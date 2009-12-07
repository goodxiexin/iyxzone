InvitationBuilder = Class.create({
  initialize: function(){
    this.selected = new Hash();
  },

  click: function(td){
    var friend_id = td.readAttribute('friend_id');
    if(this.selected.get(friend_id)){
      td.setStyle({background: 'white'});
      this.selected.unset(friend_id);
    }else{
      this.selected.set(friend_id, td);
      td.setStyle({background: '#526ea6'});
    }
  },

  mouseover: function(td){
    var friend_id = td.readAttribute('friend_id');
    if(!this.selected.get(friend_id)){
      td.setStyle({background: '#e7ebf5'});
    }
  },

  mouseout: function(td){
    var friend_id = td.readAttribute('friend_id');
    if(!this.selected.get(friend_id)){
      td.setStyle({background: 'white'});
    }
  },

  submit_invitations: function(form){
    form.action += '?';
    if(this.selected.size() == 0){
      error('你必须至少邀请一个人');
    }else{
      this.selected.each( function(pair){
        var el = new Element("input", {type: 'hidden', value: pair.key, id: 'users[]', name: 'users[]'})
        form.appendChild(el);
      });
      form.submit();
    }
  },

  reset: function(){
    this.selected = new Hash();
  }

});
