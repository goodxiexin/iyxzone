Iyxzone.Game = {
  version: '1.0',

  author: ['高侠鸿'],

  infos: null, // name and id 

  Suggestor: {},

  Selector: Class.create({}),

  PinyinSelector: Class.create({}),

  Feeder: {},

  initPinyinSelector: function(game, gameDiv, area, areaDiv, server, serverDiv, race, raceDiv, profession, professionDiv, initValue, options){
    if(Iyxzone.Game.infos == null){
      alert('错误');
      return;
    }

    $(game).innerHTML = '';
    $(game).update( '<option value="">---</option>');
    
    Iyxzone.Game.infos.each(function(info){
      Element.insert(game, {bottom: '<option value=' + info.id + '>' + info.name + '</option>'});
    }.bind(this));
    
    $(game).value = '';
 
    return new Iyxzone.Game.PinyinSelector(game, gameDiv, area, areaDiv, server, serverDiv, race, raceDiv, profession, professionDiv, initValue, options);
  }
};

Iyxzone.Game.Selector = Class.create({

  details: new Hash(),

  initialize: function(gameSelectorID, gameInfoDiv, areaSelectorID, areaInfoDiv, serverSelectID, serverInfoDiv, raceSelectorID, raceInfoDiv, professionSelectorID, professionInfoDiv, gameDetails, options){
    this.gameSelectorID = gameSelectorID;
    this.gameInfoDiv = gameInfoDiv;
    this.areaSelectorID = areaSelectorID;
    this.areaInfoDiv = areaInfoDiv;
    this.serverSelectID = serverSelectID;
    this.serverInfoDiv = serverInfoDiv;
    this.raceSelectorID = raceSelectorID;
    this.raceInfoDiv = raceInfoDiv;
    this.professionSelectorID = professionSelectorID;
    this.professionInfoDiv = professionInfoDiv;
    this.details = gameDetails;

    // 钩子函数 
    this.options = Object.extend({
      onGameChange: Prototype.emptyFunction,
      onAreaChange: Prototype.emptyFunction,
      onServerChange: Prototype.emptyFunction,
      onRaceChange: Prototype.emptyFunction,
      onProfessionChange: Prototype.emptyFunction
    }, options || {});

    this.setEvents();
  },

  setEvents: function(){
    if(this.gameSelectorID)
      Event.observe(this.gameSelectorID, 'change', this.gameChange.bind(this));

    if(this.areaSelectorID)
      Event.observe(this.areaSelectorID, 'change', this.areaChange.bind(this));
    
    if(this.serverSelectID)
      Event.observe(this.serverSelectID, 'change', this.serverChange.bind(this));

    if(this.raceSelectorID)
      Event.observe(this.raceSelectorID, 'change', this.raceChange.bind(this));

    if(this.professionSelectorID)
      Event.observe(this.professionSelectorID, 'change', this.professionChange.bind(this));
  },

  resetGameInfo: function(){
    if(!this.gameSelectorID) return;
    if($(this.gameSelectorID))
      $(this.gameSelectorID).value = '';
  },

  updateGameInfoDiv: function(text){
    if($(this.gameInfoDiv)){
      $(this.gameInfoDiv).update(text);
    }
  },

  resetAreaInfo: function(){
    if($(this.areaSelectorID))
      $(this.areaSelectorID).update('<option value="">---</option>');
  },

  setupAreaInfo: function(areas){
    if(!this.areaSelectorID) return;
    var html = '<option value="">---</option>';
    for(var i=0;i<areas.length;i++){
      html += "<option value='" + areas[i].id + "'>" + areas[i].name + "</option>";
    }
    $(this.areaSelectorID).update(html);
    if($(this.areaInfoDiv))
      $(this.areaInfoDiv).update('');
  },

  updateAreaInfoDiv: function(text){
    if($(this.areaInfoDiv)){
      $(this.areaInfoDiv).update(text);
    }
  },

  resetServerInfo: function(){
    if($(this.serverSelectID)){
      $(this.serverSelectID).update('<option value="">---</option>');
    }
  },

  setupServerInfo: function(servers){
    if(!this.serverSelectID) return;
    var html = '<option value="">---</option>';
    for(var i=0;i<servers.length;i++){
      html += "<option value='" + servers[i].id + "'>" + servers[i].name + "</option>";
    }
    $(this.serverSelectID).update( html);
    if($(this.serverInfoDiv))
      $(this.serverInfoDiv).update('');
  },

  updateServerInfoDiv: function(text){
    if($(this.serverInfoDiv)){
      $(this.serverInfoDiv).update(text);
    }
  },

  resetProfessionInfo: function(){
    if($(this.professionSelectorID)){
      $(this.professionSelectorID).update( '<option value="">---</option>');
    }
  },

  setupProfessionInfo: function(professions){
    if(!this.professionSelectorID) return;
    var html = '<option value="">---</option>';
    for(var i=0;i<professions.length;i++){
      html += "<option value='" + professions[i].id + "'>" + professions[i].name + "</option>";
    }
    $(this.professionSelectorID).update( html);
    if($(this.professionInfoDiv))
      $(this.professionInfoDiv).update('');
  },

  updateProfessionInfoDiv: function(text){
    if($(this.professionInfoDiv)){
      $(this.professionInfoDiv).update(text);
    }
  },

  resetRaceInfo: function(){
    if($(this.raceSelectorID)){
      $(this.raceSelectorID).update( '<option value="">---</option>');
    }
  },

  setupRaceInfo: function(races){
    if(!this.raceSelectorID) return;
    var html = '<option value="">---</option>';
    for(var i=0;i<races.length;i++){
      html += "<option value='" + races[i].id + "'>" + races[i].name + "</option>";
    }
    $(this.raceSelectorID).update( html);
    if($(this.raceInfoDiv))
      $(this.raceInfoDiv).value = '';
  },

  updateRaceInfoDiv: function(text){
    if($(this.raceInfoDiv)){
      $(this.raceInfoDiv).update(text);
    }
  },

  gameChange: function(){
    if(this.gameSelectorID && $(this.gameSelectorID).value == ''){
      this.reset();
      return;
    }
    new Ajax.Request('/game_details/' + $(this.gameSelectorID).value + '.json', {
      method: 'get',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        this.updateGameInfoDiv('正在加载游戏信息');
      }.bind(this),
      onComplete: function(){
        Iyxzone.changeCursor('default');
        this.updateGameInfoDiv('');
      }.bind(this),      
      onSuccess: function(transport){
        var details = transport.responseText.evalJSON().game;
        var gameID = details.id;

        if(gameID != $(this.gameSelectorID).value){
          // 不复原上面的reset了，因为会被请求$(this.gameSelectorID).value的游戏信息覆盖
          return;
        }else{
          this.details = details;
        }
  
        // reset all details if exists
        this.resetAreaInfo();
        this.updateAreaInfoDiv('');
        this.resetServerInfo();
        this.updateServerInfoDiv('');
        this.resetRaceInfo();
        this.updateRaceInfoDiv('');
        this.resetProfessionInfo();
        this.updateProfessionInfoDiv('');
    
        // set all informations
        if(this.details.areas_count == 0){
          this.updateAreaInfoDiv('该游戏没有服务区');
          if(this.details.servers_count == 0){
            this.updateServerInfoDiv('该游戏的服务器还没统计,因此不能注册。请通知我们，我们会火速加上');
          }else{
            this.setupServerInfo(this.details.servers);
          }
        }else{
          this.setupAreaInfo(this.details.areas);
        }
        
        if(this.details.professions_count == 0){
          this.updateProfessionInfoDiv('该游戏没有职业');
        }else{
          this.setupProfessionInfo(this.details.professions);
        }

        if(this.details.races_count == 0){
          this.updateRaceInfoDiv('该游戏没有种族');
        }else{
          this.setupRaceInfo(this.details.races);
        }

        // invoke game change hook        
        this.options.onGameChange(this);
      }.bind(this)
    });
  },

  areaChange: function(){
    if(this.areaSelectorID && $(this.areaSelectorID).value == ''){
      this.resetServerInfo();
      return;
    }
    new Ajax.Request('/area_details/' + $(this.areaSelectorID).value + '.json', {
      method: 'get',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        this.updateAreaInfoDiv('正在加载服务区信息');
      }.bind(this),
      onComplete: function(){
        Iyxzone.changeCursor('default');
        this.updateAreaInfoDiv('');
      }.bind(this),
      onSuccess: function(transport){
        var areaInfo = transport.responseText.evalJSON().game_area;

        //这里假设每个area下面都有server
        this.setupServerInfo(areaInfo.servers);

        this.options.onAreaChange(this);
      }.bind(this)
    });
  },

  serverChange: function(){
    if(this.serverSelectID && $(this.serverSelectID).value == ''){
      return;
    }
    this.options.onServerChange(this);
  },

  raceChange: function(){
    if(this.raceSelectorID && $(this.raceSelectorID).value == ''){
      return;
    }
    this.options.onRaceChange(this);
  },

  professionChange: function(){
    if(this.professionSelectorID && $(this.professionSelectorID).value == ''){
      return;
    }
    this.options.onProfessionChange(this);
  },

  reset: function(){
    this.resetGameInfo();
    this.resetAreaInfo();
    this.resetServerInfo();
    this.resetProfessionInfo();
    this.resetRaceInfo();
    this.details = null;
  },

  getDetails: function(){
    return this.details;
  }

});

Iyxzone.Game.PinyinSelector = Class.create(Iyxzone.Game.Selector, {

  initialize: function($super, gameSelectorID, gameInfoDiv, areaSelectorID, areaInfoDiv, serverSelectID, serverInfoDiv, raceSelectorID, raceInfoDiv, professionSelectorID, professionInfoDiv, gameDetails, options){
    if(Iyxzone.Game.infos == null){
      return;
    }

    $super(gameSelectorID, gameInfoDiv, areaSelectorID, areaInfoDiv, serverSelectID, serverInfoDiv, raceSelectorID, raceInfoDiv, professionSelectorID, professionInfoDiv, gameDetails, options);

    this.mappings = new Hash();
    this.keyPressed = '';
    this.lastPressedAt = null;
    this.currentGameID = null;
 
    if(this.gameInfoDiv){
      $(this.gameInfoDiv).update('可以输入游戏的拼音来快速定位');
    }

    // save start position of each letter: a-z A-Z 
    var i=0;
    for(var i=0;i<26;i++){
      var code = 97 + i;
      var j = this.binarySearch(code);
      if(j != -1){
        this.mappings.set(code, j); //lower case
        this.mappings.set(code - 32, j); //upper case
      }
    }
  },

  setEvents: function($super){
    $super();

    Event.observe($(this.gameSelectorID), 'keyup', function(e){
      Event.stop(e);
      this.onKeyUp(e);
    }.bind(this));

    Event.observe($(this.gameSelectorID), 'blur', function(e){
      this.lastPressedAt = null;
      this.keyPressed = '';
    }.bind(this));      
  },

  binarySearch: function(keyCode){
    var infos = Iyxzone.Game.infos;
    var size = infos.length;
    var i = 0;
    var j = size - 1;
    var c1 = infos[i].pinyin.toLowerCase().charCodeAt(0);
    var c2 = infos[j].pinyin.toLowerCase().charCodeAt(0);
    if(c1 > keyCode) return -1;
    if(c2 < keyCode) return -1;
    while(i != j-1){
      var m = Math.ceil((i+j)/2);
      var c = infos[m].pinyin.toLowerCase().charCodeAt(0);
      if(c < keyCode){
        i = m;
      }else{
        j = m;
      }
    }
    c1 = infos[i].pinyin.toLowerCase().charCodeAt(0);
    c2 = infos[j].pinyin.toLowerCase().charCodeAt(0);
    if(c1 != keyCode && c2 != keyCode) return -1;
    if(c1 == keyCode) return i;
    if(c2 == keyCode) return j;
  },
  
  onKeyUp: function(e){
    var infos = Iyxzone.Game.infos;
    var code = e.keyCode;
    var now = new Date().getTime();
    if(this.lastPressedAt == null || (now - this.lastPressedAt) < 500){
      this.lastPressedAt = now;
      this.keyPressed += String.fromCharCode(e.keyCode);
    }else{
      this.lastPressedAt = now;
      this.keyPressed = String.fromCharCode(e.keyCode);
    }
    var len = this.keyPressed.length;
    var startPos = this.mappings.get(this.keyPressed.charCodeAt(0));
    if(startPos == null) return;
    for(var i = startPos;i < infos.length; i++){
      if(infos[i].pinyin.substr(0, len) == this.keyPressed.toLowerCase()){ // start with this.keyPressed?
        if($(this.gameSelectorID).selectedIndex != i + 1){
          // 这样改变值是不会产生onChange的callback的
          $(this.gameSelectorID).value = $(this.gameSelectorID).options[i + 1].value;
          this.currentGameID = $(this.gameSelectorID).value;
          setTimeout(this.fireGameChangeEvent.bind(this), 500);
        }
        return;
      }
    }
  },

  fireGameChangeEvent: function(){
    if(this.currentGameID == null){
      return;
    }
    this.currentGameID = null;
    this.gameChange();
  }

});

Iyxzone.Game.Autocompleter = Class.create(Autocompleter.Base, {

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

    this.options.parameters += '&tag[name]=' + this.element.value;

    new Ajax.Request(this.url, this.options);
  },

  onComplete: function(request) {
    if(request.responseText.indexOf('li') < 0){
      this.update.update( this.options.emptyText);
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



Object.extend(Iyxzone.Game.Suggestor, {

  tagNames: new Array(),

  tagList: null,

  prepare: function(){
    // set text box list
    this.tagList = new TextBoxList($('game_tags'), {
      onBoxDispose: this.removeTag.bind(this),
      holderClassName: 'friend-select-list s_clear',
      bitClassName: ''
    }); 

    // set custom auto complete
    new Iyxzone.Game.Autocompleter(this.tagList.getMainInput(), $('game_tag_list'), '/auto_complete_for_game_tags', {
      method: 'get',
      emptyText: '没有匹配的关键字...',
      afterUpdateElement: this.afterSelectTag.bind(this),
      onInputFocus: this.showTips.bind(this),
      comp: this.tagList.holder
    });
    
  },

  showTips: function(){
    $('game_tag_list').innerHTML = '输入游戏特点, 拼音或者汉字';
    $('game_tag_list').setStyle({
      position: 'absolute',
      left: this.tagList.holder.positionedOffset().left + 'px',
      top: (this.tagList.holder.positionedOffset().top + this.tagList.holder.getHeight()) + 'px',
      width: (this.tagList.holder.getWidth() - 10) + 'px',
      maxHeight: '200px',
      overflow: 'auto',
      padding: '5px',
      background: 'white',
      border: '1px solid #E7F0E0'
    });
    $('game_tag_list').show();
  },

  afterSelectTag: function(input, selectedLI){
    var text = selectedLI.childElements()[0].innerHTML;
    this.addTag(text);
    input.clear();
  },

  hasTag: function(tagName){
    for(var i=0;i<this.tagNames.length;i++){
      if(tagName == this.tagNames[i])
        return true;
    }
    return false;
  },

  addTag: function(tagName){
    if(this.hasTag(tagName)){
      tip('你已经选择了该标签');
      return;
    }
    this.tagList.add(tagName, tagName);
    this.tagNames.push(tagName);
  },

  removeTag: function(box, input){
    var tagNames = Iyxzone.Game.Suggestor.tagNames;
    var text = input.value;
    for(var i=0;i< tagNames.length;i++){
      if(text == tagNames[i])
        tagNames.splice(i,1);
    }
  },

  suggest: function(button){
    if(this.tagNames.length == 0){
      notice('请您点击游戏相关类型，以便我们向您推荐');
    }else{
      var newGame = $('new_game');
      new Ajax.Request('/game_suggestions/game_tags', {
        method: 'get',
        parameters: {selected_tags: this.tagNames.join(','), new_game: newGame.checked},
        onLoading: function(){
          Iyxzone.disableButton(button, '请等待..');
        },
        onComplete: function(){
          Iyxzone.enableButton(button, '推荐');
        },
        onSuccess: function(transport){
          $('game_suggestion_area').update( transport.responseText);
          window.scrollTo(0, $('game_suggestion_area').cumulativeOffset().top);
        }.bind(this)
      });
    }
  },

  toggleAdvancedOptions: function(){
    if($('advanced_options').visible()){
      Effect.BlindUp($('advanced_options'));
    }else{
      Effect.BlindDown($('advanced_options'));
    }
  }

}); 

Object.extend(Iyxzone.Game.Feeder, {

  idx: 0,

  moreFeeds: function(gameID){
    $('more_feed').innerHTML = '<img src="/images/loading.gif" />';

    new Ajax.Request('/games/' + gameID + '/more_feeds?idx=' + this.idx, {
      method: 'get',
      onSuccess: function(transport){
        this.idx++;
      }.bind(this)
    });
  }

});
