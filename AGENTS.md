# AGENTS.md — skillsList 仓库 · Agent 执行指令

> **本仓库是一份「个人开发环境与 AI 技能清单」。** 它不只管 AI 技能，还管基础开发环境、本机配置适配、多 AI 客户端的同步。仓库内统一的规则 + 每台电脑各自的 `state.local.json` = 完整方案。

> **唯一事实源：本 GitHub 仓库。** 本机的实际状态写进 `state.local.json`（不进 Git）；任何机器上的修改都要回传仓库（场景 4），其他机器同步即得。

---

## 🤖 AI 助手请先读这段

当用户**用任何方式提到本仓库**（"按 skillsList 装一下"、"按 skillsList 同步"、"按 skillsList 体检"、"按 skillsList 配置这台电脑"）时，**按下文 5 个场景执行，不要反复问用户"你要干什么"**。遇到失败项跳过，最后汇总。

⚠️ **常见误判纠正**：
- 本仓库**不是技能包**——`skills/` 目录里只有 2 个自研技能，其余 13 个技能（设计、动效、agent-browser、find-skills、self-improving-agent 等）需从远程注册表（skills.sh / npm）安装。
- 本仓库**不是安装脚本**——所有执行由 AI 客户端内的助手按场景描述主动完成，不需要运行 `install.sh` / `setup.ps1`。
- 本仓库**不是单机器配置**——所有机器共用本仓库，但每台机器的路径、已装软件、缓存目录都是各自体检得到的，不能硬编码到模板里。

---

## 场景总览

| 场景 | 触发口令 | 状态 | 副作用 |
|---|---|---|---|
| **0 体检** | "按 skillsList 体检" / "先体检" / "配置这台新电脑" | 只读 | 写 `state.local.json`（不进 Git） |
| **1 安装** | "按 skillsList 安装" / "确认安装" | 写入 | 装软件、装技能、装环境 |
| **2 同步** | "按 skillsList 同步" / "更新技能" | 写入 | 更新已装项 |
| **3 定时** | "每天同步 skillsList" | 注册 | 用 AI 自身定时能力（不建 shell 计划任务） |
| **4 上传** | "把新技能收录进 skillsList" / "更新清单" | 写仓库 | git add / commit / push（不直接 push，先给用户审） |

执行前先确认当前处于哪个场景——按口令的关键词判定。同一句话可能命中多个场景，按优先级：体检 > 安装 > 同步 > 定时 > 上传。

---

## 场景 0：体检（只读，生成 state.local.json）

**用户说"按 skillsList 体检"或"配置这台新电脑"** → AI 执行：

1. **拉取最新仓库**：
   - 本机已克隆 → `git pull --ff-only`
   - 未克隆 → `git clone https://github.com/liaokehong/skillsList.git D:\001_Software\skillsList`
2. **执行只读体检脚本**：
   - 优先执行 `D:\001_Software\skillsList\scripts\health-check.ps1`（与仓库同发）
   - 也可 AI 自己读 `state.template.json` 字段，用 OS 命令逐项查
3. **生成 `state.local.json`**（路径：`D:\001_Software\skillsList\state.local.json`）：
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

**红线**：场景 0 不执行任何写操作（不装软件、不改注册表、不删文件）。唯一写入就是 `state.local.json`（在 `.gitignore` 里，不提交）。

---

## 场景 1：安装（写，状态机驱动）

**用户说"按 skillsList 安装"** → AI 执行：

1. **必须有 `state.local.json`**：若不存在，先自动跑场景 0 生成。
2. **对照 `state.template.json` 字段 + `state.local.json` 当前值，列出待办**：
   - 基础开发套件（git/node/npm/python/uv）缺失 → 装
   - AI 客户端缺失 → 提示用户在编辑器市场装（不自动装）
   - 缓存/模型环境变量未设 → 跑 `localConfig/scripts/redirect-caches-to-d.ps1`
   - skills 未同步到任何客户端 → 按"技能同步到所有客户端"规则装
3. **逐项确认高风险动作**（必须列出来用户确认）：
   - 装在 C 盘的工具要移 D 盘
   - 修改注册表 / PATH
   - 删除 `C:\Users\Dell` 下的旧缓存
4. **执行**：每项执行前输出"将要做 X / 影响 Y / 落点 Z"。
5. **完成后跑场景 0 复检**，对比 `state.local.json` 变化，汇报。

**技能同步到所有客户端的规则**（本仓库新增核心能力）：

```
对仓库里每个 skill：
  for client in state.local.json.ai_clients where client.installed:
    target = client.skills_path
    copy skill source to target
    verify SKILL.md exists at target
```

- **不**直接 copy 到一个默认路径
- **必须**先读 `state.local.json` 拿每个客户端的 skills_path
- **必须**逐个验证 SKILL.md 落地

**技能源**：
- 自研：`skills/<name>/` 来自本仓库
- 远端：`npx skills add <repo>@<skill> -g -y`（先装到首个客户端，再用同步规则分发到其余）
- npm：`npm i -g <pkg>`（全局工具，不复制到客户端）

---

## 场景 2：同步（写，差异驱动）

**用户说"按 skillsList 同步"** → AI 执行：

1. `cd D:\001_Software\skillsList && git pull --ff-only`
2. 重新执行 `scripts/health-check.ps1` 生成新的 `state.local.json`
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

**用户说"每天 9 点同步 skillsList"** → AI 执行：

1. 用 AI 客户端**自身的定时任务能力**注册每日任务（如 Cursor automations / ZCode automations / Codex schedule prompt）：
   - 任务名：`skillsList 每日同步`
   - 触发：每天 09:00（用户未指定则用此默认）
   - 内容：执行场景 2 的 6 步
2. **不**创建 shell 脚本、**不**创建系统级计划任务、**不**写入 `taskschd.msc`。
3. 确认已注册成功，告知用户。

---

## 场景 4：上传（写仓库，不直接 push）

**用户说"把新技能/修改收录进 skillsList"** → AI 执行：

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
- 不写用户的工号、公司邮箱、绝对路径到任何提交文件
- 自研技能的 `SKILL.md` 不得含机器特定路径
- `state.template.json` 不得含任何本机数据
- commit 身份用仓库级 `git config user.name` / `user.email`

---

## 体检规则（场景 0 的标准）

体检脚本 `scripts/health-check.ps1` 是只读的标准实现，AI 助手可参考或直接执行。体检项：

| 大类 | 必查项 |
|---|---|
| 系统 | OS、CPU、RAM |
| 磁盘 | 各盘 total/used/free，标记系统盘 |
| 基础开发套件 | git / node / npm / python / uv / docker |
| AI 客户端 | Cursor / ZCode / Codex / Claude（版本 + skills 目录） |
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
