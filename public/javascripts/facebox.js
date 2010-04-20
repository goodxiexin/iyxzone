var Facebox = Class.create({
	
  initialize: function(extra_set){
		this.settings = {
			loading_image	: '/images/loading.gif',
			image_types		: new RegExp('\.' + ['png', 'jpg', 'jpeg', 'gif'].join('|') + '$', 'i'),
			inited				: true,	
			facebox_html	: '<div class="z-box" id="facebox" style="overflow:hidden;display:none"><div class="z-t"><span class="l"><strong></strong></span><span class="r"></span></div><div class="z-m rows s_clear"><div class="box01 s_clear" id="facebox-content"></div><div class="bg"></div></div><div class="z-b"><span class="l"><strong></strong></span><span class="r"></span></div>'
		};
		if (extra_set) Object.extend(this.settings, extra_set);
		$(document.body).insert({'bottom': this.settings.facebox_html});
	
		this.preload = [];
		this.loading_image = new Image();
		this.loading_image.src = this.settings.loading_image;	
		
		this.facebox = $('facebox');
    this.content = $('facebox-content');
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
    $$('button[rel=facebox]').each(function(elem,i){
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
		
		this.content.innerHTML = '<div class="loading"><img src="'+this.loading_image.src+'"/></div>';
		
		var pageScroll = document.viewport.getScrollOffsets();
		this.facebox.setStyle({"position": 'absolute'});
		this.facebox.setStyle({"top": pageScroll.top + (document.viewport.getHeight()/4) + 'px'});
		this.facebox.setStyle({"left": document.viewport.getWidth() / 2 - (this.facebox.getWidth() / 2) + 'px'});
    	
    if(!this.facebox.visible())
      new Effect.Appear(this.facebox, {'duration': 0.3});
	
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
      position: 'absolute',
			zIndex: '1000',
			top: pageScroll.top + (document.viewport.getHeight() / 5) + 'px',
			left: document.viewport.getWidth() / 2 - (this.facebox.getWidth() / 2) + 'px'
		});
	},

	set_content: function(data){
		this.content.update( data);
    		
		if(!this.facebox.visible()) 
			new Effect.Appear(this.facebox, {'duration': 0.3});
	},

	reveal: function(data){
		this.remove_loading();
		this.set_content(data);
		this.locate();
    
		//Event.observe(document, 'keypress', this.keyPressListener);
    //Event.observe(document, 'click', this.keyPressListener);
	},

	show_tip: function(info){
		var html = '<p class="z-h s_clear"><strong class="left">提示</strong><a onclick="facebox.close();" class="icon2-close right"></a></p><div class="z-con"><p>' + info + '</p><div class="z-submit s_clear space"><div class="buttons"><span class="button"><span><button onclick="facebox.close();">确定</button></span></span></div></div></div>';
    this.remove_loading();
    this.set_content(html);
    this.locate();
	},

  show_notice: function(info){
		var html = '<p class="z-h s_clear"><strong class="left">提示</strong><a onclick="facebox.close();" class="icon2-close right"></a></p><div class="z-con"><p>' + info + '</p></div>';
 		this.remove_loading();
		this.set_content(html);
		this.locate();
    setTimeout("facebox.close();", 3000);
  },

  show_error: function(info){
    var html = '<p class="z-h z-h-error s_clear"><strong class="left">提示</strong><a onclick="facebox.close();" class="icon2-close right"></a></p><div class="z-con"><p>' + info + '</p></div>';
		this.remove_loading();
		this.set_content(html);
		this.locate();
    setTimeout("facebox.close();",3000);
  },

	show_confirm: function(confirm_message, url, token, method){
    var html = '<p class="z-h s_clear"><strong class="left">确认</strong><a onclick="facebox.close();" class="icon2-close right"></a></p>';
    html += '<div class="z-con"><p>' + confirm_message + "</p>";
    html += "<div class='z-submit s_clear space'><div class='buttons'><span class='button' id='fb-confirm'><span><button type='submit' onclick=\"new Ajax.Request('" + url +"', {parameters: 'authenticity_token=" + token + "', method: '" + method + "', onLoading: function(){Iyxzone.disableButton($('fb-confirm').down('button',0),'请等待..');Iyxzone.changeCursor('wait');}, onComplete: function(transport){facebox.close();Iyxzone.changeCursor('default');}});\">完成</button></span></span><span class='button button-gray'><span><button type='button' onclick='facebox.close();'>取消</button></span></span></div></div></div>";
		this.remove_loading();
		this.set_content(html);
		this.locate();
	},

  // TODO: 怎么传多个参数?
  show_confirm_with_callbacks: function(){
    var properties = $A(arguments);
    var confirm_message = properties.shift();
    var callback= properties.shift();
    var html = '<p class="z-h s_clear"><strong class="left">确认</strong><a onclick="facebox.close();" class="icon2-close right"></a></p>';
    html += '<div class="z-con"><p>' + confirm_message + "</p>";
    html += "<div class='z-submit s_clear space'><div class='buttons'><span class='button'><span><button type='submit' id='facebox_confirm'>确定</button></span></span><span class='button button-gray'><span><button type='button' onclick='facebox.close();'>取消</button></span></span></div></div></div>";
    this.remove_loading();
    this.set_content(html);
    this.locate();
    Event.observe('facebox_confirm', 'click', function(){
      callback.apply(this, properties);
    }.bind(this));
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
    var html = '<p class="z-h s_clear"><strong class="left">确认</strong><a onclick="facebox.close();" class="icon2-close right"></a></p>';
    html += '<div class="z-con"><div id="error"></div><p>' + confirm_message + "<br/>";
    html += "输入验证码<input id='validation_code' type='text' size=4 />";
    html += "<span id='validation'>正在生成验证码</span></p></div>";
    html += "<div class='z-submit s_clear space'><div class='buttons'><span class='button' id='fb-confirm'><span><button type='submit' onclick=\"if(facebox.validate()){new Ajax.Request('" + url +"', {parameters: 'authenticity_token=" + token + "', method: '" + method + "', onLoading: function(){Iyxzone.disableButton($('fb-confirm').down('button',0),'请等待..'); Iyxzone.changeCursor('wait');}, onComplete: function(){Iyxzone.changeCursor('default');} });}else{$('error').innerHTML = '验证码错误';}\">完成</button></span></span><span class='button button-gray'><span><button type='button' onclick='facebox.close();'>取消</button></span></span></div></div></div>";
    this.remove_loading();
    this.set_content(html);
    this.locate();
    var validation = Iyxzone.validationCode(4);
    $('validation').update( validation.div.innerHTML);
    this.codes = validation.codes;
    $('validation').observe('click', function(){
      var validation = Iyxzone.validationCode(4);
      $('validation').update( validation.div.innerHTML);
      this.codes = validation.codes;
    }.bind(this));	
	},

	close: function(){
		 new Effect.Fade('facebox', {'duration': .3});
	},

  set_width: function(width){
    this.facebox.setStyle({
      'width': width + 'px'
    });
  },

	click_handler	: function(elem, e){
    var width = elem.readAttribute('facebox_width');
    var rel = elem.readAttribute('rel');
    var type = elem.readAttribute('facebox_type');
    var fb = this; 

    // set width if necessary
    if(width){
      this.set_width(width);
    }else{
      this.set_width(350);
    }
 
    // load facebox
		this.loading();
		Event.stop(e);
		new Effect.Appear(this.facebox, {'duration': .3});

    // parse facebox type	
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
          fb.reveal(transport.responseText);
        },
        onComplete: function(transport){
          fb.reveal(transport.responseText);
        }
      });
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

