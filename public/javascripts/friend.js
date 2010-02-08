//好友
Iyxzone.Friend = {
  version: '1.0',
  author: ['高侠鸿'],
  Suggestor: {},
  Tagger: Class.create({}) // only used in Blog or Video
};


//战友
Iyxzone.Comrade = {
  version: '1.0',
  author: ['高侠鸿'],
  Suggestor: {}
};

Object.extend(Iyxzone.Friend.Suggestor, {

  newSuggestion: function(suggestionID, token){
    // consturct except parameters
    var url = 'friend_suggestions/new';
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
      parameters: {authenticity_token: encodeURIComponent(token)}, //encodeURIComponent(token)},
      onSuccess: function(transport){
        var card = $('friend_suggestion_' + suggestionID);
        var temp_parent = new Element('div');
        temp_parent.innerHTML = transport.responseText;
        var li = temp_parent.childElements()[0];
        li.hide();
        Element.replace(card, li);
        li.appear({duration: 3.0});
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.Comrade.Suggestor, {

  newSuggestion: function(serverID, suggestionID, token){
    // construct except parameters
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
      parameters: {server_id: serverID, authenticity_token: encodeURIComponent(token)}, //encodeURIComponent(token)},
      onSuccess: function(transport){
        var card = $('comrade_suggestion_' + suggestionID);
        var temp_parent = new Element('div');
        temp_parent.innerHTML = transport.responseText;
        var li = temp_parent.childElements()[0];
        li.hide();
        Element.replace(card, li);
        li.appear({duration: 3.0});
      }.bind(this)
    });

  }

});

Iyxzone.Friend.Autocompleter = Class.create(Autocompleter.Base, {

  initialize: function(element, update, url, options) {
    this.baseInitialize(element, update, options);
    this.options.asynchronous  = true;
    this.options.onComplete    = this.onComplete.bind(this);
    this.options.defaultParams = this.options.parameters || null;
    this.url                   = url;
    this.comp = this.options.comp; //位置的参照物，默认是以this.element为参照物
    this.emptyText = this.options.emptyText || "没有匹配的..."
    Event.observe(element, 'focus', this.onInputFocus.bindAsEventListener(this));
  },

  onInputFocus: function(e){
    this.options.onInputFocus(this.element);
  },

  getUpdatedChoices: function() {
    this.startIndicator();

    var entry = encodeURIComponent(this.options.paramName) + '=' + encodeURIComponent(this.getToken());

    this.options.parameters = this.options.callback ? this.options.callback(this.element, entry) : entry;

    if(this.options.defaultParams)
      this.options.parameters += '&' + this.options.defaultParams;

    this.options.parameters += '&friend[login]=' + this.element.value;

    new Ajax.Request(this.url, this.options);
  },

  onComplete: function(request) {
    if(request.responseText.indexOf('li') < 0){
      this.update.innerHTML = this.options.emptyText;
    }else{
      this.updateChoices(request.responseText);
    }
    if(this.comp){
      this.update.setStyle({
        position: 'absolute',
        left: this.comp.positionedOffset().left + 'px',
        top: (this.comp.positionedOffset().top + this.comp.getHeight()) + 'px',
        width: (this.comp.getWidth() - 10) + 'px',
        maxHeight: '200px',
        overflow: 'auto',
        padding: '5px',
        background: 'white',
        border: '1px solid #E7F0E0'
      });
    }
  }

});

Iyxzone.Friend.Tagger = Class.create({
 
  initialize: function(friendIDs, tagIDs, friendNames, toggleButton, input, friendList, friendTable, friendItems, gameSelector, confirmButton, cancelButton, token){
    this.token = token;
    this.tags = new Hash(); // friendID => [tagIDs, div]
    this.newTags = new Hash(); // friendID => div
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

    for(var i=0;i<friendIDs.length;i++){
      var el = this.taggedUserList.add(friendIDs[i], friendNames[i]);
      this.tags.set(friendIDs[i], [tagIDs[i], el]);
    }

    var inputs = $$('input');
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'checkbox'){
        inputs[i].checked = false;
        if(this.tags.keys().include(inputs[i].value))
          inputs[i].checked = true;
      }
    }

    // toggle button event
    Event.observe(this.toggleButton, 'click', function(e){
      this.toggleFriends();
    }.bind(this));

    // confirm button event
    Event.observe(this.confirmButton, 'click', function(event){
      Event.stop(event);

      var friendInfos = [];
      var delTags = new Array();
      var newTags = new Array();

      var inputs = $$('input');
      for(var i = 0; i < inputs.length; i++){
        if(inputs[i].type == 'checkbox'){
          if(inputs[i].checked){
            if(!this.tags.keys().include(inputs[i].value) && !this.newTags.keys().include(inputs[i].value))
              newTags.push({id: inputs[i].value, profileID: inputs[i].readAttribute('profileID'), login: inputs[i].readAttribute('login')});
          }else{
            if(this.newTags.keys().include(inputs[i].value) || this.tags.keys().include(inputs[i].value))
              delTags.push(inputs[i].value);
          } 
        }
      }

      this.addTags(newTags);
      this.removeTags(delTags);
      this.toggleFriends();
    }.bind(this));
    
    // cancel button events
    Event.observe(this.cancelButton, 'click', function(event){
      Event.stop(event);
      this.toggleFriends();
    }.bind(this));

    // game selector event
    Event.observe(this.gameSelector, 'change', function(e){
      this.getFriends(this.gameSelector.value);
    }.bind(this)); 

    // custom auto completer
    new Iyxzone.Friend.Autocompleter(this.taggedUserList.getMainInput(), this.friendList, '/auto_complete_for_friend_tags', {
      method: 'get',
      emptyText: '没有匹配的好友...',
      afterUpdateElement: this.afterSelectFriend.bind(this),
      onInputFocus: this.showTips.bind(this),
      comp: this.taggedUserList.holder,
      onLoading: this.searching.bind(this),
    });
  },

  searching: function(){
    this.friendList.innerHTML = '正在搜索你的好友...';
    this.friendList.setStyle({
      position: 'absolute',
      left: this.taggedUserList.holder.positionedOffset().left + 'px',
      top: (this.taggedUserList.holder.positionedOffset().top + this.taggedUserList.holder.getHeight()) + 'px',
      width: (this.taggedUserList.holder.getWidth() - 10) + 'px',
      maxHeight: '200px',
      overflow: 'auto',
      padding: '5px',
      background: 'white',
      border: '1px solid #E7F0E0'
    });
    this.friendList.show();
  },

  showTips: function(){
    this.friendList.innerHTML = '输入你好友的拼音';
    this.friendList.setStyle({
      position: 'absolute',
      left: this.taggedUserList.holder.positionedOffset().left + 'px',
      top: (this.taggedUserList.holder.positionedOffset().top + this.taggedUserList.holder.getHeight()) + 'px',
      width: (this.taggedUserList.holder.getWidth() - 10) + 'px',
      maxHeight: '200px',
      overflow: 'auto',
      padding: '5px',
      background: 'white',
      border: '1px solid #E7F0E0'
    });
    this.friendList.show();
  }, 

  removeBox: function(el, input){
    var friendID = input.value;
  
    var tagInfo = this.tags.unset(friendID);
    if(tagInfo){
      // remove exsiting tag
      new Ajax.Request('/friend_tags/' + tagInfo[0], {method: 'delete', parameters: 'authenticity_token=' + encodeURIComponent(this.token)});
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
        new Ajax.Request('/friend_tags/' + tagInfo[0], {method: 'delete', parameters: 'authenticity_token=' + encodeURIComponent(this.token)});
        tagInfo[1].remove();
      }else{
        // remove new tag
        var div = this.newTags.unset(friendID);
        div.remove();
      }
    }
  },

  addTags: function(friends){
    if(friends.length == 0)
      return;
    
    for(var i=0;i<friends.length;i++){
      var el = this.taggedUserList.add(friends[i].id, friends[i].login);
      this.newTags.set(friends[i].id, el);
    }
  },

  getNewTags: function(){
    return this.newTags.keys();
  },

  getFriends: function(game_id){
    this.friendItems.innerHTML = '<img src="/images/loading.gif" style="text-align:center"/>';
    new Ajax.Request('/friend_table_for_friend_tags?game_id=' + game_id, {
      method: 'get',
      onSuccess: function(transport){
        this.friendItems.innerHTML = transport.responseText;
      }.bind(this)
    });
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
      if(this.friendItems.innerHTML == ''){
        this.friendItems.innerHTML = '<img src="/images/loading.gif" style="text-align:center"/>';
        new Ajax.Request('/friend_table_for_friend_tags?game_id=all', {
          method: 'get',
          onSuccess: function(transport){
            this.friendItems.innerHTML = transport.responseText;
          }.bind(this)
        });
      }
    }else{
      this.friendTable.hide();
    }
  },

  afterSelectFriend: function(input, selectedLI){
    var id = selectedLI.readAttribute('id');
    var profileID = selectedLI.readAttribute('profileID');
    var login = selectedLI.childElements()[0].innerHTML;
    this.addTags([{id: id, profileID: profileID, login: login}]);
    input.clear();
  },

  reset: function(tagInfos){
    // clear current data
    this.newTags = new Hash();
    this.tags = new Hash();
    this.taggedUserList.disposeAll();

    // save new data
    for(var i=0;i<tagInfos.length;i++){
      var el = this.taggedUserList.add(tagInfos[i].friend_id, tagInfos[i].friend_login);
      this.tags.set(tagInfos[i].friend_id, [tagInfos[i].id, el]);
    }
  }

});
