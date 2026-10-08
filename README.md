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
