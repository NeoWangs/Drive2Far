---
layout: post
title: "定位元素间的Z值比较及z-index在不同浏览器下默认值的影响"
date: "2009-02-07 15:53:15 +0800"
slug: "定位元素间的Z值比较及z-index在不同浏览器下默认值的影响"
category: "developer"
categories:
  - "developer"
tags:
  - "CSS2"
  - "DOM"
permalink: "/2009/02/07/定位元素间的Z值比较及z-index在不同浏览器下默认值的影响/"
---

<blockquote markdown="1">
z-index在ie下缺省为：z-index:0; 而FF下则缺省为：z-index:auto;
</blockquote>
正是IE/FF下这一点区别导致ie,ff下z值的不同表现。
注意：此处所说的z值区别于z-index,它指的是z轴层叠等级(stack level)，表示垂直于显示屏方向上的各层的层叠顺序。z-index值须在设置position:relative/absolute/fixed之后方才生效，而不止z-index一个属性会影响到z轴层叠等级的大小（本文对其他属性的影响暂不做讨论，但本文的研究已排除其他属性的影响，其他属性不会影响本文的研究）。

<blockquote markdown="1">
正常情况下：兄弟（同级）元素后者居上，父子之间子高于父。
</blockquote>

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>各级元素间z的关系</title>
<style type="text/css">
    div{display:block;width:400px;height:200px;}
	.father1, .son1{border:2px solid #cfc}
	.father2, .son2{border:2px solid #fcf}
/* */
	.father1, .father2{position:relative;background:#aaa;}
    .son1, .son2{position:absolute;background:#eee;left:20px;top:20px;}
/* */
	.father2{top:-40px;left:20px;}
</style>
</head>
<body>
    <div class="father1">
	    父级1
         <div class="son1">
            子级1
		 </div>
    </div>
    <div class="father2">
	    父级2
         <div class="son2">
            子级2
		 </div>
 </div>
</body>
</html>
```
可以看出z的等级：子级2（“堂弟”）>父级2（“叔叔”）>子级1（“子”）>父级1（“父”）。

如果我们想要父盖过子，兄罩着弟只需设置其z-index便可。z-index值越大，给予的z值就越大。
那么这个设置能否改变叔侄之间，堂兄弟之间的Z呢？
先试试看：
```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>侄子盖过叔叔，堂兄罩着堂弟</title>
<style type="text/css">
    div{display:block;width:400px;height:200px;}
	.father1, .son1{border:2px solid #cfc}
	.father2, .son2{border:2px solid #fcf}
/* */
	.father1, .father2{ background:#aaa; }
    .son1, .son2{background:#eee; }
/* */
	.son1{position:relative;z-index:1000;top:20px;}
</style>
</head>
<body>
    <div class="father1">
	    父级1
         <div class="son1">
            子级1
		 </div>
    </div>
    <div class="father2">
	    父级2
         <div class="son2">
            子级2
		 </div>
    </div>
</body>
</html>
```

看上去一样有效，是吧？子级1盖过了父级2和子级2。

但是，再看看下面这个例子，假如各级元素都是定位元素(设置了position),情况就有些不同了（之后的讨论，都是基于这个条件之下的。我觉得position定位的应用非常广泛，基于此的研究也非常有必要）。


```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>ie/ff下表现不同</title>
<style type="text/css">
    div{display:block;width:400px;height:200px;}
	.father1, .son1{border:2px solid #cfc}
	.father2, .son2{border:2px solid #fcf}
/* */
	.father1, .father2{position:relative;background:#aaa;}
    .son1, .son2{position:absolute;background:#eee;left:20px;top:20px;}
	.father2{top:-40px;left:20px;}
/* */
	.son1{z-index:1000;}
</style>
</head>
<body>
    <div class="father1">
	    父级1
         <div class="son1">
            子级1
		 </div>
    </div>
    <div class="father2">
	    父级2
         <div class="son2">
            子级2
		 </div>
    </div>
</body>
</html>
```
son1设置z-index:1000后，在FF下的z值级别就高于其叔与其堂弟father2,son2。但是在ie下这个设置却还是不行。
这时候，我们回过头看最前面的结论：z-index在ie下缺省为：z-index:0; 而FF下则缺省为：z-index:auto;
那么再写一个Test，将父级的z-index固定为0:

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>Z-index默认值的影响</title>
<style type="text/css">
    div{display:block;width:400px;height:200px;}
	.father1, .son1{border:2px solid #cfc}
	.father2, .son2{border:2px solid #fcf}
/* */
	.father1, .father2{position:relative;background:#aaa;z-index:0;}
    .son1, .son2{position:absolute;background:#eee;left:20px;top:20px;}
	.father2{top:-40px;left:20px;}
/* */
	.son1{z-index:1000;}
</style>
</head>
<body>
    <div class="father1">
	    父级1
         <div class="son1">
            子级1
		 </div>
    </div>
    <div class="father2">
	    父级2
         <div class="son2">
            子级2
		 </div>
    </div>
</body>
</html>
```
可以看出，一旦父级元素设置了相同的z-index，ff下“侄”元素一样无法超过“叔”元素和“堂弟”元素。

我们可以试着得出这么一个结论：
<blockquote markdown="1">
对于定位元素，（不论IE还是FF）非同级关系和非父子关系元素之间的Z值大小比较，须要回溯至其为兄弟关系的两个祖先元素上，先比较这两个元素的z-index值，只有当“兄”的z-index大于“弟”的z-index值，“兄”的各个后代元素，才能超过“弟元素”及其子孙元素。
</blockquote>
我们用一个三级关系来验证一下。

```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>三级关系验证本文结论</title>
<style type="text/css">
    div{display:block;width:400px;height:200px;}
	#first,#first div{border:2px solid #cfc}
	#second,#second div{border:2px solid #fcf}
	#second{top:-80px;}
/* */
    .grandfather{position:relative;background:#aaa;z-index:0;}
	.father{position:absolute;background:#ccc;left:20px;top:20px;z-index:0;}
    .son{position:absolute;background:#eee;left:20px;top:20px;z-index:0;}
/*  */
    #first{z-index:1;}
    #first .father{z-index:1;}
    #first .son{z-index:1;}
</style>
</head>
<body>
 <div id="first" class="grandfather">
    祖父级
    <div class="father">
	    父级
         <div class="son">
            子级
		 </div>
    </div>
 </div>
 <div id="second"  class="grandfather">
    祖父级
    <div class="father">
	    父级
         <div class="son">
            子级
		 </div>
    </div>
 </div>
</body>
</html>
```
不论#first .father和#first .son如何设置，只有#first的z-index值大于0（second的z-index值为0）时，才能盖住#second。

对于IE,元素的z-index缺省值是0，如果不另外设置“兄”，“弟”元素的z-index值，那么”兄”的z-index就无法大于“弟”的z-index。那么”兄”元素及其子孙就无法盖过”弟”元素及其子孙。而一旦“兄”的z-index大过了”弟”元素的z-index,那么情况就翻转了，“弟”元素及其子孙将无法盖过“兄”元素及其子孙。
而对FF,元素的z-index缺省值是auto,auto的意思是什么，就是说“随便，不关我事”，那么子孙们的z值等级就只跟他们自己本身的z-index有关了。
那么，IE上能否设置z-index:auto;呢？

测试：
```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>测试IE下的z-index:auto属性</title>
<style type="text/css">
    div{display:block;width:400px;height:200px;}
	#first,#first div{border:2px solid #cfc}
	#second,#second div{border:2px solid #fcf}
	#second{top:-80px;}
/* */
    .grandfather{position:relative;background:#aaa;z-index:auto;}
	.father{position:absolute;background:#ccc;left:20px;top:20px;z-index:auto;}
    .son{position:absolute;background:#eee;left:20px;top:20px;z-index:auto;}
/*  #first{z-index:1;}   */
    #first .father{z-index:1;}
    #first .son{z-index:1;}
</style>
</head>
<body>
 <div id="first" class="grandfather">
    祖父级
    <div class="father">
	    父级
         <div class="son">
            子级
		 </div>
    </div>
 </div>
 <div id="second"  class="grandfather">
    祖父级
    <div class="father">
	    父级
         <div class="son">
            子级
		 </div>
    </div>
 </div>
</body>
</html>
```
可以看出，在IE下，去除#first{z-index:1}后，#first及其子孙无法盖住#second。
而FF下，#first .father,#first .son却盖住了整个#second。

推论：
<blockquote markdown="1">
z-index:auto在ie下无效。
</blockquote>
那么在IE下，对于由定位元素构成的两个并列的嵌套结构块间的Z值大小，只存在两种情况：要么这个结构块里的所有层元素都在另一个结构块之上，要么就是那个结构块所有元素在其之上。没有可能一个元素能插在另一个结构块的父与子之间，这种情况在FF下是存在的（当然，还有其他浏览器），在FF下，父级是z-index:auto的元素，他们都是自由的，依据自己的z-index决定Z值。FF下甚至可以形成：
111111
   222222
111111
   222222
这么一个四层交错，但要超过四层，就无能为力了。
```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>FF下的四层交错</title>
<style type="text/css">
    div{display:block;width:400px;height:200px;}
	#first,#first div{border:2px solid #cfc}
	#second,#second div{border:2px solid #fcf}
	#second{top:-80px;}
/* */
    .grandfather{position:relative;background:#aaa;z-index:auto;}
	.father{position:absolute;background:#ccc;left:20px;top:20px;z-index:auto;}
    .son{position:absolute;background:#eee;left:20px;top:20px;z-index:auto;}
/* */
    #first .father{z-index:1;}
    #first .son{z-index:3;}
	#second .father{z-index:2;}
	#second .son{z-index:4;}
</style>
</head>
<body>
 <div id="first" class="grandfather">
    祖父级
    <div class="father">
	    父级
         <div class="son">
            子级
		 </div>
    </div>
 </div>
 <div id="second"  class="grandfather">
    祖父级
    <div class="father">
	    父级
         <div class="son">
            子级
		 </div>
    </div>
 </div>
</body>
</html>
```

补充：关于z-index:auto的解释，在W3C的CSS说明文档中的解释是：


<blockquote markdown="1">
The stack level of the generated box in the current stacking context is the same as its parent’s box. The box does not establish a new local stacking context.
</blockquote>
即Z的层叠等级将继承父级，不创建新的层叠内容。

这段说明在CSS2和CSS2.1中是完全一致的，那为什么ie”不支持” z-index:auto呢？

在css2中有一段css2.1中所没有的解释：
<blockquote markdown="1">
An element that establishes a local stacking context generates a box that has two stack levels: one for the stacking context it creates (always ‘0′) and one for the stacking context to which it belongs (given by the ‘z-index’ property).
</blockquote>
一个元素创建的层叠内容框包含两个层叠等级，一个是就是创建的层叠内容（总是“0”），另一个就是这个层叠内容包含的子层叠内容（由“z-index”属性决定）。

所以在ie当中，即便某元素设置z-index：auto，它所继承的z也是0。
这貌似同我们文章中第一段结论一致。也勉强解释了为什么z-index:auto在IE中无效。
