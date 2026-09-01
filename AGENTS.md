# AGENTS.md — 技能清单仓库 · Agent 执行指令

这是 liaokehong 的个人技能清单仓库。**当用户提到本仓库（安装 / 同步 / 更新技能清单）时，按下述指令自主执行**，无需用户逐步确认；遇到失败项跳过并在结束时汇总。

完整技能说明与各角色工作流见 [SKILLS_GUIDE.md](./SKILLS_GUIDE.md)。

## 仓库定位与数据流向

- **主端（重度使用端）**：用户日常重度使用技能的机器，也是信息的**上传源**——清单修改、新技能沉淀都发生在主端，完成后推送到 GitHub。
- **消费端（其他设备）**：以**安装 / 同步**为主（场景 1、2、3），一般不直接修改仓库内容。
- **唯一事实源**：GitHub 上的本仓库。任何一台设备上产生的技能或清单变更，都按场景 4 回传仓库，保证其他端同步即得最新。

### 场景 4：信息上传（用户要求"把新技能/修改收录进 skillsList"）

1. 自研技能：把技能目录放进本仓库 `skills/<名称>/`（含 SKILL.md）；清单变更：更新 SKILLS_GUIDE.md 对应角色小节和 AGENTS.md 的安装清单（若是 skills.sh 生态新技能）。
2. 提交并推送：`git add -A && git commit -m "..." && git push`（提交身份用仓库级 git config，遵守文末红线）。
3. 汇报推送结果，提醒其他端下次同步即可获取。

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
