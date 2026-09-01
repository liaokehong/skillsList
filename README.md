# Skills 个人使用清单

> 我的工作：企业内部数字化建设——需求与 PRD、交互与 UI 规范、内部工具、算力服务器管理、AI 辅助开发。
> 技能按「**角色 → 工作流**」组织。仓库内置 Agent 指令，**把地址发给任何 AI 编码助手即可自动安装**——不需要跑任何脚本。

## 🤖 AI 助手请先读这段（被要求"按本仓库安装 / 同步技能"时必看）

**本仓库是一份「技能清单」（manifest），不是技能包。** `skills/` 目录里只有 2 个自研技能；其余技能都在远程注册表，需要你按下面的指令去安装。"安装本仓库的技能" = 完整执行以下步骤，而不是只装 `skills/` 目录里的文件。遇到失败项跳过，最后汇总汇报。

### 安装步骤（对应 AGENTS.md 场景 1）

1. **前置检查**：`git`、`node`、`npm` 可用（缺失则先安装或明确告知用户）。
2. **npm 全局工具**（仅一个）：`npm install -g @fission-ai/openspec`
3. **逐个安装以下 14 个 skills.sh 技能**（⚠️ 必须逐条执行，批量 `-s "a,b"` 语法不生效）：
   ```text
   npx skills add anthropics/skills@frontend-design -g -y
   npx skills add nextlevelbuilder/ui-ux-pro-max-skill@ui-ux-pro-max -g -y
   npx skills add owl-listener/designer-skills@user-flow-diagram -g -y
   npx skills add owl-listener/designer-skills@navigation-patterns -g -y
   npx skills add owl-listener/designer-skills@state-machine -g -y
   npx skills add owl-listener/designer-skills@form-design -g -y
   npx skills add owl-listener/designer-skills@loading-states -g -y
   npx skills add owl-listener/designer-skills@error-handling-ux -g -y
   npx skills add owl-listener/designer-skills@heuristic-evaluation -g -y
   npx skills add emilkowalski/skills@improve-animations -g -y
   npx skills add emilkowalski/skills@animate -g -y
   npx skills add vercel-labs/agent-browser@agent-browser -g -y
   npx skills add vercel-labs/skills@find-skills -g -y
   npx skills add zhaono1/agent-playbook@self-improving-agent -g -y
   ```
4. **自研技能**：把 `skills/` 下每个目录（product-design、clarify-first）完整拷贝到 `~/.agents/skills/`（已存在则覆盖）。
5. **Firecrawl**：无法命令行安装，提示用户在编辑器插件面板搜索安装 firecrawl 插件。
6. **汇报**：列出成功 / 失败清单，提醒重启编辑器生效。

### 同步步骤（对应 AGENTS.md 场景 2）

本仓库未克隆 → `git clone` 到用户主目录；已克隆 → `git pull --ff-only`；然后 `npx skills update -g`，再重新拷贝 `skills/` 自研技能覆盖旧版，最后汇报变更摘要。

### 每日定时（对应 AGENTS.md 场景 3）

使用**你自身的定时任务能力**注册每日同步（默认 09:00 或用户指定时间），内容 = 上面的同步步骤。**不要**创建 shell 脚本或系统计划任务。

> 信息上传（新增/修改技能收录进仓库）、设备角色、敏感信息红线，见 [AGENTS.md](./AGENTS.md)。

---

## 💬 人类怎么用（vibe coding 方式）

把下面的话发给你的 AI 编码助手（ZCode / Cursor / Codex 等）：

```text
帮我按照 https://github.com/liaokehong/skillsList 安装技能清单（读取并遵循其中的 README 和 AGENTS.md）
```

```text
按 skillsList 同步更新我的技能
```

```text
每天早上 9 点帮我同步 skillsList
```

## 角色总览

| 角色 | 技能 | 干什么 |
|------|------|--------|
| 🧭 产品 / 需求 | `clarify-first` → `product-design`（自研） | 模糊想法对齐 → 产出多角色 PRD |
| 🎨 交互 / 视觉设计 | owl-listener 七件 + `ui-ux-pro-max` + `frontend-design` + 动效两件 | 交互规格 → 视觉实现 → 交付自审 → 动效打磨 |
| 🛠 开发落地 | `openspec` + `agent-browser` | 规范驱动 AI 实现 → 浏览器自动化自测 |
| 🔍 调研 / 信息 | Firecrawl（30+ 子技能）+ `find-skills` | 网页调研、深度报告、发现新技能 |
| 🧠 通用沉淀 | `self-improving-agent` | 把纠错与踩坑沉淀为行为改进 |

每个角色的工作流、触发方式和示例见 [SKILLS_GUIDE.md](./SKILLS_GUIDE.md)。

## 🧭 设备角色

- **主端（重度使用端）**：日常重度使用 + **信息上传**——清单修改、新技能沉淀在主端完成并推送到 GitHub。
- **其他设备**：纯**消费**——发安装 / 同步口令即可，不需要改仓库。
- GitHub 仓库是**唯一事实源**：任何端产生的变更都回传仓库，其他端一次同步即得。

## 文件结构

```
skillsList/
├── README.md           ← 入口：AI 安装指令（本文件顶部）+ 人类口令
├── AGENTS.md           ← Agent 完整指令：安装/同步/定时/上传 + 设备角色 + 红线
├── SKILLS_GUIDE.md     ← 完整技能清单（按角色 → 工作流组织）
├── skills/
│   ├── product-design/ # 自研：想法 → PRD
│   └── clarify-first/  # 自研：模糊需求对齐
└── LICENSE             # MIT
```

## License

[MIT](./LICENSE)
