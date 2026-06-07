#!/bin/bash
cd ~/unfilter-collab
[ -n "$1" ] && printf '\n## %s\n%s\n' "$(date '+%F %H:%M')" "$1" >> LOG.md
git add -A && git commit -q -m "update $(date '+%F %H:%M')" && git push -q && echo "synced ✅"
