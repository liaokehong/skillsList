# Claude Code Skills 使用指南

本项目（ccswitch）已配置 7 类 Claude Code 技能/插件，全部项目可用（2026-08-28 逐项核查过安装状态）。

---

## 1. Superpowers（综合开发能力）

> **来源**: `superpowers@claude-plugins-official` （marketplace）
> **仓库**: https://github.com/obra/superpowers.git

提供一套完整的开发工作流能力，让 Claude 掌握 brainstorming、子代理驱动开发、代码审查、系统化调试、TDD 等方法论。

### 包含的 Skill

| Skill | 用途 | 触发方式 |
|-------|------|----------|
| `brainstorming` | 头脑风暴，梳理需求和方案 | 讨论需求时自动激活 |
| `using-git-worktrees` | 使用 git worktree 隔离开发 | 并行开发任务时使用 |
| `subagent-driven-development` | 子代理驱动开发，分解任务并行执行 | 大型任务自动使用 |
| `test-driven-development` | 红/绿 TDD 开发流程 | 编写代码时使用 |
| `systematic-debugging` | 系统化调试方法 | 遇到 bug 时使用 |
| `executing-plans` | 按计划执行开发任务 | 有明确计划时 |
| `writing-plans` | 编写开发计划 | `/plan` 或规划时 |
| `requesting-code-review` | 请求代码审查 | 完成代码后 |
| `receiving-code-review` | 接收并处理代码审查反馈 | 收到 review 后 |
| `writing-skills` | 编写新的自定义 skill | 需要扩展能力时 |
| `verification-before-completion` | 完成前验证 | 任务收尾阶段 |
| `finishing-a-development-branch` | 完成开发分支的收尾工作 | 开发完成时 |
| `dispatching-parallel-agents` | 调度并行子代理 | 多任务并行时 |

### 使用示例

```
# 启动头脑风暴
/superpowers:brainstorming 我需要做一个用户登录系统

# 使用 TDD 开发
/superpowers:test-driven-development 编写一个表单验证函数

# 系统调试
/superpowers:systematic-debugging 这个API返回500错误
```

---

## 2. OpenSpec（规范驱动开发 / SDD）

> **来源**: npm 全局包 `@fission-ai/openspec` v1.6.0
> **仓库**: https://github.com/Fission-AI/OpenSpec

AI 原生的规范驱动开发系统。先写规范（Spec），再驱动 AI 按规范实现代码。

### 安装状态

已全局安装，CLI 命令：`openspec`

### 使用方式

```bash
# 初始化项目
openspec init

# 创建规范
openspec new

# 查看规范状态
openspec list

# 验证规范
openspec validate
```

### 工作流

1. `openspec init` — 在项目中初始化 OpenSpec
2. 编写规范文件（`.md` 格式），描述需求和验收标准
3. 让 Claude Code 读取规范并按照规范实现
4. `openspec validate` — 验证实现是否符合规范

---

## 3. Remember（代码记忆 / 上下文记忆）

> **来源**: `remember@claude-plugins-official` （marketplace）
> **仓库**: https://github.com/Digital-Process-Tools/claude-remember

连续记忆系统。自动提取、总结、压缩对话内容到分层日志中，让 Claude 记住之前做过的事情。

### 能力

- 自动记录对话摘要
- 跨会话记忆（Claude 记得昨天做了什么）
- 分层日志（daily/weekly/monthly）
- 自动压缩旧对话

### 使用方式

```
# 查看记忆
/remember

# 记忆按照时间分层存储，Claude 会自动读取相关记忆
```

Remember 插件**自动在后台工作**，无需手动触发。每次对话结束后，它会自动提取关键信息并存储，下次对话时 Claude 会自动加载相关记忆。

---

## 4. Firecrawl（深度调研 / 网页爬取）

> **来源**: `firecrawl@claude-plugins-official` （marketplace）
> **仓库**: https://github.com/firecrawl/firecrawl-claude-plugin.git

强大的网页抓取和爬取工具。将任意网站转为干净的 Markdown 或结构化数据，支持 AI agent 自主多源数据收集。

### 包含的 Skill

| Skill | 用途 |
|-------|------|
| `firecrawl-scrape` | 抓取单个页面 |
| `firecrawl-crawl` | 爬取整个网站 |
| `firecrawl-search` | 搜索网络 |
| `firecrawl-map` | 网站结构映射 |
| `firecrawl-download` | 下载页面内容 |
| `firecrawl-instruct` | 结构化信息提取 |
| `firecrawl-agent` | AI agent 自主多源数据收集 |
| `firecrawl-cli` | 命令行接口 |

### 使用示例

```
# 爬取单个页面
/firecrawl:firecrawl-scrape https://docs.example.com

# 深度搜索调研
/firecrawl:firecrawl-agent 帮我调研 React 19 的新特性，整理成表格

# 爬取整个文档站
/firecrawl:firecrawl-crawl https://docs.example.com --maxPages 50
```

---

## 5. Task Master（需求管理 & 任务拆分）

> **来源**: npm 全局包 `task-master-ai` v0.43.1
> **仓库**: https://github.com/eyaltoledano/claude-task-master

AI 驱动的开发任务管理系统。将大需求拆分为可执行的小任务，跟踪进度，管理依赖。

### 安装状态

已全局安装，包含：
- CLI：`task-master`
- MCP Server：`task-master-mcp`（可直接在 Claude Code 中使用）

### CLI 使用方式

```bash
# 初始化项目
task-master init

# 创建任务
task-master add "实现用户登录功能"

# 列出任务
task-master list

# 查看任务详情
task-master show <task-id>

# 更新任务状态
task-master update <task-id> --status in-progress
```

### MCP 配置

在项目根目录创建或编辑 `.mcp.json`：

```json
{
  "mcpServers": {
    "task-master": {
      "command": "npx",
      "args": ["task-master-mcp"]
    }
  }
}
```

配置后重启 Claude Code，即可在对话中直接使用 task-master 管理任务：

```
帮我创建一个任务列表，包含用户认证模块的所有子任务
查看当前项目的任务进度
把 task-3 标记为已完成
```

---

## 6. 基础技能四件套（skills.sh 生态）

> **来源**: skills.sh 注册表，`npx skills` CLI 安装（2026-08-28 装入 `~/.agents/skills/`）

四个通用基础能力，均已核验落盘。

| Skill | 来源 | 用途 |
|-------|------|------|
| `frontend-design` | anthropics/skills（官方，824K 安装） | 构建/重塑 UI 时的视觉设计方向、排版、避免模板感 |
| `find-skills` | vercel-labs/skills（3.1M 安装） | 发现并安装其他 agent skill（"找个能做 X 的 skill"时自动触发） |
| `agent-browser` | vercel-labs/agent-browser（738K 安装） | 面向 AI 的浏览器自动化 CLI：导航、填表、点击、截图、测试 web 应用 |
| `self-improving-agent` | zhaono1/agent-playbook（33K 安装） | 把失败/用户纠正沉淀为可审计的行为改进 |

### 使用示例

```
# frontend-design / agent-browser 靠自然语言触发
帮我给这个落地页做个视觉方案        → frontend-design
用 agent-browser 打开 localhost:3000 截图看下效果

# find-skills：想找某领域能力时
帮我找数据分析相关的 skill

# self-improving-agent：出错或被纠正后
刚才那个方案为什么不行，沉淀成经验
```

> **安装/管理命令**（须逐个装，批量 `-s "a,b"` 语法不生效）：
> `npx skills add anthropics/skills@frontend-design -g -y`
> 更新：`npx skills update -g`

---

## 7. 交互设计技能包（10 个，前端设计工作流）

> **来源**: skills.sh 生态（2026-08-28 装入 `~/.agents/skills/`，已核验）
> 组成：`ui-ux-pro-max`（122K★）+ owl-listener/designer-skills 七核心 + emilkowalski/skills 两件

### 包含的 Skill

| Skill | 来源 | 用途 |
|-------|------|------|
| `ui-ux-pro-max` | nextlevelbuilder（122K★/333.6K 安装） | 全能"设计智能"：设计/评审/修复界面，组件选型、布局、无障碍、技术栈写法 |
| `user-flow-diagram` | owl-listener | 画用户路径、决策点、分支逻辑 |
| `navigation-patterns` | owl-listener | 选导航模式（tab/抽屉/层级/枢纽） |
| `state-machine` | owl-listener | 穷举组件状态（空/加载/成功/失败…）——交互混乱的病根 |
| `form-design` | owl-listener | 表单端到端设计：字段顺序、分组、校验 |
| `loading-states` | owl-listener | 加载态设计 |
| `error-handling-ux` | owl-listener | 错误的预防、检测、恢复路线 |
| `feedback-patterns` | owl-listener | 操作反馈模式 |
| `heuristic-evaluation` | owl-listener | 尼尔森十原则专家评审 + 严重度打分（交付前自审） |
| `improve-animations` / `animate` | emilkowalski（33K★） | 动效审计与实现（可选，打磨手感） |

### 三阶段工作流（接力使用）

```
PRD 定稿 ─► ①交互设计(owl-listener 六件) ─► ②写代码实现(ui-ux-pro-max) ─► ③交付前自审(heuristic-evaluation)
```

**① 动手前想清楚**（产出《交互规格》文档，不是代码）：

```
我们要做 XX 项目的 YY 功能，先用 user-flow-diagram 画出用户路径，
再用 state-machine 穷举核心组件的所有状态，把 loading、错误处理、
反馈方式定下来，产出一份《交互规格》文档。
```

细抠某块直接点名：「用 form-design 的规范过一遍这个表单」「用 navigation-patterns 决定侧边栏还是顶部导航」。

**② 动手时做对**：

```
按照《交互规格》实现这个页面，用 ui-ux-pro-max 的规范选组件和布局。
```

**③ 做完后验收**（每个项目交付前都跑）：

```
用 heuristic-evaluation 按尼尔森十原则给这个界面打分，列出问题和严重度。
```

发现问题回 ① 补规格再改。动效稳定后可选跑 `improve-animations`。

### 安装命令

```bash
npx skills add nextlevelbuilder/ui-ux-pro-max-skill -g -y -s ui-ux-pro-max
# owl-listener 七件须逐个安装，例如：
npx skills add owl-listener/designer-skills -g -y -s state-machine
npx skills add owl-listener/designer-skills -g -y -s heuristic-evaluation
npx skills add emilkowalski/skills -g -y -s improve-animations
```

---

## 快速参考表

| 技能 | 触发方式 | 用途场景 |
|------|----------|----------|
| **Superpowers** | `/superpowers:<skill>` 或自动 | 全流程开发 |
| **OpenSpec** | CLI `openspec` 命令 | 规范先行开发 |
| **Remember** | 后台自动 | 跨会话记忆 |
| **Firecrawl** | `/firecrawl:<skill>` | 网页调研 |
| **Task Master** | CLI 或 MCP 自动 | 任务管理 |
| **基础四件套** | 自然语言触发 | 视觉设计/找 skill/浏览器自动化/自我改进 |
| **交互设计包** | 点名触发（推荐） | 前端设计三阶段：交互规格→实现→自审 |
