# ============================================================
# 秒杀压测重置脚本（每次压测前执行，恢复初始状态）
# 1. 重置 DB 场次库存
# 2. 清空压测发放的优惠券
# 3. 重置 Redis：库存预扣 / 已抢用户 / 限流计数
# 用法: .\reset-stress-test.ps1                # 自动读取 stress-config.txt
#       .\reset-stress-test.ps1 -SessionId 19 -CouponId 5 -Stock 100000
# ============================================================
param(
    [string]$SessionId = "",
    [string]$CouponId = "",
    [int]$Stock = 100000,
    [string]$RedisContainer = "votehub-redis",
    [string]$MySQLUser = "root",
    [string]$MySQLPassword = "123456",
    [string]$Database = "eshops"
)
$ErrorActionPreference = "Stop"
$configFile = Join-Path $PSScriptRoot "stress-config.txt"

# 未传参时从 prepare 脚本输出的配置文件读取
if (-not $SessionId -and (Test-Path $configFile)) {
    foreach ($line in Get-Content $configFile) {
        if ($line -match "^sessionId=(\d+)$") { $SessionId = $Matches[1] }
        if ($line -match "^couponId=(\d+)$")  { $CouponId = $Matches[1] }
        if ($line -match "^stock=(\d+)$")     { $Stock = [int]$Matches[1] }
    }
}
if (-not $SessionId) { Write-Host "缺少 sessionId，请先运行 prepare-stress-test.ps1" -ForegroundColor Red; exit 1 }

function Invoke-Sql([string]$sql) {
        $env:MYSQL_PWD = $MySQLPassword
    mysql "-u$MySQLUser" "-D$Database" "--execute=$sql"
}

Write-Host "======== 重置压测数据 (sessionId=$SessionId) ========" -ForegroundColor Cyan

# 1. DB 库存复位 + 清理压测发放的券
Invoke-Sql "UPDATE seckill_session SET seckill_stock=$Stock WHERE id=$SessionId;"
if ($CouponId) {
    Invoke-Sql "DELETE uc FROM user_coupon uc WHERE uc.coupon_id=$CouponId;"
}
Write-Host "[OK] DB: 场次库存已复位为 $Stock，压测发放的优惠券已清空"

# 2. Redis 复位：库存 / 已抢用户集合 / 全部限流计数
redis-cli SET "seckill:stock:$SessionId" "$Stock" EX 7200 | Out-Null
redis-cli DEL "seckill:users:$SessionId" | Out-Null
$rateKeys = redis-cli KEYS "seckill:rate:*"
if ($rateKeys) { $rateKeys | ForEach-Object { redis-cli DEL $_ | Out-Null } }
$check = redis-cli GET "seckill:stock:$SessionId"
Write-Host "[OK] Redis: 库存=$check, 已抢集合已清空, 限流计数已清空"
Write-Host "可以开始压测: jmeter -n -t seckill-test.jmx -l result.jtl -e -o report" -ForegroundColor Green
