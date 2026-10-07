# 我的博客

Hugo + PaperMod 主题的个人博客架子（参考 [Dejavu Moe 的建站文章](https://blog.dejavu.moe/posts/how-i-built-my-personal-blog/)）。

## 先改这两个地方

1. `config.yml` 顶部的 `baseURL`：改成你的域名（Cloudflare Pages 会先给你一个 `*.pages.dev` 的免费域名）
2. `config.yml` 的 `title`：改成你的博客名

## 本地运行

先装 Hugo（要 extended 版）：

- Windows（Scoop）：`scoop install hugo-extended`
- macOS：`brew install hugo`

然后：

```bash
git clone --recurse-submodules <你的仓库地址> blog
cd blog
hugo server -D
```

打开 http://localhost:1313 预览。写新文章：`hugo new posts/文章名/index.md`。

> 已验证：Hugo v0.167.0 + PaperMod 最新 master 可正常构建。

## 部署到 Cloudflare Pages（免费）

1. 把这个仓库推到 GitHub
2. Cloudflare 后台 → Pages → 连接 GitHub 仓库
3. 构建设置：框架选 Hugo，构建命令 `hugo --minify`，输出目录 `public`
4. 环境变量加一个：`HUGO_VERSION = 0.167.0`
5. 每次 `git push` 后自动重新构建上线

自定义域名可以在 Pages 项目里直接添加，域名托管在 Cloudflare 的话 DNS 会自动配好。

## 目录结构

```
├── archetypes/      # 新文章模板（hugo new 时自动套用）
├── config.yml       # 站点配置（中文、CJK、搜索、目录、RSS 开关都在这）
├── content/posts/   # 你的文章（Markdown）
└── themes/PaperMod/ # 主题（git submodule，不建议直接改）
```

想小改样式但不动主题源码：把主题里对应的文件复制到站点根目录同名路径覆盖，
比如自定义 head 加 CSS 就新建 `layouts/partials/extend_head.html`。
