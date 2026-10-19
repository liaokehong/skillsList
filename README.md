# env-manifest

> **个人开发环境与 AI 技能清单**。规则统一，机器状态各自不同——所有机器共用本仓库，每台机器的本地状态在 `state.local.json`（不进 Git）。
>
> 核心文件：[`AGENTS.md`](./AGENTS.md)（AI 执行指令）· [`SKILLS_GUIDE.md`](./SKILLS_GUIDE.md)（技能清单）· [`HEALTH_CHECK.md`](./HEALTH_CHECK.md)（体检流程）· [`state.template.json`](./state.template.json)（检查模板）· [`PREFERENCES.md`](./PREFERENCES.md)（用户习惯）

## 🤖 AI 助手请先读

当用户用任何方式提到本仓库时，**按 [AGENTS.md](./AGENTS.md) 的 5 个场景自动执行**，不要反复问"你要干什么"。新电脑从 GitHub 地址开始，AI 先取得仓库、再读取规则、再体检本机：

| 场景 | 触发口令 | 状态 |
|---|---|---|
| 0 体检 | "按 env-manifest 体检" / "配置这台新电脑" | 只读 |
| 1 安装 | "按 env-manifest 安装" | 写入 |
| 2 同步 | "按 env-manifest 同步" | 写入 |
| 3 定时 | "每天同步 env-manifest" | 注册 |
| 4 上传 | "把新技能收录进 env-manifest" | 写仓库 |

⚠️ 本仓库是**清单 + 检查模板**，不含任何脚本——体检、安装、同步由 AI 读 [AGENTS.md](./AGENTS.md) 和 `state.template.json` 按本机情况自行设计步骤执行。`skills/` 目录只有 3 个自研技能，其余 14 个技能需要从远程注册表（skills.sh / npm）安装。

## 💬 人类怎么用

把下面的话发给你的 AI 编码助手（ZCode / Cursor / Codex 等）：

```text
帮我按照 https://github.com/liaokehong/env-manifest 配置这台电脑（先体检再装）
```

新电脑没有本地仓库时，AI 客户端先使用自身可用的网络和系统工具取得 Git，再把仓库克隆到本机合适的软件目录。不能假定 `D:\001_Software\env-manifest` 已经存在；实际路径由体检结果确定，并写入本机 `state.local.json`。

```text
按 env-manifest 体检并输出配置方案，暂不执行
```

```text
按 env-manifest 同步并检查这台电脑
```

```text
每天早上 9 点帮我同步 env-manifest
```

```text
把 XXX 技能收录进 env-manifest
```

## 仓库结构

```
env-manifest/
├── AGENTS.md                 ← AI 执行指令（5 场景）
├── README.md                 ← 本文件：入口 + 人类口令
├── SKILLS_GUIDE.md           ← 完整技能清单（按角色 → 工作流）
├── HEALTH_CHECK.md           ← 体检流程文档
├── state.template.json       ← 检查清单模板（进 Git）
├── PREFERENCES.md            ← 用户习惯唯一事实源（进 Git）
├── skills/                   ← 自研技能（随仓库分发）
│   ├── product-design/
│   ├── clarify-first/
│   └── c-disk-cleanup/
└── LICENSE
```

`state.local.json` 在 `.gitignore` 里——每台机器体检后生成自己的，不提交。体检、安装、同步均无固定脚本，由 AI 按模板与本机情况设计步骤。

## 数据流向

- **主端（重度使用端）**：日常重度使用 + **信息上传**——清单修改、新技能沉淀在主端完成并推送到 GitHub。
- **其他设备**：纯**消费**——发安装 / 同步口令即可，不需要改仓库。
- **GitHub 仓库是唯一事实源**：任何端产生的变更都回传仓库，其他端一次同步即得。

## 外部信息隔离

本仓库对外公开。任何提交、文档、示例、技能输出、提交说明和生成文件都严格禁止出现所属组织的名称、部门、内部系统、项目代号、内部域名、账号、工号、办公地点或可反推组织身份的术语。不确定时使用通用占位符或删除相关内容。

进 Git 的（仓库内容）：

- 基础开发套件清单
- 软件安装规则
- 缓存/下载路径规则
- AI 客户端与技能的关系
- 网络适配规则
- 体检流程
- 安装/同步/复检流程
- 用户偏好（不绑定机器）
- 对外信息隔离规则
- 通用技能源文件

不进 Git 的（每台机器独立）：

- 电脑名称
- 实际盘符
- 每个软件的真实安装路径
- 已安装版本
- 当前磁盘空间
- 当前网络
- 已安装的 AI 客户端
- 该电脑的配置目录
- 该电脑的本地体检结果

隔离方式：`state.template.json` 进 Git；`state.local.json` 不进 Git（`.gitignore`）。

## License

[MIT](./LICENSE)
