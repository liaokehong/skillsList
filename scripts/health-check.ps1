param(
    [string]$OutputPath = "$PSScriptRoot\..\state.local.json",
    [string]$TemplatePath = "$PSScriptRoot\..\state.template.json"
)

$ErrorActionPreference = "SilentlyContinue"

function Get-CommandVersion {
    param([string]$Cmd, [string]$Arg = "--version")
    try {
        $v = & $Cmd $Arg 2>$null | Select-Object -First 1
        if ($v) { return $v.ToString().Trim() } else { return $null }
    } catch { return $null }
}

function Find-Executable {
    param([string]$Path)
    if (Test-Path $Path) { return (Resolve-Path $Path).Path } else { return $null }
}

function Get-AIClient {
    param([string]$ExePath, [string]$ConfigDir, [string]$SkillsRel)
    $obj = [ordered]@{
        installed   = $false
        version     = $null
        exe_path    = $null
        config_dir  = $null
        skills_path = $null
        skill_count = $null
    }
    if ($ExePath -and (Test-Path $ExePath)) {
        $obj.installed  = $true
        $obj.version    = (Get-Item $ExePath).VersionInfo.FileVersion
        $obj.exe_path   = (Resolve-Path $ExePath).Path
    }
    if ($ConfigDir -and (Test-Path $ConfigDir)) {
        $obj.config_dir = (Resolve-Path $ConfigDir).Path
    }
    $skillsRoot = Join-Path $env:USERPROFILE $SkillsRel
    if (Test-Path $skillsRoot) {
        $obj.skills_path = (Resolve-Path $skillsRoot).Path
        $obj.skill_count = (Get-ChildItem $skillsRoot -Directory -Force | Measure-Object).Count
    }
    return [pscustomobject]$obj
}

function Get-SoftwareEntry {
    param([string]$ExePath, [string]$ModelDir = $null)
    $obj = [ordered]@{
        installed = $false
        version   = $null
        exe_path  = $null
    }
    if ($ExePath -and (Test-Path $ExePath)) {
        $obj.installed = $true
        $obj.exe_path  = (Resolve-Path $ExePath).Path
        try { $obj.version = (Get-Item $ExePath).VersionInfo.FileVersion } catch {}
    }
    if ($ModelDir) {
        $obj | Add-Member -NotePropertyName "model_dir" -NotePropertyValue $ModelDir
    }
    return [pscustomobject]$obj
}

Write-Host "=== skillsList Health Check ==="
Write-Host ("Started: " + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))

if (-not (Test-Path $TemplatePath)) {
    Write-Error "Template not found: $TemplatePath"
    exit 1
}
$templateJson = [System.IO.File]::ReadAllText($TemplatePath, [System.Text.UTF8Encoding]::new($false))
$result = $templateJson | ConvertFrom-Json

# Override generated metadata
$result.generated_at = (Get-Date).ToString("yyyy-MM-ddTHH:mm:sszzz")
$result.machine_id   = "$env:COMPUTERNAME-$env:USERNAME"

$ci = Get-ComputerInfo
$result.os = [pscustomobject]@{
    name    = $ci.WindowsProductName
    version = $ci.WindowsVersion
    arch    = $env:PROCESSOR_ARCHITECTURE
}

$disks = @()
foreach ($letter in @('C', 'D')) {
    $d = Get-PSDrive $letter -ErrorAction SilentlyContinue
    if ($d) {
        $disks += [pscustomobject]@{
            letter   = $letter
            total_gb = [math]::Round(($d.Used + $d.Free) / 1GB, 1)
            used_gb  = [math]::Round($d.Used / 1GB, 1)
            free_gb  = [math]::Round($d.Free / 1GB, 1)
            role     = if ($letter -eq 'C') { 'system' } else { 'data' }
        }
    }
}
$result.disks = $disks

$result.base_toolkit.git    = [pscustomobject]@{ required=$true;  installed=($null -ne (Get-CommandVersion 'git'));    version=(Get-CommandVersion 'git');    exe_path=(Find-Executable "D:\001_Software\Git\cmd\git.exe");    cache_dir=$null }
$result.base_toolkit.node   = [pscustomobject]@{ required=$true;  installed=($null -ne (Get-CommandVersion 'node'));   version=(Get-CommandVersion 'node');   exe_path=(Find-Executable "D:\001_Software\node\node.exe");   cache_dir=$null }
$result.base_toolkit.npm    = [pscustomobject]@{ required=$true;  installed=($null -ne (Get-CommandVersion 'npm'));    version=(Get-CommandVersion 'npm');    exe_path=(Find-Executable "D:\001_Software\node\npm.cmd");    cache_dir=$([Environment]::GetEnvironmentVariable('npm_config_cache', 'User')); global_prefix=$([Environment]::GetEnvironmentVariable('npm_config_prefix', 'User')) }
$result.base_toolkit.python = [pscustomobject]@{ required=$true;  installed=($null -ne (Get-CommandVersion 'python')); version=(Get-CommandVersion 'python'); exe_path=(Find-Executable "D:\001_Software\miniforge\python.exe"); cache_dir=$([Environment]::GetEnvironmentVariable('PIP_CACHE_DIR', 'User')) }
$result.base_toolkit.uv     = [pscustomobject]@{ required=$true;  installed=($null -ne (Get-CommandVersion 'uv'));     version=(Get-CommandVersion 'uv');     exe_path=(Find-Executable "D:\001_Software\bin\uv.exe");     cache_dir=$([Environment]::GetEnvironmentVariable('UV_CACHE_DIR', 'User')); python_install_dir=$([Environment]::GetEnvironmentVariable('UV_PYTHON_INSTALL_DIR', 'User')); tool_dir=$([Environment]::GetEnvironmentVariable('UV_TOOL_DIR', 'User')); tool_bin_dir=$([Environment]::GetEnvironmentVariable('UV_TOOL_BIN_DIR', 'User')) }
$result.base_toolkit.docker = [pscustomobject]@{ required=$false; installed=($null -ne (Get-CommandVersion 'docker'));  version=(Get-CommandVersion 'docker');  exe_path=(Find-Executable "C:\Program Files\Docker\Docker\Docker.exe"); cache_dir=$null }

$result.ai_clients.Cursor = Get-AIClient -ExePath 'D:\001_Software\010_cursor\cursor\Cursor.exe' -ConfigDir 'C:\Users\Dell\.cursor' -SkillsRel '.cursor\skills'
$result.ai_clients.ZCode  = Get-AIClient -ExePath 'D:\001_Software\008_zcode\ZCode.exe'   -ConfigDir 'C:\Users\Dell\.zcode'  -SkillsRel '.zcode\skills'
# Codex: installed via Windows Store (Appx) on Windows, no traditional exe path.
# Detection: look for Appx package named "OpenAI Codex" or "Codex".
$codexExe = $null
try {
    $codexPkg = Get-AppxPackage -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*Codex*" -or $_.Name -like "*OpenAI*" } | Select-Object -First 1
    if ($codexPkg -and $codexPkg.InstallLocation -and (Test-Path $codexPkg.InstallLocation)) {
        $codexExe = (Get-ChildItem -Path $codexPkg.InstallLocation -Filter "*.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
    }
} catch {}
$result.ai_clients.Codex = Get-AIClient -ExePath $codexExe -ConfigDir 'C:\Users\Dell\.codex' -SkillsRel '.codex\skills'

$result.software.lm_studio   = Get-SoftwareEntry -ExePath 'D:\001_Software\004_LM-Studio\LM Studio\LM Studio.exe' -ModelDir 'D:\001_Software\_models\lm-studio'
$result.software.ollama      = Get-SoftwareEntry -ExePath 'D:\001_Software\_models\ollama\ollama.exe' -ModelDir 'D:\001_Software\_models\ollama'
$result.software.pycharm     = Get-SoftwareEntry -ExePath 'D:\001_Software\005_PyCharm\bin\pycharm64.exe'
$result.software.vscode      = Get-SoftwareEntry -ExePath 'D:\001_Software\006_VSCode\Code.exe'
$result.software.firecrawl_plugin = [pscustomobject]@{ installed=$null; required=$false; note='must install via AI client marketplace' }
$result.software.ffmpeg      = Get-SoftwareEntry -ExePath 'D:\001_Software\ffmpeg-2026-07-13-git-9c2aabaa34-essentials_build\bin\ffmpeg.exe'
$result.software.powertoys   = Get-SoftwareEntry -ExePath 'D:\001_Software\009_powerToys\PowerToys.exe'

$result.paths = [pscustomobject]@{
    software_root      = if (Test-Path 'D:\001_Software') { 'D:\001_Software' } else { $null }
    downloads_dir      = if (Test-Path 'D:\001_Software\_downloads') { 'D:\001_Software\_downloads' } else { $null }
    cache_root         = if (Test-Path 'D:\001_Software\_caches') { 'D:\001_Software\_caches' } else { $null }
    models_root        = if (Test-Path 'D:\001_Software\_models') { 'D:\001_Software\_models' } else { $null }
    bin_dir            = if (Test-Path 'D:\001_Software\bin') { 'D:\001_Software\bin' } else { $null }
    follows_convention = $null
}

$envKeys = @('UV_CACHE_DIR','UV_PYTHON_INSTALL_DIR','UV_TOOL_DIR','UV_TOOL_BIN_DIR',
             'PIP_CACHE_DIR','npm_config_cache','npm_config_prefix',
             'CARGO_HOME','RUSTUP_HOME','GOPATH','GOMODCACHE','GRADLE_USER_HOME',
             'HF_HOME','MODELSCOPE_CACHE','TORCH_HOME','OLLAMA_MODELS')
foreach ($k in $envKeys) {
    $expected = $result.env_vars.$k.expected
    $actual = [Environment]::GetEnvironmentVariable($k, 'User')
    $ok = $false
    if ($actual -and $expected) {
        $ok = $actual.EndsWith($expected, [System.StringComparison]::OrdinalIgnoreCase)
    }
    $result.env_vars.$k.actual = $actual
    $result.env_vars.$k.ok     = $ok
}

$githubOk = $false
try {
    $resp = Invoke-WebRequest -Uri 'https://github.com' -UseBasicParsing -TimeoutSec 5 -Method Head
    $githubOk = ($resp.StatusCode -eq 200)
} catch {}
$npmOk = $false
try {
    $resp = Invoke-WebRequest -Uri 'https://registry.npmjs.org' -UseBasicParsing -TimeoutSec 5 -Method Head
    $npmOk = ($resp.StatusCode -eq 200)
} catch {}
$result.network = [pscustomobject]@{
    github_accessible         = $githubOk
    npm_registry_accessible   = $npmOk
    mirror_configured         = $false
    mirrors                   = [pscustomobject]@{
        pip         = [Environment]::GetEnvironmentVariable('PIP_INDEX_URL', 'User')
        npm         = (& npm config get registry 2>$null)
        huggingface = [Environment]::GetEnvironmentVariable('HF_ENDPOINT', 'User')
    }
}

$repo = [pscustomobject]@{
    local_clone_path = $null
    branch           = $null
    ahead_of_origin  = $null
    behind_of_origin = $null
    clean            = $null
}
$localClone = "D:\001_Software\skillsList"
if (Test-Path $localClone) {
    $repo.local_clone_path = (Resolve-Path $localClone).Path
    $curLoc = Get-Location
    try {
        Set-Location $localClone
        $repo.branch = git branch --show-current 2>$null
        $repo.clean  = ((git status --porcelain 2>$null) | Measure-Object).Count -eq 0
        if ($repo.branch) {
            $upstreamBranch = $repo.branch
            $repo.ahead_of_origin  = git rev-list --count ("origin/" + $upstreamBranch + "..HEAD") 2>$null
            $repo.behind_of_origin = git rev-list --count ("HEAD..origin/" + $upstreamBranch) 2>$null
        }
    } finally {
        Set-Location $curLoc
    }
}
$result.repo = $repo

function Update-SkillSync {
    param($SkillsObj, $Clients, $SelfRoot = $null)
    foreach ($name in $SkillsObj.PSObject.Properties.Name) {
        $entry = $SkillsObj.$name
        $syncedTo = @()
        foreach ($c in $Clients.PSObject.Properties.Name) {
            $client = $Clients.$c
            if (-not $client.installed) { continue }
            if (-not $client.skills_path) { continue }
            $candidates = @()
            if ($SelfRoot) {
                $candidates += Join-Path (Join-Path $SelfRoot $name) 'SKILL.md'
            }
            $candidates += Join-Path (Join-Path $client.skills_path $name) 'SKILL.md'
            foreach ($p in $candidates) {
                if (Test-Path $p) { $syncedTo += $c; break }
            }
        }
        $entry.synced_to = $syncedTo
    }
}
$selfRoot = if ($repo.local_clone_path) { Join-Path $repo.local_clone_path 'skills' } else { $null }
Update-SkillSync -SkillsObj $result.skills.self_skills -Clients $result.ai_clients -SelfRoot $selfRoot
Update-SkillSync -SkillsObj $result.skills.remote_skills -Clients $result.ai_clients -SelfRoot $null

$result.global_tools.openspec = [pscustomobject]@{
    installed = $null -ne (Get-Command openspec -ErrorAction SilentlyContinue)
    version   = Get-CommandVersion 'openspec'
    source    = 'npm i -g @fission-ai/openspec'
    exe_path  = Find-Executable "D:\001_Software\npm-global\openspec.cmd"
}

$issues = @()
foreach ($k in $envKeys) {
    if ($result.env_vars.$k.ok -eq $false) {
        $issues += [pscustomobject]@{ level='env'; kind='env'; target=$k; detail=("expected suffix '" + $result.env_vars.$k.expected + "', got '" + $result.env_vars.$k.actual + "'") }
    }
}
foreach ($tool in 'git','node','npm','python','uv') {
    $t = $result.base_toolkit.$tool
    if ($t.required -and -not $t.installed) {
        $issues += [pscustomobject]@{ level='missing'; kind='missing'; target=$tool; detail='required base toolkit not installed' }
    }
}
foreach ($c in 'Cursor','ZCode','Codex') {
    $cl = $result.ai_clients.$c
    if ($cl.installed -and -not $cl.skills_path) {
        $issues += [pscustomobject]@{ level='path'; kind='path'; target=$c; detail='installed but skills_path missing' }
    }
}
foreach ($name in $result.skills.self_skills.PSObject.Properties.Name) {
    $s = $result.skills.self_skills.$name
    foreach ($c in 'Cursor','ZCode','Codex') {
        $cl = $result.ai_clients.$c
        if ($cl.installed -and ($s.synced_to -notcontains $c)) {
            $issues += [pscustomobject]@{ level='sync'; kind='sync'; target=($name + '@' + $c); detail='self skill not synced to installed client' }
        }
    }
}
$result.issues = $issues

$json = $result | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($OutputPath, $json, [System.Text.UTF8Encoding]::new($false))

Write-Host ""
Write-Host ("Result written: " + $OutputPath)
Write-Host ("Issues found: " + $issues.Count)
foreach ($i in $issues) {
    Write-Host ("  [" + $i.level + "] " + $i.kind + ": " + $i.target + " - " + $i.detail)
}

Write-Host ""
Write-Host "=== Done ==="
