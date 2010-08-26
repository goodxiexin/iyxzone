Iyxzone.Skin = {

  version: '1.1',

  author: ['高侠鸿']

};

Object.extend(Iyxzone.Skin, {

  submit: function(profileID, form){
    var btn = form.down('button', 0);
    
    new Ajax.Request(Iyxzone.URL.updateProfile(profileID), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.disableButton(btn, '应用..');
      },
      onComplete: function(){
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          notice("成功，页面将马上跳转");
          window.location.href = Iyxzone.URL.showProfile(profileID);
        }else{
          error("发生错误，请稍后再试");
          Iyxzone.enableButton(btn, '应用');
        }
      }.bind(this)
    });
  },

  cancel: function(profileID){
    window.location.href = Iyxzone.URL.showProfile(profileID);
  },

  set: function(skinID, profileID, token, link){
    new Ajax.Request(Iyxzone.URL.updateProfile(profileID), {
      method: 'put',
      parameters: {'profile[skin_id]': skinID, 'authenticity_token': encodeURIComponent(token)},
      onLoading: function(transport){
        Iyxzone.changeCursor('wait');
        $(link).writeAttribute('onclick', '');
      },
      onComplete: function(transport){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showProfile(profileID);
        }else{
          error("发生错误");
          $(link).writeAttribute('onclick', "Iyxzone.Skin.set(" + skinID + "," + profileID + ", '" + token + "', this);");
        }
      }.bind(this)
    });
  },

  show: function(skinID){
    window.location.href = Iyxzone.URL.showSkin(skinID);
  }

});
