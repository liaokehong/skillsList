# Health Check（体检流程）

> env-manifest 仓库把"新电脑从零开始"做成可重复的标准化流程。本文档解释体检是什么、查什么、输出什么、怎么用。
>
> **本仓库不含任何脚本。** 体检由 AI 助手读取 `state.template.json` 的字段清单，按本机实际情况自行设计检查步骤完成。

## 一、体检的目的

**新电脑 = 状态未知**。AI 助手在没有体检报告之前，不能瞎装东西。体检 = 用只读方法生成一份"机器现状 JSON"，让 AI 知道：

- 已经装了什么
- 装在哪里
- 缺什么
- 什么路径不对
- 网络是否通
- skills 同步到哪些客户端了

体检**只读**：不改注册表、不删文件、不装软件。

## 二、执行方式（AI 自主，无脚本）

AI 助手读 `state.template.json`，逐字段用本机命令检查，示例命令按平台自选：

| 平台 | 工具/版本 | 磁盘 | 用户级环境变量 |
|---|---|---|---|
| Windows | `where` / `Get-Command` / `(Get-Item).VersionInfo` | `Get-PSDrive` | `[Environment]::GetEnvironmentVariable(name, 'User')` |
| macOS / Linux | `which` / `<tool> --version` | `df -h` | `printenv` / `~/.zshrc` 等 |

**最终产物必须是 `state.local.json`**（与模板同目录，`.gitignore` 已排除），字段结构对齐 `state.template.json`：

- 只填查到的真实值；查不到填 `null`，不推测
- 找不到 ≠ 不存在——只有明确确认"没有"才填 `false`

## 三、体检项

### 必查（10 大类）

| 大类 | 项 | 说明 |
|---|---|---|
| 系统 | OS / 版本 / 架构 | Windows / macOS / Linux 都查 |
| 磁盘 | 各盘 total/used/free，标 system vs data | C 盘是系统盘，D 盘起为数据盘 |
| 基础开发套件 | git / node / npm / python / uv / docker / Windows Terminal | 必装 vs 按需装 |
| AI 客户端 | Cursor / ZCode / Codex | 各自版本 + skills 目录 |
| 业务软件 | LM Studio / Ollama / PyCharm / VSCode / Firecrawl / FFmpeg / PowerToys | 大多按需 |
| 路径 | 软件根 / 下载 / 缓存 / 模型 / bin | 是否落在约定目录 |
| 环境变量 | 16 个缓存/模型变量 | 是否重定向到约定目标 |
| 网络 | GitHub / npm 可达性，镜像设置 | 装之前必查 |
| 仓库 | 本地克隆路径 / 分支 / 同步状态 | 同步的依赖 |
| skills 同步 | 每个 skill 在哪些客户端存在 | 核心规则：所有客户端完全一致 |

### 字段值约定

| 值 | 含义 |
|---|---|
| `true` | 明确查到存在 |
| `false` | 明确查到不存在 |
| `null` | 未知（查不到，不推测） |

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
用户: 按 env-manifest 体检
AI:  （按 state.template.json 逐项体检，AI 自选本机命令）→ state.local.json
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
     1. 装 node / npm / python / uv → 落数据盘
     2. 按 env_vars 表设置未设的环境变量
     3. 同步自研 skills 到 Cursor / ZCode / Codex
     4. 装 14 个远端 skills
     高风险项：需新建 _caches/cargo 和 _caches/rustup
     是否继续？
用户: 继续
AI:  (执行，每步输出影响)  → 完成
AI:  (重跑体检)  → 新 state.local.json
AI:  本轮新增/失败/跳过的清单：
     ✅ node 22.11.0 装好
     ✅ skills 同步到 3/3 客户端
     ⚠️ openspec 未装（不在本次范围）
```

### 场景 2（同步）

```text
用户: 按 env-manifest 同步
AI:  (git pull, 重体检, 对比新旧 state.local.json)
     Diff 摘要：
     - 新增项：find-skills 在仓库中标记为推荐
     - 变化项：product-design 版本从 1.0 → 1.1
     - 未变项：Cursor 3.24.9, git 2.37.1
     是否按 diff 同步？
```

## 七、扩展性

默认行为就是"读 `state.template.json`，写 `state.local.json`"——保持简单。

- **多机器**：同一模板适用于任何机器；AI 按平台（Windows / macOS / Linux）自行选择检查命令，模板不含任何机器特定数据
- **自定义检查范围**：AI 可按用户要求只查部分字段（如只查技能同步），产物仍是同结构的 `state.local.json`
- **不引入脚本**：如果发现自己在重复某套固定命令，应把规则沉淀进模板/文档（场景 4），而不是写脚本
