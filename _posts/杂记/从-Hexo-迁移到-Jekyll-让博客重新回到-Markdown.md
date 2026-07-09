---
layout: post
title: "从 Hexo 迁移到 Jekyll：让博客重新回到 Markdown"
date: "2026-07-09 10:45:00 +0800"
slug: "从-Hexo-迁移到-Jekyll-让博客重新回到-Markdown"
category: "developer"
categories:
  - "developer"
tags:
  - "Jekyll"
  - "Hexo"
  - "Obsidian"
  - "GitHub Pages"
permalink: "/2026/07/09/从-Hexo-迁移到-Jekyll-让博客重新回到-Markdown/"
---

这次把博客从 Hexo 迁移到 Jekyll，动机不是“换一个静态生成器玩玩”。真正想解决的，是写作源文件应该放在哪里、以什么格式保存、由谁来构建，以及以后还能不能舒服地继续写下去。

我希望最后得到的是这样一个工作流：

1. 本地只用 Obsidian 写 Markdown。
2. GitHub 仓库里管理的是 Markdown、主题、插件这些源文件，而不是渲染后的 HTML。
3. push 到 GitHub 之后，GitHub Actions 自动构建并部署到 GitHub Pages，网站仍然可以通过 `github.io` 或自定义域名访问。
4. 旧文章里的图片、诗词卡片和可运行代码块，在 Obsidian 里能看，在网页上也能保持原来的效果。

换句话说，这次迁移不是把 Hexo 的目录翻译成 Jekyll 的目录，而是把博客重新整理成一个“可写、可管、可部署”的 Markdown 仓库。

## 先说清楚：不是 Hexo 只能管 HTML

以前我对 GitHub Pages + Hexo 的印象，是仓库里常常放着一堆生成后的 HTML。后来想想，这并不完全是 Hexo 的问题，更像是部署方式造成的错觉。

Hexo 本身当然也是从 Markdown 生成静态页面。只是很多旧的 Hexo 部署方式，会在本地执行 `hexo generate`，再把 `public` 目录里的 HTML 推到 `gh-pages` 或发布分支。这样一来，GitHub 上看到的就主要是构建产物，而不是写作源文件。

我这次想要的正好相反：仓库的主分支保存源文件，构建产物不进 Git。发布时由 GitHub Actions 在服务器上跑 Jekyll，生成 `_site`，再把 `_site` 作为 Pages artifact 发布出去。[GitHub Pages 可以从分支发布，也可以用 GitHub Actions 工作流发布](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)；[Jekyll 又是 GitHub Pages 原生支持很好的静态站点生成器](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)，所以这条路比较顺。

最终仓库里关键的东西大概是这些：

- `_posts/`：真正写作的 Markdown，可以直接作为 Obsidian vault 使用。
- `_layouts/`、`_includes/`、`assets/`：主题结构、样式和脚本。
- `_plugins/`：迁移 Hexo 自定义标签，以及为了 Obsidian 做的兼容逻辑。
- `.github/workflows/deploy.yml`：push 后自动构建和部署。
- `_site/`：本地预览时生成，但不提交到 Git。

这就把“写文章”和“发网站”分开了：写作时只关心 Markdown，发布时再让 CI 负责把它变成网页。

## 文章文件：让 Jekyll 接受没有日期前缀的文件名

Jekyll 默认要求 `_posts` 里的文章文件名带日期，比如 `2026-07-09-title.md`。但我的旧文章已经有大量中文标题文件，而且 Obsidian 里看文章时，文件名前面挂一串日期也不是很舒服。

所以我保留了文章内部的 front matter：

    ---
    layout: post
    title: "从 Hexo 迁移到 Jekyll：让博客重新回到 Markdown"
    date: "2026-07-09 10:45:00 +0800"
    slug: "从-Hexo-迁移到-Jekyll-让博客重新回到-Markdown"
    category: "developer"
    categories:
      - "developer"
    tags:
      - "Jekyll"
      - "Hexo"
      - "Obsidian"
    permalink: "/2026/07/09/从-Hexo-迁移到-Jekyll-让博客重新回到-Markdown/"
    ---

然后写了一个小的 [Jekyll 插件](https://jekyllrb.com/docs/plugins/)，让 `_posts` 下的 Markdown 即使文件名没有 `YYYY-MM-DD-` 前缀，也能被当成文章读取。发布日期、URL 和排序都交给 front matter 里的 `date` 与 `permalink`。

这样做之后，Obsidian 里看到的就是干净的文章标题，Git 里保存的也是干净的 Markdown。

## 图片：跟着文章走，而不是散在一堆静态目录里

Obsidian 管理文章时，图片最好离文章近一点。比如一篇文章的 `slug` 是：

    一-如何计算年化收益——复利公式

那图片就放在同目录下的同名文件夹里：

    _posts/经济/一-如何计算年化收益——复利公式.md
    _posts/经济/一-如何计算年化收益——复利公式/1.webp
    _posts/经济/一-如何计算年化收益——复利公式/2.webp

文章里用相对路径引用：

    ![七日年化截图](一-如何计算年化收益——复利公式/1.webp)

这样 Obsidian 能直接显示图片。Jekyll 构建时，再通过插件把这些图片作为文章资源发布到最终文章 URL 下。写文章时不用想着站点根目录，也不用手动把图片搬到 `assets/images` 之类的公共目录。

这个改动很小，但写作体验变化很大：一篇文章就是一个 Markdown 文件加一个素材文件夹。以后迁移、备份、整理，都不需要顺着网页路径去找图。

## runcode：从 Liquid 标签变成 Obsidian 也认识的代码块

以前我写过一个 Hexo 插件：[hexo-runcode](https://github.com/NeoWangs/hexo-runcode)。它的作用很简单：在文章里放一段 HTML/CSS/JS，网页上显示成一个可以点击运行的代码框。

旧写法是 Hexo 的标签：

{% raw %}
    {% runcode %}
    <!doctype html>
    <html>
    <body>
      <h1>Hello</h1>
    </body>
    </html>
    {% endruncode %}
{% endraw %}

这个写法在网页里没问题，但在 Obsidian 里很尴尬。Obsidian 不知道这种 Liquid 标签是什么，它既不能当代码块高亮，也不能自然折叠、复制、编辑。

迁移到 Jekyll 后，我保留了 Liquid block，保证旧文章不至于立刻坏掉。同时增加了一种新的 Markdown 写法：

    ```html runcode
    <!doctype html>
    <html>
    <body>
      <h1>Hello</h1>
    </body>
    </html>
    ```

在 Obsidian 里，它就是一个普通的 HTML 代码块；在 Jekyll 构建时，插件会在 `pre_render` 阶段扫描带有 `runcode` 标记的 fenced code block，把它转换成网页上的运行框。前端脚本再负责 `Run` 和 `Copy` 两个按钮。

这就是我最满意的迁移方式：写作源文件优先符合 Markdown 习惯，网站效果通过构建阶段增强，而不是把作者绑在某个生成器的私有语法上。

## pin：从 Hexo 诗词卡片迁移成 Obsidian Callout

另一个旧插件是 [hexo-pin](https://github.com/NeoWangs/hexo-pin)。它原来用来把诗词排成卡片瀑布流，旧写法大概是这样：

{% raw %}
    {% pin 静夜思 [唐]李白 %}
    床前明月光，
    疑是地上霜。
    举头望明月，
    低头思故乡。
    {% endpin %}
{% endraw %}

这个效果在网页上很好看，但对 Obsidian 不友好。于是迁移时我把它改成了 Obsidian Callout 风格：

    > [!pin] 《静夜思》 [唐]李白
    > 床前明月光，
    > 疑是地上霜。
    > 举头望明月，
    > 低头思故乡。

Obsidian 会把它当成一个 callout 显示，编辑时很自然。Jekyll 插件则在构建前把 `[!pin]` 转成原来的卡片结构，再在渲染后把连续的 pin 包进 `.hexo-pin-wrap`，交给前端脚本做瀑布流布局。

这个转换还有一个好处：旧的视觉效果保住了，但 Markdown 文件变得更像 Markdown。以后即便不用 Jekyll，至少在 Obsidian 里读起来仍然是完整的。

## 部署：主分支保存源文件，Actions 负责发布

部署部分我没有再走“本地构建后提交 HTML”的路，而是让 GitHub Actions 做完整流程：

1. checkout 当前仓库。
2. 安装 Ruby 和 Bundler。
3. 执行 `bundle exec jekyll build` 生成 `_site`。
4. 生成旧路径重定向，兼容过去 `/blog/`、`/Drive2Far/` 之类的访问路径。
5. 上传 Pages artifact。
6. 用 `actions/deploy-pages` 发布。

这样 GitHub 里保存的仍然是 Markdown 和主题源码，HTML 只是一次构建的结果。构建失败就修源码，构建成功就自动上线。

对于博客这种长期写作项目，这一点很重要。文章源文件应该是第一等公民，而不是静态网站生成过程里的中间材料。

## 迁移之后的日常

现在写文章的流程就很朴素：

1. 打开 Obsidian。
2. 在 `_posts` 里新建 Markdown。
3. 图片放到文章同名目录，用相对路径引用。
4. 需要可运行代码时写 `html runcode` 代码块。
5. 需要诗词卡片时写 `[!pin]` callout。
6. commit，push。

后面的事交给 GitHub Actions。

这次迁移最好的地方，是它没有让写作变得更复杂。相反，它把原来散落在静态生成器、部署脚本、发布分支里的心智负担，重新收回到 Markdown 文件里。

博客当然最后还是会变成 HTML，毕竟网页就是这么来的。但对我来说，真正值得管理、值得保存、值得多年以后还能打开继续编辑的，是这些 Markdown。Jekyll 只是负责把它们送到网页上；Obsidian 负责让我愿意继续写；GitHub 负责留下每一次修改的痕迹。

这样就够了。
