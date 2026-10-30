#!/bin/zsh --no-rcs
# bs: Bear 노트 검색. 입력을 Bear 검색 문법 그대로 bearcli에 넘긴다.
# 결과 항목의 arg는 노트 ID이고, open.zsh가 받아서 연다. 결과 모양은 search.jq가 만든다.

bear=/Applications/Bear.app/Contents/MacOS/bearcli
# 자모로 쪼개진 한글(NFD)이 들어와도 Bear가 찾을 수 있게 NFC로 바꾼다.
query=$(print -rn -- "$1" | iconv -f UTF-8-MAC -t UTF-8)
limit=50

if [[ -z "$query" ]]; then
  result=$("$bear" list --limit $limit --format json --fields id,title,modified,pins)
else
  result=$("$bear" search --query "$query" --limit $limit --format json --fields id,title,modified,pins,content)
fi

print -r -- "$result" | jq --arg q "$query" -f "${0:A:h}/search.jq"
