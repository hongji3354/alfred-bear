#!/bin/zsh --no-rcs
# 노트 ID를 받아 Bear에서 연다. ⌘로 고르면 new_window=1이 넘어와 새 창으로 연다.

if [[ "$new_window" == 1 ]]; then
  /Applications/Bear.app/Contents/MacOS/bearcli app open "$1" --new-window
else
  /Applications/Bear.app/Contents/MacOS/bearcli app open "$1"
fi
