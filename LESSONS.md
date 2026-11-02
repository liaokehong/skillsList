# LESSONS.md — 技巧与踩坑沉淀（时间线）

> 每日复盘产出。两类去处：**"以后都这么做"的习惯级结论进 [PREFERENCES.md](./PREFERENCES.md)**（规则，随时生效）；**具体事件/解法记录进本文件**（归档，带日期）。条目一律不含组织身份信息。合并进 main 后对全部设备、全部 AI 客户端可见。

## 2026-10-19 · 技能多客户端分发用 JUNCTION 单源模式

skills CLI（`npx skills add -g`）的做法值得沿用：真身只放 `~\.agents\skills\`（跨客户端通用目录），其他客户端目录（`.zcode\skills`、`.codex\skills`）建 JUNCTION 链接指向真身。单一数据源，内容天然一致，更新只需覆盖真身。PowerShell 建 Junction：`New-Item -ItemType Junction -Path <链接> -Target <真身>`（无需管理员权限）。

## 2026-10-20 · PS5.1 读无 BOM 文件 = GBK 乱码（双重表现）

同一根因两种症状：① 脚本文件含中文且无 BOM → 按语句解析失败；② `Get-Content` 读无 BOM 的 UTF-8 JSON → 中文乱码、`ConvertFrom-Json` 报错。解法：读文件一律 `-Encoding UTF8`；一次性脚本用纯 ASCII 写；JSON 校验用 `node -e "JSON.parse(...)"` 最稳。

## 2026-10-20 · Git Bash 调 PowerShell 的正确姿势

内联 `powershell -Command` 会被 bash 吃掉引号/`$`/反斜杠（本日两次踩坑：`\\$name` 未展开生成垃圾链接；`$env:` 被展开为空）。正确做法：整段单引号传给 PS，或写入临时 .ps1 再 `-File` 执行（PS 内变量自己展开）；Windows 路径在 bash 参数里用正斜杠。

## 2026-10-21 · C 盘以约 2.2G/天 的速度流失（待定位）

10-19 剩 18G → 10-20 剩 15.2G → 10-21 剩 13.6G，已破 15G 红线。已知排除项：16 个重定向环境变量全部生效、D 盘五件套正常。增长大头不在 watch 列表（Downloads/Temp/.cache 只占 ~10.5G 且基本稳定），候选：Windows 更新/还原点、pagefile/hiberfil 波动、某应用持续写 C 盘。已具备 c-disk-cleanup 技能，待跑阶段一分析定位。

**10-24 更新**：走势反转——10-22 剩 11.5G、10-23 剩 10.3G 后，10-24 回升到 16.1G（一夜 +5.8G，已用量 169.1→163.3G），释放原因未知（候选：存储感知自动清理、系统更新善后、手动清理）。结论修正：此前的"稳定流失"实为波动，-2.2G/天不是恒定速率；继续观察，若再次跌破 10G 跑阶段一定位。

## 2026-10-22 · 公开仓库 push 前保密扫描的实操命令

规则在 PREFERENCES.md（push 前必做），实操三步（仓库目录下，约 30 秒）：

1. **文件白名单**：`git diff --stat origin/<分支>..HEAD` —— 逐个核对只含预期文件，出现意外文件即停；
2. **敏感内容扫描**：`git grep -n -E "DESKTOP-|主机名|工号|内部域名" HEAD -- "*.md" "*.json"` —— 无输出才通过（正则按需扩充组织标识词表）；
3. **机器状态文件核查**：`git ls-files | grep state.local` 应为空——`.gitignore` 已排除，防止日后被误 `git add -f`。

首跑结果：三步全过，推送了 3 个提交；本条目与规则本身即该次沉淀的产物。

## 2026-10-23 · 自动化环境里 git 突报 dubious ownership

现象：每日自动化例行 `git pull` 突然失败——`fatal: detected dubious ownership in repository at 'D:/001_Software/env-manifest'`，前一天还正常。原因：仓库目录所有者与执行进程凭证不一致（git ≥2.35.2 的安全防护；本机疑似系统进程/杀软动过 ACL）。
解法（一次性，写用户级 `~/.gitconfig`）：`git config --global --add safe.directory D:/001_Software/env-manifest`。
排查提示：若报错提到的不是自己的仓库路径，先核实目录再添加例外，不要无脑加 `*`。

## 2026-10-24 · Windows 用户文件夹重定向到数据盘的正确姿势

目标：下载/文档等默认位置迁 G 盘（C 盘减负 + 用户数据归冷存储）。四步：

1. **前置检查**：读注册表 `HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders` 确认当前指向；**OneDrive 若已接管（路径含 OneDrive）不可直接改**，先解除同步；
2. **搬数据**：`robocopy <源> <目标> /E /MOVE /R:1 /W:1`——被占用文件会留下并计数，不硬来；
3. **改注册表**：User Shell Folders（ExpandString）与 Shell Folders（String）两处都写，Downloads 的键名是 GUID `{374DE290-123F-4565-9164-39C4925E467B}`；
4. **重启 explorer** 生效；浏览器若设过自定义下载路径需手动改回"默认"。

桌面**不迁**（高频活跃，留 SSD）。本次 Downloads / Documents / Pictures / Videos / Music 五个全迁，零锁定残留。

## 2026-10-26 · 每周清理首跑：回收站是被审计遗漏的大头

c-disk-cleanup 首次周清理释放 6.73G（C 盘 15.18→21.91G）。分项：用户 Temp >7d 删 449 项（~1.7G）、系统 Temp 84 项、崩溃转储/WER/D3DSCache 清零、浏览器纯缓存清空；**回收站贡献约 4.5G——但技能的阶段一审计清单没有"先量回收站"这一步**，导致预估与实际差距大。改进：审计阶段加 `回收站大小`（PowerShell 可用 Shell.Application COM 或逐盘 `$RECYCLE.BIN` 估算），周报才准。三级禁令照旧，未触碰任何用户数据。

**附**（C 盘追踪线，接 10-21 条）：10-25 回落至 15.0G 后，10-26 周清理释放 6.73G 回到 21.9G——波动确认为"日常缓慢增长 + 每周一次清理"的锯齿形稳态，观察继续。

**11-01 再更新**：又一次无主大额释放——10-31 剩 15.4G → 11-01 剩 29.2G（一夜 +13.8G，本机无清理动作；候选：Windows 更新善后、存储感知深度清理、用户在别处手动清理）。规律：两次大额自愈（10-24 +5.8G、11-01 +13.8G）均发生在周末，疑似系统级周期任务；对清理策略的影响是——**周一清理前的低点总在 15G 线附近被兜住，暂无真实耗尽风险**，继续观察即可，不升级干预。

**11-02 周清理第 2 轮**：高起点（29.4G）轻清理，仅释放 0.42G；审计阶段已按 10-26 教训补测回收站（本周 0.02G）。结论：**高频小清取代低频大清，锯齿稳态正式确认**——每周一清 + 周末系统自愈的组合下，C 盘在 15~30G 区间波动，无需升级干预。

**同日补记**（多端协作规则）：发现 10-24 下午"模型迁 G"当天 17:21 已被另一会话修订（活跃模型回 D、G 只归档，性能优先），但 localConfig/重定向脚本/客户端 AGENTS/记忆还停在旧口径——仓库内 PREFERENCES 是唯一事实源，**它变了之后所有仓库外的机器文件和记忆都要跟着对齐**，本次已全部修正。教训：改规则要有一个"机器侧同步清单"，否则半新半旧。


