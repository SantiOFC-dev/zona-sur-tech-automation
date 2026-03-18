$root = Get-Location
$apps = @(
    @{name='cms'; path='cms\\CMS'; domain='cms.zonasurtech.online'; repo='https://github.com/Santyofc/CMS-server.git'},
    @{name='saas'; path='saas\\SaaS-Zona_Sur_Tech'; domain='zonasurtech.online'; repo='https://github.com/Santyofc/SaaS-Zona_Sur_Tech.git'},
    @{name='facturas'; path='facturas'; domain='facturas.zonasurtech.online'; repo='https://github.com/Santyofc/fac-zona-sur-main.git'}
)

$lines = @()
$lines += "Deploy checklist for Zona-Sur-Tech"
$lines += "Generated: $(Get-Date)"
$lines += ""

foreach ($app in $apps) {
    $p = Join-Path $root $app.path
    if (Test-Path $p) {
        Write-Host "--- [$($app.name)] $p ---" -ForegroundColor Green
        Push-Location $p
        git status
        git remote -v
        git pull
        Pop-Location
        $lines += "App: $($app.name)"
        $lines += "Path: $p"
        $lines += "Domain: $($app.domain)"
        $lines += "Repo: $($app.repo)"
        $lines += "Status: OK"
        $lines += ""
    } else {
        Write-Host "MISSING: $p" -ForegroundColor Yellow
        $lines += "App: $($app.name) - MISSING PATH"
        $lines += "Path: $p"
        $lines += ""
    }
}

$lines += "--- DNS/Env checklist ---"
$lines += "SpaceMail: A/CNAME set to AWS endpoints"
$lines += "Neon/Supabase env secrets configured"
$lines += "HTTPS cert valid"

$lines | Out-File -FilePath "$root\\deploy-checklist.txt" -Encoding utf8
Write-Host "Saved deploy checklist to deploy-checklist.txt" -ForegroundColor Cyan
