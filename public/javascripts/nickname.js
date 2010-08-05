Iyxzone.Nickname = {
  version: '1.0',
  author: ['高侠鸿']
};

Object.extend(Iyxzone.Nickname, {

  error: function(div, content){
    var span = new Element('span', {'class': 'icon-warn'});
    $(div).className = 'red';
    $(div).update(content);
    Element.insert($(div), {'top': span});
  },

  load: function(div){
    $(div).className = '';
    $(div).innerHTML = '正在检查该昵称是否合法..';
  },

  pass: function(div){
    $(div).innerHTML = '';
    $(div).className = 'f-stat';
  },

  tip: function(div, content){
    $(div).className = '';
    $(div).update(content);
  },

  showRequirement: function(){
    this.tip('nickname_info', '2－30个字，只能是数字、字母、汉字或下划线');
  },

  validate: function(code){
    var nickname = $('login_field').value;

    if(nickname == ''){
      this.error('nickname_info', '不能为空');
      return false;
    }

    if(nickname.length < 2){
      this.error('nickname_info', '至少要2个字');
      return false;
    }

    if(nickname.length > 30){
      this.error('nickname_info', '最多30个字');
      return false;
    }

    var a = /[a-zA-Z0-9_\u4e00-\u9fa5]+/.exec(nickname);
    if(a != null && a[0] == nickname){
      this.load('nickname_info');
      new Ajax.Request('/nickname/validates_login_uniqueness', {
        method: 'get',
        parameters: {'login': nickname, 'nickname_code': encodeURIComponent(code)},
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            this.pass('nickname_info');
          }else if(json.code == 0){
            this.error('nickname_info', '该昵称太受欢迎了,已经被注册');
          }
        }.bind(this)
      });
    }else{
      this.error('nickname_info', '只能包含字母，数字，汉字以及下划线');
      return false;
    }
  
    return true;
  },

  submit: function(button, code){
    if(this.validate(code)){
      new Ajax.Request('/nickname/update', {
        method: 'put',
        parameters: {'nickname_code': encodeURIComponent(code), 'login': $('login_field').value},
        onLoading: function(){
          Iyxzone.disableButton(button, '正在发送');
        },
        onComplete: function(){
          Iyxzone.enableButton(button, '重置');
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            tip('成功！！2秒后将自动跳转到登录页面..');
            setTimeout('window.location.href = "/login";');
          }else if(json.code == 2){
            this.error('nickname_info', '该昵称太受欢迎了,已经被注册');
          }else if(json.code == 3){
            error('发生错误, 稍后再试');
          }
        }.bind(this)
      });
    }
  }

});
