---
layout: post
title: "使用Threejs制作3D螺旋线"
date: "2013-02-06 11:31:36 +0800"
slug: "使用Threejs制作3D螺旋线"
category: "developer"
categories:
  - "developer"
tags:
  - "3D"
  - "threejs"
permalink: "/2013/02/06/使用Threejs制作3D螺旋线/"
---

做了一个3D螺旋线的生成器

<div class="runcode"><textarea class="runcode_text" id="runcode_20130206__Threejs_3D__1">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8"&gt;
&lt;title&gt;Threejs制作3D螺旋线&lt;/title&gt;
&lt;style&gt;
*{padding:0;margin:0;}
body{background:#333;color:#fff;}
.controlBar{position:absolute;}
#control ul{width:150px;float:left;list-style:none;}
#control b{position:relative;display:inline-block;width:120px;height:5px;font-size:0;line-height:0;background:#fff;border:1px solid #aaa;border-radius:2px;}
#control i{position:absolute;cursor:pointer;top:-4px;left:50%;width:10px;height:10px;margin-left:-4px;border:1px solid #d3d3d3;background:#ececec;border-radius:2px;}
#control i:hover{border:1px solid #999;background:#dcdcdc;}
&lt;/style&gt;
&lt;script src="/public/js/extend.js"&gt;&lt;/script&gt;
&lt;script src="/public/js/three.min.js"&gt;&lt;/script&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div class="controlBar"&gt;
&lt;div id="control"&gt;
	&lt;ul&gt;
		&lt;li&gt;x:  &lt;b class='range'&gt;&lt;i data-value='85.2'&gt;&amp;nbsp;&lt;/i&gt;&lt;/b&gt;&lt;/li&gt;
		&lt;li&gt;y:  &lt;b class='range'&gt;&lt;i data-value='205.2'&gt;&amp;nbsp;&lt;/i&gt;&lt;/b&gt;&lt;/li&gt;
		&lt;li&gt;z:  &lt;b class='range'&gt;&lt;i data-value='-64.8'&gt;&amp;nbsp;&lt;/i&gt;&lt;/b&gt;&lt;/li&gt;
	&lt;/ul&gt;
	&lt;ul&gt;
		&lt;li&gt;x:  &lt;b class='range'&gt;&lt;i data-value='60'&gt;&amp;nbsp;&lt;/i&gt;&lt;/b&gt;&lt;/li&gt;
		&lt;li&gt;y:  &lt;b class='range'&gt;&lt;i data-value='-49.8'&gt;&amp;nbsp;&lt;/i&gt;&lt;/b&gt;&lt;/li&gt;
		&lt;li&gt;z:  &lt;b class='range'&gt;&lt;i data-value='184.8'&gt;&amp;nbsp;&lt;/i&gt;&lt;/b&gt;&lt;/li&gt;
	&lt;/ul&gt;
	&lt;ul&gt;
		&lt;li&gt;x:  &lt;b class='range'&gt;&lt;i data-value='225'&gt;&amp;nbsp;&lt;/i&gt;&lt;/b&gt;&lt;/li&gt;
		&lt;li&gt;y:  &lt;b class='range'&gt;&lt;i data-value='-195'&gt;&amp;nbsp;&lt;/i&gt;&lt;/b&gt;&lt;/li&gt;
		&lt;li&gt;z:  &lt;b class='range'&gt;&lt;i data-value='195'&gt;&amp;nbsp;&lt;/i&gt;&lt;/b&gt;&lt;/li&gt;
	&lt;/ul&gt;
&lt;/div&gt;
&lt;button onclick="Producer.createPoints()"&gt;增加操作点&lt;/button&gt;
&lt;/div&gt;
&lt;script&gt;
var controlElm = $id("control"),
	iElm = $tag("i", controlElm);
for(var i = 0; i &lt; iElm.length; i++){
	iElm[i].style.left = (iElm[i].dataset['value'] - 0 + 300) * 100 /600 + "%";
}
var Producer = {
	points : [],
	getPoints : function(){
		Producer.points = [];
		var UL = $tag("UL", controlElm), item, jsondata;
		for(var i = 0 ; i &lt;UL.length; i++){
			item =  $tag("i",UL[i]);
			jsondata = {
				x : item[0].dataset['value']-0,
				y : item[1].dataset['value']-0,
				z : item[2].dataset['value']-0,
			}
			Producer.points.push(jsondata);
		}
	},
	createPoints : function(){
		$id("control").insertAdjacentHTML('beforeEnd',$tag("UL",$id("control"))[0].outerHTML);
	},
	changePoints : function(o,e){
		var l = 600;
		if(!window.event) {e.preventDefault();}
		var tX = o.offsetLeft,
			dx = e.clientX;
		events.addEvent(document,'mousemove',mouseMove);
		events.addEvent(document,'mouseup',mouseUp);
		function mouseMove(){
			var e = arguments[0] || window.event;
			var len = tX + e.clientX - dx + 8, val;
			if(len &gt;=0 &amp;&amp; len &lt;= 120){
				var rat = (len / 120) * 100;
				o.style.left = rat+ "%";
				val = l * Math.round((rat - 50)*10)/1000;
				o.dataset['value'] = val;
				o.title = val;
			}
			if(window.event) e.returnValue=false;
		}
		function mouseUp(){
			events.removeEvent(document,'mousemove',mouseMove);
			events.removeEvent(document,'mouseup',mouseUp);
			spiralDemo.init().animate();
		}
	}
};
function Spiral3D(){
	this.width = Math.max(1000, document.documentElement.offsetWidth);
	this.height = 800;
	this.camera = new THREE.PerspectiveCamera( 33, this.width / this.height, 1, 10000);
	this.scene = new THREE.Scene();
	this.renderer = null;
	this.create();
}
Spiral3D.prototype = {
	create : function(){
		try{
			this.renderer = new THREE.WebGLRenderer( { antialias: true } ); //webgl
		}catch(e){
			this.renderer = new THREE.CanvasRenderer(); //canvas
		}
		this.renderer.setSize( this.width, this.height);
		document.body.appendChild( this.renderer.domElement );
		this.init();
		return this;
	},
	init : function() {
		this.scene = new THREE.Scene();
		this.stop();
		Producer.getPoints();
		var spline = new THREE.Spline( Producer.points ),  //以关键点创建曲线
			geometry = new THREE.Geometry(),
			material = new THREE.LineBasicMaterial( { color: 0xffffff, opacity: 1, linewidth: 1, vertexColors: THREE.VertexColors } );
		//自动补全曲线点
		for ( var i =0, position, l = Producer.points.length * 7; i &lt; l; i ++ ) {
			position = spline.getPoint( i/l );
			geometry.vertices[ i ] = new THREE.Vector3( position.x, position.y, position.z );
			geometry.colors[ i ] = new THREE.Color( 0x00ffff );
			geometry.colors[ i ].setHSV( ( 100 + position.x ) / 400 * i/8, ( 200 + position.x ) / 400, ( 250 + position.x ) / 300);
		}
		//创建100条线
		for(var line, i=0, l = 100 ; i&lt;l; i++){
			line = new THREE.Line(geometry,  material);
			line.position = {x: 0, y: 0, z: 0};
			if(i &gt; 0) {
				line.rotation.y = Math.PI * 2 * (i/l);
			}
			this.scene.add( line ); //将显示对象加入场景
		}
		return this;
	},
	render : function() {
		var timer = Date.now() * 0.0005;
		this.camera.position.x = Math.cos( timer ) * 500;
		this.camera.position.z = Math.sin( timer ) * 500;
		this.camera.lookAt( this.scene.position );
		this.renderer.render( this.scene, this.camera ); //使用渲染器
		return this;
	},
	_reqID : {},
	animate : function() {
		var that = this;
		var _loop = function(){
			that._reqID = requestAnimationFrame( _loop );
			that.render();
		}
		_loop();
		return this;
	},
	stop : function(){
		var that = this;
		cancelAnimationFrame(that._reqID);
	}
}
var spiralDemo = new Spiral3D();
	spiralDemo.animate();
events.delegate(controlElm, 'i', 'mousedown',function(){
	var e = arguments[0] || window.event,
		target = e.srcElement || e.target;
	Producer.changePoints(target,e);
});
&lt;/script&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20130206__Threejs_3D__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20130206__Threejs_3D__1')">Copy</button></div></div>

配套做一个动画效果：

<div class="runcode"><textarea class="runcode_text" id="runcode_20130206__Threejs_3D__2">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8"&gt;
&lt;title&gt;Threejs 3D lines&lt;/title&gt;
&lt;style&gt;
*{padding:0;margin:0;}
body{background:#333;color:#fff;overflow:hidden;}
&lt;/style&gt;
&lt;script src="/public/js/extend.js"&gt;&lt;/script&gt;
&lt;script src="/blog/resource/threejs/three.min.js"&gt;&lt;/script&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;script&gt;
var Producer = {
	points : [{
		x : 85.2,
		y : 205.2,
		z : -64.8,
		a : 1,
		b : 1,
		c : 1
	},{
		x : 60,
		y : -49.8,
		z : 184.8,
		a : 1,
		b : 1,
		c : 2
	},{
		x : 225,
		y : -195,
		z : 195,
		a : 1,
		b : 2,
		c : 1
	},{
		x : 40,
		y : -40.8,
		z : 114.8,
		a : 2,
		b : 1,
		c : 1
	},{
		x : 85.2,
		y : 105.2,
		z : -24.8,
		a : 2,
		b : 1,
		c : 1
	},{
		x : 85.2,
		y : 205.2,
		z : -64.8,
		a : 1,
		b : 1,
		c : 1
	}],
	changePoints : function(){
		var points = Producer.points;
		for(var i = 0 ; i &lt; points.length; i++){
			item =  points[i];
			if(item.x &lt; -250 || item.x &gt; 250) item.a = -item.a;
			if(item.y &lt; -250 || item.y &gt; 250) item.b = -item.b;
			if(item.z &lt; -250 || item.z &gt; 250) item.c = -item.c;
			item.x -= item.a,
			item.y -= item.b,
			item.z -= item.c
		}
		spiralDemo.init().animate();
	}
};
function Spiral3D(){
	this.width = document.documentElement.offsetWidth;
	this.height = Math.max(document.documentElement.clientHeight,document.body.offsetHeight);
	this.camera = new THREE.PerspectiveCamera( 33, this.width / this.height, 1, 10000);
	this.scene = new THREE.Scene();
	this.renderer = null;
	this.create();
}
Spiral3D.prototype = {
	create : function(){
		try{
			this.renderer = new THREE.WebGLRenderer( { antialias: true } ); //webgl
		}catch(e){
			this.renderer = new THREE.CanvasRenderer(); //canvas
		}
		this.renderer.setSize( this.width, this.height);
		document.body.appendChild( this.renderer.domElement );
		this.init();
		return this;
	},
	init : function() {
		this.scene = new THREE.Scene();
		this.stop();
		var spline = new THREE.Spline( Producer.points ),  //以关键点创建曲线
			geometry = new THREE.Geometry(),
			material = new THREE.LineBasicMaterial( { color: 0xffffff, opacity: 1, linewidth: 1, vertexColors: THREE.VertexColors } );
		//自动补全曲线点
		for ( var i =0, position, l = Producer.points.length * 7; i &lt; l; i ++ ) {
			position = spline.getPoint( i/l );
			geometry.vertices[ i ] = new THREE.Vector3( position.x, position.y, position.z );
			geometry.colors[ i ] = new THREE.Color( 0x00ffff );
			geometry.colors[ i ].setHSV( ( 100 + position.x ) / 400 * i/8, ( 200 + position.x ) / 400, ( 250 + position.x ) / 300);
		}
		//创建100条线
		for(var line, i=0, l = 100 ; i&lt;l; i++){
			line = new THREE.Line(geometry,  material);
			line.position = {x: 0, y: 0, z: 0};
			if(i &gt; 0) {
				line.rotation.y = Math.PI * 2 * (i/l);
			}
			this.scene.add( line ); //将显示对象加入场景
		}
		return this;
	},
	render : function() {
		var timer = Date.now() * 0.0005;
		this.camera.position.x = Math.cos( timer ) * 500;
		this.camera.position.z = Math.sin( timer ) * 500;
		this.camera.lookAt( this.scene.position );
		this.renderer.render( this.scene, this.camera ); //使用渲染器
		return this;
	},
	_reqID : {},
	animate : function() {
		var that = this;
		var _loop = function(){
			that._reqID = requestAnimationFrame( _loop );
			that.render();
		}
		_loop();
		return this;
	},
	stop : function(){
		var that = this;
		cancelAnimationFrame(that._reqID);
	}
};
var spiralDemo = new Spiral3D();
	spiralDemo.animate();
setInterval(Producer.changePoints,50);
&lt;/script&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20130206__Threejs_3D__2')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20130206__Threejs_3D__2')">Copy</button></div></div>
