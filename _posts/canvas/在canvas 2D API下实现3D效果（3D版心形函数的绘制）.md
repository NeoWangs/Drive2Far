---
layout: post
title: "在canvas 2D API下实现3D效果（3D版心形函数的绘制）"
date: "2011-02-24 10:06:04 +0800"
slug: "在canvas 2D API下实现3D效果（3D版心形函数的绘制）"
category: "developer"
categories:
  - "developer"
tags:
  - "canvas"
permalink: "/2011/02/24/在canvas 2D API下实现3D效果（3D版心形函数的绘制）/"
---

html5的canvas为我们提供了浏览器原生支持的绘图API。或者说，大多数浏览器已经为我们提供了原生的绘图API：HTML5的canvas
目前，这个API只提供2D context，并不支持3D绘图，但是web上从来就不缺牛人，各种canvas下绘制的3D效果层出不穷，令人吱吱称赞。（补充，后来有了WebGL）
有3D圣诞树：http://www.romancortes.com/blog/how-i-did-the-1kb-christmas-tree
有3D的FPS：使用 HTML 5 canvas 和光线投影算法创建伪 3D 游戏
还有3D俄罗斯：http://www.benjoffe.com/code/games/torus/
不胜枚举…

其实，无论canvas是否提供API，在我们目前这种二维显示设备下显示，势必都要将3维形状投影到2维平面坐标上。无论多炫的3D效果也只是二维平面上的投影。
对于此，读过《三体》特别是第三部《死神永生》的同学或许会大有感触吧。

人们总是喜欢用这样一个类比:想象生活在三维空间中的一张二维平面画中的扁片人,不管这幅画多么丰富多彩,其中的二维人只能看到周围世界的侧面,在他们眼中,周围的人和事物都是一些长短不一的线段而已。只有当一个二维扁片人从画中飘出来,进人三维空间,再回头看那幅画,才能看到画的全貌。
这个类比,其实也只是进一步描述了四维感觉的不可描述。

关于《三体——死神永生》里四维空间（不算时间维）的讨论，这里还有篇有意思的博文：四维世界的堵车问题

好了，言归正传。
下面提供一个三维到二维的投影算法（from www.benjoffe.com）：

```

var theta = 4.2; //转角
var eleva = 0.6; //仰角
function iso(x,y,z){
var dist = Math.sqrt(x*x+y*y);
var angle = (x==0 && y==0) ? 0 : Math.atan(y/x) + theta + ((x<0)? Math.PI : 0);

x=Math.cos(angle)*dist;
y=-Math.sin(angle)*dist;
var fact = (y*Math.cos(eleva) + z*Math.sin(eleva)+8)/8;
y=y*Math.sin(eleva) - z*Math.cos(eleva);
x*=fact;
y*=fact;

return {
x: x,
y: y
};
}

```

输入是x,y,z三个三维坐标下的值，输出是x，y两个二维坐标值。

我们应用一下：下面是一个3D球

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset='UTF-8' />
<title>2D canvas API下的3D效果</title>
<style>
body{background:#cbe846;}
</style>
</head>
<body title='拖到鼠标'>
<canvas id="pad" width="800" height="800"><a href='http://www.cssass.com'>cssass.com</a>提醒您：本例使用HTML5的canvas标签。ie9以下用户请一边惭愧去吧</canvas>
<script type="text/javascript" >
	function g(e){
		return document.getElementById(e);
	}
	/* 一个插值算法(无关紧要) */
	function Cubic(t,b,c,d){
		return c*(t/=d)*t*t + b;
	}
	var ctx = g('pad').getContext('2d');
		ctx.scale(100,100);
		ctx.translate(3,3);
	var theta = 4.2; //转角
	var eleva = 0.6; //仰角
	/* 投影算法（from: www.benjoffe.com） */
	function iso(x,y,z){
		var dist = Math.sqrt(x*x+y*y);
		var angle = (x==0 && y==0) ? 0 : Math.atan(y/x) + theta + ((x<0)? Math.PI : 0);
		x=Math.cos(angle)*dist;
		y=-Math.sin(angle)*dist;
		var fact = (y*Math.cos(eleva) + z*Math.sin(eleva)+8)/8;
		y=y*Math.sin(eleva) - z*Math.cos(eleva);
		x*=fact;
		y*=fact;
		return {
			x: x,
			y: y
		};
	}
	/* 球方程 x^2+y^2+z^2=r^2 */
	function sphere(r){
		var x,y,z;
		var t;
		z=-r;
		while(z<r){
			x=-Math.sqrt(r*r-z*z);
			y=0;
			t=1;
			co = iso(x,y,z); ctx.moveTo(co.x, co.y);
			while(true){
				y=Math.sqrt((r*r-x*x-z*z))*t;
				if(isNaN(y)){  /* 此时，x值为极值,y的绝对值已经不能再小 */
					if(t==1) {t=-t; x=Math.sqrt(r*r-z*z); continue;} /* x值达到最大 */
					else break;
				};
				co = iso(x,y,z); ctx.lineTo(co.x, co.y);
				x+=0.1*t;
			}
			ctx.closePath();
			z=Cubic(1,z,2*r,4); //应用插值算法（分布均匀些）
		}
	}
	function preview(){
		ctx.clearRect(-3,-3,10,10);
		ctx.lineWidth=0.001;
		ctx.lineJoin = "round";
		ctx.strokeStyle = 'rgba(0,0,100,0.8)';
		var co;
		ctx.beginPath();
		sphere(2);
		ctx.stroke();
	}
	preview();
	/* 鼠标控制 */
	g('pad').onmousedown=function(e){
		var x0 = e.clientX, y0 = e.clientY;
		document.onmousemove=function(e){
				theta -= (x0 - (x0=e.clientX))/100;
				eleva -= (y0 - (y0=e.clientY))/100;
				theta%=Math.PI*2; if (theta<0) theta+=Math.PI*2;
				eleva%=Math.PI*2; if (eleva<0) eleva+=Math.PI*2;
				preview();
		}
		document.onmouseup=function(e){
			document.onmousemove=null;
		}
	};
</script>
</body>
</html>
```

以上代码是对球面的方程 x^2+y^2+z^2=r^2进行求解，将解（x,y,z）代入iso方法，最后根据输出二维坐标进行绘图。
对于这个球面方程的解法，也是各有各的写法。
（这里有个Functions 3D的应用，用来将方程式输出成3D图形：http://www.benjoffe.com/code/tools/functions3d/）

如果你看到过我这篇文章的话：笛卡尔情书的秘密——心形函数的绘制
我相信你也很可能知道网上还有一个3D版是心形函数：(x^2 + (9/4)y^2 + z^2 – 1)^3 – x^2*z^3 – (9/80)y^2*z^3 = 0
下面我将使用上面的iso方法在canvas中将其绘制出来，你可以拖到鼠标来看3D效果。

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset='UTF-8' />
<title>3D LOVE in canvas</title>
<style>
body{background:#efd5e2;}
</style>
</head>
<body  title='拖到鼠标'>
<canvas id="pad" width="800" height="800" ><a href='http://www.cssass.com'>cssass.com</a>提醒您：本例使用了HTML5的canvas标签。ie9以下用户请一边惭愧去吧</canvas>
</body>
<script type="text/javascript" >
	function g(e){
		return document.getElementById(e);
	}
	var theta = -0.4; //转角
	var eleva = -0.1; //仰角
	var pad = g('pad');
	var ctx = pad.getContext('2d');
		ctx.translate(200,200);
		ctx.scale(82,82);
	/* 将三维投射到二维（三维直角坐标系转平面直角坐标系） */
	function iso(x,y,z){
		var dist = Math.sqrt(x*x+y*y);
		var angle = (x==0 && y==0) ? 0 : Math.atan(y/x) + theta + ((x<0)? Math.PI : 0);
		x=Math.cos(angle)*dist;
		y=-Math.sin(angle)*dist;
		var fact = (y*Math.cos(eleva) + z*Math.sin(eleva)+8)/8;
		y=y*Math.sin(eleva) - z*Math.cos(eleva);
		x*=fact;
		y*=fact;
		return {
			x: x,
			y: y
		};
	}
	/* 方程式: (x^2 + (9/4)y^2 + z^2 - 1)^3 - x^2*z^3 - (9/80)y^2*z^3 < 0 */
	function love(){
		var x,y,z,m,t=3;
		for(z=-3;z<=3;){
			for(y=-3;y<=3;){
				for(x=-3;x<=3;){
					m=(x*x + (9/4)*y*y + z*z - 1)*(x*x + (9/4)*y*y + z*z - 1)*(x*x + (9/4)*y*y + z*z - 1) - x*x*z*z*z - (9/80)*y*y*z*z*z;
					if(m<0){
						co = iso(x,y,z);
						ctx.strokeRect(co.x, co.y,0.02,0.02);
						ctx.closePath();
					}
					x+=0.11;
				}
				y+=0.11;
			}
			z+=0.11;
		}
	}
	function preview(){
		ctx.clearRect(-10,-10,20,20);
		ctx.lineWidth=0.008;
		ctx.lineJoin = "round";
		ctx.strokeStyle = 'rgba(150,0,100,0.3)';
		var co;
		ctx.beginPath();
		love();
		ctx.stroke();
	};
	preview();
	/* 鼠标拖动控制 */
	pad.onmousedown=function(e){
		var x0 = e.clientX, y0 = e.clientY;
		document.onmousemove=function(e){
				theta -= (x0 - (x0=e.clientX))/100;
				eleva -= (y0 - (y0=e.clientY))/100;
				theta%=Math.PI*2; if (theta<0) theta+=Math.PI*2;
				eleva%=Math.PI*2; if (eleva<0) eleva+=Math.PI*2;
				preview();
		}
		document.onmouseup=function(e){
			document.onmousemove=null;
		}
	}
</script>
</html>
```

我们知道，三维空间下的坐标系不止直角坐标一种，还有 圆柱坐标系，球坐标系等等。
下面我们将iso方法转换一下，是输入使用球坐标系值（θ,Φ,r）——转角，仰角，球半径。
首先我们先要知道，三维直角坐标系于球坐标系的换算式：

```
x=rsinθcosφ 　
y=rsinθsinφ 　　
z=rcosθ

```
呃哦，代入iso函数后我们发现iso变的更简单了：


```
var theta = 4.2; //转角
var eleva = 0.6; //仰角
function iso(a,b,r){
var x,y,z
x=r*Math.cos(a+this.theta)*Math.sin(b);
y=r*Math.sin(a+this.theta)*Math.sin(b);
z=r*Math.cos(b);

var fact = (y*Math.cos(this.eleva) + z*Math.sin(this.eleva)+8)/8;
y=y*Math.sin(this.eleva) + z*Math.cos(this.eleva);
x*=fact;
y*=fact;
return {
x: x,
y: y
};
}

```

下面是我们使用球坐标系绘制的三维图形（三维投射到二维的图形）

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset='UTF-8' />
<title>球坐标系投影到二维直角坐标系</title>
<style>
	body{background:#666;}
</style>
</head>
<body>
<canvas id="pad" width="800" height="800"><a href='http://www.cssass.com'>cssass.com</a>提醒您：本例使用了HTML5的canvas标签。ie9以下用户请一边惭愧去吧</canvas>
</body>
<script type="text/javascript" >
	function g(e){
		return document.getElementById(e);
	}
	var random=function(){
		return (Math.random()*10>>0)/10;
	}
	var ctx = g('pad').getContext('2d');
		ctx.scale(100,100);
		ctx.lineWidth=0.002;
		ctx.lineJoin = "round";
	var Ball=function(x,y,r){
		this.theta = 0; //球坐标转角
		this.eleva = 0; //球坐标仰角
		this.radius= r || 1; //球坐标半径
		this.pos={ //球坐标原点
			x:x || 2,
			y:y || 2
		};
		this.co={ //二维上的投影坐标
			x:0,
			y:0
		};
		this.col={ //颜色
			r:255,
			g:255,
			b:255,
			a:0.6
		};
		this.init=function(){
			ctx.translate(this.pos.x,this.pos.y);
			this.preview();
		};
		this.init();
	};
	/* 球坐标系转平面直角坐标系 */
	Ball.prototype.iso=function(a,b,r){
		var x,y,z
		x=r*Math.cos(a+this.theta)*Math.sin(b);
		y=r*Math.sin(a+this.theta)*Math.sin(b);
		z=r*Math.cos(b);
		var fact = (y*Math.cos(this.eleva) + z*Math.sin(this.eleva)+8)/8;
		y=y*Math.sin(this.eleva) + z*Math.cos(this.eleva);
		x*=fact;
		y*=fact;
		return {
			x: x,
			y: y
		};
	}
	Ball.prototype.preview=function(){
		ctx.strokeStyle = 'rgba('+this.col.r+','+this.col.g+','+this.col.b+','+this.col.a+')';
		ctx.clearRect(-2,-2,4,4);
		ctx.beginPath();
		this.sphere();
		ctx.stroke();
	}
	Ball.prototype.sphere=function(){
		var a,b;
		for(a=0; a<2*Math.PI; a+=Math.PI/12){
			for(b=0; b<2*Math.PI; b+=Math.PI/12){
				if(b ==0 || b*100>>0 == Math.PI*100>>0 || b*100>>0 == 2*Math.PI*100>>0)  continue; /* 排除一些仰角(接近)为0/PI/2PI的点.  */
				this.co = this.iso(0,0,0);
				ctx.moveTo(this.co.x, this.co.y);
				this.co = this.iso(a,b,this.radius);
				ctx.lineTo(this.co.x, this.co.y);
			}
		}
	}
	Ball.prototype.fluc=function(){
		var that=this;
		setInterval(function(){
			that.theta+=random()/20;
			that.eleva+=random()/20;
			that.radius+=(random()/10-0.05);
			if(that.radius<0.5 || that.radius>2) that.radius=1;
			that.preview();
		},100)
	};
	new Ball(2,2,1).fluc();
</script>
</html>
```
