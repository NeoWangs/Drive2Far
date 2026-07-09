---
layout: post
title: "贝塞尔曲线的可视化操作实现——Photoshop钢笔工具的初级模拟"
date: "2010-09-16 16:43:22 +0800"
slug: "贝塞尔曲线的可视化操作实现——Photoshop钢笔工具的初级模拟"
category: "developer"
categories:
  - "developer"
tags:
  - "Math"
permalink: "/2010/09/16/贝塞尔曲线的可视化操作实现——Photoshop钢笔工具的初级模拟/"
---

贝塞尔曲线在数字绘图中有着非常重要的地位，你可能使用过photoshop的钢笔工具，那就是贝塞尔曲线的应用。
在html5的canvas中也得到了实现，即bezierCurveTo函数。
虽然功能不错，但是凭空使用 bezierCurveTo来绘图可不是件方便的事。
他的6个参数：（控制点1的坐标X，控制点1的坐标y，控制点2的坐标x，控制点2的坐标y，终点坐标x，终点坐标y）并不是你一见就能知道最终效果的。
黑客帝国中的那种通过没有数字视频解码器的显示设备，纯粹看代码来监视母体世界的能力，不是一时半会能够修炼的出来的。

下面的demo就提供了这种类似数字解码功能，使得你可以可视化操作曲线。
然后，这还只是个很初级的东西，希望大家支持，我会慢慢完善的。
此demo仅提供了单条贝塞尔曲线的操作，可控的点有四个，暂没有拖动线条的功能。
和那种用HTML5实现整个photoshop功能的项目比起来。这只能算是小小的练习，希望这个练习在不久的未来能够用上。

```html runcode
<!doctype html>
<html>
<head>
<meta charset='UTF-8' />
<title>贝塞尔曲线可视化操作</title>
<style>
*{padding:0;margin:0;}
body{padding:20px;}
</style>
</head>
<body>
<canvas id="pad" width='800' height='500'  style='position:relative;border:1px solid #ccc;'><a href='http://www.cssass.com'>cssass.com</a>提醒您：ie用户(9以下)请一边惭愧去吧</canvas>
<div id='output'>在屏幕中点击并可拖动，你可控的点有4个</div>
<button onclick='document.location.reload()'>刷新</button>
<script type="text/javascript">
var $id=function(n){
	return document.getElementById(n) || n;
}
$id("pad").addEventListener("mousedown", main, false);
var con=$id("pad").getContext('2d');
	con.strokeStyle = '#000';
	con.lineWidth=0.2;
var vector={sta:[],end:[],cr1:[],cr2:[]}
function main(){
	var e=arguments[0];
	var cx=e.layerX || e.offsetX,   //鼠标起点
		cy=e.layerY || e.offsetY;
		init(cx,cy);   //初始化点
	var sx=parseInt(vector.sta[0]), //起点
		sy=parseInt(vector.sta[1]),
		ex=parseInt(vector.end[0]), //终点
		ey=parseInt(vector.end[1]),
		cr1x=parseInt(vector.cr1[0]), //控制点1
		cr1y=parseInt(vector.cr1[1]),
		cr2x=parseInt(vector.cr2[0]), //控制点2
		cr2y=parseInt(vector.cr2[1]);
	if(vector.end[0] == undefined) return;  //仅有起点时，退出。
	if(cr1x-5 < cx && cx < cr1x + 5 && cr1y-5 < cy && cy < cr1y +5){    //选中控制点1
		 discern('ctr1',cx,cy,cr1x,cr1y,cr2x,cr2y);
	}
	else if(cr2x-5 < cx && cx < cr2x + 5 && cr2y-5 < cy && cy < cr2y +5){  //选中控制点2
		discern('ctr2',cx,cy,cr1x,cr1y,cr2x,cr2y);
	}
	else if(sx-5 < cx && cx < sx + 5 && sy-5 < cy && cy < sy +5){  //选中起点
	    discern('start',cx,cy,cr1x,cr1y,cr2x,cr2y);
	}
	else if(ex-5 < cx && cx < ex + 5 && ey-5 < cy && cy < ey +5 ){  //选中终点
		discern('end',cx,cy,cr1x,cr1y,cr2x,cr2y);
	}
	document.onmouseup=function(){
		document.onmousemove=null;
	}
}
function init(cx,cy){
	if(vector.sta[0] == undefined){  //若无起点时，初始化起点
		vector.sta[0] = vector.cr1[0] = cx;
		vector.sta[1] = vector.cr1[1] = cy;
		con.fillRect(vector.sta[0]-1, vector.sta[1]-1 ,3,3);
	}
	else if(vector.end[0] == undefined){  //若无终点，初始化终点
		vector.end[0] = vector.cr2[0] = cx;
		vector.end[1] = vector.cr2[1] = cy;
		con.fillRect(vector.end[0]-1, vector.end[1]-1 ,3,3);
		draw()  //已有两点，开始绘线
	}
}
function discern(v,cx,cy,cr1x,cr1y,cr2x,cr2y){
	document.onmousemove=function(e){
		var dx=e.layerX || e.offsetX,  //鼠标当前坐标
			dy=e.layerY || e.offsetY;
		switch(v) {
			case 'start' :  //拖动起点
				vector.sta[0]=dx;
				vector.sta[1]=dy;
				vector.cr1[0] = cr1x + (dx-cx);
				vector.cr1[1] = cr1y + (dy-cy);
				break;
			case 'end' :
				vector.end[0]=dx;
				vector.end[1]=dy;
				vector.cr2[0] = cr2x + (dx-cx);
				vector.cr2[1] = cr2y + (dy-cy);
				break;
			case 'ctr1' :
				vector.cr1[0] = dx;
				vector.cr1[1] = dy;
				break;
			case 'ctr2' :
				vector.cr2[0] = dx;
				vector.cr2[1] = dy;
				break;
			default: break;
		}
		draw();
	}
}
function draw(){
	 con.clearRect(0,0,800,500);
	 //画贝塞尔曲线
	 con.beginPath();
	 con.moveTo(vector.sta[0], vector.sta[1]);
	 con.bezierCurveTo(vector.cr1[0], vector.cr1[1], vector.cr2[0], vector.cr2[1], vector.end[0], vector.end[1]);
	 con.stroke();
	 //画控制线1
	con.beginPath();
	con.moveTo(vector.sta[0],vector.sta[1]);
	con.lineTo(vector.cr1[0], vector.cr1[1]);
	con.stroke();
	 //画控制线2
	con.beginPath();
	con.moveTo(vector.end[0], vector.end[1]);
	con.lineTo(vector.cr2[0], vector.cr2[1]);
	con.stroke();
	 //画4个控制点
	con.strokeRect(vector.sta[0]-1, vector.sta[1]-1 ,3,3);
	con.strokeRect(vector.end[0]-1, vector.end[1]-1 ,3,3);
	con.fillRect(vector.cr1[0]-1, vector.cr1[1]-1 ,3,3);
	con.fillRect(vector.cr2[0]-1, vector.cr2[1]-1 ,3,3);
	//输出贝塞尔函数
	$id('output').innerHTML='moveTo(' + vector.sta[0] +',' + vector.sta[1] + ');<br />' + 'bezierCurveTo(' + vector.cr1[0] +','+ vector.cr1[1] +',' + vector.cr2[0] +',' + vector.cr2[1] +','+ vector.end[0] +',' + vector.end[1] +');';
}
</script>
</body>
</html>
```
