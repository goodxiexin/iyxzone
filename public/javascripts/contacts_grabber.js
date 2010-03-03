Iyxzone.ContactsGrabber = {
  author: '高侠鸿',
  version: '1.0'
}

Object.extend(Iyxzone.ContactsGrabber, {

  grabUnregisteredContacts: function(type, user, token){
    new Ajax.Request('/user/email_contacts/unregistered', {
      method: 'post',
      parameters: 'authenticity_token=' + token + '&type=' + type + '&user_name=' + user,
    });
  },

  grabNotFriendContacts: function(type, user, token){
    new Ajax.Request('/user/email_contacts/not_friend', {
      method: 'post',
      parameters: 'authenticity_token=' + token + '&type=' + type + '&user_name=' + user,
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
    table.childElements().each(function(tr){
      var box = tr.down('input');
      if(box.type == 'checkbox' && box.checked){
        ids.push(box.readAttribute('user_id'));
      }
    });

    // construct parameters
    ids.each(function(id){
      params += "ids[]=" + id + "&";
    });

    // send request
    new Ajax.Request('/user/friends/requests/create_multiple?authenticity_token=' + encodeURIComponent(token), {
      method: 'post',
      parameters: params,
      onSuccess: function(){
        document.location.href = '/user/signup_invitations/invite_contact';
      }
    });
  },

  inviteContactsToSignup: function(token){
    var invitees = new Array();
    var table = $('unregister_table');
    var params = '';

    // get all checked emails
    table.down('tbody').childElements().each(function(tr){
      var box = tr.down('input');
      if(box.type == 'checkbox' && box.checked){
        invitees.push(tr.childElements()[2].innerHTML);
      }
    });

    // construct parameters
    invitees.each(function(email){
      params += "emails[]=" + email + "&";
    });
   
    // send request
    new Ajax.Request('/signup_invitations/create_multiple?authenticity_token=' + encodeURIComponent(token), {
      method: 'post',
      parameters: params,
    });
  }

});
