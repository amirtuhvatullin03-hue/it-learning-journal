# Настройка GitHub-репозитория и плагина Obsidian Git
# Запуск:  powershell -ExecutionPolicy Bypass -File tools\setup-github.ps1
# Или из Obsidian: плагин Obsidian Git → кнопка "Open in terminal" / "Run setup"

# Windows PowerShell 5.1 превращает stderr нативных команд в terminating error при ErrorActionPreference=Stop.
# Поэтому ошибки обрабатываем по $LASTEXITCODE, а не через ErrorActionPreference.
$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"
$RepoName = "it-learning-journal"
$Description = "Открытый учебный план и журнал прогресса: путь в IT (сети, кибербез, ИИ), ресурсы, проект на лето 2027"
$Topics = @("learning-journal", "cybersecurity", "networking", "ai", "career-roadmap", "obsidian")

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$gh = "C:\Program Files\GitHub CLI\gh.exe"
if (-not (Test-Path $gh)) { $gh = (Get-Command gh -ErrorAction SilentlyContinue).Source }
if (-not $gh) { Write-Host "GitHub CLI не найден. Установи: winget install --id GitHub.cli" -ForegroundColor Red; exit 1 }

Write-Host "== 1/6 Проверка авторизации ==" -ForegroundColor Cyan
& $gh auth status 2>&1 | Out-String | Write-Host
if ($LASTEXITCODE -ne 0) {
    Write-Host "Не авторизован. Выполни: gh auth login --web" -ForegroundColor Yellow
    exit 1
}

Write-Host "== 2/6 Имя и почта для коммитов ==" -ForegroundColor Cyan
$login = (& $gh api user --jq .login).Trim()
$name = (& $gh api user --jq .name 2>$null)
if (-not $name -or $name -eq "null" -or [string]::IsNullOrWhiteSpace($name)) { $name = $login }
$id = (& $gh api user --jq .id).Trim()
# Канонический noreply-адрес GitHub: <id>+<login>@users.noreply.github.com — он связывает коммиты с профилем
$email = "$id+$login@users.noreply.github.com"
git config user.name $name
git config user.email $email
Write-Host "user.name = $name ; user.email = $email" -ForegroundColor DarkGray

Write-Host "== 3/6 Создание репозитория ==" -ForegroundColor Cyan
& $gh repo view "$login/$RepoName" --json name 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Репозиторий $login/$RepoName уже существует — пропускаю создание." -ForegroundColor DarkGray
} else {
    & $gh repo create $RepoName --public --description $Description --source . --remote origin
    if ($LASTEXITCODE -ne 0) { Write-Host "Не удалось создать репозиторий" -ForegroundColor Red; exit 1 }
    Write-Host "Создан https://github.com/$login/$RepoName" -ForegroundColor Green
}

Write-Host "== 4/6 Темы и описание ==" -ForegroundColor Cyan
& $gh repo edit "$login/$RepoName" --add-topic $Topics 2>&1 | Out-Null
& $gh repo edit "$login/$RepoName" --homepage "https://$login.github.io/$RepoName/" 2>&1 | Out-Null

Write-Host "== 5/6 Настройка плагина Obsidian Git ==" -ForegroundColor Cyan
$pluginDir = Join-Path $root ".obsidian\plugins\obsidian-git"
New-Item -ItemType Directory -Force -Path $pluginDir | Out-Null
$cfg = @{
    autoSaveInterval        = 10
    autoPushInterval        = 0
    autoPullInterval        = 0
    autoPullOnBoot          = $true
    commitMessage           = "vault: auto commit"
    commitDateFormat        = "YYYY-MM-DD HH:mm"
    commitFileSuffix        = ""
    showErrorNotice         = $true
    showCommitInfo          = $true
    syncMethod              = "merge"
    gitDir                  = ".git"
    basePath                = ""
    updateSubmodules        = $false
    pullBeforePush          = $true
    disablePush             = $false
    refreshSourceControl    = $false
    pullTags                = $false
    pullRebase              = $false
    forcePush               = $false
    switchBranch            = ""
    openFileOnInit          = $false
    displayName             = ""
    showRemoteName          = $false
    showBranch              = $false
    showStatus              = $true
} | ConvertTo-Json
[System.IO.File]::WriteAllText((Join-Path $pluginDir "data.json"), $cfg, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Записан .obsidian\plugins\obsidian-git\data.json" -ForegroundColor DarkGray

Write-Host "== 6/6 Пуш ==" -ForegroundColor Cyan
git add -A
git commit -q -m "Обновление учебного хранилища" 2>$null
git push -u origin main

Write-Host ""
Write-Host "Готово: https://github.com/$login/$RepoName" -ForegroundColor Green
Write-Host "Осталось: в Obsidian установить плагин Obsidian Git и нажать 'Pull' один раз." -ForegroundColor Green
