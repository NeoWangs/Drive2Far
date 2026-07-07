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
<div class="runcode"><textarea class="runcode_text" id="runcode_20081120_Position__1">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;style type="text/css"&gt;
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
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div style="position:relative;"&gt;
&lt;div class="wrap"&gt;&lt;span class="color"&gt;半色字213font阴阳字（只限单行文字）&lt;/span&gt;&lt;/div&gt;
&lt;span class="back"&gt;半色字213font阴阳字（只限单行文字）&lt;/span&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20081120_Position__1')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20081120_Position__1')">Copy</button></div></div>

彩虹字
<div class="runcode"><textarea class="runcode_text" id="runcode_20081120_Position__2">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;style type="text/css"&gt;
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
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div style="position:relative;"&gt;
    &lt;div class="fonts fonts0"&gt;&lt;span class="colors colors0"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;div class="fonts fonts1"&gt;&lt;span class="colors colors1"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;div class="fonts fonts2"&gt;&lt;span class="colors colors2"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;div class="fonts fonts3"&gt;&lt;span class="colors colors3"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;div class="fonts fonts4"&gt;&lt;span class="colors colors4"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;div class="fonts fonts5"&gt;&lt;span class="colors colors5"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;div class="fonts fonts6"&gt;&lt;span class="colors colors6"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;span class="back"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20081120_Position__2')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20081120_Position__2')">Copy</button></div></div>
倒影字：
<div class="runcode"><textarea class="runcode_text" id="runcode_20081120_Position__3">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="utf-8" /&gt;
&lt;style type="text/css"&gt;
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
&lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div style="position:relative; height:25px;"&gt;
    &lt;div class="fonts fonts0"&gt;&lt;span class="back back0"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;div class="fonts fonts1"&gt;&lt;span class="back back1"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;div class="fonts fonts2"&gt;&lt;span class="back back2"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;div class="fonts fonts3"&gt;&lt;span class="back back3"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;div class="fonts fonts4"&gt;&lt;span class="back back4"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;div class="fonts fonts5"&gt;&lt;span class="back back5"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;div class="fonts fonts6"&gt;&lt;span class="back back6"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;&lt;/div&gt;
    &lt;span class="front"&gt;阔地网络阔地网络阔地网络阔地网络&lt;/span&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;/html&gt;</textarea><div class="runcode_actions"><button type="button" class="runcode_button" onclick="runcode.open('runcode_20081120_Position__3')">Run</button><button type="button" class="runcode_button" onclick="runcode.copy('runcode_20081120_Position__3')">Copy</button></div></div>
