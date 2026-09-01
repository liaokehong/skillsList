# Claude Code Skills 个人使用清单

> 我在用的 8 类 Claude Code 技能/插件的个人使用清单：来源、安装、触发方式、使用示例。
> 配有一键安装脚本和每日自动同步，任何新设备 3 条命令即可复刻整套环境。

## 技能总览

| 技能 | 触发方式 | 用途场景 |
|------|----------|----------|
| **Superpowers** | `/superpowers:<skill>` 或自动 | 全流程开发（头脑风暴 / TDD / 调试 / 代码审查） |
| **OpenSpec** | CLI `openspec` 命令 | 规范先行开发（SDD） |
| **Remember** | 后台自动 | 跨会话记忆 |
| **Firecrawl** | `/firecrawl:<skill>` | 网页调研 / 爬取（30+ 子技能） |
| **Task Master** | CLI 或 MCP 自动 | 需求拆分 & 任务管理 |
| **基础四件套** | 自然语言触发 | 视觉设计 / 找 skill / 浏览器自动化 / 自我改进 |
| **交互设计包** | 点名触发（推荐） | 前端设计三阶段：交互规格 → 实现 → 自审 |
| **自研技能** | 自然语言触发 | 想法→PRD（product-design）、模糊需求对齐（clarify-first） |

## 🚀 新设备快速上手

前置：装好 [Git](https://git-scm.com) 和 [Node.js](https://nodejs.org)。

```bash
# 1. 克隆本仓库
git clone https://github.com/liaokehong/skillsList.git
cd skillsList

# 2. 一键安装全部技能
bash install.sh                     # macOS / Linux / Git Bash
powershell -ExecutionPolicy Bypass -File .\install.ps1   # Windows

# 3. （可选）注册每天 09:00 自动同步
bash sync.sh --setup-cron           # macOS / Linux
powershell -ExecutionPolicy Bypass -File .\sync.ps1 -SetupTask   # Windows
```

安装完成后重启编辑器即可。各技能怎么触发、怎么用，见 [SKILLS_GUIDE.md](./SKILLS_GUIDE.md)。

## 🔄 每日自动同步

自动同步做两件事：
1. `git pull` 拉取本清单最新版本
2. `npx skills update -g` 把已安装的 skills.sh 生态技能更新到最新

手动触发一次同步：

```bash
bash sync.sh        # 或 Windows: powershell -ExecutionPolicy Bypass -File .\sync.ps1
```

日志写在 `sync.log`（已加入 .gitignore，不会被提交）。

## 📝 日常维护

在一台设备上修改清单后推送，其他设备的每日同步会自动拉取：

```bash
git add -A && git commit -m "update skills list" && git push
```

## 文件结构

```
skillsList/
├── README.md          # 本文件
├── SKILLS_GUIDE.md    # 完整技能清单（8 类，含安装/触发/示例）
├── install.sh         # 一键安装（macOS / Linux）
├── install.ps1        # 一键安装（Windows）
├── sync.sh            # 每日同步（macOS / Linux）
├── sync.ps1           # 每日同步（Windows）
└── LICENSE            # MIT
```

## License

[MIT](./LICENSE)
