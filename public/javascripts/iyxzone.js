Iyxzone = {};

Object.extend(Iyxzone, {

  version: 1.0,

  author: ['高侠鸿'],

  SiteURL: "http://localhost:3000",

  // some utilities
  disableButton: function(button, text){
    button.innerHTML = text;
    $(button).writeAttribute('disabled', 'disabled');
    var span = $(button.up('span')).up('span');
    $(span).writeAttribute('class', 'button button-gray');
  },

  enableButton: function(button, text){
    button.innerHTML = text;
    button.disabled = '';
    var span = $(button.up('span')).up('span');
    $(span).writeAttribute('class', 'button');
  },

  disableButtonThree: function(button, text){
    button.innerHTML = text;
    $(button).writeAttribute('disabled', 'disabled');
    var span = $(button.up('span')).up('span');
    $(span).writeAttribute('class', 'button03 button03-gray');
  },

  enableButtonThree: function(button, text){
    button.innerHTML = text;
    button.disabled = '';
    var span = $(button.up('span')).up('span');
    $(span).writeAttribute('class', 'button03');
  },

  validationCode: function(digits){
    var codes = new Array(digits);       //用于存储随机验证码
    var colors = new Array("Red","Green","Gray","Blue","Maroon","Aqua","Fuchsia","Lime","Olive","Silver");
    for(var i=0;i < codes.length;i++){//获取随机验证码
      codes[i] = Math.floor(Math.random()*10);
    }
    var div = new Element('div');
    for(var i = 0;i < codes.length;i++){
      var span = new Element('span');
      span.innerHTML = codes[i];
      span.setStyle({'color': colors[Math.floor(Math.random()*10)]});
      div.appendChild(span);
    }
    return {'codes': codes, 'div': div};
  },

  changeCursor: function(type){
    document.body.style.cursor = type;
  },

  blinkTitle: function(){
    if(!document.title.match(/^【　　　】/)){
      document.title='【　　　】' + this.documentTitle;
    }else{
      document.title='【' + this.blinkText + '】' + this.documentTitle;
    }
    setTimeout(this.blinkTitle.bind(this), 500);
  },

  startBlinkTitle: function(text){
    if(this.documentTitleTimer == null){
      this.documentTitle = document.title;
      this.blinkText = text;
      this.documentTitleTimer = setTimeout(this.blinkTitle.bind(this), 500);
    }else{
      this.blinkText = text;
    } 
  },

	
	addToBookmark: function(){
		title = "17gaming 一起游戏网";
		url="http://www.17gaming.com/";
		if (window.sidebar) // firefox
			window.sidebar.addPanel(title, url, "");
		else if(window.opera && window.print){ // opera
			var elem = document.createElement('a');
			elem.setAttribute('href',url);
			elem.setAttribute('title',title);
			elem.setAttribute('rel','sidebar');
			elem.click();
		}
		else if(document.all)// ie
			window.external.AddFavorite(url, title);
	},

	addToHomepage: function(){
		if (Prototype.Browser.IE){
			document.body.style.behavior='url(#default#homepage)';
			document.body.setHomePage('http://www.17gaming.com');
		}
		else{
			alert("您的浏览器不支持自动设置首页，请手动添加!");
		}
	},

  // 下面这个函数只是用于你收到邮件后的提示
  newMailNotice: function(){
    Iyxzone.startBlinkTitle('新邮件');
    var navItem = $('navinbox');
    var elm = navItem.down('strong');
    if(elm){
      var num = parseInt(elm.innerHTML) + 1;
      elm.update(num);
    }else{
      navItem.update('站内信<em class="notice-bubble"><strong>1</strong></em>');
    }
    Sound.play('music/tip.wav');
  },

  newNotificationNotice: function(){
    Iyxzone.startBlinkTitle('新通知');
    var navItem = $('navnotice');
    var elm = navItem.down('strong');
    if(elm){
      var num = parseInt(elm.innerHTML) + 1;
      elm.update(num);
    }else{
      navItem.update('通知<em class=\"notice-bubble\"><strong>1</strong></em>'); 
    }
    $('notifications_dropdown_list').update(''); 
    $('notifications_dropdown').hide(); 
    Sound.play('/music/tip.wav');
  }

});

Iyxzone.limitedTextField = Class.create({

  initialize: function(el, max, div, autoClear){
    this.el = el;
    this.max = max;
    this.div = div;
    this.timer = null;
    this.firstFocus = true;
    this.interval = 200;
    
    this.el.observe('focus', function(){
      if(this.firstFocus){
				if(autoClear)
					this.el.clear();
        if(this.div)
          this.div.innerHTML = '0/' + this.max;
        this.firstFocus = false;
      }
      this.timer = setTimeout(this.checkLength.bind(this), this.interval);
    }.bind(this));

    this.el.observe('blur', function(){
      clearTimeout(this.timer);
    }.bind(this));
  },

  checkLength: function(){
    var count = this.el.value.length;
    if(count > this.max){
      this.el.value = this.el.value.substr(0, this.max);
    }else{
      if(this.div)
        this.div.innerHTML = count + "/" + this.max;
    }
    this.timer = setTimeout(this.checkLength.bind(this), this.interval);
  }
});
