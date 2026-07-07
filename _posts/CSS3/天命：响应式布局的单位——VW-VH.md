---
layout: post
title: "天命：响应式布局的单位——VW/VH"
date: "2016-12-30 13:22:11 +0800"
slug: "天命：响应式布局的单位——VW-VH"
category: "developer"
categories:
  - "developer"
tags:
  - "CSS3"
permalink: "/2016/12/30/天命：响应式布局的单位——VW-VH/"
---

所谓「天命」，是说有些单位生来就该做响应式的事。百分比依附于父级，em 依附于字号，而 vw 与 vh 只听命于一件事——viewport本身。

本文最早发布于知乎的一个回答：<a href="https://www.zhihu.com/question/37179916/answer/101810379" target="_blank" rel="noopener">vw相比rem，在实际开发中究竟有多大区别？</a>
几年前，人们谈论响应式布局的时候，必会提到一个单位：rem，其基于rem的布局思路影响一直持续到今天。那么rem是否是最好的呢？有没有更合理的布局结局方案呢？以下是原文：

我认为基于vw开发布局比基于rem不知道要高明到哪里去了。

vw可以轻松搞定弹性布局，流体布局。而网上那些吹捧rem的文章，所用的响应式适配方案都是基于弹性布局的。流体布局？人家说了，流体布局不好，见 <a href="https://isux.tencent.com/web-app-rem.html" target="_blank" rel="noopener">web app变革之rem</a>

vw逻辑非常清晰，”1vw ＝ 1/100th viewport width”，用viewport width的百分比来设置element width。rem是什么？“The font size of the root element”，就是说你用它来布局，就相当于用font size 来设置 width size，中间你要转一道。
基于以上，我也发出了题主的疑问，为什么rem这种单位会被用来布局，而vw这种天生的布局单位缺鲜有人关注？

所以今天深扒了一下关于这两个单位在 W3C组织 的邮件组里的讨论，
rem这个单位，我能找到的最早讨论是在2002年4月，一封比较各种样式语言的邮件中：http://lists.w3.org/Archives/Public/www-style/2002Apr/0010.html ，
<blockquote markdown="1">
CSS3 would just need a unit relative to the Root element's EM -- say, 'rem'
</blockquote>

之后有理由相信，rem最晚在2003年8月，已经被讨论组内人士所公认，并有可能已处在 w3c 工作组成员的笔记之中：http://lists.w3.org/Archives/Public/www-style/2003Aug/0044.html

<blockquote markdown="1">
According to my experience, when some authors look for exotic ways to define size of some element, it really comes to trying to define size of that element relative to viewport size. Nowadays, one has to use percentages and carefully compute size of every element from root to the element one wants to set size for. This is logical addition to 'rem' unit (root's em).
</blockquote>

邮件的作者此时也提出了两个单位：

<blockquote markdown="1">
vpw: viewport width
vph: viewport height
</blockquote>

仔细一看，这不就是现在的vw 和 vh 么。

其实，再早半年，也已经有人提出了与 vw 和 vh 接近的概念：http://lists.w3.org/Archives/Public/www-style/2003Feb/0110.html

<blockquote markdown="1">
The unit should be relative to the screen (or paper) width.
The unit should be referenced to the preferred screen resolution.

I suggest those units:
sw8 = (screen.width / 800 ) px;
sw12 = (screen.width / 1200 ) px;
sw16 = (screen.width / 1600 ) px;
sw24 = (screen.width / 2400 ) px;
</blockquote>

2005年3月，从一封讨论CSS运算表达式的邮件里 http://lists.w3.org/Archives/Public/www-style/2005Mar/0057.html 可以确定 vw 已基本被定下，同时被定下的还有vh 和 vm (也就是后来的vmin)：

<blockquote markdown="1">
the working group recently decided to investigate the implications of allowing simple, linear expressions as values.

Some common cases can be done without expressions, by means of a few new units:

gd = the grid unit from CSS3 Text
rem = the font size of the root element
vw = the viewport width (or 1/100th of it)
vh = the viewport height (or 1/100th of it)
vm = min(vw, vh)
</blockquote>

当然

<blockquote markdown="1">
There is not even a draft yet, though.
</blockquote>
不过话音刚落，到了当年7月26日，working draft 发布： CSS3 Values and Units

此次是第二次发布CSS3 Values and Units草案，距离首次发布已经过去整整4年，显而易见： ren, vw, vh, vm 是同时进的草案。

之后，2012年3月8日，vm 更改为 vmin。2012年8月28日，发布Candidate Recommendation（备选标准），增加 vmax。截止到现在，CSS3 Values and Units依然处于备选标准阶段，并不是一个正式标准，CSS Values and Units Module Level 3。

但俨然它是一个事实标准，因为浏览器厂商从来不是等标准确定后才付之实施，否则就会落后于人。我猜也不乏浏览器厂家在事先实现了某个features，继而正式递交工作组要求成为标准的，当然大多数浏览器厂商本身就是标准制定组成员。所以，虽然同时进入标准，rem 和 vw 的命运还得看浏览器厂家们是否积极去实现。

我们来看看 rem 和 vw 在 Moliza 家的待遇：
2009-01-05：有用户提交bug要求支持rem：472195 – support css3 root em (‘rem’ or ‘re’) units
2009-07-11：有用户提交bug要求实现vw：503720 – Implement vw/vh/vmin/vmax (viewport sizes) from CSS 3 Values and Units
相差半年
2010-1-21: Firefox3.6发布，支持rem：Firefox 3.6 for developers
2013-2-19: Firefox 19发布，支持vw：Firefox 19 for developers
晚了三年

其它各家皆是如此，厚此而薄彼，就导致了如下的支持度差异：
rem：
<img src="https://pic2.zhimg.com/b4f035b1007996aba311cab004425179_b.png" alt="">
vw:
<img src="https://pic4.zhimg.com/a6df85f2f4c38db8ff30da6f5276362f_b.png" alt="">

回到原题，vw被支持的太晚是其并不流行的根本原因，而当时移动端web app/page的开发需求已经十分旺盛，弹性布局是一种不错的移动端界面兼容展现方式，对于rem机遇就此而来，便成为一个实现弹性布局效果的极佳方案。

其实看目前状况，对vw最不利的是Android Browser，据我调查Android Browser 4.4以下的还占全部Android Browser的 9% 左右, 这个量还是不容忽视的。

好在既然所有最新浏览器都已经支持，那么随着时间推移，相信未来vw必将会流行。
