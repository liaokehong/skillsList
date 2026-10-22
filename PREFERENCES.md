# PREFERENCES.md — 个人使用习惯（唯一事实源）

> 跨设备、跨客户端的用户习惯。随仓库分发；每台机器的 AI 客户端应把这些**内化到自己的持久记忆**（用户级 AGENTS.md / 客户端 memory 机制），内化步骤见 AGENTS.md 场景 1。外部信息隔离规则同样适用于本文件：禁止出现组织身份相关信息。

## 工具与安装

- Python 一律优先 uv（包管理器优先级 uv > pip）；全局 CLI 工具优先 npm（`npm i -g`）
- 便携版 > 安装器；单文件工具进软件根的 `bin`；一切"会长大"的（缓存/模型/下载）落数据盘——各机实际路径以 `state.local.json` 的 `paths` 为准
- 镜像不全局写死，按项目/按需开（网络慢时：pip→aliyun、npm→npmmirror、HuggingFace→hf-mirror）

## 协作风格

- 目标明确且有常规方案：直接选默认方案执行，完成后汇报"选了什么、为什么"；仅不可逆/破坏性操作、真正的范围变更、纯偏好才询问
- git：commit 后必须给用户审摘要，审过才 push；永不自动 push；commit 后要**主动询问**是否推送，不等用户想起
- 定时任务一律用 AI 客户端自身 automation 能力，不建 shell 脚本任务、不写系统计划任务
- 删除/清理：先分析后动手，每次删除必有大小和性质依据；文件被占用 = 正在使用 = 跳过
- 沉淀/记忆类写入（LESSONS、PREFERENCES、长期记忆）必须把实际内容原文展示给用户过目，不能只报条数

## 磁盘清理偏好（配合 c-disk-cleanup 技能）

- 休眠文件 hiberfil.sys：未经用户当次明确决定绝不处理；一旦用户明确保留，即写入永久禁令，此后不再建议关闭休眠
- WinSxS 只允许 DISM 正规清理，永不手动删
- 三级内容（系统/用户数据）永不自动删除，仅列清单供用户决定

## Windows 细节

- PowerShell 脚本含中文时保存为带 BOM 的 UTF-8 或纯 ASCII（避免 PS5.1 乱码）
- PowerShell 5.1 读取无 BOM 的 UTF-8 文件（如 JSON）必须加 `-Encoding UTF8`，否则按 GBK 解码中文会乱码甚至解析失败；对 JSON 校验优先用 `node -e "JSON.parse(...)"`
- 在 Git Bash 里拼 Windows 路径/变量易踩 `$` 与反斜杠转义坑：优先整段单引号交给 PowerShell 处理
- 批量删除前先确认目标真实存在与大小，防止路径变量展开错误
