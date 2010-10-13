// HINTSTYLE: letter || number or whatever you want
var HINTSTYLE = "letter";
var elements = [];
var active_arr = [];
var hints;
var active;
var lastpos = 0;
var lastinput;
var styles;

active_color = "#00ff00";
normal_color = "#ffff00";
opacity = 0.3;
border = "1px dotted #000000";

hint_foreground = "#ffffff";
hint_background = "#0000aa";
hint_border = "2px dashed #000000";
hint_opacity = 0.6;
hint_font_size =  "12px";
hint_font_weight = "bold";
hint_font_family = "monospace";

var letters_seq = "FDSARTGBVECWXQYIOPMNHZULK"
//var letters_seq = "fdsartgbvecwxqyiopmnhzulkj"

// Hint
function Hint(element) {
  this.element = element;
  this.rect = element.getBoundingClientRect();

  function create_span(element, h, v) {
    var span = document.createElement("span");
    var leftpos = Math.max((element.rect.left + document.defaultView.scrollX), document.defaultView.scrollX);
    var toppos = Math.max((element.rect.top + document.defaultView.scrollY), document.defaultView.scrollY);
    span.style.position = "absolute";
    span.style.left = leftpos + "px";
    span.style.top = toppos + "px";
    return span;
  }
  function create_hint(element) {
    var hint = create_span(element);
    hint.style.fontSize = hint_font_size;
    hint.style.fontWeight = hint_font_weight;
    hint.style.fontFamily = hint_font_family;
    hint.style.color = hint_foreground;
    hint.style.background = hint_background;
    hint.style.opacity = hint_opacity;
    hint.style.border = hint_border;
    hint.style.zIndex = 10001;
    hint.style.visibility = 'visible';
    return hint;
  }
  this.hint = create_hint(this);
}
//NumberHint
NumberHint.prototype.getTextHint = function (i, length) {
  start = length <=10 ? 1 : length <= 100 ? 10 : 100;
  var content = document.createTextNode(start + i);
  this.hint.appendChild(content);
}
NumberHint.prototype.betterMatch = function(input) {
  var bestposition = 37;
  var ret = 0;
  for (var i=0; i<active_arr.length; i++) {
    var e = active_arr[i];
    if (input && bestposition != 0) {
      var content = e.element.textContent.toLowerCase().split(" ");
      for (var cl=0; cl<content.length; cl++) {
        if (content[cl].toLowerCase().indexOf(input) == 0) {
          if (cl < bestposition) {
            ret = i;
            bestposition = cl;
            break;
          }
        }
      }
    }
  }
  return ret;
}
NumberHint.prototype.matchText = function(input) {
  var ret = false;
  if (parseInt(input) == input) {
    text_content = this.hint.textContent;
  }
  else {
    text_content = this.element.textContent.toLowerCase();
  }
  if (text_content.match(input)) {
    return true;
  }
}

// LetterHint
LetterHint.prototype.getTextHint = function(i, length) {
  var text;
  var l = letters_seq.length;
  if (length < l) {
    text = letters_seq[i];
  }
  else if (length < 2*l) {
    var rem = (length) % l;
    var sqrt = Math.sqrt(2*rem);
    var r = sqrt == (getint = parseInt(sqrt)) ? sqrt + 1 : getint ;
    if (i < l-r) {
      text = letters_seq[i];
    }
    else {
      var newrem = i%(r*r);
      text = letters_seq[Math.floor( (newrem / r) + l - r )] + letters_seq[l-newrem%r - 1];
    }
  }
  else {
    text = letters_seq[i%l] + letters_seq[l - 1 - Math.floor(i/l)];
  }
  var content = document.createTextNode(text);
  this.hint.appendChild(content);
}

LetterHint.prototype.betterMatch = function(input) {
  return 0;
}

LetterHint.prototype.matchText = function(input) {
  return (this.hint.textContent.toLowerCase().indexOf(input.toLowerCase()) == 0);
}


function LetterHint(element) {
  this.constructor = Hint;
  this.constructor(element);
}
LetterHint.prototype = new Hint();

function NumberHint(element) {
  this.constructor = Hint;
  this.constructor(element);
}
NumberHint.prototype = new Hint();

function click_element(e) {
  var mouseEvent = document.createEvent("MouseEvent");
  mouseEvent.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
  e.element.dispatchEvent(mouseEvent);
  clear();
}
function dwb_create_stylesheet() {
  var styles = document.createElement("style");
  styles.type = "text/css";
  document.getElementsByTagName('head')[0].appendChild(styles);
  
  var style = document.styleSheets[document.styleSheets.length - 1];
  style.insertRule('a[dwb_highlight=hint_normal] { background: ' + normal_color + ' } ', 0);
  style.insertRule('a[dwb_highlight=hint_normal] { outline: 1px solid ' + normal_color + ' } ', 0);
  style.insertRule('input[dwb_highlight=hint_normal] { outline: 1px solid ' + normal_color + '  } ', 0);
  style.insertRule('a[dwb_highlight=hint_active] { background: ' + active_color + '  } ', 0);
  style.insertRule('a[dwb_highlight=hint_active] { border: 1px solid ' + active_color + '  } ', 0);
  style.insertRule('input[dwb_highlight=hint_active] { outline: 1px solid ' + active_color + '  } ', 0);
}
function get_visibility(e) {
  var style = document.defaultView.getComputedStyle(e, null);
  if (style.getPropertyValue("visibility") == "hidden" || style.getPropertyValue("display") == "none") {
      return false;
  }
  var rects = e.getClientRects()[0];
  var r = e.getBoundingClientRect();

  var height = window.innerHeight ? window.innerHeight : document.body.offsetHeight;
  var width = window.innerWidth ? window.innerWidth : document.body.offsetWidth;
  if (!r || r.top > height || r.bottom < 0 || r.left > width ||  r.right < 0 || !rects) {
    return false;
  }

  var style = document.defaultView.getComputedStyle(e, null);
  return true;
}


function show_hints() {
  var res = document.body.querySelectorAll('a, area, textarea, select, link, input:not([type=hidden]), button,  frame, iframe');

  var hints = document.createElement("div");
  hints.id = "dwb_hints";

  dwb_create_stylesheet();

  for (var i=0; i<res.length; i++) {
    if (get_visibility(res[i])) {
      var e = HINTSTYLE.toLowerCase() == "letter" ? new LetterHint(res[i], i) : new NumberHint(res[i], i);
      elements.push(e);
    }
  }
  elements.sort( function(a,b) { return a.rect.top - b.rect.top; });
  for (var i=0; i<elements.length; i++) {
    if (res[i] == elements[i]) {
      continue;
    }
    var e = elements[i];
    hints.appendChild(e.hint);
    e.getTextHint(i, elements.length);
    e.element.setAttribute('dwb_highlight', 'hint_normal');
  }
  active_arr = elements;
  set_active(active_arr[0]);
  
  document.getElementsByTagName("body")[0].appendChild(hints);
}
function update_hints(input) {
  var array = [];
  var text_content;
  var keep = false;
  if (input) {
    input = input.toLowerCase();
  }
  if (lastinput && (lastinput.length > input.length)) {
    clear();
    lastinput = input;
    show_hints();
    update_hints(input);
    return;
  }
  lastinput = input;
  for (var i=0; i<active_arr.length; i++) {
    var e = active_arr[i];
    if (e.matchText(input)) {
      array.push(e);
    }
    else {
      e.hint.style.visibility = 'hidden';
      e.element.removeAttribute('dwb_highlight');
    }
  }
  active_arr = array;
  active = array[0];
  if (array.length == 0) {
    clear();
    return;
  }
  else if (array.length == 1) {
    return evaluate(array[0]);
  }
  else {
    lastpos = array[0].betterMatch(input);
    set_active(array[lastpos]);
  }
}
function set_active(element) {
  var current = document.querySelector('*[dwb_highlight=hint_active]');
  if (current) {
    current.setAttribute('dwb_highlight', 'hint_normal' );
  }
  element.element.setAttribute('dwb_highlight', 'hint_active');
  active = element;
}
function clear() {
  var hints = document.getElementById("dwb_hints");
  hints.parentNode.removeChild(hints);
  active_arr = [];
  if (elements) {
    for (var i=0; i<elements.length; i++) {
      elements[i].element.removeAttribute('dwb_highlight');
    }
  }
  if (styles) {
    document.getElementsByTagName('head')[0].removeChild(styles);
  }
  elements = [];
}
function evaluate(element) {
  var ret;
  var e = element.element;
  var type = e.type.toLowerCase();
  var  tagname = e.tagName.toLowerCase();

  if (tagname == "input" || tagname == "textarea" ) {
    if (type == "radio" || type == "checkbox") {
      e.focus();
      dwb_click_element(element);
    }
    else if (type == "submit" || type == "reset" || type  == "button") {
      dwb_click_element(element);
    }
    else {
      e.focus();
    }
    clear();
  }
  else {
    ret = e.href;
  }
  return ret;
}
function get_active() {
  return evaluate(active);
}

function focus_next() {
  var newpos = lastpos == active_arr.length-1 ? 0 : lastpos + 1;
  active = active_arr[newpos];
  set_active(active);
  lastpos = newpos;
}
function focus_prev() {
  var newpos = lastpos == 0 ? active_arr.length-1 : lastpos - 1;
  active = active_arr[newpos];
  set_active(active);
  lastpos = newpos;
}
