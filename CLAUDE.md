# alfred-bear

Bear 노트를 검색(`bs`)하고 만드는(`bn`) 개인용 Alfred 워크플로. drgrib/alfred-bear가 관리되지 않아 대신 만들었다. 기능을 많이 넣기보다 쓰면서 조금씩 고쳐 나가는 게 목적이다.

## 원칙
- Bear와는 `bearcli`(`/Applications/Bear.app/Contents/MacOS/bearcli`)로만 통신한다. Bear SQLite DB를 직접 읽지 않는다.
- 스크립트는 zsh + `jq`만 쓴다. 따로 설치해야 하는 의존성을 추가하지 않는다.
- 셔뱅은 `#!/bin/zsh --no-rcs`. 사용자 셸 설정에 영향받지 않게 한다.
- `bs`는 제목과 본문을 모두 검색한다. 원칙상 작은 정보는 대상 노트 본문에 적기 때문에 제목 검색만으로 바꾸지 않는다.
- `bs`는 입력을 Bear 검색 문법 그대로 넘긴다. `#태그`도 별도 처리 없이 노트 검색이 된다.
- 태그 목록을 보여 주는 태그 검색은 일부러 만들지 않았다. 사용자가 아직 태그를 쓰지 않는다. 태그가 많아지면 그때 추가한다.
- `bn`은 같은 제목의 노트가 있으면 새로 만들지 않고 기존 노트를 연다.
- ⌘+Enter로 고르면 새 창으로 연다. Script Filter 항목의 `mods.cmd`가 `new_window=1` 변수를 넘기고, `open.zsh`와 `create.zsh`가 이 값을 보고 `--new-window`를 붙인다. `info.plist`에는 ⌘(1048576) 연결이 따로 있다.
- 사용자는 한글로 노트를 쓴다. 문구와 주석은 한글로 쓴다.
- 입력은 `iconv -f UTF-8-MAC -t UTF-8`로 NFC로 바꾼 뒤 쓴다. 자모로 쪼개진 한글(NFD)은 Bear 검색과 제목 비교에서 일치하지 않는다.

## 구조
- `info.plist`: Alfred 정의. Script Filter와 Run Script 모두 External Script(type 8)로 같은 폴더의 `.zsh` 파일을 실행한다.
- `search.zsh` → `open.zsh`: `bs`. 결과 항목의 `arg`는 노트 ID다.
- `search.jq`: `bs` 결과 모양. 제목 일치를 위로 올리고 설명 줄에 `제목 일치` 또는 `내용 일치 (N곳)`을 붙인다. 본문 문장은 일부러 보여 주지 않는다(여러 곳에서 일치하면 한 문장만으로는 의미가 없다). bearcli 없이 가짜 JSON을 넣어 테스트할 수 있다.
- `new.zsh` → `create.zsh`: `bn`. 결과 항목의 `arg`는 제목이다.
- 설치는 Alfred workflows 폴더의 `user.workflow.alfred-bear` 심볼릭 링크가 이 저장소를 가리키는 방식이다. 파일을 고치면 Alfred에 바로 반영된다.

## 테스트
Script Filter는 터미널에서 바로 실행해 Alfred JSON을 확인한다.

```sh
./search.zsh "" | jq .
./search.zsh "검색어" | jq .
./new.zsh "제목" | jq .
```

`create.zsh`를 테스트하면 실제 Bear 노트가 생긴다. 테스트 노트는 확인 뒤 `bearcli trash <id>`로 휴지통에 보낸다.

## 커밋
- 커밋 메시지는 한글로 쓴다.
- `prefs.plist`(Alfred 개인 설정)는 커밋하지 않는다.
