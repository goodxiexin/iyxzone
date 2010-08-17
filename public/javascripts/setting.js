Object.extend(Iyxzone, {

  ApplicationSetting: {},

  MailSetting: {},

  ProfilePrivacySetting: {},

  GoingPrivacySetting: {},

  OutsidePrivacySetting: {},

  PhonePrivacySetting: {},

  QQPrivacySetting: {},

  WebsitePrivacySetting: {}

});

Object.extend(Iyxzone.ApplicationSetting, {

  update: function(form, btn){
    new Ajax.Request(Iyxzone.URL.updateApplicationSetting(), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        Iyxzone.disableButton(btn, '发送..');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          Iyxzone.Facebox.close();
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.MailSetting, {

  update: function(form, btn){
    new Ajax.Request(Iyxzone.URL.updateMailSetting(), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        Iyxzone.disableButton(btn, '发送..');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        Iyxzone.enableButton(btn, "保存修改");
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          notice("修改成功");
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.ProfilePrivacySetting, {

  update: function(form, btn){
    new Ajax.Request(Iyxzone.URL.updatePrivacySetting(), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        Iyxzone.disableButton(btn, '发送..');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        Iyxzone.enableButton(btn, "保存修改");
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          notice("修改成功");
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.GoingPrivacySetting, {

  update: function(form, btn){
    new Ajax.Request(Iyxzone.URL.updatePrivacySetting(), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        Iyxzone.disableButton(btn, '发送..');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        Iyxzone.enableButton(btn, "保存修改");
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          notice("修改成功");
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
          Iyxzone.enableButton(btn, "保存修改");
        }
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.OutsidePrivacySetting, {

  update: function(form, btn){
    new Ajax.Request(Iyxzone.URL.updatePrivacySetting(), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        Iyxzone.disableButton(btn, '发送..');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        Iyxzone.enableButton(btn, "保存修改");
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          notice("修改成功");
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.PhonePrivacySetting, {

  update: function(form, btn){
    new Ajax.Request(Iyxzone.URL.updatePrivacySetting(), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        Iyxzone.disableButton(btn, '发送..');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          Iyxzone.Facebox.close();
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
          Iyxzone.enableButton(btn, "保存修改");
        }
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.QQPrivacySetting, {

  update: function(form, btn){
    new Ajax.Request(Iyxzone.URL.updatePrivacySetting(), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        Iyxzone.disableButton(btn, '发送..');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          Iyxzone.Facebox.close();
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
          Iyxzone.enableButton(btn, "保存修改");
        }
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.WebsitePrivacySetting, {

  update: function(form, btn){
    new Ajax.Request(Iyxzone.URL.updatePrivacySetting(), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        Iyxzone.disableButton(btn, '发送..');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          Iyxzone.Facebox.close();
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
          Iyxzone.enableButton(btn, "保存修改");
        }
      }.bind(this)
    });
  }

});

