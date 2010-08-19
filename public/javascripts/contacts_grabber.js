Iyxzone.ContactsGrabber = {
  
  author: '高侠鸿',
  
  version: '1.3'

};

Object.extend(Iyxzone.ContactsGrabber, {

  contacts: new Array(),

  getUnregisteredContacts: function(){
    var contacts = new Array();
    for(var i=0;i<this.contacts.length;i++){
      if(!this.contacts[i].registered)
        contacts.push(this.contacts[i]);
    }
    return contacts;
  },

  getNotFriendContacts: function(){
    var contacts = new Array();
    for(var i=0;i<this.contacts.length;i++){
      if(!this.contacts[i].is_friend && this.contacts[i].registered)
        contacts.push(this.contacts[i]);
    }
    return contacts;
  },

  showUnregister: function(){
    var contacts = this.getUnregisteredContacts();
    var html = '';

    html += '<h2>向联系人发送邀请</h2>';
    html += '<p class="tip"><strong>你的联系人中有' + contacts.length + '位尚未注册，你可以:</strong></p>';
    html += '<div style="display:block">';
    html += '<div class="box02 space">';
    html += '<div class="func"><input type="checkbox" value=1 checked=false onclick="Iyxzone.ContactsGrabber.toggleAll(\'unregister_table\', this);"/><strong>全部选中</strong></div>';
    html += '<div class="list">';
    html += '<table cellpadding="0" id="unregister_table">';
    for(var i=0;i<contacts.length;i++){
      html += '<tr class="jl-cutline">';
      html += '<td width="30" align="center"><input type="checkbox" value=1 checked=false/></td>';
      html += '<td width="80"><img src="/images/default_male_cmedium.png" class="imgbox01"/></td>';
      html += '<td>';
      html += '<strong>' + contacts[i].nickname + '</strong><br/>';
      html += '<span>' + contacts[i].email + '</span>';
      html += '</td>';
      html += '</tr>';
    }
    html += '</table>';
    html += '</div>';
    html += '</div>';
    html += '<div class="s_clear space">';
    html += '<span class="button"><span><button onclick="Iyxzone.ContactsGrabber.inviteContactsToSignup(this);">发送邀请</button></span></span>';
    html += '<span class="button button-gray"><span><button onclick="Iyxzone.ContactsGrabber.fetchNotFriend();">跳过</button></span></span>';
    html += '</div>';
    html += '</div>';

    $('contacts').update(html);
  },

  showNotFriend: function(){
    var contacts = this.getNotFriendContacts();
    var registeredCount = this.contacts.length - this.getUnregisteredContacts().length;
    var html = '';

    html += '<h2>向联系人发送邀请</h2>';
    html += '<p class="tip"><strong>你的' + this.contacts.length + '个联系人中有' + registeredCount + '位已经在一起游戏网注册，其中' + contacts.length + '位还不是你的好友，你可以在这里加他们为好友</strong></p>';
    html += '<div class="box02">';
    html += '<div class="func"><input type="checkbox" value=1 checked=false onclick="Iyxzone.ContactsGrabber.toggleAll("not_friend_table", this);"/><strong>全部选中</strong></div>';
    html += '<div class="list" id="contacts">';
    html += '<table cellpadding="0" id="not_friend_table">';
    for(var i=0;i<contacts.length;i++){
      html += '<tr class="jl-cutline">';
      html += '<td width="30" align="center"><input type="checkbox" value=1 checked=false user_id=' + contacts[i].user_id + '/></td>';
      html += '<td width="80"><img src="' + contacts[i].avatar + '" class="imgbox01" /></td>';
      html += '<td>';
      html += '<strong>' + contacts[i].nickname + '</strong><br/>';
      html += '<span>' + contacts[i].email + '</span>';
      html += '</td>';
      html += '</tr>';
    }
    html += '</table>';
    html += '</div>';
    html += '</div>';
    html += '<div class="space">';
    html += '<span class="button"><span><button onclick="Iyxzone.ContactsGrabber.addContactsAsFriends(this);">加为好友</button></span></span>';
    html += '<span class="button button-gray"><span><button onclick="window.location.href=Iyxzone.URL.listSignupInvitation();">跳过</button></span></span>';
    html += '</div>';
    
    $('contacts').update(html);
  },

  fetchContacts: function(type, user, token){
    this.token = token;
    new Ajax.Request(Iyxzone.URL.parseEmailContacts(), {
      method: 'post',
      parameters: 'authenticity_token=' + token + '&type=' + type + '&user_name=' + user,
      onLoading: function(){
      },
      onComplete: function(){
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          this.contacts = json.contacts;
          var contacts = this.getUnregisteredContacts();

          if(contacts.length != 0){
            this.showUnregister();
          }else{
            contacts = this.getNotFriendContacts();
            alert(contacts.length);
            if(contacts.length != 0){
              this.showNotFriend();
            }else{
              notice("没有可以邀请的好友");
              window.location.href = Iyxzone.URL.listSignupInvitation();
            }
          }
        }else if(json.code == 2){
          error("不支持的邮件类型");
          history.back();
        }else if(json.code == 3){
          error("用户名密码错误");
          history.back();
        }else if(json.code == 4){
          error("无法连接服务器，请稍后再试");
          history.back();
        }
      }.bind(this)
    });
  },

  fetchNotFriend: function(){
    var contacts = this.getNotFriendContacts();
    if(contacts.length == 0){
      window.location.href = Iyxzone.URL.listSignupInvitation();
    }else{
      this.showNotFriend();
    }
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

  addContactsAsFriends: function(btn){
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
    new Ajax.Request(Iyxzone.URL.createMultipleFriendRequests(), {
      method: 'post',
      parameters: params + "&authenticity_token=" + encodeURIComponent(this.token),
      onLoading: function(){
        $(btn).writeAttribute('onclick', '');
      },
      onComplete: function(){
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          notice("发送成功，页面将自动跳转");
          window.location.href = Iyxzone.URL.listSignupInvitation();
        }else if(json.code == 0){
          error("发生错误");
          $(btn).writeAttribute('onclick', 'Iyxzone.ContactsGrabber.addContactsAsFriends(this);');
        }
      }.bind(this)
    });
  },

  inviteContactsToSignup: function(button){
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
    new Ajax.Request(Iyxzone.URL.createMultipleSignupInvitations(), {
      method: 'post',
      parameters: params + "&authenticity_token=" + encodeURIComponent(this.token),
      onLoading: function(){
        Iyxzone.disableButton(button, '请等待..');
        $(button).writeAttribute('onclick', '');
      },
      onComplete: function(){
        Iyxzone.enableButton(button, '发送邀请');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          this.contacts = json.contacts;
          var contacts = this.getNotFriendContacts();

          if(contacts.length == 0){
            notice("发送成功，页面将自动跳转");
            window.location.href = Iyxzone.URL.listSignupInvitation();
          }else{
            this.showNotFriend();
          }
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
          $(button).writeAttribute('onclick', "Iyxzone.ContactsGrabber.inviteContactsToSignup(this);");
        }
      }.bind(this)
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
  }

});
