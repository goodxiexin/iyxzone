Iyxzone.ContactsGrabber = {
  author: '高侠鸿',
  version: '1.0'
}

Object.extend(Iyxzone.ContactsGrabber, {

  grabUnregisteredContacts: function(type, user, token){
    new Ajax.Request('/user/email_contacts/unregistered', {
      method: 'post',
      parameters: 'authenticity_token=' + token + '&type=' + type + '&user_name=' + user
    });
  },

  grabNotFriendContacts: function(type, user, token){
    new Ajax.Request('/user/email_contacts/not_friend', {
      method: 'post',
      parameters: 'authenticity_token=' + token + '&type=' + type + '&user_name=' + user
    });
  },

  toggleAll: function(id, checkbox){
    var checked = checkbox.checked;
    var table = $(id);
    table.down('tbody').childElements().each(function(tr){
      var box = tr.down('input');
      if(box.type == 'checkbox'){
        box.checked = checked;
      }
    });
  },

  addContactsAsFriends: function(token){
    var ids = new Array();
    var table = $('not_friend_table');
    var params = '';

    // get all checked emails
    table.down('tbody').childElements().each(function(tr){
      var box = tr.down('input');
      if(box.type == 'checkbox' && box.checked){
        ids.push(box.readAttribute('user_id'));
      }
    });

    if(ids.length == 0){
      error('至少选择一个');
      return;
    }

    // construct parameters
    ids.each(function(id){
      params += "ids[]=" + id + "&";
    });

    // send request
    new Ajax.Request('/friend_requests/create_multiple?authenticity_token=' + encodeURIComponent(token), {
      method: 'post',
      parameters: params,
      onSuccess: function(){
        document.location.href = '/user/signup_invitations/invite_contact';
      }
    });
  },

  inviteContactsToSignup: function(token, button){
    var invitees = new Array();
    var table = $('unregister_table');
    var params = '';

    // get all checked emails
    table.down('tbody').childElements().each(function(tr){
      var box = tr.down('input');
      if(box.type == 'checkbox' && box.checked){
        invitees.push(tr.childElements()[2].down('span').innerHTML);
      }
    });

    if(invitees.length == 0){
      error('至少选择一个');
      return;
    }

    // construct parameters
    invitees.each(function(email){
      params += "emails[]=" + email + "&";
    });
   
    // send request
    new Ajax.Request('/signup_invitations/create_multiple?authenticity_token=' + encodeURIComponent(token), {
      method: 'post',
      parameters: params,
      onLoading: function(){
        Iyxzone.disableButton(button, '请等待..');
      },
      onComplete: function(){
        Iyxzone.enableButton(button, '发送邀请');
      }
    });
  },

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

  checkEmailInvitation: function(form){
    var value = form.getInputs('text')[0].value;
    if(value == ''){
      error('请输入邮箱');
      return false;
    }else if(!value.match(/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/)){
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
  }

});
