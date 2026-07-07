---
layout: post
title: "写了一个JS特效：打字效果（有彩蛋）"
date: "2011-07-28 11:13:55 +0800"
slug: "写了一个JS特效：打字效果（有彩蛋）"
category: "developer"
categories:
  - "developer"
tags:
  - "JS"
permalink: "/2011/07/28/写了一个JS特效：打字效果（有彩蛋）/"
---

 <div class="runcode"><textarea class="runcode_text" id="runcode_20110728__JS__1">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="UTF-8" /&gt;
&lt;title&gt;Typing...&lt;/title&gt;
&lt;style type="text/css"&gt;
*{padding:0;margin:0;}
body
{font-family:'MS Gothic';line-height: 1.8;font-size: 15px;color: #444;padding:10px;}
#avatar{position:relative;width:800px;word-wrap:break-word;margin:0 auto;}
b{font-weight:normal;display:none;}
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div id="avatar"&gt;
&lt;p&gt;我们都一样&lt;/p&gt;
&lt;p&gt;推开窗看见星星,依然守在夜空中。&lt;/p&gt;
&lt;p&gt;心中不免多了些,暖暖的感动。&lt;/p&gt;
&lt;p&gt;一闪一闪的光,努力把黑夜点亮，气氛如此安详。&lt;/p&gt;
&lt;p&gt;你在我的生命中,是那最闪亮的星。&lt;/p&gt;
&lt;p&gt;一直在无声夜空,守护着我们的梦。&lt;/p&gt;
&lt;p&gt;这世界那么大,我的爱只想要你懂。&lt;/p&gt;
&lt;p&gt;陪伴我孤寂旅程。&lt;/p&gt;
&lt;p&gt;你知道我的梦,你知道我的痛。&lt;/p&gt;
&lt;p&gt;你知道我们感受都相同。&lt;/p&gt;
&lt;p&gt;就算有再大的风,也挡不住勇敢的冲动。&lt;/p&gt;
&lt;p&gt;努力的往前飞,再累也无所谓。&lt;/p&gt;
&lt;p&gt;黑夜过后的光芒有多美。&lt;/p&gt;
&lt;p&gt;分享你我的力量,就能把对方的路照亮。&lt;/p&gt;
&lt;p&gt;我想我们都一样,渴望梦想的光芒。&lt;/p&gt;
&lt;p&gt;这一路喜悦彷徨,不要轻易说失望。&lt;/p&gt;
&lt;p&gt;回到最初时光,当时的你多么坚强。&lt;/p&gt;
&lt;p&gt;那鼓励让我难忘。&lt;/p&gt;
&lt;p&gt;你知道我的梦,你知道我的痛。&lt;/p&gt;
&lt;p&gt;你知道我们感受都相同。&lt;/p&gt;
&lt;p&gt;就算有再大的风,也挡不住勇敢的冲动。&lt;/p&gt;
&lt;p&gt;努力的往前飞,再累也无所谓。&lt;/p&gt;
&lt;p&gt;黑夜过后的光芒有多美。&lt;/p&gt;
&lt;p&gt;分享你我的力量,就能把对方的路照亮。&lt;/p&gt;
&lt;/div&gt;
&lt;span id="cursor"&gt;|&lt;/span&gt;
&lt;embed name="我们都一样" pluginspage="http://www.microsoft.com/Windows/MediaPlayer" src="http://www.cssass.com/blog/resource/bgsound/bgsound.mp3"
width="1" height="1" type="application/x-mplayer2" autostart="1"  loop="1" volume="50"&gt;&lt;/embed&gt;
&lt;script&gt;
var $id=function(o){return document.getElementById(o) || o};
var g=$id('avatar');
var cursor=$id("cursor");
var init=function ()
{
	var n=0, l=g.innerHTML, s='';
	while (n&lt;l.length)
	{
		var r=l.charAt(n);
		if (r==' ') { s+=r; n++}
		if (r=='&lt;') while (l.charAt(n-1)!='&gt;') s+=l.charAt(n++);
		s+='&lt;b&gt;'+l.charAt(n++)+'&lt;/b&gt;';
	}
	g.innerHTML=s;
};
var Wt={};
Wt.n = 0,
Wt.i = 0;
Wt.p = g.getElementsByTagName("p");
Wt.loop=function(){
	if( Wt.n &gt;= Wt.p.length ) {
		window.scrollTo(0,0);
		pos();
		anim();
		cursor.innerHTML='';
		g.onclick=anim;
		return false;
	};
	Wt.p[Wt.n].appendChild(cursor);
	var _loop=function(){
		var m = Wt.p[Wt.n].getElementsByTagName("b");
		if(Wt.i &lt; m.length ){
			setTimeout(function(){
				m[Wt.i].style.display='inline';
				Wt.i++;
				_loop();
			},300);
		}
		else{
			setTimeout(function(){
				Wt.i=0;
				Wt.n++;
				Wt.loop();
			},300);
		}
	};
	_loop();
};
var glint=setInterval(function(){
	cursor.style.display = (cursor.style.display=="none") ? "inline" : "none";
},500);
var xo=[], yo=[], xd=[], yd=[], e=[], an=-1, dir=-1 , t=0;
var d='6=.6&gt;&amp;5&amp;84OF4(@4*?3*J3-53*&gt;3-B3*13G%44&amp;5),6.D6377E%8.B;.0;3J?$+&gt;E&lt;B))B;@EG*F%-I0&gt;I6AM&amp;&gt;M,=Q),PJ;T:DT@5X1$X60[NO[T,_8B_=8b16b)3eC)e!?i,Gh3!l&gt;&lt;kD,o*Go!!r0)r%&gt;u54t92w=+v@=y+HxGF6H86248D+8-G6H/8G-7-889C8677&lt;&gt;8748E?8D79C1;0C86+:6&amp;;/0;&gt;$=)?&lt;#$=*#&lt;H%=*;=!(=*G:5(=++=!?=+7&lt;&lt;HA9;&lt;HD?3*=GDAF3&gt;C5A9#&gt;E$A9/A03A:!B!@A:8@1?B+AA/1BE&amp;B-)BO2A/OA83A/GA8BE&gt;/E0DB.FF.#CE%F-3E&gt;8F,OE&gt;EF,CF#&lt;F,7E?)F-?E?3F,+F0AHB-H*(F+GE@6J:GG.&gt;J;-I65J&lt;!J2#J&lt;-J2%J01J2/J&lt;9J=GJ=*J39J;@J2GJ;4J2;I65O.&lt;K0@LCBL9$O.BL.!O/;M,/NJ7N@@O#4NA#O0+NA/P,HO&amp;HO07O&amp;&lt;P!ANA&gt;Q,$Q.=S&gt;)RC=S=ES4,S&gt;6RDCS&gt;ARD)S?%S(HT!OT22S?1U/&amp;T=1V!*X%#T@&amp;X%/V!*X%;X5(X%HWCCX&amp;+WC8X&amp;7X(JX30WC,ZE4W8,ZE@WE$ZF$ZH%[P1[R0[P=[R&lt;[]3[RJ[]@[S/]%.[S:_,8[SF_ED]@4_,OaBD_-3^27_::a6&lt;`7@`9/a*?c$(`:#`6D`FFcH;`!&gt;c&lt;3e,Bc&lt;JdH:e7@e-:fB.e!4h$$fC(h1(i/)h1%i#!h/Hh2-h/&gt;h2;i:,mJ9jDCm%0kB$l@Ol39l(2n-@p*7o+Ar%#p)7r%,q3!u63s!&gt;t85z6)v@*sGCr$;pO0n.Ak62h=GdGGd:Oc$4a);_.1]@)[,!Z.AW6&amp;W)DT$&lt;RO3P.BO&gt;#MB8L8AK!HHO)H5JF;3E=:CC&amp;C)D@$F?@&amp;&lt;GG;J)9C#9)A6=.6&gt;&amp;5&amp;84OF4(@4*?3*J3-53*&gt;3-B3*13G%44&amp;5),6.D6377E%8.B;.0;3J?$+&gt;E&lt;B))B;@EG*F%-I0&gt;I6AM&amp;&gt;M,=Q),PJ;T:DT@5X1$X60[NO[T,_8B_=8b16b)3eC)e!?i,Gh3!l&gt;&lt;kD,o*Go!!r0)r%&gt;u54t92w=+v@=y+HxGF6=.6&gt;&amp;5&amp;84OF4(@4*?3*J3-53*&gt;3-B3*13G%44&amp;5),6.D6377E%8.B;.0;3J?$+&gt;E&lt;B))B;@EG*F%-I0&gt;I6AM&amp;&gt;M,=Q),PJ;T:DT@5X1$X60[NO[T,_8B_=8b16b)3eC)e!?i,Gh3!l&gt;&lt;kD,o*Go!!r0)r%&gt;u54t92w=+v@=y+HxGF';
function pos(){
	e=g.getElementsByTagName('b');
	for (n=0; n&lt;e.length; n++)
	{
		xo[n]=e[n].offsetLeft;
		yo[n]=e[n].offsetTop;
		var p=d.charCodeAt(n*3)*1600+d.charCodeAt(n*3+1)*40+d.charCodeAt(n*3+2)-78768;
		yd[n]=p%500;
		xd[n]=(p-yd[n])/500;
	}
	for (n=0; n&lt;e.length; n++)
	{
		e[n].style.position='absolute';
		e[n].style.left=xo[n]+'px';
		e[n].style.top=yo[n]+'px';
	}
};
function ani()
{	t=e.length;
	for (var n=0; n&lt;t; n++)
	{
		if ((an-n&lt;=30)&amp;&amp;(an-n&gt;=0))
		{
			var b=(Math.cos((((an-n)*Math.PI)/30))+1)/2;
			var a=1-b;
			e[n].style.left=((yd[n]+111)*a+xo[n]*b)+'px';
			e[n].style.top=((xd[n]+74)*a+yo[n]*b)+'px';
		}
	}
	an+=dir;
	if ((an-t&lt;=30)&amp;&amp;(an&gt;=0))
	{
		window.setTimeout("ani()", 20);
	}
};
function anim()
{
	dir*=-1;
	if ((an&lt;0)||(an-t&gt;30)) ani();
};
init();
Wt.loop();
&lt;/script&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20110728__JS__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20110728__JS__1')">Copy</button></div></div>
