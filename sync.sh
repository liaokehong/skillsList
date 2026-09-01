#!/usr/bin/env bash
# 每日同步脚本（macOS / Linux）
# 手动同步:   bash sync.sh
# 注册每天 09:00 自动同步:  bash sync.sh --setup-cron
# 取消自动同步:  crontab -e 删除 skillsList 那一行

set -u
repo="$(cd "$(dirname "$0")" && pwd)"
log="$repo/sync.log"

sync_once() {
    {
        echo "===== $(date '+%Y-%m-%d %H:%M:%S') ====="
        git -C "$repo" pull --ff-only 2>&1
        npx skills update -g 2>&1
        echo ""
    } >> "$log"
}

if [ "${1:-}" = "--setup-cron" ]; then
    # 旧的同类条目先移除，避免重复
    (crontab -l 2>/dev/null | grep -v "skillsList.*sync.sh" ; \
     echo "0 9 * * * cd $repo && bash sync.sh >> /dev/null 2>&1 # skillsList") | crontab -
    echo "[OK] 已注册每日 09:00 自动同步 (crontab)"
else
    echo "==> 拉取最新清单 + 更新已安装技能..."
    sync_once
    echo "[OK] 同步完成，详情见 sync.log"
fi
