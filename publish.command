#!/bin/bash
# 在 macOS Finder 中双击即可发布；也可在终端传入提交说明。
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
status=0
/bin/bash "$script_dir/publish.sh" "$@" || status=$?
printf '\n按回车结束…'
read -r _
exit "$status"
