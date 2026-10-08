#!/bin/bash
set -euo pipefail

usage() {
    printf '用法：bash publish.sh ["提交说明"]\n'
    printf '先检查 Hugo 构建，再提交全部源码改动并推送当前分支到 origin。\n'
}

fail() {
    printf '发布失败：%s\n' "$1" >&2
    exit 1
}

if [[ $# -gt 1 ]]; then
    usage >&2
    exit 1
fi
if [[ ${1:-} == "--help" || ${1:-} == "-h" ]]; then
    usage
    exit 0
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

command -v git >/dev/null 2>&1 || fail "没有找到 Git。"
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || fail "请把脚本放在博客仓库中。"
branch="$(git symbolic-ref --quiet --short HEAD)" || fail "当前没有检出分支，请先切回 main。"
git remote get-url origin >/dev/null 2>&1 || fail "没有配置 origin 远程仓库。"
[[ -z $(git ls-files --unmerged) ]] || fail "请先解决 Git 合并冲突。"

# Finder 启动的终端可能没有 Homebrew 的 PATH。
if command -v hugo >/dev/null 2>&1; then
    hugo_bin="$(command -v hugo)"
elif [[ -x /opt/homebrew/bin/hugo ]]; then
    hugo_bin=/opt/homebrew/bin/hugo
elif [[ -x /usr/local/bin/hugo ]]; then
    hugo_bin=/usr/local/bin/hugo
else
    fail "没有找到 Hugo。macOS 可以运行 brew install hugo 安装。"
fi

build_dir="$(mktemp -d "${TMPDIR:-/tmp}/blog-publish.XXXXXX")"
trap 'rm -rf -- "$build_dir"' EXIT

printf '\n检查博客构建…\n'
if ! "$hugo_bin" --minify --noBuildLock --destination "$build_dir/public" --cacheDir "$build_dir/cache"; then
    fail "Hugo 构建未通过，尚未添加文件或创建提交，请先修正文章或配置。"
fi

printf '\n添加博客改动…\n'
git add --all
if git diff --cached --quiet; then
    printf '没有新的改动，继续推送已有提交。\n'
else
    commit_message="${1:-更新博客：$(date '+%Y-%m-%d %H:%M')}"
    git diff --cached --stat
    git commit -m "$commit_message" || fail "无法创建提交，请检查 Git 的报错；已添加的改动仍然保留。"
fi

printf '\n推送到 origin/%s…\n' "$branch"
if ! git push --set-upstream origin "$branch"; then
    fail "GitHub 推送未成功，本地提交已保留。请根据上方报错检查网络、登录或远程更新，处理后重新运行此脚本。"
fi

printf '\n已推送到 GitHub（%s）。\n' "$branch"
if [[ $branch == main ]]; then
    printf 'Cloudflare Pages 将按现有配置自动构建上线。\n'
fi
