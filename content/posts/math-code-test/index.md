---
title: "阅读、公式与代码块排版测试"
summary: "用于检查中文正文、标题、引用、表格，以及公式、代码高亮、行号、复制和长行滚动。"
date: 2026-10-08T10:00:00+08:00
categories: ["博客"]
tags: ["排版", "公式", "代码"]
draft: true
comments: false
ShowToc: true
TocOpen: false
---

这是一篇本地测试草稿。运行 `hugo server -D` 后可以查看，正式构建不会发布它。

## 中文正文

写博客的时候，最重要的往往是把一件事说清楚。一个问题是怎么出现的，试过哪些办法，最后又是怎样解决的——这些过程值得被认真记录，也值得被慢慢阅读。

阅读页面应该给文字留出空间。正文不必铺满整个屏幕，段落之间也不需要拥挤。合适的字号、行距与留白，可以让长文章读起来轻松一些，让读者把注意力放在内容本身。

这个测试页面把中文段落、引用、表格、数学公式和代码放在一起，方便检查不同内容之间的节奏。在电脑上，右侧目录可以直接跳转到某个章节；在手机上，目录会收起，点击「目录」即可展开。

### 引用与链接

> 把学到的东西写下来，把生活里的片刻留下来。
>
> 好的排版，让阅读成为一件自然的事。

正文中的[关于页面](/about/)和[文章归档](/archives/)应当容易辨认，键盘访问链接时也应看到焦点提示。

### 列表与表格

- 每个段落只说明一件事。
- 代码保留原始缩进和换行。
- 长公式、代码和表格在各自区域内滚动。

| 内容 | 检查重点 |
| --- | --- |
| 中文正文 | 字体、行距和段落间隔 |
| 数学公式 | 上下标、分数与长公式 |
| 代码块 | 高亮、行号与复制 |

## 行内公式

质能关系为 \(E = mc^2\)。中文段落中的公式应当与文字自然衔接，上下标 \(a_i^2 + b_i^2 = c_i^2\) 和分数 \(\frac{1}{2}\) 都应正常显示。

推荐使用 `\( ... \)` 写行内公式，避免把金额当成公式。比如 $5 和 $10 应保持普通文字，行内代码 `$HOME` 也应原样显示。

## 独立公式

用一对 `$$` 包裹公式，上下各留一个空行：

$$
x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
$$

积分、求和与希腊字母：

\[
\int_{-\infty}^{\infty} e^{-x^2}\,dx = \sqrt{\pi},
\qquad \sum_{n=1}^{\infty}\frac{1}{n^2} = \frac{\pi^2}{6}
\]

## 矩阵与多行推导

$$
A = \begin{bmatrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{bmatrix}
$$

$$
\begin{aligned}
(a+b)^2 &= (a+b)(a+b) \\
        &= a^2 + 2ab + b^2
\end{aligned}
$$

公式内部的下划线和星号应保持 LaTeX 含义，不被 Markdown 吞掉：\(x_i^* = \arg\min_{x_i} f(x_i)\)。

## 长公式

手机上可以在公式内部横向滚动，正文宽度应保持正常：

$$
\underbrace{a_1 + a_2 + a_3 + a_4 + a_5 + a_6 + a_7 + a_8 + a_9 + a_{10} + a_{11} + a_{12}}_{\text{a long expression}}
= \sum_{i=1}^{12} a_i
$$

## 代码高亮与复制

行内代码如 `hugo server -D`、`config.yml` 应使用等宽字体。

### Python

代码块右上角可以复制；复制结果应只有代码，不包含左侧行号。

```python
from math import sqrt


def solve_quadratic(a: float, b: float, c: float):
    """求一元二次方程的两个实数解。"""
    discriminant = b * b - 4 * a * c
    if discriminant < 0:
        raise ValueError("方程没有实数解")
    return ((-b + sqrt(discriminant)) / (2 * a),
            (-b - sqrt(discriminant)) / (2 * a))


print(solve_quadratic(1, -3, 2))
```

### JavaScript 与指定行高亮

在代码围栏后加上 `{hl_lines=[2,3]}`，即可强调关键行：

```javascript {hl_lines=[2,3]}
function greet(name) {
  const message = `你好，${name}！`;
  console.log(message);
}

greet("Ninuan");
```

### Shell 与特殊字符

美元符号和公式分隔符在代码块内应保持原样：

```bash
printf '%s\n' "$HOME"
printf '%s\n' '\(E = mc^2\)' '$$x_i^2$$'
hugo --minify
```

### 长代码行

代码保持原始换行；长行在块内横向滚动：

```json
{"title":"公式与代码块测试","description":"这是一行故意写得很长的 JSON，用于确认手机阅读时可以在代码块内部横向滚动，而不会把整个文章页面撑开。","features":["syntax highlighting","line numbers","copy button","horizontal scrolling"]}
```

### 纯文本与无语言代码块

不需要高亮的输出可以写成 `text`，也可以不写语言名：

```text
构建完成 ✓
公式：行内 / 独立 / 矩阵 / 多行
代码：高亮 / 行号 / 复制 / 滚动
```

```
<article>这里只是示例文本 & 不应被当作 HTML 执行。</article>
```

### 单独关闭行号

短命令可在围栏后加 `{linenos=false}`：

```bash {linenos=false}
hugo server -D
```

## 检查清单

- 切换浅色和深色主题，公式与代码仍然清晰。
- 所有公式都已排版，没有残留的 LaTeX 源码或错误提示。
- 代码复制后保留缩进、换行和特殊字符，不混入行号。
- 手机宽度下，长公式和长代码只在各自区域内滚动。
- 不带 `-D` 构建时，这篇测试草稿不会出现在首页、搜索或归档里。
