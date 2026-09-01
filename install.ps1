# Claude Code Skills 一键安装脚本（Windows）
# 用法: 在仓库目录下右键"使用 PowerShell 运行"，或:
#   powershell -ExecutionPolicy Bypass -File .\install.ps1
# 已安装的项会自动跳过/覆盖，可重复执行。

$ErrorActionPreference = "Continue"

function Step($m) { Write-Host "`n==> $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "    [OK] $m" -ForegroundColor Green }
function Warn($m) { Write-Host "    [!!] $m" -ForegroundColor Yellow }

# ---------- 0. 前置依赖 ----------
Step "检查前置依赖 (git / node / npm)"
foreach ($cmd in @("git", "node", "npm")) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) { Ok "$cmd" }
    else { Warn "缺少 $cmd — 请先安装 (node: https://nodejs.org , git: https://git-scm.com)" }
}

# ---------- 1. npm 全局工具 ----------
Step "安装 npm 全局工具: OpenSpec"
npm install -g @fission-ai/openspec
if ($LASTEXITCODE -eq 0) { Ok "openspec 已安装" } else { Warn "失败，请手动执行: npm i -g @fission-ai/openspec" }

# ---------- 2. skills.sh 生态技能（必须逐个安装，批量 -s 语法不生效） ----------
Step "安装 skills.sh 生态技能 (npx skills add)"
$skills = @(
    # 交互 / 视觉设计角色
    "anthropics/skills@frontend-design",
    "nextlevelbuilder/ui-ux-pro-max-skill@ui-ux-pro-max",
    "owl-listener/designer-skills@user-flow-diagram",
    "owl-listener/designer-skills@navigation-patterns",
    "owl-listener/designer-skills@state-machine",
    "owl-listener/designer-skills@form-design",
    "owl-listener/designer-skills@loading-states",
    "owl-listener/designer-skills@error-handling-ux",
    "owl-listener/designer-skills@heuristic-evaluation",
    "emilkowalski/skills@improve-animations",
    "emilkowalski/skills@animate",
    # 开发落地角色
    "vercel-labs/agent-browser@agent-browser",
    # 调研 / 信息角色
    "vercel-labs/skills@find-skills",
    # 通用沉淀
    "zhaono1/agent-playbook@self-improving-agent"
)
$i = 0
foreach ($s in $skills) {
    $i++
    Write-Host "  ($i/$($skills.Count)) $s"
    npx skills add $s -g -y
    if ($LASTEXITCODE -eq 0) { Ok $s } else { Warn "$s 安装失败" }
}

# ---------- 3. 自研技能（随仓库分发，拷贝到技能目录） ----------
Step "安装自研技能: product-design / clarify-first"
$dest = Join-Path $HOME ".agents\skills"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
foreach ($name in @("product-design", "clarify-first")) {
    $src = Join-Path $PSScriptRoot "skills\$name"
    if (Test-Path $src) {
        Copy-Item $src (Join-Path $dest $name) -Recurse -Force
        Ok "$name -> ~/.agents/skills/$name"
    } else {
        Warn "仓库内找不到 skills/$name"
    }
}

# ---------- 4. Firecrawl（插件市场安装） ----------
Step "Firecrawl"
Warn "请用编辑器插件面板搜索安装 firecrawl 插件（详见 SKILLS_GUIDE.md 第四节）"

Step "全部完成！重启编辑器后生效。完整说明见 SKILLS_GUIDE.md"
