# Health Check（体检流程）

> skillsList 仓库把"新电脑从零开始"做成可重复的标准化流程。本文档解释体检是什么、查什么、输出什么、怎么用。

## 一、体检的目的

**新电脑 = 状态未知**。AI 助手在没有体检报告之前，不能瞎装东西。体检 = 用只读方法生成一份"机器现状 JSON"，让 AI 知道：

- 已经装了什么
- 装在哪里
- 缺什么
- 什么路径不对
- 网络是否通
- skills 同步到哪些客户端了

体检**只读**：不改注册表、不删文件、不装软件。

## 二、调用方式

### 方式 A：执行仓库脚本

```bash
powershell -ExecutionPolicy Bypass -File scripts/health-check.ps1
```

默认输出：`state.local.json`（与 `state.template.json` 同目录）。

可选参数：

- `-OutputPath <path>`：自定义输出位置
- `-TemplatePath <path>`：自定义模板位置

### 方式 B：AI 自行体检

AI 助手可以**不跑脚本**，自己用 OS 命令逐项查。但**最终产物必须是 `state.local.json`**，且字段结构对齐 `state.template.json`。

## 三、体检项

### 必查（10 大类）

| 大类 | 项 | 说明 |
|---|---|---|
| 系统 | OS / 版本 / 架构 | Windows / macOS / Linux 都查 |
| 磁盘 | 各盘 total/used/free，标 system vs data | C 盘是系统盘，D 盘起为数据盘 |
| 基础开发套件 | git / node / npm / python / uv / docker | 必装 vs 按需装 |
| AI 客户端 | Cursor / ZCode / Codex / Claude | 各自版本 + skills 目录 |
| 业务软件 | LM Studio / Ollama / PyCharm / VSCode / Firecrawl / FFmpeg / PowerToys | 大多按需 |
| 路径 | 软件根 / 下载 / 缓存 / 模型 / bin | 是否落在约定目录 |
| 环境变量 | 16 个缓存/模型变量 | 是否重定向到约定目标 |
| 网络 | GitHub / npm 可达性，镜像设置 | 装之前必查 |
| 仓库 | 本地克隆路径 / 分支 / 同步状态 | 同步的依赖 |
| skills 同步 | 每个 skill 在哪些客户端存在 | 核心规则 |

### 字段值约定

| 值 | 含义 |
|---|---|
| `true` | 明确查到存在 |
| `false` | 明确查到不存在 |
| `null` | 未知（查不到，不推测） |

体检脚本不会"如果找不到就标 false"——会标 null，让 AI 后续决策时知道"这是没查到的"。

## 四、state.local.json 字段说明

`state.local.json` 与 `state.template.json` 同结构，但填充了实际机器数据。

### 不进 Git 的字段（`.gitignore`）

| 字段 | 为什么 |
|---|---|
| `machine_id` | 含主机名/用户，识别具体机器 |
| `generated_at` | 时间戳，无长期价值 |
| 所有 `exe_path` / `*_dir` / `actual` | 绝对路径，因机器而异 |
| 所有 `version` | 因升级而变，污染 diff |
| `issues` | 临时状态，不应进仓库 |

### 进 Git 的字段（`state.template.json`）

| 字段 | 为什么 |
|---|---|
| 字段结构 | 决定 schema 兼容 |
| `required` / `expected` 枚举 | 决定策略 |
| 自研 skill / 远端 skill 列表 | 决定要装什么 |
| 角色 / 工作流描述 | 决定使用方式 |

## 五、issue 等级

体检发现偏差时，按严重度分 4 级：

| 等级 | 含义 | 场景 |
|---|---|---|
| ❌ missing | 必装项缺失 | 基础开发套件没装、关键工具缺失 |
| ⚠️ path | 路径不符约定 | 装在 C 盘、不在 `_caches/_models` 目录 |
| 🔧 env | 环境变量未重定向 | 缓存还指向 `%APPDATA%` |
| 🚨 risk | 高风险动作 | 需删数据、需改注册表、需改 PATH |

`state.local.json` 的 `issues` 数组就是这 4 类的清单。AI 在场景 1/2 看到 `🚨 risk` 时必须先列出来给用户确认。

## 六、典型使用流

### 场景 0（首次体检）

```text
用户: 按 skillsList 体检
AI:  (执行 health-check.ps1)  → state.local.json
AI:  已生成报告
     ✅ 已满足：git 2.37.1, Cursor 3.24.9, ...
     ❌ 缺失：node, npm, python, uv
     🔧 环境变量未重定向：CARGO_HOME, RUSTUP_HOME
     是否按此报告进入场景 1 安装？
```

### 场景 1（安装）

```text
用户: 确认安装
AI:  (基于 state.local.json 列出待办)
     1. 装 node / npm / python / uv → 落 D 盘
     2. 设 2 个未设的环境变量
     3. 同步自研 skills 到 Cursor / ZCode / Codex / Claude
     4. 装 13 个远端 skills
     高风险项：需新建 _caches/cargo 和 _caches/rustup
     是否继续？
用户: 继续
AI:  (执行，每步输出影响)  → 完成
AI:  (重跑体检)  → 新 state.local.json
AI:  本轮新增/失败/跳过的清单：
     ✅ node 22.11.0 装好
     ✅ skills 同步到 3/4 客户端（Claude 未装）
     ⚠️ openspec 未装（不在本次范围）
```

### 场景 2（同步）

```text
用户: 按 skillsList 同步
AI:  (git pull, 重跑体检, 对比新旧 state.local.json)
     Diff 摘要：
     - 新增项：find-skills 在仓库中标记为推荐
     - 变化项：product-design 版本从 1.0 → 1.1
     - 未变项：Cursor 3.24.9, git 2.37.1
     是否按 diff 同步？
```

## 七、扩展性

体检脚本接受 `-OutputPath` 和 `-TemplatePath` 参数，可以：

- 用同一模板给多台机器做体检（CI 场景）
- 在不同目录跑体检（用户偏好）
- 把模板复制成自定义版本（项目特例）

但**默认行为**就是"读 `state.template.json`，写 `state.local.json`"——保持简单。
