---
layout: post
title: "canvas的像素级操作——1.引子"
date: "2012-01-06 10:16:32 +0800"
slug: "canvas的像素级操作——1-引子"
category: "developer"
categories:
  - "developer"
tags:
  - "canvas"
permalink: "/2012/01/06/canvas的像素级操作——1-引子/"
---

本文是对《MDC的canvas经典教程辑和个人学习笔记》的补遗，也是canvas像素级操作系列文章的一个引子。

既然是引子，那就不能开门见山的介绍了，我们先讲讲如何复制canvas.
已知一个image对象，我们将其绘制进canvas的方法是什么？drawImage。（当然使用createPattern模板填充也是一个方法）。
那已知一个canvas对象，我们将其绘制进另一个canvas的方法呢？
答案还是drawImage，drawImage算是一个很辽阔的方法了，不仅可以绘image，也可以绘canvas对象，甚至还可以绘video的帧。

并且他拥有大量参数：(Image [, vXSrc] [, vYSrc] [, vWSrc] [, vHSrc], vXDest, vYDest [, vWDest] [, vHDest])，这个读者可以先不管，往下看。

那么，除了drawImage这个方法，还有没有其他方法呢——有，putImageData方法隆重登场。

<div class="runcode"><textarea class="runcode_text" id="runcode_20120106_canvas_1__1">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;title&gt;canvas绘制与复制及像素级复制&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;p&gt;原图：imgObj&lt;br /&gt;
&lt;img id="imgObj" src="/blog/resource/avatar/avatar_s.jpg" width="200" /&gt;
&lt;p&gt;canvas中绘制的图：MyCanvas&lt;br /&gt;
&lt;canvas id="MyCanvas" width="200" height="220" &gt; &lt;/canvas&gt;
&lt;p&gt;从MyCanvas复制过来的图：YourCanvas&lt;br /&gt;
&lt;canvas id="YourCanvas" width="200" height="220"&gt; &lt;/canvas&gt;
&lt;p&gt;从MyCanvas的ImageData复制来的图：GodCanvas （注意，这里只是为了引出canvas的像素级操作，通常像素级操作是很低效的）&lt;br /&gt;
&lt;canvas id="GodCanvas" width="200" height="220"&gt; &lt;/canvas&gt;
&lt;/body&gt;
&lt;/html&gt;
&lt;script type="text/javascript"&gt;
function draw(){
	/* 在canvas中绘制image */
	var canvas1 = document.getElementById("MyCanvas");
	var ctx1 = canvas1.getContext("2d");
		ctx1.drawImage(imgObj,0,0);
}
function clone(){
	/* 在canvas2中绘制canvas1 ——普通复制 */
	var origin = document.getElementById("MyCanvas");
	var canvas2 = document.getElementById("YourCanvas");
	var ctx2 = canvas2.getContext("2d");
		ctx2.drawImage(origin,0,0); //drawImage不仅可以绘image，也可以绘canvas对象，甚至还可以绘video的帧
}
function cloneData(canvasObj){
	/* 获取canvas1中的ImageData，在canvas3中输出 ——像素级复制 */
	var origin = document.getElementById("MyCanvas");
	var canvas3 = document.getElementById("GodCanvas");
	var ctx3 = canvas3.getContext("2d");
	var canvasCtx = origin.getContext("2d");
	var imagePix = canvasCtx.getImageData(0,0,origin.width,origin.height); // 获取canvas1绘图环境下的参数范围内的imageData。
		ctx3.putImageData(imagePix,0,0);    //putImageData输出图像
}
/* 以下与示例代码无关 */
function Load(canvas){
	/* canvas Loading 效果 */
	var backCtx = canvas.getContext('2d');
		backWidth = canvas.width;
		backHeight = canvas.height;
	var drawIntervalID,
		spokes = 7;
	var	drawPad = document.createElement('canvas');
		drawPad.width = 30;
		drawPad.height = 30;
	var	drawCtx = drawPad.getContext('2d');
		drawCtx.translate(drawPad.width/2, drawPad.height/2);
		drawCtx.lineWidth = 5;
		drawCtx.lineCap = "round";
		drawCtx.strokeStyle = "rgba(0,0,0,0.1)";
		drawCtx.fillStyle = "#fff";
	var draw = function(){
		drawCtx.fillRect(0,0, drawPad.width ,drawPad.height);
		drawCtx.rotate(Math.PI*2/spokes);
		for (var i=0; i&lt;spokes; i++) {
			drawCtx.rotate(Math.PI*2/spokes);
			drawCtx.beginPath();
			drawCtx.moveTo(0,8);
			drawCtx.lineTo(0,10);
			drawCtx.stroke();
		}
		backCtx.drawImage(drawPad,(backWidth - drawPad.width)/2, (backHeight - drawPad.height)/2);
	}
	this.loading = function(){
		 drawIntervalID = setInterval(draw,200);
	}
	this.loaded = function(){
		clearInterval(drawIntervalID);
		backCtx.clearRect((backWidth - drawPad.width)/2, (backHeight - drawPad.height)/2, drawPad.width ,drawPad.height);
	}
}
var imgObj = document.getElementById("imgObj");
var canvas = document.getElementsByTagName('canvas');
for(var i = 0, l = canvas.length; i &lt; l; i++ ){
	var loadObj = new Load(canvas[i]);
	(function(obj){
		obj.loading();
		imgObj.addEventListener('load',obj.loaded,false);
	})(loadObj);
}
imgObj.addEventListener('load',function(){
	draw();
	clone();
	cloneData();
},false);
&lt;/script&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20120106_canvas_1__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20120106_canvas_1__1')">Copy</button></div></div>

上面的cloneData方法就是通过将源canvas中像素数据ImageData，输出(putImageData)到新的canvas中，达到复制作用。

不过，我们在获取和输出ImageData的过程中，并没有对ImageData做过任何处理，而这个ImageData数据是包含{width,height,CanvasPixelArray},其中CanvasPixelArray包含了图像(canvas也可看做图像)的每一个像素的RGBA数据，可见中间的操作空间是很大的，以后我们会做重点讨论。

插注：CanvasPixelArray——在最新标准中已引入一个Uint8ClampedArray的Typed Array来替代 ，在各浏览器实现之后，将使得对ImageData的操作更快速更便捷。参考例子：http://hacks.mozilla.org/2011/12/faster-canvas-pixel-manipulation-with-typed-arrays/

下面介绍一下像素操作的三个方法：

createImageData();
getImageData();
putImageData();

createImageData的参数是(w,h)可以新建一个W*H尺寸的新的ImageData【firefox3.5开始支持】，不过也可以使用参数(anotherImageData)来创建【firefox5开始支持】。

getImageData的参数（x,y,w,h）表示起点x,y,尺寸w,h。可以获取canvas.context中在参数范围内的ImageData。

putImageData的参数使用要着重要介绍下（和drawImage的参数可以触类旁通）：

<div class="runcode"><textarea class="runcode_text" id="runcode_20120106_canvas_1__2">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;title&gt;putImageData的参数&lt;/title&gt;
&lt;style&gt;
	canvas{border:1px solid #ccc;}
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;canvas id="canvas1" width="300" height="300"&gt;&lt;/canvas&gt;
&lt;canvas id="canvas2" width="300" height="300"&gt;&lt;/canvas&gt;
&lt;/body&gt;
&lt;/html&gt;
&lt;script type="text/javascript"&gt;
(function draw(){
	var canvas0 = document.createElement("canvas"),
		ctx = canvas0.getContext("2d");
	var canvas1 = document.getElementById("canvas1"),
		ctx1 = canvas1.getContext("2d");
	var canvas2 = document.getElementById("canvas2"),
		ctx2 = canvas2.getContext("2d");
	var img = new Image();
	img.src="/blog/resource/avatar/avatar_s.jpg";
	img.onload=function(){
		canvas0.width = img.width;
		canvas0.height = img.height;
		ctx.drawImage(img,0,0);
		var imagePix = ctx.getImageData(0,0,canvas0.width,canvas0.height);
		/* putImageData参数(ImageData, dx, dy [, DirtyX] [, DirtyX] [, DirtyWidth] [, DirtyHeight]) */
		ctx1.putImageData(imagePix,30,30);  //imageData（包含了width,height,还有一个CanvasPixelArray）；dx, dy表示绘图起始位置
		ctx2.putImageData(imagePix,0,0,100,100,50,50); //后面四个可选参数表示可见区范围。缺省为：0,0,ImageData.width,ImageData.height
	}
})()
&lt;/script&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20120106_canvas_1__2')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20120106_canvas_1__2')">Copy</button></div></div>

putImageData参数有(ImageData, dx, dy [, DirtyX] [, DirtyX] [, DirtyWidth] [, DirtyHeight])

imageData：包含了图像的width,height,还有一个CanvasPixelArray，前面已经提了。
dx, dy：表示绘图起始位置。相对于canvas区域左上角。
后面四个可选参数：表示可见区范围。相对于起绘点，即上面的参数dx,dy表示的点。缺省为0,0,ImageData.width,ImageData.height。
