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

## 一键提交与发布

写完文章后，先将文章 Front Matter 的 `draft` 改为 `false`，保存文件。
macOS 可以在 Finder 中双击根目录的 `publish.command`，自动检查构建、添加改动、提交并推送到 GitHub。
也可以在博客目录的终端运行：

```bash
bash publish.sh
```

默认提交说明是「更新博客：日期 时间」。想自定义说明时：

```bash
bash publish.sh "发布文章：我的新博客"
```

脚本会提交整个仓库的新增、修改和删除，包括文章图片、配置、样式和脚本；
`public/`、`resources/` 等被 `.gitignore` 忽略的生成文件不会提交。
构建检查在临时目录进行，不会发布草稿，也不会自动把草稿改为正式文章。

脚本使用当前 Git 的 GitHub 登录配置，推送当前分支到 `origin`。
本项目在 `main` 分支推送后，Cloudflare Pages 会按现有配置自动部署。
无新改动时不会创建空提交，但会继续推送上次尚未推送成功的提交。
构建失败时不会添加文件或创建提交；推送失败时会保留本地提交，处理报错后重新运行即可。

## 目录结构

```
├── archetypes/      # 新文章模板（hugo new 时自动套用）
├── config.yml       # 站点配置（中文、CJK、搜索、目录、RSS 开关都在这）
├── content/posts/   # 你的文章（Markdown）
└── themes/PaperMod/ # 主题（git submodule，不建议直接改）
```

想小改样式但不动主题源码：把主题里对应的文件复制到站点根目录同名路径覆盖，
比如自定义 head 加 CSS 就新建 `layouts/partials/extend_head.html`。

本项目使用 Hugo `0.167.0`，语言配置使用 `locale: zh-CN`。
`layouts/baseof.html`、`layouts/rss.xml` 和 `layouts/_partials/templates/opengraph.html`
覆盖了主题中的旧语言接口，避免 Hugo 0.158 以后出现弃用警告。
升级 PaperMod 时，可以对照这三个覆盖模板同步主题的新改动。

## 阅读风格

阅读样式参考 [Dejavu 的文章页](https://blog.dejavu.moe/posts/how-i-built-my-personal-blog/)，
使用暖色背景、系统衬线字体、720px 正文宽度和 1.8 倍行距，同时支持深色模式。
字体使用系统中的宋体类字体，具体字形会随设备变化，无需下载远程字体。

- `assets/css/extended/reading.css`：正文、标题、首页列表、目录和手机样式。
- `layouts/_partials/toc.html`：宽屏右侧目录；不足 1280px 时改为正文前的折叠目录。
- `i18n/zh-cn.yaml`：中文阅读时间、字数、复制按钮等文案。

文章默认显示日期、阅读时间和字数，隐藏作者重复署名、面包屑和分享按钮。
需要展开手机目录时，在文章 Front Matter 中设置 `TocOpen: true`；
不需要目录时设置 `ShowToc: false`。
阅读样式的测试内容位于 `content/posts/math-code-test/index.md`，保持为草稿。

## 个人信息

首页使用 PaperMod 的 `homeInfoParams` 显示简短介绍，下方继续显示文章列表。
个人信息的编辑位置：

- `config.yml` 中的 `params.author`：文章署名和网页作者信息。
- `params.description`：站点简介；`params.homeInfoParams`：首页标题和介绍，支持 Markdown。
- `params.socialIcons`：首页邮箱、GitHub、RSS 等链接；只添加希望公开的信息。邮箱使用 `mailto:` 链接。
- `content/about/index.md`：「关于」页面的完整介绍。

「关于」页面会出现在顶部导航中，不作为文章出现在首页列表、文章归档或 RSS 中。
新文章默认沿用全站作者；需要单独署名时，在文章 Front Matter 中添加 `author`。

## 公式与代码块

公式在构建时由 Hugo 内置的 KaTeX 渲染，保留 MathML 供辅助技术读取。
无需在文章里添加 `math: true`，有公式的文章会自动加载 KaTeX 样式（固定版本的 jsDelivr CDN，含完整性校验）。
参考 [Hugo 官方说明](https://gohugo.io/functions/transform/tomath/)。Cloudflare 的 `HUGO_VERSION` 保持为 `0.167.0`。

行内公式写成 `\(E = mc^2\)`。独立公式使用 `$$ ... $$` 或 `\[ ... \]`，分隔符上下各留空行：

```text
$$
x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
$$
```

行内不启用 `$ ... $`，因此金额 `$5`、`$10` 可以直接写。代码围栏和行内代码中的公式标记不会被渲染。
无效公式会让构建失败，并在日志中给出文章位置，方便发布前修正。

代码围栏注明语言（如 `python`、`javascript`、`bash`、`json`）；默认显示语法高亮、行号和复制按钮。
长行在代码块内部滚动。围栏语言后可添加 `{hl_lines=[2,3]}` 强调指定行，或 `{linenos=false}` 关闭行号。
不需要高亮时，使用 `text` 或不指定语言。

测试文章保存在 `content/posts/math-code-test/index.md`，默认为草稿：

```bash
hugo server -D
```

打开 http://localhost:1313/posts/math-code-test/，检查公式、代码复制、主题切换和窄屏滚动。
正式构建 `hugo --minify` 不会发布这篇草稿；想公开展示时，将文章的 `draft` 改为 `false`。
