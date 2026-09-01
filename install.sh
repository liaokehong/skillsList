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
step "安装 npm 全局工具: OpenSpec"
npm install -g @fission-ai/openspec \
    && ok "openspec 已安装" \
    || warn "失败，请手动执行: npm i -g @fission-ai/openspec"

# ---------- 2. skills.sh 生态技能（必须逐个安装，批量 -s 语法不生效） ----------
step "安装 skills.sh 生态技能 (npx skills add)"
skills=(
    # 交互 / 视觉设计角色
    "anthropics/skills@frontend-design"
    "nextlevelbuilder/ui-ux-pro-max-skill@ui-ux-pro-max"
    "owl-listener/designer-skills@user-flow-diagram"
    "owl-listener/designer-skills@navigation-patterns"
    "owl-listener/designer-skills@state-machine"
    "owl-listener/designer-skills@form-design"
    "owl-listener/designer-skills@loading-states"
    "owl-listener/designer-skills@error-handling-ux"
    "owl-listener/designer-skills@heuristic-evaluation"
    "emilkowalski/skills@improve-animations"
    "emilkowalski/skills@animate"
    # 开发落地角色
    "vercel-labs/agent-browser@agent-browser"
    # 调研 / 信息角色
    "vercel-labs/skills@find-skills"
    # 通用沉淀
    "zhaono1/agent-playbook@self-improving-agent"
)
total=${#skills[@]}
i=0
for s in "${skills[@]}"; do
    i=$((i + 1))
    printf "  (%d/%d) %s\n" "$i" "$total" "$s"
    if npx skills add "$s" -g -y; then ok "$s"; else warn "$s 安装失败"; fi
done

# ---------- 3. 自研技能（随仓库分发，拷贝到技能目录） ----------
step "安装自研技能: product-design / clarify-first"
dest="$HOME/.agents/skills"
mkdir -p "$dest"
for name in product-design clarify-first; do
    if [ -d "$name" ] || [ -d "skills/$name" ]; then
        src="skills/$name"; [ -d "$src" ] || src="$name"
        rm -rf "$dest/$name"
        cp -r "$src" "$dest/$name"
        ok "$name -> ~/.agents/skills/$name"
    else
        warn "仓库内找不到 skills/$name"
    fi
done

# ---------- 4. Firecrawl（插件市场安装） ----------
step "Firecrawl"
warn "请用编辑器插件面板搜索安装 firecrawl 插件（详见 SKILLS_GUIDE.md 第四节）"

step "全部完成！重启编辑器后生效。完整说明见 SKILLS_GUIDE.md"
