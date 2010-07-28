Iyxzone.Facebox = {

  version: '1.0',

  author: ['高侠鸿']

};

Object.extend(Iyxzone.Facebox, {

  loading: function(html){
    $('facebox_content').innerHTML = '<div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div>';
  },

  setContent: function(html){
    $('facebox_content').update(html);
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

  setWidth: function(width){
    this.facebox.setStyle({width: width + 'px'});
  },

  appear: function(){
    if(!this.facebox.visible()) 
      new Effect.Appear(this.facebox, {'duration': 0.5}); 
  },

  close: function(){
    if(this.facebox.visible())
      this.facebox.hide();
  },

  link: function(href, method, width){
    new Ajax.Request(href, {
      method: method,
      onLoading: function(){
        this.setWidth(width);
        this.loading();
        this.locate();
        this.appear();
      }.bind(this),
      onSuccess: function(transport){
        this.setContent(transport.responseText);
      }.bind(this)
    });
  },

  tip: function(mess, title, width){
    if(width)
      this.setWidth(width);
    if(title == null)
      title = "提示";

    this.setContent('<p class="z-h s_clear"><strong class="left">' + title + '</strong><a onclick="Iyxzone.Facebox.close();" class="icon2-close right"></a></p><div class="z-con"><p>' + mess + '</p><div class="z-submit s_clear space"><div class="buttons"><span class="button"><span><button onclick="Iyxzone.Facebox.close();">确定</button></span></span></div></div></div>');
    this.locate(); 
    this.appear();
  },

  notice: function(mess, title, width){
    if(width)
      this.setWidth(width);
    if(title == null)
      title = "通知"

    this.setContent('<p class="z-h s_clear"><strong class="left">' + title + '</strong><a onclick="Iyxzone.Facebox.close();" class="icon2-close right"></a></p><div class="z-con"><p>' + mess + '</p></div>');
    this.locate();
    this.appear();
    setTimeout("Iyxzone.Facebox.close();", 3000); 
  },

  error: function(mess, title, width){
    if(width)
      this.setWidth(width);
    if(title == null)
      title = "通知"

    this.setContent('<p class="z-h z-h-error s_clear"><strong class="left">' + title + '</strong><a onclick="Iyxzone.Facebox.close();" class="icon2-close right"></a></p><div class="z-con"><p>' + mess + '</p></div>');
    this.locate();
    this.appear();
    setTimeout("Iyxzone.Facebox.close();",3000);
  },

  confirm: function(mess, title, width, url, token, method){
    if(title == null)
      title = "确认";
    if(width)
      this.setWidth(width);

    this.setContent('<p class="z-h s_clear"><strong class="left">' + title + '</strong><a onclick="Iyxzone.Facebox.close();" class="icon2-close right"></a></p><div class="z-con"><p>' + mess + "</p><div class='z-submit s_clear space'><div class='buttons'><span class='button' id='fb-confirm'><span><button type='submit' onclick=\"new Ajax.Request('" + url +"', {parameters: 'authenticity_token=" + token + "', method: '" + method + "', onLoading: function(){Iyxzone.disableButton($('fb-confirm').down('button',0),'请等待..');Iyxzone.changeCursor('wait');}, onComplete: function(transport){Iyxzone.Facebox.close();Iyxzone.changeCursor('default');}});\">完成</button></span></span><span class='button button-gray'><span><button type='button' onclick='Iyxzone.Facebox.close();'>取消</button></span></span></div></div></div>");
    this.locate();
    this.appear();
  },

  validate: function(){
    var str='';
    var len = this.codes.length;
    for(var i=0;i < len; i++){
      str += this.codes[i];
    }
    return str == $('validation_code').value;
  },

  confirmWithValidation: function(mess, title, width, url, token, method){
    if(title == null)
      title = '确认';
    if(width)
      this.setWidth(width);

    this.setContent('<p class="z-h s_clear"><strong class="left">' + title + '</strong><a onclick="Iyxzone.Facebox.close();" class="icon2-close right"></a></p><div class="z-con"><div id="error"></div><p>' + mess + "<br/>输入验证码<input id='validation_code' type='text' size=4 /><span id='validation'>正在生成验证码</span></p></div><div class='z-submit s_clear space'><div class='buttons'><span class='button' id='fb-confirm'><span><button type='submit' onclick=\"if(Iyxzone.Facebox.validate()){new Ajax.Request('" + url +"', {parameters: 'authenticity_token=" + token + "', method: '" + method + "', onLoading: function(){Iyxzone.disableButton($('fb-confirm').down('button',0),'请等待..'); Iyxzone.changeCursor('wait');}, onComplete: function(){Iyxzone.changeCursor('default');} });}else{$('error').innerHTML = '验证码错误';}\">完成</button></span></span><span class='button button-gray'><span><button type='button' onclick='Iyxzone.Facebox.close();'>取消</button></span></span></div></div></div>");
    this.locate();
    this.appear();
    var validation = Iyxzone.validationCode(4);
    $('validation').update( validation.div.innerHTML);
    this.codes = validation.codes;
    $('validation').observe('click', function(){
      var validation = Iyxzone.validationCode(4);
      $('validation').update( validation.div.innerHTML);
      this.codes = validation.codes;
    }.bind(this));  
  },

  // FIXME: 怎么传多个参数?
  show_confirm_with_callbacks: function(){
    var properties = $A(arguments);
    var confirm_message = properties.shift();
    var callback= properties.shift();
    var html = '<p class="z-h s_clear"><strong class="left">确认</strong><a onclick="Iyxzonw.Facebox.close();" class="icon2-close right"></a></p>';
    html += '<div class="z-con"><p>' + confirm_message + "</p>";
    html += "<div class='z-submit s_clear space'><div class='buttons'><span class='button'><span><button type='submit' id='facebox_confirm'>确定</button></span></span><span class='button button-gray'><span><button type='button' onclick='Iyxzone.Facebox.close();'>取消</button></span></span></div></div></div>";
    this.setContent(html);
    this.locate();
    this.appear();
    Event.observe('facebox_confirm', 'click', function(){
      callback.apply(this, properties);
    }.bind(this));
  },

  // the only instance
  facebox: null,

  init: function(){
    if(this.facebox == null){
      this.facebox = new Element('div', {class: 'z-box', style:"overflow:hidden;display:none"});
      this.facebox.innerHTML = '<div class="z-t"><span class="l"><strong></strong></span><span class="r"></span></div><div class="z-m rows s_clear"><div class="box01 s_clear" id="facebox_content"></div><div class="bg"></div></div><div class="z-b"><span class="l"><strong></strong></span><span class="r"></span></div>';
      document.body.appendChild(this.facebox);
    }
  }

});

document.observe('dom:loaded', function(){
	
  window.notice = function(mess, title){
		return Iyxzone.Facebox.notice(mess, title);
	};
	
  window.tip = function(mess, title){
		return Iyxzone.Facebox.tip(mess, title);
  };

	window.error = function(mess, title) {
		return Iyxzone.Facebox.error(mess, title);
	};

  Iyxzone.Facebox.init();

});

