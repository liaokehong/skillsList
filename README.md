# skillsList

> **个人开发环境与 AI 技能清单**。规则统一，机器状态各自不同——所有机器共用本仓库，每台机器的本地状态在 `state.local.json`（不进 Git）。
>
> 核心文件：[`AGENTS.md`](./AGENTS.md)（AI 执行指令）· [`SKILLS_GUIDE.md`](./SKILLS_GUIDE.md)（技能清单）· [`HEALTH_CHECK.md`](./HEALTH_CHECK.md)（体检流程）· [`state.template.json`](./state.template.json)（检查模板）

## 🤖 AI 助手请先读

当用户用任何方式提到本仓库时，**按 [AGENTS.md](./AGENTS.md) 的 5 个场景自动执行**，不要反复问"你要干什么"：

| 场景 | 触发口令 | 状态 |
|---|---|---|
| 0 体检 | "按 skillsList 体检" / "配置这台新电脑" | 只读 |
| 1 安装 | "按 skillsList 安装" | 写入 |
| 2 同步 | "按 skillsList 同步" | 写入 |
| 3 定时 | "每天同步 skillsList" | 注册 |
| 4 上传 | "把新技能收录进 skillsList" | 写仓库 |

⚠️ 本仓库是**清单 + 检查模板**，不是技能包也不是安装脚本。`skills/` 目录只有 2 个自研技能，其余 13 个技能需要从远程注册表（skills.sh / npm）安装。

## 💬 人类怎么用

把下面的话发给你的 AI 编码助手（ZCode / Cursor / Codex / Claude 等）：

```text
帮我按照 https://github.com/liaokehong/skillsList 配置这台电脑（先体检再装）
```

```text
按 skillsList 体检并输出配置方案，暂不执行
```

```text
按 skillsList 同步并检查这台电脑
```

```text
每天早上 9 点帮我同步 skillsList
```

```text
把 XXX 技能收录进 skillsList
```

## 仓库结构

```
skillsList/
├── AGENTS.md                 ← AI 执行指令（5 场景）
├── README.md                 ← 本文件：入口 + 人类口令
├── SKILLS_GUIDE.md           ← 完整技能清单（按角色 → 工作流）
├── HEALTH_CHECK.md           ← 体检流程文档
├── state.template.json       ← 检查清单模板（进 Git）
├── skills/                   ← 自研技能（随仓库分发）
│   ├── product-design/
│   └── clarify-first/
├── scripts/
│   └── health-check.ps1      ← 只读体检脚本（生成 state.local.json）
└── LICENSE
```

`state.local.json` 在 `.gitignore` 里——每台机器体检后生成自己的，不提交。

## 数据流向

- **主端（重度使用端）**：日常重度使用 + **信息上传**——清单修改、新技能沉淀在主端完成并推送到 GitHub。
- **其他设备**：纯**消费**——发安装 / 同步口令即可，不需要改仓库。
- **GitHub 仓库是唯一事实源**：任何端产生的变更都回传仓库，其他端一次同步即得。

## 外部信息隔离

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
