# ============================================================
# 秒杀压测准备脚本
# 1. 创建压测专用优惠券 + 秒杀场次（秒杀券模式，免收货地址）
# 2. Redis 预热库存
# 3. 批量注册压测账号 loadtest_001..N
# 4. 批量登录写入 tokens.csv（供 JMeter CSV Data Set 使用）
# 输出: stress-config.txt（sessionId/couponId 等压测参数摘要）
# ============================================================
param(
    [int]$UserCount = 100,                                # 压测账号数量
    [int]$Stock = 100000,                                 # 秒杀库存（够大，避免压测中售罄）
    [string]$BaseUrl = "http://localhost:8080",           # 后端地址
    [string]$RedisContainer = "votehub-redis",            # Redis docker 容器名
    [string]$MySQLUser = "root",
    [string]$MySQLPassword = "123456",
    [string]$Database = "eshops"
)
$ErrorActionPreference = "Stop"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outDir = $PSScriptRoot
$configFile = Join-Path $outDir "stress-config.txt"
$tokenFile = Join-Path $outDir "tokens.csv"

function Invoke-Sql([string]$sql) {
    # 通过 MYSQL_PWD 环境变量传密码，避免 -p 触发 stderr 警告(PS5.1 会当作异常)
    $env:MYSQL_PWD = $MySQLPassword
    mysql "-u$MySQLUser" "-D$Database" "--execute=$sql"
}

Write-Host "======== 0. 前置检查 ========" -ForegroundColor Cyan
try {
    $null = Invoke-WebRequest -Uri "$BaseUrl/api/captcha/image" -Method GET -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    Write-Host "[OK] 后端可达: $BaseUrl"
} catch {
    Write-Host "[FAIL] 后端不可达: $BaseUrl，请先启动后端服务" -ForegroundColor Red
    exit 1
}
try {
    $null = redis-cli PING
    if ($LASTEXITCODE -ne 0) { throw }
    Write-Host "[OK] Redis 容器可用: $RedisContainer"
} catch {
    Write-Host "[FAIL] Redis 容器不可用: $RedisContainer" -ForegroundColor Red
    exit 1
}

Write-Host "======== 1. 创建压测券 + 秒杀场次 ========" -ForegroundColor Cyan
# 清理旧的压测数据（幂等，可重复执行）
Invoke-Sql "DELETE uc FROM user_coupon uc JOIN coupon c ON uc.coupon_id=c.id WHERE c.name LIKE '[LOADTEST]%';"
Invoke-Sql "DELETE FROM seckill_session WHERE session_name LIKE '[LOADTEST]%';"
Invoke-Sql "DELETE FROM coupon WHERE name LIKE '[LOADTEST]%';"

$expire = (Get-Date).AddDays(1).ToString("yyyy-MM-dd HH:mm:ss")
$begin  = (Get-Date).AddHours(-1).ToString("yyyy-MM-dd HH:mm:ss")
$end    = (Get-Date).AddHours(2).ToString("yyyy-MM-dd HH:mm:ss")

# 压测专用优惠券（满减券，status=1 启用，obtain_type=0 秒杀获取）
Invoke-Sql "INSERT INTO coupon(name,type,value,min_amount,stock,limit_per_user,start_time,end_time,status,description,obtain_type) VALUES('[LOADTEST] stress coupon',0,10,0,$Stock,$UserCount,'$expire','2027-12-31 23:59:59',1,'for load test only',0);"
$couponId = (Invoke-Sql "SELECT MAX(id) AS id FROM coupon WHERE name LIKE '[LOADTEST]%';" | Select-Object -Last 1).Trim()
# 压测专用秒杀场次（type=0 秒杀券模式，status=1 进行中）
Invoke-Sql "INSERT INTO seckill_session(seckill_type,coupon_id,session_name,start_time,end_time,seckill_stock,limit_per_user,status) VALUES(0,$couponId,'[LOADTEST] stress session','$begin','$end',$Stock,1,1);"
$sessionId = (Invoke-Sql "SELECT MAX(id) AS id FROM seckill_session WHERE session_name LIKE '[LOADTEST]%';" | Select-Object -Last 1).Trim()
Write-Host "[OK] couponId=$couponId, sessionId=$sessionId, stock=$Stock"

Write-Host "======== 2. Redis 预热 ========" -ForegroundColor Cyan
# 预热库存（与 SeckillServiceImpl.STOCK_KEY 格式一致），TTL 覆盖场次时间
redis-cli SET "seckill:stock:$sessionId" "$Stock" EX 7200 | Out-Null
# 清空会话列表缓存，让下次查询重建（避免读到旧数据）
redis-cli DEL "seckill:sessions" | Out-Null
$check = redis-cli GET "seckill:stock:$sessionId"
Write-Host "[OK] Redis 库存预热完成: seckill:stock:$sessionId = $check"

Write-Host "======== 3. 批量注册压测账号 ($UserCount 个) ========" -ForegroundColor Cyan
$pass = "LoadTest2026"
$registered = 0
for ($i = 1; $i -le $UserCount; $i++) {
    $name = "loadtest_{0:D4}" -f $i
    $body = @{ username = $name; password = $pass; email = "$name@test.local" } | ConvertTo-Json -Compress
    try {
        $resp = Invoke-RestMethod -Uri "$BaseUrl/api/user/register" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
        if ($resp.code -eq 200) { $registered++ }
    } catch {
        # 重复注册等业务异常视为成功，继续下一个
    }
}
Write-Host "[OK] 新注册 $registered 个（已存在的自动跳过）"

Write-Host "======== 4. 批量登录 -> tokens.csv ========" -ForegroundColor Cyan
"username,password,token" | Out-File $tokenFile -Encoding ascii
$failed = 0
for ($i = 1; $i -le $UserCount; $i++) {
    $name = "loadtest_{0:D4}" -f $i
    # 直接向 Redis 写入已知验证码，绕过图形验证码（仅压测环境）
    $null = redis-cli SET "captcha:stress_$i" "8888" EX 300
    $body = @{ username = $name; password = $pass; captchaKey = "stress_$i"; captchaCode = "8888" } | ConvertTo-Json -Compress
    try {
        $resp = Invoke-RestMethod -Uri "$BaseUrl/api/user/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
        if ($resp.code -ne 200 -or -not $resp.data.token) { throw $resp.msg }
        "$name,$pass,$($resp.data.token)" | Out-File $tokenFile -Append -Encoding ascii
    } catch {
        $failed++
        Write-Host "  [WARN] $name 登录失败: $_" -ForegroundColor Yellow
    }
}
Write-Host "[OK] 登录成功 $($UserCount - $failed) 个, 失败 $failed 个 -> tokens.csv"

Write-Host "======== 5. 输出压测参数 ========" -ForegroundColor Cyan
@"
# 压测配置摘要 ($stamp)
sessionId=$sessionId
couponId=$couponId
stock=$Stock
userCount=$UserCount
tokenFile=tokens.csv
seckillUrl=$BaseUrl/api/seckill/$sessionId
# JMeter 运行示例:
#   jmeter -n -t seckill-test.jmx -l result.jtl -e -o report
"@ | Out-File $configFile -Encoding utf8
Get-Content $configFile
Write-Host "`n全部就绪。压测前如需重复执行请先运行 reset-stress-test.ps1" -ForegroundColor Green
