---
layout: post
title: "mouseenter/mouseleave事件和delegate方法的实现"
date: "2011-12-18 11:20:54 +0800"
slug: "mouseenter-mouseleave事件和delegate方法的实现"
category: "developer"
categories:
  - "developer"
tags:
  - "DOM"
permalink: "/2011/12/18/mouseenter-mouseleave事件和delegate方法的实现/"
---

众所周知，事件onmouseover和onmouseout有一个极其不好的问题，就是在绑定元素内部的子元素上滑动会反复触发事件，及执行绑定的方法。

而ie在很早的时候有提供了另一对事件：mouseenter和mouseleaver。顾名思义，就是只有当mouse滑进滑出绑定元素的时候，才会触发。

但是，这本来只是ie的私有属性，虽然已属于DOM3 Event草案当中，其他浏览器的支持率并不是很高，目前看来，Opera11.10已提供支持，而Firefox到10.0会提供支持，Webkit的暂无消息。
所以，如果想要用，我们得自己动手。

先搞一个通用的事件绑定函数：
```

var addEvent = function( target,type,fn ) {
    if(target.addEventListener)
    {
        target.addEventListener(type,fn,false);
    }
    else if(target.attachEvent)
    {
        target.attachEvent("on" + type,fn);
    }
};
var removeEvent = function(target,type,fn ) {
    if(target.addEventListener)
    {
        target.removeEventListener(type,fn,false);
    }
    else if(target.attachEvent)
    {
        target.detachEvent("on" + type,fn);
    }
};

```

我们的mouseenter/leave是通过mouseover/out来实现的，只需屏蔽mouseover/out在元素内部触发时的事件传播即可。
 <div class="runcode"><textarea class="runcode_text" id="runcode_20111218_mouseenter_mouseleave_delegate__1">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;title&gt;实现mouseenter、mouseleave事件&lt;/title&gt;
&lt;style&gt;
.outer{padding:50px;background:#aaa;}
.inner{height:100px;background:#eee;}
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div id="outer" class="outer"&gt;
	只有移进移出外框的时候才执行方法。对内框操作不执行。click点击解除绑定。
	&lt;div id="inner" class="inner"&gt;&lt;/div&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;script&gt;
var $id=function(o){return document.getElementById(o) || o;}
var events = {}
events._mouseFn ={}; //保存“onmouseenter”和“onmouseleave”所绑定的方法
events._mouseHandle = function(fn){
	/* 转换方法，符合条件时才会执行 */
	var func = function(event){
		var target = event.target;
		var parent = event.relatedTarget; //在onmouseover/out操作中，相关的另一个节点
		while( parent &amp;&amp; parent != this ){
			try{ parent = parent.parentNode; }
			catch(e){break;}
		}
		/* 只有当相关节点的父级不会是绑定的节点时（即二者不是父子的包含关系），才调用fn，否则不做处理 */
		( parent != this ) &amp;&amp; (fn.call(target,event));
	};
	return func;
}
events.addEvent = function( obj,type,fn ) {
	if(obj.addEventListener)
    {
		if(obj.onmouseenter !== undefined){
			//for opera11，firefox10。他们也支持“onmouseenter”和“onmouseleave”，可以直接绑定
			obj.addEventListener(type,fn,false);
			return ;
		}
		if(type=="mouseenter" || type=="mouseleave" ){
			var eType = (type=="mouseenter") ? "mouseover" : "mouseout";
			var fnNew = events._mouseHandle(fn);
			obj.addEventListener(eType,fnNew,false);
			 /* 将方法存入events._mouseFn，以便以后remove */
			if(!events._mouseFn[obj]) events._mouseFn[obj] = {};
			if(!events._mouseFn[obj][eType]) events._mouseFn[obj][eType] = {};
				events._mouseFn[obj][eType][fn] = fnNew;
		}else{
			obj.addEventListener(type,fn,false);
		}
    }else if(obj.attachEvent)
    {
		// for ie
        obj.attachEvent("on" + type,fn);
    }
};
events.removeEvent = function(obj,type,fn ) {
    if(obj.addEventListener)
    {
		if(obj.onmouseenter !== undefined){
			obj.removeEventListener(type,fn,false);
			return ;
		}
		if(type=="mouseenter" || type=="mouseleave" ){
			var eType = (type=="mouseenter") ? "mouseover" : "mouseout";
			if(!events._mouseFn[obj][eType][fn]) return;
			obj.removeEventListener(eType,events._mouseFn[obj][eType][fn],false);
			events._mouseFn[obj][eType][fn] = null;
		}else{
			obj.removeEventListener(type,fn,false);
		}
    }
    else if(obj.attachEvent)
    {
        obj.detachEvent("on" + type,fn);
    }
};
(function(){
	/* 这里是演示demo 绑定解除事件 */
	var outer = $id("outer"),
		inner = $id("inner");
	events.addEvent(outer,"mouseenter",add);
	events.addEvent(outer,"mouseleave",add);
	events.addEvent(outer,"click",remove);
	function add(){
		var e = arguments[0] || window.event;
		var target = e.srcElement || e.target;
		inner.innerHTML = target.id + ' ' + e.type;
	}
	function remove(){
		events.removeEvent(outer,"mouseenter",add);
		events.removeEvent(outer,"mouseleave",add)
		inner.innerHTML = "click";
	}
})()
&lt;/script&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20111218_mouseenter_mouseleave_delegate__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20111218_mouseenter_mouseleave_delegate__1')">Copy</button></div></div>
为了解除绑定，我们设计了一个events._mouseFn来保存绑定的方法，在解除操作时读取对应的方法进行解绑。因为事件可以绑定多个方法，我们需要保存对应的方法，以便之后对应解除。
当然如果这里如果按面向对象的思路实现，就可以各自保存，而不需要保持在同一个events._mouseFn对象下。但每绑定一个事件，都需实例化一个对象，显得很多余，所以不采用面向对象的模式。

接下来是文章的第二部分，我们来实现下jquery中提供的delegate方法。
（delegate是live方法的扩展版。delegate是基于live的，live是基于bind的。在jquery1.7中又被封装进了on方法。1.7中的on方法是一个很辽阔的方法。其实封装的越厉害，效率就越差了，这也是为什么我们选择自己做简单封装的原因，而不是使用jquery已封装好的）。
这个方法可以将想要绑定在子级元素上的事件方法，委托绑定在其父级上，用事件传播机制来触发执行。
这么做的好处有：
1：如果子级有n个并列元素需要绑定，绑子级需要绑n次，而将其绑定在父级上则只需绑定一次，这是很高效的。
2：如果子级元素有动态增加的话，新增元素是没有绑定过任何事件方法的。而如果之前选择的是绑定其父级，就不会有这个问题。
 <div class="runcode"><textarea class="runcode_text" id="runcode_20111218_mouseenter_mouseleave_delegate__2">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;title&gt;delegate委托绑定事件方法的实现&lt;/title&gt;
&lt;style&gt;
.outer{padding:50px;background:#aaa;zoom:1;}
.inner{display:block;height:50px;margin:5px;background:#eee;border:1px solid #ccc;}
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div id="outer" class="outer"&gt;
	&lt;div id="message"&gt;点击下面框体&lt;/div&gt;
	&lt;span class="inner"&gt;1:&lt;/span&gt;
	&lt;span class="inner"&gt;2:&lt;/span&gt;
	&lt;span class="inner"&gt;3:&lt;/span&gt;
	&lt;span class="inner"&gt;4:&lt;/span&gt;
	&lt;span class="inner"&gt;5:&lt;/span&gt;
	&lt;div id="unbind"&gt;点击解除绑定&lt;/div&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;script&gt;
//一些通用方法
var $id=function(o){return document.getElementById(o) || o;}
var isDOMs = function(target){
	return target.length &gt;= 0 &amp;&amp; target !== window &amp;&amp; !target.tagName;  //!target.tagName排除FORM,SELECT等元素
};
var hasClass = function(target,className){
	if(!target || !className) return false;
	if(target[0]) target = target[0];
	var pattern = new RegExp("(^|\\s)"+className+"(\\s|$)");
	return pattern.test(target.className);
}
//正式开始
window.events = {}
events._deleFn = {}; //保存delegate所绑定的方法
events._mouseFn ={}; //保存“onmouseenter”和“onmouseleave”所绑定的方法
events._ieFunc = {}; //由于保存在ie下绑定的方法
events._mouseHandle = function(fn){
	/* 实现mouseenter/leave 的转换方法，符合条件时才会执行 */
	var func = function(event){
		var target = event.target;
		var parent = event.relatedTarget; //在onmouseover/out操作中，相关的另一个节点
		while( parent &amp;&amp; parent != this ){
			try{ parent = parent.parentNode; }
			catch(e){break;}
		}
		/* 只有当相关节点的父级不会是绑定的节点时（即二者不是父子的包含关系），才调用fn，否则不做处理 */
		( parent != this ) &amp;&amp; (fn.call(target,event));
	};
	return func;
}
events._delegateHandle = function(obj,selector,fn){
	/* 实现delegate 的转换方法，符合条件时才会执行 */
	var func = function(event){
		var event = event || window.event;
		var target = event.srcElement || event.target;
		var parent = target;
		function contain(item,elmName){
			if(elmName.split('#')[1]){ //by id
				if(item.id &amp;&amp; item.id === elmName.split('#')[1]) return true;
			}
			if(elmName.split('.')[1]){ //by class
				if(hasClass(item, elmName.split('.')[1])) return true;
			}
			if(item.tagName == elmName.toUpperCase())  return true; //by tagname
			return false;
		}
		while(parent){
			/* 如果触发的元素，属于(selector)元素的子级。 */
			if(obj == parent) return false; //触发元素是自己
			if(contain(parent,selector)){
				fn.call(obj,event);
				return;
			}
			parent = parent.parentNode;
		}
	};
	return func;
};
events.addEvent = function(target,type,fn){
	if (!target) return false;
	var add = function(obj){
		if(obj.addEventListener){
			obj.addEventListener(type,fn,false);
		}else{
			// for ie
			if(!events._ieFunc[obj]) events._ieFunc[obj] = {};
			if(!events._ieFunc[obj][type]) events._ieFunc[obj][type] = {};
			events._ieFunc[obj][type][fn] = function(){
				fn.apply(obj,arguments);
			};
			obj.attachEvent("on" + type,events._ieFunc[obj][type][fn]);
		}
	}
	if(isDOMs(target)) {
		for(var i=0, l = target.length; i &lt; l; i++){
			add(target[i])
		}
	}else{
		add(target);
	}
};
events.removeEvent = function(target,type,fn) {
	if (!target) return false;
    var remove = function(obj){
    	if(obj.addEventListener){
			if(obj.onmouseenter !== undefined){
				obj.removeEventListener(type,fn,false);
				return ;
			}
			obj.removeEventListener(type,fn,false);
		}else{
			//for ie
			if(!events._ieFunc[obj] ||!events._ieFunc[obj][type] || !events._ieFunc[obj][type][fn]) return;
			obj.detachEvent("on" + type, events._ieFunc[obj][type][fn],false);
			events._ieFunc[obj][type][fn]={};
		}
    }
    if(isDOMs(target)) {
		for(var i=0, l = target.length; i &lt; l; i++){
			remove(target[i])
		}
	}else{
		remove(target);
	}
};
events.delegate = function(obj,selector,type,fn){
	if (!obj || !selector) return false;
	var fnNew = events._delegateHandle(obj,selector,fn);
	events.addEvent(obj,type,fnNew);
	/* 将绑定的方法存入events._deleFn，以便之后解绑操作 */
	if(!events._deleFn[selector]) events._deleFn[selector] = {};
	if(!events._deleFn[selector][type]) events._deleFn[selector][type] = {};
	events._deleFn[selector][type][fn] = fnNew;
};
events.undelegate = function(obj,selector,type,fn){
	if (!obj || !selector || !events._deleFn[selector]) return false;
	var fnNew = events._deleFn[selector][type][fn];
	if(!fnNew) return;
	events.removeEvent(obj,type,fnNew);
	events._deleFn[selector][type][fn] = null;
};
(function(){
	/* 这里是演示demo*/
	var outer = $id("outer"),
		msg = $id("message");
	var add = function(){
		var e = arguments[0] || window.event;
		var target = e.srcElement || e.target;
		msg.innerHTML =  target.innerHTML + ' ' + e.type;
	}
	function color(){
		msg.style.color = "#c00"
	}
	function remove(){
		events.undelegate(outer,".inner","click",color);
		events.undelegate(outer,"#unbind","click",remove);
		msg.style.color = "#000"
		msg.innerHTML = "已解除绑定color方法.add方法仍在";
	}
	events.delegate(outer,".inner","click",add);
	events.delegate(outer,".inner","click",color);
	events.delegate(outer,"#unbind","click",remove);
})()
&lt;/script&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20111218_mouseenter_mouseleave_delegate__2')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20111218_mouseenter_mouseleave_delegate__2')">Copy</button></div></div>
这里的实现思路是这样的：如果触发事件的元素，是你想要绑定的元素的子级（当然他肯定已是委托实际绑定元素的子级），就执行绑定的事件方法，否则方法就不执行，看上去就像方法没绑定过一样。
同实现onmouseenter一样，我们也设计了一个events._deleFn来用于后面的解绑方法undelegate的实现。
另外针对ie，我们还解决了两个问题：
1. 绑定方法内的this指向问题。我们用.apply执行绑定方法来解决。
2. 使用apply调用绑定方法，就必须考虑如何解绑方法。原理和_mouseFn还有_deleFn一样。

在使用delegate时，我们同样遇到了mouseover/out的问题。
我们的解决方案是：不罗嗦，直接将mouseover/out处理成mouseenter/leave
 <div class="runcode"><textarea class="runcode_text" id="runcode_20111218_mouseenter_mouseleave_delegate__3">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;title&gt;delegate委托绑定事件方法的实现&lt;/title&gt;
&lt;style&gt;
.outer{padding:50px;background:#aaa;zoom:1;}
.inner{display:block;height:50px;background:#eee;border:1px solid #ccc;}
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div id="outer" class="outer"&gt;
	&lt;div id="message"&gt;划过下面框体&lt;/div&gt;
	&lt;span class="inner"&gt;1:&lt;/span&gt;
	&lt;span class="inner"&gt;2:&lt;/span&gt;
	&lt;span class="inner"&gt;3:&lt;/span&gt;
	&lt;span class="inner"&gt;4:&lt;/span&gt;
	&lt;span class="inner"&gt;5:&lt;/span&gt;
	&lt;div id="unbind"&gt;点击解除绑定&lt;/div&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;script&gt;
var $id=function(o){return document.getElementById(o) || o;}
var isDOMs = function(target){
	return target.length &gt;= 0 &amp;&amp; target !== window &amp;&amp; !target.tagName;  //!target.tagName排除FORM,SELECT等元素
};
window.events = {}
events._deleFn = {}; //保存delegate所绑定的方法
events._mouseFn ={}; //保存“onmouseenter”和“onmouseleave”所绑定的方法
events._ieFunc = {}; //由于保存在ie下绑定的方法
events._mouseHandle = function(fn){
	/* 实现mouseenter/leave 的转换方法，符合条件时才会执行 */
	var func = function(event){
		var target = event.target;
		var parent = event.relatedTarget; //在onmouseover/out操作中，相关的另一个节点
		while( parent &amp;&amp; parent != this ){
			try{ parent = parent.parentNode; }
			catch(e){break;}
		}
		/* 只有当相关节点的父级不会是绑定的节点时（即二者不是父子的包含关系），才调用fn，否则不做处理 */
		( parent != this ) &amp;&amp; (fn.call(target,event));
	};
	return func;
}
events._delegateHandle = function(obj,selector,fn){
	/* 实现delegate 的转换方法，符合条件时才会执行 */
	var func = function(event){
		var event = event || window.event;
		var target = event.srcElement || event.target;
		var parent = target;
		function contain(item,elmName){
			if(elmName.split('#')[1]){ //by id
				if(item.id &amp;&amp; item.id === elmName.split('#')[1]) return true;
			}
			if(elmName.split('.')[1]){ //by class
				if(hasClass(item, elmName.split('.')[1])) return true;
			}
			if(item.tagName == elmName.toUpperCase())  return true; //by tagname
			return false;
		}
		while(parent){
			/* 如果触发的元素，属于(selector)元素的子级。 */
			if(obj == parent) return false; //触发元素是自己
			if(contain(parent,selector)){
				if(event.type == 'mouseover' || event.type == 'mouseout'){
					/*
					* 将mouseover/out直接处理成mouseenter/leave: 事件相关元素不属于绑定元素的子级，才绑定方法
					*/
					//事件相关元素。ie下使用toElement和fromElement，其他用relatedTarget。
					var related = event.relatedTarget || ((event.type == 'mouseout') ? event.toElement : event.fromElement);
					if(contain(target,selector) || contain(related,selector)) {
						/* 如果，触发元素或相关元素属于绑定元素(selector)。执行方法 */
						fn.call(obj,event);
						return;
					}
					while( related &amp;&amp; !contain(related,selector)){
						  related = related.parentNode;
					}
					/* 事件相关元素，不属于绑定元素(selector)的子级，执行方法  */
					!contain(related,selector) &amp;&amp; (fn.call(obj,event));
				}else{
					fn.call(obj,event);
				}
				return;
			}
			parent = parent.parentNode;
		}
	};
	return func;
};
events.addEvent = function(target,type,fn){
	if (!target) return false;
	var add = function(obj){
		if(obj.addEventListener){
			if(obj.onmouseenter !== undefined){
				//for opera11，firefox10。他们也支持“onmouseenter”和“onmouseleave”，可以直接绑定
				obj.addEventListener(type,fn,false);
				return ;
			}
			if(type=="mouseenter" || type=="mouseleave" ){
				var eType = (type=="mouseenter") ? "mouseover" : "mouseout";
				var fnNew = events._mouseHandle(fn);
				obj.addEventListener(eType,fnNew,false);
				 /* 将方法存入events._mouseFn，以便以后remove */
				if(!events._mouseFn[obj]) events._mouseFn[obj] = {};
				if(!events._mouseFn[obj][eType]) events._mouseFn[obj][eType] = {};
					events._mouseFn[obj][eType][fn] = fnNew;
			}else{
				obj.addEventListener(type,fn,false);
			}
		}else{
			// for ie
			if(!events._ieFunc[obj]) events._ieFunc[obj] = {};
			if(!events._ieFunc[obj][type]) events._ieFunc[obj][type] = {};
			events._ieFunc[obj][type][fn] = function(){
				fn.apply(obj,arguments);
			};
			obj.attachEvent("on" + type,events._ieFunc[obj][type][fn]);
		}
	}
	if(isDOMs(target)) {
		for(var i=0, l = target.length; i &lt; l; i++){
			add(target[i])
		}
	}else{
		add(target);
	}
};
events.removeEvent = function(target,type,fn) {
	if (!target) return false;
    var remove = function(obj){
    	if(obj.addEventListener){
			if(obj.onmouseenter !== undefined){
				obj.removeEventListener(type,fn,false);
				return ;
			}
			if(type=="mouseenter" || type=="mouseleave" ){
				var eType = (type=="mouseenter") ? "mouseover" : "mouseout";
				if(!events._mouseFn[obj][eType][fn]) return;
				obj.removeEventListener(eType,events._mouseFn[obj][eType][fn],false);
				events._mouseFn[obj][eType][fn]={};
			}else{
				obj.removeEventListener(type,fn,false);
			}
		}else{
			//for ie
			if(!events._ieFunc[obj] ||!events._ieFunc[obj][type] || !events._ieFunc[obj][type][fn]) return;
			obj.detachEvent("on" + type, events._ieFunc[obj][type][fn],false);
			events._ieFunc[obj][type][fn]={};
		}
    }
    if(isDOMs(target)) {
		for(var i=0, l = target.length; i &lt; l; i++){
			remove(target[i])
		}
	}else{
		remove(target);
	}
};
events.delegate = function(obj,selector,type,fn){
	if (!obj || !selector) return false;
	var fnNew = events._delegateHandle(obj,selector,fn);
	events.addEvent(obj,type,fnNew);
	/* 将绑定的方法存入events._deleFn，以便之后解绑操作 */
	if(!events._deleFn[selector]) events._deleFn[selector] = {};
	if(!events._deleFn[selector][type]) events._deleFn[selector][type] = {};
	events._deleFn[selector][type][fn] = fnNew;
};
events.undelegate = function(obj,selector,type,fn){
	if (!obj || !selector || !events._deleFn[selector]) return false;
	var fnNew = events._deleFn[selector][type][fn];
	if(!fnNew) return;
	events.removeEvent(obj,type,fnNew);
	events._deleFn[selector][type][fn] = null;
};
(function(){
	/* 这里是演示demo*/
	var outer = $id("outer"),
		msg = $id("message");
	events.delegate(outer,'span',"mouseover",add);
	events.delegate(outer,'span',"mouseout",add);
	events.delegate(outer,'#unbind',"click",remove);
	function add(){
		var e = arguments[0] || window.event;
		var target = e.srcElement || e.target;
		msg.innerHTML =  target.innerHTML + ' ' + e.type;
	}
	function remove(){
		events.undelegate(outer,'span',"mouseover",add);
		events.undelegate(outer,'span',"mouseout",add);
		events.undelegate(outer,'#unbind',"click",remove);
	}
})()
&lt;/script&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20111218_mouseenter_mouseleave_delegate__3')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20111218_mouseenter_mouseleave_delegate__3')">Copy</button></div></div>
最后，整理一下，封装一个支持mouseenter 和 mouseleave事件，delegate方法 及其他们的解除绑定的方法的 功能函数库。

```
window.events = {}
events._deleFn = {}; //保存delegate所绑定的方法   
events._mouseFn ={}; //保存“onmouseenter”和“onmouseleave”所绑定的方法
events._ieFunc = {}; //由于保存在ie下绑定的方法
 
events._mouseHandle = function(fn){
    /* 实现mouseenter/leave 的转换方法，符合条件时才会执行 */
    var func = function(event){
        var target = event.target;
        var parent = event.relatedTarget; //在onmouseover/out操作中，相关的另一个节点
        while( parent && parent != this ){ 
            try{ parent = parent.parentNode; }
            catch(e){break;}
        }
        /* 只有当相关节点的父级不会是绑定的节点时（即二者不是父子的包含关系），才调用fn，否则不做处理 */
        ( parent != this ) && (fn.call(target,event));
    };
    return func;
}
 
events._delegateHandle = function(obj,selector,fn){
    /* 实现delegate 的转换方法，符合条件时才会执行 */
    var func = function(event){
        var event = event || window.event;
        var target = event.srcElement || event.target;
        var parent = target;
        function contain(item,elmName){
            if(elmName.split('#')[1]){ //by id
                if(item.id && item.id === elmName.split('#')[1]) return true;
            } 
            if(elmName.split('.')[1]){ //by class
                if(hasClass(item, elmName.split('.')[1])) return true;
            }
            if(item.tagName == elmName.toUpperCase())  return true; //by tagname
            return false;
        }
 
        while(parent){
            /* 如果触发的元素，属于(selector)元素的子级。 */
            if(obj == parent) return false; //触发元素是自己
            if(contain(parent,selector)){
                if(event.type == 'mouseover' || event.type == 'mouseout'){
                    /*
                    * 将mouseover/out直接处理成mouseenter/leave: 事件相关元素不属于绑定元素的子级，才绑定方法
                    */
                    //事件相关元素。ie下使用toElement和fromElement，其他用relatedTarget。
                    var related = event.relatedTarget || ((event.type == 'mouseout') ? event.toElement : event.fromElement);
                    if(contain(target,selector) || contain(related,selector)) {
                        /* 如果，触发元素或相关元素属于绑定元素(selector)。执行方法 */
                        fn.call(obj,event);
                        return;
                    }
                    while( related && !contain(related,selector)){ 
                          related = related.parentNode;
                    }
                    /* 事件相关元素，不属于绑定元素(selector)的子级，执行方法  */
                    !contain(related,selector) && (fn.call(obj,event));
                }else{
                    fn.call(obj,event);
                }
                return;
            }
            parent = parent.parentNode;   
        }
    };
    return func;
};
 
events.addEvent = function(target,type,fn){
    if (!target) return false;
    var add = function(obj){
        if(obj.addEventListener){   
            if(obj.onmouseenter !== undefined){
                //for opera11，firefox10。他们也支持“onmouseenter”和“onmouseleave”，可以直接绑定
                obj.addEventListener(type,fn,false); 
                return ;
            }
            if(type=="mouseenter" || type=="mouseleave" ){ 
                var eType = (type=="mouseenter") ? "mouseover" : "mouseout";
                var fnNew = events._mouseHandle(fn);
                obj.addEventListener(eType,fnNew,false);
                 /* 将方法存入events._mouseFn，以便以后remove */
                if(!events._mouseFn[obj]) events._mouseFn[obj] = {};
                if(!events._mouseFn[obj][eType]) events._mouseFn[obj][eType] = {};
                    events._mouseFn[obj][eType][fn] = fnNew;
            }else{
                obj.addEventListener(type,fn,false);
            }
        }else{
            // for ie
            if(!events._ieFunc[obj]) events._ieFunc[obj] = {};
            if(!events._ieFunc[obj][type]) events._ieFunc[obj][type] = {};
            events._ieFunc[obj][type][fn] = function(){
                fn.apply(obj,arguments);
            };
            obj.attachEvent("on" + type,events._ieFunc[obj][type][fn]);
        }
    }
    if(isDOMs(target)) {
        for(var i=0, l = target.length; i < l; i++){
            add(target[i])
        }
    }else{
        add(target);
    }
};
 
events.removeEvent = function(target,type,fn) {
    if (!target) return false;
    var remove = function(obj){
        if(obj.addEventListener){   
            if(obj.onmouseenter !== undefined){
                obj.removeEventListener(type,fn,false); 
                return ;
            }
            if(type=="mouseenter" || type=="mouseleave" ){ 
                var eType = (type=="mouseenter") ? "mouseover" : "mouseout";
                if(!events._mouseFn[obj][eType][fn]) return;
                obj.removeEventListener(eType,events._mouseFn[obj][eType][fn],false);
                events._mouseFn[obj][eType][fn]={};
            }else{
                obj.removeEventListener(type,fn,false);
            }
        }else{
            //for ie
            if(!events._ieFunc[obj] ||!events._ieFunc[obj][type] || !events._ieFunc[obj][type][fn]) return;
            obj.detachEvent("on" + type, events._ieFunc[obj][type][fn],false);
            events._ieFunc[obj][type][fn]={};
        }
    }
    if(isDOMs(target)) {
        for(var i=0, l = target.length; i < l; i++){
            remove(target[i])
        }
    }else{
        remove(target);
    }
};
 
events.delegate = function(obj,selector,type,fn){
    if (!obj || !selector) return false;
    var fnNew = events._delegateHandle(obj,selector,fn);
    events.addEvent(obj,type,fnNew);
    /* 将绑定的方法存入events._deleFn，以便之后解绑操作 */
    if(!events._deleFn[selector]) events._deleFn[selector] = {};
    if(!events._deleFn[selector][type]) events._deleFn[selector][type] = {};
    events._deleFn[selector][type][fn] = fnNew;
};
 
events.undelegate = function(obj,selector,type,fn){
    if (!obj || !selector || !events._deleFn[selector]) return false;
    var fnNew = events._deleFn[selector][type][fn];
    if(!fnNew) return;
    events.removeEvent(obj,type,fnNew);
    events._deleFn[selector][type][fn] = null;
};

```
