---
layout: post
title: "Date对象初始化Month，Day参数的奇葩设定的解释"
date: "2014-08-16 13:11:07 +0800"
slug: "Date对象初始化Month，Day参数的奇葩设定的解释"
category: "developer"
categories:
  - "developer"
tags:
  - "JS"
permalink: "/2014/08/16/Date对象初始化Month，Day参数的奇葩设定的解释/"
---

new一个Date对象时，当以年份Y，月份M，日期D为参数传入来设定的时候，我们会发现：月份M是从0开始的，而日期D却是从1开始的。
即：M:0是一月，1是二月，11是十二月，但D：1 是一号，2是二号，31是三十一号。
如下：
```html runcode
<script type="text/javascript">
var t1 = new Date(2014,0,1).toLocaleString(),
	t2 = new Date(2014,1,2).toLocaleString(),
	t3 = new Date(2014,11,29).toLocaleString()
document.write(2014,"&nbsp;",0,"&nbsp;",1,"<br />",t1,"<br /><br />");
document.write(2014,"&nbsp;",1,"&nbsp;",2,"<br />",t2,"<br /><br />");
document.write(2014,"&nbsp;",11,"&nbsp;",29,"<br />",t3,"<br /><br />");
</script>
```
是不是觉得很别扭，很奇葩？

对于习惯了以“一月”称呼“January”，“二月”称呼“February”的人来说，让”0″和”一”对应，”1″和”二”对应肯定是超级别扭啊，
但对于计算机从业者来说倒合情合理，第一位都是0开始数的嘛。

那问题抛向了另一边，为什么Day又是从1开始呢？
那么我告诉你1Day其实根本不是数组的第一项，日期的初始也是0！
当1Day完成的时候，时间就已经过去了二十四小时，1Day已经结束了。
所以0Day才是days的开始，那么我们来看看0Day到底是什么时候，让我们从1Day开始往前回溯，其实我们将每一天的开始设在了前夜。
如果按小数来细分的话，每月1号的正午应该算是0.5号，而10号的下午6点就是九又四分之三号！
```html runcode
<script type="text/javascript">
var t3 = new Date(2014,11,29).toLocaleString(),
	t2 = new Date(2014,1,2).toLocaleString(),
	t1 = new Date(2014,0,1).toLocaleString(),
	t0 = new Date(2014,0,0).toLocaleString();
document.write(2014,"&nbsp;",11,"&nbsp;",29,"<br />",t3,"<br /><br />");
document.write(2014,"&nbsp;",1,"&nbsp;",2,"<br />",t2,"<br /><br />");
document.write(2014,"&nbsp;",0,"&nbsp;",1,"<br />",t1,"<br /><br />");
document.write(2014,"&nbsp;",0,"&nbsp;",0,"<br />",t0,"<br /><br />");
</script>
```
0Day的设计，其实还有一个巨大的好处，我们调用new Date就可以轻松拿到当月的最后一号，而不用你自己去考虑大小月、闰年2月。
如下：
```html runcode
<script type="text/javascript">
var t1 = new Date(2014,1,0).toLocaleString(),
	t2 = new Date(2014,2,0).toLocaleString(),
	t3 = new Date(2014,3,0).toLocaleString(),
	t4 = new Date(2014,4,0).toLocaleString();
document.write(t1,"<br />");
document.write(t2,"<br />");
document.write(t3,"<br />");
document.write(t4,"<br />");
</script>
```
全文结束。
插一个小问题，在知乎上看见有人提问 <a href="http://www.zhihu.com/question/24400532/answer/29267154" target="_blank" rel="noopener">javascript里面为什么不提供date的格式化函数？</a> 其实在Firefox上是提供了一个toLocaleFormat方法的。
```html runcode
<script type="text/javascript">
(function(){
	if(!new Date().toLocaleFormat) return alert("Date has no method 'toLocaleFormat'");
	var t1 = new Date().toLocaleFormat("%y/%m/%d");
		t2 = new Date("2015,2,14").toLocaleFormat("%y-%m-%d");
		t3 = new Date(1391012219050).toLocaleFormat();
	document.write(t1,"<br />");
	document.write(t2,"<br />");
	document.write(t3,"<br />");
})();
</script>
```
