# 每日同步脚本（Windows）
# 手动同步:   powershell -ExecutionPolicy Bypass -File .\sync.ps1
# 注册每天 09:00 自动同步:  powershell -ExecutionPolicy Bypass -File .\sync.ps1 -SetupTask
# 取消自动同步:  Unregister-ScheduledTask -TaskName "SkillsList-DailySync" -Confirm:$false

param([switch]$SetupTask)

$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$log  = Join-Path $repo "sync.log"

function Sync {
    "===== $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') =====" | Add-Content $log
    git -C $repo pull --ff-only 2>&1 | Add-Content $log
    npx skills update -g 2>&1 | Add-Content $log
    "" | Add-Content $log
}

if ($SetupTask) {
    $action  = New-ScheduledTaskAction -Execute "powershell.exe" `
                 -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$repo\sync.ps1`""
    $trigger = New-ScheduledTaskTrigger -Daily -At 09:00
    Register-ScheduledTask -TaskName "SkillsList-DailySync" `
        -Action $action -Trigger $trigger -Description "每天拉取 skillsList 最新清单并更新已装技能" -Force | Out-Null
    Write-Host "[OK] 已注册每日 09:00 自动同步任务 (SkillsList-DailySync)" -ForegroundColor Green
} else {
    Write-Host "==> 拉取最新清单 + 更新已安装技能..."
    Sync
    Write-Host "[OK] 同步完成，详情见 sync.log" -ForegroundColor Green
}
