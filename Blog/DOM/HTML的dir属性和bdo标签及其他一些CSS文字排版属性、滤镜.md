---
layout: post
title: "HTML的dir属性和bdo标签及其他一些CSS文字排版属性、滤镜"
date: "2009-04-14 16:06:56 +0800"
slug: "HTML的dir属性和bdo标签及其他一些CSS文字排版属性、滤镜"
category: "developer"
categories:
  - "developer"
tags:
  - "HTML"
permalink: "/2009/04/14/HTML的dir属性和bdo标签及其他一些CSS文字排版属性、滤镜/"
---

先看一下HTML4.0中定义的dir属性.对应有两个值ltr(默认值)和rlt。分别表示文本从左向右显示（dir=ltr）和文本从右向左显示（dir=rtl）。
文本从右向左显示的情况（dir=rtl）是考虑到一些特殊的文字书写方式（如古中文，希伯来文——但是我们古中文可不止是从右到左，还是从上到下书写的呢）。
先看一下Test

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
</head>
<body>
<p dir="rtl">
 一二三<br />
 abc<br/>
 a b c<br />
</p>
</body>
</html>
```
从这里看，觉得这和css的属性text-align:right，或则HTML中不推荐使用的属性align=right并没有什么区别啊。

这是因为受到了“各种用于语言编码的和显示的Unicode和ISO标准”的影响。整段文落都当成一个不可分割的整体了（不管是什么文字的）。
象数字和一些符号就能按空格分隔反排，体现出“从右向左”的显示：

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
</head>
<body>
<p dir="rtl">
a b c d / ?
</p>
<p dir="rtl">
11 12 13 14 / ?
</p>
</body>
</html>
```
除此之外，这个属性还能在ie下改变滚动条的位置，你见过滚动条显示在滚动内容的左侧的吗？
用ie看看下面的效果吧：

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
</head>
<body  >
<div dir="rtl" style="height:200px;width:500px;overflow:auto;border:1px solid #ccc;">
a
<br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
<br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
<br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
c
</div>
</body>
</html>
```
综上也可以看出，dir这个属性其实并不怎么好用。幸好我们也基本用不上这个属性。
要用我们也最好结合bdo这个标签来使用。

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
</head>
<body>
<bdo dir=rtl >
我是谁,who am I?
</bdo>
</body>
</html>
```
bdo标签必须要带dir属性一起使用。他产生的效果就不论是什么文字字母符号，都以单个字符为单位，颠倒顺序，从右往左显示（我们可以称为“反排效果”）,很彻底啊，我们可以看到，连连续书写的英文字母都被反写了。

现如今web标准化的春风吹遍大江南北，我们也要与时俱进，贯彻落实结构和表现分离的思想方针，加快发展可扩展性良好的web建设。
所以，除了语义化的结构外，我们还推荐将结构之外的表现用CSS属性来实现。
前面提到的html属性dir和<bdo>标签所能达到的反排效果，我们也可以使用两个CSS标准属性来实现。
第一个CSS属性：direction : ltr | rtl | inherit ——效果对应ＨＴＭＬ属性dir。
第二个CSS属性：unicode-bidi : normal | bidi-override | embed——其中的bidi-override属性值效果对应<bdo>标签。

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
</head>
<body>
<div style="direction:rtl; unicode-bidi:bidi-override;">
我是谁,who am I?
</div>
</body>
</html>
```
之前我们还说道古中文的写法并非只是单单的从右往左书写，同时也是由上往下书写的。那么有没有html属性或css属性能达到这个效果（可以称作文字竖排效果吧）呢？
css属性倒的确有，还不止一个。但很遗憾，都只是MS的推荐属性，并非W3C的标准属性。所以只有IE系列（ie5.5+）浏览器支持。
这两个属性分别是:
writing-mode : lr-tb | tb-rl ;
layout-flow : horizontal | vertical-ideographic ;

稍微演示一下

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
</head>
<body>
<div style="writing-mode:tb-rl;text-align:left;border:1px solid red;">
writing-mode设置或检索对象内文本的流动和方向。
当此属性值发生变化时，text-align属性与vertical-align属性的作用也将发生变化。
对应的脚本特性为layoutFlow。
</div>
<br />
<div style="layout-flow:vertical-ideographic;text-align:right;border:1px solid green;">
layout-flow设置或检索对象内文本的流动和方向。
当此属性值发生变化时，text-align属性与vertical-align属性的作用也将发生变化。
对应的脚本特性为layoutFlow。
</div>
</body>
</html>
```
个人觉得这两个属性，几乎没什么差别。。。
另外，当其高度不设定时。如何自适应的高度，很是令人迷惑。

再提一个不标准的东西——镜像翻转滤镜——只做了解，不建议使用。
前面我们有一个文字反排效果，那是排版上的。而使用这个滤镜呢，不单是排版上反过来了。连文字的显示都反过来了（镜像翻转效果）。——当然只支持ie系列（ie4+）。
滤镜有两个，一个是水平翻转滤镜：fliph。一个事垂直翻转滤镜flipv。
注：使用这个滤镜需要触发haslayout.

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<style type="text/css">
h2{zoom:1;}
</style>
</head>
<body>
<h2 style="filter:fliph()">左右翻转</h2>
<h2 style="filter:flipv()">上下翻转</h2>
</body>
</html>
```
提到这个翻转镜像效果，倒想起了自己之前的一个娱乐之作：重型7级absolute单层1像素真实web2.0渐变风格倒影字效果（全兼容） 。

文章到这里，我们已经提到了关于页面，文字排版相关的html属性，html标签，CSS属性以及CSS滤镜。除此之外，可以改变文字排版方式（文字反排）的还有一个RLO符。
请看：

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>RLO(right-to-left override)字符的演示</title>
</head>
<body>
<input type="text" value="&#8238;我从右往左？"/>
</body>
</html>
```
这个RLO符的unicode编码是：202E 。字符实体编号是：8238
可以参考这篇后文：JS实现字符unicode编码信息查询

最后，我们还要提一个由字体产生的文字侧倒的效果。
运行下如下代码：

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>文字侧倒</title>
</head>
<body>
<div style="font-family:'@宋体';" >1要吃饭我要吃饭</div>
<br />
<span style="font-family:'@黑体';">2我要吃饭我要吃饭我</span>
</body>
</html>
```
这个相信一些修改过QQ聊天字体的童鞋们也发现过，选择QQ聊天字体里这类前面带@符的字体就能打出侧倒的文字。
不过，这浏览器下显示，会有一些差异。比如FF下不支持，（我的）safari下不支持@宋体。
另外，还有些人反映自己的自己上根本没有效果。
