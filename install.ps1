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
Step "安装 npm 全局工具: OpenSpec + Task Master"
npm install -g @fission-ai/openspec task-master-ai
if ($LASTEXITCODE -eq 0) { Ok "openspec / task-master 已安装" } else { Warn "npm 全局安装失败，请手动执行: npm i -g @fission-ai/openspec task-master-ai" }

# ---------- 2. skills.sh 生态技能（必须逐个安装，批量 -s 语法不生效） ----------
Step "安装 skills.sh 生态技能 (npx skills add)"
$skills = @(
    # 基础四件套
    "anthropics/skills@frontend-design",
    "vercel-labs/skills@find-skills",
    "vercel-labs/agent-browser@agent-browser",
    "zhaono1/agent-playbook@self-improving-agent",
    # 交互设计包
    "nextlevelbuilder/ui-ux-pro-max-skill@ui-ux-pro-max",
    "owl-listener/designer-skills@user-flow-diagram",
    "owl-listener/designer-skills@navigation-patterns",
    "owl-listener/designer-skills@state-machine",
    "owl-listener/designer-skills@form-design",
    "owl-listener/designer-skills@loading-states",
    "owl-listener/designer-skills@error-handling-ux",
    "owl-listener/designer-skills@heuristic-evaluation",
    # 动效
    "emilkowalski/skills@improve-animations",
    "emilkowalski/skills@animate"
)
$i = 0
foreach ($s in $skills) {
    $i++
    Write-Host "  ($i/$($skills.Count)) $s"
    npx skills add $s -g -y
    if ($LASTEXITCODE -eq 0) { Ok $s } else { Warn "$s 安装失败" }
}

# ---------- 3. Claude 插件市场（有 claude CLI 才执行） ----------
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Step "安装 Claude 插件: Superpowers / Remember"
    claude plugin install superpowers@claude-plugins-official
    claude plugin install remember@claude-plugins-official
} else {
    Step "未检测到 claude CLI，跳过 marketplace 插件"
    Warn "Superpowers / Remember 请在编辑器插件面板搜索安装，或安装 claude CLI 后重跑本脚本"
}

# Firecrawl：请用编辑器插件面板安装 firecrawl 插件，或参考 SKILLS_GUIDE.md 第 4 节
# 自研技能 (product-design / clarify-first)：把 SKILL.md 目录拷到 ~/.agents/skills/ 即可

Step "全部完成！重启编辑器后生效。完整说明见 SKILLS_GUIDE.md"
