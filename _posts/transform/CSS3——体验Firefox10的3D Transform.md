---
layout: post
title: "CSS3——体验Firefox10的3D Transform"
date: "2012-02-01 10:31:30 +0800"
slug: "CSS3——体验Firefox10的3D Transform"
category: "developer"
categories:
  - "developer"
tags:
  - "CSS3"
  - "3D"
  - "Transform"
permalink: "/2012/02/01/CSS3——体验Firefox10的3D Transform/"
---

之前写了一篇CSS3的崛起——体验webkit的3D-Effect。
随着firefox10正式版发布，firefox也支持3D Transform了，所以补充一篇，将上篇中的代码移植过来，支持firefox。

这里先穿插介绍下firefox10的新特性，firefox10除了支持3D Transform，还提供了Fullscreen API，令人兴奋吧。另外firefox10成为Mozila首个“长期支持版本”(Extended Support Release，简称“ESR”)，这种当然是市场考虑啦，至于是什么用意和市场反响我们就不探讨了。

下面是演示demo，只支持firefox10。 chrome浏览器的用户可以参考上一篇。

<div class="runcode"><textarea class="runcode_text" id="runcode_20120201_CSS3_Firefox10_3D_Transform_1">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;title&gt;firefox10&lt;/title&gt;
&lt;style&gt;
*{padding:0;margin:0;}
body { background-color:#deddcd;}
#movieposters { list-style:none; margin:100px;}
#movieposters li {float:left;
	-moz-perspective: 500px;
}
/* 图片3d变换效果 */
#movieposters li img { border:10px solid #fcfafa;-moz-box-shadow:0 3px 10px #888;
	-moz-transform: rotateY(30deg);
	-moz-transition-property: -moz-transform;
	-moz-transition-duration: 0.5s;
}
#movieposters li:hover img {-moz-transform: rotateY(0deg); }
/* 文字框3d变换效果 */
.movieinfo {border:10px solid #fcfafa; padding:0 10px; width:120px; height:100px; background-color:#deddcd; margin:-125px 0 0 55px; position:absolute;-moz-box-shadow:0 10px 20px #888;
	-moz-transform: translateZ(30px) rotateY(30deg);
	-moz-transition-property: -moz-transform, box-shadow, margin;
	-moz-transition-duration: 0.5s; }
#movieposters li:hover .movieinfo {-moz-box-shadow:0 5px 10px #888; margin:-105px 0 0 30px;
	-moz-transform: rotateY(0deg); }
.movieinfo h3 {color:#7a3f3a;font-family:Georgia; text-align:center; }
.movieinfo p {padding:10px 0;}
.movieinfo a { display:block; background:#7a3f3a; padding:3px 0; color:#eee; text-decoration:none; text-align:center; margin:0 auto;-moz-border-radius:5px; }
.movieinfo a:hover, .movieinfo a:focus { background-color:#6a191f; color:#fff; }
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;ul id="movieposters"&gt;
	&lt;li&gt;
		&lt;img src='http://www.cssass.com/blog/resource/avatar/avatar_m.jpg' width='200' /&gt;
		&lt;div class="movieinfo"&gt;
			&lt;h3&gt;Avatar 2&lt;/h3&gt;
			&lt;p&gt;You like a baby&lt;/p&gt;
			&lt;a href="http://www.cssass.com" title="I see you"&gt;More info&lt;/a&gt;
		&lt;/div&gt;
	&lt;/li&gt;
	&lt;li&gt;
		&lt;img src='http://www.cssass.com/blog/resource/avatar/avatar_m.jpg' width='200' /&gt;
		&lt;div class="movieinfo"&gt;
			&lt;h3&gt;Avatar 2&lt;/h3&gt;
			&lt;p&gt;You like a baby&lt;/p&gt;
			&lt;a href="http://www.cssass.com" title="I see you"&gt;More info&lt;/a&gt;
		&lt;/div&gt;
	&lt;/li&gt;
	&lt;li&gt;
		&lt;img src='http://www.cssass.com/blog/resource/avatar/avatar_m.jpg' width='200' /&gt;
		&lt;div class="movieinfo"&gt;
			&lt;h3&gt;Avatar 2&lt;/h3&gt;
			&lt;p&gt;You like a baby&lt;/p&gt;
			&lt;a href="http://www.cssass.com" title="I see you"&gt;More info&lt;/a&gt;
		&lt;/div&gt;
	&lt;/li&gt;
&lt;/ul&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20120201_CSS3_Firefox10_3D_Transform_1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20120201_CSS3_Firefox10_3D_Transform_1')">Copy</button></div></div>

去除一些效果

<div class="runcode"><textarea class="runcode_text" id="runcode_20120201_CSS3_Firefox10_3D_Transform_2">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;title&gt;firefox10&lt;/title&gt;
&lt;style&gt;
*{padding:0;margin:0;list-style:none; }
body { background:#deddcd;margin:100px;}
#movieposters li {float:left;
	-moz-perspective: 500px;
}
#movieposters li img {
	-moz-transform: rotateY(30deg);
	-moz-transition-property: -moz-transform;
	-moz-transition-duration: 0.5s;
}
#movieposters li:hover img {
	-moz-transform: rotateY(0deg);
}
.movieinfo {
	position:absolute; width:120px; height:100px; background:#fff; margin:-125px 0 0 55px;
	-moz-transform: translateZ(30px) rotateY(30deg);
	-moz-transition-property: -moz-transform, margin;
	-moz-transition-duration: 0.5s;
}
#movieposters li:hover .movieinfo {
	margin:-105px 0 0 40px;
	-moz-transform: rotateY(0deg);
}
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;ul id="movieposters"&gt;
	&lt;li&gt;
		&lt;img src='http://www.cssass.com/blog/resource/avatar/avatar_m.jpg' width='200' /&gt;
		&lt;div class="movieinfo"&gt;
			(未设置transform-style，默认为plat)
		&lt;/div&gt;
	&lt;/li&gt;
&lt;/ul&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20120201_CSS3_Firefox10_3D_Transform_2')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20120201_CSS3_Firefox10_3D_Transform_2')">Copy</button></div></div>

使用preserve-3d，实现全方位3D

<div class="runcode"><textarea class="runcode_text" id="runcode_20120201_CSS3_Firefox10_3D_Transform_3">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;title&gt;firefox10&lt;/title&gt;
&lt;style&gt;
*{padding:0;margin:0;list-style:none; }
body { background:#deddcd;margin:100px;}
#movieposters{
	-moz-perspective: 1000px;
}
#movieposters li {float:left;
	-moz-animation: spin 10s infinite linear;
}
#movieposters li.first{
	-moz-transform-style: preserve-3d;
}
#movieposters li.second{
	-moz-transform-style: plat;
}
 @-moz-keyframes spin {
      from { -moz-transform: rotateY(0); }
      to   { -moz-transform: rotateY(360deg); }
    }
#movieposters li img {
	-moz-transform: rotateY(30deg);
	-moz-transition-property: -moz-transform;
	-moz-transition-duration: 0.5s;
}
#movieposters li:hover img {
	-moz-transform: rotateY(0deg);
}
.movieinfo {
	position:absolute; width:120px; height:100px; background:#fff; margin:-125px 0 0 55px;
	-moz-transform: translateZ(30px) rotateY(30deg);
	-moz-transition-property: -moz-transform, margin;
	-moz-transition-duration: 0.5s;
}
#movieposters li:hover .movieinfo {
	margin:-105px 0 0 40px;
	-moz-transform: rotateY(0deg);
}
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;ul id="movieposters"&gt;
	&lt;li class='first'&gt;
		&lt;img src='http://www.cssass.com/blog/resource/avatar/avatar_m.jpg' width='200' /&gt;
		&lt;div class="movieinfo"&gt;
			Avatar 2 (preserve-3d)
		&lt;/div&gt;
	&lt;/li&gt;
	&lt;li class='second'&gt;
		&lt;img src='http://www.cssass.com/blog/resource/avatar/avatar_m.jpg' width='200' /&gt;
		&lt;div class="movieinfo"&gt;
			Avatar 2 (plat)
		&lt;/div&gt;
	&lt;/li&gt;
&lt;/ul&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20120201_CSS3_Firefox10_3D_Transform_3')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20120201_CSS3_Firefox10_3D_Transform_3')">Copy</button></div></div>

最后说明一下firefox和webkit间使用的一点差别：
火狐10下的3D Transforms在设置perspective属性值时必须带单位px，webkit可以省略；
另外，webkit在用transition-property设置transform这个值时，可以不用前缀，而firefox需要写上-moz-transform;


现在综合Webkit和Firefox，写一个效果，顺便也兼用下另两个属性：transition 和 animation
<div class="runcode"><textarea class="runcode_text" id="runcode_20120201_CSS3_Firefox10_3D_Transform_4">&lt;!doctype html&gt;
&lt;link href='http://fonts.googleapis.com/css?family=Ultra&amp;v2' rel='stylesheet' type='text/css'&gt;
&lt;style&gt;
body{background:#333;}
h1{font:normal 90px/1.5 'Ultra','Curlz MT','Bauhaus 93','Blackoak Std',Courier,Arial;color:#7e9409;position:absolute;top:85px;left:10px;width:300px;
	/* animation */
	-moz-animation: 1s slidein;
	-webkit-animation: 1s slidein;
	/* 3d-transform */
	-webkit-perspective: 600;
	-moz-perspective: 600px;
}
@-moz-keyframes slidein {
	from {top:1550px;}
	85% {top:5px;}
	to {top:85px;}
}
@-webkit-keyframes slidein {
	from {top:1550px;}
	85% {top:5px;}
	to {top:85px;}
}
.myLogo,.myLogo a{
	/*  transition */
	-moz-transition: all 2s ease-in-out 0s;
	-webkit-transition:all 2s ease-in-out 0;
	transition:all 2s ease-in-out 0;
}
.myLogo{position:relative;display:inline-block;zoom:1;top:0;left:0;text-shadow:-2px -1px 1px #7e9409;opacity: 0.8;filter:alpha(opacity=50);
	-webkit-transform: rotateY(30deg);
	-moz-transform: rotateY(30deg);
	transform: rotateY(30deg);
}
h1:hover .myLogo {
	 /* 3d-transform */
	 -webkit-transform: rotateY(0);
	-moz-transform: rotateY(0);
	transform: rotateY(0);
	text-shadow:0;
}
.myLogo a{position:absolute;top:1px;left:5px;color:#B7D902;text-shadow:-1px -1px 1px #fff;text-decoration: none;}
h1:hover .myLogo a{left: 2px;}
&lt;/style&gt;
&lt;h1&gt;
	&lt;span class="myLogo"&gt;
		CSSASS
		&lt;a href="http://www.cssass.com/blog/"&gt;CSSASS&lt;/a&gt;
	&lt;/span&gt;
&lt;/h1&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20120201_CSS3_Firefox10_3D_Transform_4')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20120201_CSS3_Firefox10_3D_Transform_4')">Copy</button></div></div>
