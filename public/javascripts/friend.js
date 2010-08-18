//好友
Iyxzone.Friend = {

  version: '1.9',

  author: ['高侠鸿'],

  Suggestor: {},

  Request: {},

  Tagger: Class.create({}) // only used in Blog or Video
};

// destroy friend
Object.extend(Iyxzone.Friend, {

  destroy: function(friendID, link){
    new Ajax.Request(Iyxzone.URL.destroyFriend(friendID), {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          Iyxzone.Facebox.close();
          $('friend_' + friendID).remove();
        }else if(json.code == 0){
          error("发生错误");
        }
      }.bind(this)
    });
  },

  confirmDestroying: function(friendID, link){
    Iyxzone.Facebox.confirmWithValidation("你确定要解除好友关系吗?", null, null, function(){
      this.destroy(friendID, link);
    }.bind(this)); 
  }

});

// create friend request
Object.extend(Iyxzone.Friend.Request, {

  clicked: false,

  validate: function(val){
    if(val.length > 80){
      alert('最多80个字');
      return false;
    }

    return true;
  },

  send: function(form, btn, friendID){
    Iyxzone.disableButton(btn, "发送..");
    if(this.validate($('request_data').value)){
      new Ajax.Request(Iyxzone.URL.createFriendRequest(friendID), {
        method: 'post',
        parameters: $(form).serialize(),
        onLoading: function(){
          Iyxzone.changeCursor('wait');
        },
        onComplete: function(){
          Iyxzone.changeCursor('default');
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            notice("发送成功");
          }else if(json.code == 0){
            var errors = json.errors;
            errors.each(function(error){
              if(error[0] == 'friend_id'){
                Iyxzone.Facebox.error(error[1]);
              }
            }.bind(this));
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButton(btn, "发送");
    }
  },

  clickTextArea: function(field){
    if(!this.clicked){
      this.clicked = true;
      field.clear();
    }
  },

  accept: function(requestID, btn){
    new Ajax.Request(Iyxzone.URL.acceptFriendRequest(requestID), {
      method: 'put',
      onLoading: function(){
        Iyxzone.disableButton(btn, "提交..");
        Iyxzone.changeCursor("wait");
      },
      onComplete: function(){
        Iyxzone.changeCursor("default");
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          var info = $('friend_info_' + requestID);
          var parent = info.up();
          parent.update('');
          parent.appendChild(info);
          info.show();
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  decline: function(requestID, btn){
    new Ajax.Request(Iyxzone.URL.declineFriendRequest(requestID), {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor("wait");
      },
      onComplete: function(){
        Iyxzone.changeCursor("default");
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('friend_request_option_' + requestID).innerHTML = '<strong class="nowrap"><span class="icon-success"></span>拒绝请求成功！</strong>';
          setTimeout(function(){new Effect.Fade('friend_request_' + requestID );}, 2000);
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  }

});

//战友
Iyxzone.Comrade = {
  version: '1.0',
  author: ['高侠鸿'],
  Suggestor: {}
};

Object.extend(Iyxzone.Friend.Suggestor, {

  newSuggestion: function(suggestionID, token, nicerLayout){
    // consturct except parameters
    var url = '/friend_suggestions/new';
    var exceptIDs = [];
    var suggestions = $('friend_suggestions').childElements();
    for(var i=0;i<suggestions.length;i++){
      exceptIDs.push(suggestions[i].readAttribute('suggestion_id'));
    }
    var exceptParam = "";
    for(var i=0;i<exceptIDs.length;i++){
      exceptParam += "except_ids[]=" + exceptIDs[i] + "&";
    }
    
    // construct url
    url += "?" + exceptParam;
    
    // send ajax request
    new Ajax.Request(url, {
      method: 'get',
      parameters: {sid: suggestionID, authenticity_token: encodeURIComponent(token), nicer: nicerLayout},
      onSuccess: function(transport){
        var card = $('friend_suggestion_' + suggestionID);
        var temp_parent = new Element('div');
        temp_parent.update(transport.responseText);
        var li = temp_parent.childElements()[0];
        li.setStyle({'opacity': 0});
        Element.replace(card, li);
        new Effect.Opacity(li, { from: 0, to: 1 })
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.Comrade.Suggestor, {

  newSuggestion: function(serverID, suggestionID, token){
    var url = 'friend_suggestions/new';
    var exceptIDs = [];
    var suggestions = $('server_' + serverID + '_suggestions').childElements();
    for(var i=0;i<suggestions.length;i++){
      exceptIDs.push(suggestions[i].readAttribute('suggestion_id'));
    }
    var exceptParam = "";
    for(var i=0;i<exceptIDs.length;i++){
      exceptParam += "except_ids[]=" + exceptIDs[i] + "&";
    }

    // construct url
    url += "?" + exceptParam;

    // send ajax request
    new Ajax.Request(url, {
      method: 'get',
      parameters: {sid: suggestionID, server_id: serverID, authenticity_token: encodeURIComponent(token)},
      onSuccess: function(transport){
        var card = $('comrade_suggestion_' + suggestionID);
        var temp_parent = new Element('div');
        temp_parent.update( transport.responseText);
        var li = temp_parent.childElements()[0];
        li.setStyle({'opacity': 0});
        Element.replace(card, li);
        new Effect.Opacity(li, { from: 0, to: 1 })
      }.bind(this)
    });

  }

});

Iyxzone.Friend.Autocompleter = Class.create(Autocompleter.Local, {

  initialize: function($super, element, update, options){
    options = Object.extend({
      selector: function(instance){
        var options = instance.options;
        var pinyins = options.pinyins;
        var names = options.names;
        var ids = options.ids;
        var token = instance.getToken();
        var ret = [];

        for(var i=0;i < pinyins.length;i++){
          var pinyinPos = options.ignoreCase ? pinyins[i].toLowerCase().indexOf(token.toLowerCase()) : pinyins[i].indexOf(token);
          var namePos = options.ignoreCase ? names[i].toLowerCase().indexOf(token.toLowerCase()) : names[i].indexOf(token);
          if(pinyinPos >= 0 || namePos >= 0){
            ret.push('<li style="list-style-type:none;" id=' + ids[i] + ' ><a href="javascript:void(0)">' + names[i] + '</a></li>');
          }
        }

        if(ret.length == 0){
          return options.emptyText;
        }else{     
          return "<ul>" + ret.join('') + "</ul>";
        }
      }
    }, options || {});

    Event.observe(element, 'focus', this.showTip.bindAsEventListener(this));

    $super(element, update, null, options);
  },

  showTip: function(){
    this.update.update( this.options.tipText);
    var comp = this.options.comp;
    
    this.update.setStyle({
      position: 'absolute',
      left: comp.positionedOffset().left + 'px',
      top: (comp.positionedOffset().top + comp.getHeight()) + 'px',
      width: (comp.getWidth() - 10) + 'px',
      maxHeight: '200px',
      overflowX: 'hidden',
      overflowY: 'auto',
      padding: '5px',
      background: 'white',
      border: '1px solid #E7F0E0'
    });

    this.update.show();
  },

  // to prevent ie onbeforeunload from being fired
  onClick: function($super, event){
    Event.stop(event);
    $super(event);
  },

  updateChoices: function($super, data){
    if(data.indexOf('ul') < 0){
      this.update.update( data);
      this.update.show();
    }else{
      $super(data);
    }

    var comp = this.options.comp;
    
    this.update.setStyle({
        position: 'absolute',
        left: comp.positionedOffset().left + 'px',
        top: (comp.positionedOffset().top + comp.getHeight()) + 'px',
        width: (comp.getWidth() - 10) + 'px',
        maxHeight: '200px',
        overflowX: 'hidden',
        autoflowY: 'auto',
        padding: '5px',
        background: 'white',
        border: '1px solid #E7F0E0'
    });
  }

});

Iyxzone.Friend.Tagger = Class.create({
 
  initialize: function(max, tagInfos, toggleButton, input, friendList, friendTable, friendItems, gameSelector, confirmButton, cancelButton){
    this.max = max;
    this.tags = new Hash(); // friendID => div //[tagIDs, div]
    this.newTags = new Hash(); // friendID => div
    this.delTags = new Array();
    this.toggleButton = $(toggleButton);
    this.friendList = $(friendList);
    this.friendTable = $(friendTable);
    this.friendItems = $(friendItems);
    this.confirmButton = $(confirmButton);
    this.cancelButton = $(cancelButton);
    this.gameSelector = $(gameSelector);

    // set text box list
    this.taggedUserList = new TextBoxList(input, {
      onBoxDispose: this.removeBox.bind(this),
      holderClassName: 'friend-select-list s_clear',
      bitClassName: ''
    });

    for(var i=0;i<tagInfos.length;i++){
      var info = tagInfos[i];
      var el = this.taggedUserList.add(info.friend_id, info.friend_name);
      this.tags.set(info.friend_id, el);
    }

    var inputs = $$('input');
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'checkbox'){
        inputs[i].checked = false;
        inputs[i].observe('click', this.afterCheckFriend.bindAsEventListener(this));
        if(this.tags.keys().include(inputs[i].value)){
          inputs[i].checked = true;
        }
      }
    }

    // toggle button event
    Event.observe(this.toggleButton, 'click', function(e){
      this.toggleFriends();
			Event.stop(e);
    }.bind(this), false);

    // confirm button event
    Event.observe(this.confirmButton, 'click', function(event){
      Event.stop(event);
      
      var checked = new Hash();
      var delTags = new Array();
      var newTags = new Array();
      var inputs = $$('input');

      for(var i=0;i<inputs.length;i++){
        if(inputs[i].type == 'checkbox' && inputs[i].checked){
          checked.set(inputs[i].value, {id: inputs[i].value, login: inputs[i].readAttribute('login')});
        }
      }
      
      this.tags.keys().each(function(key){
        if(!checked.keys().include(key)){
          delTags.push(key);
        }
      }.bind(this));
      
      this.newTags.keys().each(function(key){
        if(!checked.keys().include(key)){
          delTags.push(key);
        }
      }.bind(this));
      
      this.removeTags(delTags);

      var tagIDs = this.tags.keys();
      var newTagIDs = this.newTags.keys();
      checked.each(function(pair){
        var input = pair.value;
        var key = pair.key;
        if(!tagIDs.include(key) && !newTagIDs.include(key)){
          newTags.push(input);
        }
      }.bind(this));
      this.addTags(newTags);

      this.toggleFriends();
    }.bind(this));
    
    // cancel button events
    Event.observe(this.cancelButton, 'click', function(event){
      Event.stop(event);
      this.toggleFriends();
    }.bind(this),false);

    // game selector event
    Event.observe(this.gameSelector, 'change', function(e){
      this.getFriends(this.gameSelector.value);
			Event.stop(e);
    }.bind(this), false); 

    // custom auto completer
    var pinyins = [];
    var names = [];
    var ids = [];

    this.friendItems.childElements().each(function(li){
      pinyins.push(li.down('input').readAttribute('pinyin'));
      names.push(li.down('input').readAttribute('login'));
      ids.push(li.down('input').value);
    }.bind(this));

    new Iyxzone.Friend.Autocompleter(this.taggedUserList.getMainInput(), this.friendList, {
      ids: ids, 
      names: names, 
      pinyins: pinyins, 
      afterUpdateElement: this.afterSelectFriend.bind(this),
      tipText: '输入你好友的名字或者拼音',
      emptyText: '没有匹配的好友...',
      comp: this.taggedUserList.holder
    }); 
  },

  removeBox: function(el, input){
    var friendID = input.value;
  
    var tagInfo = this.tags.unset(friendID);
    
    if(tagInfo){
      // remove exsiting tag
      this.delTags.push(friendID);
    }else{
      // remove new tag
      this.newTags.unset(friendID);
    }

    // uncheck boxes
    var inputs = $$('input');
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'checkbox' && inputs[i].value == friendID){
        inputs[i].checked = false;
      }
    }
  },

  removeTags: function(friendIDs){
    for(var i=0;i<friendIDs.length;i++){
      var friendID = friendIDs[i];
      var tagInfo = this.tags.unset(friendID);
      if(tagInfo){
        // remove exsiting tag
        this.delTags.push(friendID);
        tagInfo.remove();
      }else{
        // remove new tag
        var div = this.newTags.unset(friendID);
        div.remove();
      }
    }
  },

  addTags: function(friends){
    for(var i=0;i<friends.length;i++){
      var el = this.taggedUserList.add(friends[i].id, friends[i].login);
      this.newTags.set(friends[i].id, el);
    }
  },

  getNewTags: function(){
    return this.newTags.keys();
  },

  getDelTags: function(){
    return this.delTags;
  },

  getFriends: function(game_id){
    var friends = this.friendItems.childElements();
    friends.each(function(f){
      var info = f.readAttribute('info').evalJSON();
      var games = info.games;
      if(game_id == 'all' || games.include(game_id)){
        f.show();
      }else{
        f.hide();
      }
    }.bind(this));
  },

  toggleFriends: function(){
    if(!this.friendTable.visible()){
      var pos = this.toggleButton.positionedOffset();
      this.friendTable.setStyle({
        position: 'absolute',
        left: (pos.left + this.toggleButton.getWidth() - this.friendTable.getWidth()) + 'px',
        top: (pos.top + this.toggleButton.getHeight()) + 'px'
      });
      this.friendTable.show();
    }else{
      this.friendTable.hide();
    }
  },

  afterSelectFriend: function(input, selectedLI){
    var id = selectedLI.readAttribute('id');
    //var profileID = selectedLI.readAttribute('profileID');
    var login = selectedLI.childElements()[0].innerHTML;
    input.clear();

    if(this.tags.keys().include(id) || this.newTags.keys().include(id)){
      return;
    }else{
      if(this.tags.keys().length + this.newTags.keys().length >= this.max){
        error('最多选' + this.max + '个!');
        return;
      }

      this.addTags([{id: id, login: login}]);//profileID: profileID, login: login}]);
      input.clear();
      
      var inputs = $$('input');
      for(var i = 0; i < inputs.length; i++){
        if(inputs[i].type == 'checkbox' && inputs[i].value == id){
          inputs[i].checked = true;
        }
      }
    }
  },

  afterCheckFriend: function(mouseEvent){
    var checkbox = mouseEvent.target;
    
    if(!checkbox.checked){
      return;
    }

    var inputs = $$('input');
    var checked = 0;

    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'checkbox' && inputs[i].checked)
        checked++;
    }
 
    if(checked > this.max){
      error('最多选' + this.max + '个!');
      checkbox.checked = false;
      return;
    }
  },

  reset: function(){
    // move new tags to tags
    this.newTags.each(function(pair){
      this.tags.set(pair.key, pair.value);
    }.bind(this));

    // reset del tags
    this.delTags = new Array();
    this.newTags = new Hash();
  }

});
