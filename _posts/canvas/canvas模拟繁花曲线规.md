---
layout: post
title: "canvas模拟繁花曲线规"
date: "2012-12-05 10:56:41 +0800"
slug: "canvas模拟繁花曲线规"
category: "developer"
categories:
  - "developer"
tags:
  - "canvas"
permalink: "/2012/12/05/canvas模拟繁花曲线规/"
---

不算难，就是几个相对运动。

<div class="runcode"><textarea class="runcode_text" id="runcode_20121205_canvas__1">&lt;!doctype html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset='UTF-8' /&gt;
&lt;title&gt;繁花曲线规&lt;/title&gt;
&lt;style&gt;
*{padding:0;margin:0;}
body{background:#eee;overflow-x:hidden;}
#operationBar{position: fixed;z-index:10000;bottom:0;width:100%;text-align:center;background:#FBFDFE;border-top:2px solid #CC0F16;padding:5px 0;}
.optText{width:35px;}
.dialog_Wrap{background:#666;border: 1px solid #585858;border-top:0;border-radius: 0 0 8px 8px;box-shadow: 1px 1px 2px #aaa; overflow: hidden;}
.dialog_Head{background:#000;height:26px;line-height:26px;padding: 0 5px;border-top:2px solid #CC0F16;cursor:move;color:#fff;font-size:12px;}
.dialog_close{text-decoration:none;color:#fff; display:inline-block;width:15px;height:15px;font-size:12px;text-align:center;line-height:15px;font-family:'Comic Sans MS';}
.dialog_Head .dialog_Opts{position:absolute;right:5px;top:0;height:21px;cursor:default;}
.dialog_Body{overflow:auto;}
&lt;/style&gt;
&lt;script src="/public/js/extend.js"&gt;&lt;/script&gt;
&lt;script src="/public/js/litewin.js"&gt;&lt;/script&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div id="operationBar"&gt;
	&lt;label&gt;&lt;input class="opt" id="showCricle" type="checkbox" /&gt;圈&lt;/label&gt;
	&lt;label&gt;&lt;input class="opt" id="showLine" type="checkbox" checked/&gt;线&lt;/label&gt;
	&lt;label&gt;&lt;input class="opt" id="showPoint" type="checkbox" /&gt;点&lt;/label&gt;
	&lt;label&gt;&lt;input class="opt" id="showColor" type="checkbox" checked /&gt;变色&lt;/label&gt;
	&lt;label&gt;&lt;input class="opt" id="isRefresh" type="checkbox" /&gt;刷新&lt;/label&gt;
	&lt;label&gt;外圈半径:&lt;input class="opt optText" id="bigRadius" type="text" value="133" /&gt;&lt;/label&gt;
	&lt;label&gt;内圈半径:&lt;input class="opt optText" id="smallRadius" type="text" value="140" /&gt;&lt;/label&gt;
	&lt;label&gt;线长:&lt;input class="opt optText" id="lineLength" type="text" value="123" /&gt;&lt;/label&gt;
	&lt;label&gt;&lt;input id="runBtn" type="button" value="新建"/&gt;&lt;/label&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;script&gt;
function Toy(options){
	this.setOptions(options);
	this.createPad();
	this.draw(true);
}
Toy.prototype = {
	setOptions: function(options) {
		this.options = {
			R:	133, //大圈半径
			r:	140, //小圈半径
			l:	123, //线长
			showPoint: false, //显示小点
			showCricle: false, //显示小圈
			showLine: true, //显示线条
			isRefresh: false, //每次清屏
			showColor : true, //颜色变化
			count : 1500 //绘制次数
		};
		extendCopy(options || {}, this.options);
		//实际占用区域半径的计算
		var delta = 0;
		if(this.options.R &gt; this.options.r){
			delta = (this.options.r &gt; this.options.l) ? 0 : this.options.l - this.options.r;
			this.radius = this.options.R + delta;
		}else{
			delta = (this.options.r &gt; this.options.l) ? this.options.r - this.options.R : this.options.l - this.options.R;
			this.radius = this.options.r + delta;
		}
		this.radius += 10;
		this.color = {
			r : 0,
			g : 0,
			b : 255,
			a : 0.5
		};
		this.v =  20;
		this.colorValue = "rgba("+this.color.r+","+this.color.g+","+this.color.b+","+this.color.a+")";
		this.angle = 0;
		this.timePlay = null;
  	},
  	changeColor : function(){
  		//颜色变换模式1
  		this.color.r += this.v;
  		if(this.color.r &gt; 255){
  			this.color.r = 0;
  			this.color.g += this.v;
  		}
  		if(this.color.g &gt; 255){
  			this.color.r = 0;
  			this.color.g = 0;
  			this.color.b += this.v;
  		}
  		if(this.color.b &gt; 255){
  			this.color.r = 0;
  			this.color.g = 0;
  			this.color.b = 0;
  		}
  		this.colorValue = "rgba("+this.color.r+","+this.color.g+","+this.color.b+","+this.color.a+")";
  	},
  	changeColor2 : function(){
  		//颜色变换模式2
  		if(Toy.isIn(this.color.r + this.v, -1, 255)){
  			this.color.r += this.v;
  		}else{
  			if(Toy.isIn(this.color.g + this.v, -1, 255)){
  				this.color.g += this.v;
  			}else{
  				if(Toy.isIn(this.color.b + this.v, -1, 255)){
  					this.color.b += this.v;
  				}else{
  					this.v = -this.v;
  				}
  			}
  		}
  		this.colorValue = "rgba("+this.color.r+","+this.color.g+","+this.color.b+","+this.color.a+")";
  	},
	createPad : function(isReset){
				if(!isReset){
					this.pad = document.createElement("canvas");
				}
				this.pad.width =  this.radius * 2;
				this.pad.height = this.radius * 2;
				this.ctx = this.pad.getContext('2d');
				this.ctx.lineJoin = 'round';
				this.ctx.lineCap = 'round';
				this.ctx.lineWidth=.5;
				this.ctx.strokeStyle = this.colorValue;
				this.ctx.fillStyle = this.colorValue;
				if(!isReset){
					var dialogs = $class("myDialog"),
						lastOne = dialogs[dialogs.length - 1],
						pos = [0,0],
						scrollT = document.body.scrollTop || document.documentElement.scrollTop;
					if(lastOne){
						var rect = lastOne.getBoundingClientRect();
						if (rect.right &gt; document.documentElement.offsetWidth - lastOne.offsetWidth) {
							pos = [rect.bottom + 10 + scrollT, 0];
						}else{
							pos = [rect.top + scrollT, rect.right+ 10];
						}
					}
					this.myPad = Win.open({
						title : "Pad - " + Toy.t++,
						html : "",
						width : this.pad.width +10,
						height : this.pad.height + 35,
						onclose : this.stop
					}).position("leftTop").css("top:"+pos[0]+"px;left:"+ pos[1] +"px;");
					$class("dialog_Cont",this.myPad.dom)[0].appendChild(this.pad);
				}
			},
	draw : function(isFirst){
				this.ctx.save();
				if(this.options.showColor){
					this.changeColor2();
					this.ctx.strokeStyle = this.colorValue;
					this.ctx.fillStyle = this.colorValue;
				}
				//大圆
				this.ctx.translate(this.radius, this.radius);
				if(isFirst){
					this.ctx.beginPath();
					this.ctx.arc(0,0,this.options.R,0,Math.PI*2,true);
					this.ctx.closePath();
					this.ctx.stroke();
				}
				//小圆
				this.ctx.rotate(-this.angle);
				this.ctx.translate(this.options.R-this.options.r,0);
				if(this.options.showCricle || isFirst){
					this.ctx.beginPath();
					this.ctx.arc(0,0,this.options.r,0,Math.PI*2,true);
					this.ctx.closePath();
					this.ctx.stroke();
				}
				//线
				this.ctx.rotate(this.angle * this.options.R/this.options.r);
				if(this.options.showLine || isFirst){
					this.ctx.beginPath();
					this.ctx.moveTo(0,0);
					this.ctx.lineTo(this.options.l,0);
					this.ctx.stroke();
				}
				//小点
				if(this.options.showPoint || isFirst){
					this.ctx.translate(this.options.l,0);
					this.ctx.beginPath();
					this.ctx.arc(0,0,1,0,Math.PI*2,true);
					this.ctx.fill();
				}
				this.ctx.restore();
				this.angle += 0.2;
				return this;
			},
	move : function(){
			var that = this,
				count = 0,
				_s = function(){
					that.clear(count == 0).draw();
					count ++;
					that.timePlay = setTimeout(_s,50);
					if(that.options.count &lt; count) {
						clearTimeout(that.timePlay)
					};
				}
				_s();
				return this;
		},
	stop : function(){
		clearTimeout(this.timePlay);
		return this;
	},
	clear : function(isInit){
		if(this.options.isRefresh || isInit){
			this.ctx.clearRect(0,0,this.radius * 2,this.radius * 2);
			this.ctx.font = '10px Helvetica';
			this.ctx.fillStyle = '#fff';
			this.ctx.fillText("R: "+this.options.R, this.radius * 2 - 35, this.radius * 2-24 );
			this.ctx.fillText("r : "+this.options.r, this.radius * 2 - 35, this.radius * 2 - 12);
			this.ctx.fillText("l : "+this.options.l, this.radius * 2 - 35, this.radius * 2 );
		}
		return this;
	},
	reset : function(options){
		this.setOptions(options);
		this.createPad(true);
		this.draw(true);
		return this;
	}
}
Toy.isIn = function(v,min,max){
	return (v &gt; min &amp;&amp; v &lt; max)
};
Toy.t = new Date();
function getOpt(){
	return {
		R : $id("bigRadius").value - 0 || 133,
		r : $id("smallRadius").value - 0 || 140,
		l : $id("lineLength").value - 0 || 123,
		showPoint: $id("showPoint").checked,
		showCricle: $id("showCricle").checked,
		showLine: $id("showLine").checked,
		isRefresh: $id("isRefresh").checked,
		showColor : $id("showColor").checked
	}
}
window.onload = function(){
	var opt = getOpt();
	var temp1 = new Toy(opt),
		temp2 = new Toy(opt).move(),
	temp3 = new Toy({R:103,r:40,l:50}).move(),
	temp4 = new Toy({R:113,r:140,l:123}).move();
	var inputs = $class("opt");
	for (var i = inputs.length - 1; i &gt;= 0; i--) {
		inputs[i].onchange = function(){
			temp1.reset(getOpt());
		}
	};
	events.addEvent($id("runBtn"),'click', function(){
		new Toy(getOpt()).move();
	});
}
&lt;/script&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20121205_canvas__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20121205_canvas__1')">Copy</button></div></div>
