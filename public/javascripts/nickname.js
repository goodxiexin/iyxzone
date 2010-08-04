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
    $(div).innerHTML = '<img src="/images/loading.gif" />';
  },

  pass: function(div){
    $(div).innerHTML = '';
    $(div).addClassName('fldstatus');
  },

  tip: function(div, content){
    $(div).className = '';
    $(div).update(content);
  },

  showRequirement: function(){
    this.tip('nickname_info', '2－30个字，只能是数字、字母、汉字或下划线');
  },

  validate: function(){
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

    if(!nickname.match(/[a-zA-Z0-9_\u4e00-\u9fa5]+/)){
      this.error('nickname_info', '只能包含字母，数字，汉字以及下划线');
      return false;
    }else{
      this.load('nickname_info');
      new Ajax.Request('/register/validates_login_uniqueness?login=' + encodeURIComponent(nickname), {
        method: 'get',
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            this.pass('nickname_info');
          }else{
            this.error('nickname_info', '该用户名已经被占用');
          }
        }.bind(this)
      })
    }
  
    return true;
  },

  reset: function(button, form){
    alert('reset');
    Iyxzone.disableButton(button, '正在发送');
    if(this.validate()){
      form.submit();
    }else{
      Iyxzone.enableButton(button, '重置');
    }
  }

});
