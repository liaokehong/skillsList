# AGENTS.md — env-manifest 仓库 · Agent 执行指令

> **本仓库是一份「个人开发环境与 AI 技能清单」。** 它不只管 AI 技能，还管基础开发环境、本机配置适配、多 AI 客户端的同步。仓库内统一的规则 + 每台电脑各自的 `state.local.json` = 完整方案。

> **唯一事实源：本 GitHub 仓库。** 本机的实际状态写进 `state.local.json`（不进 Git）；任何机器上的修改都要回传仓库（场景 4），其他机器同步即得。

---

## 🤖 AI 助手请先读这段

当用户**用任何方式提到本仓库**（"按 env-manifest 装一下"、"按 env-manifest 同步"、"按 env-manifest 体检"、"按 env-manifest 配置这台电脑"）时，**按下文 5 个场景执行，不要反复问用户"你要干什么"**。新电脑从 GitHub 地址开始，先取得仓库并读取本文件，再体检本机。遇到失败项跳过，最后汇总。

⚠️ **常见误判纠正**：
- 本仓库**不是技能包**——`skills/` 目录里只有 2 个自研技能，其余 14 个技能（设计、动效、agent-browser、find-skills、self-improving-agent 等）需从远程注册表（skills.sh / npm）安装。
- 本仓库**不含任何脚本**——体检、安装、同步全部由 AI 客户端内的助手读取本文件和 `state.template.json` 后，按本机实际情况自行设计步骤完成；不存在 `install.sh` / `setup.ps1` / `health-check.ps1` 之类的固定入口。
- 本仓库**不是单机器配置**——所有机器共用本仓库，但每台机器的路径、已装软件、缓存目录都是各自体检得到的，不能硬编码到模板里。

---

## 场景总览

| 场景 | 触发口令 | 状态 | 副作用 |
|---|---|---|---|
| **0 体检** | "按 env-manifest 体检" / "先体检" / "配置这台新电脑" | 只读 | 写 `state.local.json`（不进 Git） |
| **1 安装** | "按 env-manifest 安装" / "确认安装" | 写入 | 装软件、装技能、装环境 |
| **2 同步** | "按 env-manifest 同步" / "更新技能" | 写入 | 更新已装项 |
| **3 定时** | "每天同步 env-manifest" | 注册 | 用 AI 自身定时能力（不建 shell 计划任务） |
| **4 上传** | "把新技能收录进 env-manifest" / "更新清单" | 写仓库 | git add / commit / push（不直接 push，先给用户审） |

执行前先确认当前处于哪个场景——按口令的关键词判定。同一句话可能命中多个场景，按优先级：体检 > 安装 > 同步 > 定时 > 上传。

---

## 场景 0：体检（只读，生成 state.local.json）

**用户说"按 env-manifest 体检"或"配置这台新电脑"** → AI 执行：

1. **取得并读取仓库**：
   - 用户只提供 GitHub 地址时，AI 先判断本机是否已有该仓库；已有则读取本地规则，必要时 `git pull --ff-only`。
   - 未克隆且 Git 可用时，AI 选择本机软件根目录下的 `env-manifest` 目录进行克隆；软件根目录不存在时，先根据磁盘体检结果选择可用数据盘并创建它。
   - Git 不可用时，AI 使用客户端可用的网络和系统工具取得 Git，安装包放入下载暂存目录，Git 本体放入软件根目录，再继续克隆。不能假定仓库已经存在，也不能把当前电脑路径写入模板。
   - 克隆完成后必须重新读取仓库内的 `README.md`、`AGENTS.md`、`SKILLS_GUIDE.md` 和 `state.template.json`，后续步骤以当前仓库版本为准。
2. **执行只读体检（AI 自主设计步骤，无脚本）**：
   - 读 `state.template.json`，按字段清单逐项检查：系统、磁盘、基础套件、AI 客户端、业务软件、路径、环境变量、网络、仓库、技能同步
   - 检查命令由 AI 根据本机情况选择（Windows 用 `where` / `Get-Command` / `Get-PSDrive` / 注册表查询，macOS/Linux 用 `which` / `df` 等）；查不到的项填 `null`，不推测、不标 `false`
   - 环境变量以模板 `env_vars` 表为准：`expected` 是相对软件根目录的约定路径，`actual` 从用户级环境变量读取后拼接比较
3. **生成 `state.local.json`**（路径：`D:\001_Software\env-manifest\state.local.json`）：
   - 复制 `state.template.json` 为骨架
   - 用体检结果填充所有字段
   - 加上"日期"和"机器标识"
4. **输出报告**（不分项说明）：
   - ✅ 已满足：列出所有 OK 的项
   - ❌ 缺失：缺哪些必装软件 / 工具
   - ⚠️ 路径不符：装在 C 盘或非约定路径的项
   - 🔧 建议：缓存/模型目录未重定向到 D 盘的项
   - 🚨 高风险：装在系统目录、下载目录溢出 C 盘、缺少必备开发工具
5. **询问用户**：
   - "是否按此报告进入场景 1（安装）？"
   - "是否需要我先把修改建议写到一份 `state.changes.json` 里供你审？"

**红线**：场景 0 不执行安装、注册表修改、环境变量修改和删除。允许的写入只有本机 `state.local.json`；拉取仓库或创建本地克隆目录属于启动必要动作。所有实际安装和配置必须等用户确认进入场景 1。

---

## 场景 1：安装（写，状态机驱动）

**用户说"按 env-manifest 安装"** → AI 执行：

1. **必须有 `state.local.json`**：若不存在，先自动跑场景 0 生成。
2. **对照 `state.template.json` 字段 + `state.local.json` 当前值，列出待办**：
   - 基础开发套件（Git/Node.js/npm/Python/uv/Windows Terminal）缺失 → 装
   - AI 客户端缺失 → 提示用户在编辑器市场装（不自动装）
   - 缓存/模型环境变量未设 → 按 `state.template.json` 的 `env_vars` 表逐个设置为用户级变量（目标 = 本机软件根目录 + `expected` 相对路径），需要时追加 PATH；注册表 / PATH 修改先列影响给用户确认
   - skills 未同步到任何客户端 → 按"技能同步到所有客户端"规则装
3. **逐项确认高风险动作**（必须列出来用户确认）：
   - 装在 C 盘的工具要移 D 盘
   - 修改注册表 / PATH
   - 删除 `C:\Users\Dell` 下的旧缓存
4. **执行**：每项执行前输出"将要做 X / 影响 Y / 落点 Z"。
5. **完成后跑场景 0 复检**，对比 `state.local.json` 变化，汇报。

**技能同步规则**（核心能力：所有客户端完全一致）：

**硬规则**：清单里的每个 skill 必须在**每个已安装客户端**的 skills 目录里都存在，且 `SKILL.md` 内容一致——不存在"只装在某个客户端"的 skill。客户端自有的、不在清单里的技能（平台专属）不受影响，也不要求删除。

```
对 state.template.json.skills 里每个 skill：
  1. 检查：是否已存在于各客户端 skills 目录（对照 SKILL.md 内容）
  2. 缺失 → 安装：远端 `npx skills add <repo>@<skill> -g -y`；自研从仓库 skills/<name>/ 拷贝
  3. 分发：for client in state.local.json.ai_clients where client.installed and client.skills_path is known:
       copy 到 client.skills_path（已存在且内容一致则跳过）
  4. 验证：每个目标目录的 SKILL.md 存在且内容一致
```

- **不**直接 copy 到一个默认路径——必须先读 `state.local.json` 拿每个客户端的 skills_path
- **首次使用**（场景 1）：全量检查 → 缺的装 → 分发 → 逐个验证
- **日常使用**（场景 2 / 每日定时）：diff 驱动——只补新增和变更项，已一致的不动
- **失败项跳过**：某客户端未装 → 跳过，汇总里写明

**技能源**：
- 自研：`skills/<name>/` 来自本仓库
- 远端：`npx skills add <repo>@<skill> -g -y`（先装到首个客户端，再用同步规则分发到其余）
- npm：`npm i -g <pkg>`（全局工具，不复制到客户端）

---

## 场景 2：同步（写，差异驱动）

**用户说"按 env-manifest 同步"** → AI 执行：

1. 进入本地克隆目录（`state.local.json` 的 `repo.local_clone_path`，新机器上由场景 0 确定）执行 `git pull --ff-only`
2. 按场景 0 的无脚本方式重新体检，刷新 `state.local.json`
3. 对比新旧两份 `state.local.json`，列出 diff：
   - 新增项
   - 删除项
   - 变化项（版本/路径）
4. 询问用户："是否按 diff 执行同步？"
5. 确认后只改变动项，不动未变的项。
6. 汇报：本轮新增/更新/失败/跳过的清单。

**核心规则：只改变动项**。已装且版本一致的项不动，避免破坏用户当前状态。

---

## 场景 3：定时（注册，不建 shell 任务）

**用户说"每天 9 点同步 env-manifest"** → AI 执行：

1. 用 AI 客户端**自身的定时任务能力**注册每日任务（如 Cursor automations / ZCode automations / Codex schedule prompt）：
   - 任务名：`env-manifest 每日同步`
   - 触发：每天 09:00（用户未指定则用此默认）
   - 内容：执行场景 2 的 6 步
2. **不**创建 shell 脚本、**不**创建系统级计划任务、**不**写入 `taskschd.msc`。
3. 确认已注册成功，告知用户。

---

## 场景 4：上传（写仓库，不直接 push）

**用户说"把新技能/修改收录进 env-manifest"** → AI 执行：

1. 自研技能：把技能目录放进 `skills/<名称>/`（含 `SKILL.md`）
2. 清单变更：更新 `SKILLS_GUIDE.md` 对应角色小节
3. 安装规则变更：更新 `AGENTS.md` 的对应场景步骤
4. 检查清单模板变更：更新 `state.template.json`
5. **写本地 commit**（仓库级 git 身份）：
   ```bash
   git add -A
   git diff --cached --stat      # 给用户看变更摘要
   git commit -m "..."
   ```
6. **不直接 push**——`git push` 前必须让用户审 commit 摘要。
7. 用户确认后执行 `git push`。

**红线（上传）**：
- 任何对外内容都严格禁止出现所属组织名称、部门、内部系统、项目代号、内部域名、账号、工号、办公地点或可反推组织身份的术语；不确定时使用通用占位符或删除。
- 自研技能的 `SKILL.md` 不得含机器特定路径
- `state.template.json` 不得含任何本机数据
- commit 身份用仓库级 `git config user.name` / `user.email`

---

## 体检规则（场景 0 的标准）

体检由 AI 助手直接执行（本仓库不含脚本）：读 `state.template.json` 字段，按本机情况设计检查命令。体检项：

| 大类 | 必查项 |
|---|---|
| 系统 | OS、CPU、RAM |
| 磁盘 | 各盘 total/used/free，标记系统盘 |
| 基础开发套件 | git / node / npm / python / uv / docker |
| AI 客户端 | Cursor / ZCode / Codex（版本 + skills 目录） |
| 业务软件 | LM Studio / Ollama / PyCharm / VSCode / Firecrawl / FFmpeg / PowerToys |
| 路径 | 软件根、下载、缓存、模型、bin 是否落在约定目录 |
| 环境变量 | 16 个缓存/模型变量是否已重定向到 D 盘 |
| 网络 | GitHub / npm 可达性，镜像是否设置 |
| 仓库 | 本地是否已克隆、与 origin/main 同步状态 |

`state.local.json` 生成时**只填体检结果**，**不填推测值**——查不到就标 `null` 而非编造。

---

## 红线汇总

- **不自动 push**：所有 git push 之前必须给用户看 commit 摘要
- **不写本机数据到仓库**：machine_id / hostname / 绝对路径 / 实际 exe 路径都进 `state.local.json`
- **不创建 shell 计划任务**：场景 3 用 AI 自身定时能力
- **不删除用户文件**：清理 C 盘缓存必须先列清单经用户确认
- **不擅自修改注册表**：改 PATH / 改系统环境变量必须先列影响
- **不在场景 0 写任何文件**：除了 `state.local.json` 自身
- **AI 客户端路径不写死**：必须从体检得到，每个客户端的 skills_path 各异
- **软件根目录不写死**：模板只保存规则，实际根目录由本机体检确定
