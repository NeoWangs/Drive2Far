---
layout: post
title: "说说HTML5"
date: "2009-09-04 16:14:59 +0800"
slug: "说说HTML5"
category: "developer"
categories:
  - "developer"
tags:
  - "HTML"
  - "DOM"
  - "HTML5"
permalink: "/2009/09/04/说说HTML5/"
---

html5如何而来？
HTML isn’t a very good language！它亟待改进。
因此，1999年W3C停止了HTML的工作，2000年发布xhtml的第一个推荐版本。
2002年W3C发布XHTML 2.0第一个草案，令人吃惊的是：XHTML2.0不是向后兼容的（Web 的未来：XHTML 2.0(2003.1.1)）。
随着XHTML的越来越火，绝大多数人都认为它将是web的未来。然而终于有些人坐不住了，面对W3C对HTML的持续冷淡，2004年，由Apple, Mozilla Foundation 和Opera Software组成了The Web Hypertext Application Technology Working Group (WHATWG)，致力于发展HTML和创建Web applications所需的APIs。他们开始制定Web Applications 1.0 规范，这也就是后来HTML5。
WHATWG的努力没有白费，这份规范的草案在2007年通过了W3C的审核。
W3C组织了HTML工作组，并在2008年1月22日公开了第一份草案。
2009年7月2日，W3C宣布在年内停止XHTML 2的工作，而将资源投入转向HTML5工作组。（XHTML 2 Working Group Expected to Stop Work End of 2009, W3C to Increase Resources on HTML 5）
在标准化的春风吹满神州之际，xhtml2却溘然而止,HTML5取代上位，我们广大的web工作者是不是需要做什么呢？

我们不需要做什么！
HTML5 的目标是保持HTML当前标准HTML4.01和HTML的XML版本XHTML1.0 向后兼容。
同以前的HTML4一样：它没有名称空间或模式、元素不必结束、浏览器会宽容地对待错误。
对于XHTML1，它也没有什么排斥。
相反的，XHTML2才是不向后兼容的。
所以，我们并不需要非得做什么改变，才能适应在HTML5下面的页面工作。
当然HTML5不会仅仅如此而已，只是HTML5是想让不支持它的浏览器中能够平稳地退化。
随着浏览器的缓慢升级，HTML5的真正好处才会开始慢慢体现，当别人的网页通过html5实现了越来越多的功能之后。到时，你再虑是不是需要做什么——理论上讲，也是不晚的。
我们不需要做什么，但我们可以做的更多

HTML5能做什么？
一句话：很多！HTML5还在草案阶段，他的功能仍将扩展。
首先，我们应该知道，html5已经不只是Hypertext Markup Language，它更是一种Web Hypertext Application Technology。

1. html5增加了一些结构性（Sections）元素：header,footer,nav,section,article,aside，用来替代千篇一律的div布局，非常语义化。

2. 还有meter（数值尺），progress(进度表)，mark（标记）这些语义内联元素。通过自带的属性，可以进行很直接地描述。

3.一些交互元素。details（脚注），datagrid（网格控件——可动态显示树、列表和表格），menu和command（可以做交互菜单）

4. 媒体元素video,audio,source。不需要借助第三方插件，页面就能播放多媒体。

5. canvas元素。脚本绘图，它的最终目标是flash般的动画展示和交互体验。不要以为很遥远，canvas在FireFox1.5就有了，opera,safari也是一样支持甚早（这个标签是就是苹果的发明）。

6. 表单处理功能。HTML5吸收了WHATWG之前的Web Forms 2.0。验证数据是如此简单。

7. 页面元素的拖曳和编辑。

8. HTML5的离线存储技术 http://dev.w3.org/html5/webstorage/

好了， HTML5能做的够多了，但他还处在草案阶段，那关键是现在我们能做什么呢？

我们能做什么？
HTML5估计能在2012年之前成为W3C的候选推荐标准，不过在这之前，只要浏览器支持，我们都可以使用html5的功能。

1. HTML5新元素布局。
除了ie系列浏览器外，其它大多数浏览器都能识别HTML5的那些新元素标签，可以对其进行style，这就意味着它们可以使用HTML5的新元素标签进行页面布局。
但问题是ie系列浏览器是无法对其不承认的元素添加样式的，而缺少了IE的支持，大多数人都会束手束脚。解决这个问题的方法早已经了:HTML5 Shiv
很简单:
```html runcode
<script>
document.createElement("元素名称")
</script>
```
创建文档元素。
批量创建的方法:
```html runcode
(function(){
    if(!/*@cc_on!@*/0) return;
    var html5 = "abbr,article,aside,audio,bb,canvas,datagrid,datalist,details,dialog,event,source,figure,footer,hgroup,header,mark,menu,meter,nav,output,progress,section,time,video".split(',');
    for(var i = 0, len = html5.length; i < len; i++ ) {
    document.createElement(html5[i]);
    }
})
();
```
现在在IE里也可以对HTML5元素进行布局了。
不过，在此之前，我们还需要对这些新元素定义基本的Display style,
这个工作本来一般是由浏览器完成的，比如FireFox的html.css。
现在只能自己对引进的HTML5元素进行定义了。
那么哪些需要定义成display:block;哪些又是不需要呢？这个我们可以看下W3C是怎么定义的：display-types

```html runcode
address, article, aside, blockquote, body, center, dd, dialog, dir,
div, dl, dt, figure, footer, form, h1, h2, h3, h4, h5, h6, header,
hgroup, hr, html, legend, listing, menu, nav, ol, p, plaintext, pre,
section, ul, xmp { display: block; }
```

刨除HTML老元素，以下这些元素:
article,aside,dialog,figure,footer,header,hgroup,nav,section可以定义为{display:block;}
这篇针对HTML 5 Reset Stylesheet的文章也可以参考下：http://html5doctor.com/html-5-reset-stylesheet/。文章在Eric的CSS Reset的基础上考虑HTML5新元素及W3C规范推荐下对元素进行了style reset。当然reset CSS本身就存在争议的，一般来说，reset CSS是你自己的style，很多东西都可以按你的意愿来定，当然不要太偏离W3C的元素设计本意。
接下来，使用HTML5新元素进行布局就可以随心所欲了（还是悠着点好）。
```html runcode
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>HTML5新标签试用</title>
<style type="text/css">
html,body,div,span,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,abbr,address,cite,code,del,dfn,em,img,ins,kbd,q,samp,small,strong,sub,sup,var,b,i,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td,article,aside,dialog,figure,footer,header,hgroup,menu,nav,section,time,mark,audio,video{margin:0;padding:0;border:0;outline:0;font-size:100%;vertical-align:baseline;background:transparent;}
body {font:normal 12px/140% Georgia,Tahoma,Verdana,Arial,sans-serif;}
article,aside,dialog,figure,footer,header,hgroup,nav,section{display:block;}
ul,ol{list-style:none;}
blockquote, q{quotes:none;}
blockquote:before, blockquote:after,q:before, q:after {content:'';content:none;}
a {margin:0;padding:0;border:0;font-size:100%;vertical-align:baseline;background:transparent;}
ins{background-color:#ff9;color:#000;text-decoration:none;}
mark{background-color:#ff9;color:#000;font-style:italic;font-weight:bold;}
del{text-decoration: line-through;}
abbr[title], dfn[title]{border-bottom:1px dotted #000;cursor:help;}
table {border-collapse:collapse;border-spacing:0;}
hr{display:block;height:1px;border:0;border-top:1px solid #ccc;margin:1em 0;padding:0;}
input,select{vertical-align:middle;}
/* reset over */
body{overflow-x:hidden;}
header{height:60px;background:#669bb7;position:fixed;_position:absolute;left:0;width:100%;}
h1{font:bold 40px/110% Georgia;text-align:center;border-bottom:10px dashed #fff;}
h1 a{text-decoration:none;position:relative;}
h1 span{color:#000;zoom:1;opacity:0.5;filter:alpha(opacity=50);}
h1 b{position:absolute;left:0;margin-left:-2px;margin-top:-1px;color:#fff;cursor:pointer;}
.main{min-width:400px;max-width:970px;overflow:hidden;margin:0 auto;padding-top:70px;_margin:0 20px;}
aside{background:#e2ebf0;float:left;width:160px;padding:5px;margin-right:10px;display:inline;}
.portrait{width:132px;margin:0 auto;padding:5px;text-align:center;border-bottom:1px solid #c0d6df;}
.portrait img{display:block;width:120px;height:180px;padding:3px;background:#fff;border:4px solid #e3e3e3;border-left:2px solid #e0e0e0;border-top:1px solid #e3e3e3;margin-left:1px}
.portrait span{line-height:150%;cursor:help;}
aside nav{padding:5px 10px;}
aside nav li{font-size:14px;line-height:150%;}
aside nav li a{text-decoration:none;color:#005eac;}
section{border-top:20px solid #fff;margin-left:20px;background:#f6f6f6;padding:10px;padding-left:20px;}
article h2{font-size:18px;text-align:center;}
article h2 a{color:#73a6bc}
article h3,article p{margin:8px 0;}
dialog time{padding-left:10px;font-style:italic;}
footer{clear:both;text-align:center;sss}
</style>
<script type="text/javascript">
(function(){
if(!/*@cc_on!@*/0) return;
var html5 = "abbr,article,aside,audio,bb,canvas,datagrid,datalist,details,dialog,eventsource,figure,footer,hgroup,header,mark,menu,meter,nav,output,progress,section,time,video".split(',');
for(var i = 0, len = html5.length; i < len; i++ ) {document.createElement(html5[i]); }})();
</script>
</head>
<body>
<header>
	<h1><a href="http://www.cssass.com" target="_blank"><span>CSSASS</span><b>CSSASS</b></a></h1>
</header>
<div class="main">
<aside>
<figure class="portrait">
	<img alt="A boy named oneboys said he is The One."  src="http://center.blueidea.com/data/avatar/000/36/17/22_avatar_middle.jpg" />
	<!-- <legend>ONEBOYS</legend>  legend标签在html5之前是只允许作为fieldset的第一个子元素的，所以加在这里会出错。无法实现。我们还是用span来代替-->
	<span>ONEBOYS</span>
</figure>
<nav>
	<ul>
		<li><a href="#">首页</a></li>
		<li><a href="#">我的主页</a></li>
		<li><a href="#">个人资料</a></li>
		<li><a href="#">心情日志</a></li>
	</ul>
</nav>
</aside>
<section>
	<article class="article1">
        <h2><a href="http://html5doctor.com/html-5-reset-stylesheet/" target="_blank">HTML 5 Reset Stylesheet</a></h2>
        <p>We’ve had a number of people asking about templates, boilerplates and styling for HTML 5 so to give you all a helping hand and continue on from those basic building blocks that Remy talked about last week I’ve created a HTML 5 reset stylesheet for you to take away and use, edit, amend and update in your projects.</p>
		<p>Based on Eric Meyers CSS reset, I’ve made a few adjustments from Erics work that we’ll get to later but first here’s the file in full and we’ll then break it down step by step.</p>
		<h3>So what’s new then?</h3>
		<p>Well firstly, I’ve removed those elements that have been deprecated from the HTML 5 specification such as &lt;acronym&gt;, &lt;font&gt; and &lt;big&gt; (We’ll cover deprecated elements in more detail in another post). I’ve added in the the new HTML 5 elements to the reset, to remove any default padding, margin and borders. I’ve then added the explicit display:block declaration for those elements that are required to render as blocks.</p>
		<p>I’ve also removed the :focus part from Eric’s stylesheet. There are two reasons for this; the first is that by declaring outline:0 you remove the focus identifier for keyboard users. The second is that although Eric released his stylesheet in good faith that people would edit it and style :focus, they don’t. You will also notice that I’ve set defaults for <ins>&lt;ins&gt</ins>; as I don’t think they got updated very often in Eric’s styles either.</p>
		<p>Another change from Eric’s stylsheet is that I decided to remove the lines that remove bullets from lists, the reason for this is purely personal. I tend to only add the list style back in when using Erics reset anyway. I have however included nav ul {list-style:none;} to at least remove those pesky bullets from your navigation. </p>
		<h3>Using attribute selectors</h3>
		<p>You’ll notice that I’ve included attribute selctors for <abbr title="缩写：abbreviation">&lt;abbr&gt;</abbr> and <dfn>&lt;dfn&gt;</dfn>, the reason for this is I only want the style to appear if there is a title attribute to be displayed. The reason for this is primarly for accessibility. For example we use &ltabbr&gt regularly on this site but don’t always include a title attribute, that’s because it’s safe to assume all (no matter what device they are using) our readers know what HTML is, however we need to still include &ltabbr&gt to make sure screenreaders read the text as H-T-M-L rather than “HTML” which they struggle to pronounce.</p>
		<h3>What’s that bit about mark?</h3>
		<p><mark>&lt;mark&gt</mark>; is a new element introduced in HTML 5 used to (you guessed it) mark text in a document. The spec describes <mark>&lt;mark&gt</mark>; as “The mark element represents a run of text in one document marked or highlighted for reference purposes, due to its relevance in another context.”. I anticipate this it will be used for highlighting phrases in search results and similar. We’ll have more on this in a post soon.</p>
		<h3>Where are all those application elements?</h3>
		<p>“Application elements” is the term I’ve used to loosely describe those elements such as &lt;datagrid&gt;, &lt;datalist&gt; etc. Basically those that you are likely to find in web apps rather than websites. These have been left out because at the current time hardly any of what was ‘Web Applications 1.0′ has been implemented by browsers. Also this reset is primarily aimed at those serving their pages as text/html not xml.</p>
		<h3>Go grab it</h3>
		<p>So that basically wraps it up, it’s released under a creative commons license and you can use it for both personal and commercial work. I thought I’d let Google take care of the hosting so go grab it from Google Code and let me know of any thoughts, queries or improvements you can offer.</p>
	</article>
</section>
</div>
<footer>Copyright © 2009 Cssass.com </footer>
</body>
</html>
```
2. Drag & drop
Drag & drop是浏览器支持度比较高的HTML5内容：
```html runcode
<!DOCTYPE HTML>
<html>
<head>
  <title>Drag and Drop</title>
  <style>
   div {margin: 1em 2em; border: black solid;text-align: center;float:left;height: 9em; width: 12em; }
	img {width:4em;float:left; }
	p{clear:left;}
  </style>
 </head><body>
  <h1>Drag and Drop</h1>
  <div ondrop="drop(this, event)" ondragenter="return false" ondragover="return false">
   <p>Good</p>
  </div>
  <div ondrop="drop(this, event)" ondragenter="return false" ondragover="return false">
   <p>Bad</p>
  </div>
  <p>
   <img src="http://www.baidu.com/img/baidu_logo.gif" id="baidu" alt="baidu" ondragstart="drag(this, event)">
   <img src="http://www.google.cn/intl/zh-CN/images/logo_cn.gif" id="google" alt="google" ondragstart="drag(this, event)">
   <img src="http://www.blueidea.com/img/common/logo.gif" id="blueidea" alt="blueidea" ondragstart="drag(this, event)">
   <img src="http://www.w3.org/Icons/w3c_main" id="W3C" alt="W3C" ondragstart="drag(this, event)">
  </p>
  <script>
   function drag(target, e) {
     e.dataTransfer.setData('Text', target.id);
   }
   function drop(target, e) {
     var id = e.dataTransfer.getData('Text');
     target.appendChild(document.getElementById(id));
     e.preventDefault();
   }
  </script>
 </body>
 </html>
```
3. canvas
我们先看一些canvas的示例：
http://www.agustinfernandez.com.ar/proyectos/canvas/
http://www.whatwg.org/demos/2008-sept/color/color.html
网上还有一些互动性蛮强的Demo.
canvas应用的发展无疑将威胁到也行进在富Web之路上的Flash和Silverligth这些Web插件。

canvas在safari,firefox,opera很早就有了支持，但IE缺迟迟不予支持，尽管他在ie8中已经开始支持多个HTML5功能。MS的同志很有理由这么做:“HTML 5标准制定之前,某些功能确实已经得以实现,例如Google Gears实现了离线应用程序功能,Flash和silverlight实现了类似Canvas API的功能.在下一代HTML规范中设置这些内容未必非常必要”。要知道MS在silverlight是花了很大力气。事实上，MS在参与HTML5之事上一直非常谨慎，并且希望精简HTML5。
Flash的所有者，HTML5参与者之一Adobe则表现的很轻松：“canvas还很弱，HTML 5 + CSS 3 可能要 10年的时间才能定稿，在这期间，Flash 会持续发展，并提供更好的用户体验”。

尽管IE没有支持canvas功能，但我们可以使用JS模拟达到：
http://excanvas.sourceforge.net/
这是其中的一个Demo,试试你的IE:
3Dcanvas_For_IE.html

4. audio and video
使用FireFox3.5看看下面这个Video Demo。
```html runcode
<!DOCTYPE HTML>
<html>
<head>
<title>Video</title>
</head>
<body>
	<h1>Video</h1>
	<video src="http://v2v.cc/~j/theora_testsuite/320x240.ogg" controls autoplay >
	   你的浏览器不支持
	</video>
	<script>
		var video = document.getElementsByTagName('video')[0];
	</script>
	<p><input type="button" value="&#x2588; &#x2588;" onclick="if (video.paused) video.play(); else video.pause()"></p>
</body>
</html>
```

我们没有引入flash播放器就能播放swf。

在下面这个页面里罗列了各浏览器所支持的HTML5功能：
Implementations in Web browsers
