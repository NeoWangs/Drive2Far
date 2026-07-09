---
layout: post
title: "CSS3的崛起——体验webkit的3D-Effect"
date: "2010-11-16 16:55:02 +0800"
slug: "CSS3的崛起——体验webkit的3D-Effect"
category: "developer"
categories:
  - "developer"
tags:
  - "CSS3"
  - "3D"
  - "Transform"
permalink: "/2010/11/16/CSS3的崛起——体验webkit的3D-Effect/"
---

在性能保证的前提下，向更高更炫的效果发起冲击是未来Web的一大需求，而CSS必将借此大展抱负，崛起于未来的web技术之林，独树一帜，无可撼动。而在这条道路上，Apple公司无疑是一位先驱：他们要将web交互推入3D时代。目前，不仅W3C通过了3d-transforms的工作草案，在webkit上3d-transforms也已经实现了。

本文意在体验，浅析3d-transforms，读者如对3d-transforms有技术方面的兴趣，可以阅读以下文档：
W3C的 css3-3d-transforms (工作草案)
Apple的 CSS Visual Effects Guide —— transforms （指南）
Apple的 Visual Effects Transform Functions （属性方法介绍）
westciv.com的 3Dtransforms （可视化演示）
webkit.org的 3D Transforms (有Demo讲解)

警告：以下所有Demo效果须使用safari5，开源的chrominm浏览器进行体验，而即使是在chrome12下的效果也会大打折扣。
下面这个demo来自marcofolio.net：3d animation using pure CSS3
以下是代码删减版

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>cssass.com</title>
<style>
*{padding:0;margin:0;}
body { background-color:#deddcd;}
#movieposters { list-style:none; margin:100px;}
#movieposters li {float:left;
	-webkit-perspective: 500;
	/*
	-webkit-transform-style: preserve-3d;
	-webkit-transition-property: perspective;
	-webkit-transition-duration: 0.5s;
	*/
}
/*
#movieposters li:hover { -webkit-perspective: 5000; }
*/
#movieposters li img { border:10px solid #fcfafa;-webkit-box-shadow:0 3px 10px #888;
	-webkit-transform: rotateY(30deg);
	-webkit-transition-property: transform;
	-webkit-transition-duration: 0.5s;
}
#movieposters li:hover img {-webkit-transform: rotateY(0deg); }
.movieinfo {border:10px solid #fcfafa; padding:0 10px; width:120px; height:100px; background-color:#deddcd; margin:-125px 0 0 55px; position:absolute;-webkit-box-shadow:0 10px 20px #888;
	-webkit-transform: translateZ(30px) rotateY(30deg);
	-webkit-transition-property: transform, box-shadow, margin;
	-webkit-transition-duration: 0.5s; }
#movieposters li:hover .movieinfo {-webkit-box-shadow:0 5px 10px #888; margin:-105px 0 0 30px;
	-webkit-transform: rotateY(0deg); }
.movieinfo h3 {color:#7a3f3a;font-family:Georgia; text-align:center; }
.movieinfo p {padding:10px 0;}
.movieinfo a { display:block; background:#7a3f3a; padding:3px 0; color:#eee; text-decoration:none; text-align:center; margin:0 auto;-webkit-border-radius:5px; }
.movieinfo a:hover, .movieinfo a:focus { background-color:#6a191f; color:#fff; }
</style>
</head>
<body>
<ul id="movieposters">
	<li>
		<img src='http://www.cssass.com/blog/resource/avatar/avatar_m.jpg' width='200' />
		<div class="movieinfo">
			<h3>Avatar 2</h3>
			<p>You like a baby</p>
			<a href="http://www.cssass.com" title="I see you">More info</a>
		</div>
	</li>
	<li>
		<img src='http://www.cssass.com/blog/resource/avatar/avatar_m.jpg' width='200' />
		<div class="movieinfo">
			<h3>Avatar 2</h3>
			<p>You like a baby</p>
			<a href="http://www.cssass.com" title="I see you">More info</a>
		</div>
	</li>
	<li>
		<img src='http://www.cssass.com/blog/resource/avatar/avatar_m.jpg' width='200' />
		<div class="movieinfo">
			<h3>Avatar 2</h3>
			<p>You like a baby</p>
			<a href="http://www.cssass.com" title="I see you">More info</a>
		</div>
	</li>
</ul>
</body>
</html>
```
进一步删减

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>cssass.com</title>
<style>
*{padding:0;margin:0;list-style:none; }
body { background:#deddcd;margin:100px;}
#movieposters li {float:left;
	-webkit-perspective: 500;
}
#movieposters li img {
	-webkit-transform: rotateY(30deg);
	-webkit-transition-property: transform;
	-webkit-transition-duration: 0.5s;
}
#movieposters li:hover img {
	-webkit-transform: rotateY(0deg);
}
.movieinfo {
	position:absolute; width:120px; height:100px; background:#fff; margin:-125px 0 0 55px;
	-webkit-transform: translateZ(30px) rotateY(30deg);
	-webkit-transition-property: transform, margin;
	-webkit-transition-duration: 0.5s;
}
#movieposters li:hover .movieinfo {
	margin:-105px 0 0 40px;
	-webkit-transform: rotateY(0deg);
}
</style>
</head>
<body>
<ul id="movieposters">
	<li>
		<img src='http://www.cssass.com/blog/resource/avatar/avatar_m.jpg' width='200' />
		<div class="movieinfo">
			Avatar 2
		</div>
	</li>
</ul>
</body>
</html>
```
上面的Demo中，我们一直没有应用-webkit-transform-style: preserve-3d;这个属性。
事实上，上面的Demo仅仅是”伪3D”,只是我们面对的是屏幕这样一个2D平面，上面的Demo还无法区分出真3D和伪3D。

我们再看看下面这个真3D的Demo——来自webkit.org

```html runcode
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Explaining transform-style</title>
  <style>
    #container {
      position: relative;
      height: 300px;
      width: 300px;
      margin: 50px 100px;
      border: 2px solid blue;
      -webkit-perspective: 500;
    }
    #parent {
      margin: 10px;
      width: 280px;
      height: 280px;
      background-color: #844BCA;
      opacity: 0.8;
      -webkit-transform-style: preserve-3d;
      -webkit-animation: spin 10s infinite linear;
    }
    #container:hover #parent {
      -webkit-transform-style: flat;
    }
    @-webkit-keyframes spin {
      from { -webkit-transform: rotateY(0); }
      to   { -webkit-transform: rotateY(360deg); }
    }
    #parent > div {
      position: absolute;
      top: 40px;
      left: 40px;
      width: 200px;
      height: 200px;
      padding: 10px;
      -webkit-box-sizing: border-box;
    }
    #parent > :first-child {
      background-color: #49DC93;
      -webkit-transform: translateZ(-100px) rotateY(45deg);
    }
    #parent > :last-child {
      background-color: #FF6;
      -webkit-transform: translateZ(50px) rotateX(20deg);
      -webkit-transform-origin: 50% top;
    }
  </style>
</head>
<body>
  <div id="container">
    <div id="parent">
      <div>-webkit-transform: translateZ(-100px) rotateY(45deg);</div>
      <div>-webkit-transform: translateZ(50px) rotateX(20deg);</div>
    </div>
  </div>
</body>
</html>
```
hover状态下transform-style值是flat;未hover状态下是preserve-3d —— 两者的效果差异一目了然。
在上面的Demo中，不仅应用了transform属性，还使用了webkit css中另一个很牛的属性——animation
（而我们最前面的Demo也使用了webkit css中第三个很牛的属性——transition）

参照上面的Demo，我们对原demo也做个修改，

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>cssass.com</title>
<style>
*{padding:0;margin:0;list-style:none; }
body { background:#deddcd;margin:100px;}
#movieposters{
	-webkit-perspective: 1000;
}
#movieposters li {float:left;
	-webkit-animation: spin 10s infinite linear;
}
#movieposters li.first{
	-webkit-transform-style: preserve-3d;
}
#movieposters li.second{
	-webkit-transform-style: plat;
}
 @-webkit-keyframes spin {
      from { -webkit-transform: rotateY(0); }
      to   { -webkit-transform: rotateY(360deg); }
    }
#movieposters li img {
	-webkit-transform: rotateY(30deg);
	-webkit-transition-property: transform;
	-webkit-transition-duration: 0.5s;
}
#movieposters li:hover img {
	-webkit-transform: rotateY(0deg);
}
.movieinfo {
	position:absolute; width:120px; height:100px; background:#fff; margin:-125px 0 0 55px;
	-webkit-transform: translateZ(30px) rotateY(30deg);
	-webkit-transition-property: transform, margin;
	-webkit-transition-duration: 0.5s;
}
#movieposters li:hover .movieinfo {
	margin:-105px 0 0 40px;
	-webkit-transform: rotateY(0deg);
}
</style>
</head>
<body>
<ul id="movieposters">
	<li class='first'>
		<img src='http://www.cssass.com/blog/resource/avatar/avatar_m.jpg' width='200' />
		<div class="movieinfo">
			Avatar 2
		</div>
	</li>
	<li class='second'>
		<img src='http://www.cssass.com/blog/resource/avatar/avatar_m.jpg' width='200' />
		<div class="movieinfo">
			Avatar 2
		</div>
	</li>
</ul>
</body>
</html>
```
