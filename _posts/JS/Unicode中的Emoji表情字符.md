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

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<title>Unicode6.0字符显示</title>
<style>
	*{padding:0;margin:0;}
	body{font-size:50px;padding:20px;}
	h3{padding:20px 10px;background:#eee;}
	p{word-wrap:break-word;border:1px solid #ccc; padding:10px;}
</style>
<script src="https://show.cssass.com/public/js/extend.js"></script>
</head>
<body>
<div id="showcode">

</div>
<script>
var code = "<h3>Emoticons</h3><p>";
for(var i = 0x1f600 ; i <= 0x1f64f; i = i + 1 ){
	code += "&#" + i + ";";
}
code += "</p><h3>Miscellaneous Symbols And Pictographs</h3><p>";
for(var i = 0x1F300 ; i <= 0x1F5FF; i = i + 1 ){
	code += "&#" + i + ";";
}
code += "</p><h3>Playing Cards</h3><p>";
for(var i = 0x1F0A0 ; i <= 0x1F0FF; i = i + 1 ){
	code += "&#" + i + ";";
}
code += "</p><h3>Transport And Map symbols</h3><p>";
for(var i = 0x1F680 ; i <= 0x1F6FF; i = i + 1 ){
	code += "&#" + i + ";";
}
code += "</p><h3>Dingbats</h3><p>";
for(var i = 0x2700 ; i <= 0x27BF; i = i + 1 ){
	code += "&#" + i + ";";
}
code += "</p><h3>Miscellaneous Technical</h3><p>";
for(var i = 0x2300 ; i <= 0x23ff; i = i + 1 ){
	code += "&#" + i + ";";
}
code += "</p><h3>Miscellaneous Symbols</h3><p>";
code += "&#" + 0x26CE + ";";
code += "</p><h3>Enclosed Alphanumeric Supplement</h3><p>";
for(var i = 0x1F170 ; i <= 0x1F171; i = i + 1 ){
	code += "&#" + i + ";";
}
code += "&#" + 0x1F17E + ";";
code += "&#" + 0x1F18E + ";";
for(var i = 0x1F191 ; i <= 0x1F19A; i = i + 1 ){
	code += "&#" + i + ";";
}
code += "</p><h3>Enclosed Ideographic Supplement</h3><p>";
for(var i = 0x1F201 ; i <= 0x1F202; i = i + 1 ){
	code += "&#" + i + ";";
}
for(var i = 0x1F232 ; i <= 0x1F23A; i = i + 1 ){
	code += "&#" + i + ";";
}
for(var i = 0x1F250 ; i <= 0x1F251; i = i + 1 ){
	code += "&#" + i + ";";
}
code += "</p><h3>Regional Indicator Symbols</h3><p>";
for(var i = 0x1F1E6 ; i <= 0x1F1FF; i = i + 1 ){
	code += "&#" + i + ";";
}
code += "</p><h3>Common Flag Sequences</h3><p>";
var flags = ["AC","AD","AE","AF","AG","AI","AL","AM","AO","AQ","AR","AS","AT","AU","AW","AX","AZ","BA","BB","BD","BE","BF","BG","BH","BI","BJ","BL","BM","BN","BO","BQ","BR","BS","BT","BV","BW","BY","BZ","CA","CC","CD","CF","CG","CH","CI","CK","CL","CM","CN","CO","CP","CR","CU","CV","CW","CX","CY","CZ","DE","DG","DJ","DK","DM","DO","DZ","EA","EC","EE","EG","EH","ER","ES","ET","EU","FI","FJ","FK","FM","FO","FR","GA","GB","GD","GE","GF","GG","GH","GI","GL","GM","GN","GP","GQ","GR","GS","GT","GU","GW","GY","HK","HM","HN","HR","HT","HU","IC","ID","IE","IL","IM","IN","IO","IQ","IR","IS","IT","JE","JM","JO","JP","KE","KG","KH","KI","KM","KN","KP","KR","KW","KY","KZ","LA","LB","LC","LI","LK","LR","LS","LT","LU","LV","LY","MA","MC","MD","ME","MF","MG","MH","MK","ML","MM","MN","MO","MP","MQ","MR","MS","MT","MU","MV","MW","MX","MY","MZ","NA","NC","NE","NF","NG","NI","NL","NO","NP","NR","NU","NZ","OM","PA","PE","PF","PG","PH","PK","PL","PM","PN","PR","PS","PT","PW","PY","QA","RE","RO","RS","RU","RW","SA","SB","SC","SD","SE","SG","SH","SI","SJ","SK","SL","SM","SN","SO","SR","SS","ST","SV","SX","SY","SZ","TA","TC","TD","TF","TG","TH","TJ","TK","TL","TM","TN","TO","TR","TT","TV","TW","TZ","UA","UG","UM","US","UY","UZ","VA","VC","VE","VG","VI","VN","VU","WF","WS","XK","YE","YT","ZA","ZM","ZW"];
for(var i = 0; i < flags.length; i = i + 1 ){
	var flag = flags[i];
	code += "&#" + (0x1F1E6 + flag.charCodeAt(0) - 65) + ";&#" + (0x1F1E6 + flag.charCodeAt(1) - 65) + ";";
}
code += "</p>";
$id("showcode").insertAdjacentHTML("beforeend",code);
</script>
</body>
</html>
```

附一个QQ表情库
```html runcode
<!doctype html>
<html>
<head>
<meta charset="UTF-8"/>
<title>QQ Emoticons</title>
<style>
	*{padding:0;margin:0;}
	img {padding:10px;margin:10px;border:3px double #eee;border-radius:8px;}
</style>
</head>
<body>
<div id="showEmo">

</div>
</body>
<script>
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
		for(var i = start; i < Emo.index; i++){
			if(i in Emo.removeArr){
				Emo.index =  Emo.removeArr[i];
				str += "<br />";
				break;
			}
			str += "<img title="+i+" src=" + Emo.url + i + ".gif />";
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
	if(windowHeight + scrollTop > documentHeight - 50 ){
		showDIV.insertAdjacentHTML("beforeend",Emo.getEmoStr(Emo.index, 200));
	};
};
</script>
</html>
```
