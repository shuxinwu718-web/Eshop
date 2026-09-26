# 加载 .env.local 密钥后启动后端（支付宝沙箱模式）
# 用法：在 e-shop 目录执行  .\start-backend-alipay.ps1
# 密钥以 -D 系统属性传给应用 JVM（优先级高于环境变量，避免 mvn fork 丢失 env）
$envFile = Join-Path $PSScriptRoot ".env.local"
if (-not (Test-Path $envFile)) {
    Write-Error "找不到 $envFile"
    exit 1
}
$props = @{}
Get-Content $envFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -and -not $line.StartsWith("#")) {
        $idx = $line.IndexOf("=")
        if ($idx -gt 0) {
            $props[$line.Substring(0, $idx).Trim()] = $line.Substring($idx + 1).Trim()
        }
    }
}
if ($props["ALIPAY_APP_ID"] -match "TODO") {
    Write-Error ".env.local 中 ALIPAY_APP_ID 还是占位符，请先填入沙箱 APPID"
    exit 1
}
Write-Host "支付宝沙箱参数已加载: APPID=$($props['ALIPAY_APP_ID'])" -ForegroundColor Green

# 组装 -D 参数（空值跳过，yml 里用默认值）
$sysProps = @()
foreach ($k in $props.Keys) {
    if ($props[$k] -ne "") {
        $sysProps += "-D$k=$($props[$k])"
    }
}
$jvmArgs = $sysProps -join " "
mvn spring-boot:run "-Dspring-boot.run.jvmArguments=$jvmArgs"
