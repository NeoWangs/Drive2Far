---
layout: post
title: "canvas鼠标绘图Demo"
date: "2010-09-02 16:35:51 +0800"
slug: "canvas鼠标绘图Demo"
category: "developer"
categories:
  - "developer"
tags:
  - "canvas"
permalink: "/2010/09/02/canvas鼠标绘图Demo/"
---

```html runcode
<!doctype html>
<html>
<head>
<meta charset='UTF-8' />
<title>cssass.com</title>
<style>
*{padding:0;margin:0;}
html,body{height:100%;overflow:hidden;}
</style>
</head>
<body title='鼠标绘图'>
<canvas id="pad" width='1800' height='1000' onmousedown=draw(event) style='border:1px solid #ccc'>ie用户(9以下)请忽略</canvas>
<script type="text/javascript">
var $id=function(n){
	return document.getElementById(n) || n;
}
var D={
	width : 0.2 ,
	randRGB : function(){ return Math.round(Math.random()*250) },
	color : function(){return 'rgba(' + D.randRGB() + ',' + D.randRGB() + ',' + D.randRGB() + ' , 1)'}
}
var draw=function(e){
	var e=window.event || e;
	var o=$id("pad");
	var con=o.getContext('2d');
	con.beginPath();
	con.moveTo(e.clientX,e.clientY);
	con.strokeStyle = D.color();
	con.lineWidth=D.width;
	con.lineCap ='round';
	con.lineJoin = 'round';
	document.onmousemove=function(e){
		con.lineTo(e.clientX,e.clientY);
		con.stroke();
		document.onmouseup=function(){
			document.onmousemove=null;
		}
	}
}
</script>
</body>
</html>
```
我之前用window.onload来绑定函数修改canvas的高度，这通过运行框运行open新页面，在chrome下获取document.documentElemnet.offsetHeight时会等于0，导致绘图板高度也没了。
另外发现，Opera下绘线同其他浏览器有点差别：单独的一个path(即同上一次的path没有瓜葛)，如果没有moveTo设置起点，一般浏览器会以第一个lineTo为起点，这在Opera下是不正确的。

下面再放一个百度UEO基于canvas绘制热力图的演示：

```html runcode
<!doctype html>
<html>
<head>
<meta charset='UTF-8' />
<title>canvas热力图演示</title>
<style>
*{padding:0;margin:0;}
.wrap{width:1000px;height:500px;margin:0 auto;border:2px solid #eee;}
#pad{position:absolute;z-index:-1;top:0;left:50%;background:#eee;opacity:.8;}
#switch{position:absolute;z-index:20;}
</style>
</head>
<body onmousedown=imit(event)>
<div class="wrap" >
	<img src="https://www.google.com.hk/intl/zh-CN/images/logo_cn.png" />
	<img src="https://www.google.com.hk/intl/zh-CN/images/logo_cn.png" />
	<img src="https://www.google.com.hk/intl/zh-CN/images/logo_cn.png" />
</div>
<input id="switch"type='button' value="切换热力图显示在上层" />
<script>
var canvas= document.createElement('canvas');
var context = canvas.getContext('2d');
	canvas.id = "pad";
	canvas.width = document.documentElement.scrollWidth;
	canvas.height = Math.max(document.documentElement.clientHeight,document.body.offsetHeight);
	canvas.style.marginLeft = - canvas.width/2+'px';
	document.body.appendChild(canvas);
var points =[];
var oData = [];
var imit=function(e){
	points.push([e.clientX - canvas.offsetLeft, e.clientY]);  //手动模拟点,再按二次函数自动生成100个点。
	for(var i=0; i<100 ;i++){
		var r1=Math.random()*2,r2=Math.random()*2;
		points.push([parseInt(Math.pow(r1,2)*500)+5,parseInt(Math.pow(r2,2)*150)+5])
	}
	analy();
	draw();
}
function analy(){
	var cache = {};
	//计算每个点的密度
	for (var i = 0, len = points.length; i < len; i++) {
		var key = points[i][0] + '*' + points[i][1];
		 if (cache[key]) {
			cache[key] ++;
		} else {
			cache[key] = 1;
		}
	}
	//点数据还原
	oData.length=0;
	for (var m in cache) {
		if (m == '0*0') continue;
		var x = parseInt(m.split('*')[0], 10);
		var y = parseInt(m.split('*')[1], 0);
		oData.push([x, y, cache[m]]);
	}
	//简单排序，使用数组内建的sort
	oData.sort(function(a, b){
		return a[2] - b[2];
	});
}
function draw(){
	context.clearRect(0,0,canvas.width,canvas.height); //每次点击都要重绘，每次重绘都需清屏
	var max = oData[oData.length - 1][2];
		max=(max==1) ? 2 : max   //如果最大密度等于1，则认为2，避免log(max)为0
	var pi2 = Math.PI * 2;
	//alpha增强参数
	var pr = (Math.log(245)-1)/245;
	for (var i = 0, len = oData.length; i < len; i++) {
		//q参数用于平衡梯度差，使之符合人的感知曲线log2N，如需要精确梯度，去掉log计算
		var q = parseInt(Math.log(oData[i][2]) / Math.log(max) * 255);
		var r = parseInt(128 * Math.sin((1 / 256 * q - 0.5 ) * Math.PI ) + 200);
		var g = parseInt(128 * Math.sin((1 / 128 * q - 0.5 ) * Math.PI ) + 127);
		var b = parseInt(256 * Math.sin((1 / 256 * q + 0.5 ) * Math.PI ));
		var alp = (0.92 * q + 20) / 255;
		//灰度增强，
		//var alp = (Math.exp(pr * q + 1) + 10) / 255
		var radgrad = context.createRadialGradient(oData[i][0], oData[i][1], 1, oData[i][0], oData[i][1], 8);
		radgrad.addColorStop( 0, 'rgba(' + r + ',' + g + ','+ b + ',' + alp + ')');
		radgrad.addColorStop( 1, 'rgba(' + r + ',' + g + ','+ b + ',0)');
		context.fillStyle = radgrad;
		context.fillRect( oData[i][0] - 8, oData[i][1] - 8, 16, 16);
	}
}
var switcher = document.getElementById("switch");
	switcher.onclick = function(){
		canvas.style.zIndex = (canvas.style.zIndex == -1) ?  10 : -1; //注意一点，style.xx只能取得行内样式的，要获取外部样式可以使用getComputedStyle和currentStyle.
		//canvas.style.display = (canvas.style.display == 'block') ?  'none' : 'block';
	}
</script>
</body>
</html>
```
