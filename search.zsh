#!/bin/zsh --no-rcs
# bs: Bear 노트 검색. 입력을 Bear 검색 문법 그대로 bearcli에 넘긴다.
# 결과 항목의 arg는 노트 ID이고, open.zsh가 받아서 연다.

bear=/Applications/Bear.app/Contents/MacOS/bearcli
query="$1"
fields=id,title,modified,pins
limit=50

if [[ -z "$query" ]]; then
  result=$("$bear" list --limit $limit --format json --fields $fields)
else
  result=$("$bear" search --query "$query" --limit $limit --format json --fields $fields)
fi

print -r -- "$result" | jq '
  if type == "object" then
    {items: [{title: "검색 오류", subtitle: .error.message, valid: false}]}
  elif length == 0 then
    {items: [{title: "검색 결과 없음", subtitle: "다른 검색어를 입력하세요", valid: false}]}
  else
    {items: map({
      title: .title,
      subtitle: ((if (.pins | length) > 0 then "📌 " else "" end)
                 + (.modified | fromdateiso8601 | strflocaltime("%m/%d %H:%M")) + " 수정"),
      arg: .id
    })}
  end'
