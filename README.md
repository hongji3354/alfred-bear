# alfred-bear

Bear 노트를 Alfred에서 검색하고 만드는 개인용 워크플로입니다.
Bear 앱에 들어 있는 공식 CLI인 `bearcli`를 사용해서, Bear 데이터베이스를 직접 읽지 않습니다.

## 사용법

| 키워드 | 동작 |
|---|---|
| `bs` | 최근 수정한 노트 목록 (고정한 노트가 맨 위) |
| `bs 검색어` | Bear 검색. Enter를 누르면 노트를 엽니다 |
| `bn 제목` | 같은 제목의 노트가 있으면 열고, 없으면 새로 만듭니다 |

`bs`는 Bear 검색 문법을 그대로 지원합니다.

- `#태그`: 태그가 붙은 노트
- `"정확한 문구"`: 문구가 그대로 들어간 노트
- `-제외어`: 그 단어가 없는 노트
- `@today`, `@last7days`: 오늘, 최근 7일 안에 수정한 노트

전체 문법은 [Bear 검색 안내](https://bear.app/faq/how-to-search-notes-in-bear/)를 참고하세요.

## 필요한 것

- Alfred (Powerpack)
- Bear (`bearcli`가 들어 있는 버전)
- `jq` (macOS 기본 포함)

## 설치

```sh
git clone git@github.com:hongji3354/alfred-bear.git ~/alfred-bear
ln -s ~/alfred-bear "$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences/workflows/user.workflow.alfred-bear"
```

Alfred 설정을 동기화 폴더에 두고 있다면 위 경로 대신 그 폴더 안의 `workflows`에 링크를 만드세요.

## 구조

| 파일 | 역할 |
|---|---|
| `search.zsh` | `bs` 검색 결과 만들기 |
| `open.zsh` | 고른 노트 열기 |
| `new.zsh` | `bn` 미리보기 ("새 노트 만들기" 또는 "기존 노트 열기") |
| `create.zsh` | 노트 만들기, 이미 있으면 열기 |
| `info.plist` | Alfred 워크플로 정의 (키워드와 연결) |
