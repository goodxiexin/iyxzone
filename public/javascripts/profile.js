Iyxzone.Profile = {
  version: '1.0',
  author: ['高侠鸿'],
  Editor: {},
  Feeder: {},
	Tag: {}
};

Object.extend(Iyxzone.Profile.Editor, {

  loading: function(div, title){
    div.innerHTML = '<div class="edit-toggle space edit"><h3 class="s_clear"><strong class="left">' + title + '</strong><a href="#" class="right">取消</a></h3><div class="formcontent con con2"><img src="/images/loading.gif"/></div></div>';
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
      new Ajax.Updater('basic_info_frame', '/profiles/' + profileID + '/edit?type=1', {
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
   // Event.stop(event);
    $('basic_info_frame').update( this.basicInfoHTML);
    this.isEditingBasicInfo = false;
  },

  isLoginValid: function(){
    var login = $('profile_login');
  
    this.clearError('login_error');

    if(login.value == ''){
      this.showError('login_error', '昵称不能为空');
      return false;
    }

    if(login.value.length < 2){
      this.showError('login_error', '至少要2个字');
      return false;
    }

    if(login.value.length > 30){
      this.showError('login_error', '最多30个字');
      return false;
    }

    first = login.value[0];
    if((first >= '0' && first <= '9')){
      this.showError('login_error', '昵称不能以数字开头');
      return false;
    }

    if(!login.match(/[a-zA-Z0-9_\u4e00-\u9fa5]+/)){
      this.error('login_info', '只能包含字母，数字，汉字以及下划线');
      return false;
    }

    return true;
  },

  validateBasicInfo: function(){
    return this.isLoginValid();
  },

  updateBasicInfo: function(profileID, button, form){
    if(this.validateBasicInfo()){
      new Ajax.Request('/profiles/' + profileID + '?type=1', {
        method: 'put',
        parameters: $(form).serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '请等待..');
        },
        onSuccess: function(transport){
          $('basic_info_frame').update( transport.responseText);
          this.isEditingBasicInfo = false;
          this.editBasicInfoHTML = null;
          this.regionSelector = null;
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
      new Ajax.Request('/profiles/' + profileID + '/edit?type=2', {
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
//    $('contact_info_frame').innerHTML = this.contactInfoHTML;
    $('contact_info_frame').update( this.contactInfoHTML);
    this.isEditingContactInfo = false;
  },

  isQQValid: function(){
    var qq = $('profile_qq').value;

    this.clearError('qq_error');

    if(qq != ''){
      if(qq.match(/\d+/)){
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
      if(phone.match(/\d+(-\d+)*/)){
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
			if(!url.match(/^((https?:\/\/)?)([a-zA-Z0-9_-])+(\.([a-zA-Z0-9_-]+))+(:([\d])+)*([\/a-zA-Z0-9\.\?=&_-])*$/)){
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
      new Ajax.Request('/profiles/' + profileID + '?type=2', {
        method: 'put',
        parameters: $(form).serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '请等待..');
        }.bind(this),
        onSuccess: function(transport){
          this.editContactInfoHTML = null;
          $('contact_info_frame').update( transport.responseText);
          this.isEditingContactInfo = false;
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
      /*this.gameSelectors.values().each(function(selector){
        selector.setEvents();
      });*/
    }else{
      new Ajax.Request('/profiles/' + profileID + '/edit?type=3', {
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

      new Ajax.Request('/profiles/' + profileID + '?type=3', {
        method: 'put',
        parameters: delCharacterParams + $(form).serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '请等待..');
        },
        onSuccess: function(transport){
          $('character_frame').update( transport.responseText);
          this.editCharactersHTML = null;
          this.gameSelectors = new Hash();
          this.newGameSelectors = new Hash();
          this.delCharacterIDs = new Array();
          this.isEditingCharacters = false;
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

  loading: function(div){
    div.innerHTML = "<div style='textAligin: center'><img src='/images/loading.gif'/></div>";
  },

	deleteTag: function(profileID, tagID, token){
    new Ajax.Request('/profiles/' + profileID + '/tags/' + tagID, {
      method: 'delete',
			parameters: 'authenticity_token=' + encodeURIComponent(token),
			onLoading: function(){
				this.loading($('tag_'+tagID));
			}.bind(this)
    });  
	}
}); 
