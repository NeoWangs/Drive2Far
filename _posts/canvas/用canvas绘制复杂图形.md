---
layout: post
title: "用canvas绘制复杂图形"
date: "2011-01-21 17:08:45 +0800"
slug: "用canvas绘制复杂图形"
category: "developer"
categories:
  - "developer"
tags:
  - "canvas"
permalink: "/2011/01/21/用canvas绘制复杂图形/"
---

在闪吧看见一棵树，移植到canvas+javascript里来。

```html runcode
<!doctype html>
<html>
<head>
<meta charset='UTF-8' />
<title>Tree</title>
</head>
<body>
<canvas id="pad" width='1000' height='500'><a href='http://www.cssass.com'>cssass.com</a>提醒您：ie9以下用户请一边惭愧去吧</canvas>
</body>
<script>
var con=document.getElementById("pad").getContext('2d');
	con.strokeStyle = '#000';
	con.lineWidth=0.8;
function dw(ax, ay, bx, by) {
	con.beginPath()
	con.moveTo(ax, ay);
	con.lineTo(bx, by);
	con.stroke();
}
function lzh(x, y, l, angle, n) {
	if (n>0) {
		var a_l, a_r, x1, y1, x2, y2, y2_l;
		x1 = x+0.5*l*Math.cos(angle*Math.PI/180);
		y1 = y-0.5*l*Math.sin(angle*Math.PI/180);
		x2 = x+l*Math.cos(angle*Math.PI/180);
		y2 = y-l*Math.sin(angle*Math.PI/180);
		dw(x, y, x2, y2);
		a_l = angle+30;
		a_r = angle-30;
		l=l*2/3
		lzh(x2, y2, l, angle+rand, n-1);
		lzh(x1, y1, l*2/3, a_l+rand/2, n-1);
		lzh(x1, y1, l*2/3, a_r+rand/2, n-1);
		lzh(x2, y2, l*2/3, a_l+rand/2, n-1);
		lzh(x2, y2, l*2/3, a_r+rand/2, n-1);
		}
	}
var rand=2-Math.random()*10
lzh(300, 400, 100, 90, 6);
</script>
</html>
```

用setInterval让它动起来

```html runcode
<!doctype html>
<html>
<head>
<meta charset='UTF-8' />
<title>Tree</title>
</head>
<body>
<canvas id="pad" width='1000' height='500'><a href='http://www.cssass.com'>cssass.com</a>提醒您：ie9以下用户请一边惭愧去吧</canvas>
</body>
<script>
var con=document.getElementById("pad").getContext('2d');
    con.strokeStyle = '#000';
    con.lineWidth=0.8;
var Tree=function(x, y, l, angle, n){
    var a=[],rand=0,dir=1,val;
    this.init=function(x, y, l, angle, n) {
        var that=this;
        if (n>0) {
            var a_l, a_r, x1, y1, x2, y2;
            x1 = x+0.5*l*Math.cos(angle*Math.PI/180);
            y1 = y-0.5*l*Math.sin(angle*Math.PI/180);
            x2 = x+l*Math.cos(angle*Math.PI/180);
            y2 = y-l*Math.sin(angle*Math.PI/180);
            a.push([x, y, x2, y2]);
            a_l = angle+30;
            a_r = angle-30;
            l=l*2/3;
            that.init(x2, y2, l, angle+rand, n-1);
            that.init(x1, y1, l*2/3, a_l+rand/2, n-1);
            that.init(x1, y1, l*2/3, a_r+rand/2, n-1);
            that.init(x2, y2, l*2/3, a_l+rand/2, n-1);
            that.init(x2, y2, l*2/3, a_r+rand/2, n-1);
         };
    };
    this.run=function(){
		con.clearRect(0,0,1000,500);
        for(var i=0; i<a.length; i++){
            this.dw(a[i][0],a[i][1],a[i][2],a[i][3]);
        };
		a=[];
    };
	this.move=function(){
		var that = this;
		var _s=function(){
			that.change();
			that.init(x, y, l, angle, n);
			that.run();
			setTimeout(_s,100);
		};
		_s();
	};
	this.change=function(){
		val=Math.random()*2;
		rand+=dir*val;
		if(rand>10 || rand<-2){dir=-dir;}
	};
	this.init(x, y, l, angle, n);
	this.run();
};
Tree.prototype.dw=function(ax, ay, bx, by){
    con.beginPath()
    con.moveTo(ax, ay);
    con.lineTo(bx, by);
    con.stroke();
};
new Tree(300, 400, 100, 90, 6).move();
</script>
</html>
```

补充：
除了setTimeout/setInterval这两个函数控制动画外。现在很多浏览器还提供了另一个函数requestAnimationFrame，这个函数接口所拥有的优势是：

对于一个侦中对DOM的所有操作，只进行一次Layout和Paint。
如果发生动画的元素被隐藏了，那么就不再去Paint。

不过这个方法的使用只类似于递归调用，并没有一个时间停顿，所以我们一般要根据记录时间间隔来决定动画的每一帧的绘制情况。
下面用requestAnimationFrame来完成上面的动画。由于requestAnimationFrame的兼容性，我们需要先写一个兼容性的方法（来自three.js）：


```
(function() {
    /* 兼容requestAnimationFrame */
    var lastTime = 0;
    var vendors = ['ms', 'moz', 'webkit', 'o'];
    for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
        window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
        window.cancelAnimationFrame = window[vendors[x]+'CancelAnimationFrame'] 
                                   || window[vendors[x]+'RequestCancelAnimationFrame'];
    }
    if (!window.requestAnimationFrame)
        window.requestAnimationFrame = function(callback, element) {
            var currTime = new Date().getTime();
            var timeToCall = Math.max(0, 16 - (currTime - lastTime));
            var id = window.setTimeout(function() { callback(currTime + timeToCall); },
              timeToCall);
            lastTime = currTime + timeToCall;
            return id;
        };
    if (!window.cancelAnimationFrame)
        window.cancelAnimationFrame = function(id) {
            clearTimeout(id);
        };
}());

```

```html runcode
<!doctype html>
<html>
<head>
<meta charset='UTF-8' />
<title>Tree</title>
</head>
<body>
<canvas id="pad" width='1000' height='500'><a href='http://www.cssass.com'>cssass.com</a>提醒您：ie9以下用户请一边惭愧去吧</canvas>
</body>
<script>
(function() {
	/* 兼容requestAnimationFrame */
    var lastTime = 0;
    var vendors = ['ms', 'moz', 'webkit', 'o'];
    for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
        window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
        window.cancelAnimationFrame = window[vendors[x]+'CancelAnimationFrame']
                                   || window[vendors[x]+'RequestCancelAnimationFrame'];
    }
    if (!window.requestAnimationFrame)
        window.requestAnimationFrame = function(callback, element) {
            var currTime = new Date().getTime();
            var timeToCall = Math.max(0, 16 - (currTime - lastTime));
            var id = window.setTimeout(function() { callback(currTime + timeToCall); },
              timeToCall);
            lastTime = currTime + timeToCall;
            return id;
        };
    if (!window.cancelAnimationFrame)
        window.cancelAnimationFrame = function(id) {
            clearTimeout(id);
        };
}());
var con = document.getElementById("pad").getContext('2d');
    con.strokeStyle = '#000';
    con.lineWidth=0.8;
var Tree = function(x, y, l, angle, n){
    var a=[],rand=0,dir=1,val;
    this.init = function(x, y, l, angle, n) {
        var that = this;
        if (n>0) {
            var a_l, a_r, x1, y1, x2, y2;
            x1 = x+0.5*l*Math.cos(angle*Math.PI/180);
            y1 = y-0.5*l*Math.sin(angle*Math.PI/180);
            x2 = x+l*Math.cos(angle*Math.PI/180);
            y2 = y-l*Math.sin(angle*Math.PI/180);
            a.push([x, y, x2, y2]);
            a_l = angle+30;
            a_r = angle-30;
            l=l*2/3;
            that.init(x2, y2, l, angle+rand, n-1);
            that.init(x1, y1, l*2/3, a_l+rand/2, n-1);
            that.init(x1, y1, l*2/3, a_r+rand/2, n-1);
            that.init(x2, y2, l*2/3, a_l+rand/2, n-1);
            that.init(x2, y2, l*2/3, a_r+rand/2, n-1);
         };
    };
    this.run=function(){
		con.clearRect(0,0,1000,500);
        for(var i=0; i<a.length; i++){
            this.dw(a[i][0],a[i][1],a[i][2],a[i][3]);
        };
		a=[];
    };
	this.move = function(){
		var that = this;
		var start = new Date().getTime(),
			delta;
		(function _s(){
			delta = new Date().getTime() - start;
			if( delta > 100 ){
				start = new Date().getTime();
				that.change();
				that.init(x, y, l, angle, n);
				that.run();
			}
			return requestAnimationFrame(_s)
		})();
	};
	this.change=function(){
		val = Math.random()*2;
		rand += dir*val;
		if (rand >10 || rand < -2){ dir = -dir; }
	};
	this.init(x, y, l, angle, n);
	this.run();
};
Tree.prototype.dw=function(ax, ay, bx, by){
    con.beginPath()
    con.moveTo(ax, ay);
    con.lineTo(bx, by);
    con.stroke();
};
new Tree(300, 400, 100, 90, 6).move();
</script>
</html>
```

再画几个图形：

```html runcode
<!doctype html>
<html>
<head>
<meta charset='UTF-8' />
<title>那些花儿</title>
<style>
*{padding:0;margin:0;}
html,body{height:100%;overflow:hidden;background:#333;}
</style>
</head>
<body>
<canvas id="pad" width='2000' height='1000'><a href='http://www.cssass.com'>cssass.com</a>提醒您：ie9以下用户请一边惭愧去吧</canvas>
</body>
<script>
var con=document.getElementById("pad").getContext('2d');
	con.strokeStyle = 'rgba(255,255,255,0.5)';
	con.lineJoin = 'round';
	con.lineCap = 'round';
	con.lineWidth=.5;
function Tad(x,y,c){ /* 位置，角数 */
	var l,r,n,k,mx;
	var xt=0, yt=0, angle=0 ,a=[];
		r=360/c; //每只角分到的度数
		var t=5; //转角
		while(t>1){
			if(r%t===0) break;
			t--;
		};
		n=360/t; //总线条数
		k=r/t; //每只角分到的线条数
	this.init=function(){
		if(a.length<n){
			angle+=t;
			a.unshift(angle);  //存储所有转角
			this.init();
		};
	};
	this.change=function(){
		angle+=t;
		a.unshift(angle)
		a.pop(angle);
		this.body(x,y);
	};
	this.body=function() {
		l=0; //线长(初始)
		o=c; //每次增加的线长.这个值可以自定义
		mx=l+ k*o + 10; //直径(最大值)
		con.clearRect(x-mx/2, y-mx/2, mx, mx);
		for(var i=1; i<a.length; i++) {
			l+=o;
			if(Math.floor(i%(k/2))===0) { //峰谷时反向
				o=-o;
				if(i%(k/2)===0.5) {l+=o;} //遇到k是奇数的情况。如c=8时。
			}
			xt = l*Math.cos(a[i-1]*Math.PI/180);
			yt = l*Math.sin(a[i-1]*Math.PI/180);
			this.dw(x, y, x+xt, y-yt);
		}
	};
	this.init();
	this.body();
}
Tad.prototype.move=function(){
	var that = this;
	var _s=function(){
		that.change();
		setTimeout(_s,100);
	}
	_s();
};
Tad.prototype.dw=function(ax, ay, bx, by) {
	con.beginPath();
	con.moveTo(ax, ay);
	con.lineTo(bx, by);
	con.stroke();
};
new Tad(100,100,15).move();
new Tad(200,100,12).move();
new Tad(300,100,9).move();
new Tad(400,100,8).move();
new Tad(500,100,6).move();
new Tad(100,200,5).move();
new Tad(200,200,4).move();
new Tad(300,200,3).move();
new Tad(400,200,2).move();
new Tad(500,200,1).move();
</script>
</html>
```
