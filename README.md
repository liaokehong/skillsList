# Claude Code Skills 个人使用清单

> 我的工作：企业内部数字化建设——需求与 PRD、交互与 UI 规范、内部工具、算力服务器管理、AI 辅助开发。
> 本清单按「**角色 → 工作流**」组织。仓库内置 [AGENTS.md](./AGENTS.md) 指令，**把仓库地址发给任何 AI 编码助手，它就能自动完成安装和同步**——不需要跑任何脚本。

## 💬 怎么用（vibe coding 方式）

把下面的话直接发给你的 AI 编码助手（Claude Code / ZCode / Cursor…）：

```text
帮我按照 https://github.com/liaokehong/skillsList 安装技能清单
```

```text
按 skillsList 同步更新我的技能
```

```text
每天早上 9 点帮我同步 skillsList
```

助手会读取仓库里的 AGENTS.md 指令自主执行：装 OpenSpec、逐个装 14 个 skills.sh 生态技能、部署自研技能、注册每日同步（用助手自身的定时任务能力，无脚本）。

## 🧭 设备角色

- **主端（重度使用端）**：日常重度使用 + **信息上传**——清单修改、新技能沉淀在主端完成并推送到 GitHub。
- **其他设备**：纯**消费**——发安装 / 同步口令即可，不需要改仓库。
- GitHub 仓库是**唯一事实源**：任何端产生的变更都回传仓库，其他端一次同步即得。

## 角色总览

| 角色 | 技能 | 干什么 |
|------|------|--------|
| 🧭 产品 / 需求 | `clarify-first` → `product-design`（自研） | 模糊想法对齐 → 产出多角色 PRD |
| 🎨 交互 / 视觉设计 | owl-listener 七件 + `ui-ux-pro-max` + `frontend-design` + 动效两件 | 交互规格 → 视觉实现 → 交付自审 → 动效打磨 |
| 🛠 开发落地 | `openspec` + `agent-browser` | 规范驱动 AI 实现 → 浏览器自动化自测 |
| 🔍 调研 / 信息 | Firecrawl（30+ 子技能）+ `find-skills` | 网页调研、深度报告、发现新技能 |
| 🧠 通用沉淀 | `self-improving-agent` | 把纠错与踩坑沉淀为行为改进 |

每个角色的工作流、触发方式和示例见 [SKILLS_GUIDE.md](./SKILLS_GUIDE.md)。

## 文件结构

```
skillsList/
├── README.md           # 本文件（人类看的入口）
├── AGENTS.md           # Agent 执行指令（AI 看的入口：安装/同步/定时）
├── SKILLS_GUIDE.md     # 完整技能清单（按角色 → 工作流组织）
├── skills/
│   ├── product-design/ # 自研：想法 → PRD
│   └── clarify-first/  # 自研：模糊需求对齐
└── LICENSE             # MIT
```

## License

[MIT](./LICENSE)
