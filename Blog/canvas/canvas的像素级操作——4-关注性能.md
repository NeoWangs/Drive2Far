---
layout: post
title: "canvas的像素级操作——4.关注性能"
date: "2012-01-17 10:29:03 +0800"
slug: "canvas的像素级操作——4-关注性能"
category: "developer"
categories:
  - "developer"
tags:
  - "canvas"
permalink: "/2012/01/17/canvas的像素级操作——4-关注性能/"
---

我们开篇就提过，canvas的像素级操作相对来说是很低效的。

我们试着写一个图片切割效果。
```html runcode
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>效率相关</title>
</head>
<body>
<canvas id="board" width="100" height="110"></canvas>
<script type="text/javascript">
function splinter(ctx,imgPixels){
	var round = 0; //统计循环次数
	for(var y = 0; y < imgPixels.height; y++){
		for(var x = 0; x < imgPixels.width; x++){
			/* 虽然只调用了putImageData一个方法，但是操作的data非常多 */
			ctx.putImageData(imgPixels, x, y, x, y, 1 ,1); //后四个参数控制显示区域
			round ++ ;
		}
	}
	return round;
}
function demo(img){
	var w = img.width,
		h = img.height;
	var temp = document.createElement('canvas');
		temp.width = w;
		temp.height = h;
	var tempCtx = temp.getContext('2d');
		tempCtx.drawImage(img, 0, 0, w, h);
	var ctx = document.getElementById('board').getContext('2d');
	var imgPixels = tempCtx.getImageData(0, 0, w, h);
	return splinter(ctx,imgPixels);
}
(function(){
	var img = new Image();
		img.src = "/blog/resource/avatar/avatar_s.jpg";
		img.width = 50;
		img.height = 55;
		img.onload = function(){
			var d = new Date();
			var func = demo(img);
			alert("耗时：" + (new Date() - d) + "(ms)，\n共执行了" + func + "次的putImageData");
		}
})()
</script>
</body>
</html>
```

对于这个效果，因为我们并不需要操作图像的rgba数据，而只是把图像进行分割，所以利用putImageData的后四个可见区参数进行了设置就行了。
但是，这样做的性能却非常不理想。因为我们操作的ImageData数据实在太多了，循环执行了2750遍，相当于我们对整幅图像进行了2750次的像素级复制，而其实在可见区之外的ImageData数据并不是我们所需要的。

那么，我们在对源图getImageData的时候，可以只获取我们需要的ImageData。
```html runcode
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>效率相关</title>
</head>
<body>
<canvas id="board" width="100" height="110"></canvas>
<script type="text/javascript">
function splinter(ctx,tempCtx, w, h){
	var newData = [];
	var round = 0; //统计循环次数
	for(var y = 0; y < h; y++){
		newData[y] = [];
		for(var x = 0; x < w; x++){
			newData[y][x] = tempCtx.getImageData(x, y, 1, 1); //分开获取所需要的ImageData
			ctx.putImageData(newData[y][x], x*2, y*2);
			round ++ ;
		}
	}
	return round;
}
function demo(img){
	var w = img.width,
		h = img.height;
	var temp = document.createElement('canvas');
		temp.width = w;
		temp.height = h;
	var tempCtx = temp.getContext('2d');
		tempCtx.drawImage(img, 0, 0, w, h);
	var ctx =  document.getElementById('board').getContext('2d');
	return round = splinter(ctx,tempCtx, w, h);
}
(function(){
	var img = new Image();
		img.src = "/blog/resource/avatar/avatar_s.jpg";
		img.width = 50;
		img.height = 55;
		img.onload = function(){
			var d = new Date();
			var func = demo(img);
			alert("耗时：" + (new Date() - d) + "(ms)，\n共执行了" + func + "次的getImageData和putImageData");
		}
})()
</script>
</body>
</html>
```

第二种做法虽然在循环的时候多运行了一个方法（共执行2750次的getImageData和putImageData方法），但因为操作的ImageData少了2750倍，所以在效率上比第一种方式高了很多。

但从流程上来讲，我们只需要在刚开始的时候获取一次源图的ImageData（执行getImageData），对数据进行再排列后，最后再输出一次新的ImageData（执行putImageData）就可以了。
根本不需要在循环中反复调用getImageData和putImageData。所以现在的关键点是get和put之间的如何对数据进行重排列。

ImageData.data可以看做一个矩形矩阵，我们已知，它的序列号（n）与ImageData.width(w),及x轴序列号(x),y轴序列号（y）的关系是：n = ((y * w) + x) * 4; （其中的4表示了RGBA四个数据）。我们要的新的输出ImageData，其实是x加倍，y加倍，w加倍的一个新矩阵。那么新矩阵序号与原x,y,w的关系式应该是：t = ((y * 2 * w * 2) + x * 2) * 4;
```html runcode
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>效率相关</title>
</head>
<body>
<canvas id="board" width="100" height="110"></canvas>
<script type="text/javascript">
function splinter(ctx,imgPixels){
	var round = 0; //统计循环次数
	var n = 0,
		w = imgPixels.width,
		h = imgPixels.height,
		newdata = ctx.createImageData(w*2, h*2);
	for(var y = 0; y < h; y++){
		for(var x = 0; x < w; x++){
			n = ((y * w) + x) * 4; /* data序号n与x,y,w的关系 */
			t = ((y * 2 * w * 2) + x * 2) * 4; /* 分割后，y,x,w都变大了一倍 */
			newdata.data[t] =  imgPixels.data[n];
			newdata.data[t + 1] =  imgPixels.data[n + 1];
			newdata.data[t + 2] =  imgPixels.data[n + 2];
			newdata.data[t + 3] =  imgPixels.data[n + 3];
			round ++ ;
		}
	}
	ctx.putImageData(newdata, 0, 0);
	return round;
}
function demo(img){
	var w = img.width,
		h = img.height;
	var temp = document.createElement('canvas');
		temp.width = w;
		temp.height = h;
	var tempCtx = temp.getContext('2d');
		tempCtx.drawImage(img, 0, 0, w, h);
	var ctx = document.getElementById('board').getContext('2d');
	var imgPixels = tempCtx.getImageData(0, 0, w, h);
	return splinter(ctx,imgPixels);
}
(function(){
	var img = new Image();
		img.src = "/blog/resource/avatar/avatar_s.jpg";
		img.width = 50;
		img.height = 55;
		img.onload = function(){
			var d = new Date();
			var func = demo(img);
			alert("耗时：" + (new Date() - d) + "(ms)，\n共循环了" + func + "次,循环内不执行getImageData和putImageData方法");
		}
})()
</script>
</body>
</html>
```

第三种方法相对于第二种方法的效率提高了十几倍。第三种方法的关键点是找出新旧矩阵之间的关系，对于我们这一例来说还比较容易，复杂一点的，算法可就没这么简单了。

——————————————
重要补充：

我们先总结下三种方法：第一种：效率低差，但理解起来最简单。第三种，算法复杂，但效率最高。第二种，折中。
然而，如果使用的是webkit，opera浏览器，我们会发现第一种方法的效率比之第三种方法居然差不了多少！
可以看出webkit,opera对putImageData做过优化。对于putImageData(imgdata, x, y, x, y, 1 ,1)方法，webkit,opera只对（x,y,1,1）这个1平方px区域内的数据进行了put操作，区域外的数据并没有进行操作，这样在效率上会有很大的提高。
可惜的是firefox(9)就没有做过优化。要加油啊，Mozila！
最新测试了下ie9，结果显示第一种方法的效率的确很低，而第二种方法比第一种方法的效率还要低一倍。看来ie9果然也没用对putImageData进行优化，而且ie9下的getImageData也没用像其他浏览器下那么优化。对于getImageData(x,y,1,1)的获取，它操作的整个图像的像素数据的，而不是那个1平方px内的数据。

目前来说，考虑到各个浏览器原生方法的效率问题，第三种方法是最优的，即不要反复调用getImageData和putmageData，因为某些浏览器下一旦调用就是操作全部imageData的，而不会看你的参数。不过在未来，各个浏览器肯定会对原生方法进行优化的，在考虑第一种方法的时候就不用有所顾忌了！
