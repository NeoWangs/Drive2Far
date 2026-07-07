---
layout: post
title: "浮动后block元素的水平居中,与横版布局的长度自适应"
date: "2010-12-07 16:57:18 +0800"
slug: "浮动后block元素的水平居中-与横版布局的长度自适应"
category: "developer"
categories:
  - "developer"
tags:
  - "DOM"
permalink: "/2010/12/07/浮动后block元素的水平居中-与横版布局的长度自适应/"
---

今天介绍两个小技巧，与float，margin负值有关。

众所周知：
inline元素的水平居中可以用text-align:center;
block元素的水平居中可以用margin:0 auto; (设置宽度后，方显效果)。
block元素设置float:left;后，如果幸运，我们知道其确定的宽度值，则可以用left:50%;margin-left:-width/2;来实现。
那么，当我们不确定知道block具体要达到的宽度时，该如何办呢？
这种情况，常见于菜单栏居中，而因为某些原因，各个菜单项的宽度很难去确定，造成菜单栏宽度的不确定。
当然，我们也可以使用inline元素来嵌套菜单项（即使菜单项是block元素，也未尝不可），父级使用text-align:center;来居中。
而下面的方法也不错，值得吸收的小技巧。

<div class="runcode"><textarea class="runcode_text" id="runcode_20101207__block__1">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;title&gt;block元素浮动后的自适应水平居中&lt;/title&gt;
&lt;style&gt;
*{
	margin:0;
	padding:0;
	list-style:none;
}
.header{overflow:hidden;}
.nav{
	float:left;
	position:relative;
	left:50%;
}
.menu{
	float:left;
    position:relative;
	right:50%;
	background: #ccc;
}
.menu li{
	float:left;
	padding:5px 20px;
	border:1px solid #aaa;
}
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div class="header"&gt;
	&lt;div class="nav"&gt;
		&lt;ul class="menu"&gt;
			&lt;li&gt;1&lt;/li&gt;
			&lt;li&gt;2&lt;/li&gt;
			&lt;li&gt;3&lt;/li&gt;
			&lt;li&gt;4&lt;/li&gt;
			&lt;li&gt;5&lt;/li&gt;
			&lt;li&gt;6&lt;/li&gt;
			&lt;li&gt;7&lt;/li&gt;
			&lt;li&gt;8&lt;/li&gt;
		&lt;/ul&gt;
	&lt;/div&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20101207__block__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20101207__block__1')">Copy</button></div></div>
下面介绍第二个简单的技巧。
它应用于横版布局的宽度自适应，因为我们同样不知道横版最终达到的宽度是多少。
尽管这种布局很少见，但里面的技巧其实用处很广。

<div class="runcode"><textarea class="runcode_text" id="runcode_20101207__block__2">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;title&gt;横版布局的长度自适应&lt;/title&gt;
&lt;style&gt;
*{
	margin:0;
	padding:0;
	list-style:none;
}
.menu{
	float:left;
    margin-right:-30000px;
}
.menu li{
	float:left;
	width:200px;border:1px solid #ccc;
}
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;ul class="menu"&gt;
	&lt;li&gt;1&lt;/li&gt;
	&lt;li&gt;2&lt;/li&gt;
	&lt;li&gt;3&lt;/li&gt;
	&lt;li&gt;4&lt;/li&gt;
	&lt;li&gt;5&lt;/li&gt;
	&lt;li&gt;6&lt;/li&gt;
	&lt;li&gt;7&lt;/li&gt;
	&lt;li&gt;8&lt;/li&gt;
	&lt;li&gt;1&lt;/li&gt;
	&lt;li&gt;2&lt;/li&gt;
	&lt;li&gt;3&lt;/li&gt;
	&lt;li&gt;4&lt;/li&gt;
	&lt;li&gt;5&lt;/li&gt;
	&lt;li&gt;6&lt;/li&gt;
	&lt;li&gt;7&lt;/li&gt;
	&lt;li&gt;8&lt;/li&gt;
&lt;/ul&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20101207__block__2')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20101207__block__2')">Copy</button></div></div>
里面的技巧其实就是个margin负值。
应用margin负值来完成预定的布局，往往有“柳暗花明”的效果。

/************** 额外奉送第三个小技巧 **************/
文本单行居中，多行居左的效果。

<div class="runcode"><textarea class="runcode_text" id="runcode_20101207__block__3">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;title&gt;单行居中，多行居左&lt;/title&gt;
&lt;style&gt;
.box{width:350px;border:1px solid #ccc;margin:50px;text-align:center;}
.box span{display:inline-block;text-align:left;}
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div class="box"&gt;
&lt;span&gt;让我们荡起双桨&lt;/span&gt;
&lt;/div&gt;
&lt;div class="box"&gt;
&lt;span&gt;让我们荡起双桨,小船儿推开波浪,海面倒映着美丽的白塔,四周环绕着绿树红墙~&lt;/span&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20101207__block__3')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20101207__block__3')">Copy</button></div></div>
