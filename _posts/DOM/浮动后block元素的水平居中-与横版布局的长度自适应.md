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

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>block元素浮动后的自适应水平居中</title>
<style>
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
</style>
</head>
<body>
<div class="header">
	<div class="nav">
		<ul class="menu">
			<li>1</li>
			<li>2</li>
			<li>3</li>
			<li>4</li>
			<li>5</li>
			<li>6</li>
			<li>7</li>
			<li>8</li>
		</ul>
	</div>
</div>
</body>
</html>
```
下面介绍第二个简单的技巧。
它应用于横版布局的宽度自适应，因为我们同样不知道横版最终达到的宽度是多少。
尽管这种布局很少见，但里面的技巧其实用处很广。

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>横版布局的长度自适应</title>
<style>
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
</style>
</head>
<body>
<ul class="menu">
	<li>1</li>
	<li>2</li>
	<li>3</li>
	<li>4</li>
	<li>5</li>
	<li>6</li>
	<li>7</li>
	<li>8</li>
	<li>1</li>
	<li>2</li>
	<li>3</li>
	<li>4</li>
	<li>5</li>
	<li>6</li>
	<li>7</li>
	<li>8</li>
</ul>
</body>
</html>
```
里面的技巧其实就是个margin负值。
应用margin负值来完成预定的布局，往往有“柳暗花明”的效果。

/************** 额外奉送第三个小技巧 **************/
文本单行居中，多行居左的效果。

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>单行居中，多行居左</title>
<style>
.box{width:350px;border:1px solid #ccc;margin:50px;text-align:center;}
.box span{display:inline-block;text-align:left;}
</style>
</head>
<body>
<div class="box">
<span>让我们荡起双桨</span>
</div>
<div class="box">
<span>让我们荡起双桨,小船儿推开波浪,海面倒映着美丽的白塔,四周环绕着绿树红墙~</span>
</div>
</body>
</html>
```
