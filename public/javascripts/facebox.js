var Facebox = Class.create({
	
  initialize: function(extra_set){
		this.settings = {
			loading_image	: '/images/loading.gif',
			image_types		: new RegExp('\.' + ['png', 'jpg', 'jpeg', 'gif'].join('|') + '$', 'i'),
			inited				: true,	
			facebox_html	: '<div id="facebox" class="box05" style="display:none;"></div>'
		};
		if (extra_set) Object.extend(this.settings, extra_set);
		$(document.body).insert({bottom: this.settings.facebox_html});
	
		this.preload = [];
		this.loading_image = new Image();
		this.loading_image.src = this.settings.loading_image;	
		
		this.facebox = $('facebox');
    this.keyPressListener = this.watchKeyPress.bindAsEventListener(this);
		
		this.watchClickEvents();
		fb = this;
	},
	
  watchKeyPress: function(e){
		// Close if espace is pressed or if there's a click outside of the facebox
		if (e.keyCode == 27 || !Event.element(e).descendantOf(this.facebox)) this.close();
  },
	
	watchClickEvents: function(){
		var f = this;
		$$('a[rel=facebox]').each(function(elem,i){
			Event.observe(elem, 'click', function(e){
				Event.stop(e);
				f.click_handler(elem, e);
			});
		});
	},

	watchClickEvent: function(elem){
		var f = this;		
		Event.observe(elem, 'click', function(e){
			Event.stop(e);
			f.click_handler(elem, e);
		});
	},
	
	loading: function() {
		if ($$('#facebox .loading').length == 1) return true;
		
		this.facebox.innerHTML = '<div class="loading"><img src="'+this.loading_image.src+'"/></div>';
		
		var pageScroll = document.viewport.getScrollOffsets();
		this.facebox.setStyle({
      position: 'absolute',
			top: pageScroll.top + (document.viewport.getHeight()/4) + 'px',
			left: document.viewport.getWidth() / 2 - (this.facebox.getWidth() / 2) + 'px',
		});
    	
    if(!this.facebox.visible())
      new Effect.Appear(this.facebox, {duration: 0.3});
	
		//Event.observe(document, 'keypress', this.keyPressListener);
    //Event.observe(document, 'click', this.keyPressListener);
	},
	
	remove_loading: function(){
		//this.loading();
		load = $$('#facebox .loading').first();
		if(load) load.remove();
	},

	locate: function(){
		var pageScroll = document.viewport.getScrollOffsets();
		this.facebox.setStyle({
      position:'absolute',
			top: pageScroll.top + (document.viewport.getHeight() / 5) + 'px',
			left: document.viewport.getWidth() / 2 - (this.facebox.getWidth() / 2) + 'px'
		});
	},

	set_content: function(data, klass){
		bodyWrapper = $('facebox'); 
		if(klass) bodyWrapper.addClassName(klass);
		bodyWrapper.innerHTML = data;
    		
		if(!this.facebox.visible()) 
			new Effect.Appear(this.facebox, {duration: 0.3});
	},

	reveal: function(data, klass){
		this.remove_loading();
		this.set_content(data, klass);
		this.locate();
    
		//Event.observe(document, 'keypress', this.keyPressListener);
    //Event.observe(document, 'click', this.keyPressListener);
	},

	show_tip: function(info){
		var html = "<div class='title01'><a class='icon-active icon-active-close' href='#' onclick='facebox.close();'></a><h1>提示</h1></div>";
    html += "<div class='formcontent'>" + info + "</div>";
    this.remove_loading();
    this.set_content(html);
    this.locate();
	},

  show_notice: function(info){
		var html = "<div class='title01'><a class='icon-active icon-active-close' href='#' onclick='facebox.close();'></a><h1>提示</h1></div>";
    html += "<div class='formcontent'>" + info + "</div>";
 		this.remove_loading();
		this.set_content(html);
		this.locate();
    setTimeout("facebox.close();", 3000);
  },

  show_error: function(info){
    var html = "<div class='title01'><a class='icon-active icon-active-close' href='#' onclick='facebox.close();'></a><h1>错误提示</h1></div>";
    html += "<div class='formcontent'>" + info + "</div>";
		this.remove_loading();
		this.set_content(html);
		this.locate();
    setTimeout("facebox.close();",3000);
  },

	show_confirm: function(confirm_message, url, token, method){
    var html = "<div class='title01'><a class='icon-active icon-active-close' href='#' onclick='facebox.close();'></a><h1>请确认</h1></div>";
    html += "<div class='formcontent'>" + confirm_message + "</div>";
    html += "<div class='buttons s_clear'><table class='center' cellpadding='0'><tr><td><span class='button'><span><button type='submit' onclick=\"new Ajax.Request('" + url +"', {parameters: 'authenticity_token=" + token + "', method: '" + method + "'});\">完成</button></span></span><span class='button button-gray'><span><button type='button' onclick='facebox.close();'>取消</button></span></span></td></tr></table></div>";
		this.remove_loading();
		this.set_content(html);
		this.locate();
	},

	generate_validate_code: function(digits){
    this.codes = new Array(digits);       //用于存储随机验证码
    var colors = new Array("Red","Green","Gray","Blue","Maroon","Aqua","Fuchsia","Lime","Olive","Silver");
    for(var i=0;i < this.codes.length;i++){//获取随机验证码
      this.codes[i] = Math.floor(Math.random()*10);
    }
		var div = new Element('div');
    for(var i = 0;i < this.codes.length;i++){
			var span = new Element('span');
			span.innerHTML = this.codes[i];
			span.setStyle({color: colors[Math.floor(Math.random()*10)]});
			div.appendChild(span);
    }
		$('validation').innerHTML = div.innerHTML;
	},
	
	validate: function(){
		var str='';
		var len = this.codes.length;
		for(var i=0;i < len; i++){
			str += this.codes[i];
		}
		return str == $('validation_code').value;
	},

	show_confirm_with_validation: function(confirm_message, url, token, method){
    var html = "<div class='title01'><a class='icon-active icon-active-close' href='#' onclick='facebox.close();'></a><h1>请确认</h1></div>";
    html += "<div id='error'></div><div class='formcontent'>" + confirm_message + "<br/>";
    html += "输入验证码<input id='validation_code' type='text' size=4 />";
    html += "<span id='validation'>正在生成验证码</span></div>";
    html += "<div class='buttons s_clear'><table class='center' cellpadding='0'><tr><td><span class='button'><span><button type='submit' onclick=\"if(facebox.validate()){new Ajax.Request('" + url +"', {parameters: 'authenticity_token=" + token + "', method: '" + method + "'});}else{$('error').innerHTML = '验证码错误';}\">完成</button></span></span><span class='button button-gray'><span><button type='button' onclick='facebox.close();'>取消</button></span></span></td></tr></table></div>";
    this.remove_loading();
    this.set_content(html);
    this.locate();
		this.generate_validate_code(4);
    $('validation').observe('click', function(){
      this.generate_validate_code(4);
    }.bind(this));	
	},

	close: function(){
		 new Effect.Fade('facebox', {duration: .3});
	},

	click_handler	: function(elem, e){
		this.loading();
		Event.stop(e);

		// support for rel="facebox[.inline_popup]" syntax, to add a class
		var klass = elem.rel.match(/facebox\[\.(\w+)\]/);
		if (klass) klass = klass[1];
		
		new Effect.Appear(this.facebox, {duration: .3});
	
		if(elem.href.match(/#/)){
			var url = window.location.href.split('#')[0];
			var target = elem.href.replace(url+'#','');
			var d = $(target);
			var data = new Element(d.tagName);
			data.innerHTML = d.innerHTML;
			this.reveal(data, klass);
		 }else if(elem.href.match(this.settings.image_types)) {
			var image = new Image();
			fb = this;
			image.onload = function() {
				fb.reveal('<div class="image"><img src="' + image.src + '" /></div>', klass)
			}
			image.src = elem.href;
		}else{
			var fb  = this;
			var type = elem.readAttribute('facebox_type');
		
			if(type == 'confirm'){
				var confirm_message = elem.readAttribute('facebox_confirm');
				var method = elem.readAttribute('facebox_method');
				var authenticity_token = elem.readAttribute('authenticity_token');
				fb.show_confirm(confirm_message, elem.href, authenticity_token, method); 
			}else if(type == 'confirm_with_validation'){
				var confirm_message = elem.readAttribute('facebox_confirm');
        var method = elem.readAttribute('facebox_method');
        var authenticity_token = elem.readAttribute('authenticity_token');
        fb.show_confirm_with_validation(confirm_message, elem.href, authenticity_token, method);
			}else{
				// get one page
				new Ajax.Request(elem.href, {
					method: 'get',
					onFailure: function(transport){
            fb.reveal(transport.responseText, klass);
          },
          onSuccess: function(transport){
            fb.reveal(transport.responseText, klass);
          }
        });
			}
		}
	}
});

var facebox;

document.observe('dom:loaded', function(){
	facebox = new Facebox();

	window.notice = function(mess){
		return facebox.show_notice(mess);
	};
	
 	// override default alert
	//window.alert = function(mess){
	//	return facebox.show_notice(mess);
	//};

  window.tip = function(mess){
		return facebox.show_tip(mess);
  };

	// add a shortcut to facebox.show_error
	window.error = function(mess) {
		return facebox.show_error(mess);
	};

});

