Iyxzone.SignupInvitation = {
  
  author: '高侠鸿',
  
  version: '1.3'

};

Object.extend(Iyxzone.SignupInvitation, {

  checkMsnInput: function(form){
    Iyxzone.disableButton($('msn_contact_grabber_btn'), '请等待..');
    var id = form.getInputs('text')[0];
    var pwd = form.getInputs('password')[0];
    if(id.value == ''){
      error('请输入msn用户名');
      Iyxzone.enableButton($('msn_contact_grabber_btn'), '导入联系人');
      return false;
    }
    if(pwd.value == ''){
      error('请输入msn密码');
      Iyxzone.enableButton($('msn_contact_grabber_btn'), '导入联系人');
      return false;
    }
    return true;
  },

  checkEmailInput: function(form){
    var value = form.getInputs('text')[0].value;
    if(value == ''){
      error('请输入邮箱');
      return false;
    }else if(!/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/.exec(value)){
      error('非法的邮箱地址');
      return false;
    }
    return true;
  },

  checkEmailContactsInput: function(form){
    Iyxzone.disableButton($('other_mail_contact_grabber_btn'), '请等待..');
    var id = form.getInputs('text')[0];
    var pwd = form.getInputs('password')[0];
    var type = $('email_selector').value;
    if(type == ''){
      error('请选择邮箱种类');
      Iyxzone.enableButton($('other_mail_contact_grabber_btn'), '导入联系人');
      return false;
    }
    if(id.value == ''){
      error('请输入用户名');
      Iyxzone.enableButton($('other_mail_contact_grabber_btn'), '导入联系人');
      return false;
    }
    if(pwd.value == ''){
      error('请输入密码');
      Iyxzone.enableButton($('other_mail_contact_grabber_btn'), '导入联系人');
      return false;
    }
    return true;
  },

  inviteByEmail: function(form, btn){
    Iyxzone.disableButton(btn, '发送..');
    if(this.checkEmailInput(form)){
      new Ajax.Request(Iyxzone.URL.createSignupInvitation(), {
        method: 'post',
        parameters: $(form).serialize(), 
        onLoading: function(){
          Iyxzone.changeCursor('wait');
        },
        onComplete: function(){
          Iyxzone.changeCursor('default');
          Iyxzone.enableButton(btn, '发送邀请');
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            notice("发送成功");
          }else if(json.code == 0){
            error("发生错误，请稍后再试");
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButton(btn, '发送邀请');
    }
  },

  inviteByMsn: function(form, btn){
    Iyxzone.disableButton(btn, '发送..');
    if(this.checkMsnInput(form)){
      $(form).submit();
    }else{
      Iyxzone.enableButton(btn, '导入联系人');
    }    
  },

  inviteByEmailContacts: function(form, btn){
    Iyxzone.disableButton(btn, '发送..');
    if(this.checkEmailContactsInput(form)){
      $(form).submit();
    }else{
      Iyxzone.enableButton(btn, '导入联系人');
    }    
  }

});
