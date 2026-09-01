# AGENTS.md — 技能清单仓库 · Agent 执行指令

这是 liaokehong 的个人技能清单仓库。**当用户提到本仓库（安装 / 同步 / 更新技能清单）时，按下述指令自主执行**，无需用户逐步确认；遇到失败项跳过并在结束时汇总。

完整技能说明与各角色工作流见 [SKILLS_GUIDE.md](./SKILLS_GUIDE.md)。

## 触发场景与执行动作

### 场景 1：用户要求「安装技能清单」（如"按 skillsList 装一下技能"）

依次执行：

1. **检查前置**：`git`、`node`、`npm` 可用（缺失则先安装或明确告知用户）。
2. **安装 npm 全局工具**（仅一个）：
   ```bash
   npm install -g @fission-ai/openspec
   ```
3. **逐个安装 skills.sh 生态技能**（14 个，见下方清单）。⚠️ 必须逐个执行，批量 `-s "a,b"` 语法不生效：
   ```bash
   npx skills add <repo>@<skill> -g -y
   ```
4. **安装自研技能**：把本仓库 `skills/` 下的每个目录完整拷贝到 `~/.agents/skills/`（已存在则覆盖）。
5. **Firecrawl**：无法命令行安装，提示用户在编辑器插件面板搜索安装 firecrawl 插件。
6. **结束汇报**：列出成功 / 失败清单，提醒重启编辑器生效。

### 场景 2：用户要求「同步 / 更新技能清单」

1. 本仓库未克隆到本机 → `git clone https://github.com/liaokehong/skillsList.git`（默认克隆到用户主目录，用户指定了路径则用指定路径）；已克隆 → 在仓库目录 `git pull --ff-only`。
2. `npx skills update -g` 更新已安装的 skills.sh 生态技能。
3. 重新拷贝 `skills/` 自研技能到 `~/.agents/skills/`（覆盖旧版）。
4. 汇报本次更新内容（`git log` 最近的变更摘要）。

### 场景 3：用户要求「每天定时同步」

使用**你自己的定时任务能力**注册每日任务（如 ZCode automations、cron prompt 等），任务内容 = 执行「场景 2」的同步流程。**不要**创建 shell 脚本或系统级计划任务。时间用用户指定的时间，未指定则默认每天 09:00。

## skills.sh 生态技能安装清单（逐个执行）

```text
# 交互 / 视觉设计角色
anthropics/skills@frontend-design
nextlevelbuilder/ui-ux-pro-max-skill@ui-ux-pro-max
owl-listener/designer-skills@user-flow-diagram
owl-listener/designer-skills@navigation-patterns
owl-listener/designer-skills@state-machine
owl-listener/designer-skills@form-design
owl-listener/designer-skills@loading-states
owl-listener/designer-skills@error-handling-ux
owl-listener/designer-skills@heuristic-evaluation
emilkowalski/skills@improve-animations
emilkowalski/skills@animate
# 开发落地角色
vercel-labs/agent-browser@agent-browser
# 调研 / 信息角色
vercel-labs/skills@find-skills
# 通用沉淀
zhaono1/agent-playbook@self-improving-agent
```

## 自研技能（只随本仓库分发）

| 目录 | 用途 |
|------|------|
| `skills/product-design/` | 把产品想法变成多角色可直接使用的 PRD |
| `skills/clarify-first/` | 模糊需求开工前对齐，产出《任务简报》 |

## 红线

- 不要把用户工号、公司邮箱等敏感信息写进任何提交（提交身份用用户已配置的仓库级 git config）。
- 修改清单内容时保持「角色 → 工作流」的组织结构（见 SKILLS_GUIDE.md）。
