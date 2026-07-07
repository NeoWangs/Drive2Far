---
layout: post
title: "XMLHttpRequest Level 2的跨域功能"
date: "2012-12-03 10:39:06 +0800"
slug: "XMLHttpRequest Level 2的跨域功能"
category: "developer"
categories:
  - "developer"
tags:
  - "ajax"
  - "jsonp"
permalink: "/2012/12/03/XMLHttpRequest Level 2的跨域功能/"
---

XMLHttpRequest Level 2的功能已经大幅提升了，
参见：http://www.ruanyifeng.com/blog/2012/09/xmlhttprequest_level_2.html

我们知道，受到浏览器”同域限制“制约，以前的xhr对象是无法完成跨域请求的，而现在只需在Server端做一个访问控制，Client端再用xhr对象请求就行了，一般情况下Client并不需要设置，当然还有些相关的方法属性可供使用的，比如setRequestHeader，withCredentials。
服务端设置参见： https://developer.mozilla.org/en-US/docs/Server-Side_Access_Control

下面我们简单的做个demo
Server端代码(PHP)：

``` php
if($_SERVER['HTTP_ORIGIN'] == "http://www.cssass.com")
        {
            header('Access-Control-Allow-Origin: http://www.cssass.com');
            header('Content-Type: text/plain');
            if($_SERVER['REQUEST_METHOD'] == "GET")
            {
                $arr = array( 
                    'id' => '1',
                    'name' => 'XMLHttpRequest Response' 
                );
                echo json_encode($arr);
            };
        };
```
http响应头设置参见：https://developer.mozilla.org/en-US/docs/HTTP_access_control#The_HTTP_response_headers


Client端代码：
```
<!doctype html>
<meta charset="UTF-8" />
<title>XMLHttpRequest 2演示</title>
<a href="javascript:;" onclick="get_xhr2()">获取数据!(xhr2)</a>
<script>
	function get_xhr2(){
		var xhr = new XMLHttpRequest();
		xhr.open('GET', 'http://www.hzmilo.com/me.php?r=/xhr2/send'); //POST也支持
		xhr.onload = function(e) { //绑定onload
		  var data = JSON.parse(this.response); //json解析
		  alert(data.name);
		}
		xhr.send();
	};
</script>
```
正如你所知，ie下是不支持XMLHttpRequest Level 2的，不过ie8引入了自己的跨域对象XDomainRequest。(同时ie8下的xhr对象也引入了 timeou属性t和ontimeout方法）
所以我们做下兼容（不支持ie6，ie7）：

```
<!doctype html>
<meta charset="UTF-8" />
<title>XMLHttpRequest 2演示</title>
<a href="javascript:;" onclick="get_xhr2()">获取数据!(xhr2)</a>
<script>
	function get_xhr2(){
		var xr,xrName;
		if(window.XDomainRequest){
			xr = new XDomainRequest();
			xrName = "XDomainRequest";
		}else{
			xr = new XMLHttpRequest();
			xrName = "XMLHttpRequest";
		}
		xr.open('GET', 'http://www.hzmilo.com/me.php?r=/xhr2/send/&xr='+xrName);
		xr.onload = function(e) {
		  var data = JSON.parse(this.responseText); //json解析
		  alert(data.name);
		}
		xr.send();
	};
</script>
```
接下来，我们来了解下JSONP这种在同域限制的情况下实现跨域请求（GET）的实现过程。
原理其实就是：以script标签的形式在页面中放置一个请求地址，该请求地址返回的数据格式为：

jsonp1354513528560({“id”:”2″,”name”:”JSON with Padding”})

如果jsonp1354513528560是一个预先定义好的JS方法，那么获取其参数（我们实际需要获取的数据）就顺理成章了。

以下是Client端的实现代码:
```
(function(){
        //jsonp的具体实现
          var randomNum = (new Date).getTime(),
              callName = null,
              sendScriptRequest = function(url,id){
                  //将请求地址以script标签形式插入到页面。（注定是GET请求）
                var head = document.getElementsByTagName("head")[0];
                var script = document.createElement("script");
                script.id = id;
                script.src = url;
                script.charset = 'utf-8';
                head.appendChild(script);
            },
            buildTempFunction = function(callback){
                //创建一个全局方法，并将方法名当做请求地址的一个参数
                callName = "jsonp" + randomNum++;
                window[ callName ] = function(data){
                    callback(data);
                    window[ callName ] = undefined;
                    try{ 
                        delete window[ callName ];
                        //var jsNode = document.getElementById(callName);
                        //jsNode.parentElement.removeChild(jsNode);  //执行全局方法后，将script标签删除
                    } catch(e){}
                };
                return callName;
            },
            $jsonp = function(url,params){
                //生成GET请求地址
                  params.callback = buildTempFunction(params.callback);
                  url += (url.indexOf("?")>0 ) ? "" : "?" ;
                  for(var i in params)
                      url += "&" + i + "=" + params[i];
                sendScriptRequest(url,callName);
              };
            //对外开放接口：$jsonp
            /**
            * @$jsonp JSONP方法
            * @param {String} url 请求地址
            * @param {Object} params 请求参数
            */ 
              if (!window.$jsonp)
                   window.$jsonp = $jsonp;
    })();
```
Server端很简单,只需拼接输出一个js的执行方法即可。
```
$jsonp = $_GET['callback']; //请求端传递的callback参数，作为输出的方法名
        $arr = array( 
            'id' => '2',
            'name' => 'JSON with Padding' 
        );
        echo $jsonp, '(', json_encode($arr), ')';
```
演示：
```
<!doctype html>
<meta charset="UTF-8" />
<title>jsonp演示</title>
<script src="/public/js/extend.js"></script>
<a href="javascript:;" onclick="get_jsonp()">获取数据!(jsonp)</a>
<script>
	function get_jsonp(){
		$jsonp('http://www.hzmilo.com/me.php?r=/xhr2/send2',{"id":1001},function(data){
				alert(data.name);
		});
	};
</script>
```
因为大多数网站不会开启server端的访问控制，所以xhr2目前比较适用于自己所属的几个域名下网站的连结,并且放弃ie6、7。
JSONP应用倒是很普遍，很多网站开放API的时候，也会用jsonp的形式给js提供接口，这样一来，使得ajax也能直接调用到API，当然只限一些普通的无需授权即用的接口。

然而很多网站并未开放API, 也未在服务端设置callback之类的参数，而我们也不想自己写server端代码去抓取。
那么我们可以试试中间代理：http://developer.yahoo.com/yql/

演示：我们抓取一下我很喜欢的一个电影网站（dianying.fm）的数据。
```
<!doctype html>
<meta charset="UTF-8" />
<title>yql演示</title>
<script src="/public/js/extend.js"></script>
<a href="javascript:;" onclick="get_yql()">获取数据!(jsonp代理)</a>
<script>
	function get_yql(){
		$jsonp('http://query.yahooapis.com/v1/public/yql',{
			q: "select * from json where url=\"http://dianying.fm/reflect/cannes/e30=/2\"",
	    	format: "json"},function(data){
				alert(data.query.results.json.html);
			});
	};
</script>
```
