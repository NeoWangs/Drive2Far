---
layout: post
title: "MDC的canvas经典教程辑和个人学习笔记"
date: "2010-09-10 16:39:37 +0800"
slug: "MDC的canvas经典教程辑和个人学习笔记"
category: "developer"
categories:
  - "developer"
tags:
  - "canvas"
  - "MDC"
permalink: "/2010/09/10/MDC的canvas经典教程辑和个人学习笔记/"
---

mozilla developer center的关于canvas的教程集Canvas tutorial，可说是目前入门canvas教程中最棒的了。
教程列表：
Basic usage(中译：基本用法)
Drawing shapes(中译：绘制图形)
Using images(中译：使用图像)
Applying styles and colors(中译：运用样式与颜色)
Transformations(中译：变形)
Compositing(中译：组合)
Basic animations(中译：基本动画)

以下是个人的一点笔记，涵盖了教程中所有知识点。但只适用于个人，存此备忘。

canvas_ABC
<div class="runcode"><textarea class="runcode_text" id="runcode_20100910_MDC_canvas__1">&lt;!doctype html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset='UTF-8' /&gt;
&lt;title&gt;cssass.com&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;canvas id="myCanvas" width='800' height="500" style="border:1px solid #c3c3c3;"&gt;ie（有ie9求测试）用户请绕行&lt;/canvas&gt;
&lt;script type="text/javascript"&gt;
var c=document.getElementById("myCanvas");
var con=c.getContext('2d');   //-----画矩形框
var grd=con.createLinearGradient(10,10,150,10);
grd.addColorStop(0,"#f00");  //起色
grd.addColorStop(1,"#0f0");  //终色
con.fillStyle=grd;   //渐变填充
con.rect(0, 0, 180,100)   //矩形1
con.fillRect(10,10,150,75);  //矩形2
con.clearRect(20,20,80,40);  //清除出一个矩形3
con.lineWidth=2;
con.lineCap ='round';  //线端点，默认butt; square和round会多出一半宽度的长度
con.lineJoin = 'round';  //折线连接点样式，默认miter延伸来连接；（round磨圆, beve削平） ；miter有miterLimit做限制，超过则应用beve
con.strokeStyle = '#00f';
con.strokeRect(30,30,20,20);  //矩形边框
var con2=c.getContext('2d');  //-------画折线
con2.moveTo(20,10); //起点位置
con2.lineTo(45,80);  //点
con2.lineTo(20,50);  //点
con2.lineTo(40,30);
con2.stroke();  //描边
// con2.fill(); //填充
var con3=c.getContext('2d');  //-------画圆
var radi=con3.createRadialGradient(290,50,10,295,60,30);  // 径向渐变（x1,y1,r1,x2,y2,r2）
radi.addColorStop(0, '#A7D30C');
radi.addColorStop(0.9, '#019F62');
//radi.addColorStop(1, 'rgba(1,159,98,0)');
con3.fillStyle = radi;
con3.beginPath();  //初始化路径
con3.arc(290,50,50,0,Math.PI*2,true);   //（x,y,radius,起，末弧度，逆，顺时针）
con3.closePath();  //终止路径
con3.stroke();
con3.fill();
var con4=c.getContext('2d');  //-------应用图片
var img=new Image();
img.src='http://bbs.blueidea.com/images/default/logo.gif';
img.onload=function(){
	con4.drawImage(img,10,90,200,200);  //图片对象，位置，[尺寸]，
	var ptrn = con4.createPattern(img,'repeat');  //图案填充
	con4.fillStyle = ptrn;
	con4.fillRect(0,350,150,150);
}
//var con4_2=c.getContext('2d');
//var img2=new Image();
//img2.src='https://developer.mozilla.org/samples/canvas-tutorial/images/rhino.jpg';
//con4_2.drawImage(document.getElementById('source'),33,71,104,124);
//con4_2.drawImage(document.getElementById('source'),0,0,20,100,0,90,120,124);
var con5=c.getContext('2d');  //二次，三次贝赛尔曲线
con5.moveTo(200,0)  //起点
con5.quadraticCurveTo(20, 20, 200, 200);  //（1个）控制点，终点
con5.stroke();
con5.moveTo(200,100)  //起点
con5.bezierCurveTo(250, 250, 350, 350, 220, 220); //（2个）控制点，终点
con5.stroke();
var con6=c.getContext('2d');  //文字阴影
con6.shadowOffsetX=2;
con6.shadowOffsetY=2;
con6.shadowBlur=2;
con6.shadowColor='rgba(0,0,0,0.5)';
con6.font='20px Times New Roman';
con6.fillStyle='black';
con6.fillText('hello HTML5',0,300);
&lt;/script&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20100910_MDC_canvas__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20100910_MDC_canvas__1')">Copy</button></div></div>
canvas_DEF

<div class="runcode"><textarea class="runcode_text" id="runcode_20100910_MDC_canvas__2">&lt;!doctype html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset='UTF-8' /&gt;
&lt;title&gt;cssass.com&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;canvas id="myCanvas" width='1000' height="600" style="border:1px solid #c3c3c3;"&gt;ie（有ie9求测试）用户请绕行&lt;/canvas&gt;
&lt;script type="text/javascript"&gt;
var c=document.getElementById("myCanvas");
var con1=c.getContext('2d');   //-----用于保存一些状态属性。
  con1.fillRect(0,0,40,40);
  con1.save();
  con1.fillStyle = 'blue'
  con1.globalAlpha = 0.1;
  con1.translate(50,0);  //【平移】圆点位置（位置1）
  con1.fillRect(0,0,40,40);
  con1.save();            //注意：圆点位置状态也会被保存
  con1.fillStyle = 'red'
  con1.globalAlpha = 1;
  con1.translate(50,0);
  con1.fillRect(0,0,40,40);
  con1.restore();   //恢复到位置1状态
  con1.translate(100,0); //从位置1开始移动100
  con1.fillRect(0,0,40,40);
  con1.restore();
  con1.save();
  con1.translate(200,0);
  con1.rotate(Math.PI*2/6);  //以圆点（200，0）为中心，【旋转】六分之一个角度
  con1.fillRect(0,0,40,40);
con1.restore();
con1.save();
con1.scale(1,0.25);  //【缩放】
con1.translate(250,0);
con1.fillRect(0,0,40,40);
con1.restore();
~function draw() {  //【变形】示例：http://www.html5.jp/blog/contents/HTML5-Tech-Talk-201001/transform-jquery.html
  con1.translate(200, 200);
  var sin = Math.sin(Math.PI/6);
  var cos = Math.cos(Math.PI/6);
  for (var i=0; i &lt;= 12; i++) {
    con1.fillRect(0, 0, 100, 10);
    con1.transform(cos, sin, -sin, cos, 0, 0);  // (m11, m12, m21, m22, dx, dy) 水平缩放，垂直斜切，水平斜切，垂直缩放，水平平移，垂直平移。
  }
  con1.setTransform(1,0.5 , 0, 1,0, 0);  //set重置后设置。
  con1.fillRect(300,300, 100, 100);
}()
&lt;/script&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20100910_MDC_canvas__2')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20100910_MDC_canvas__2')">Copy</button></div></div>

canvas_HIJ

<div class="runcode"><textarea class="runcode_text" id="runcode_20100910_MDC_canvas__3">&lt;!doctype html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset='UTF-8' /&gt;
&lt;title&gt;cssass.com&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;canvas id="myCanvas" width='350' height="300" style="border:1px solid #c3c3c3;"&gt;ie（有ie9求测试）用户请绕行&lt;/canvas&gt;
&lt;canvas id="myCanvas2" width='350' height="300" style="border:1px solid #c3c3c3;"&gt;ie（有ie9求测试）用户请绕行&lt;/canvas&gt;
&lt;br /&gt;
&lt;select id='types' onchange='comp();'&gt;
	&lt;option value='source-over' selected&gt;source-over&lt;/option&gt;
	&lt;option value='source-in'&gt;source-in&lt;/option&gt;
	&lt;option value='source-out'&gt;source-out&lt;/option&gt;
	&lt;option value='source-atop'&gt;source-atop&lt;/option&gt;
	&lt;option value='destination-over'&gt;destination-over&lt;/option&gt;
	&lt;option value='destination-in'&gt;destination-in&lt;/option&gt;
	&lt;option value='destination-out'&gt;destination-out&lt;/option&gt;
	&lt;option value='destination-atop'&gt;destination-atop&lt;/option&gt;
	&lt;option value='lighter'&gt;lighter&lt;/option&gt;
	&lt;option value='darker'&gt;darker&lt;/option&gt;
	&lt;option value='copy'&gt;copy&lt;/option&gt;
	&lt;option value='xor'&gt;xor&lt;/option&gt;
&lt;/select&gt;
&lt;script type="text/javascript"&gt;
var $id=function(n){
	return document.getElementById(n) || n;
}
//组合
var con1=$id("myCanvas").getContext('2d');
function comp(){
	con1.save();
	con1.clearRect(0,0,200,300);
    con1.fillStyle = "#09f";
    con1.fillRect(15,15,70,70);
    con1.globalCompositeOperation =$id('types').value; //对所以绘制的图形均起作用。
    con1.fillStyle = "#f30";
    con1.beginPath();
    con1.arc(75,75,35,0,Math.PI*2,true);
    con1.fill();
	con1.restore();
	con1.font='20px Times New Roman';
	con1.fillText($id('types').value,0,200)
}
comp();
//clip
var con2=$id("myCanvas2").getContext('2d');
function draw() {
  con2.save();
  con2.translate(100,100);
  con2.fillRect(0,0,150,150);
  con2.translate(75,75);
  con2.beginPath();
  con2.arc(0,0,60,0,Math.PI*2,true);
  con2.clip();
  con2.fillStyle = '#143778';
  con2.fillRect(-75,-75,150,150);
  for (j=1;j&lt;50;j++){
    con2.save();
    con2.fillStyle = '#fff';
    con2.translate(75-Math.floor(Math.random()*150),75-Math.floor(Math.random()*150));
	drawStar(con2,Math.floor(Math.random()*4)+2);
    con2.restore();
  }
  con2.restore();
}
draw();
function drawStar(con2,r){  //五角星的画法
  con2.save();
  con2.beginPath()
  con2.moveTo(r,0);
  for (i=0;i&lt;9;i++){
    con2.rotate(Math.PI/5);
    if(i%2 == 0) {
      con2.lineTo((r/0.525731)*0.200811,0);
    } else {
      con2.lineTo(r,0);
    }
  }
  con2.closePath();
  con2.fill();
  con2.restore();
}
&lt;/script&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20100910_MDC_canvas__3')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20100910_MDC_canvas__3')">Copy</button></div></div>
