FriendInfo = Class.create({

  initialize: function(id, profile_id, login){
    this.id = id;
    this.profile_id = profile_id;
    this.login = login;
  },

  id: function(){
    return this.id;
  },

  profile_id: function(){
    return this.profile_id;
  },

  login: function(){
    return this.login;
  }

});

FriendTagBuilder = Class.create({

  initialize: function(friend_ids){
    this.tags = new Hash(); // friend_id => div
    this.new_tags = new Hash(); // friend_id => div
    for(var i=0;i<friend_ids.length;i++){
      this.tags.set(friend_ids[i], $('friend_'+friend_ids[i]));
    }
    this.toggle_button = $('toggle_button');
    this.toggle_button.observe('click', function(e){
      if(this.popup && this.popup.visible()){
        this.hide_friends();
      }else{
        this.show_friends();
      }
    }.bind(this));
    this.text_field = $('friend_login');
		this.text_field.clear();
  },

  remove_tag: function(friend_id, tag_id, token){
    new Ajax.Request('/friend_tags/destroy?id=' + tag_id, {
			method: 'delete',
			parameters: "authenticity_token=" + encodeURIComponent(token),
      onSuccess: function(transport){
        var tag = this.tags.unset(friend_id);alert(tag);
        if(tag) tag.remove();
      }.bind(this)
    });
  },

  remove_new_tag: function(friend_id){
    var tag = this.new_tags.unset(friend_id);
    if(tag) tag.remove();
  },

  tag_html: function(friend_info){
    var html = "";
    html += "<li class='friend-tag' id='friend_" + friend_info.id + "'>";
    html += "<div class='sbInfo'><a href='/profiles/" + friend_info.profile_id + "' popup=1>" + friend_info.login + "</a></div>";
    html += "<div class='sbDel'><a href=# onclick='friend_tag_builder.remove_new_tag(" + friend_info.id + ");'>x</a></div>";
    html += "</li>";
    return html;
  },

  add: function(friends){
    for(var i=0;i<friends.length;i++){
      if(!this.tags.get(friends[i].id) && !this.new_tags.get(friends[i].id)){
        Element.insert('friend_tags', {top: this.tag_html(friends[i])});
        this.new_tags.set(friends[i].id, $('friend_'+friends[i].id));
      }
    }
  },

  get_new_tags: function(){
    return this.new_tags.keys();
  },

  set_confirm_button_event: function(){
    this.confirm_button.observe('click', function(event){
      var friend_infos = [];
      var inputs = $$('input');
      for(var i = 0; i < inputs.length; i++){
        if(inputs[i].type == 'checkbox' && inputs[i].checked && !this.tags.get(inputs[i].value) && !this.new_tags.get(inputs[i].value)){
          friend_infos.push(new FriendInfo(inputs[i].value, inputs[i].readAttribute('profile_id'), inputs[i].readAttribute('login')));
        }
      }
      this.add(friend_infos);
      this.hide_friends(); 
    }.bind(this));
  },

  get_games: function(){
    new Ajax.Request('/friend_tags/games_list', {
      method: 'get',
      onSuccess: function(transport){
        this.selector.innerHTML = transport.responseText;
        this.selector.observe('change', function(){
          this.get_friends($F(this.selector)); 
        }.bind(this));
      }.bind(this)
    });
  },

  get_friends: function(game_id){
    new Ajax.Request('/friend_tags/friends_list?game_id=' + game_id, {
      method: 'get',
      onSuccess: function(transport){
        this.friends_list.innerHTML = transport.responseText;
      }.bind(this)
    });
  },

  hide_friends: function(){
    if(this.popup){ 
      this.popup.hide();
      var inputs = $$('input');
      for(var i=0;i<inputs.length;i++){
        if(inputs[i].type == 'checkbox')
          inputs[i].checked = false;
      }
    }
  },

  show_friends: function(){
    if(this.popup){
      this.popup.show();
      return;
    }
    
    this.popup = new Element('div');
    this.game_category = new Element('div');
    this.label = new Element('label').update('select friends: ');
    this.selector = new Element('select');
    this.friends_list = new Element('div');
    this.confirm_button = new Element('button').update('confirm');
    this.game_category.appendChild(this.label);
    this.game_category.appendChild(this.selector);
    this.popup.appendChild(this.game_category);
    this.popup.appendChild(this.friends_list);
    this.popup.appendChild(this.confirm_button);
    
    this.set_confirm_button_event();
    this.get_games();
    this.get_friends('all');   
    
    this.friends_list.setStyle({
      width: '350px',
      height: '150px',
      overflow: 'auto'
    });
    
    this.popup.setStyle({
      position: 'absolute',
      left: (this.text_field.positionedOffset().left + this.text_field.offsetWidth - 350) + 'px',
      top: (this.text_field.positionedOffset().top + this.text_field.offsetHeight) + 'px',
    });

    document.body.appendChild(this.popup);
    this.popup.show();
  }

});

function add_friend_tag(input_field, selected_li){
  var id = selected_li.readAttribute('id');
  var profile_id = selected_li.readAttribute('profile_id');
  var login = selected_li.innerHTML;
  tag_builder.add([new FriendInfo(id, profile_id, login)]);
  input_field.clear();
}

