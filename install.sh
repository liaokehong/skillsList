#!/usr/bin/env bash
# Claude Code Skills 一键安装脚本（macOS / Linux / Git Bash）
# 用法: bash install.sh
# 已安装的项会自动跳过/覆盖，可重复执行。

set -u
step() { printf "\n==> %s\n" "$1"; }
ok()   { printf "    [OK] %s\n" "$1"; }
warn() { printf "    [!!] %s\n" "$1"; }

# ---------- 0. 前置依赖 ----------
step "检查前置依赖 (git / node / npm)"
for cmd in git node npm; do
    if command -v "$cmd" >/dev/null 2>&1; then ok "$cmd"; else warn "缺少 $cmd — 请先安装"; fi
done

# ---------- 1. npm 全局工具 ----------
step "安装 npm 全局工具: OpenSpec + Task Master"
npm install -g @fission-ai/openspec task-master-ai \
    && ok "openspec / task-master 已安装" \
    || warn "失败，请手动执行: npm i -g @fission-ai/openspec task-master-ai"

# ---------- 2. skills.sh 生态技能（必须逐个安装，批量 -s 语法不生效） ----------
step "安装 skills.sh 生态技能 (npx skills add)"
skills=(
    # 基础四件套
    "anthropics/skills@frontend-design"
    "vercel-labs/skills@find-skills"
    "vercel-labs/agent-browser@agent-browser"
    "zhaono1/agent-playbook@self-improving-agent"
    # 交互设计包
    "nextlevelbuilder/ui-ux-pro-max-skill@ui-ux-pro-max"
    "owl-listener/designer-skills@user-flow-diagram"
    "owl-listener/designer-skills@navigation-patterns"
    "owl-listener/designer-skills@state-machine"
    "owl-listener/designer-skills@form-design"
    "owl-listener/designer-skills@loading-states"
    "owl-listener/designer-skills@error-handling-ux"
    "owl-listener/designer-skills@heuristic-evaluation"
    # 动效
    "emilkowalski/skills@improve-animations"
    "emilkowalski/skills@animate"
)
total=${#skills[@]}
i=0
for s in "${skills[@]}"; do
    i=$((i + 1))
    printf "  (%d/%d) %s\n" "$i" "$total" "$s"
    if npx skills add "$s" -g -y; then ok "$s"; else warn "$s 安装失败"; fi
done

# ---------- 3. Claude 插件市场（有 claude CLI 才执行） ----------
if command -v claude >/dev/null 2>&1; then
    step "安装 Claude 插件: Superpowers / Remember"
    claude plugin install superpowers@claude-plugins-official || warn "superpowers 安装失败"
    claude plugin install remember@claude-plugins-official || warn "remember 安装失败"
else
    step "未检测到 claude CLI，跳过 marketplace 插件"
    warn "Superpowers / Remember 请在编辑器插件面板搜索安装"
fi

# Firecrawl：请用编辑器插件面板安装 firecrawl 插件，或参考 SKILLS_GUIDE.md 第 4 节
# 自研技能 (product-design / clarify-first)：把 SKILL.md 目录拷到 ~/.agents/skills/ 即可

step "全部完成！重启编辑器后生效。完整说明见 SKILLS_GUIDE.md"
