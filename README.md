# Claude Code Skills 个人使用清单

> 我的工作：企业内部数字化建设——需求与 PRD、交互与 UI 规范、内部工具、算力服务器管理、AI 辅助开发。
> 本清单按「**角色 → 工作流**」组织我的技能配置，配有一键安装和每日自动同步，任何新设备 3 条命令复刻整套环境。

## 角色总览

| 角色 | 技能 | 干什么 |
|------|------|--------|
| 🧭 产品 / 需求 | `clarify-first` → `product-design`（自研） | 模糊想法对齐 → 产出多角色 PRD |
| 🎨 交互 / 视觉设计 | owl-listener 七件 + `ui-ux-pro-max` + `frontend-design` + 动效两件 | 交互规格 → 视觉实现 → 交付自审 → 动效打磨 |
| 🛠 开发落地 | `openspec` + `agent-browser` | 规范驱动 AI 实现 → 浏览器自动化自测 |
| 🔍 调研 / 信息 | Firecrawl（30+ 子技能）+ `find-skills` | 网页调研、深度报告、发现新技能 |
| 🧠 通用沉淀 | `self-improving-agent` | 把纠错与踩坑沉淀为行为改进 |

每个角色的工作流、触发方式和示例见 [SKILLS_GUIDE.md](./SKILLS_GUIDE.md)。

## 🚀 新设备快速上手

前置：装好 [Git](https://git-scm.com) 和 [Node.js](https://nodejs.org)。

```bash
# 1. 克隆本仓库
git clone https://github.com/liaokehong/skillsList.git
cd skillsList

# 2. 一键安装全部技能（含自研技能）
bash install.sh                     # macOS / Linux / Git Bash
powershell -ExecutionPolicy Bypass -File .\install.ps1   # Windows

# 3. （可选）注册每天 09:00 自动同步
bash sync.sh --setup-cron           # macOS / Linux
powershell -ExecutionPolicy Bypass -File .\sync.ps1 -SetupTask   # Windows
```

安装完成后重启编辑器即可。Firecrawl 需在编辑器插件面板单独安装。

## 🔄 每日自动同步

自动同步做两件事：
1. `git pull` 拉取本清单最新版本（含自研技能更新）
2. `npx skills update -g` 把已安装的 skills.sh 生态技能更新到最新

手动触发一次同步：

```bash
bash sync.sh        # 或 Windows: powershell -ExecutionPolicy Bypass -File .\sync.ps1
```

日志写在 `sync.log`（已加入 .gitignore，不会被提交）。

## 📝 日常维护

在一台设备上修改清单或自研技能后推送，其他设备的每日同步会自动拉取：

```bash
git add -A && git commit -m "update skills list" && git push
```

## 文件结构

```
skillsList/
├── README.md                  # 本文件
├── SKILLS_GUIDE.md            # 完整技能清单（按角色 → 工作流组织）
├── skills/
│   ├── product-design/        # 自研：想法 → PRD
│   └── clarify-first/         # 自研：模糊需求对齐
├── install.sh / install.ps1   # 一键安装
├── sync.sh / sync.ps1         # 每日同步
└── LICENSE                    # MIT
```

## License

[MIT](./LICENSE)
