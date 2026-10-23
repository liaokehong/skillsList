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


