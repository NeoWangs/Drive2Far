---
layout: post
title: "Metro风混搭瀑布流"
date: "2012-12-09 13:06:11 +0800"
slug: "Metro风混搭瀑布流"
category: "developer"
categories:
  - "developer"
tags:
  - "JS"
  - "Metro"
permalink: "/2012/12/09/Metro风混搭瀑布流/"
---

去年做了一个自号“ 格子块的智能堆砌 ”的效果, 当时瀑布流已激发了国内的第一批模仿者，微软的Merto也刚震撼了设计界。

今天把原来的效果改动优化了下，打造一个Metro风混搭瀑布流。

```html runcode
<!doctype html>
<html>
<head>
<meta charset="UTF-8" />
<title>Metro风兼搭瀑布流</title>
<style>
body{background:#000;}
.myMetro{position:relative;overflow:hidden;zoom:1;margin:0 auto;}
.MBox{float:left;vertical-align:middle;}
.widgetBox{position:relative;display:block;overflow:hidden;width:180px;height:160px;}
</style>
<script src="/public/js/extend.js"></script>
<script>
/* 格子排序 */
var metro = {};
metro.init=function(wrap){
	metro.gen={w:190,h:170};
	metro.wrap = wrap;
	metro.sizeArray= []; //格子,[1,2]就表示1X2的大格子
	metro.preset();
	metro.putData(wrap);
};
metro.preset = function(){
	metro.nameSpace= {};
	metro.maxY = -1;
	metro.basePos = {x:0, y:0};
	metro.memory = {flag:Infinity, x: Infinity, y:Infinity};
	metro.row = document.documentElement.offsetWidth / metro.gen.w >> 0;
	metro.wrap.style.width = metro.row * metro.gen.w + "px";
};
metro.resort=function(){
	metro.preset();
	metro.mbox = $class("MBox");
	metro.sort(metro.sizeArray);
};
metro.putData = function(list){
	(function setBig(){  //大格子初始化设置
	 	var bigBox = $class("bigBox",list);
	   	if(bigBox.length==0) return false;
		var i = 0, nx, ny, bigBoxCont;
		while(i < bigBox.length){
			bigBoxCont =  $class("innerBox",bigBox[i]);
			nx = Math.floor(bigBoxCont[0].offsetWidth / metro.gen.w); //bigBox横向占的块数
			ny = Math.floor(bigBoxCont[0].offsetHeight / metro.gen.h);
			bigBox[i].style.width = nx*metro.gen.w - 10 + 'px' ;
			bigBox[i].style.height = ny*metro.gen.h - 10 + 'px' ;
			i++;
		}
	})();
	metro.mbox = $class("MBox",list);
	var i = 0 , nx, ny, tempSizeArray = [];
	while( i < this.mbox.length){
		if( $class("bigBox",this.mbox[i]).length > 0 ){
			nx = Math.ceil(this.mbox[i].offsetWidth / this.gen.w);
			nx = (nx > this.row) ? this.row : nx; //bigBox宽度尺寸过大
			ny = Math.ceil(this.mbox[i].offsetHeight / this.gen.h);
			tempSizeArray.push([nx,ny]);
		}else{
			tempSizeArray.push([1,1]);
		}
		i++;
	}
	this.sizeArray = this.sizeArray.concat(tempSizeArray);
	metro.sort(tempSizeArray);
}
metro.sort = function(size){
	var x = metro.basePos.x,
		y = metro.basePos.y,
		memory = metro.memory,
		name;
	for(var n=0; n < size.length ; n++){
		if(memory.flag == 0){
			x = memory.x;
			y = memory.y;
		}
		memory.flag --;
		if(x > metro.row-1){ //换行
			x = 0;
			y ++;
		}
		name = x+'_'+y;  //对象属性名（反映占领的格子）
		if(name in this.nameSpace) {  //判断属性名是否存在
			n--;
			x++;
			memory.flag < Infinity && memory.flag++;
			continue;
		}
		if(size[n][0] * size[n][1] == 1){  //普通格子
			metro.nameSpace[name]=[x,y];  //项值（反映坐标值）
			setPos(x,y,n);
			x++;
		}
		else{  //大格子
			if(beOver(x,y,size[n])) {
				if(memory.y > y){
					memory.y = y;
					memory.x = x;
				}
				if(memory.y < Infinity) memory.flag = 1;
				n--;
				x++;
				continue;
			}
			metro.nameSpace[name] = [x,y];
			setPos(x,y,n);
			hold(x,y,size[n]);
			x += size[n][0];
		}
		if(memory.flag == -1) memory = {flag:Infinity ,x: Infinity, y:Infinity};
		metro.maxY = Math.max(metro.maxY, y + size[n][1]);
	}
	metro.basePos = {"x":x,"y":y}
	metro.memory = memory;
	metro.wrap.style.height= metro.gen.h * metro.maxY +'px';
	function beOver(x,y,item){  //判断是否会重叠
		var name;
		if(x + item[0] > metro.row) return true; //超出显示范围
		for(var k=1; k<item[1]; k++){
			name=x+'_'+(y-0+k);
			if(name in metro.nameSpace) return true; //左侧一列有无重叠
		}
		for(k=1; k<item[0]; k++){
			name=(x-0+k)+'_'+y;
			if(name in metro.nameSpace) return true; //上侧一行有无重叠
		}
		return false;
	};
	function hold(x,y,item){  //大格子多占的位置
		for(var t=0; t < item[0]; t++) {
			for(var k=0; k < item[1]; k++){
				name = (x+t)+'_'+(y+k);
				if(t==0 && k==0)   continue;
				metro.nameSpace[name] = 0;   //多占的格子无坐标值
			}
		}
	};
	function setPos(x,y,n){
		var left = metro.gen.w * x,
			top = metro.gen.h * y;
		metro.mbox[n].style.cssText += "position:absolute;left:"+ left +"px;top:" + top + "px;";
	}
};
</script>
</head>
<body>
<div id="myMetro" class="myMetro"></div>
<script>
//随机数据
var myMetro = $id("myMetro"),
	colorList = ['f4b300','78ba00','2673ec','ae113d','632f00','b01e00','4e0038','c1004f','7200ac','2d004e','006ac1','001e4e','008287','004d60','004a00','00c13f','15992a','ff981d','e56c19','b81b1b','ff1d77','b81b6c','aa40ff','691bb8','1faeff','1b58b8','56c5ff','569ce3','00d8cc','00aaaa','91d100','b81b6c','e1b700','d39d09','ff76bc','e064b7','00a4a4','ff7d23','4cafb5','044d91','832772','d15a44','de971b','017802','6e2ea0'],
	color = colorList[0];
function createTestData(n){
	var spanWrap = document.createElement("span"),
		content = "";
	for(i = 0; i < n; i++) {
		color = colorList[(colorList.length * Math.random())>>0];
		if(!(Math.random()*3 >> 0)){ //输出大模块测试数据。宽高在一个范围内都是随意的，未做其他限制
			height = Math.floor(Math.random()*320 + 160);
			width = Math.floor(Math.random()*360 + 180);
			content += '<div class="MBox" style="background:#'+color+'"><div class="bigBox" ><a href="http://www.cssass.com" target="_blank" style="width:' + width +'px;height:' + height +'px;top:'+(-height%170)/2+'px;left:'+(-width%190)/2+'px;" class="widgetBox innerBox"></a></div></div>';
		}else{ //输出普通模块数据
			content += '<div class="MBox" style="background:#'+color+'"><a href="http://www.cssass.com" target="_blank" class="widgetBox" ></a></div>';
		}
	};
	spanWrap.innerHTML = content;
	myMetro.appendChild(spanWrap);
	return spanWrap;
}
window.onload = function(){
	createTestData(35);
	metro.init(myMetro);
};
window.onresize = function(){
	metro.resort(myMetro);
};
window.onscroll=function(){
	var scrollTop = document.body.scrollTop || document.documentElement.scrollTop,
		windowHeight = document.documentElement.clientHeight,
		documentHeight = document.body.offsetHeight;
	if(windowHeight + scrollTop > documentHeight - 50){
		metro.putData(createTestData(15));
	}
}
</script>
</body>
</html>
```

应大家要求，我将主要的sort方法取出来，再做个简单demo

```html runcode
<!doctype html>
<html>
<head>
<meta charset="UTF-8" />
<title>CSSASS</title>
</head>
<body></body>
<script>
var metro = {
    //初始化数据。表示格子大小：1*1，1*2，2*3...
    sizeArray : [[1, 1], [1, 2], [2, 1], [2, 3], [1, 1], [1, 2], [1, 1], [2, 2], [1, 1]],
    //单元格尺寸
    gen: {
        w: 200,
        h: 180
    },
    //nameSpace的key用于判断对应的坐标位置有没被占有,我们就是要保证key是唯一的。而value就是最终设置的坐标了。
    nameSpace: {
        /* 1_0: [1,0] */
    }
};
metro.init = function () {
    metro.row = 1000 / metro.gen.w >> 0; //一行最多能排下的单元格个数/ 测试宽度以1000px计。
    metro.sort(metro.sizeArray);
};
metro.sort = function (size) {
    var x = 0,
        y = 0,
        memory = {
            flag: Infinity,
            x: Infinity,
            y: Infinity
        },
        name;
    for (var n = 0; n < size.length; n++) {
        if (memory.flag == 0) {
            x = memory.x;
            y = memory.y;
        }
        memory.flag--;
        if (x > metro.row - 1) { //换行
            x = 0;
            y ++;
        }
        name = x + '_' + y; //对象属性名（反映占领的格子）
        if (name in this.nameSpace) { //判断属性名是否存在
            n --;
            x ++;
            memory.flag < Infinity && memory.flag++;
            continue;
        }
        if (size[n][0] * size[n][1] == 1) { //普通格子
            metro.nameSpace[name] = [x, y]; //项值（反映坐标值）
            LOG(x, y, n, name, metro.nameSpace[name]); /* 显示及打印信息 */
            x++;
        } else { //大格子
            if (beOver(x, y, size[n])) {
                if (memory.y > y) {
                    memory.y = y;
                    memory.x = x;
                }
                if (memory.y < Infinity) memory.flag = 1;
                n --;
                x ++;
                continue;
            }
            metro.nameSpace[name] = [x, y];
            LOG(x, y, n, name, metro.nameSpace[name]); /* 显示及打印信息 */
            hold(x, y, n);
            x += size[n][0];
        }
        if (memory.flag == -1) memory = {
            flag: Infinity,
            x: Infinity,
            y: Infinity
        };
    };
    function beOver(x, y, item) { //判断是否会重叠
        var name;
        if (x + item[0] > metro.row) return true; //超出显示范围
        for (var k = 1; k < item[1]; k++) {
            name = x + '_' + (y - 0 + k);
            if (name in metro.nameSpace) return true; //左侧一列有无重叠
        }
        for (k = 1; k < item[0]; k++) {
            name = (x - 0 + k) + '_' + y;
            if (name in metro.nameSpace) return true; //上侧一行有无重叠
        }
        return false;
    };
    function hold(x, y, n) { //大格子多占的位置
        var item = metro.sizeArray[n];
        for (var t = 0; t < item[0]; t++) {
            for (var k = 0; k < item[1]; k++) {
                name = (x + t) + '_' + (y + k);
                if (t == 0 && k == 0) continue;
                metro.nameSpace[name] = 0; //多占的格子无坐标值
                LOG_2(n ,name);
            }
        }
    };
};
metro.init();
function LOG(x, y, n, key) {
    //用于显示
    var left = metro.gen.w * x,
        top = metro.gen.h * y,
        width = metro.sizeArray[n][0] * metro.gen.w,
        height = metro.sizeArray[n][1] * metro.gen.h;
    var box = document.createElement("div");
    box.id = "ID" + n;
    box.innerHTML = "<h3>" + n +"</h3>" + key + ":(" + metro.nameSpace[key] + ")<br/>";
    box.style.cssText = "position:absolute;border:1px solid #333;left:" + left + "px;top:" + top + "px;width:" + width + "px;height:" + height + "px;";
    document.body.appendChild(box);
}
function LOG_2(n, key){
    //大格子多占位置的信息。
    document.getElementById("ID" + n).innerHTML +=  key + ":(" + metro.nameSpace[key] + ")<br/>";
}
</script>
</html>
```
