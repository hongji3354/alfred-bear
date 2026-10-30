# bearcli search 결과(JSON 배열)를 Alfred Script Filter JSON으로 바꾼다.
# $q: 사용자가 입력한 검색어 (NFC)
#
# - 제목에 검색어가 있는 노트를 위로, 본문에만 있는 노트를 아래로 두고
#   설명 줄 앞에 `제목 일치` 또는 `내용 일치 (N곳)`을 붙인다.
# - 본문 문장은 보여 주지 않는다. 여러 곳에서 일치하면 한 문장만으로는 의미가 없어서다.

# Bear 검색 문법에서 제목·본문과 맞춰 볼 일반 단어만 뽑는다. #태그, @조건, -제외어, or는 뺀다.
def terms:
  [scan("\"[^\"]+\"|\\S+")]
  | map(select(test("^[-#@!]") | not) | gsub("\""; "") | ascii_downcase)
  | map(select(length > 0 and . != "or"));

def contains_any($terms): ascii_downcase as $s | any($terms[]; . as $t | $s | contains($t));

# 제목 줄을 뺀 본문에서 검색어가 들어간 줄 수
def content_hits($terms): .content | split("\n") | .[1:] | map(select(contains_any($terms))) | length;

($q | terms) as $terms
| if type == "object" then
    {items: [{title: "검색 오류", subtitle: .error.message, valid: false}]}
  elif length == 0 then
    {items: [{title: "검색 결과 없음", subtitle: "다른 검색어를 입력하세요", valid: false}]}
  else
    map(
      (if ($terms | length) == 0 then null      # 빈 검색, #태그·@조건만 있는 검색
       elif (.title | contains_any($terms)) then "제목 일치"
       else content_hits($terms) as $n
            | "내용 일치" + if $n > 1 then " (\($n)곳)" else "" end
       end) as $label
      | . + {label: $label})
    | (map(select(.label != null and (.label | startswith("제목"))))
       + map(select(.label == null or (.label | startswith("내용")))))
    | {items: map({
        title: .title,
        subtitle: ((if (.pins | length) > 0 then "📌 " else "" end)
                   + (if .label then .label + " · " else "" end)
                   + (.modified | fromdateiso8601 | strflocaltime("%m/%d %H:%M")) + " 수정"),
        arg: .id,
        mods: {cmd: {arg: .id, subtitle: "새 창으로 열기", variables: {new_window: "1"}}}
      })}
  end
