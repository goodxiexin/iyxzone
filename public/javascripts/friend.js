//好友
Iyxzone.Friend = {
  version: '1.0',
  author: ['高侠鸿'],
  Suggestor: {},
	NicerSuggestor: {}, //for layout reason
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

Object.extend(Iyxzone.Friend.NicerSuggestor, {

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
      parameters: {authenticity_token: encodeURIComponent(token), nicer: 1}, //encodeURIComponent(token)},
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
    this.update.innerHTML = this.options.tipText;
    var comp = this.options.comp;
    
    this.update.setStyle({
        position: 'absolute',
        left: comp.positionedOffset().left + 'px',
        top: (comp.positionedOffset().top + comp.getHeight()) + 'px',
        width: (comp.getWidth() - 10) + 'px',
        maxHeight: '200px',
        overflow: 'auto',
        padding: '5px',
        background: 'white',
        border: '1px solid #E7F0E0'
    });

    this.update.show();
  },

  updateChoices: function($super, data){
    if(data.indexOf('ul') < 0){
      this.update.innerHTML = data;
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
        overflow: 'auto',
        padding: '5px',
        background: 'white',
        border: '1px solid #E7F0E0'
    });
  }

});

Iyxzone.Friend.Tagger = Class.create({
 
  initialize: function(max, friendIDs, tagIDs, friendNames, toggleButton, input, friendList, friendTable, friendItems, gameSelector, confirmButton, cancelButton){
    this.max = max;
    this.tags = new Hash(); // friendID => [tagIDs, div]
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

    for(var i=0;i<friendIDs.length;i++){
      var el = this.taggedUserList.add(friendIDs[i], friendNames[i]);
      this.tags.set(friendIDs[i], [tagIDs[i], el]);
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
    }.bind(this));

    // confirm button event
    Event.observe(this.confirmButton, 'click', function(event){
      Event.stop(event);
      
      var checked = new Hash();
      var delTags = new Array();
      var newTags = new Array();
      var inputs = $$('input');

      for(var i=0;i<inputs.length;i++){
        if(inputs[i].type == 'checkbox' && inputs[i].checked){
          checked.set(inputs[i].value, {id: inputs[i].value, login: inputs[i].readAttribute('login')});//, profileID: inputs[i].readAttribute('profile_id')});
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
    }.bind(this));

    // game selector event
    Event.observe(this.gameSelector, 'change', function(e){
      this.getFriends(this.gameSelector.value);
    }.bind(this)); 

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
      comp: this.taggedUserList.holder,
    }); 
  },

  removeBox: function(el, input){
    var friendID = input.value;
  
    var tagInfo = this.tags.unset(friendID);
    
    if(tagInfo){
      // remove exsiting tag
      this.delTags.push(tagInfo[0]);
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
        this.delTags.push(tagInfo[0]);
        tagInfo[1].remove();
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

  reset: function(tagInfos){
    // move new tags to tags
    this.newTags.each(function(pair){
      var friendID = pair.key;
      var div = pair.value;
      for(var i = 0; i < tagInfos.length; i++){
        if(tagInfos[i].friend_id == friendID){
          this.tags.set(friendID, [tagInfos[i].id, div])
        }
      }
    }.bind(this));

    // reset del tags
    this.delTags = new Array();
    this.newTags = new Hash();
  }

});
