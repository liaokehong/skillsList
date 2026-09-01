# Claude Code Skills 个人使用清单

> 按「**角色 → 工作流**」组织。我的工作：企业内部数字化建设——需求与 PRD、交互与 UI 规范、内部工具（如部门提单系统）、算力服务器管理、AI 辅助开发。
>
> - 首次核验：2026-08-28 · 按角色重组：2026-09-01
> - 新设备一键安装与每日自动同步见 [README](./README.md)

## 角色总览

| 角色 | 技能 | 干什么 |
|------|------|--------|
| 🧭 产品 / 需求 | `clarify-first` → `product-design` | 模糊想法对齐 → 产出多角色 PRD |
| 🎨 交互 / 视觉设计 | owl-listener 七件 + `ui-ux-pro-max` + `frontend-design` + 动效两件 | 交互规格 → 视觉实现 → 交付自审 → 动效打磨 |
| 🛠 开发落地 | `openspec` + `agent-browser` | 规范驱动 AI 实现 → 浏览器自动化自测 |
| 🔍 调研 / 信息 | Firecrawl（30+ 子技能）+ `find-skills` | 网页调研、深度报告、发现新技能 |
| 🧠 通用沉淀 | `self-improving-agent` | 把纠错与踩坑沉淀为可审计的行为改进 |

> 已移除（与当前工作关联弱）：~~Superpowers~~（TDD/调试/代码审查等开发工作流）、~~Remember~~（跨会话记忆）、~~Task Master~~（任务拆分管理）。

---

## 一、产品 / 需求角色

### 工作流

```
模糊想法 ─► ① clarify-first 对齐 ─► ② product-design 出 PRD ─► 交给设计 / 开发角色
```

### clarify-first（自研）

模糊需求开工前先对齐再执行：调研 → 澄清 → 产出《任务简报》。

- **触发**：需求缺少明确的"好"的标准、返工成本高时；创意/内容类任务（脚本、分镜、官网、工作台）、"优化一下"类口头需求
- **文件**：随本仓库 `skills/clarify-first/` 分发，安装脚本自动落到 `~/.agents/skills/`

### product-design（自研）

把对齐后的产品想法变成多角色可直接使用的 PRD（设计 / 开发 / 测试 / 管理分区）。

- **触发**："我想做一个…""把这个想法整理成需求""写个 PRD""功能设计"
- **衔接**：想法过于模糊时先走 `clarify-first` 对齐，再产出 PRD
- **文件**：随本仓库 `skills/product-design/` 分发

---

## 二、交互 / 视觉设计角色

> 组成：`ui-ux-pro-max`（nextlevelbuilder）+ owl-listener/designer-skills 七核心 + `frontend-design`（anthropics 官方）+ emilkowalski 动效两件

### 工作流（四阶段接力）

```
PRD 定稿 ─► ① 交互规格(owl-listener) ─► ② 视觉方向+实现(frontend-design + ui-ux-pro-max) ─► ③ 交付自审(heuristic-evaluation) ─► ④ 动效打磨(improve-animations，可选)
```

### Skill 一览

| Skill | 来源 | 阶段 | 用途 |
|-------|------|------|------|
| `user-flow-diagram` | owl-listener | ① | 画用户路径、决策点、分支逻辑 |
| `navigation-patterns` | owl-listener | ① | 选导航模式（tab/抽屉/层级/枢纽） |
| `state-machine` | owl-listener | ① | 穷举组件状态（空/加载/成功/失败…）——交互混乱的病根 |
| `form-design` | owl-listener | ① | 表单端到端设计：字段顺序、分组、校验 |
| `loading-states` | owl-listener | ① | 加载态设计 |
| `error-handling-ux` | owl-listener | ① | 错误的预防、检测、恢复路线 |
| `heuristic-evaluation` | owl-listener | ③ | 尼尔森十原则专家评审 + 严重度打分 |
| `frontend-design` | anthropics/skills 官方 | ② | 视觉设计方向、排版、避免模板感 |
| `ui-ux-pro-max` | nextlevelbuilder | ② | 全能"设计智能"：组件选型、布局、无障碍、技术栈写法 |
| `improve-animations` / `animate` | emilkowalski | ④ | 动效审计与实现（打磨手感） |

### 使用示例

**① 动手前想清楚**（产出《交互规格》文档，不是代码）：

```
我们要做 XX 项目的 YY 功能，先用 user-flow-diagram 画出用户路径，
再用 state-machine 穷举核心组件的所有状态，把 loading、错误处理、
反馈方式定下来，产出一份《交互规格》文档。
```

细抠某块直接点名：「用 form-design 的规范过一遍这个表单」「用 navigation-patterns 决定侧边栏还是顶部导航」。

**② 动手时做对**：

```
先给这个落地页定视觉方向，再按照《交互规格》实现页面，
用 ui-ux-pro-max 的规范选组件和布局。
```

**③ 做完后验收**（每个项目交付前都跑）：

```
用 heuristic-evaluation 按尼尔森十原则给这个界面打分，列出问题和严重度。
```

**④ 动效打磨**（稳定后可选）：`用 improve-animations 审一下列表页的过渡动效`

发现问题回 ① 补规格再改。

---

## 三、开发落地角色（AI 辅助）

### 工作流

```
PRD ─► ① openspec 写规范 ─► ② AI 按规范实现 ─► ③ openspec validate 校验 ─► ④ agent-browser 自测
```

### OpenSpec（规范驱动开发 / SDD）

> **来源**: npm 全局包 `@fission-ai/openspec`（本机 v1.10.0）
> **仓库**: https://github.com/Fission-AI/OpenSpec

AI 原生的规范驱动开发系统。先写规范（Spec），再驱动 AI 按规范实现代码。

```bash
openspec init      # 项目内初始化
openspec new       # 创建规范
openspec list      # 查看规范状态
openspec validate  # 验证实现是否符合规范
```

工作流：`init` → 编写规范（描述需求和验收标准）→ 让 AI 读规范并实现 → `validate` 校验。

### agent-browser（浏览器自动化）

> **来源**: vercel-labs/agent-browser（738K 安装）

面向 AI 的浏览器自动化 CLI：导航、填表、点击、截图、测试 web 应用。

```
用 agent-browser 打开 localhost:3000，截图看下提单表单在手机尺寸下的效果
```

---

## 四、调研 / 信息支撑角色

### 工作流

```
要外部信息 ─► 快查: firecrawl-search / scrape ─► 深度: firecrawl-deep-research / firecrawl-agent ─► 缺能力: find-skills 找新 skill
```

### Firecrawl

> **仓库**: https://github.com/firecrawl/firecrawl-claude-plugin.git
> **规模**: 共 30+ 个 skill，以下为常用子集（2026-09-01 按实际安装核对）

强大的网页抓取和爬取工具。将任意网站转为干净的 Markdown 或结构化数据，支持 AI agent 自主多源数据收集。

| Skill | 用途 |
|-------|------|
| `firecrawl-scrape` | 抓取单个页面 |
| `firecrawl-crawl` | 爬取整个网站 |
| `firecrawl-search` | 搜索网络 |
| `firecrawl-map` | 网站结构映射 |
| `firecrawl-download` | 下载页面内容 |
| `firecrawl-parse` | 文档/文件结构化解析 |
| `firecrawl-agent` | AI agent 自主多源数据收集 |
| `firecrawl-deep-research` | 多轮深度调研并输出报告 |
| `firecrawl-research-papers` | 学术论文检索 |
| `firecrawl-website-design-clone` | 网站设计风格克隆 |
| `firecrawl-seo-audit` | SEO 审计 |
| `firecrawl-qa` | 对抓取内容做问答 |
| `firecrawl-monitor` | 网页变更监控 |

> 早期版本的 `firecrawl-instruct` / `firecrawl-cli` 已分别被 `firecrawl-parse` 与独立 CLI 取代。

### 使用示例

```
# 爬取单个页面
/firecrawl:firecrawl-scrape https://docs.example.com

# 深度调研：帮我调研电池行业 MES 系统的主流方案，整理成表格
/firecrawl:firecrawl-agent …

# 爬取整个文档站
/firecrawl:firecrawl-crawl https://docs.example.com --maxPages 50
```

### find-skills（发现新技能）

> **来源**: vercel-labs/skills（3.1M 安装）

"找个能做 X 的 skill" 时自动触发：

```
帮我找数据分析相关的 skill
```

---

## 五、通用沉淀

### self-improving-agent

> **来源**: zhaono1/agent-playbook（33K 安装）

把失败和用户纠正沉淀为可审计的行为改进，越用越顺手。

```
刚才那个方案为什么不行，沉淀成经验
```

---

## 安装速查

| 类目 | 安装方式 |
|------|----------|
| skills.sh 生态（设计包 / 四件套 / 动效） | `npx skills add <repo>@<skill> -g -y`，须逐个装；一键脚本见 [README](./README.md) |
| OpenSpec | `npm i -g @fission-ai/openspec` |
| Firecrawl | 编辑器插件市场安装 firecrawl 插件 |
| 自研技能（product-design / clarify-first） | 随本仓库 `skills/` 目录分发，install 脚本自动拷贝到 `~/.agents/skills/` |

## 快速参考表（按角色）

| 角色 | 触发方式 | 关键场景 |
|------|----------|----------|
| 🧭 产品 / 需求 | 自然语言 | 想法对齐、写 PRD |
| 🎨 交互 / 视觉设计 | 点名触发（推荐） | 交互规格 → 实现 → 自审 → 动效 |
| 🛠 开发落地 | CLI + 自然语言 | 规范先行、浏览器自测 |
| 🔍 调研 / 信息 | `/firecrawl:<skill>`、自然语言 | 网页调研、深度报告、找技能 |
| 🧠 通用沉淀 | 出错/被纠正后 | 沉淀经验 |
