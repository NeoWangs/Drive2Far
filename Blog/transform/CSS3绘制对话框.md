---
layout: post
title: "CSS3绘制对话框"
date: "2011-03-09 10:11:06 +0800"
slug: "CSS3绘制对话框"
category: "developer"
categories:
  - "developer"
tags:
  - "CSS3"
  - "Transform"
permalink: "/2011/03/09/CSS3绘制对话框/"
---

我们之前有利用css3做过一个投影效果：纯css打造投影效果——CSS3属性transform的应用
主要是利用了transforms系列属性。
另外，在这篇文章里：CSS3的崛起——体验webkit的3D-Effect
我们还讨论了目前仍属于webkit独有的3d-transforms属性。

今天这个效果的实现还是用到了transform（之中的skew）。

看代码:
```html runcode
<!doctype html>
<html>
<head>
<meta charset='UTF-8' />
<title>采用css3的语言框效果</title>
<style>
.wrap{position:relative;}
.bd{
	background:#BDCEEF;width:250px;height:80px;padding:10px;position:relative;z-index:2;
	box-shadow: 5px 8px 11px rgba(0,0,0,0.4); /* 阴影 */
	-webkit-box-shadow: 5px 8px 11px rgba(0,0,0,0.4);
	-moz-box-shadow: 5px 8px 11px rgba(0,0,0,0.4);
	/*filter: progid:DXImageTransform.Microsoft.Shadow(color='#666666', Direction=145, Strength=3)*/ /* ie的阴影滤镜 */
	border-radius: 5px;  /* 圆角 */
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
}
.cor{
	position:absolute;
	z-index:2;
	width:40px;
	height:40px;
	background:#BDCEEF;
	left:30px;bottom:-20px;
	transform: skewY(-45deg); /* 斜切实现尖角  */
	-o-transform: skewY(-45deg);
	-webkit-transform: skewY(-45deg);
	-moz-transform: skewY(-45deg);
}
.cor_s{
	z-index:1;
	box-shadow: 5px 8px 11px rgba(0,0,0,0.4);  /* 尖角处的阴影 */
	-webkit-box-shadow: 5px 8px 11px rgba(0,0,0,0.4);
	-moz-box-shadow: 5px 8px 11px rgba(0,0,0,0.4);
}
</style>
<!--[if lte IE 8]>
<style type="text/css">
/* 对ie实行人道处置 */
.cor{
	width:0;height:0;bottom:-30px;overflow:hidden;background:transparent;
	border:20px solid transparent;
	border-top-color:#BDCEEF;
	border-left-color:#BDCEEF;
}
</style>
<![endif]-->
</head>
<body>
<div class='wrap'>
	<div class='bd'>Hello everybody</div>
	<div class="cor"></div>
	<div class="cor cor_s"></div>
</div>
</body>
</html>
```

上面的代码中，我们可以看见有一句ie的滤镜注释，那是ie的阴影滤镜。
其实ie在很早的时候就开始以滤镜的形式支持各种变形和阴影了，所以如果你想让ie（9以下）浏览器也能展现css3的那些效果，你也可以考虑滤镜实现。
并且，有人已经帮你实现智能转换了。非常轻松，看这里：http://www.useragentman.com/IETransformsTranslator/

而如果你不屑于ie的滤镜，认为那是即将被淘汰的事物了，那不妨看看3d-transforms以及Animation属性这种目前只有webkit支持的，未来或许能进入css3标准的东西。
http://westciv.com/tools/transforms/index.html (除一般的transforms的演示外，还有3d-transforms和Animation的演示)。

最后，提醒一句，transform属性并非css3独有，svg，canvas中也都有实现，当然他们的写法非常类似。
下面是一个canvas中的transform属性可视化演示：http://www.cssass.com/blog/index.php/2010/817.html
