#!/bin/zsh --no-rcs
# 제목을 받아 같은 제목의 노트가 있으면 열고, 없으면 만들어서 편집 상태로 연다.

bear=/Applications/Bear.app/Contents/MacOS/bearcli
title="$1"

if id=$("$bear" show --title "$title" --format json --fields id | jq -er .id); then
  "$bear" app open "$id"
else
  id=$("$bear" create "$title" --content "" --format json --fields id | jq -r .id)
  "$bear" app open "$id" --edit
fi
