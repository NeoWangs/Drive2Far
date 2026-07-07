---
layout: post
title: "JS实现字符unicode编码信息查询"
date: "2009-05-02 16:11:04 +0800"
slug: "JS实现字符unicode编码信息查询"
category: "developer"
categories:
  - "developer"
tags:
  - "JS"
  - "unicode"
permalink: "/2009/05/02/JS实现字符unicode编码信息查询/"
---

这两天在xiaonei的个人状态里看见很多人添加有一些特殊字符，如҉ (据说叫菊花，囧nz)。当然这种字符也还没什么稀奇，这个符号是cyrillic里百万的标识。另外有见到一个能将文字反排显示的不可见字符,比较有趣。如下：

<div class="runcode"><textarea class="runcode_text" id="runcode_20090502_JS_unicode__1">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta http-equiv="Content-Type" content="text/html; charset=utf-8" /&gt;
&lt;title&gt;RLO(right-to-left override)字符的演示&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;input type="text" value="&amp;#8238;我从右往左？"/&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20090502_JS_unicode__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20090502_JS_unicode__1')">Copy</button></div></div>
   此RLO字符的效果就是将文字反排（效果有点类似<bdo dir=rtl>啊。参见：HTML的dir属性和<bdo>标签及其他一些CSS文字排版属性、滤镜 不过bdo这个是需要浏览器解释后才能看见效果的，而此RLO不需要浏览器解释，当然上面代码里使用的是html字符实体编号,这个是需要浏览器解释的。）

   在UCS（Unicode Character Set）当中，每个字符都有一个unicode编码——不过，拥有unicode码的不一定是字符，也可以是设备控制符。
   应该说，很多形式的字符编码都是基于unicode编码的，如URL-encode,ASCll码,HTML Character Entities编号。特别是HTML Character Entities编号，与unicode可以说是一一对应的，只要浏览器支持，charset包含，“&#”+十进制标号+“；”的编码就能在html中使用所有unicode中定义字符。
   以上面的RLO字符分析，虽然RLO符看不见，但也是可以被copy的，而且，必然的有一个对应的unicode码。RLO的unicode对应的16进制编号是：202e；10进制是：8238。要在html中使用这个字符，除了copy这个字符过来外，我们可以使用Character Entities References(HTML Entities)：&#+8238+;(不包括+号)，或Numeric Character Reference(NCR):&#+x202e+;。
关于如何查到某个字符的unicode编码，每种程序语言应该都有函数可以用来解码为unicode，这里有一个php的解码应用：convert-to-html。这是直接解成html实体编码的。它同unicode的关系只是十进制与十六进制的关系（实质是一样的）。要看16进制unicode只需做下进制转码就行了。知道了16进制编码，我们就可以在这里查询字符的信息：unicode.org

下面是js写的转码工具：
<div class="runcode"><textarea class="runcode_text" id="runcode_20090502_JS_unicode__2">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;title&gt;字符的unicode码信息查询&lt;/title&gt;
&lt;style type="text/css"&gt;
  body{font-size:13px;background:#ccc;}
  #codeShow{display:none;}
  #codeShow .showBox{width:800px;}
  #codeShow ul{overflow:hidden;zoom:1;}
  #codeShow li{float:left;width:220px;text-align:center;list-style:none;}
&lt;/style&gt;
&lt;script type="text/javascript"&gt;
function $id(o)
{
  return document.getElementById(o) || o;
}
function escapeCode(){
    var hexArray = [],
		decArray = [],
		entiArray = [];
    var decCode,
		inTXT = $id('inputValue').value,
		outTXT='',
		entityCode='',
		outList="&lt;ul&gt;&lt;li&gt;Unicode Character Code编码&lt;/li&gt;&lt;li&gt;HTML Character Entities编号&lt;/li&gt;&lt;li&gt;字符显示&lt;/li&gt;&lt;li&gt;unicode信息查询&lt;/li&gt;&lt;/ul&gt;";
		//if($id('convAll').checked){  //true,转换a-z,A-Z等字符的unicode编码
		  var character;
		  for(i=0; i&lt;inTXT.length; i++){
			character = inTXT.charCodeAt(i).toString(16).toUpperCase();   //法1：使用charCodeAt逐字转码
			outTXT += character+' ';
			hexArray.push(character);
		   }
//		}
//		else{
//			outTXT = escape(inTXT);               //法2：使用escape直接转码（不转a-z,A-Z等字符）
//			hexArray = outTXT.split(/%u|%/);  //以%u和%做分割插入数组
//		}
		for(i in hexArray){
			if(hexArray[i]=='') hexArray.splice(i,1); //清除空的数组项（FF）
			hexArray[i] = hexArray[i].slice(0,4);     //截取数组项中前四个字符。（消除a-z,A-Z等不解码产生的影响）
			decCode = parseInt(hexArray[i],16).toString(10);
			decArray.push(decCode);
			entityCode += '&amp;#'+decCode+'; ';
			outList+="&lt;ul&gt;&lt;li&gt;"+hexArray[i]+"&lt;/li&gt;&lt;li&gt;"+decArray[i]+"&lt;/li&gt;&lt;li&gt;\"&amp;#"+decCode+";\"&lt;/li&gt;";
			outList+="&lt;li&gt;&lt;form enctype='application/x-www-form-urlencoded' action='//www.unicode.org/charts/cgi-bin/Code2Chart' method='post' target='_blank'&gt;";
			outList+="&lt;input type='hidden'  maxlength='8' size='8' name='HexCode' value="+hexArray[i]+" /&gt;";
			outList+="&lt;input type='submit' value='Go' name='submit'/&gt;&lt;/form&gt;&lt;/li&gt;&lt;/ul&gt;";
		}
		$id('outUnicode').value = outTXT;   //输出unicode码，以%u或%开头。
		$id('outEnticode').value = entityCode;  //输出字符实体编码
		$id('outView').innerHTML = outList;  //输出编码值，并有unicode信息查询链接。
		$id('codeShow').style.display='block';
	 }
&lt;/script&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;h2&gt;字符转unicode码&lt;/h2&gt;
（&lt;a href="http://www.cssass.com/blog/index.php/convert_characters_to_unicode" target="_blank"&gt;Read  in my Blog&lt;/a&gt;）
&lt;div&gt;
	&lt;input type="text" id="inputValue" value="输入字符:如&amp;#1161;" style="width:180px;height:25px;padding:2px;"/&gt;&lt;label&gt;
	&lt;!-- &lt;input id="convAll" type="checkbox" /&gt;a-z,A-Z,0-9,@,/,.,+,-,_等字符也加入转码.&lt;/label&gt; --&gt;
	&lt;br /&gt;
	&lt;input type="button" value="转为unicode码" onclick="escapeCode();"/&gt;
	&lt;p&gt;
&lt;/div&gt;
&lt;div id="codeShow"&gt;
	16进制Unicode：&lt;br /&gt;
	&lt;input class="showBox" id="outUnicode" /&gt;&lt;br /&gt;
	10进制Enticode：&lt;br /&gt;
	&lt;input class="showBox" id="outEnticode" /&gt;
	&lt;div id="outView"&gt;&lt;/div&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20090502_JS_unicode__2')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20090502_JS_unicode__2')">Copy</button></div></div>
可以解开任意字符的unicode码，并生成字符实体码，而且可以链接到unicode官网查询该字符的信息。
js中escape这个函数能直接将字符串转成unicode码，不过有部分属于ASCll编码的字符不会解开。
而charCodeAt函数则能解开任何字符的unicode码。

JS中解码的函数还有encodeURI——这个解开的unicode码我们会经常看见，地址栏里的字符串即出自于此。
另外在写了个简单的进制转换工具，支持10进制与16进制之间的互转，比较常用啊。
<div class="runcode"><textarea class="runcode_text" id="runcode_20090502_JS_unicode__3">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;title&gt;16进制，10进制互转&lt;/title&gt;
&lt;style type="text/css"&gt;
body{font-size:13px;background:#ccc;}
#codeShow{width:230px;overflow:hidden;}
.codeWrap{float:left;width:110px;}
.codeWrap textarea{width:100px;height:300px;}
&lt;/style&gt;
&lt;script src="/public/js/extend.js"&gt;&lt;/script&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;h2&gt;十进制与十六进制互转&lt;/h2&gt;
&lt;div id="codeShow"&gt;
	&lt;div class="codeWrap"&gt;
		16进制&lt;br /&gt;
		&lt;textarea id="hexCode" &gt;&lt;/textarea&gt;
	&lt;/div&gt;
	&lt;div class="codeWrap"&gt;
		10进制&lt;br /&gt;
		&lt;textarea id="decCode" &gt;&lt;/textarea&gt;
	&lt;/div&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;script&gt;
function change(code){
	var outs = '';
	var a=[];
	if(code == "H2D"){
		var vals = $id("hexCode").value.split(/[,， ]/);
		for(var i=0; i &lt;vals.length; i++){
			outs += parseInt(vals[i],16).toString(10) + ',' ;
		}
		$id("decCode").value = outs;
	}
	else if(code == "D2H"){
		var vals = $id("decCode").value.split(/[,， ]/);
		for(var i=0; i &lt;vals.length; i++){
			outs += parseInt(vals[i]).toString(16) + ',' ;
		}
		$id("hexCode").value = outs;
	}
}
events.addEvent($id("hexCode"),'keyup',function(){
	change("H2D");
})
events.addEvent($id("decCode"),'keyup',function(){
	change("D2H");
})
&lt;/script&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20090502_JS_unicode__3')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20090502_JS_unicode__3')">Copy</button></div></div>
