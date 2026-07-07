(function () {
  var root = document.documentElement;
  var STORAGE_KEY = 'heibai-theme';

  function applyThemeText(dark) {
    var textEls = document.querySelectorAll('[data-theme-text]');
    for (var i = 0; i < textEls.length; i++) {
      textEls[i].textContent = dark ? '知白' : '守黑';
    }
  }

  function isDark() {
    return root.getAttribute('data-theme') === 'dark';
  }

  document.addEventListener('DOMContentLoaded', function () {
    applyThemeText(isDark());

    var toggle = document.querySelector('[data-theme-toggle]');
    if (toggle) {
      toggle.addEventListener('click', function () {
        var dark = !isDark();
        root.setAttribute('data-theme', dark ? 'dark' : 'light');
        applyThemeText(dark);
        try { localStorage.setItem(STORAGE_KEY, dark ? 'dark' : 'light'); } catch (e) {}
      });
    }

    var burger = document.querySelector('[data-nav-burger]');
    var drawer = document.querySelector('[data-nav-drawer]');
    if (burger && drawer) {
      burger.addEventListener('click', function () {
        drawer.classList.toggle('is-open');
      });
    }

    window.heibaiPinLayout();
    setTimeout(window.heibaiPinLayout, 100);
  });

  window.addEventListener('load', function () {
    window.heibaiPinLayout();
  });
  window.addEventListener('resize', function () {
    window.clearTimeout(window.__heibaiPinResizeTimer);
    window.__heibaiPinResizeTimer = window.setTimeout(window.heibaiPinLayout, 120);
  });

  if (document.fonts && document.fonts.ready) {
    document.fonts.ready.then(function () {
      window.heibaiPinLayout();
    }).catch(function () {});
  }
})();

window.heibaiPinLayout = function () {
  var wraps = document.getElementsByClassName('hexo-pin-wrap');

  function getArrayKey(items, value) {
    for (var key in items) {
      if (items[key] === value) return key;
    }
    return 0;
  }

  function layout(el) {
    var heights = [];
    var boxes = el.children;
    if (!boxes[0]) return;

    var boxWidth = boxes[0].offsetWidth;
    if (!boxWidth) return;

    var columns = Math.max(1, el.offsetWidth / boxWidth | 0);
    el.style.position = 'relative';
    el.style.overflow = 'hidden';

    for (var i = 0; i < boxes.length; i++) {
      boxes[i].style.position = '';
      boxes[i].style.top = '';
      boxes[i].style.left = '';
    }

    for (var j = 0; j < boxes.length; j++) {
      var boxHeight = boxes[j].offsetHeight;
      if (j < columns) {
        heights[j] = boxHeight;
        continue;
      }

      var minHeight = Math.min.apply({}, heights);
      var minKey = getArrayKey(heights, minHeight);
      heights[minKey] += boxHeight;
      boxes[j].style.position = 'absolute';
      boxes[j].style.top = minHeight + 'px';
      boxes[j].style.left = (minKey * boxWidth) + 'px';
    }

    el.style.height = (heights.length ? Math.max.apply({}, heights) : 0) + 'px';
  }

  for (var i = 0; i < wraps.length; i++) {
    layout(wraps[i]);
  }
};

window.runcode = window.runcode || {};
window.runcode.open = function (element) {
  var target = document.getElementById(element);
  if (!target) return;
  var code = target.value;
  var win = window.open('', '', '');
  win.opener = null;
  win.document.write(code);
  win.document.close();
};
window.runcode.copy = function (element) {
  var codeobj = document.getElementById(element);
  if (!codeobj) return;
  if (navigator.clipboard && window.isSecureContext) {
    navigator.clipboard.writeText(codeobj.value);
  } else {
    codeobj.select();
    codeobj.setSelectionRange(0, codeobj.value.length);
    document.execCommand('copy');
    setTimeout(function () {
      codeobj.blur();
    }, 300);
  }
};
