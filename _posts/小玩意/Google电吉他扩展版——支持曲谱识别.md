---
layout: post
title: "Google电吉他扩展版——支持曲谱识别"
date: "2011-06-19 11:08:24 +0800"
slug: "Google电吉他扩展版——支持曲谱识别"
category: "developer"
categories:
  - "developer"
tags:
  - "google"
  - "JS"
permalink: "/2011/06/19/Google电吉他扩展版——支持曲谱识别/"
---

在6月9号Google 放出的纪念电吉他之父莱斯·保罗 96 周年诞辰的电吉他Doodle代码上，扩展了这个可播放曲谱的版本。
做这个扩展版的初衷是为了方便不是很熟悉键盘的童鞋。
童鞋们可以从网上复制曲谱进来自动播放（如果读者能自己谱曲，那真的就太棒了）。
曲谱中的空格及所有非法字符都表示停顿，间隔越大表示停顿越长，也可以调整曲子的整体节奏快慢。
同时可以开启自带的录音功能，录制之后会生产网址，可以拿来同朋友分享(由于国内网络环境的问题，网址生产可能会有限滞后)。
代码方面删除了不相干的部分，并做了格式整理，但由于原代码是经过压缩的，所以阅读起来还是会很费力的，很多地方处理的挺复杂，能力有限也不便做代码分析。
以下就是全部的代码（24k的code，1张图片，1个声音的flash文件）：

 <div class="runcode"><textarea class="runcode_text" id="runcode_20110619_Google__1">&lt;!doctype html&gt;
&lt;meta charset='utf-8' /&gt;
&lt;title&gt;google电吉他扩展版——可播放曲谱&lt;/title&gt;
&lt;style&gt;
#lga{width:500px;margin:0 auto;}
#hplogo:active,#hplogo:focus{outline:none}#hplogo-g{background:url(http://www.cssass.com/blog/resource/guitar/guitar11-hp-sprite.png) no-repeat 0 0;height:175px;position:relative;width:474px}#hplogo-click{background:url(http://www.cssass.com/blog/resource/guitar/guitar11-hp-sprite.png) no-repeat -2000px -2000px;cursor:pointer;height:130px;left:0;position:absolute;top:0;width:474px}#hplogo-lcd{height:30px;left:70px;position:absolute;top:129px;width:200px}#hplogo-lcd-icon{background:url(http://www.cssass.com/blog/resource/guitar/guitar11-hp-sprite.png) no-repeat -580px -162px;cursor:pointer;height:0;position:absolute;width:0}#hplogo-lcd-text{background:transparent;border:0 none;color:#666;cursor:text;font-family:"VT323",arial,sans-serif;font-size:14px;left:77px;position:absolute;top:134px;text-decoration:none;width:182px}#hplogo-lcd-screen{background:url(http://www.cssass.com/blog/resource/guitar/guitar11-hp-sprite.png) no-repeat -2000px -2000px;height:20px;left:52px;position:absolute;top:134px;width:214px}#hplogo-on{background:url(http://www.cssass.com/blog/resource/guitar/guitar11-hp-sprite.png) no-repeat -2000px -2000px;height:37px;left:272px;position:absolute;top:123px;width:62px}#hplogo-led{background:url(http://www.cssass.com/blog/resource/guitar/guitar11-hp-sprite.png) no-repeat -2000px -2000px;height:21px;left:292px;position:absolute;top:133px;width:21px}.hplogo-str{background:url(http://www.cssass.com/blog/resource/guitar/guitar11-hp-sprite.png) no-repeat -530px -60px;height:20px;position:absolute;width:255px}#hplogot{-webkit-box-shadow:5px 5px 10px #ddd;-moz-box-shadow:5px 5px 10px #ddd;box-shadow:5px 5px 10px #ddd;-webkit-transition:opacity 0.5s ease-out;-moz-transition:opacity 0.5s ease-out;-o-transition:opacity 0.5s ease-out;transition:opacity 0.5s ease-out;-webkit-user-select:none;-moz-user-select:none;user-select:none;background-color:#ffffca;border:1px solid #b5b5b5;cursor:pointer;display:none;font:normal 9pt arial,sans-serif;left:128px;opacity:0;padding:2px 3px;position:absolute;top:16px;white-space:nowrap}
.opern{width:480px;height:40px;}
&lt;/style&gt;
&lt;body onload="document.f.q.focus();" &gt;
&lt;div id=xjsc&gt;&lt;/div&gt;
&lt;div id=lga&gt;
&lt;div id=hplogo border=0&gt;
	&lt;div id=hplogo-g&gt;
		&lt;div id=hplogo-click &gt;&lt;/div&gt;
		&lt;div id=hplogo-lcd-screen&gt;&lt;/div&gt;
		&lt;div id=hplogo-lcd-icon&gt;&lt;/div&gt;
		&lt;input id=hplogo-lcd-text value="" autocomplete=off onclick="this.focus();this.select()" readonly=readonly&gt;
		&lt;div id=hplogo-on&gt;&lt;/div&gt;
		&lt;div id=hplogo-led&gt;&lt;/div&gt;
		&lt;div id=hplogot&gt;Les Paul&amp;#39;s 96th Birthday&lt;/div&gt;
	&lt;/div&gt;
&lt;/div&gt;
&lt;form name=f&gt; &lt;input class='opern' name=q value="3688368 77653 2226235 37753 3688368 00989 00989987 53566" /&gt;&lt;/form&gt;
&lt;button id='play'&gt;Play&lt;/button&gt;
节奏：
&lt;select id='speed'&gt;
	&lt;option value='5'&gt;Fast&lt;/option&gt;
	&lt;option value='7' selected&gt;Medium&lt;/option&gt;
	&lt;option value='9'&gt;Slow&lt;/option&gt;
&lt;/select&gt;
&lt;script&gt;
(function(){
var g=null,h;
if(!window.google)window.google={};
if(!google.doodle)google.doodle={};
google.rt=7;
var j,m,o,p,r,s,aa,t,u,ba,v,ca,da,ea=navigator.userAgent.indexOf("MSIE")&gt;=0,fa=[[3,"#776a62","#2063ff",2,[[28,23],[103,23]]],[5,"#776a62","#f61b33",2,[[28,38],[103,38]]],[0,"#776a62","#ffdd24",2,[[65,67],[318,67]]],[2,"#776a62","#07d238",2,[[28,81],[281,81]]],[7,"#776a62","#2063ff",1,[[28,96.5],[281,96.5]]],[9,"#776a62","#f61b33",1,[[29,111.5],[104,111.5]]],[1,"#776a62","#07d238",2,[[358,66],[433,66]]],[4,"#776a62","#2063ff",2,[[358,81],[433,81]]],[6,"#776a62","#f61b33",2,[[330,96],[405,96]]],[8,"#776a62","#ffdd24",1,[[358,111.5],[434,111.5]]]],ga=0,ha=0,w=0,x=0,y=!0,z=[],A=g,B=g,
C=function(a){a&amp;&amp;a.parentNode&amp;&amp;a.parentNode.removeChild(a)},
D=function(a,b,c){if(a){if(!google.doodle.ka)google.doodle.ka=[];google.doodle.ka.push(arguments);
var d=a,e=b,f=c;
d.addEventListener?d.addEventListener(e,f,!1):d.attachEvent("on"+e,f)}},
ia=function(a,b,c){a&amp;&amp;(a.removeEventListener?a.removeEventListener(b,c,!1):a.detachEvent("on"+b,c))},
ja=function(){if(google.doodle.ka)for(var a;a=google.doodle.ka.pop();)ia.apply(g,a)},
E=function(a){a?a.stopPropagation&amp;&amp;a.stopPropagation():window.event.cancelBubble=!0;return!1},
F=function(a){if(j!==a){var b=j;j=a;for(a=0;a&lt;z.length;++a)z[a](b)}},
G=0;z.push(function(){var a=document.getElementById("hplogo-on");if(a)j==1?(a.style.backgroundPosition="-476px -139px",G=0):j==2?G=1:(a.style.backgroundPosition="-2000px -2000px",G=0)});
var ka=function(a){j==0||j==5||j==4?F(1):F(4);return E(a)},
H=g,
ma=function(a){
	C(document.getElementById("goo-gl-script"));
	H&amp;&amp;window.clearTimeout(H);
	var b="http://google-lespaul.appspot.com?callback=google.doodle.url&amp;url="+encodeURIComponent(a),c=document.createElement("script");
	c.src=b;
	c.id="goo-gl-script";
	H=window.setTimeout(function(){la(a)},2E3);
	(document.getElementById("xjsc")||document.body).appendChild(c)
},
na=function(a){a&amp;&amp;a.status=="OK"&amp;&amp;!a.error&amp;&amp;a.id&amp;&amp;la(a.id)},
la=function(a){
	if(j==0||j==4){window.clearTimeout(H);var b=document.getElementById("hplogo-lcd-text");if(b)b.value=a,b.select()}
},
I=[[0,0,0,0,0,0],[-540,-162,9,9,59,139],[-551,-162,9,6,62,139],[-559,-162,11,17,55,138]],
J=function(a){
	var b=document.getElementById("hplogo-lcd-screen");
	if(b)b.style.backgroundPosition="-678px -139px";
	if(b=document.getElementById("hplogo-lcd-icon"))
	b.style.backgroundPosition=I[a][0]+"px "+I[a][1]+"px",b.style.height=I[a][2]+"px",b.style.width=I[a][3]+"px",b.style.left=I[a][4]+"px",b.style.top=I[a][5]+"px"
};
z.push(function(a){
	var b=document.getElementById("hplogo-lcd-text");
	if(j==5){if(J(1),b.value=="")b.value="Playing..."}
	else if(A&amp;&amp;(j==0||j==4)){if(J(2),K(),b.value=="Playing...")b.value=""}
	else if(j==1)J(3),b.value="Recording";
	if(j!=2&amp;&amp;(a==1||a==2)&amp;&amp;A)A.stop(),K(),J(A.u.length==0?0:2),b.value="",B=g,(a=A.eb())&amp;&amp;ma(a)
});
var oa=function(a){A&amp;&amp;(j==0||j==4)?(F(5),A.play()):j==5&amp;&amp;F(4);return E(a)};
z.push(function(){j==1&amp;&amp;(A=new L,B=A.ib())});
var pa=!1,qa={el:1,iw:1,ja:1,kk:1,ky:1,ko:1,lt:1,lv:1,mk:1,mr:1,ru:1,th:1,ur:1,"zh-CN":1,"zh-TW":1},
ra=function(){
//	if(!pa&amp;&amp;!qa[google.kHL]){
//		pa=!0;window.WebFontConfig={google:{families:["VT323"]}};
//		var a=document.createElement("script");
//		a.src=("https:"==document.location.protocol?"https":"http")+"://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js";
//		a.type="text/javascript";a.async="true";(document.getElementById("xjsc")||document.body).appendChild(a)
//	}
},
sa=!1,N=g,
ua=function(){O();N=window.setTimeout(function(){ta(!0)},1E3)},
O=function(){N&amp;&amp;window.clearTimeout(N);N=g;ta(!1)},
ta=function(a){var b=document.getElementById("hplogot");if(b)sa?(b.style.display="block",b.style.opacity=a?1:0):b.style.display=a?"block":"none"},
za=function(){
	D(document,"keydown",va);
	D(document,"mousemove",P);
	D(document,"touchmove",P);
	D(document,"touchstart",wa);
	D(window,"resize",xa);
	D(document.getElementById("play"),"click",playA);
	var a=document.forms.f||document.forms.gs||document.forms.lb;
	a&amp;&amp;(D(a.q,"blur",function(){m=!1}),D(a.q,"focus",function(){m=!0;j!=5&amp;&amp;F(0)}));
	D(document.body,"mouseout",ya);
	if(a=document.getElementById("hplogo-on"))a.onclick=ka,a.style.cursor="pointer";
	if(a=document.getElementById("hplogo-led"))a.onclick=ka,a.style.cursor="pointer";
	if(a=document.getElementById("hplogo-lcd-icon"))a.onclick=oa;
	if((a=document.getElementById("hplogo-click"))&amp;&amp;!ea)a.onmousemove=ua,a.onmouseout=O;
	if(a=document.getElementById("speed"))a.onchange=function(){google.rt=this.value};
},
wa=function(a){var b=Aa(a);b[0]&gt;=w&amp;&amp;b[0]&lt;=w+474&amp;&amp;b[1]&gt;=x&amp;&amp;b[1]&lt;=x+175&amp;&amp;a.preventDefault()},
Aa=function(a){
	a=a||window.event;
	return[(a.clientX||a.targetTouches&amp;&amp;a.targetTouches[0].clientX||0)+(document.body.scrollLeft||document.documentElement.scrollLeft),
	(a.clientY||a.targetTouches&amp;&amp;a.targetTouches[0].clientY||0)+(document.body.scrollTop||document.documentElement.scrollTop)]
},
P=function(a){a=a||window.event;a=Aa(a);ga=a[0];ha=a[1]},
//Ba={49:2,50:6,51:3,52:0,53:7,54:1,55:8,56:4,57:9,48:5,81:2,87:6,69:3,82:0,84:7,89:1,85:8,73:4,79:9,80:5,65:2,83:6,68:3,70:0,71:7,72:1,74:8,75:4,76:9,186:5,90:2,88:6,67:3,86:0,66:7,78:1,77:8,188:4,190:9,191:5},
Ba={49:2,50:6,51:3,52:0,53:7,54:1,55:8,56:4,57:9,48:5,
	81:2,87:6,69:3,82:0,84:7,89:1,85:8,73:4,79:9,80:5,
	65:2,83:6,68:3,70:0,71:7,72:1,74:8,75:4,76:9,186:5,
	90:2,88:6,67:3,86:0,66:7,78:1,77:8,188:4,190:9,191:5,
	'1':2,'2':6,'3':3,'4':0,'5':7,'6':1,'7':8,'8':4,'9':9,'0':5,
	'q':2,'w':6,'e':3,'r':0,'t':7,'y':1,'u':8,'i':4,'o':9,'p':5,
	'a':2,'s':6,'d':3,'f':0,'g':7,'h':1,'j':8,'k':4,'l':9,';':5,
	'z':2,'x':6,'c':3,'v':0,'b':7,'n':1,'m':8,',':4,'.':9,'/':5,
	'#':'#'},
va=function(a){var b=a||window.event;return o&amp;&amp;!m&amp;&amp;!b.altKey&amp;&amp;!b.ctrlKey&amp;&amp;!b.metaKey&amp;&amp;(b=Ba[b.keyCode],typeof b=="number")?(j==0&amp;&amp;F(4),o.V(b),E(a)):!0},
playA=function(){
	var b=document.f.q.value.toLowerCase();
	var c=b.replace(/[^0-9a-zA-Z,.;/]/g,'#');
	var d=new L;
	for(var i=0,c=c.split(""); i&lt;c.length; i++){
		b=Ba[c[i]].toString();
		d.Za(new Y(b,google.rt));
	}
	d.stop();
	google.d=5,d.play();
},
xa=function(){
	y&amp;&amp;p!=g&amp;&amp;(y=!1,window.setTimeout(function(){y=!0;var a=p,b=0;do b+=a.offsetLeft;while(a=a.offsetParent);w=b;a=p;b=0;do b+=a.offsetTop;while(a=a.offsetParent);x=b},30))
},
ya=function(a){
	(a=a||window.event)&amp;&amp;!a.toElement&amp;&amp;P(a)
},
Ca=function(a,b){
	this.i=a;this.Y=b;this.width=474;this.height=175;this.J=[];this.Ja=this.U=!1;this.ha=0;this.ta=this.T();this.ua=this.ia();this.qa=new Q(0,0);this.ra=new Q(0,0);this.Ia=!0;this.La=(new Date).getTime();this.Xa();this.Ka()
};
h=Ca.prototype;
h.Xa=function(){for(var a=0,b;b=fa[a++];)this.J.push(new Da(b[4][0][0],b[4][0][1],b[4][1][0],b[4][1][1],b[3],b[1],b[2],a,b[0],this.i,this.Y,this))};
h.T=function(){return ga-w};
h.ia=function(){return ha-x};
h.Ha=function(a){return R(a,this.width)/this.width};
h.kb=function(){this.bb();this.Ja&amp;&amp;this.ab();this.U&amp;&amp;(this.i&amp;&amp;this.i.clearRect(0,0,this.width,this.height),this.Ka())};
h.Ka=function(){for(var a=0,b;b=this.J[a++];)b.hb(),b.gb()};
h.ya=function(){if(this.J)for(var a=0,b;b=this.J[a++];)b.ya()};
h.Va=function(){for(var a=0,b;b=this.J[a++];)if(b.L||b.O){this.U=!0;return}this.U=!1};
h.bb=function(){
	var a=(new Date).getTime(),b=(a-this.La)/1E3;
	this.La=a;
	var a=this.T(),c=this.ia();
	this.qa.x=this.ta;this.qa.y=this.ua;this.ra.x=a;this.ra.y=c;var d=a-this.ta,e=c-this.ua,d=Math.sqrt(d*d+e*e);this.Ja=d&gt;0;this.ha=(this.ha*4+R(((b&gt;0?d/b:0)-70)/1430,1))/5;this.ta=a;this.ua=c
};
h.ab=function(){
	if(this.Ia)this.Ia=!1;
	else for(var a=0,b;b=this.J[a++];)
	{
		var c;c=this.qa;
		var d=this.ra,e=b.Ra,f=b.Qa,i=d.y-c.y,n=f.y-e.y,k=c.x-d.x,l=e.x-f.x,q=d.x*c.y-c.x*d.y,M=f.x*e.y-e.x*f.y,X=i*l-n*k;
		X==0?c=g:(k=(k*M-l*q)/X,i=(n*q-i*M)/X,c=Math.pow(k-d.x,2)+Math.pow(i-d.y,2)&gt;Math.pow(c.x-d.x,2)+Math.pow(c.y-d.y,2)||Math.pow(k-c.x,2)+Math.pow(i-c.y,2)&gt;Math.pow(c.x-d.x,2)+Math.pow(c.y-d.y,2)||Math.pow(k-f.x,2)+Math.pow(i-f.y,2)&gt;Math.pow(e.x-f.x,2)+Math.pow(e.y-f.y,2)||Math.pow(k-e.x,2)+Math.pow(i-e.y,2)&gt;Math.pow(e.x-f.x,2)+Math.pow(e.y-f.y,2)?g:new Q(k,i));
		c&amp;&amp;!b.L&amp;&amp;(this.ha&lt;0.4?b.Ya(c.x,c.y):b.Ma(c.x,c.y,!1))
	}
};
h.V=function(a){a&gt;=0&amp;&amp;a&lt;12&amp;&amp;this.J[a].V()};
var R=function(a,b){return a&lt;0?0:a&gt;b?b:a},
Ea=function(a){for(var b=[],a=a.match(/[0-9a-f]{2}/gi),c=0,d;d=a[c++];)b.push(parseInt(d,16));return b},
Q=function(a,b){this.x=a;this.y=b},
Da=function(a,b,c,d,e,f,i,n,k,l,q,M){
	this.z=a;this.A=b;this.ea=c;this.fa=d;this.Ra=new Q(this.z,this.A);this.Qa=new Q(this.ea,this.fa);this.R=this.ea-this.z;this.S=this.fa-this.A;
	this.length=Math.sqrt(this.R*this.R+this.S*this.S);
	this.P=this.z+this.R*0.5;this.Q=this.A+this.S*0.5;this.W=this.P;this.X=this.Q;this.Aa=this.za=this.I=this.H=0;this.ga=k;this.Da=this.ga/11;this.Ca=this.M=this.F=this.la=0;this.ca=Math.atan2(this.S,this.R);this.ba=Math.sin(this.ca);this.ma=Math.cos(this.ca);a=Math.PI/2-this.ca;this.Pa=Math.sin(a);this.Oa=Math.cos(a);this.index=n;this.lineWidth=e;this.na=f;this.Ba=i;this.aa=this.na;this.color=this.w;this.w=Ea(this.na);this.da=Ea(this.Ba);this.B=this.k=0;this.Z=this.O=this.L=!1;this.oa=1;this.i=l;this.Y=q;this.v=M;this.o=(e=this.length&gt;100)?7.5:5;this.Sa=0.88+(0.85-0.88)*this.Da;this.Ta=1.4+1.5*this.Da;this.$=0;
	if(!this.i)this.G=document.createElement("div"),this.G.className="hplogo-str",this.G.style.left=this.z+1+"px",this.G.style.top=this.A-10+"px",this.G.style.width=this.length,this.Ua=e?-475:-730,this.Y.appendChild(this.G)
};
h=Da.prototype;h.ya=function(){if(this.G)this.Y.removeChild(this.G),this.G=g};
h.gb=function(){
	var a,b;(this.L||this.Z)&amp;&amp;this.H&amp;&amp;this.I?(a=this.H,b=this.I):(a=this.W,b=this.X);
	var c=a-this.z,d=b-this.A,e=this.ea-a,f=this.fa-b;
	this.i?(this.i.beginPath(),this.i.lineCap="round",this.i.strokeStyle=this.aa,this.i.lineWidth=this.lineWidth,this.i.shadowOffsetX=2,this.i.shadowOffsetY=3,this.i.shadowBlur=2,this.i.shadowColor="rgba(0, 0, 0, 0.35)",c=Math.sqrt(c*c+d*d),f=Math.sqrt(e*e+f*f),e=0.45*c*this.ma,c=0.45*c*this.ba,d=0.45*f*this.ma,f=0.45*f*this.ba,this.i.moveTo(this.z,this.A),this.i.bezierCurveTo(a-e,b-c,a+d,b+f,this.ea,this.fa),this.i.stroke(),this.i.closePath()):this.G.style.backgroundPosition=this.Ua+"px "+-(3+Math.round(d/2))*20+"px"
};
h.hb=function(){this.L?this.Na():this.O&amp;&amp;this.db()};
h.db=function(){
	if(this.Z){
		this.aa=this.Ba;
		var a=this.za-this.H,b=this.Aa-this.I;
		this.H+=a*0.8;this.I+=b*0.8;
		if(Math.abs(a)&lt;2&amp;&amp;Math.abs(b)&lt;2)this.$=0,this.oa=1,this.Z=!1,(a&gt;=0?1:-1)!=(this.ba&gt;=0?1:-1)&amp;&amp;(this.oa*=-1)
	}else if(this.color=[this.w[0]+(this.da[0]-this.w[0])*(this.k&gt;this.o*0.25?1:this.k/(this.o*0.25)),this.w[1]+(this.da[1]-this.w[1])*(this.k&gt;this.o*0.25?1:this.k/(this.o*0.25)),this.w[2]+(this.da[2]-this.w[2])*(this.k&gt;this.o*0.25?1:this.k/(this.o*0.25)),this.w[3]+(this.da[3]-this.w[3])*(this.k&gt;this.o*0.25?1:this.k/(this.o*0.25))],this.aa="rgb("+Math.round(this.color[0])+","+Math.round(this.color[1])+","+Math.round(this.color[2])+")",this.$+=this.Ta*this.oa,a=Math.sin(this.$),this.k*=this.Sa,this.W=this.P+a*this.ba*this.k,this.X=this.Q-a*this.ma*this.k,this.k&lt;=0.15)
	this.k=0,this.O=!1,this.color=this.w,this.aa=this.na,this.v.Va()
};
h.Na=function(){
	var a=this.v.T(),b=this.v.ia(),c=a-this.z,d=b-this.A,e=this.ca-Math.atan2(d,c),c=Math.sqrt(c*c+d*d);
	this.F=c*Math.sin(e);this.Ea(R(c*Math.cos(e)/this.length,1));this.B=R(Math.abs(this.F)/this.o,1);Math.abs(this.F)&gt;this.la?this.Wa():(this.H=a,this.I=b)
};
h.Ea=function(a){this.M=a;this.Ca=this.M&lt;=0.5?this.M/0.5:1-(this.M-0.5)/0.5;this.la=this.o*this.Ca};
h.Ma=function(a,b,c){
	this.H=a;this.I=b;
	var b=this.v.T()-this.z,d=this.v.ia()-this.A;this.Ea(R(Math.sqrt(b*b+d*d)/this.length,1));
	this.F=(1-(c?1:this.v.ha))*this.la;this.B=c?1:R(Math.abs(this.F)/this.o,1);if(this.F&lt;3)this.F=3;
	this.H+=this.F*this.Oa;
	this.I+=this.F*this.Pa;
	this.W=this.P;this.X=this.Q;
	this.O?(this.B=R(this.B/2+this.k/this.o,1),this.k=this.B*this.o):(this.k=this.B*this.o,this.Ga());
	this.Fa(this.B,this.v.Ha(a))
};
h.V=function(){this.Ma(this.P,this.Q,!0)};
h.Ya=function(a,b){this.L=!0;this.v.U=!0;this.H=a;this.I=b;this.Na()};
h.Wa=function(){this.L=!1;this.W=this.P;this.X=this.Q;this.k=this.B*this.o;this.Fa(this.B,this.v.Ha(this.v.T()));this.Ga()};
h.Ga=function(){this.v.U=!0;this.za=this.z+this.M*this.R;this.Aa=this.A+this.M*this.S;this.$=0;this.Z=this.O=!0};
h.Fa=function(a,b){
	if(r)try{s.playTrack("guitar-"+(this.ga&lt;10?"0":"")+this.ga,this.ga,0.4+(0.6-0.4)*a,-0.8+1.6*b)}catch(c){r=!1}B&amp;&amp;B([this.index-1])
};
var Fa=function(){if(r)for(var a=0;a&lt;12;a++)if(r)try{s.stopChannel(a)}catch(b){r=!1}},
Ha=function(){u&amp;&amp;(Ga("guitar11-sound-player")||Ga("guitar11-sound-player-2"))},
Ga=function(a){return(a=u.getElementById(a))&amp;&amp;a.playTrack?(s=a,r=!0,Ia(),!0):!1},
S=function(a,b){if(a&lt;b)return-1;else if(a&gt;b)return 1;return 0},
T=function(a){a=a.match(/[\d]+/g);a.length=3;return a.join(".")},
Ja=function(){
	var a=!1,b="";
	if(navigator.plugins&amp;&amp;navigator.plugins.length){var c=navigator.plugins["Shockwave Flash"];c&amp;&amp;(a=!0,c.description&amp;&amp;(b=T(c.description)));navigator.plugins["Shockwave Flash 2.0"]&amp;&amp;(a=!0,b="2.0.0.11")} else if(navigator.mimeTypes&amp;&amp;navigator.mimeTypes.length)(a=(c=navigator.mimeTypes["application/x-shockwave-flash"])&amp;&amp;c.enabledPlugin)&amp;&amp;(b=T(c.enabledPlugin.description));else try{c=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7"),a=!0,b=T(c.GetVariable("$version"))}catch(d){try{c=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6"),a=!0,b="6.0.21"}catch(e){try{c=new ActiveXObject("ShockwaveFlash.ShockwaveFlash"),a=!0,b=T(c.GetVariable("$version"))}catch(f){}}}aa=a;ba=b
},
Ka=function(){
	for(var a=0,b=String(ba).replace(/^[\s\xa0]+|[\s\xa0]+$/g,"").split("."),c=String("9.0.0.0").replace(/^[\s\xa0]+|[\s\xa0]+$/g,"").split("."),d=Math.max(b.length,c.length),e=0;a==0&amp;&amp;e&lt;d;e++)
	{
		var f=b[e]||"",i=c[e]||"",n=RegExp("(\\d*)(\\D*)","g"),k=RegExp("(\\d*)(\\D*)","g");
		do{
			var l=n.exec(f)||["","",""],q=k.exec(i)||["","",""];
			if(l[0].length==0&amp;&amp;q[0].length==0)break;
			a=S(l[1].length==0?0:parseInt(l[1],10),q[1].length==0?0:parseInt(q[1],10))||S(l[2].length==0,q[2].length==0)||S(l[2],q[2])
		}
		while(a==0)}return a&gt;=0},
U,La={c:2,d:6,e:3,f:0,g:7,a:1,b:8,C:4,D:9,E:5,1:2,2:6,3:3,4:0,5:7,6:1,7:8,8:4,9:9,0:5},
Ma=function(a,b){
	if(!(typeof a!="number"||typeof b!="string")){
		U!==void 0&amp;&amp;window.clearInterval(U);var c=Math.floor(6E4/a);if(!(c&lt;30)&amp;&amp;!(6E4*(b.replace("[","").replace("]","").length/a)&gt;28E3)){
			var d=0;F(5);
			U=window.setInterval(function(){d&gt;=b.length&amp;&amp;j==5&amp;&amp;F(4);if(j!=5)window.clearInterval(U);else{var a=b.charAt(d++);
			if(a!="-"){
				var c=[];if(a=="["){for(;d&lt;b.length&amp;&amp;b.charAt(d)!="]";)c.push(b.charAt(d++));d++}else c.push(a);for(var a=0,i;i=c[a++];)La.hasOwnProperty(i)&amp;&amp;o.V(La[i])}
			}},c)
		}
	}
},
V=g,W=g,
Na=function(){
	if(!V){V={};W={};
	for(var a=0;a&lt;65;a++)V[a]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_*".charAt(a),W[V[a]]=a;}
},
Y=function(a,b){this.N=a;this.duration=Math.max(b,0);var c=0;c+=this.N.length==1?5:11;c+=this.duration&lt;Math.pow(2,5)?6:21;this.size=c};
//Y.prototype.play=function(){for(var a=0;a&lt;this.N.length;++a)o.V(this.N[a])};
Y.prototype.play=function(){o.V(this.N)};
var Z=function(a,b){for(var c=[],d=0;d&lt;b;++d)c.push(!!(a&amp;1)),a&gt;&gt;=1;return c},
Oa=function(a,b,c){if(b+c&gt;a.length)return-1;for(var d=0,e=0;e&lt;c;++e)d*=2,d|=a[b+c-e-1]?1:0;return d},
Pa=function(a){for(var b=[],c=0;c&lt;10;++c)b.push(!1);for(c=0;c&lt;a.length;++c)b[a[c]]=!0;return b};
Y.prototype.xa=function(){
	var a=[];
	this.N.length==1?(a.push(!1),a=a.concat(Z(this.N[0],4))):(a.push(!0),a=a.concat(Pa(this.N)));
	this.duration&lt;Math.pow(2,5)?(a.push(!1),a=a.concat(Z(this.duration,5))):(a.push(!0),a=a.concat(Z(this.duration,20)));
	return a
};
var Qa=function(a,b){
	var c,d,e=b;if(b&lt;0||b&gt;=a.length)return g;
	if(a[b]){c=b+1;if(c+10&gt;a.length)d=g;else{d=[];for(var f=0;f&lt;10;++f)a[c+f]&amp;&amp;d.push(f)}if(!d)return g;b+=11}
	else{c=Oa(a,b+1,4);if(c==-1)return g;d=[c];b+=5}
	if(b&gt;=a.length)return g;a[b]?(c=Oa(a,b+1,20),b+=21):(c=Oa(a,b+1,5),b+=6);
	return c&lt;0?g:{s:new Y(d,c),n:b-e}
},
L=function(a){this.u=a||[];this.va=g;for(var b=this.duration=a=0;b&lt;this.u.length;++b)a+=this.u[b].size,b!=0&amp;&amp;(this.duration+=this.u[b].duration*50);this.size=a};
L.prototype.Za=function(a){this.u.push(a);this.size+=a.size;this.u.size&gt;1&amp;&amp;(this.duration+=a.duration*50)};
L.prototype.$a=function(){return(this.size+4)*1.37/8};
var Ra=g,
Sa=function(){j==1&amp;&amp;F(2)},Ta=g,
Ua=function(){(j==1||j==2)&amp;&amp;F(4)};
L.prototype.ib=function(){this.wa=0;this.K=[];this.cb=!0;var a=this;this.va=window.setTimeout(function(){a.tick(!0)},50);return function(b){a.K.push(b)}};
L.prototype.tick=function(a){
	this.wa++;
	if(this.K&amp;&amp;this.K.length&gt;0){
		var b=this.wa;this.wa=0;var c;
		if(this.K.length==1)c=this.K[0];else{for(var d=[],e=0;c=this.K[e++];)
		for(var f=0;f&lt;c.length;++f)d[c[f]]=1;c=[];
		for(e=0;e&lt;d.length;++e)d[e]&amp;&amp;c.push(e)}this.K=[];
		this.Za(new Y(c,b));
		this.u.length==1&amp;&amp;(window.clearTimeout(Ta),Ta=window.setTimeout(Ua,28E3),window.clearTimeout(Ra),Ra=window.setTimeout(Sa,23E3));
		b=this.$a();
		if(b&gt;=1900||this.duration&gt;=28E3){F(4);return}else b&gt;=1800&amp;&amp;F(2)
	}
	if(a){var i=this;this.va=window.setTimeout(function(){i.tick(!0)},50)}
};
L.prototype.stop=function(){
	window.clearTimeout(this.va);this.tick(!1);
	if(this.u.length&gt;0)this.u[0].duration=0;this.cb=!1;
	clearTimeout(google.clearp);
};
L.prototype.play=function(a){
	if(google.d || j==5)if(this.duration&gt;28E3)j==5&amp;&amp;F(4);
	else{
		var b=a||0;b&gt;0&amp;&amp;this.u[b-1].play();
		if(b&gt;=this.u.length)j==5&amp;&amp;F(4);
		else{var c=this;google.clearp=window.setTimeout(function(){c.play(b+1)},this.u[b].duration*50)}
	}
};
eval("google.doodle.mod = (function(a,n){return a"+"%%".charAt(0)+"n;})");
L.prototype.xa=function(){
	for(var a=[],b=0;b&lt;this.u.length;++b)a=a.concat(this.u[b].xa());
	for(window.bits=a;google.doodle.mod(a.length,8)!=0;)a.push(!1);
	return a
};
L.prototype.eb=function(){
	if(this.u.length==0)return g;
	var a="http://www.google.com/webhp?",b=Va(window.location.toString()).hl;b&amp;&amp;(a+="hl="+b+"&amp;");
	a+="tune=";
	for(var c=this.xa(),b=[],d=0;d&lt;c.length;d+=8){
		for(var e=0,f=0;f&lt;8;++f)e*=2,e|=c[d+f]?1:0;b.push(e)
	}
	Na();c=V;d=[];
	for(e=0;e&lt;b.length;e+=3){
		var i=b[e],n=(f=e+1&lt;b.length)?b[e+1]:0,k=e+2&lt;b.length,l=k?b[e+2]:0,q=i&gt;&gt;2,i=(i&amp;3)*16|n&gt;&gt;4,n=(n&amp;15)*4|l&gt;&gt;6;l&amp;=63;k||(l=64,f||(n=64));d.push(c[q],c[i],c[n],c[l])
	}return a+d.join("")
};
var Va=function(a){
	if(!a)return{};
	for(var a=a.match(/\?[^#]*/),a=(a&amp;&amp;a.length&gt;0?a[0].substr(1):"").split("&amp;"),b={},c=0;c&lt;a.length;++c){var d=a[c];d&amp;&amp;(d=d.split("="),b[d[0]]=d[1]||"")}
	return b
},
Ia=function(){
	var a=Va(window.location.href),b=parseInt(a.bpm,10),a=a.tune;b&amp;&amp;a&amp;&amp;Ma(b,unescape(a));
	if(a){
		Na();for(var c=W,b=[],d=0;d&lt;a.length;){var e=c[a.charAt(d++)],f=d&lt;a.length?c[a.charAt(d)]:0;++d;var i=d&lt;a.length?c[a.charAt(d)]:0;++d;var n=d&lt;a.length?c[a.charAt(d)]:0;++d;if(e==g||f==g||i==g||n==g)throw Error();b.push(e*4|f&gt;&gt;4);i!=64&amp;&amp;(b.push(f*16&amp;240|i&gt;&gt;2),n!=64&amp;&amp;b.push(i*64&amp;192|n))}a=[];
		for(c=0;c&lt;b.length;++c){d=b[c];for(e=0;e&lt;8;++e)a.push(!!(d&amp;128)),d*=2}
		if(a){var k;a:{b=[];c=0;try{for(;a.length-c&gt;=8;){var l=Qa(a,c);if(l)b.push(l.s),c+=l.n;else{k=g;break a}}}catch(q){k=g;break a}k=new L(b)}k&amp;&amp;(A=k,F(5),k.play())}
	}
},
Wa=!0,
Xa=function(){
	if(google.rein&amp;&amp;google.dstr&amp;&amp;!google.doodle.jb)google.doodle.jb=!0,google.rein.push(Xa),google.dstr.push($);
	if(document.getElementById("hplogo")){
		$();google.psy&amp;&amp;google.psy.q&amp;&amp;google.msg&amp;&amp;google.msg.listen(22,function(){$();return!0});google.doodle.url=na;p=document.getElementById("hplogo-g");
		v=document.createElement("canvas");
		v.getContext?(v.width=474,v.height=175,v.hideFocus=!0,ca=v.getContext("2d"),p.appendChild(v)):v=g;xa();o=new Ca(ca,p);
		var a;r=!1;Ja();
		if(!aa||!Ka())a=!1;else{
			google.doodle.flashLoaded=Ha;t=document.createElement("iframe");t.name="doodle-sound";t.style.position="absolute";t.style.top="-150px";t.style.border=0;t.style.width="100px";t.style.height="100px";document.getElementById("hplogo").appendChild(t);u=t.contentDocument;if(u==void 0||u==g)u=t.contentWindow.document;u.open();u.write("&lt;html&gt;&lt;head&gt;&lt;/head&gt;&lt;body&gt;&lt;object classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0\" width=\"0\" height=\"0\" id=\"guitar11-sound-player\" type=\"application/x-shockwave-flash\"&gt;&lt;param name=\"movie\" value=\"http://www.cssass.com/blog/resource/guitar/guitar11.swf\"&gt;&lt;param name=\"allowScriptAccess\" value=\"always\"&gt;&lt;object id=\"guitar11-sound-player-2\" type=\"application/x-shockwave-flash\" data=\"http://www.cssass.com/blog/resource/guitar/guitar11.swf\" width=\"0\" height=\"0\"&gt;&lt;param name=\"allowScriptAccess\" value=\"always\"&gt;&lt;/object&gt;&lt;/object&gt;&lt;/body&gt;&lt;/html&gt;");u.close();a=!0
		}
		var b=document.getElementById("hplogot");
		b&amp;&amp;(sa=typeof b.style.opacity!="undefined");za();m=!0;Ya();!a&amp;&amp;Wa&amp;&amp;Ia();Wa=!1;ra();
		if(ea)try{document.execCommand("BackgroundImageCache",!1,!0)}catch(c){}
	}},
Ya=function(){
	o&amp;&amp;(o.kb(),da=window.setTimeout(Ya,30));
	var a=document.getElementById("hplogo-led");
	if(a&amp;&amp;G)a.style.backgroundPosition=-540-23*Math.abs(Math.round(5*Math.sin(G*Math.PI/12)))+"px -139px",G++
},
K=function(){
	var a=document.getElementById("hplogo-led");if(a)a.style.backgroundPosition="1000px 1000px"},
$=function(){
	try{window.clearTimeout(da);O();Fa();ja();o&amp;&amp;(o.ya(),o=g);t&amp;&amp;(C(t),t=g,r=!1);v&amp;&amp;(C(v),v=g);A&amp;&amp;A.stop();B=A=g;F(0);var a=document.getElementById("hplogo-lcd-text");if(a)a.value="";var b=document.getElementById("hplogo-lcd-screen");if(b)b.style.backgroundPosition="1000px 1000px";K();google.msg&amp;&amp;window.setTimeout(function(){google.msg.unlisten(22,$)},0)}catch(c){}
};
Xa()
})();
&lt;/script&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20110619_Google__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20110619_Google__1')">Copy</button></div></div>

可以运行以上代码，也可以访问这个链接：http://www.cssass.com/blog/resource/guitar/

最后罗列一些网上收集的曲谱：
欢乐颂：

uuiooiuyttyuuyy uuiooiuyttyuytt yyutyuiutyuiuytyw uuiooiuyttyuytt

爱情买卖：

3688368 77653 2226235 37753 3688368 00989 00989987 53566

茉莉花：

eetyiiyttyt eetyiiyttyt tttetyyt ewetewqqwq ewqwetyit ewetewqqwq

义勇军进行曲：

qr rrrqwer r yrtyi i yyryiytt o i t y iy iytyr y qwrryyiittw t qr ry yi rtiio i yriiiy r q r yriiiy r q r q r q r r

沧海一声笑:

pouyt uytew wewetyuopppou

童年：

35553 6676 66588886865 355536676 66658888668 9~

上海滩：

356666，352222，356865132

一闪一闪亮晶晶

1155665 4433221 5544332 5544332 1155665 4433221；

天空之城

6787807 365685 254573 874477 6787807 365685 34878908 876756 1232352
5878007 678789855 43213 376321 21253 376321 21276

春江花月夜

H-HHK-LHG～G-G-H-KLD～D-SDG-DGH～KL-;-K-L;LKH-G～

隐形的翅膀

358787 6568321 11186532122 358787 6568321 1118653211

可以复制曲谱到文本框中直接播放。欢迎读者提供更精彩的乐谱。
