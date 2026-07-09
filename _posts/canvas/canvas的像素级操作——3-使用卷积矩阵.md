---
layout: post
title: "canvas的像素级操作——3.使用卷积矩阵"
date: "2012-01-12 10:25:48 +0800"
slug: "canvas的像素级操作——3-使用卷积矩阵"
category: "developer"
categories:
  - "developer"
tags:
  - "canvas"
permalink: "/2012/01/12/canvas的像素级操作——3-使用卷积矩阵/"
---

利用卷积矩阵(Convolution Matrix)操作像素，我们可以很方便的得到诸如模糊、边缘检测、锐化、浮雕和斜角这样的效果。

常用的矩阵类型是 3 x 3 矩阵，另外还有5 x 5的矩阵。

工作原理：http://flex4jiaocheng.com/blog/280

点阵图中的每一个像素被称为“初步像素”，用与卷积矩阵同样面积的“初步像素”从左到右从上到下与卷积矩阵中相应位置的值相乘，再将得到的9个或25个中间值相加，就得到了“初步像素”矩阵中央的一个值的结果值再与Divisor（因子）相除，与Offset（偏移量）相加，最后得到终值。如下图所示：


应用卷积矩阵实现特效:

```html runcode
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>利用卷积矩阵实现特效</title>
</head>
<body>
<canvas id="canvas1" width="200" height="200" title="浮雕效果"></canvas>
<canvas id="canvas2" width="200" height="200" title="边缘检测"></canvas>
<canvas id="canvas3" width="200" height="200" title="锐化"></canvas>
<canvas id="canvas4" width="200" height="200" title="基本模糊"></canvas>
<canvas id="canvas5" width="200" height="200" ></canvas>
<script type="text/javascript">
function convolution(imgPixels, matrix, divisor, offset){
	/* 卷积矩阵应用函数 */
    var w = imgPixels.width,
		h = imgPixels.height,
		d = imgPixels.data;
	var canvas = document.createElement('canvas'),
		ctx = canvas.getContext('2d'),
		newImgPixels = ctx.createImageData(w,h);
	for (var y = 1; y < h-1; y++) {
			for (var x = 1; x < w-1; x++) {
				for (var c = 0; c < 3; c++) {
					/* RGB通道 */
					var i = (y*w + x)*4 + c;
					newImgPixels.data[i]=(matrix[0]*d[i-(w+1)*4] + matrix[1]*d[i-w*4] + matrix[2]*d[i-(w-1)*4]
										+ matrix[3]*d[i-4]       + matrix[4]*d[i]     + matrix[5]*d[i+4]
										+ matrix[6]*d[i+(w-1)*4] + matrix[7]*d[i+w*4] + matrix[8]*d[i+(w+1)*4])
										/ divisor + offset;
				}
				newImgPixels.data[(y*w + x)*4 + 3] = 255;
			}
		}
    return newImgPixels;
}
(function(){
	/* demo */
	var imgObj = new Image();
		imgObj.src = '/blog/resource/avatar/avatar_s.jpg';
	var embossing = {
		/* 浮雕效果 */
			matrix : [-2, -1, 0,
					  -1,  1, 1,
					   0,  1, 2],
			divisor: 1,
			offset : 0
		},
		edge = {
		/* 边缘检测 */
			matrix : [0, -1, 0,
					 -1,  4, -1,
					  0, -1, 0],
			divisor: 1,
			offset : 0
		},
		sharpening = {
		/* 锐化 */
			matrix : [ 0, -1, 0,
					  -1,  5, -1,
					  0,  -1, 0],
			divisor: 1,
			offset : 0
		},
		blur = {
		/* 基本模糊 */
			matrix : [0, 1, 0,
					  1, 1, 1,
					  0, 1, 0],
			divisor: 5,
			offset : 0
		},
		oneboys = {
		/* 胡诌的一个矩阵 */
			matrix : [ 0, 1, 4,
					  -1,  5, -1,
					  3,  -1, 2],
			divisor: 5,
			offset : 0
		};
	function process(obj,effect){
		var context = document.getElementById(obj).getContext('2d');
			context.drawImage(imgObj, 0, 0);
		var imgPixels = context.getImageData(0, 0, imgObj.width, imgObj.height);
		imgPixels = convolution(imgPixels, effect.matrix, effect.divisor, effect.offset)
		context.putImageData(imgPixels, 0, 0, 0, 0, imgPixels.width, imgPixels.height);
	}
	var canvas = document.getElementsByTagName('canvas');
	for(var i = 0, l = canvas.length; i < l; i++ ){
		var loadObj = new Load(canvas[i]);
		(function(obj){
			obj.loading();
			imgObj.addEventListener('load',obj.loaded,false);
		})(loadObj);
	};
	imgObj.addEventListener('load',function(){
		process('canvas1',embossing);
		process('canvas2',edge);
		process('canvas3',sharpening);
		process('canvas4',blur);
		process('canvas5',oneboys);
	},false);
})()
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
		for (var i=0; i<spokes; i++) {
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
</script>
</body>
</html>
```

上面demo中卷积的实现函数来自于在HTML 5 的 Canvas 中应用卷积矩阵对图像处理

推荐一篇有趣的文章：卷积的物理意义
