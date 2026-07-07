---
layout: post
title: "使用Three.js展现3D模型"
date: "2012-02-24 10:49:35 +0800"
slug: "使用Three-js展现3D模型"
category: "developer"
categories:
  - "developer"
tags:
  - "3D"
  - "threejs"
permalink: "/2012/02/24/使用Three-js展现3D模型/"
---

CSS3的3d-Transform，Canvas，SVG，WebGL等等技术的出现和发展，正将网页的3D化慢慢变得简单友好，但是3D建模毕竟有其很高的专业性，所以如果拥有一个内心强大，接口简洁的库就能使我们得心应手许多。Three.js便是备受推崇的一个，尽管API的变动，简陋的文档会让我们的上手比较困难。

下面我提供一个入门Demo，及一个用Three.js展示通用的3D模型格式的Demo。（注意：确保你使用的浏览器支持了Canvas，及WebGL。拥有一个先进的浏览器，将为你带来更好的上网体验。Test）

下面是入门Demo，加了注释。详细入门教程可以到这里Getting Started with Three.js
<div class="runcode"><textarea class="runcode_text" id="runcode_20120224__Three_js_3D__1">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="UTF-8" /&gt;
&lt;title&gt;立方体&lt;/title&gt;
    &lt;script type="text/javascript" charset="utf-8" src="/public/js/three.min.js"&gt;&lt;/script&gt;
	&lt;style&gt;body{overflow:hidden;}&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;&lt;/body&gt;
	&lt;script&gt;
	/* 场景 */
	var WIDTH = document.documentElement.offsetWidth || 800,
		HEIGHT = document.documentElement.clientHeight || 600;
	var scene = new THREE.Scene();
	/* 摄像头 */
	var VIEW_ANGLE = 75,
		ASPECT = WIDTH / HEIGHT,
		NEAR = 0.1,
		FAR = 10000;
	var	camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR); /* 摄像机视角，视口长宽比，近切面，远切面 */
		camera.position.set(0, 0, 1000); //放置位置
		scene.add(camera);
	/* 显示对象 */
	var geometry = new THREE.CubeGeometry( 200, 200, 200 ), //几何属性。代码位于"\src\extras\geometries"
		material = new THREE.MeshLambertMaterial( { color: 0xcccccc} ); //材质属性 "\src\materials"
	var cube = new THREE.Mesh(geometry, material);
		cube.rotation.set(10,20,10); //放置角度
		scene.add(cube);
	/* 灯光 */
	var light = new THREE.DirectionalLight(0xFFFFFF); //直线光,"\src\lights"
		light.position.set(0, 0, 100).normalize();
		scene.add(light);
	/* 渲染器 */
	var	renderer = new THREE.CanvasRenderer(); //有Canvas，WebGL，SVG三种模式
		renderer.setSize(WIDTH , HEIGHT);
		document.body.appendChild(renderer.domElement);
	/* 动画 */
	(function anime(){
		cube.rotation.x += 0.01; //改变立方体角度
		renderer.render(scene, camera); //开始渲染
		return requestAnimationFrame(anime);
	})()
&lt;/script&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20120224__Three_js_3D__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20120224__Three_js_3D__1')">Copy</button></div></div>

考虑到Opera还不支持WebGL，上面使用了Canvas模式渲染。但WebGL的渲染模式要比Canvas快的要多的多。

下面是一个展示机器人MGA-411 Mangusa模型的Demo。
Three.js可以调用以Json格式存储模型信息的js文件来创建模型。模型你可以自己在3D软件上建模完成，或在网上下载。至于模型格式，你可以通过three.js提供的插件在Blender这款开源3D制作软件中将一些3D模型格式，如3ds，obj等，转换成符合three.js标准的js格式。

<div class="runcode"><textarea class="runcode_text" id="runcode_20120224__Three_js_3D__2">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="UTF-8" /&gt;
&lt;title&gt;MGA-411 Mangusa&lt;/title&gt;
    &lt;script type="text/javascript" charset="utf-8" src="/blog/resource/threejs/three.min.js"&gt;&lt;/script&gt;
	&lt;style&gt;body{overflow:hidden;background:#000}&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
	&lt;div id="Loading" style="color:#fff"&gt;Loading...&lt;/div&gt;
&lt;/body&gt;
	&lt;script&gt;
	/* 场景 */
	var WIDTH = document.documentElement.offsetWidth || 800,
		HEIGHT = document.documentElement.clientHeight || 600;
	var scene = new THREE.Scene();
	/* 摄像头 */
	var VIEW_ANGLE = 75,
		ASPECT = WIDTH / HEIGHT,
		NEAR = 0.1,
		FAR = 10000;
	var	camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
		camera.position.set(0, 0, 1000);
		scene.add(camera);
	/* 渲染器 */
	var	renderer = new THREE.WebGLRenderer();
		renderer.setSize(WIDTH , HEIGHT);
		document.body.appendChild(renderer.domElement);
	/* 灯光 */
	var light = new THREE.DirectionalLight(0xFFFFFF);
		light.position.set(0, 0, 99).normalize();
		scene.add(light);
	/* 显示对象 */
	var material = new THREE.MeshLambertMaterial({ color: 0xcccccc, wireframe: true }),
		obj;
	var loader = new THREE.JSONLoader(true);
    loader.load("/blog/resource/threejs/model/MGA.js", function ( geometry ) {
		var loading = document.getElementById("Loading");
		loading.parentNode.removeChild(loading);
		obj = new THREE.Mesh(geometry, material);
		obj.position.set(0,1,990);
		scene.add(obj);
		var start = new Date().getTime(),delta;
		(function anime(){
			delta = new Date().getTime() - start;
			obj.rotation.y =   delta / 1000;
			renderer.render(scene, camera);
			return requestAnimationFrame(anime);
		})();
	});
&lt;/script&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20120224__Three_js_3D__2')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20120224__Three_js_3D__2')">Copy</button></div></div>
