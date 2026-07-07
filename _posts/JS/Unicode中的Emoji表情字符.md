---
layout: post
title: "Unicode中的Emoji表情字符"
date: "2014-05-09 11:37:28 +0800"
slug: "Unicode中的Emoji表情字符"
category: "developer"
categories:
  - "developer"
tags:
  - "unicode"
permalink: "/2014/05/09/Unicode中的Emoji表情字符/"
---

<div class="runcode"><textarea class="runcode_text" id="runcode_20140509_Unicode_Emoji__1">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="UTF-8"/&gt;
&lt;title&gt;Unicode6.0字符显示&lt;/title&gt;
&lt;style&gt;
	*{padding:0;margin:0;}
	body{font-size:50px;padding:20px;}
	h3{padding:20px 10px;background:#eee;}
	p{word-wrap:break-word;border:1px solid #ccc; padding:10px;}
&lt;/style&gt;
&lt;script src="https://show.cssass.com/public/js/extend.js"&gt;&lt;/script&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div id="showcode"&gt;

&lt;/div&gt;
&lt;script&gt;
var code = "&lt;h3&gt;Emoticons&lt;/h3&gt;&lt;p&gt;";
for(var i = 0x1f600 ; i &lt;= 0x1f64f; i = i + 1 ){
	code += "&amp;#" + i + ";";
}
code += "&lt;/p&gt;&lt;h3&gt;Miscellaneous Symbols And Pictographs&lt;/h3&gt;&lt;p&gt;";
for(var i = 0x1F300 ; i &lt;= 0x1F5FF; i = i + 1 ){
	code += "&amp;#" + i + ";";
}
code += "&lt;/p&gt;&lt;h3&gt;Playing Cards&lt;/h3&gt;&lt;p&gt;";
for(var i = 0x1F0A0 ; i &lt;= 0x1F0FF; i = i + 1 ){
	code += "&amp;#" + i + ";";
}
code += "&lt;/p&gt;&lt;h3&gt;Transport And Map symbols&lt;/h3&gt;&lt;p&gt;";
for(var i = 0x1F680 ; i &lt;= 0x1F6FF; i = i + 1 ){
	code += "&amp;#" + i + ";";
}
code += "&lt;/p&gt;&lt;h3&gt;Dingbats&lt;/h3&gt;&lt;p&gt;";
for(var i = 0x2700 ; i &lt;= 0x27BF; i = i + 1 ){
	code += "&amp;#" + i + ";";
}
code += "&lt;/p&gt;&lt;h3&gt;Miscellaneous Technical&lt;/h3&gt;&lt;p&gt;";
for(var i = 0x2300 ; i &lt;= 0x23ff; i = i + 1 ){
	code += "&amp;#" + i + ";";
}
code += "&lt;/p&gt;&lt;h3&gt;Miscellaneous Symbols&lt;/h3&gt;&lt;p&gt;";
code += "&amp;#" + 0x26CE + ";";
code += "&lt;/p&gt;&lt;h3&gt;Enclosed Alphanumeric Supplement&lt;/h3&gt;&lt;p&gt;";
for(var i = 0x1F170 ; i &lt;= 0x1F171; i = i + 1 ){
	code += "&amp;#" + i + ";";
}
code += "&amp;#" + 0x1F17E + ";";
code += "&amp;#" + 0x1F18E + ";";
for(var i = 0x1F191 ; i &lt;= 0x1F19A; i = i + 1 ){
	code += "&amp;#" + i + ";";
}
code += "&lt;/p&gt;&lt;h3&gt;Enclosed Ideographic Supplement&lt;/h3&gt;&lt;p&gt;";
for(var i = 0x1F201 ; i &lt;= 0x1F202; i = i + 1 ){
	code += "&amp;#" + i + ";";
}
for(var i = 0x1F232 ; i &lt;= 0x1F23A; i = i + 1 ){
	code += "&amp;#" + i + ";";
}
for(var i = 0x1F250 ; i &lt;= 0x1F251; i = i + 1 ){
	code += "&amp;#" + i + ";";
}
code += "&lt;/p&gt;&lt;h3&gt;Regional Indicator Symbols&lt;/h3&gt;&lt;p&gt;";
for(var i = 0x1F1E6 ; i &lt;= 0x1F1FF; i = i + 1 ){
	code += "&amp;#" + i + ";";
}
code += "&lt;/p&gt;&lt;h3&gt;Common Flag Sequences&lt;/h3&gt;&lt;p&gt;";
var flags = ["AC","AD","AE","AF","AG","AI","AL","AM","AO","AQ","AR","AS","AT","AU","AW","AX","AZ","BA","BB","BD","BE","BF","BG","BH","BI","BJ","BL","BM","BN","BO","BQ","BR","BS","BT","BV","BW","BY","BZ","CA","CC","CD","CF","CG","CH","CI","CK","CL","CM","CN","CO","CP","CR","CU","CV","CW","CX","CY","CZ","DE","DG","DJ","DK","DM","DO","DZ","EA","EC","EE","EG","EH","ER","ES","ET","EU","FI","FJ","FK","FM","FO","FR","GA","GB","GD","GE","GF","GG","GH","GI","GL","GM","GN","GP","GQ","GR","GS","GT","GU","GW","GY","HK","HM","HN","HR","HT","HU","IC","ID","IE","IL","IM","IN","IO","IQ","IR","IS","IT","JE","JM","JO","JP","KE","KG","KH","KI","KM","KN","KP","KR","KW","KY","KZ","LA","LB","LC","LI","LK","LR","LS","LT","LU","LV","LY","MA","MC","MD","ME","MF","MG","MH","MK","ML","MM","MN","MO","MP","MQ","MR","MS","MT","MU","MV","MW","MX","MY","MZ","NA","NC","NE","NF","NG","NI","NL","NO","NP","NR","NU","NZ","OM","PA","PE","PF","PG","PH","PK","PL","PM","PN","PR","PS","PT","PW","PY","QA","RE","RO","RS","RU","RW","SA","SB","SC","SD","SE","SG","SH","SI","SJ","SK","SL","SM","SN","SO","SR","SS","ST","SV","SX","SY","SZ","TA","TC","TD","TF","TG","TH","TJ","TK","TL","TM","TN","TO","TR","TT","TV","TW","TZ","UA","UG","UM","US","UY","UZ","VA","VC","VE","VG","VI","VN","VU","WF","WS","XK","YE","YT","ZA","ZM","ZW"];
for(var i = 0; i &lt; flags.length; i = i + 1 ){
	var flag = flags[i];
	code += "&amp;#" + (0x1F1E6 + flag.charCodeAt(0) - 65) + ";&amp;#" + (0x1F1E6 + flag.charCodeAt(1) - 65) + ";";
}
code += "&lt;/p&gt;";
$id("showcode").insertAdjacentHTML("beforeend",code);
&lt;/script&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20140509_Unicode_Emoji__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20140509_Unicode_Emoji__1')">Copy</button></div></div>

附一个QQ表情库
<div class="runcode"><textarea class="runcode_text" id="runcode_20140509_Unicode_Emoji__2">&lt;!doctype html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="UTF-8"/&gt;
&lt;title&gt;QQ Emoticons&lt;/title&gt;
&lt;style&gt;
	*{padding:0;margin:0;}
	img {padding:10px;margin:10px;border:3px double #eee;border-radius:8px;}
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div id="showEmo"&gt;

&lt;/div&gt;
&lt;/body&gt;
&lt;script&gt;
var $id = function(o){
	return document.getElementById(o);
};
var Emo = {
	url : "http://ctc.qzonestyle.gtimg.cn/qzone/em/e",
	index : 0,
	removeArr : {205:300,371:500,778:829,954:1000,1012:1500,1503:2000,2074:2172,2325:2801,2804:3000,3079:3173,3200:4001,4021:4300,4302:4400,4411:6001,6096:7000,7450:10000,10075:100000,100179:100491,100730:110000,110157:120000,120043:121001,121036:326980,326981:327183,327184:327343,327570:327743,328710:332445},
	getEmoStr : function(start,num){
		var str = "";
		Emo.index = start + num;
		for(var i = start; i &lt; Emo.index; i++){
			if(i in Emo.removeArr){
				Emo.index =  Emo.removeArr[i];
				str += "&lt;br /&gt;";
				break;
			}
			str += "&lt;img title="+i+" src=" + Emo.url + i + ".gif /&gt;";
		};
		return str;
	}
};

var showDIV = $id("showEmo");
showDIV.insertAdjacentHTML("beforeend",Emo.getEmoStr(Emo.index, 1000));
window.onscroll=function(){
	var scrollTop = document.body.scrollTop || document.documentElement.scrollTop,
		windowHeight = document.documentElement.clientHeight,
		documentHeight = document.body.offsetHeight;
	if(windowHeight + scrollTop &gt; documentHeight - 50 ){
		showDIV.insertAdjacentHTML("beforeend",Emo.getEmoStr(Emo.index, 200));
	};
};
&lt;/script&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20140509_Unicode_Emoji__2')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20140509_Unicode_Emoji__2')">Copy</button></div></div>
