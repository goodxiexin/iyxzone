Iyxzone.Profile = {

  version: '1.9',

  author: ['高侠鸿'],
	
  Editor: {},

  Feeder: {},

  Tag: {},

  Presentor: {}
};

Object.extend(Iyxzone.Profile.Presentor, {
	
	curType: null,

	curLoading: false,

  profileID: null,

	cache: new Hash(),

	gameIdx: 1,

	gameFetchSize: 10,

  GameDisplay: {},

  init: function(profileID){
    this.cache.set("home", { loading: false, html: null});
    this.cache.set("info", { loading: false, html: null});
    this.cache.set("feed", { loading: false, html: null});
    this.cache.set("poll", { loading: false, html: null});
    this.cache.set("photo", { loading: false, html: null});
    this.cache.set("blog", { loading: false, html: null});
    this.cache.set("video", { loading: false, html: null});
    this.curType = 'home';
    this.curLoading = false;
    this.profileID = profileID;
  },

  moreGames: function(profileID){
    new Ajax.Request(Iyxzone.URL.moreGamesInProfile(profileID), {
      method: 'get',
      parameters: {"idx": this.gameIdx},
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
				var tmpHtml = transport.responseText
				$('game-list').insert({bottom: tmpHtml});
        var newFeeds = new Element('div');
        newFeeds.innerHTML = tmpHtml;
        var len = newFeeds.childElements().length;
        if(len == 0 || len < this.gameFetchSize){ //说明没有了
					$('more-game-button').hide();
				}
        this.gameIdx++;
      }.bind(this)
    });  
  },

  setTab: function(type){
    $('tab_home').className = '';
    $('tab_info').className = '';
    $('tab_feed').className = '';
    $('tab_poll').className = '';
    $('tab_photo').className = '';
    $('tab_blog').className = '';
    $('tab_video').className = '';
    $('tab_' + type).className = 'selected';
  },

	changeTab: function(type){
    if(this.curType == type)
      return;

    this.cache.set(this.curType, {html: $('profile-main-content').innerHTML, loading: this.curLoading});
   
    var info = this.cache.get(type);
    this.curLoading = info.loading;
    this.curType = type;
    this.setTab(type);

    if(info.html){
      $('profile-main-content').innerHTML = info.html;
      $('profile-main-content').innerHTML.evalScripts();
      return;
    }

    if(this.curLoading)
      return;

    new Ajax.Request(Iyxzone.URL.changeTabInProfile(this.profileID), {
			method: 'get',
			parameters: {category: type},
      onLoading: function(){
        this.curLoading = true;
        $('profile-main-content').update("<div class='ajaxLoading'><img src='/images/ajax-loader.gif' /></div>");
      }.bind(this),
      onSuccess: function(transport){
        var newInfo = new Element('div');
        newInfo.update(transport.responseText);
        if(this.curType == type){ //说明没切换，或者又切了回来
					$('profile-main-content').update(newInfo.innerHTML);
					this.curLoading = false;
				}	else {
					this.cache.set(type, {html: newInfo.innerHTML, loading: false});
				}
			}.bind(this)
		});
	}

});

// follow, unfollow idol
Object.extend(Iyxzone.Profile, {

  followIdol: function(idolID, idolName, profileID, btn){
    new Ajax.Request(Iyxzone.URL.followIdol(idolID), {
      method: 'post',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showProfile(profileID);
        }else if(json.code == 0){
          error('发生错误，请稍后再试');
        }
      }.bind(this)
    });
  },

  unfollowIdol: function(idolID, idolName, profileID, link){
    new Ajax.Request(Iyxzone.URL.unfollowIdol(idolID), {
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
          window.location.href = Iyxzone.URL.showProfile(profileID);
        }else if(json.code == 0){
          error('发生错误，请稍后再试');
        }
      }.bind(this)
    });
  },

  confirmFollowingIdol: function(idolID, idolName, profileID, btn){
    Iyxzone.Facebox.confirmWithCallback("你确定要成为 <b>" + idolName + "</b> 的粉丝吗？这样你可以在首页上看到TA的新鲜事", null, null, function(){
      Iyxzone.Profile.followIdol(idolID, idolName, profileID, btn);
    });
  },

  confirmUnfollowingIdol: function(idolID, idolName, profileID, link){
    Iyxzone.Facebox.confirmWithCallback("你确定要不做 <b>" + idolName + "</b> 的粉丝吗？", null, null, function(){
      Iyxzone.Profile.unfollowIdol(idolID, idolName, profileID, link);
    });
  }

});

Object.extend(Iyxzone.Profile.Presentor.GameDisplay, {

	cache: new Hash(),

	curLoading: false,

	curGame: null,

  startLoading: function(gameID, event){
    var game = $('game-display-' + gameID)
    var gamePic = game.down('img');
    var img = new Element('div', {'id': 'gl-' + gameID}).update('<img src="/images/loading.gif"/>');
    document.body.appendChild(img);

    gamePic.observe('mousemove', function(event){3.2
      img.setStyle({
        'position': 'absolute',
        'left': (event.pointerX() + 10) + 'px',
        'top': (event.pointerY() + 5) + 'px'
      });
    }.bind(this));

    gamePic.observe('mouseout', function(event){
      this.stopLoading(gameID, event);
    }.bind(this));
  },

  stopLoading: function(gameID, event){
    var cursor = $('gl-' + gameID);
    var game = $('game-display-' + gameID);

    if(cursor){
      cursor.remove();
    }

    if(game){
      gamePic = game.down('img');
      gamePic.stopObserving('mousemove');
    }     
  },

  getGameDisplayHTML: function(){
    if($('game-display-panel')){
      var tmp = new Element('div');
      tmp.appendChild($('game-display-panel'));
      return tmp.innerHTML;
    }else{
      return null;
    }
  },

  setGameDisplayHTML: function(html, gameID){
    var tmp = new Element('div').update(html);
    var el = tmp.childElements()[0];
    document.body.appendChild(el);
    el.setStyle({
      'position': 'absolute',
      'left': ($('game-display-' + gameID).cumulativeOffset().left - 100) + 'px',
      'top': ($('game-display-' + gameID).cumulativeOffset().top + 50) + 'px'
    });
  },

  saveCurrentContext: function(){
    this.cache.set(this.curGame, {'loading': this.curLoading, 'html': this.getGameDisplayHTML()});
    this.curLoading = false;
    this.curGame = null;
  },

  mouseOverGamePic: function(gameID, profileID, event){
    if(this.curGame == gameID){
      return;
    }
    if(this.curGame){
      this.saveCurrentContext();
    }

    this.curGame = gameID;
    var info = this.cache.get(gameID);
    if(info){
      this.curLoading = info.loading;
      var html = info.html;
      if(html){
        this.setGameDisplayHTML(html, gameID);
        return;
      }
    }

    if(this.curLoading){
      this.startLoading(gameID, event);
      return;
    }

		new Ajax.Request(Iyxzone.URL.displayGameInProfile(profileID), {
      method: 'get',
			parameters: {'game_id': gameID},
      onLoading: function(){
				this.curLoading = true;
        this.startLoading(gameID, event);
      }.bind(this),
      onComplete: function(){
        this.stopLoading(gameID);
      }.bind(this),
      onSuccess: function(transport){
        var html = transport.responseText;
        if(this.curGame == gameID){
          this.setGameDisplayHTML(html, gameID);
          this.curLoading = false;
				}
        this.cache.set(gameID, {'loading': false, 'html': html});
      }.bind(this)
		});
	},

  mouseOutGamePic: function(gameID, event){
    var to = event.relatedTarget || event.fromElement;
    if($('game-display-panel')){
      if($(to) && $(to) != $('game-display-panel') && !$(to).descendantOf('game-display-panel')){
        this.saveCurrentContext();
      }
    }else{
      this.saveCurrentContext();
    }
  },

  mouseOverGamePanel: function(gameID, event){
    // nothing to do
  },

  mouseOutGamePanel: function(gameID, event){
    var to = event.relatedTarget || event.fromElement;
    // prevent event bubble
    if($(to) && $(to) != $('game-display-panel') && !$(to).descendantOf('game-display-panel'))
      this.saveCurrentContext();
  },

  follow: function(name, gid){
    new Ajax.Request(Iyxzone.URL.createMiniTopicAttention(), {
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
          if($('follow_game_' + gid))
            $('follow_game_' + gid).innerHTML = '<a onclick="Iyxzone.Profile.Presentor.GameDisplay.unfollow(' + json.id + ', \'' + name + '\', ' + gid + '); return false;" href="#"><span class="i iNoFollow"></span>取消关注</a>';
          // reset cache
          this.cache.set(gid, this.getGameDisplayHTML());
        }else{
          error('发生错误');
        }
      }.bind(this)
    });

  },

  unfollow: function(id, name, gid){
    new Ajax.Request(Iyxzone.URL.deleteMiniTopicAttention(id), {
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
          if($('follow_game_' + gid))
            $('follow_game_' + gid).update('<a onclick="Iyxzone.Profile.Presentor.GameDisplay.follow(\'' + name + '\', ' + gid + '); return false;" href="#"><span class="i iFollow"></span>关注</a>');
          this.cache.set(gid, this.getGameDisplayHTML());
        }else{
          error('发生错误');
        }
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.Profile.Editor, {

  loading: function(div, title){
    div.innerHTML = '<div class="edit-toggle space edit"><h3 class="s_clear"><strong class="left">' + title + '</strong><a href="#" class="right">取消</a></h3><div class="formcontent con con2"><div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div></div></div>';
  },

  showError: function(div, content){
    var span = new Element('span', {"class": 'icon-warn'});
    $(div).update(content);
    Element.insert($(div), {"top": span});
  },

  clearError: function(div){
    $(div).update('');
  },

  regionSelector: null,

  setRegionSelector: function(regionID, cityID, districtID){
    this.regionSelector = new Iyxzone.ChineseRegion.Selector(regionID, cityID, districtID);
  },

  basicInfoHTML: null,

  editBasicInfoHTML: null,

  isEditingBasicInfo: false,

  editBasicInfo: function(profileID){
    if(this.isEditingBasicInfo)
      return;
    else
      this.isEditingBasicInfo = true;

    var frame = $('basic_info_frame');
    this.basicInfoHTML = frame.innerHTML;
    if(this.editBasicInfoHTML){
      frame.update( this.editBasicInfoHTML);
      this.regionSelector.setEvents();
    }else{
      new Ajax.Updater('basic_info_frame', Iyxzone.URL.editProfile(profileID, {'type': 1}), {
        method: 'get',
        evalScripts: true,
        onLoading: function(){
          this.loading(frame, '基本信息');
        }.bind(this),
        onSuccess: function(transport){
          this.editBasicInfoHTML = transport.responseText;
        }.bind(this)
      });
    }
  },

  cancelEditBasicInfo: function(){
    $('basic_info_frame').update( this.basicInfoHTML);
    this.isEditingBasicInfo = false;
  },

  validateBasicInfo: function(){
    return true;
  },

  updateBasicInfo: function(profileID, button, form){
    if(this.validateBasicInfo()){
      new Ajax.Request(Iyxzone.URL.updateProfile(profileID, {'type': 1}), {
        method: 'put',
        parameters: $(form).serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '请等待..');
          Iyxzone.changeCursor('wait');
        },
        onComplete: function(){
          Iyxzone.changeCursor('default');
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            $('basic_info_frame').update(json.html);
            this.isEditingBasicInfo = false;
            this.editBasicInfoHTML = null;
            this.regionSelector = null;
          }else{
            error("发生错误");
            Iyxzone.enableButton(button, '保存');
          }
        }.bind(this)
      });
    }
  },

  contactInfoHTML: null,

  editContactInfoHTML: null,

  isEditingContactInfo: false,

  editContactInfo: function(profileID){
    if(this.isEditingContactInfo)
      return;
    else
      this.isEditingContactInfo = true;

    var frame = $('contact_info_frame');
    this.contactInfoHTML = frame.innerHTML;
    if(this.editContactInfoHTML){
      frame.update( this.editContactInfoHTML);
    }else{
      new Ajax.Request(Iyxzone.URL.editProfile(profileID, {'type': 2}), {
        method: 'get',
        onLoading: function(){
          this.loading(frame, '联系信息');
        }.bind(this),
        onSuccess: function(transport){
          this.editContactInfoHTML = transport.responseText;
          $('contact_info_frame').update( transport.responseText);
        }.bind(this)
      });
    }
  },

  cancelEditContactInfo: function(){
    $('contact_info_frame').update(this.contactInfoHTML);
    this.isEditingContactInfo = false;
  },

  isQQValid: function(){
    var qq = $('profile_qq').value;

    this.clearError('qq_error');

    if(qq != ''){
      if(/\d+/.exec(qq)){
        if(qq.length < 4 || qq.length > 15){
          this.showError('qq_error', 'qq号码长度不对');
          return false;
        }
      }else{
        this.showError('qq_error', 'qq号码只能由数字组成');
        return false;
      }
    }

    return true;
  },
 
  isPhoneValid: function(){
    var phone = $('profile_phone').value;

    this.clearError('phone_error');

    if(phone != ''){
      if(/\d+(-\d+)*/.exec(phone)){
        if(phone.length < 7 || phone.length > 15){
          this.showError('phone_error', '联系电话长度不对');
          return false;
        }
      }else{
        this.showError('phone_error', '联系电话只能由数字或-组成');
        return false;
      }
    }

    return true;
  },

  isUrlValid: function(){
    var url = $('profile_website').value;

    this.clearError('url_error');

    if(url != ''){
			if(!/^((https?:\/\/)?)([a-zA-Z0-9_-])+(\.([a-zA-Z0-9_-]+))+(:([\d])+)*([\/a-zA-Z0-9\.\?=&_-])*$/.exec(url)){
        this.showError('url_error', '非法的url地址');
        return false;
      }
    }

    return true;
  },
 
  validateContactInfo: function(){
    var v1 = this.isQQValid();
    var v2 = this.isPhoneValid();
    var v3 = this.isUrlValid();
    return v1 && v2 && v3;
  },
  
  updateContactInfo: function(profileID, button, form){
    if(this.validateContactInfo()){
      new Ajax.Request(Iyxzone.URL.updateProfile(profileID, {'type': 2}), {
        method: 'put',
        parameters: $(form).serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '请等待..');
          Iyxzone.changeCursor('wait');
        }.bind(this),
        onComplete: function(){
          Iyxzone.changeCursor('default');
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            this.editContactInfoHTML = null;
            $('contact_info_frame').update(json.html);
            this.isEditingContactInfo = false;
          }else{
            error("发生错误");
            Iyxzone.enableButton('保存');
          }
        }.bind(this)
      });
    }
  },
  
  charactersHTML: null,

  editCharactersHTML: null,

  newCharacterID: 1,

  isEditingCharacters: false,

  gameSelectors: new Hash(), // deprecated

  existingCharactersCount: 0, 

  newGameSelectors: new Hash(),

  delCharacterIDs: new Array(),

  // deprecated
  addGameSelector: function(characterID, gameDetails){
    var prefix = 'profile_existing_characters_' + characterID + '_';
    var dprefix = 'existing_characters_' + characterID + '_';

    var selector = new Iyxzone.Game.PinyinSelector(
      prefix + 'game_id',
      dprefix + 'game_id_error',
      prefix + 'area_id',
      dprefix + 'area_id_error',
      prefix + 'server_id',
      dprefix + 'server_id_error',
      prefix + 'race_id',
      dprefix + 'race_id_error',
      prefix + 'profession_id',
      dprefix + 'profession_id_error',
      gameDetails,
      {}
    );
   
    this.gameSelectors.set("existing_" + characterID, selector);
  },

  editCharacters: function(profileID){
    if(this.isEditingCharacters)
      return
    else
      this.isEditingCharacters = true

    var frame = $('character_frame');
    this.charactersHTML = frame.innerHTML;
    if(this.editCharactersHTML){
      frame.update(this.editCharactersHTML);
    }else{
      new Ajax.Request(Iyxzone.URL.editProfile(profileID, {'type': 3}), {
        method: 'get',
        onLoading: function(){
          this.loading(frame, '游戏角色信息');
        }.bind(this),
        onSuccess: function(transport){
          this.editCharactersHTML = transport.responseText;
          $('character_frame').update(this.editCharactersHTML);
          this.existingCharactersCount = $('user_characters').childElements().length;
        }.bind(this)
      });
    }
  },

  cancelEditCharacters: function(){
    $('character_frame').update( this.charactersHTML);
    this.isEditingCharacters = false;
    this.delCharacterIDs = new Array();
    this.newGameSelectors = new Hash();
  },

  newCharacter: function(){
    var id = this.newCharacterID;
    var div = new Element('div', {id: 'new_characters_' + id});
  
    var html = '<div class="rows s_clear"><div class="fldid"><label>名字：</label></div><div class="fldvalue"><div class="textfield"><input type="text" size="30" onblur="Iyxzone.Profile.Editor.isCharacterNameValid(' + id + ', 1)" name="profile[new_characters][' + id + '][name]" id="profile_new_characters_' + id + '_name"/></div></div><span id="new_characters_' + id + '_name_error" class="red"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label>等级：</label></div><div class="fldvalue"><div class="textfield"><input type="text" size="30" onblur="Iyxzone.Profile.Editor.isCharacterLevelValid(' + id + ', 1)" name="profile[new_characters][' + id + '][level]" id="profile_new_characters_' + id + '_level"/></div></div><span id="new_characters_' + id + '_level_error" class="red"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label>游戏：</label></div><div class="fldvalue"><div><select name="profile[new_characters][' + id + '][game_id]" id="profile_new_characters_' + id + '_game_id"><option value="">---</option></select></div></div><span id="new_characters_' + id + '_game_id_error" class="red"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label>服务区：</label></div><div class="fldvalue"><div><select name="profile[new_characters]['+ id + '][area_id]" id="profile_new_characters_' + id + '_area_id"><option value="">---</option></select></div></div><span id="new_characters_' + id + '_area_id_error" class="red"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label>服务器：</label></div><div class="fldvalue"><div><select name="profile[new_characters][' + id + '][server_id]" id="profile_new_characters_' + id + '_server_id"><option value="">---</option></select></div></div><span id="new_characters_' + id + '_server_id_error" class="red"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label>种族：</label></div><div class="fldvalue"><div><select name="profile[new_characters][' + id + '][race_id]" id="profile_new_characters_' + id + '_race_id"><option value="">---</option></select></div></div><span id="new_characters_' + id + '_race_id_error" class="red"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label>职业：</label></div><div class="fldvalue"><div><select name="profile[new_characters][' + id + '][profession_id]" id="profile_new_characters_' + id + '_profession_id"><option value="">---</option></select></div></div><span id="new_characters_' + id + '_profession_id_error" class="red"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label>正在玩：</label></div><div class="fldvalue"><input name="profile[new_characters][' + id + '][playing]" value="0" type="hidden"><input checked="checked" id="profile_new_characters_' + id + '_playing" name="profile[new_characters][' + id + '][playing]" value="1" type="checkbox"></div></div>'; 
    html += '<p class="foot s_clear"><a onclick="Iyxzone.Profile.Editor.removeCharacter(' + id + ', 1, this);; return false;" href="javascript: void(0)" class="right red">删除角色</a></p>';

    div.update( html);
    $('user_characters').appendChild(div);
    this.newCharacterID++;
    
    // set game selector
    var prefix = 'profile_new_characters_' + id + '_';
    var dprefix = 'new_characters_' + id + '_';
    var selector = Iyxzone.Game.initPanelSelector(
      prefix + 'game_id',
      dprefix + 'game_id_error',
      prefix + 'area_id',
      dprefix + 'area_id_error',
      prefix + 'server_id',
      dprefix + 'server_id_error',
      prefix + 'race_id',
      dprefix + 'race_id_error',
      prefix + 'profession_id',
      dprefix + 'profession_id_error',
      null,
      {});
    this.newGameSelectors.set("new_" + id, selector);
  },

  isCharacterNameValid: function(characterID, newCharacter){
    if(newCharacter)
      prefix = 'new';
    else
      prefix = 'existing';

    var name = $('profile_' + prefix + '_characters_' + characterID + '_name').value;
    var div = prefix + '_characters_' + characterID + '_name_error';
    
    this.clearError(div);

    if(name.length == ''){
      this.showError(div, '游戏角色的名称不能为空');
      return false;
    }

    return true;
  },

  isCharacterLevelValid: function(characterID, newCharacter){
    if(newCharacter)
      prefix = 'new';
    else
      prefix = 'existing';
    
    var level = $('profile_' + prefix + '_characters_' + characterID + '_level').value;
    var div = prefix + '_characters_' + characterID + '_level_error';
    
    this.clearError(div);

    if(level == ''){
      this.showError(div, '等级不能为空');
      return false;
    }

    if(!parseInt(level)){
      this.showError(div, '等级必须是数字');
      return false;
    }

    return true;
  },

  isGameValid: function(characterID, newCharacter){
    var valid = true;

    if(newCharacter)
      prefix = 'new';
    else
      prefix = 'existing';
   
    var gameID = $('profile_' + prefix + '_characters_' + characterID + '_game_id').value;
    var gameDiv = prefix + '_characters_' + characterID + '_game_id_error';
    var areaID = $('profile_' + prefix + '_characters_' + characterID + '_area_id').value;
    var areaDiv = prefix + '_characters_' + characterID + '_area_id_error';
    var serverID = $('profile_' + prefix + '_characters_' + characterID + '_server_id').value;
    var serverDiv = prefix + '_characters_' + characterID + '_server_id_error';
    var raceID = $('profile_' + prefix + '_characters_' + characterID + '_race_id').value;
    var raceDiv = prefix + '_characters_' + characterID + '_race_id_error';
    var professionID = $('profile_' + prefix + '_characters_' + characterID + '_profession_id').value;
    var professionDiv = prefix + '_characters_' + characterID + '_profession_id_error';
    var game = null;
    if(newCharacter)
      game = this.newGameSelectors.get(prefix + '_' + characterID).getDetails();
    else
      game = this.gameSelectors.get(prefix + '_' + characterID).getDetails();
    this.clearError(gameDiv);
    this.clearError(areaDiv);
    this.clearError(serverDiv);
    this.clearError(raceDiv);
    this.clearError(professionDiv);

    if(gameID == ''){
      this.showError(gameDiv, "请选择游戏");
      valid = false;
    }

    if(game && game.areas_count != 0 && areaID == ''){
      this.showError(areaDiv, "请选择服务区");
      valid = false;
    }

    if(game && game.servers_count != 0 && serverID == ''){
      this.showError(serverDiv, "请选择服务器");
      valid = false;
    }

    if(game && game.races_count != 0 && raceID == ''){
      this.showError(raceDiv, "请选择种族");
      valid = false;
    }
    
    if(game && game.professions_count != 0 && professionID == ''){
      this.showError(professionDiv, "请选择职业");
      valid = false;
    }

    return valid; 
  },
 
  validateCharactersInfo: function(form){
    var valid = true;
    var inputs = $(form).getInputs();
    var characterIDs = new Array();

    this.gameSelectors.keys().each(function(key){
      var id = parseInt(key.match(/\d+/)[0]);
      if(!this.delCharacterIDs.include(id))
        characterIDs.push(key);
    }.bind(this));

    this.newGameSelectors.keys().each(function(key){
      characterIDs.push(key);
    }.bind(this));

    characterIDs.each(function(key){
      var id = key.match(/\d+/)[0];
      var newCharacter = null;
      if(key.match(/new/))
        newCharacter = true;
      else
        newCharacter = false;
      valid &= this.isCharacterNameValid(id, newCharacter);
      valid &= this.isCharacterLevelValid(id, newCharacter);
      valid &= this.isGameValid(id, newCharacter);
    }.bind(this));

    return valid;
  },
  
  updateCharacters: function(profileID, form, button){
    if(this.validateCharactersInfo(form)){
      // construct del character ids
      var delCharacterParams = '';
      for(var i = 0; i < this.delCharacterIDs.length; i++){
        delCharacterParams += "profile[del_characters][]=" + this.delCharacterIDs[i] + "&";
      }

      new Ajax.Request(Iyxzone.URL.updateProfile(profileID, {'type': 3}), {
        method: 'put',
        parameters: delCharacterParams + $(form).serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '请等待..');
          Iyxzone.changeCursor('wait');
        },
        onComplete: function(){
          Iyxzone.changeCursor('default');
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            $('character_frame').update(json.html);
            this.editCharactersHTML = null;
            this.gameSelectors = new Hash();
            this.newGameSelectors = new Hash();
            this.delCharacterIDs = new Array();
            this.isEditingCharacters = false;
          }else{
            error("发生错误");
            Iyxzone.enableButton(button, '保存');
          }
        }.bind(this)
      }); 
    }
  },
  
  removeCharacter: function(characterID, newCharacter, link){
    //var currentCharactersCount = this.newGameSelectors.keys().length + this.gameSelectors.keys().length - this.delCharacterIDs.length;
    var currentCharactersCount = this.newGameSelectors.keys().length + this.existingCharactersCount - this.delCharacterIDs.length;
    if(currentCharactersCount == 1){
      error('至少要有1个游戏角色');
      return;
    }

    if(newCharacter)
      prefix = 'new';
    else
      prefix = 'existing';

    if(newCharacter){
      this.newGameSelectors.unset(prefix + '_' + characterID);
    }else{
      this.delCharacterIDs.push(characterID); 
    }

    $(prefix + '_characters_' + characterID).remove();
  },

  edit: function(profileID){
    this.editBasicInfo(profileID);
    this.editContactInfo(profileID);
    this.editCharacters(profileID);    
  }

});

Object.extend(Iyxzone.Profile.Feeder, {
  
  idx: 0,

  moreFeeds: function(profileID){
    // loading
    $('more_feed').innerHTML = '<img src="/images/loading.gif" />';

    new Ajax.Request('/profiles/' + profileID + '/more_feeds?idx=' + this.idx, {
      method: 'get',
      onSuccess: function(transport){
        this.idx++;
      }.bind(this)
    });  
  }

});

Object.extend(Iyxzone.Profile.Tag, {

  init: function(token){
    this.token = token;
  },

  showTagCloud: function(){
    $('tag_cloud').show();
    $('tag_input').hide();
  },

	showTagInput: function(){
	  $('tag_cloud').hide();
    $('tag_input').show();
  },

  isAdding: false,

  addTag: function(profileID, name){
    if(this.isAdding){
      return;
    }else{
      this.isAdding = true;
    }

    new Ajax.Request(Iyxzone.URL.createTag('Profile', profileID), {
      method: 'post',
      parameters: {'tag_name': name, 'authenticity_token': this.token},
      onLoading: function(){
        Iyxzone.disableButton($('tag_submit'), '发送');
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          this.isAdding = false;
          this.showTagCloud();
          $('add_tag_link').remove();
        }else if(json.code == 0){
          error("发生错误，请稍后再试"); 
          Iyxzone.enableButton($('tag_submit'), '评价');
        }
      }.bind(this)
    }); 
  },

  submitForm: function(profileID, field){
    this.addTag(profileID, $(field).value);
  },

  confirmDeletingTag: function(profileID, tagID, link){
    Iyxzone.Facebox.confirmWithCallback("您真的要删除这个印象", null, null, function(){
      this.deleteTag(profileID, tagID, link);
    }.bind(this));
  },

  deleteTag: function(profileID, tagID, link){
    new Ajax.Request(Iyxzone.URL.deleteTag(tagID, 'Profile', profileID), {
      method: 'delete',
      parameters: 'authenticity_token=' + encodeURIComponent(this.token),
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        $(link).writeAttribute('onclick', '');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      }.bind(this),
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('tag_' + tagID).remove();
          Iyxzone.Facebox.close();
        }else{
          error('发生错误');
          $(link).writeAttribute('onclick', 'Iyxzone.Profile.Tag.confirmDeletingTag(' + profileID + ', ' + tagID + ', this);');
        }
      }.bind(this)
    });  
  }

}); 
