---
layout: post
title: "Position定位巧做彩虹字，倒影字效果"
date: "2008-11-20 15:39:02 +0800"
slug: "Position定位巧做彩虹字，倒影字效果"
category: "developer"
categories:
  - "developer"
tags:
  - "CSS2"
permalink: "/2008/11/20/Position定位巧做彩虹字，倒影字效果/"
---

"阴阳字"
```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<style type="text/css">
body{background:#E9F5EE; font-family:'黑体';  font-size:15pt;}
.wrap{
    position:absolute;
    top:8pt;
    overflow:hidden;
    }
.color{
    position:relative;
    top:-8pt;
    color:#ccc;
   }
</style>
</head>
<body>
<div style="position:relative;">
<div class="wrap"><span class="color">半色字213font阴阳字（只限单行文字）</span></div>
<span class="back">半色字213font阴阳字（只限单行文字）</span>
</div>
</body>
</html>
```

彩虹字
```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<style type="text/css">
body{background:#3e4b5c; color:#b7e2e9; font-size:15pt;}
.fonts{position:absolute; overflow:hidden; height:2pt;  }
.colors{position:relative;}
.fonts0{ top:1pt; }
.colors0{ top:-1pt; color:#e61765;}
.fonts1{ top:3pt; }
.colors1{ top:-3pt; color:#d7588f;}
.fonts2{ top:5pt; }
.colors2{ top:-5pt; color:#cb8eb2;}
.fonts3{ top:5pt; }
.colors3{ top:-5pt; color:#c4a8c4;}
.fonts4{ top:7pt; }
.colors4{ top:-7pt; color:#c2b4cb;}
.fonts5{ top:9pt; }
.colors5{ top:-9pt; color:#bccbd9;}
.fonts6{ top:11pt; }
.colors6{ top:-11pt; color:#b7e2e9;}
</style>
</head>
<body>
<div style="position:relative;">
    <div class="fonts fonts0"><span class="colors colors0">阔地网络阔地网络阔地网络阔地网络</span></div>
    <div class="fonts fonts1"><span class="colors colors1">阔地网络阔地网络阔地网络阔地网络</span></div>
    <div class="fonts fonts2"><span class="colors colors2">阔地网络阔地网络阔地网络阔地网络</span></div>
    <div class="fonts fonts3"><span class="colors colors3">阔地网络阔地网络阔地网络阔地网络</span></div>
    <div class="fonts fonts4"><span class="colors colors4">阔地网络阔地网络阔地网络阔地网络</span></div>
    <div class="fonts fonts5"><span class="colors colors5">阔地网络阔地网络阔地网络阔地网络</span></div>
    <div class="fonts fonts6"><span class="colors colors6">阔地网络阔地网络阔地网络阔地网络</span></div>
    <span class="back">阔地网络阔地网络阔地网络阔地网络</span>
</div>
</body>
</html>
```
倒影字：
```html runcode
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<style type="text/css">
body{background:#E9F5EE; font-family:'黑体';  font-size:18px;}
.fonts{position:absolute; overflow:hidden; height:1px;}
.back{position:relative;}
.fonts0{ top:18px; }
.back0{ top:-15px; color:#999; }
.fonts1{ top:19px; }
.back1{ top:-14px; color:#aaa;}
.fonts2{ top:20px; }
.back2{ top:-13px; color:#bbb;}
.fonts3{ top:21px; }
.back3{ top:-12px; color:#bbb;}
.fonts4{ top:22px; }
.back4{ top:-11px; color:#ccc;}
.fonts5{ top:23px; }
.back5{ top:-10px; color:#ccc;}
.fonts6{ top:24px; }
.back6{ top:-9px; color:#ddd;}
</style>
</head>
<body>
<div style="position:relative; height:25px;">
    <div class="fonts fonts0"><span class="back back0">阔地网络阔地网络阔地网络阔地网络</span></div>
    <div class="fonts fonts1"><span class="back back1">阔地网络阔地网络阔地网络阔地网络</span></div>
    <div class="fonts fonts2"><span class="back back2">阔地网络阔地网络阔地网络阔地网络</span></div>
    <div class="fonts fonts3"><span class="back back3">阔地网络阔地网络阔地网络阔地网络</span></div>
    <div class="fonts fonts4"><span class="back back4">阔地网络阔地网络阔地网络阔地网络</span></div>
    <div class="fonts fonts5"><span class="back back5">阔地网络阔地网络阔地网络阔地网络</span></div>
    <div class="fonts fonts6"><span class="back back6">阔地网络阔地网络阔地网络阔地网络</span></div>
    <span class="front">阔地网络阔地网络阔地网络阔地网络</span>
</div>
</body>
</html>
```
