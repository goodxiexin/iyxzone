/* NicEdit - Micro Inline WYSIWYG
 * Copyright 2007-2008 Brian Kirchoff
 *
 * NicEdit is distributed under the terms of the MIT license
 * For more information visit http://nicedit.com/
 * Do not remove this copyright message
 */
var bkExtend = function(){
	var args = arguments;
	if (args.length == 1) args = [this, args[0]];
	for (var prop in args[1]) args[0][prop] = args[1][prop];
	return args[0];
};
function bkClass() { }
bkClass.prototype.construct = function() {};
bkClass.extend = function(def) {
  var classDef = function() {
      if (arguments[0] !== bkClass) { return this.construct.apply(this, arguments); }
  };
  var proto = new this(bkClass);
  bkExtend(proto,def);
  classDef.prototype = proto;
  classDef.extend = this.extend;      
  return classDef;
};

var bkElement = bkClass.extend({
	construct : function(elm,d) {
		if(typeof(elm) == "string") {
			elm = (d || document).createElement(elm);
		}
		elm = $BK(elm);
		return elm;
	},
	
	appendTo : function(elm) {
		elm.appendChild(this);	
		return this;
	},
	
	appendBefore : function(elm) {
		elm.parentNode.insertBefore(this,elm);	
		return this;
	},
	
	addEvent : function(type, fn) {
		bkLib.addEvent(this,type,fn);
		return this;	
	},
	
	setContent : function(c) {
		this.innerHTML = c;
		return this;
	},
	
	pos : function() {
		var curleft = curtop = 0;
		var o = obj = this;
		if (obj.offsetParent) {
			do {
				curleft += obj.offsetLeft;
				curtop += obj.offsetTop;
			} while (obj = obj.offsetParent);
		}
		var b = (!window.opera) ? parseInt(this.getStyle('border-width') || this.style.border) || 0 : 0;
		return [curleft+b,curtop+b+this.offsetHeight];
	},
	
	noSelect : function() {
		bkLib.noSelect(this);
		return this;
	},
	
	parentTag : function(t) {
		var elm = this;
		 do {
			if(elm && elm.nodeName && elm.nodeName.toUpperCase() == t) {
				return elm;
			}
			elm = elm.parentNode;
		} while(elm);
		return false;
	},

  // 下面3个函数是高侠鸿添加的，不属于nicEdit
  up : function(){
    var elm = this;
    return $BK(elm.parentNode);
  },
	
  show : function(){
    var elm = this;
    elm.style.display = '';
    return elm;
  },

  hide : function(){
    var elm = this;
    elm.style.display = 'none'
    return elm;
  },

	hasClass : function(cls) {
		return this.className.match(new RegExp('(\\s|^)nicEdit-'+cls+'(\\s|$)'));
	},
	
	addClass : function(cls) {
		if (!this.hasClass(cls)) { this.className += " nicEdit-"+cls };
		return this;
	},
	
	removeClass : function(cls) {
		if (this.hasClass(cls)) {
			this.className = this.className.replace(new RegExp('(\\s|^)nicEdit-'+cls+'(\\s|$)'),' ');
		}
		return this;
	},

	setStyle : function(st) {
		var elmStyle = this.style;
		for(var itm in st) {
			switch(itm) {
				case 'float':
					elmStyle['cssFloat'] = elmStyle['styleFloat'] = st[itm];
					break;
				case 'opacity':
					elmStyle.opacity = st[itm];
					elmStyle.filter = "alpha(opacity=" + Math.round(st[itm]*100) + ")"; 
					break;
				case 'className':
					this.className = st[itm];
					break;
				default:
					//if(document.compatMode || itm != "cursor") { // Nasty Workaround for IE 5.5
						elmStyle[itm] = st[itm];
					//}		
			}
		}
		return this;
	},
	
	getStyle : function( cssRule, d ) {
		var doc = (!d) ? document.defaultView : d; 
		if(this.nodeType == 1)
		return (doc && doc.getComputedStyle) ? doc.getComputedStyle( this, null ).getPropertyValue(cssRule) : this.currentStyle[ bkLib.camelize(cssRule) ];
	},
	
	remove : function() {
		this.parentNode.removeChild(this);
		return this;	
	},
	
	setAttributes : function(at) {
		for(var itm in at) {
			this[itm] = at[itm];
		}
		return this;
	}
});

var bkLib = {
	isMSIE : (navigator.userAgent.indexOf("MSIE") > 0),

  // added by gaoxh
  eventTarget: function(e){
    if(this.isMSIE){
      return e.srcElement;
    }else{
      return e.target;
    }
  },
	
	addEvent : function(obj, type, fn) {
		(obj.addEventListener) ? obj.addEventListener( type, fn, false ) : obj.attachEvent("on"+type, fn);	
	},
	
	toArray : function(iterable) {
		var length = iterable.length, results = new Array(length);
    	while (length--) { results[length] = iterable[length] };
    	return results;	
	},
	
	noSelect : function(element) {
		if(element.setAttribute && element.nodeName.toLowerCase() != 'input' && element.nodeName.toLowerCase() != 'textarea') {
			element.setAttribute('unselectable','on');
		}
		for(var i=0;i<element.childNodes.length;i++) {
			bkLib.noSelect(element.childNodes[i]);
		}
	},
	camelize : function(s) {
		return s.replace(/\-(.)/g, function(m, l){return l.toUpperCase()});
	},
	inArray : function(arr,item) {
	    return (bkLib.search(arr,item) != null);
	},
	search : function(arr,itm) {
		for(var i=0; i < arr.length; i++) {
			if(arr[i] == itm)
				return i;
		}
		return null;	
	},
	cancelEvent : function(e) {
		e = e || window.event;
		if(e.preventDefault && e.stopPropagation) {
			e.preventDefault();
			e.stopPropagation();
		}
		return false;
	},
	domLoad : [],
	domLoaded : function() {
		if (arguments.callee.done) return;
		arguments.callee.done = true;
		for (i = 0;i < bkLib.domLoad.length;i++) bkLib.domLoad[i]();
	},
	onDomLoaded : function(fireThis) {
		this.domLoad.push(fireThis);
		if (document.addEventListener) {
			document.addEventListener("DOMContentLoaded", bkLib.domLoaded, null);
		} else if(bkLib.isMSIE) {
			document.write("<style>.nicEdit-main p { margin: 0; }</style><scr"+"ipt id=__ie_onload defer " + ((location.protocol == "https:") ? "src='javascript:void(0)'" : "src=//0") + "><\/scr"+"ipt>");
			$BK("__ie_onload").onreadystatechange = function() {
			    if (this.readyState == "complete"){bkLib.domLoaded();}
			};
		}
	    window.onload = bkLib.domLoaded;
	}
};

function $BK(elm) {
	if(typeof(elm) == "string") {
		elm = document.getElementById(elm);
	}
	return (elm && !elm.appendTo) ? bkExtend(elm,bkElement.prototype) : elm;
}

var bkEvent = {
	addEvent : function(evType, evFunc) {
		if(evFunc) {
			this.eventList = this.eventList || {};
			this.eventList[evType] = this.eventList[evType] || [];
			this.eventList[evType].push(evFunc);
		}
		return this;
	},
	fireEvent : function() {
		var args = bkLib.toArray(arguments), evType = args.shift();
		if(this.eventList && this.eventList[evType]) {
			for(var i=0;i<this.eventList[evType].length;i++) {
				this.eventList[evType][i].apply(this,args);
			}
		}
	}	
};

function __(s) {
	return s;
}

Function.prototype.closure = function() {
  var __method = this, args = bkLib.toArray(arguments), obj = args.shift();
  return function() { if(typeof(bkLib) != 'undefined') { return __method.apply(obj,args.concat(bkLib.toArray(arguments))); } };
}
	
Function.prototype.closureListener = function() {
  	var __method = this, args = bkLib.toArray(arguments), object = args.shift(); 
  	return function(e) { 
  	e = e || window.event;
  	if(e.target) { var target = e.target; } else { var target =  e.srcElement };
	  	return __method.apply(object, [e,target].concat(args) ); 
	};
}		


/* START CONFIG */

var nicEditorConfig = bkClass.extend({
	buttons : {
    'redo' : {name : __('重做'), command : 'Redo', noActive : true},
    'undo' : {name : __('撤销'), command : 'Undo', noActive : true},
		'bold' : {name : __('黑体(Ctrl+B)'), command : 'Bold', tags : ['B','STRONG'], css : {'font-weight' : 'bold'}, key : 'b'},
		'italic' : {name : __('斜体(Ctrl+I)'), command : 'Italic', tags : ['EM','I'], css : {'font-style' : 'italic'}, key : 'i'},
		'underline' : {name : __('下划线(Ctrl+U)'), command : 'Underline', tags : ['U'], css : {'text-decoration' : 'underline'}, key : 'u'},
		'left' : {name : __('左对齐'), command : 'justifyleft', noActive : true},
		'center' : {name : __('居中'), command : 'justifycenter', noActive : true},
		'right' : {name : __('右对齐'), command : 'justifyright', noActive : true},
		'justify' : {name : __('两端对齐'), command : 'justifyfull', noActive : true},
		'ol' : {name : __('有序列表'), command : 'insertorderedlist', tags : ['OL']},
		'ul' : 	{name : __('无序列表'), command : 'insertunorderedlist', tags : ['UL']},
		'subscript' : {name : __('下标'), command : 'subscript', tags : ['SUB']},
		'superscript' : {name : __('上标'), command : 'superscript', tags : ['SUP']},
		'strikethrough' : {name : __('删除线'), command : 'strikeThrough', css : {'text-decoration' : 'line-through'}},
		'removeformat' : {name : __('清除格式'), command : 'removeformat', noActive : true},
		'indent' : {name : __('向内缩进'), command : 'indent', noActive : true},
		'outdent' : {name : __('向外缩进'), command : 'outdent', noActive : true},
		'hr' : {name : __('水平线'), command : 'insertHorizontalRule', noActive : true}
	},
	iconsPath : '/images/nicEditor/nicEditorIcons.gif',
	buttonList : ['undo', 'redo', 'bold','italic','underline','left','center','right','justify','ol','ul','fontSize','fontFamily','fontFormat','emotion','image','link','forecolor','bgcolor'],
	iconList : {"bgcolor":1,"forecolor":2,"bold":3,"center":4,"hr":5,"indent":6,"italic":7,"justify":8,"left":9,"ol":10,"outdent":11,"removeformat":12,"right":13,"save":24,"strikethrough":15,"subscript":16,"superscript":17,"ul":18,"underline":19,"image":20,"link":21,"unlink":22,"close":23,"arrow":25,"emotion":26, "undo": 27, "redo": 28}
	
});
/* END CONFIG */


var nicEditors = {
	nicPlugins : [],
	editors : [],
	
	registerPlugin : function(plugin,options) {
		this.nicPlugins.push({p : plugin, o : options});
	},

	allTextAreas : function(nicOptions) {
		var textareas = document.getElementsByTagName("textarea");
		for(var i=0;i<textareas.length;i++) {
			nicEditors.editors.push(new nicEditor(nicOptions).panelInstance(textareas[i]));
		}
		return nicEditors.editors;
	},
	
	findEditor : function(e) {
		var editors = nicEditors.editors;
		for(var i=0;i<editors.length;i++) {
			if(editors[i].instanceById(e)) {
				return editors[i].instanceById(e);
			}
		}
	}
};


var nicEditor = bkClass.extend({
	construct : function(o) {
		this.options = new nicEditorConfig();
		bkExtend(this.options,o);
		this.nicInstances = new Array();
		this.loadedPlugins = new Array();
		
		var plugins = nicEditors.nicPlugins;
		for(var i=0;i<plugins.length;i++) {
			this.loadedPlugins.push(new plugins[i].p(this,plugins[i].o));
		}
		nicEditors.editors.push(this);
		bkLib.addEvent(document.body,'mousedown', this.selectCheck.closureListener(this) );
	},
	
	panelInstance : function(e,o) {
		e = this.checkReplace($BK(e));
		var panelElm = new bkElement('DIV').setStyle({width : (parseInt(e.getStyle('width')) || e.clientWidth)+'px'}).appendBefore(e);
		this.setPanel(panelElm);
		return this.addInstance(e,o);	
	},

	checkReplace : function(e) {
		var r = nicEditors.findEditor(e);
		if(r) {
			r.removeInstance(e);
			r.removePanel();
		}
		return e;
	},

	addInstance : function(e,o) {
		e = this.checkReplace($BK(e));
		if( e.contentEditable || !!window.opera ) {
			var newInstance = new nicEditorInstance(e,o,this);
		} else {
			var newInstance = new nicEditorIFrameInstance(e,o,this);
		}
		this.nicInstances.push(newInstance);
		return this;
	},
	
	removeInstance : function(e) {
		e = $BK(e);
		var instances = this.nicInstances;
		for(var i=0;i<instances.length;i++) {	
			if(instances[i].e == e) {
				instances[i].remove();
				this.nicInstances.splice(i,1);
			}
		}
	},

	removePanel : function(e) {
		if(this.nicPanel) {
			this.nicPanel.remove();
			this.nicPanel = null;
		}	
	},

	instanceById : function(e) {
		e = $BK(e);
		var instances = this.nicInstances;
		for(var i=0;i<instances.length;i++) {
			if(instances[i].e == e) {
				return instances[i];
			}
		}	
	},

	setPanel : function(e) {
		this.nicPanel = new nicEditorPanel($BK(e),this.options,this);
		this.fireEvent('panel',this.nicPanel);
		return this;
	},
	
	nicCommand : function(cmd,args) {	
		if(this.selectedInstance) {
			this.selectedInstance.nicCommand(cmd,args);
		}
	},
	
	getIcon : function(iconName,options) {
		var icon = this.options.iconList[iconName];
		var file = (options['iconPath']) ? options['iconPath'] : '';
		return {backgroundImage : "url('"+((file == '') ? this.options.iconsPath : file)+"')", backgroundPosition : ((file == '') ? ((icon-1)*-18) : 0)+'px 0px'};	
	},
		
	selectCheck : function(e,t) {
		var found = false;
		do{
			if(t.className && t.className.indexOf('nicEdit') != -1) {
				return false;
			}
		} while(t = t.parentNode);
		this.fireEvent('blur',this.selectedInstance,t);
		this.lastSelectedInstance = this.selectedInstance;
		this.selectedInstance = null;
		return false;
	}
	
});
nicEditor = nicEditor.extend(bkEvent);

 
var nicEditorInstance = bkClass.extend({
	isSelected : false,
	
	construct : function(e,options,nicEditor) {
		this.ne = nicEditor;
		this.elm = this.e = e;
		this.options = options || {};
		
		newX = parseInt(e.getStyle('width')) || e.clientWidth;
		newY = parseInt(e.getStyle('height')) || e.clientHeight;
		this.initialHeight = newY-8;
		
		var isTextarea = (e.nodeName.toLowerCase() == "textarea");
		if(isTextarea || this.options.hasPanel) {
			var ie7s = (bkLib.isMSIE && !((typeof document.body.style.maxHeight != "undefined") && document.compatMode == "CSS1Compat"))
			var s = {width: newX+'px', border : '1px solid #ccc', borderTop : 0, overflowY : 'auto', overflowX: 'hidden' };
			s[(ie7s) ? 'height' : 'maxHeight'] = (this.ne.options.maxHeight) ? this.ne.options.maxHeight+'px' : null;
			this.editorContain = new bkElement('DIV').setStyle(s).appendBefore(e);
			var editorElm = new bkElement('DIV').setStyle({width : (newX-8)+'px', margin: '4px', minHeight : newY+'px'}).addClass('main').appendTo(this.editorContain);

			e.setStyle({display : 'none'});
				
			editorElm.innerHTML = e.innerHTML;		
			if(isTextarea) {
				editorElm.setContent(e.value);
				this.copyElm = e;
				var f = e.parentTag('FORM');
				if(f) { bkLib.addEvent( f, 'submit', this.saveContent.closure(this)); }
			}
			editorElm.setStyle((ie7s) ? {height : newY+'px'} : {overflow: 'hidden'});
			this.elm = editorElm;	
		}
		this.ne.addEvent('blur',this.blur.closure(this));

		this.init();
		this.blur();
	},
	
	init : function() {
		this.elm.setAttribute('contentEditable','true');	
		if(this.getContent() == "") {
			this.setContent('<br />');
		}
		this.instanceDoc = document.defaultView;
		this.elm.addEvent('mousedown',this.selected.closureListener(this)).addEvent('keypress',this.keyDown.closureListener(this)).addEvent('focus',this.selected.closure(this)).addEvent('blur',this.blur.closure(this)).addEvent('keyup',this.selected.closure(this));
		this.ne.fireEvent('add',this);
	},
	
	remove : function() {
		this.saveContent();
		if(this.copyElm || this.options.hasPanel) {
			this.editorContain.remove();
			this.e.setStyle({'display' : 'block'});
			this.ne.removePanel();
		}
		this.disable();
		this.ne.fireEvent('remove',this);
	},
	
	disable : function() {
		this.elm.setAttribute('contentEditable','false');
	},
	
	getSel : function() {
		return (window.getSelection) ? window.getSelection() : document.selection;	
	},
	
	getRng : function() {
		var s = this.getSel();
		if(!s) { return null; }
		return (s.rangeCount > 0) ? s.getRangeAt(0) : s.createRange();
	},
	
	selRng : function(rng,s) {
		if(window.getSelection) {
			s.removeAllRanges();
			s.addRange(rng);
		} else {
			rng.select();
		}
	},
	
	selElm : function() {
		var r = this.getRng();
		if(r.startContainer) {
			var contain = r.startContainer;
			if(r.cloneContents().childNodes.length == 1) {
				for(var i=0;i<contain.childNodes.length;i++) {
					var rng = contain.childNodes[i].ownerDocument.createRange();
					rng.selectNode(contain.childNodes[i]);					
					if(r.compareBoundaryPoints(Range.START_TO_START,rng) != 1 && 
						r.compareBoundaryPoints(Range.END_TO_END,rng) != -1) {
						return $BK(contain.childNodes[i]);
					}
				}
			}
			return $BK(contain);
		} else {
			return $BK((this.getSel().type == "Control") ? r.item(0) : r.parentElement());
		}
	},
	
	saveRng : function() {
		this.savedRange = this.getRng();
		this.savedSel = this.getSel();
	},
	
	restoreRng : function() {
		if(this.savedRange) {
			this.selRng(this.savedRange,this.savedSel);
		}
	},
	
	keyDown : function(e,t) {
		if(e.ctrlKey) {
			this.ne.fireEvent('key',this,e);
		}
	},
	
	selected : function(e,t) {
		if(!t) {t = this.selElm()}
		if(!e.ctrlKey) {
			var selInstance = this.ne.selectedInstance;
			if(selInstance != this) {
				if(selInstance) {
					this.ne.fireEvent('blur',selInstance,t);
				}
				this.ne.selectedInstance = this;	
				this.ne.fireEvent('focus',selInstance,t);
			}
			this.ne.fireEvent('selected',selInstance,t);
			this.isFocused = true;
			this.elm.addClass('selected');
		}
		return false;
	},
	
	blur : function() {
		this.isFocused = false;
		this.elm.removeClass('selected');
	},
	
	saveContent : function() {
		if(this.copyElm || this.options.hasPanel) {
			this.ne.fireEvent('save',this);
			(this.copyElm) ? this.copyElm.value = this.getContent() : this.e.innerHTML = this.getContent();
		}	
	},
	
	getElm : function() {
		return this.elm;
	},
	
	getContent : function() {
		this.content = this.getElm().innerHTML;
		this.ne.fireEvent('get',this);
		return this.content;
	},
	
	setContent : function(e) {
		this.content = e;
		this.ne.fireEvent('set',this);
		this.elm.innerHTML = this.content;	
	},
	
	nicCommand : function(cmd,args) {
		document.execCommand(cmd,false,args);
	}		
});

var nicEditorIFrameInstance = nicEditorInstance.extend({
	savedStyles : [],
	
	init : function() {	
		var c = this.elm.innerHTML.replace(/^\s+|\s+$/g, '');
		this.elm.innerHTML = '';
		(!c) ? c = "<br />" : c;
		this.initialContent = c;
		
		this.elmFrame = new bkElement('iframe').setAttributes({'src' : 'javascript:;', 'frameBorder' : 0, 'allowTransparency' : 'true', 'scrolling' : 'no'}).setStyle({height: '100px', width: '100%'}).addClass('frame').appendTo(this.elm);

		if(this.copyElm) { this.elmFrame.setStyle({width : (this.elm.offsetWidth-4)+'px'}); }
		
		var styleList = ['font-size','font-family','font-weight','color'];
		for(itm in styleList) {
			this.savedStyles[bkLib.camelize(itm)] = this.elm.getStyle(itm);
		}
     	
		setTimeout(this.initFrame.closure(this),50);
	},
	
	disable : function() {
		this.elm.innerHTML = this.getContent();
	},
	
	initFrame : function() {
		var fd = $BK(this.elmFrame.contentWindow.document);
		fd.designMode = "on";		
		fd.open();
		var css = this.ne.options.externalCSS;
		fd.write('<html><head>'+((css) ? '<link href="'+css+'" rel="stylesheet" type="text/css" />' : '')+'</head><body id="nicEditContent" style="margin: 0 !important; background-color: transparent !important;">'+this.initialContent+'</body></html>');
		fd.close();
		this.frameDoc = fd;

		this.frameWin = $BK(this.elmFrame.contentWindow);
		this.frameContent = $BK(this.frameWin.document.body).setStyle(this.savedStyles);
		this.instanceDoc = this.frameWin.document.defaultView;
		
		this.heightUpdate();
		this.frameDoc.addEvent('mousedown', this.selected.closureListener(this)).addEvent('keyup',this.heightUpdate.closureListener(this)).addEvent('keydown',this.keyDown.closureListener(this)).addEvent('keyup',this.selected.closure(this));
		this.ne.fireEvent('add',this);
	},
	
	getElm : function() {
		return this.frameContent;
	},
	
	setContent : function(c) {
		this.content = c;
		this.ne.fireEvent('set',this);
		this.frameContent.innerHTML = this.content;	
		this.heightUpdate();
	},
	
	getSel : function() {
		return (this.frameWin) ? this.frameWin.getSelection() : this.frameDoc.selection;
	},
	
	heightUpdate : function() {	
		this.elmFrame.style.height = Math.max(this.frameContent.offsetHeight,this.initialHeight)+'px';
	},
    
	nicCommand : function(cmd,args) {
		this.frameDoc.execCommand(cmd,false,args);
		setTimeout(this.heightUpdate.closure(this),100);
	}

	
});
var nicEditorPanel = bkClass.extend({
	construct : function(e,options,nicEditor) {
		this.elm = e;
		this.options = options;
		this.ne = nicEditor;
		this.panelButtons = new Array();
		this.buttonList = bkExtend([],this.ne.options.buttonList);
		
		this.panelContain = new bkElement('DIV').setStyle({overflow : 'hidden', width : '100%', border : '1px solid #cccccc', backgroundColor : '#efefef'}).addClass('panelContain');
		this.panelElm = new bkElement('DIV').setStyle({margin : '2px', marginTop : '0px', zoom : 1, overflow : 'hidden'}).addClass('panel').appendTo(this.panelContain);
		this.panelContain.appendTo(e);

		var opt = this.ne.options;
		var buttons = opt.buttons;
		for(button in buttons) {
				this.addButton(button,opt,true);
		}
		this.reorder();
		e.noSelect();
	},
	
	addButton : function(buttonName,options,noOrder) {
		var button = options.buttons[buttonName];
		var type = (button['type']) ? eval('(typeof('+button['type']+') == "undefined") ? null : '+button['type']+';') : nicEditorButton;
		var hasButton = bkLib.inArray(this.buttonList,buttonName);
		if(type && (hasButton || this.ne.options.fullPanel)) {
			this.panelButtons.push(new type(this.panelElm,buttonName,options,this.ne));
			if(!hasButton) {	
				this.buttonList.push(buttonName);
			}
		}
	},
	
	findButton : function(itm) {
		for(var i=0;i<this.panelButtons.length;i++) {
			if(this.panelButtons[i].name == itm)
				return this.panelButtons[i];
		}	
	},
	
	reorder : function() {
		var bl = this.buttonList;
		for(var i=0;i<bl.length;i++) {
			var button = this.findButton(bl[i]);
			if(button) {
				this.panelElm.appendChild(button.margin);
			}
		}	
	},
	
	remove : function() {
		this.elm.remove();
	}
});
var nicEditorButton = bkClass.extend({
	
	construct : function(e,buttonName,options,nicEditor) {
		this.options = options.buttons[buttonName];
		this.name = buttonName;
		this.ne = nicEditor;
		this.elm = e;

		this.margin = new bkElement('DIV').setStyle({'float' : 'left', marginTop : '2px'}).appendTo(e);
		this.contain = new bkElement('DIV').setStyle({width : '20px', height : '20px'}).addClass('buttonContain').appendTo(this.margin);
		this.border = new bkElement('DIV').setStyle({backgroundColor : '#efefef', border : '1px solid #efefef'}).appendTo(this.contain);
		this.button = new bkElement('DIV').setStyle({width : '18px', height : '18px', overflow : 'hidden', zoom : 1, cursor : 'pointer'}).addClass('button').setStyle(this.ne.getIcon(buttonName,this.options)).appendTo(this.border);
		this.button.addEvent('mouseover', this.hoverOn.closure(this)).addEvent('mouseout',this.hoverOff.closure(this)).addEvent('mousedown',this.mouseClick.closure(this)).noSelect();
		
		if(!window.opera) {
			this.button.onmousedown = this.button.onclick = bkLib.cancelEvent;
		}
		
		nicEditor.addEvent('selected', this.enable.closure(this)).addEvent('blur', this.disable.closure(this)).addEvent('key',this.key.closure(this));
		
		this.disable();
		this.init();
	},
	
	init : function() {  },
	
	hide : function() {
		this.contain.setStyle({display : 'none'});
	},
	
	updateState : function() {
		if(this.isDisabled) { this.setBg(); }
		else if(this.isHover) { this.setBg('hover'); }
		else if(this.isActive) { this.setBg('active'); }
		else { this.setBg(); }
	},
	
	setBg : function(state) {
		switch(state) {
			case 'hover':
				var stateStyle = {border : '1px solid #666', backgroundColor : '#ddd'};
				break;
			case 'active':
				var stateStyle = {border : '1px solid #666', backgroundColor : '#ccc'};
				break;
			default:
				var stateStyle = {border : '1px solid #efefef', backgroundColor : '#efefef'};	
		}
		this.border.setStyle(stateStyle).addClass('button-'+state);
	},
	
	checkNodes : function(e) {
		var elm = e;	
		do {
			if(this.options.tags && bkLib.inArray(this.options.tags,elm.nodeName)) {
				this.activate();
				return true;
			}
		} while(elm = elm.parentNode && elm.className != "nicEdit");
		elm = $BK(e);
		while(elm.nodeType == 3) {
			elm = $BK(elm.parentNode);
		}
		if(this.options.css) {
			for(itm in this.options.css) {
				if(elm.getStyle(itm,this.ne.selectedInstance.instanceDoc) == this.options.css[itm]) {
					this.activate();
					return true;
				}
			}
		}
		this.deactivate();
		return false;
	},
	
	activate : function() {
		if(!this.isDisabled) {
			this.isActive = true;
			this.updateState();	
			this.ne.fireEvent('buttonActivate',this);
		}
	},
	
	deactivate : function() {
		this.isActive = false;
		this.updateState();	
		if(!this.isDisabled) {
			this.ne.fireEvent('buttonDeactivate',this);
		}
	},
	
	enable : function(ins,t) {
		this.isDisabled = false;
		this.contain.setStyle({'opacity' : 1}).addClass('buttonEnabled');
		this.updateState();
		this.checkNodes(t);
	},
	
	disable : function(ins,t) {		
		this.isDisabled = true;
		this.contain.setStyle({'opacity' : 0.6}).removeClass('buttonEnabled');
		this.updateState();	
	},
	
	toggleActive : function() {
		(this.isActive) ? this.deactivate() : this.activate();	
	},
	
	hoverOn : function() {
		if(!this.isDisabled) {
			this.isHover = true;
			this.updateState();
			this.ne.fireEvent("buttonOver",this);
		}
	}, 
	
	hoverOff : function() {
		this.isHover = false;
		this.updateState();
		this.ne.fireEvent("buttonOut",this);
	},
	
	mouseClick : function() {
		if(this.options.command) {
			this.ne.nicCommand(this.options.command,this.options.commandArgs);
			if(!this.options.noActive) {
				this.toggleActive();
			}
		}
		this.ne.fireEvent("buttonClick",this);
	},
	
	key : function(nicInstance,e) {
		if(this.options.key && e.ctrlKey && String.fromCharCode(e.keyCode || e.charCode).toLowerCase() == this.options.key) {
			this.mouseClick();
			if(e.preventDefault) e.preventDefault();
		}
	}
	
});

 
var nicPlugin = bkClass.extend({
	
	construct : function(nicEditor,options) {
		this.options = options;
		this.ne = nicEditor;
		this.ne.addEvent('panel',this.loadPanel.closure(this));
		
		this.init();
	},

	loadPanel : function(np) {
		var buttons = this.options.buttons;
		for(var button in buttons) {
			np.addButton(button,this.options);
		}
		np.reorder();
	},

	init : function() {  }
});



 
 /* START CONFIG */
var nicPaneOptions = { };
/* END CONFIG */

var nicEditorPane = bkClass.extend({
	construct : function(elm,nicEditor,options,openButton) {
		this.ne = nicEditor;
		this.elm = elm;
		this.pos = elm.pos();
		
		this.contain = new bkElement('div').setStyle({zIndex : '99999', overflow : 'hidden', position : 'absolute', left : this.pos[0]+'px', top : this.pos[1]+'px'})
		this.pane = new bkElement('div').setStyle({fontSize : '12px', border : '1px solid #ccc', 'overflow': 'hidden', padding : '4px', textAlign: 'left', backgroundColor : '#ffffc9'}).addClass('pane').setStyle(options).appendTo(this.contain);
		
		if(openButton && !openButton.options.noClose) {
			this.close = new bkElement('div').setStyle({'float' : 'right', height: '16px', width : '16px', cursor : 'pointer'}).setStyle(this.ne.getIcon('close',nicPaneOptions)).addEvent('mousedown',openButton.removePane.closure(this)).appendTo(this.pane);
		}
		
		this.contain.noSelect().appendTo(document.body);
		
		this.position();
		this.init();	
	},
	
	init : function() { },
	
	position : function() {
		if(this.ne.nicPanel) {
			var panelElm = this.ne.nicPanel.elm;	
			var panelPos = panelElm.pos();
			var newLeft = panelPos[0]+parseInt(panelElm.getStyle('width'))-(parseInt(this.pane.getStyle('width'))+8);
			if(newLeft < this.pos[0]) {
				this.contain.setStyle({left : newLeft+'px'});
			}
		}
	},
	
	toggle : function() {
		this.isVisible = !this.isVisible;
		this.contain.setStyle({display : ((this.isVisible) ? 'block' : 'none')});
	},
	
	remove : function() {
		if(this.contain) {
			this.contain.remove();
			this.contain = null;
		}
	},
	
	append : function(c) {
		c.appendTo(this.pane);
	},
	
	setContent : function(c) {
		this.pane.setContent(c);
	}
	
});


 
var nicEditorAdvancedButton = nicEditorButton.extend({
	
	init : function() {
		this.ne.addEvent('selected',this.removePane.closure(this)).addEvent('blur',this.removePane.closure(this));	
	},
	
	mouseClick : function() {
		if(!this.isDisabled) {
			if(this.pane && this.pane.pane) {
				this.removePane();
			} else {
				this.pane = new nicEditorPane(this.contain,this.ne,{width : (this.width || '270px'), backgroundColor : '#fff'},this);
				this.addPane();
				this.ne.selectedInstance.saveRng();
			}
		}
	},
	
	addForm : function(f,elm) {
		this.form = new bkElement('form').addEvent('submit',this.submit.closureListener(this));
		this.pane.append(this.form);
		this.inputs = {};
		
		for(itm in f) {
			var field = f[itm];
			var val = '';
			if(elm) {
				val = elm.getAttribute(itm);
			}
			if(!val) {
				val = field['value'] || '';
			}
			var type = f[itm].type;
			
			if(type == 'title') {
					new bkElement('div').setContent(field.txt).setStyle({fontSize : '14px', fontWeight: 'bold', padding : '0px', margin : '2px 0'}).appendTo(this.form);
			} else {
				var contain = new bkElement('div').setStyle({overflow : 'hidden', clear : 'both'}).appendTo(this.form);
				if(field.txt) {
					new bkElement('label').setAttributes({'for' : itm}).setContent(field.txt).setStyle({margin : '2px 4px', fontSize : '13px', width: '50px', lineHeight : '20px', textAlign : 'right', 'float' : 'left'}).appendTo(contain);
				}
				
				switch(type) {
					case 'text':
						this.inputs[itm] = new bkElement('input').setAttributes({id : itm, 'value' : val, 'type' : 'text'}).setStyle({margin : '2px 0', fontSize : '13px', 'float' : 'left', height : '20px', border : '1px solid #ccc', overflow : 'hidden'}).setStyle(field.style).appendTo(contain);
						break;
					case 'select':
						this.inputs[itm] = new bkElement('select').setAttributes({id : itm}).setStyle({border : '1px solid #ccc', 'float' : 'left', margin : '2px 0'}).appendTo(contain);
						for(opt in field.options) {
							var o = new bkElement('option').setAttributes({value : opt, selected : (opt == val) ? 'selected' : ''}).setContent(field.options[opt]).appendTo(this.inputs[itm]);
						}
						break;
					case 'content':
						this.inputs[itm] = new bkElement('textarea').setAttributes({id : itm}).setStyle({border : '1px solid #ccc', 'float' : 'left'}).setStyle(field.style).appendTo(contain);
						this.inputs[itm].value = val;
				}	
			}
		}
		new bkElement('input').setAttributes({'type' : 'submit', 'value' : '提交'}).setStyle({backgroundColor : '#efefef',border : '1px solid #ccc', margin : '3px 0', 'float' : 'left', 'clear' : 'both'}).appendTo(this.form);
		this.form.onsubmit = bkLib.cancelEvent;	
	},
	
	submit : function() { },
	
	findElm : function(tag,attr,val) {
		var list = this.ne.selectedInstance.getElm().getElementsByTagName(tag);
		for(var i=0;i<list.length;i++) {
			if(list[i].getAttribute(attr) == val) {
				return $BK(list[i]);
			}
		}
	},
	
	removePane : function() {
		if(this.pane) {
			this.pane.remove();
			this.pane = null;
			this.ne.selectedInstance.restoreRng();
		}	
	}	
});


var nicButtonTips = bkClass.extend({
	construct : function(nicEditor) {
		this.ne = nicEditor;
		nicEditor.addEvent('buttonOver',this.show.closure(this)).addEvent('buttonOut',this.hide.closure(this));

	},
	
	show : function(button) {
		this.timer = setTimeout(this.create.closure(this,button),400);
	},
	
	create : function(button) {
		this.timer = null;
		if(!this.pane) {
			this.pane = new nicEditorPane(button.button,this.ne,{fontSize : '12px', marginTop : '5px'});
			this.pane.setContent(button.options.name);
		}		
	},
	
	hide : function(button) {
		if(this.timer) {
			clearTimeout(this.timer);
		}
		if(this.pane) {
			this.pane = this.pane.remove();
		}
	}
});
nicEditors.registerPlugin(nicButtonTips);


 
 /* START CONFIG */
var nicSelectOptions = {
	buttons : {
		'fontSize' : {name : __('大小'), type : 'nicEditorFontSizeSelect', command : 'fontsize'},
		'fontFamily' : {name : __('字体'), type : 'nicEditorFontFamilySelect', command : 'fontname'},
		'fontFormat' : {name : __('字体格式'), type : 'nicEditorFontFormatSelect', command : 'formatBlock'}
	}
};
/* END CONFIG */
var nicEditorSelect = bkClass.extend({
	
	construct : function(e,buttonName,options,nicEditor) {
		this.options = options.buttons[buttonName];
		this.elm = e;
		this.ne = nicEditor;
		this.name = buttonName;
		this.selOptions = new Array();
		
		this.margin = new bkElement('div').setStyle({'float' : 'left', margin : '2px 1px 0 1px'}).appendTo(this.elm);
		this.contain = new bkElement('div').setStyle({width: '90px', height : '20px', cursor : 'pointer', overflow: 'hidden'}).addClass('selectContain').addEvent('click',this.toggle.closure(this)).appendTo(this.margin);
		this.items = new bkElement('div').setStyle({overflow : 'hidden', zoom : 1, border: '1px solid #ccc', paddingLeft : '3px', backgroundColor : '#fff'}).appendTo(this.contain);
		this.control = new bkElement('div').setStyle({overflow : 'hidden', 'float' : 'right', height: '18px', width : '16px'}).addClass('selectControl').setStyle(this.ne.getIcon('arrow',options)).appendTo(this.items);
		this.txt = new bkElement('div').setStyle({overflow : 'hidden', 'float' : 'left', width : '66px', height : '14px', marginTop : '1px', fontFamily : 'sans-serif', textAlign : 'center', fontSize : '12px'}).addClass('selectTxt').appendTo(this.items);
		
		if(!window.opera) {
			this.contain.onmousedown = this.control.onmousedown = this.txt.onmousedown = bkLib.cancelEvent;
		}
		
		this.margin.noSelect();
		
		this.ne.addEvent('selected', this.enable.closure(this)).addEvent('blur', this.disable.closure(this));
		
		this.disable();
		this.init();
	},
	
	disable : function() {
		this.isDisabled = true;
		this.close();
		this.contain.setStyle({opacity : 0.6});
	},
	
	enable : function(t) {
		this.isDisabled = false;
		this.close();
		this.contain.setStyle({opacity : 1});
	},
	
	setDisplay : function(txt) {
		this.txt.setContent(txt);
	},
	
	toggle : function() {
		if(!this.isDisabled) {
			(this.pane) ? this.close() : this.open();
		}
	},
	
	open : function() {
		this.pane = new nicEditorPane(this.items,this.ne,{width : '88px', padding: '0px', borderTop : 0, borderLeft : '1px solid #ccc', borderRight : '1px solid #ccc', borderBottom : '0px', backgroundColor : '#fff'});
		
		for(var i=0;i<this.selOptions.length;i++) {
			var opt = this.selOptions[i];
			var itmContain = new bkElement('div').setStyle({overflow : 'hidden', borderBottom : '1px solid #ccc', width: '88px', textAlign : 'left', overflow : 'hidden', cursor : 'pointer'});
			var itm = new bkElement('div').setStyle({padding : '0px 4px'}).setContent(opt[1]).appendTo(itmContain).noSelect();
			itm.addEvent('click',this.update.closure(this,opt[0])).addEvent('mouseover',this.over.closure(this,itm)).addEvent('mouseout',this.out.closure(this,itm)).setAttributes('id',opt[0]);
			this.pane.append(itmContain);
			if(!window.opera) {
				itm.onmousedown = bkLib.cancelEvent;
			}
		}
	},
	
	close : function() {
		if(this.pane) {
			this.pane = this.pane.remove();
		}	
	},
	
	over : function(opt) {
		opt.setStyle({backgroundColor : '#ccc'});			
	},
	
	out : function(opt) {
		opt.setStyle({backgroundColor : '#fff'});
	},
	
	
	add : function(k,v) {
		this.selOptions.push(new Array(k,v));	
	},
	
	update : function(elm) {
		this.ne.nicCommand(this.options.command,elm);
		this.close();	
	}
});

var nicEditorFontSizeSelect = nicEditorSelect.extend({
sel : {2 : '10pt', 3 : '12pt', 4 : '14pt', 5 : '18pt', 6 : '24pt', 7 : '36pt'},
	init : function() {
		this.setDisplay('大小');
		for(itm in this.sel) {
			this.add(itm,'<font size="'+itm+'">'+this.sel[itm]+'</font>');
		}		
	}
});

var nicEditorFontFamilySelect = nicEditorSelect.extend({
sel : {'宋体' : '宋体', '楷体' : '楷体', '黑体' : '黑体', '隶书' : '隶书', 'arial' : 'Arial', 'times new roman' : 'Times'},
	
	init : function() {
		this.setDisplay('字体');
		for(itm in this.sel) {
			this.add(itm,'<font face="'+itm+'">'+this.sel[itm]+'</font>');
		}
	}
});

var nicEditorFontFormatSelect = nicEditorSelect.extend({
		sel : {'p' : '段落', 'pre' : '无格式', 'h6' : '标题6', 'h5' : '标题5', 'h4' : '标题4', 'h3' : '标题3', 'h2' : '标题2', 'h1' : '标题1'},
		
	init : function() {
		this.setDisplay('格式');
		for(itm in this.sel) {
			var tag = itm.toUpperCase();
			this.add('<'+tag+'>','<'+itm+' style="padding: 0px; margin: 0px;">'+this.sel[itm]+'</'+tag+'>');
		}
	}
});

nicEditors.registerPlugin(nicPlugin,nicSelectOptions);



/* START CONFIG */
var nicLinkOptions = {
	buttons : {
		'link' : {name : '添加链接', type : 'nicLinkButton', tags : ['A']},
		'unlink' : {name : '移除链接',  command : 'unlink', noActive : true}
	}
};
/* END CONFIG */

var nicLinkButton = nicEditorAdvancedButton.extend({

  paneHTML: "<div class='z-box'><div class='z-t'> \
        <span class='l'><strong></strong></span> \
        <span class='r'></span> \
        </div> \
        <div class='z-m rows s_clear'> \
            <div class='box01 s_clear'> \
                <p class='z-h'>插入编辑链接</p> \
                <div class='z-con'> \
                    <div class='content'> \
                      <div class='formcontent'>  \
                            <div class='rows s_clear'> \
                              <div class='fldid'><label>链接地址：</label></div> \
                              <div class='fldvalue'> \
                                <div style='width: 150px;' class='textfield'><input type='text' size='30' value='' id='nicEdit-link-url-field'></div> \
                              </div> \
                            </div> \
                            <div class='rows s_clear'> \
                              <div class='fldid'><label>位置：</label></div> \
                              <div class='fldvalue' class='textfield'> \
                                  <select id='nicEdit-link-open-scheme'> \
                                    <option value=''>在当前窗口打开</option> \
                                    <option value='_blank'>在新窗口打开</option> \
                                  </select> \
                            </div> \
                         </div> \
                    </div> \
                    <div class='rows'></div> \
                    </div> \
                        <div class='z-submit s_clear space'> \
                            <div class='buttons'> \
                                 <span class='button'><span><button type='submit' id='nicEdit-link-submit'>插入</button></span></span> \
                                 <span class='button button-gray'><span><button type='reset' id='nicEdit-link-cancel'>取消</button></span></span> \
                            </div> \
                    </div> \
                </div> \
            </div> \
            <div class='bg'></div> \
        </div> \
        <div class='z-b'> \
        <span class='l'><strong></strong></span> \
        <span class='r'></span> \
        </div> \
    </div></div>",
  
  addPane : function() {
    var scroll = document.viewport.getScrollOffsets();
    var height = document.viewport.getHeight();
    var width = document.viewport.getWidth();

    this.pane.contain.setStyle({'width' : '350px', 'overflow' : 'hidden', 'position' : 'absolute', 'top' : (height/3 + scroll.top) + 'px', 'left' : (width/2 - 175) + 'px', 'z-index' : '9999'});
    this.pane.pane.setStyle({'width':'350px', 'border' : 'none', 'padding' : '0px'});
    this.pane.close.remove();
    this.pane.close = null;

    this.ln = this.ne.selectedInstance.selElm().parentTag('A');
    this.pane.setContent(this.paneHTML);
    $BK('nicEdit-link-submit').addEvent('click', function(){
      this.url = $BK('nicEdit-link-url-field').value;
      this.scheme = $BK('nicEdit-link-open-scheme').value;
      this.submit();
    }.closure(this));
    $BK('nicEdit-link-cancel').addEvent('click', function(){
      this.removePane();
    }.closure(this));
  },
	
	submit : function(e) {
		var url = this.url;
    var scheme = this.scheme;

		if(url == "http://" || url == "") {
			alert("请输入合法的URL");
			return false;
		}
		this.removePane();
		
		if(!this.ln) {
			var tmp = 'javascript:nicTemp();';
			this.ne.nicCommand("createlink",tmp);
			this.ln = this.findElm('A','href',tmp);
		}
		if(this.ln) {
			this.ln.setAttributes({
				href : url,
				target : scheme
			});
		}
	}
});

nicEditors.registerPlugin(nicPlugin,nicLinkOptions);



/* START CONFIG */
var nicColorOptions = {
	buttons : {
		'forecolor' : {name : __('选择文字颜色'), type : 'nicEditorColorButton', noClose : true},
		'bgcolor' : {name : __('选择背景颜色'), type : 'nicEditorBgColorButton', noClose : true}
	}
};
/* END CONFIG */

var nicEditorColorButton = nicEditorAdvancedButton.extend({	
	addPane : function() {
			var colorList = {0 : '00',1 : '33',2 : '66',3 :'99',4 : 'CC',5 : 'FF'};
			var colorItems = new bkElement('DIV').setStyle({width: '270px'});
			
			for(var r in colorList) {
				for(var b in colorList) {
					for(var g in colorList) {
						var colorCode = '#'+colorList[r]+colorList[g]+colorList[b];
						
						var colorSquare = new bkElement('DIV').setStyle({'cursor' : 'pointer', 'height' : '15px', 'float' : 'left'}).appendTo(colorItems);
						var colorBorder = new bkElement('DIV').setStyle({border: '2px solid '+colorCode}).appendTo(colorSquare);
						var colorInner = new bkElement('DIV').setStyle({backgroundColor : colorCode, overflow : 'hidden', width : '11px', height : '11px'}).addEvent('click',this.colorSelect.closure(this,colorCode)).addEvent('mouseover',this.on.closure(this,colorBorder)).addEvent('mouseout',this.off.closure(this,colorBorder,colorCode)).appendTo(colorBorder);
						
						if(!window.opera) {
							colorSquare.onmousedown = colorInner.onmousedown = bkLib.cancelEvent;
						}

					}	
				}	
			}
			this.pane.append(colorItems.noSelect());
	},
	
	colorSelect : function(c) {
		this.ne.nicCommand('foreColor',c);
		this.removePane();
	},
	
	on : function(colorBorder) {
		colorBorder.setStyle({border : '2px solid #000'});
	},
	
	off : function(colorBorder,colorCode) {
		colorBorder.setStyle({border : '2px solid '+colorCode});		
	}
});

var nicEditorBgColorButton = nicEditorColorButton.extend({
	colorSelect : function(c) {
    if (navigator.userAgent.indexOf('MSIE') > 0) {
      this.ne.nicCommand('BackColor', c);
    }
    else {
		  this.ne.nicCommand('hiliteColor',c);
    }
		this.removePane();
	}	
});

nicEditors.registerPlugin(nicPlugin,nicColorOptions);



/* START CONFIG */
var nicImageOptions = {
	buttons : {
		'image' : {name : '添加图片', type : 'nicImageButton', tags : ['IMG']}
	}
};
/* END CONFIG */

/* 考虑到一页可能有多个nicEditors，然后每个nicEditor都应该共享这一个变量，所以这样设置了 */
nicEditors.albums = [];

/* authenticity token， 考虑到一页可能有多个nicEditors, 每个nicEditor应该能共享这一个token */
nicEditors.authenticityToken = null;

var nicImageButton = nicEditorAdvancedButton.extend({

  paneHTML: "<div class='z-t'> \
        <span class='l'><strong></strong></span> \
        <span class='r'></span> \
        </div> \
        <div class='z-m rows s_clear'> \
            <div class='box01 s_clear'> \
                <p class='z-h'>插入图片</p> \
                <div class='z-con'> \
                    <div class='content'> \
                    		<div class='tab tab01'> \
                            <ul> \
                                <li><span><a href='javascript: void(0)' id='local_image_tab'>上传照片</a></span></li> \
                                <li class='hover'><span><a href='javascript: void(0)' id='url_image_tab'>网络照片</a></span></li> \
                                <li><span><a href='javascript: void(0)' id='album_image_tab'>相册照片</a></span></li> \
                 			      </ul> \
                        </div> \
                      <div class='formcontent' id='local_image_frame' style='display:none'> \
                          <form action='/blog_images' id='upload_image_form' enctype='multipart/form-data' method='post' target='upload_iframe'> \
                            <input type='hidden' value='' name='authenticity_token' id='authenticity_token_field'/> \
                            <div class='rows s_clear'> \
                              <div class='fldid'><label>上传本地图片：</label></div> \
                              <div class='fldvalue'> \
                                <input id='photo_uploaded_data' name='photo[uploaded_data]' size='20' type='file' />\
                              </div> \
                            </div> \
                          </form>\
                          <iframe id='upload_iframe' name='upload_iframe' style='border: 0px none ; width: 1px; height: 1px;' src='about:blank'></iframe> \
                      </div> \
                    	<div class='formcontent' id='url_image_frame'>	 \
                          <div class='rows s_clear'> \
                              <div class='fldid'><label>连接地址：</label></div> \
                              <div class='fldvalue'> \
                                <div style='width: 150px;' class='textfield'><input type='text' size='30' value='' id='image_url_field' /></div> \
                              </div> \
                          </div> \
                      </div> \
                      <div class='space' id='album_image_frame' style='display:none'>\
                               选择 <select id='album_selector'><option value=''>---</option></select> 专辑内的图片\
                                 <div class='blog-ins-imglist'> \
                                  <ul id='album_images_list'></ul>\
                                 </div> \
                         </div>\
                    </div> \
                    <div class='rows'></div> \
                        <div class='z-submit s_clear space'> \
                            <div class='buttons'> \
                                 <span class='button'><span><button type='submit' id='image_submit_btn'>插入</button></span></span> \
                                 <span class='button button-gray'><span><button type='reset' id='image_cancel'>取消</button></span></span> \
                            </div> \
                    </div> \
                </div> \
            </div> \
            <div class='bg'></div> \
        </div> \
        <div class='z-b'> \
        <span class='l'><strong></strong></span> \
        <span class='r'></span> \
        </div> \
    </div>",

  currentTab : null,

  selectedPhotos: [], // this is only used for album images,

  clickTab : function(type){
    this.currentTab = type;
    $BK('local_image_tab').up().up().setStyle({'className' : ''});
    $BK('url_image_tab').up().up().setStyle({'className' : ''});
    $BK('album_image_tab').up().up().setStyle({'className' : ''});
    $BK(type + '_tab').up().up().setStyle({'className' : 'hover'});
    $BK('local_image_frame').hide();
    $BK('url_image_frame').hide();
    $BK('album_image_frame').hide();
    $BK(type + '_frame').show();
  },

  addPane : function() {
    nicImageButton.lastPlugin = this;

    var scroll = document.viewport.getScrollOffsets();
    var height = document.viewport.getHeight();
    var width = document.viewport.getWidth();

    var zBox = new bkElement('div').setStyle({'className': 'z-box', 'width': '450px'});
    zBox.innerHTML = this.paneHTML;

    this.pane.contain.setStyle({'width' : '450px', 'overflow' : 'hidden', 'position' : 'absolute', 'top' : (height/3 + scroll.top) + 'px', 'left' : (width/2 - 225) + 'px', 'z-index' : '9999'});
    this.pane.pane.setStyle({'width':'450px', 'border' : 'none', 'padding' : '0px'});
    this.pane.close.remove();
    this.pane.close = null;
    this.pane.append(zBox.noSelect());

    this.currentTab = 'url_image';

    // set token
    $BK('authenticity_token_field').value = nicEditors.authenticityToken;

    // set album selector
    for(var i=0;i<nicEditors.albums.length;i++){
      var album = nicEditors.albums[i];
      var option = new bkElement('option');
      option.innerHTML = (album.title);
      option.setAttributes({'value': album.id});
      $BK('album_selector').appendChild(option);
    }
    
    // set album selector event
    $BK('album_selector').addEvent('change', function(){
      var albumID = $BK('album_selector').value;
      // send ajax request
      // 这个东西很2比，因为用的是prototype的东西，和我的初衷“尽量在nicEditor里不用prototype”不符合
      // 但也没办法，先将就一下
      var type;
      for(var i=0;i<nicEditors.albums.length;i++){
        if(albumID == nicEditors.albums[i].id){
          type = nicEditors.albums[i].type;
          break;
        }
      }
      new Ajax.Request('/' + type + 's/' + albumID + '.json', {
        method: 'get',
        onLoading: function(){
          Iyxzone.changeCursor('wait');
        },
        onComplete: function(){
          Iyxzone.changeCursor('default');
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          var ul = $BK('album_images_list');
          ul.innerHTML = '';
          if(json.length == 0){
            var li = new bkElement('li');
            li.innerHTML = '没有照片';
            ul.appendChild(li);
            return;
          }
          for(var i=0;i<json.length;i++){
            var path = json[i];
            var li = new bkElement('li');
            var img = new bkElement('img').setStyle({'className': 'imgbox02'}).setAttributes({'src': path, 'width': 75, 'height': 75});
            img.appendTo(li);
            ul.appendChild(li);
            img.addEvent('click', function(e){
              var img = bkLib.eventTarget(e);
              var src = img.src;
              var li = img.up();
              if(this.selectedPhotos.include(src)){
                li.setStyle({'className': ''});
                this.selectedPhotos.splice(this.selectedPhotos.indexOf(src), 1);
              }else{
                li.setStyle({'className': 'selected'});
                this.selectedPhotos.push(src);
              }
            }.closure(this));
          }
        }.bind(this)
      });
    }.closure(this));
  
    // set tab events
    $BK('local_image_tab').addEvent('click', function(){
      this.clickTab('local_image');
      return false;
    }.closure(this));
    $BK('url_image_tab').addEvent('click', function(){
      this.clickTab('url_image');
      return false;
    }.closure(this));
    $BK('album_image_tab').addEvent('click', function(){
      this.clickTab('album_image');
      return false;
    }.closure(this));  

    // set submit/cancel event
    $BK('image_submit_btn').addEvent('click', function(){
      if(this.currentTab == 'url_image'){
        this.src = $BK('image_url_field').value;
        this.removePane(); // 必须先removePane(), 然后selElm().parentTag('IMG')才能找到争取的tag
        this.im = this.ne.selectedInstance.selElm().parentTag('IMG');
        this.submit();
      }else if(this.currentTab == 'local_image'){
        $BK('upload_image_form').submit();
        this.im = this.ne.selectedInstance.selElm().parentTag('IMG');
      }else if(this.currentTab == 'album_image'){
        for(var i=0;i<this.selectedPhotos.length;i++){
          this.src = this.selectedPhotos[i];
          this.im = this.ne.selectedInstance.selElm().parentTag('IMG');
          this.submit();
        }
        this.removePane();
        this.selectedPhotos = [];
      }
    }.closure(this));
    $BK('image_cancel').addEvent('click', function(){
      this.removePane();
    }.closure(this));
	},
	
	submit : function(e) {
    var src = this.src; 
		if(src == "" || src == "http://") {
			alert("你必须插入一个图片的链接地址");
			return false;
		}

		if(!this.im) {
			var tmp = 'javascript:nicImTemp();';
			this.ne.nicCommand("insertImage",tmp);
			this.im = this.findElm('IMG','src',tmp);
		}
		if(this.im) {
			this.im.setAttributes({
				src : src
	//		,	alt : this.inputs['alt'].value,
	//			align : this.inputs['align'].value
			});
		}
	},

  // 这个函数是服务器那边调用的，可以告诉这里什么时候上传结束
  update: function(o){
    if(o.url) {
      if(!this.im) {
        this.ne.selectedInstance.restoreRng();
        var tmp = 'javascript:nicImTemp();';
        this.ne.nicCommand("insertImage",tmp);
        this.im = this.findElm('IMG','src',tmp);
      }
      if(this.im) {
        this.im.setAttributes({
          src : o.url,
          width : (o.width) ? o.width : ''
        });
      }
      this.removePane();
    } 
  }

});

nicEditors.registerPlugin(nicPlugin,nicImageOptions);

nicImageButton.statusCb = function(o) {
  nicImageButton.lastPlugin.update(o);
}

/* START CONFIG */
var nicSaveOptions = {
	buttons : {
		'save' : {name : __('保存内容'), type : 'nicEditorSaveButton'}
	}
};
/* END CONFIG */

var nicEditorSaveButton = nicEditorButton.extend({
	init : function() {
		if(!this.ne.options.onSave) {
			this.margin.setStyle({'display' : 'none'});
		}
	},
	mouseClick : function() {
		var onSave = this.ne.options.onSave;
		var selectedInstance = this.ne.selectedInstance;
		onSave(selectedInstance.getContent(), selectedInstance.elm.id, selectedInstance);
	}
});

nicEditors.registerPlugin(nicPlugin,nicSaveOptions);


/*
 * emotion button
 */

var nicEmotionOptions = {
	buttons : {
		'emotion' : {name : '添加表情', type : 'nicEmotionButton'} 
	}
	
};

var nicEmotionButton = nicEditorAdvancedButton.extend({

  symbols: [ '[惊吓]', '[晕]', '[流鼻涕]', '[挖鼻子]', '[鼓掌]', '[骷髅]', '[坏笑]', '[傲慢]', '[大哭]', '[砸头]', '[衰]', '[哭]', '[可爱]', '[冷汗]', '[抽烟]', '[擦汗]', '[亲亲]', '[糗]', '[吃惊]', '[左哼哼]', '[疑问]', '[惊恐]', '[睡觉]', '[皱眉头]', '[可怜]', '[打呵欠]', '[害羞]', '[花痴]', '[右哼哼]', '[囧]', '[大便]', '[咒骂]', '[贼笑]', '[嘘]', '[吐]', '[苦恼]', '[白眼]', '[流汗]', '[大笑]', '[羞]', '[撇嘴]', '[偷笑]', '[BS]', '[困]', '[火]', '[闭嘴]', '[抓狂]', '[强]', '[不行]', '[装酷]' ], 

  buildFaces: function(){
    var zBox = new bkElement('div').setStyle({'className': 'z-box', 'width': '400px', 'overflow': 'hidden'});
    
    var zt = new bkElement('div').setStyle({'className': 'z-t'});
    zt.innerHTML = '<span class="l"><strong></strong></span><span class="r"></span>';
    
    var zm = new bkElement('div').setStyle({'className': 'z-m rows s_clear'});
    var box01 = new bkElement('div').setStyle({'className': 'box01 s_clear'});
    var p = new bkElement('p').setStyle({'className': 'z-h'});
    p.innerHTML = ('插入表情');
    var zcon = new bkElement('div').setStyle({'className': 'z-con'});
    var content = new bkElement('div').setStyle({'className': 'content'});
    var emotBox = new bkElement('div').setStyle({'className': 'emot-box'});
    var bg = new bkElement('div').setStyle({'className': 'bg'}); 
    content.appendChild(emotBox);
    zcon.appendChild(content);
    box01.appendChild(p);
    box01.appendChild(zcon);
    zm.appendChild(box01);
    zm.appendChild(bg);

    var len = this.symbols.length;
    var symbols = this.symbols;
    var perPage = this.facesPerPage;
    var div = new bkElement('DIV').setStyle({'className' : 'con'});
    for(var i = 0; i < len; i++){
      a = new bkElement('a').setAttributes({title: symbols[i], href: 'javascript: void(0)'});
      img = new bkElement('img').setAttributes({src: "/images/faces/"+ symbols[i].slice(1,symbols[i].length-1) +".gif",  alt: symbols[i]});
      img.appendTo(a);
      a.addEvent('click', function(e){
        var url = bkLib.eventTarget(e).getAttribute('src');
        if(!this.im){
          var tmp = 'javascript:nicImTemp();';
          this.ne.nicCommand("insertImage", tmp);
          this.im = this.findElm('IMG','src',tmp);
        }
        this.im.setAttributes( {src: url});
        this.removePane();
        this.ne.nicCommand("Unselect",this.im);
        return false; // 如果没有，在IE6下会触发onbeforeunload
      }.closure(this));
      a.appendTo(div);
    }
    var foot = new bkElement('div').setStyle({'className': 'pager-simple foot'});
    div.appendChild(foot);
    emotBox.appendChild(div);

    var zb = new bkElement('div').setStyle({'className': 'z-b'});
    zb.innerHTML = '<span class="l"><strong></strong></span>';
    
    zBox.appendChild(zt);
    zBox.appendChild(zm);
    zBox.appendChild(zb);

    return zBox;    
  },

	addPane : function(){
    var scroll = document.viewport.getScrollOffsets();
    var height = document.viewport.getHeight();
    var width = document.viewport.getWidth();

    var zBox = this.buildFaces();
    
    this.pane.contain.setStyle({'width' : '400px', 'overflow' : 'hidden', 'position' : 'absolute', 'top' : (height/3 + scroll.top) + 'px', 'left' : (width/2 - 165) + 'px', 'z-index' : '9999'});
    this.pane.pane.setStyle({'width':'400px', 'border' : 'none', 'padding' : '0px'});
    this.pane.close.remove();
    this.pane.close = null;//将pane上面叉号去掉
    this.pane.append(zBox.noSelect());

    this.im = this.ne.selectedInstance.selElm().parentTag('IMG');
    //$BK('nicEdit-emot-box').appendChild(this.buildFaces());
	}
});

nicEditors.registerPlugin(nicPlugin,nicEmotionOptions);
