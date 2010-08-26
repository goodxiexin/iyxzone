Object.extend(Iyxzone, {

  ApplicationSetting: {},

  MailSetting: {},

  ProfilePrivacySetting: {},

  GoingPrivacySetting: {},

  OutsidePrivacySetting: {},

  PhonePrivacySetting: {},

  QQPrivacySetting: {},

  WebsitePrivacySetting: {},

  PasswordSetting: {}

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

Object.extend(Iyxzone.PasswordSetting, {

  error: function(div, content){
    var span = new Element('span', {'class': 'icon-warn'});
    $(div).className = 'red';
    $(div).update(content);
    Element.insert($(div), {'top': span}); 
  },

  clear: function(div){
    $(div).innerHTML = '';
  },

  pass: function(div){
    $(div).innerHTML = '';
    $(div).className = 'fldstatus';
  },

  tip: function(div, content){
    $(div).className = '';
    $(div).update(content);
  },

  showPasswordConfirmRequirement: function(){
    this.tip('password_confirmation_info', '确认你的密码');
  },

  showPasswordRequirement: function(){
    this.tip('password_info', '密码6－20个字符');
  },

  validatePassword: function(){
    var old_pwd = $('old_password').value;
    var pwd = $('password').value;
    var pwd_cfm = $('password_confirmation').value;
    var strongReg = new RegExp("^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$", "g");
    var mediumReg = new RegExp("^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");
 
    // check length
    if(pwd == ''){
      this.error('password_info', '密码不能为空');
      return false;
    }
    if(pwd.length < 6){
      this.error('password_info', '至少6个字符');
      return false;
    }
    if(pwd.length > 20){
      this.error('password_info', '最多20个字符');
      return false;
    }

    // check strength
    if(pwd.match(strongReg)){
      this.tip('password_info', '密码强度: 强');
    }else if(pwd.match(mediumReg)){
      this.tip('password_info', '密码强度: 中');
    }else{
      this.tip('password_info', '密码强度: 弱');
    }

    return true;
  },

  validatePasswordConfirmation: function(){
    var old_pwd = $('old_password').value;
    var pwd = $('password').value;
    var pwd_cfm = $('password_confirmation').value;

    // check confirm
    if(pwd == pwd_cfm){
      this.pass('password_confirmation_info');
      return true;
    }else{
      this.error('password_confirmation_info', '两次密码不一致');
      return false;
    }

    return true;
  },

  set: function(form){
    var btn = $(form).down('button', 0);

    if(this.validatePassword() && this.validatePasswordConfirmation()){
      new Ajax.Request(Iyxzone.URL.updatePasswordSetting(), {
        method: 'put',
        parameters: $(form).serialize(),
        onLoading: function(){
          this.clear('old_password_info');
          this.clear('password_info');
          this.clear('password_confirmation_info');
          this.clear('captcha_info');
          Iyxzone.disableButton(btn, '发送..');
        }.bind(this),
        onComplete: function(){
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          Iyxzone.enableButton(btn, '确定');
          if(json.code == 1){
            $(form).remove();
            $('notes').update('<div class="form-con"><div style="font-size: 14px;" class="jl-cutline"><span class="icon-success"/>修改成功。</div><div class="space20">新的密码已经奏效，请牢记您的新密码</div></div>');
          }else if(json.code == 0){
            error("更新时发生错误，请稍后再试");
          }else if(json.code == 2){
            this.error('old_password_info', '密码不正确');
            window.scrollTo(0, $('old_password').cumulativeOffset().top - 50);
          }else if(json.code == 222){
            this.error('captcha_info', "验证码错误");
            window.scrollTo(0, $('captcha_code').cumulativeOffset().top - 50);            
          }
        }.bind(this)
      });            
    }
  }

});
