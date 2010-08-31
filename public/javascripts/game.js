Iyxzone.Game = {

  version: '1.6',

  author: ['高侠鸿'],

  infos: null, // name and id 

  Suggestor: {},

  Presentor: {},

  Tagger: Class.create({}),

  Selector: Class.create({}),

  PinyinSelector: Class.create({}),

  PanelSelector: Class.create({}),

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
  },

  initPanelSelector: function(game, gameDiv, area, areaDiv, server, serverDiv, race, raceDiv, profession, professionDiv, initValue, options){
    $(game).innerHTML = '';

    return new Iyxzone.Game.PanelSelector(game, gameDiv, area, areaDiv, server, serverDiv, race, raceDiv, profession, professionDiv, initValue, options);
  },

  follow: function(name, gid){
    new Ajax.Request('/mini_topic_attentions', {
      method: 'post',
      parameters: {'name': name},
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      }.bind(this),
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('follow_game_' + gid).innerHTML = '<a onclick="Iyxzone.Game.unfollow(' + json.id + ', \'' + name + '\', ' + gid + '); return false;" href="#"><span class="i iNoFollow"></span>取消关注</a>';
        }else{
          error('发生错误');
        }
      }.bind(this)
    });

  },

  unfollow: function(id, name, gid){
    new Ajax.Request('/mini_topic_attentions/' + id, {
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
          $('follow_game_' + gid).update('<a onclick="Iyxzone.Game.follow(\'' + name + '\', ' + gid + '); return false;" href="#"><span class="i iFollow"></span>关注</a>');
        }else{
          error('发生错误');
        }
      }.bind(this)
    });
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

Iyxzone.Game.PanelSelector = Class.create(Iyxzone.Game.Selector, {

  initialize: function($super, gameSelectorID, gameInfoDiv, areaSelectorID, areaInfoDiv, serverSelectID, serverInfoDiv, raceSelectorID, raceInfoDiv, professionSelectorID, professionInfoDiv, gameDetails, options){
    $(gameSelectorID).replace('<input style="display: none" type="text" name="' + $(gameSelectorID).readAttribute('name') + '" id="' + gameSelectorID + '"/><div class="fldvalue"><div class="selectSim">选择游戏</div></div>');
    
    // 这样gameSelectorID就变成那个新的了
    $super(gameSelectorID, gameInfoDiv, areaSelectorID, areaInfoDiv, serverSelectID, serverInfoDiv, raceSelectorID, raceInfoDiv, professionSelectorID, professionInfoDiv, gameDetails, options);

    // get hot games and truncate it
    Iyxzone.Game.hotGames = Iyxzone.Game.infos.clone().sort(function(a,b){return b.hot - a.hot;});
    Iyxzone.Game.hotGames.length = 20;
    Iyxzone.Game.hotGames[19].id = 716;
    Iyxzone.Game.hotGames[19].name = "绝对女神II";
    Iyxzone.Game.hotGames[19].pinyin = "jueduinvshenII";
    Iyxzone.Game.hotGames[19].hot = 100;
    
    this.panel = null;
    this.panelTrigger = $(gameSelectorID).next();
    this.curLetterCode = null;
    this.lis = new Hash();

    $(this.panelTrigger).observe('click', function(e){
      this.showPanel(e.target);
    }.bind(this));
  },

  setEvents: function($super){
    $super();

    Event.stopObserving($(this.gameSelectorID), 'change');

    Event.observe($(this.gameSelectorID), 'click', function(e){
      Event.stop(e);
      this.showPanel(e.target);
    }.bind(this));
  },

  showPanel: function(el){
    if(this.panel == null){
      this.buildPanel();
      if(this.curLetterCode == null)
        this.changeLetter(123);
    }
    this.locatePanel(el);
    this.panel.show();
  },

  closePanel: function(){
    this.panel.hide();
  },

  locatePanel: function(el){
    if(this.panel){
      this.panel.setStyle({
        position: 'absolute',
        top: ($(el).cumulativeOffset().top) + 20 + 'px',
        left: document.viewport.getWidth() / 2 - 325 + 'px'
      });
    } 
  },

  changeLetter: function(letterCode){
    if(this.curLetterCode == letterCode){
      return;
    }else{
      this.curLetterCode = letterCode;
    }
    this.lis.each(function(pair){
      var code = pair.key;
      var li = pair.value;
      if(code != 123){
        li.writeAttribute({'class': ''});
      }else{
        li.writeAttribute({'class': 'hotGame'});
      }
    });

    if(letterCode == 123){
      this.lis.get(letterCode).addClassName('hotCurrent');
    }else{
      this.lis.get(letterCode).addClassName('current');
    }

    var listLeft = new Element('div', {'class':'t'});
    if(letterCode == 123)
      listLeft.update("<em></em><div class='alphaImg alphaHot'></div>");
    else
      listLeft.update("<em></em><div class='alphaImg alpha-"+ String.fromCharCode(letterCode) + "'></div>");

    var listCon = new Element('div', {'class':'con'});
    var listUl = new Element('ul', {});

    var gameInfos = [];
    if(letterCode == 123){
      gameInfos = Iyxzone.Game.hotGames;
    }else{
      Iyxzone.Game.infos.each(function(g){
        if(g.pinyin.charCodeAt(0) == letterCode){
          gameInfos.push(g);
        }
      }.bind(this));
    }
    
    gameInfos.each(function(g){
        var tempLi = new Element('li');
        var tempA = new Element('a', {href: 'javascript: void(0)', title: g.name, index: g.id});
        tempA.update(g.name);
        tempA.observe('click', function(e){
          this.selectGame(e.target.readAttribute('index'), e.target.readAttribute('title'));
        }.bind(this));
        tempLi.appendChild(tempA);
        listUl.appendChild(tempLi);
    }.bind(this));
    
    this.gameList.update('');
    listCon.appendChild(listUl);
    this.gameList.appendChild(listLeft);
    this.gameList.appendChild(listCon);   
  },

  selectGame: function(gid, gname){
    $(this.gameSelectorID).value = gid;
    $(this.panelTrigger).update(gname); 
    this.closePanel();
    this.gameChange();
  },

  buildPanel: function(letterCode){
    if(this.panel)
      return;

    this.panel = new Element('div', {'class':'allGameSelector'});
    var mask  = new Element('div', {'class': 'mask-wrap'});
    var round1 = new Element('div', {'class':'round07 round_r_t'});
    var round2 = new Element('div', {'class':'round_l_t'});
    var round3 = new Element('div', {'class':'round_r_b'});
    var round4 = new Element('div', {'class':'round_l_b'});
    var round5 = new Element('div', {'class':'round_m'});
    var round6 = new Element('div', {'class':'round_body'});

    var title = new Element('div', {'class':'allGameTitle fix'});
    var h3 = new Element('h3');
    h3.update("<strong>请选择游戏</strong>(点击游戏名称选择游戏)");
    var close = new Element('a', {'class' : "op", href: 'javascript: void(0)'});
    close.update("关闭<span class='icon-active'></span>");
    close.observe('click', function(e){
      this.closePanel();
    }.bind(this));
    title.appendChild(h3);
    title.appendChild(close);

    var alpha = new Element('div', {'class':'alphaList fix'});
    var alphaUl = new Element('ul', {id : "alphabet_list"});
    
    var hotLi = new Element('li', {'class' : 'hotGame'});
    var aLi = new Element('a', {href: 'javascript: void(0)'});
    aLi.update("<span>热门游戏</span>");
    aLi.observe('click', function(e){
      this.changeLetter(123);
    }.bind(this));
    this.lis.set(123, hotLi);
    hotLi.appendChild(aLi);
    alphaUl.appendChild(hotLi);
    
    var tempLi, tempA;
    for (var i=97; i<=122; i++){
      tempLi = new Element('li');
      tempA = new Element('a', {href: 'javascript: void(0)'});
      tempA.update("<span index="+ i +">"+ String.fromCharCode(i) +"</span>");
      tempA.observe('click', function(e){
        this.changeLetter(e.element().readAttribute('index'));
      }.bind(this));
      this.lis.set(i, tempLi);
      tempLi.appendChild(tempA);
      alphaUl.appendChild(tempLi);
    }
    
    alpha.appendChild(alphaUl);
    
    this.gameList = new Element('div', {'class':'catGameList fix'});
    
    round6.appendChild(title);
    round6.appendChild(alpha);
    round6.appendChild(this.gameList);
    round5.appendChild(round6);
    round4.appendChild(round5);
    round3.appendChild(round4);
    round2.appendChild(round3);
    round1.appendChild(round2);
    mask.appendChild(round1);
    var iframeMask = new Element('iframe', {'class':'mask-iframe','frameborder':0,'src':''});
    mask.appendChild(iframeMask);
    this.panel.appendChild(mask);
    document.body.appendChild(this.panel);
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

//一些在game show页面上的操作
Object.extend(Iyxzone.Game.Presentor, {

  feedIdx: 0,

  gameID: null,

  fetchSize: null,

  curTab: null,

  cache: new Hash(),

  init: function(gameID, fetchSize){
    this.gameID = gameID;
    this.feedIdx = 1;
    this.fetchSize = fetchSize;
    this.curTab = 'feed';
    this.cache.set('feed', $('presentation').innerHTML);
  },

  setTab: function(type){
    $('tab_feed').writeAttribute('class', 'fix unSelected');
    $('tab_blog').writeAttribute('class', 'fix unSelected');
    $('tab_album').writeAttribute('class', 'fix unSelected');
    $('tab_wall').writeAttribute('class', 'fix unSelected');
    $('tab_' + type).writeAttribute('class', 'fix');
    this.curTab = type;
  }, 

  showFeeds: function(gameID){
    if(this.curTab == 'feed')
      return;

    this.setTab('feed');

    var html = this.cache.get('feed');
    //一定有
    if(html){
      $('presentation').innerHTML = html;
      return;
    }
  },

  moreFeeds: function(){
    // send ajax request
    new Ajax.Request('/feed_deliveries', {
      method: 'get',
      parameters: {recipient_id: this.gameID, recipient_type: 'Game', fetch: this.fetchSize, idx: this.feedIdx},
      onLoading: function(){
        $('more_feed_panel').innerHTML = '<div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div>';
        this.cache.set('feed', $('presentation').innerHTML);
      }.bind(this),
      onSuccess: function(transport){
        var newFeeds = new Element('div').update(transport.responseText);
        var moreFeeds = new Element('div');
        var len = newFeeds.childElements().length;
        if(len == 0 || len < this.fetchSize){
          moreFeeds.update(this.noFeedHTML());
        }else{
          moreFeeds.update(this.moreFeedHTML());
        }
        
        if(this.curTab == 'feed'){
          $('feed_list').insert({bottom: newFeeds.innerHTML});
          $('more_feed_panel').update(moreFeeds.innerHTML);
          this.cache.set('feed', $('presentation').innerHTML);
        }else{
          var html = this.cache.get('feed');
          var tmp = new Element('div').update(html);
          var oldFeedList = tmp.childElements()[0];
          var oldMoreFeeds = tmp.childElements()[2];
          oldFeedList.insert({bottom: newFeeds.innerHTML});
          oldMoreFeeds.update(moreFeeds.innerHTML);
          this.cache.set('feed', tmp.innerHTML);
        }
  
        this.feedIdx = this.feedIdx + 1; 
      }.bind(this)
    });
  },

  noFeedHTML: function(){
    return this.baseHTML('<div class="jl-more">没有更多了...</div>');
  },

  moreFeedHTML: function(){
    return this.baseHTML('<a href="javascript:void(0)" onclick="Iyxzone.Game.Presentor.moreFeeds();" class="jl-more">更多新鲜事</a>');
  },

  baseHTML: function(con){
    var html = '<div class="round04 round_r_t jl-read-more space s_clear">';
    html += '<div class="round_l_t"><div class="round_r_b"><div class="round_l_b"><div class="round_m"><div class="round_body" id="more_feed_link">';
    html +=  con;
    html += '</div></div></div></div></div></div>';
    return html;
  },

  showBlogs: function(){
    if(this.curTab == 'blog')
      return;

    this.setTab('blog');

    var html = this.cache.get('blog');
    if(html){
      $('presentation').innerHTML = html;
      return;
    }

    new Ajax.Request('/games/' + this.gameID + '/blogs?at=guild_show', {
      method: 'get',
      onLoading: function(){
        $('presentation').innerHTML = '<div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div>';
        this.cache.set('blog', $('presentation').innerHTML);
      }.bind(this),
      onSuccess: function(transport){
        this.cache.set('blog', transport.responseText);
        if(this.curTab == 'blog'){
          $('presentation').innerHTML = transport.responseText;
        }
      }.bind(this)
    });
  },

  showAlbums: function(){
    if(this.curTab == 'album')
      return;

    this.setTab('album');
    
    var html = this.cache.get('album');
    if(html){
      $('presentation').innerHTML = html;
      return;
    }

    new Ajax.Request('/games/' + this.gameID + '/albums?at=guild_show', {
      method: 'get',
      onLoading: function(){
        $('presentation').innerHTML = '<div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div>';
        this.cache.set('album', $('presentation').innerHTML);
      }.bind(this),
      onSuccess: function(transport){
        this.cache.set('album', transport.responseText);
        if(this.curTab == 'album'){
          $('presentation').innerHTML = transport.responseText;
        }
      }.bind(this)
    });
  },

  showWall: function(){
    if(this.curTab == 'wall')
      return;

    this.setTab('wall');

    var html = this.cache.get('wall');
    if(html){
      $('presentation').innerHTML = html;
      return;
    }

    new Ajax.Request('/wall_messages/index_with_form', {
      method: 'get',
      parameters: {wall_id: this.gameID, wall_type: 'game'},
      onLoading: function(){
        $('presentation').innerHTML = '<div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div>';
        this.cache.set('wall', $('presentation').innerHTML);
      }.bind(this),
      onSuccess: function(transport){
        this.cache.set('wall', transport.responseText);
        if(this.curTab == 'wall'){
          $('presentation').innerHTML = transport.responseText;
        }
      }.bind(this)
    });
  },

  // 下面2个函数和上面4个的机制不太一样
  showComrades: function(gameID){
    if($('tab_player')){
      $('tab_player').writeAttribute('class', 'fix unSelected');
      $('player_panel').hide();
    }
    $('tab_comrade').writeAttribute('class', 'fix');
    $('comrade_panel').show();
    $('cp_link').writeAttribute('href', '/games/' + gameID + '/comrades');
  },

  showPlayers: function(gameID){
    if($('tab_comrade')){
      $('tab_comrade').writeAttribute('class', 'fix unSelected');
      $('comrade_panel').hide();
    }
    $('tab_player').writeAttribute('class', 'fix');
    $('player_panel').show();
    $('cp_link').writeAttribute('href', '/games/' + gameID + '/players');
  },

  showGuilds: function(gameID){
    if($('tab_event')){
      $('tab_event').writeAttribute('class', 'fix unSelected');
      $('event_panel').hide();
    }
    $('tab_guild').writeAttribute('class', 'fix');
    $('guild_panel').show();
    $('ge_link').writeAttribute('href', '/games/' + gameID + '/guilds');
  },

  showEvents: function(gameID){
    if($('tab_guild')){
      $('tab_guild').writeAttribute('class', 'fix unSelected');
      $('guild_panel').hide();
    }
    $('tab_event').writeAttribute('class', 'fix');
    $('event_panel').show();
    $('ge_link').writeAttribute('href', '/games/' + gameID + '/events');
  }

});

Iyxzone.Game.Autocompleter2 = Class.create(Autocompleter.Local, {

  gameCache: new Array(),

  isFetching: false,

  initialize: function($super, element, update, options){
    options = Object.extend({}, options || {});

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

  buildListFromCache: function(){
    var thisToken = this.getToken();
    var games = [];
    
    this.gameCache.each(function(game){
      var token = this.options.ignoreCase ? thisToken.toLowerCase() : thisToken;
      var name = this.options.ignoreCase ? game.name.toLowerCase() : game.name;
      var pinyin = this.options.ignoreCase ? game.pinyin.toLowerCase() : game.pinyin;

      if(name.indexOf(token) == 0 || pinyin.indexOf(token) == 0){
        games.push('<li style="list-style-type:none;" id=' + game.id + ' ><a href="javascript:void(0)">' + game.name + '</a></li>');  
      }
    }.bind(this));

    if(games.length == 0){
      return this.options.emptyText;
    }else{
      return "<ul>" + games.join('') + "</ul>";
    }
  },

  getUpdatedChoices: function(){
    var choices = "";

    if(this.gameCache.length == 0){
      if(this.isFetching)
        return;

      new Ajax.Request(Iyxzone.URL.listGameDetails(), {
        method: 'get',
        onLoading: function(){
          this.isFetching = true;
        }.bind(this),
        onComplete: function(){
          this.isFetching = false;
        }.bind(this),
        onSuccess: function(transport){
          this.gameCache = transport.responseText.evalJSON();
          this.updateChoices(this.buildListFromCache());
        }.bind(this)
      });
    }else{
      this.updateChoices(this.buildListFromCache());
    }
  },

  updateChoices: function($super, data){
    if(!this.changed && this.hasFocus){
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
  }

});

Iyxzone.Game.Tagger = Class.create({
 
  initialize: function(max, gameInfos, input, gameList){
    this.max = max;
    this.games = new Hash(); // gameID => text_box_list el
    this.newGames = new Hash(); // gameID => text_box_list el
    this.delGames = new Array();
    this.gameList = $(gameList);

    // set text box list
    this.relGameList = new TextBoxList(input, {
      onBoxDispose: this.removeBox.bind(this),
      holderClassName: 'friend-select-list s_clear',
      bitClassName: ''
    });

    for(var i=0;i<gameInfos.length;i++){
      var info = gameInfos[i];
      var el = this.relGameList.add(info.id, info.name);
      this.games.set(info.id, el);
    }

    // custom auto completer
    new Iyxzone.Game.Autocompleter2(this.relGameList.getMainInput(), this.gameList, {
      afterUpdateElement: this.afterSelectGame.bind(this),
      tipText: '输入你游戏的拼音或者名字',
      emptyText: '没有匹配的游戏...',
      comp: this.relGameList.holder
    }); 
  },

  removeBox: function(el, input){
    var gameID = input.value;
  
    var info = this.games.unset(gameID);
    
    if(info){
      // remove exsiting tag
      this.delGames.push(gameID);
    }else{
      // remove new tag
      this.newGames.unset(gameID);
    }
  },

  getNewRelGames: function(){
    return this.newGames.keys();
  },

  getDelRelGames: function(){
    return this.delGames;
  },

  afterSelectGame: function(input, selectedLI){
    var id = selectedLI.readAttribute('id');
    var name = selectedLI.childElements()[0].innerHTML;
    input.clear();

    if(this.games.keys().include(id) || this.newGames.keys().include(id)){
      return;
    }else{
      if(this.games.keys().length + this.newGames.keys().length >= this.max){
        error('最多选' + this.max + '个!');
        return;
      }

      var el = this.relGameList.add(id, name);
      this.newGames.set(id, el);
    }
  }

});

