Iyxzone = {};

Object.extend(Iyxzone, {

  version: 1.0,

  author: ['高侠鸿'],

  // some utilities
  disableButton: function(button, text){
    button.innerHTML = text;
    button.writeAttribute({disabled: 'disabled'});
    var span = button.up('span').up('span');
    span.writeAttribute({class: 'button button-gray'});
  },

  enableButton: function(button, text){
    button.innerHTML = text;
    button.disabled = '';
    var span = button.up('span').up('span');
    span.writeAttribute({class: 'button'});
  },

  disableButtonThree: function(button, text){
    button.innerHTML = text;
    button.writeAttribute({disabled: 'disabled'});
    var span = button.up('span').up('span');
    span.writeAttribute({class: 'button03 button03-gray'});
  },

  enableButtonThree: function(button, text){
    button.innerHTML = text;
    button.disabled = '';
    var span = button.up('span').up('span');
    span.writeAttribute({class: 'button03'});
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
      span.setStyle({color: colors[Math.floor(Math.random()*10)]});
      div.appendChild(span);
    }
    return {codes: codes, div: div};
  },


});

Iyxzone.limitedTextField = Class.create({

  initialize: function(el, max, div){
    this.el = el;
    this.max = max;
    this.div = div;
    this.timer = null;
    this.firstFocus = true;
    this.interval = 200;
    
    this.el.observe('focus', function(){
      if(this.firstFocus){
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
