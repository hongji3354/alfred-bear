#!/bin/zsh --no-rcs
# 제목을 받아 같은 제목의 노트가 있으면 열고, 없으면 만들어서 편집 상태로 연다.
# ⌘로 고르면 new_window=1이 넘어와 새 창으로 연다.

bear=/Applications/Bear.app/Contents/MacOS/bearcli
title="$1"
open_opts=()
[[ "$new_window" == 1 ]] && open_opts+=(--new-window)

if id=$("$bear" show --title "$title" --format json --fields id | jq -er .id); then
  "$bear" app open "$id" $open_opts
else
  id=$("$bear" create "$title" --content "" --format json --fields id | jq -r .id)
  "$bear" app open "$id" --edit $open_opts
fi
