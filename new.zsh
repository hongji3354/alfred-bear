#!/bin/zsh --no-rcs
# bn: 입력한 제목의 노트가 이미 있으면 열기, 없으면 새로 만들기를 미리 보여준다.
# 결과 항목의 arg는 제목이고, create.zsh가 받아서 처리한다.

bear=/Applications/Bear.app/Contents/MacOS/bearcli
# 자모로 쪼개진 한글(NFD)이 들어와도 기존 제목과 맞춰 볼 수 있게 NFC로 바꾼다.
title=$(print -rn -- "$1" | iconv -f UTF-8-MAC -t UTF-8)

if [[ -z "$title" ]]; then
  jq -n '{items: [{title: "새 노트 제목을 입력하세요", valid: false}]}'
  exit
fi

if "$bear" show --title "$title" >/dev/null 2>&1; then
  action="기존 노트 열기"
else
  action="새 노트 만들기"
fi

jq -n --arg t "$title" --arg a "$action" '{items: [{
  title: $t,
  subtitle: $a,
  arg: $t,
  mods: {cmd: {arg: $t, subtitle: ($a + " (새 창)"), variables: {new_window: "1"}}}
}]}'
