---
layout: post
title: "纯css打造投影效果——CSS3属性transform的应用"
date: "2010-11-03 16:52:19 +0800"
slug: "纯css打造投影效果——CSS3属性transform的应用"
category: "developer"
categories:
  - "developer"
tags:
  - "CSS3"
  - "Transform"
permalink: "/2010/11/03/纯css打造投影效果——CSS3属性transform的应用/"
---

刚在twitter上看见这个效果。
Getting Clever with CSS3 Shadows


这个效果里，除了应用阴影属性box-shadow之外，还需要一个重要属性的支持——transform
其实transform算是一个混合属性，它同canvas和svg的transform一样，带有几个独立的方法：平移（translate），缩放（Scaling），旋转（Rotating），另外，还有一个斜切（Skewing）。其实，斜切和旋转是有关系的：当skewX=-skewY时，它就是一个纯粹的Rotate。

下面就是效果演示。略有改动，原demo没有考虑opera，在此补上。
所以，应该除了ie9以下的浏览器，其他所以用户都能看见效果。
<div class="runcode"><textarea class="runcode_text" id="runcode_20101103__css_CSS3_transform__1">&lt;!DOCTYPE HTML&gt;
&lt;html&gt;
&lt;head&gt;
	&lt;meta charset="UTF-8"&gt;
	&lt;title&gt;skew&lt;/title&gt;
	&lt;style&gt;
	.box {
		position: absolute;
		padding: 2px;
		background: white;
		-webkit-box-shadow: 1px 2px 4px rgba(0,0,0,.5);
		-moz-box-shadow: 1px 2px 4px rgba(0,0,0,.5);
		box-shadow: 1px 2px 4px rgba(0,0,0,.5);
	}
	.box img {
		display:block;
		width: 200px;
		border: 1px inset #8a4419;
		background:#eee;
	}
	.box:after {
		content: '';
		-webkit-box-shadow:  100px 0 10px 20px rgba(0,0,0,.2);
		-moz-box-shadow:  100px 0 10px 20px rgba(0,0,0,.2);
		box-shadow:  100px 0 10px 20px rgba(0,0,0,.2);
		position: absolute;
		width: 50%;
		height: 20px;
		bottom: 20px;
		right: 90px;
		z-index: -1;
		-webkit-transform: skew(-40deg);
		-moz-transform: skew(-40deg);
		-o-transform: skew(-40deg);
		transform: skew(-40deg);
	}
	&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div class="box"&gt;
	&lt;img src='http://www.cssass.com/blog/resource/avatar/avatar.jpg'/&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20101103__css_CSS3_transform__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20101103__css_CSS3_transform__1')">Copy</button></div></div>

————几分钟之后——————
我们发现safari竟然不支持。
但千万不要怀疑safari的transform能力。——它可是支持3D变换的。
Visual Effects Transform Functions
从中可以看出，safari的transform完全应该可以达到效果的。
（另外，safari的Transition和Animation这两个CSS属性/方法也是异常的强大）

现在把目光转向box-shadow属性。
前面我们的写法是：box-shadow: 100px 0 10px 20px rgba(0,0,0,.2);
这里有5个属性，分别表示 X偏移offset-x，Y偏移offset-y， 模糊半径blur-radius ，延伸半径spread-radius，和 color
这是据MDC的说法，-moz-box-shadow。
除了这5个属性值之外，还有一个属性值inset——表示内阴影。另外，这个属性值组还可以设置多组，中间用逗号隔开。
inset值在safari下不支持，这点我们之前就有所了解。除此之外，还有没有其他差异呢？
请看：-webkit-box-shadow。
原来safari下还不支持“延伸半径”值。

那么为了兼容safari，我们可以修改一下：

<div class="runcode"><textarea class="runcode_text" id="runcode_20101103__css_CSS3_transform__2">&lt;!DOCTYPE HTML&gt;
&lt;html&gt;
&lt;head&gt;
	&lt;meta charset="UTF-8"&gt;
	&lt;title&gt;skew&lt;/title&gt;
	&lt;style&gt;
	.box {
		position: absolute;
		padding: 2px;
		background: white;
		-webkit-box-shadow: 1px 2px 4px rgba(0,0,0,.5);
		-moz-box-shadow: 1px 2px 4px rgba(0,0,0,.5);
		box-shadow: 1px 2px 4px rgba(0,0,0,.5);
	}
	.box img {
		display:block;
		width:200px;
		height:220px;
		border: 1px inset #8a4419;
		background:#eee;
	}
	.box:after {
		content: '';
		-webkit-box-shadow:  100px 0 10px rgba(0,0,0,.2);
		-moz-box-shadow:  100px 0 10px rgba(0,0,0,.2);
		box-shadow:  100px 0 10px rgba(0,0,0,.2);
		position: absolute;
		width: 50%;
		height: 80px;
		bottom: 0;
		right: 65px;
		z-index: -1;
		-webkit-transform: skew(-40deg);
		-moz-transform: skew(-40deg);
		-o-transform: skew(-40deg);
		transform: skew(-40deg);
	}
	&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div class="box"&gt;
	&lt;img src='http://www.cssass.com/blog/resource/avatar/avatar.jpg'/&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20101103__css_CSS3_transform__2')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20101103__css_CSS3_transform__2')">Copy</button></div></div>
