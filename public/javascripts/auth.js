Iyxzone.Auth = {

  version: '1.1',

  author: '高侠鸿'

};

Object.extend(Iyxzone.Auth, {

  login: function(form, btn){
    new Ajax.Request(Iyxzone.URL.login(), {
      method: 'post',
      parameters: $(form).serialize(),
      onLoading: function(){
        $(btn).writeAttribute('onclick', '');
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          var returnTo = Iyxzone.Cookie.get("return_to");
          if(returnTo){
            window.location.href = returnTo;
            Iyxzone.Cookie.unset(returnTo);
          }else{
            window.location.href = Iyxzone.URL.home();
          }
        }else if(json.code == 2){
          //用户名密码不正确
          window.location.href = Iyxzone.URL.loginFailure();
        }else if(json.code == 3){
          // 没激活
          window.location.href = Iyxzone.URL.loginFailure();
        }else if(json.code == 4){
          // 被删除了
          window.location.href = Iyxzone.URL.loginFailure();
        }
      }.bind(this)
    });
  }
  
});
