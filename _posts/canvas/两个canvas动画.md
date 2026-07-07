---
layout: post
title: "两个canvas动画"
date: "2010-12-27 17:01:26 +0800"
slug: "两个canvas动画"
category: "developer"
categories:
  - "developer"
tags:
  - "canvas"
permalink: "/2010/12/27/两个canvas动画/"
---

几星期前参加ie9开发大赛做了一个《ie9大风车》（呃，我承认名字很挫）。

这个小玩意的难度在于，里面的所有东西都不是图片，而是用canvas写的，之前写的贝塞尔曲线的可视化操作实现倒是帮了大忙，不过据说AI已有插件直接导出canvas绘图代码了，那我的手写代码的生产力就太落后了。

支持的浏览器包括ie9,firefox,chrome,safari。在opera下有个bug,暂时无法修复。
<div class="runcode"><textarea class="runcode_text" id="runcode_20101227__canvas__1">&lt;!doctype html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset='UTF-8' /&gt;
&lt;title&gt;IE9 Pinwheel&lt;/title&gt;
&lt;style&gt;
/*
*	IE9大风车
*	author: ONEBOYS
*	blog: http://www.cssass.com
*	谢谢观赏
*/
*{padding:0;margin:0;}
html,body{height:100%;overflow:hidden;text-align:center;}
#middle{position:relative;z-index:2;width:750px;margin:0 auto;}
#middle canvas{position:relative;}
#bg{position:absolute;z-index:1;top:0;left:0;}
&lt;/style&gt;
&lt;/head&gt;
&lt;body &gt;
	&lt;canvas id="bg"&gt;&lt;/canvas&gt;
	&lt;div id='middle'&gt;&lt;/div&gt;
&lt;/body&gt;
&lt;script type="text/javascript"&gt;
var G={}
G.$=function(n){
	return document.getElementById(n) || n;
}
G.scrW=function(){return document.body.offsetWidth;}
G.scrH=function(){return document.body.offsetHeight;}
function Pad(){
	var m=1, sign=1, lineWidth=3;
	this.init = function(o){
		this.create(o.name);
		this.S= o.size || 150; //pad尺寸
		this.radius = this.S/3; //logo半径
		this.posX = this.S/2; //logo原点位置
		this.posY = this.S/2;
		this.turn = o.turn || 8;	//补间时限
		this.con = G.$(o.name).getContext('2d');
		this.timeout = null;
		this.radi=this.con.createRadialGradient(-this.radius * 0.1,-this.radius * 0.2, this.radius * 0.5 , 0 , -this.radius * 0.1, this.radius *1.1);  //logo渐变
		this.radi.addColorStop(0, 'rgba(126,226,253,1)');
		this.radi.addColorStop(0.6, 'rgba(69,182,239,1)');
		this.radi.addColorStop(1, 'rgba(20,133,211,1)');
		this.radi2= this.con.createLinearGradient(this.radius * 2.2 , this.radius * 0.2 , this.radius * 0.2 , this.radius * 2.2); //光环渐变
		this.radi2.addColorStop(0, 'rgba(255,187,44,.9)');
		this.radi2.addColorStop(0.5, 'rgba(255,242,102,.9)');
		this.radi2.addColorStop(1, 'rgba(255,187,44,.9)');
		G.$(o.name).width=this.S;
		G.$(o.name).height=this.S;
		this.run();
	};
	this.create = function(n){ //创建canvas
		var temp=document.createElement('canvas');
		var that = this;
		temp.id=n;
		var bind=function(){
			clearTimeout(that.timeout);
			that.turn = 3;
			that.run();
		};
		var drag=function(){
			var o=this,e=arguments[0];
			var tX=parseInt(o.style.left) || 0,
				tY=parseInt(o.style.top) || 0,
				dx=e.clientX,
				dy=e.clientY;
			document.onmousemove=function(e){
				o.style.left=tX+e.clientX-dx+"px";
				o.style.top=tY+e.clientY-dy+"px";
			}
			document.onmouseup=function(){
				document.onmousemove=null;
				document.onmouseup=null;
			}
		};
		temp.addEventListener("mousedown",drag,false); //拖动
		temp.addEventListener("mouseover",bind,false); //划过
		temp.addEventListener("touchstart",bind,false); //iOS触屏。（抱歉，由于本人没钱买iPad，还没测试过）
		G.$('middle').appendChild(temp);
	};
	this.run = function(){  //转动
		var that = this;
		var _slide=function(){
			var b=-1 ,t=0, c=2, d=that.turn;
			function _run(){
				if(t&lt;d){ //半圈补间动画
					t++;
					m = - sign * easeInOut(t,b,c,d);
					that.con.clearRect(0, 0, that.S, that.S);
					that.drawLogo();
					that.drawHalo();
					that.timeout=setTimeout(_run, 10);
				}
				else{  //完成半圈
					sign=-sign;
					that.turn++;
					that.timeout=setTimeout(_slide, 10);
				};
			};
			_run();
		 };
		_slide();
	};
	this.drawLogo=function(){ //绘logo
		this.con.save();
		this.con.translate(this.posX,this.posY);
		if(m === 0) {m = 0.1;}
		this.con.scale(m, 1);
		this.con.beginPath();
		this.con.strokeStyle='#135b9f';
		this.con.fillStyle=this.radi;
		this.con.lineWidth=lineWidth;
		this.con.save();
		this.con.translate(0,-this.radius/8);
		this.con.moveTo(0,0);
		this.con.arc(0,0, this.radius/2 ,0,Math.PI*2/2,true);
		this.con.lineTo(0,0);
		this.con.restore();
		this.con.save();
		this.con.translate(0,this.radius/8);
		this.con.moveTo(this.radius,0);
		this.con.lineTo(-this.radius/2,0)
		this.con.arc(0, 0, this.radius/2 ,Math.PI*2/2,Math.PI*4/24,true);
		var y1=this.radius/2 * Math.sin(Math.PI*4/24) ;
		var x1=Math.sqrt(Math.pow(this.radius,2) - Math.pow(y1+ this.radius/8,2));
		this.con.lineTo(x1,y1);
		this.con.restore();
		var ang1=Math.asin(this.radius/8/this.radius);
		var ang2=Math.acos(x1/this.radius);
		this.con.arc(0, 0, this.radius, ang2, ang1, false);
		this.con.stroke();
		this.con.fill();
		this.con.restore();
	};
	this.drawHalo = function(){  //绘光环
		this.con.save();
		this.con.fillStyle=this.radi2;
		this.con.beginPath();
		this.con.translate(this.posX,this.posY);
		var n=this.radius/105;
		this.con.moveTo(90 * n,-70 * n);
		this.con.bezierCurveTo(125 * n,-202* n,-140* n,-65* n,-128* n,87* n);
		this.con.bezierCurveTo(-125* n,105* n,-105* n,115* n,-60* n,88* n);
		this.con.bezierCurveTo(-59* n,79* n,-108* n,118* n,-114* n,78* n);
		this.con.bezierCurveTo(-115* n,-33* n,117* n,-183* n,88* n,-70* n);
		this.con.fill();
		this.con.restore();
	};
};
var drawBg=function(){ //绘背景
	var bg=G.$("bg").getContext('2d');
	G.$('bg').width=G.scrW() ;
	G.$('bg').height=G.scrH() ;
	var lineBg = bg.createLinearGradient(1000,0,0,800);
	lineBg.addColorStop(0,'#98ff5a');
	lineBg.addColorStop(0.4,'#64dbc5');
	lineBg.addColorStop(0.8,'#00b8fe');
	lineBg.addColorStop(1,'#0034bb');
	bg.save();
	bg.fillStyle=lineBg;
	bg.fillRect(0,0,G.scrW(),G.scrH());
	bg.fillStyle='#fff';
	bg.transform(-1,0,0,1,G.scrW(),0);
	for (var i=20;i&gt;0;i--){
      bg.beginPath();
	  bg.scale(1,0.95);
		if(i % 2 === 0){bg.globalAlpha = 0.05;}
		else{bg.globalAlpha = 0.03;}
      bg.arc(i*i*1.2 ,200 + i*5, 80+i*i, 0, Math.PI*2, true);
      bg.fill();
	}
	bg.restore();
}
function easeInOut(t,b,c,d){ //补间算法
	if ((t/=d/2) &lt; 1) return c/2*t*t + b;
	return -c/2 * ((--t)*(t-2) - 1) + b;
}
window.onload=function(){
	drawBg();
	var max=20;
	//var size=Math.max(G.scrW()/Math.sqrt(max),G.scrH()/Math.sqrt(max));
	for(var i=0 ; i&lt;max; i++ ){
		new Pad().init({name:'pad'+i, turn: i+5});
	}
};
window.onresize=function(){drawBg();}
&lt;/script&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20101227__canvas__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20101227__canvas__1')">Copy</button></div></div>

下面是另一个玩意《忍者镖》，话说是受了这个大赛（http://js1k.com/2010-first/demos ）的刺激才写的。
在这个大赛里，所有的Demo都必须小于1KB。

于是，我就把我的代码往死里压。从这样：

<div class="runcode"><textarea class="runcode_text" id="runcode_20101227__canvas__2">&lt;!doctype html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset='UTF-8' /&gt;
&lt;title&gt;忍者镖&lt;/title&gt;
&lt;style&gt;
*{padding:0;margin:0;}
html,body{height:100%;overflow:hidden;text-align:center;}
#middle{position:relative;z-index:2;height:100%;}
#middle canvas{position:absolute;top:0;left:0;}
#bg{position:absolute;z-index:1;top:0;left:0;}
&lt;/style&gt;
&lt;/head&gt;
&lt;body &gt;
	&lt;canvas id="bg"&gt;&lt;/canvas&gt;
	&lt;div id='middle'&gt;&lt;/div&gt;
&lt;/body&gt;
&lt;script type="text/javascript"&gt;
var G={}
G.$=function(n){
	return document.getElementById(n) || n;
}
G.scrW=function(){return document.body.offsetWidth;}
G.scrH=function(){return document.body.offsetHeight;}
function Pad(){};
Pad.prototype.init = function(o){
		this.create(o.name);
		this.S= o.size || 400;
		this.posX = this.S/2;
		this.posY = this.S/2;
		this.con = G.$(o.name).getContext('2d');
		G.$(o.name).width=this.S;
		G.$(o.name).height=this.S;
		this.m = o.m || 0;
		this.run();
	};
Pad.prototype.run = function(){
		var sign=1;
		var that = this;
		var _slide=function(){
			var t=0;
			function _run(){
				if(t&lt;Math.PI*6){
					t += 0.1;
					that.m += sign * 0.1;
					that.con.clearRect(0, 0, that.S, that.S);
					that.draw();
					that.timeout=setTimeout(_run, 10);
				}
				else{
					sign=-sign;
					that.timeout=setTimeout(_slide, 10);
				}
			};
			_run();
		 };
		_slide();
	};
Pad.prototype.draw=function(){
		this.con.save();
		this.con.translate(this.posX,this.posY);
		this.con.rotate(this.m);
		if(this.m === 0) {this.m = 0.001;}
		this.con.scale(this.m/10,this.m/10);
		this.con.strokeStyle='#3E392E';
		this.con.fillStyle="#F9F9FA";
		this.con.lineWidth=1;
		this.drawNinja()
		this.con.restore();
	}
Pad.prototype.create = function(n){
		var temp=document.createElement('canvas');
		var that = this;
		temp.id=n;
		G.$('middle').appendChild(temp);
};
Pad.prototype.drawNinja=function(){
	this.con.beginPath();
	this.con.moveTo(20,-20);
	this.con.lineTo(80,0);
	this.con.lineTo(20,20);
	this.con.lineTo(0,80);
	this.con.lineTo(-20,20);
	this.con.lineTo(-80,0);
	this.con.lineTo(-20,-20);
	this.con.lineTo(0,-80);
	this.con.lineTo(20,-20);
	this.con.translate(0,0);
	this.con.arc(0,0,8,0,Math.PI*2,true);
	this.con.stroke();
	this.con.fill();
};
var drawBg=function(){
	var bg=G.$("bg").getContext('2d');
	G.$('bg').width=G.scrW() ;
	G.$('bg').height=G.scrH() ;
	var lineBg = bg.createLinearGradient(1000,0,0,800);
	lineBg.addColorStop(0,'#eee');
	lineBg.addColorStop(0.4,'#818181');
	lineBg.addColorStop(0.8,'#434343');
	lineBg.addColorStop(1,'#141414');
	bg.fillStyle=lineBg;
	bg.fillRect(0,0,G.scrW(),G.scrH());
}
window.onload=function(){
	var max=10;
	for(var i=0 ; i&lt;max; i++ ){
		new Pad().init({name:'pad'+i, m:i*0.1});
	}
	drawBg();
};
window.onresize=function(){drawBg();}
&lt;/script&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20101227__canvas__2')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20101227__canvas__2')">Copy</button></div></div>
斩头去尾，挖心掏肺，搞成这样：

<div class="runcode"><textarea class="runcode_text" id="runcode_20101227__canvas__3">&lt;!doctype html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;style&gt;
body{overflow:hidden;background:#666;}
canvas{position:absolute;top:0;left:0;}
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;&lt;/body&gt;
&lt;script type="text/javascript"&gt;
function g(){var b=this;b.d=function(a){b.create();b.a=a.a;b.e()};b.e=function(){function a(){function e(){if(f&lt;Math.PI*8){f+=0.1;c.a+=d*0.1;c.b.clearRect(0,0,400,400);c.c();c.timeout=setTimeout(e,10)}else{d=-d;c.timeout=setTimeout(a,10)}}var f=0;e()}var d=1,c=b;a()};b.c=function(){var a=b.b;a.save();a.translate(200,200);a.rotate(b.a);if(b.a===0)b.a=0.0010;a.scale(b.a/10,b.a/10);a.strokeStyle="#333";a.fillStyle="#eee";a.lineWidth=1;a.beginPath();a.moveTo(20,-20);a.lineTo(80,0);a.lineTo(20,20);a.lineTo(0, 80);a.lineTo(-20,20);a.lineTo(-80,0);a.lineTo(-20,-20);a.lineTo(0,-80);a.lineTo(20,-20);a.translate(0,0);a.arc(0,0,8,0,Math.PI*2,true);a.stroke();a.fill();a.restore()};b.create=function(){var a=document.createElement("canvas");a.width=400;a.height=400;b.b=a.getContext("2d");document.body.appendChild(a)}}window.onload=function(){for(var b=0;b&lt;10;b++)(new g).d({a:b*0.1})};
&lt;/script&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20101227__canvas__3')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20101227__canvas__3')">Copy</button></div></div>
结果，我的文件大小依然超出1KB，不得不佩服那些1KB Demos啊，个顶个的又小又炫。
