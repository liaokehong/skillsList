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
