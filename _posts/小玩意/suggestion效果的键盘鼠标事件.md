---
layout: post
title: "google suggestion效果的键盘鼠标事件"
date: "2010-08-23 16:30:13 +0800"
slug: "suggestion效果的键盘鼠标事件"
category: "developer"
categories:
  - "developer"
tags:
  - "JS"
  - "google"
permalink: "/2010/08/23/suggestion效果的键盘鼠标事件/"
---

google的suggestion功能是一个非常棒的用户体验创新，相信你之前也已经使用过了。由于某些原因，国内现在却不能使用这个功能了。
不过,你还可以在baidu上使用相同的功能。对于好点子好创意，模仿学习并不是件坏事。
<div class="runcode"><textarea class="runcode_text" id="runcode_20100823_suggestion__1">&lt;!doctype html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset='UTF-8' /&gt;
&lt;style type='text/css'&gt;
.sugg{position:relative;font-size:12px;}
.sugg a{text-decoration:none;}
.sugg .text{width:210px;height:18px;padding:3px;color:#474747;border:1px solid #ADCAD8;}
#suggestion{display:none;position:absolute;top:26px;left:0;width:216px;border:1px solid #3890d0;border-top:0;background:#fff;}
#suggestion a{display:block;height:25px;line-height:25px;padding:0 5px;color:#000;}
#suggestion a img{vertical-align:middle;}
#suggestion #hover{background:#378ece;color:#fff;}
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div class='sugg'&gt;
	&lt;form id='suggF' action="http://www.baidu.com/baidu" onsubmit="document.charset='GBK';sug.hide()" accept-charset='GBK' target="_blank"&gt;
		&lt;input class='text' type=text name=wd autocomplete="off" onkeydown="pressKey(this,event)" /&gt;
		&lt;input id='sub' type="submit" value="搜索" /&gt;
	&lt;/form&gt;
	&lt;div id='suggestion'&gt;
		&lt;a href='javascript:;' onmouseover="sug.hover(this);" onclick="sug.select();"&gt;思思&lt;/a&gt;
		&lt;a href='javascript:;' onmouseover="sug.hover(this);" onclick="sug.select();"&gt;芊芊&lt;/a&gt;
		&lt;a href='javascript:;' onmouseover="sug.hover(this);" onclick="sug.select();"&gt;cssass&lt;/a&gt;
		&lt;a href='javascript:;' onmouseover="sug.hover(this);" onclick="sug.select();"&gt;敏敏&lt;/a&gt;
		&lt;a href='javascript:;' onmouseover="sug.hover(this);" onclick="sug.select();"&gt;黎黎&lt;/a&gt;
	&lt;/div&gt;
&lt;/div&gt;
suggestion显示之后，使用方向键或鼠标进行选择。
&lt;/body&gt;
&lt;script type='text/javascript'&gt;
var $id=function(o){
	return document.getElementById(o) || o;
}
var pressKey=function(o,e){
	var e = e ? e : window.event;
	var k = e.keyCode;
	switch(k){
		case 9 :  //tab键
		case 13 : return false; //回车键
		default : sug.show(o,k); break;
	}
}
var sug={
	show:function(o,k){
		/* 此时动态读取suggestion数据（略）*/
		document.getElementById('suggestion').style.display='block';
		document.onclick=function(){sug.hide()};
		if (k != 38 &amp;&amp; k != 40 &amp;&amp; k != 39 &amp;&amp; k != 37) { //非方向键
			 sug.i = -1;
		}
		sug.i = sug.i || 0;
		var list = $id('suggestion').getElementsByTagName("a");
		var prev = '';
		switch(k){
			case 38:
				sug.clear();
				if (sug.i &lt; 1) {
					sug.i = list.length
				}
				sug.i--;
				list[sug.i].id = "hover";
				o.value = list[sug.i].innerHTML;
				return false;
			case 40:
				sug.clear();
				if (sug.i == list.length - 1) {
					sug.i = -1
				}
				sug.i++;
				list[sug.i].id = "hover";
				o.value = list[sug.i].innerHTML;
				return false;
			default : break;
		}
		sug.hover=function(othis){ //鼠标划过
			sug.clear();
			for(i=0;i&lt;list.length;i++){
				if(othis==list[i]){
					sug.i=i;
					list[sug.i].id="hover";
					o.value = othis.innerHTML;
					return ;
				}
			}
		}
		sug.clear=function(){
			prev = $id('hover');
			if (prev) prev.id = '';
		}
		sug.select=function(){ //鼠标选中
			document.charset='GBK';
			$id('suggF').submit();
		}
	},
	hide:function(){
		$id('suggestion').style.display='none';
	}
};
&lt;/script&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20100823_suggestion__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20100823_suggestion__1')">Copy</button></div></div>
下面是加入google的数据（墙内也有几率可以看到效果）
<div class="runcode"><textarea class="runcode_text" id="runcode_20100823_suggestion__2">&lt;!doctype html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset='UTF-8' /&gt;
&lt;style type='text/css'&gt;
.sugg{position:relative;font-size:12px;}
.sugg a{text-decoration:none;}
.sugg .text{width:210px;height:18px;padding:3px;color:#474747;border:1px solid #ADCAD8;}
#suggestion{display:none;position:absolute;top:26px;left:0;width:216px;border:1px solid #3890d0;border-top:0;background:#fff;}
.listitem{display:block;height:25px;line-height:25px;padding:0 5px;color:#000;cursor:pointer;}
.itemhover{background:#378ece;color:#fff;}
&lt;/style&gt;
&lt;script type="text/javascript" src="/public/js/extend.js"&gt;&lt;/script&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div class='sugg'&gt;
	&lt;form id="searchForm" method="GET"  action="http://www.baidu.com/baidu"&gt;
		&lt;input class='text' type=text name=wd autocomplete="off"  id="keyInput" /&gt;
	&lt;/form&gt;
	&lt;div id='suggestion'&gt;&lt;/div&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;script type='text/javascript'&gt;
function Suggest(inputer, shower){
	this.global = {
		keyElm : inputer,
		showElm : shower,
		ajaxURL : 'https://www.google.com/complete/search',
		ajaxData : {
			'client' : 'hp',
			'xhr' : 't'
		},
		index : -1
	}
	this.bind();
};
Suggest.prototype = {
	bind: function(){
		var that = this;
		events.addEvent(this.global.keyElm, "keyup", function(){
			var e = arguments[0] || window.event,
				k = e.keyCode;
			switch(k){
				case 9 :  //tab键
				case 13 : //回车键
					that.hide();
					return false;
				case 37 :
				case 38 :
				case 39 :
				case 40 :
					 that.select(k); //方向键
					 break;
				default :
					 that.show(k);
			}
		});
		events.delegate(this.global.showElm, ".listitem", "mouseover", function(){
			var e = arguments[0] || window.event,
				target = e.srcElement || e.target;
			that.hover(target);
		});
		events.addEvent(this.global.showElm,"click", function(){
			$id("searchForm").submit();
		});
		events.addEvent(document, 'click', function(){
			that.hide();
		});
	},
	show: function(k){
		var that = this;
		this.global.ajaxData.q = this.global.keyElm.value;
		$jsonp(this.global.ajaxURL, this.global.ajaxData, function(msg){
			var list = msg[1],
				html = '';
			if(!list.length ){
				that.hide();
			}else{
				for(var i = 0 ; i&lt; list.length; i++){
					html += "&lt;span class='listitem' idx="+i+"&gt;"+list[i][0]+"&lt;/span&gt;";
				};
				that.global.showElm.style.display='block';
			}
			that.global.showElm.innerHTML = html;
		});
	},
	hide: function(){
		$id('suggestion').style.display='none';
	},
	select: function(k){
		var list = $tag("span", $id('suggestion'));
		if(list.length &lt; 1) return false;
		switch(k){
			case 38:
				this.global.index --;
				if (this.global.index &lt; 0) {
					this.global.index = list.length - 1;
				}
				break;
			case 40:
				this.global.index ++;
				if (this.global.index &gt; list.length - 1) {
					this.global.index = 0
				}
				break;
			default :
				return false;
		}
		this.setValue(list[this.global.index]);
	},
	hover : function(target){
		this.global.index = target.getAttribute("idx");
		this.setValue(target);
	},
	setValue : function(o){
		removeClass($class("itemhover"), "itemhover");
		addClass(o, "itemhover");
		this.global.keyElm.value = o.innerText || o.textContent;
	}
}
new Suggest($id("keyInput"), $id("suggestion"));
&lt;/script&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20100823_suggestion__2')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20100823_suggestion__2')">Copy</button></div></div>
