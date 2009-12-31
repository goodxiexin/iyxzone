Iyxzone.Profile = {
  version: '1.0',
  author: ['高侠鸿'],
  Editor: {},
  Feeder: {}
};

Object.extend(Iyxzone.Profile.Editor, {

  loadingImage: new Image(),

  loading: function(div){
    div.innerHTML = "<img src='/images/loading.gif'/>";
  },

  regionSelector: new Iyxzone.ChineseRegion.Selector('profile_region_id', 'profile_city_id', 'profile_district_id'), 

  gameSelector: null,

  oldBasicInfo: null,

  basicInfoForm: null,

  editBasicInfo: function(profileID){
    // change css class of this.basicInfoHead
    var basicInfo = $('basic_info');
    var basicInfoHead = basicInfo.childElements()[0];
    var basicInfoBody = basicInfo.childElements()[1];
    this.oldBasicInfo = basicInfoBody.innerHTML;
    if(this.basicInfoForm){
      basicInfoBody.innerHTML = this.basicInfoForm;
    }else{
      this.loading(basicInfoBody);
      new Ajax.Request('/profiles/' + profileID + '/edit?type=1', {
        method: 'get',
        onSuccess: function(transport){
          this.basicInfoForm = transport.responseText;
          basicInfoBody.innerHTML = this.basicInfoForm;
          this.regionSelector.setEvents();
        }.bind(this)
      });
    }
  },

  cancelEditBasicInfo: function(){
    var basicInfoBody = $('basic_info').childElements()[1];
    basicInfoBody.innerHTML = this.oldBasicInfo;
  },

  validateBasicInfo: function(){
    var login = $('profile_login');

    if(login.value == ''){
      error('昵称不能为空');
      return false;
    }

    if(login.value.length < 6){
      error('昵称至少要4个字符');
      return false;
    }
    if(login.value.length > 16){
      error('昵称最多16个字符');
      return false;
    }

    first = login.value[0];
    if((first >= 'a' && first <= 'z') || (first >= 'A' && first <= 'Z')){
      if(!login.value.match(/[A-Za-z0-9\_]+/)){
        error('昵称只允许字母和数字');
        return false;
      }
    }else{
      error('昵称必须以字母开头');
      return false;
    }

    return true;
  },

  updateBasicInfo: function(profileID, button){
    if(this.validateBasicInfo()){
      new Ajax.Request('/profiles/' + profileID + '?type=1', {
        method: 'put',
        parameters: $('basic_info_form').serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '等待...');
        },
        onComplete: function(){
          Iyxzone.enableButton(button, '保存');
        },
        onSuccess: function(transport){
          this.basicInfoForm = null;
          //this.basicInfoHead
          var basicInfoBody = $('basic_info').childElements()[1];
          basicInfoBody.innerHTML = transport.responseText;
        }.bind(this)
      });
    }
  },

  oldContactInfo: null,

  contactInfoForm: null,

  editContactInfo: function(profileID){
    var contactInfoBody = $('contact_info').childElements()[1];
    var contactInfoHead = $('contact_info').childElements()[0];
    this.oldContactInfo = contactInfoBody.innerHTML;
    if(this.contactInfoForm){
      contactInfoBody.innerHTML = this.contactInfoForm;
    }else{
      this.loading(contactInfoBody);
      new Ajax.Request('/profiles/' + profileID + '/edit?type=2', {
        method: 'get',
        onSuccess: function(transport){
          this.contactInfoForm = transport.responseText;
          contactInfoBody.innerHTML = this.contactInfoForm;
        }.bind(this)
      });
    }
  },

  cancelEditContactInfo: function(){
    var contactInfoBody = $('contact_info').childElements()[1];
    contactInfoBody.innerHTML = this.oldContactInfo;
  },

  validateContactInfo: function(){
    var qq = $('profile_qq').value;

    if(qq.match(/\d+/)){
      if(qq.length < 6 || qq.length > 20){
        error('qq号码长度不对');
        return false;
      }
    }else{
      error('qq号码只能由数字组成');
      return false;
    }
  
    var phone = $('profile_phone').value;

    if(phone.match(/\d+/)){
      if(qq.length < 8 || qq.length > 20){
        error('联系电话长度不对');
        return false;
      }
    }else{
      error('联系电话只能由数字组成');
      return false;
    }

    var url = $('profile_website').value;

    if(!url.match(/^((https?:\/\/)?)(([a-zA-Z0-9_-])+(\.)?)*(:\d+)?(\/((\.)?(\?)?=?&?[a-zA-Z0-9_-](\?)?)*)*$/)){
      error('非法的url地址');
      return false;
    }

    return true;
  },

  updateContactInfo: function(profileID, button){
    if(this.validateContactInfo()){
      new Ajax.Request('/profiles/' + profileID + '?type=2', {
        method: 'put',
        parameters: $('contact_info_form').serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '等待...');
        },
        onComplete: function(){
          Iyxzone.enableButton(button, '保存');
        },
        onSuccess: function(transport){
          this.contactInfoForm = null;
          //this.contactInfoHead
          var contactInfoBody = $('contact_info').childElements()[1];
          contactInfoBody.innerHTML = transport.responseText;
        }.bind(this)
      });
    }
  },

  oldCharacterInfo: null,

  newCharacterForm: null,

  characterToFormMappings: new Hash(), 

  newCharacterInfo: function(){
    var characterInfoBody = $('character_info').childElements()[1];
    var characterInfoHead = $('character_info').childElements()[0];
    this.oldCharacterInfo = characterInfoBody.innerHTML;
    if(this.newCharacterForm){
      characterInfoBody.innerHTML = this.newCharacterForm;
    }else{
      this.loading(characterInfoBody);
      new Ajax.Updater(characterInfoBody, '/characters/new', {
        method: 'get',
        evalScripts: true, // guarantee that javascript is executed
        onComplete: function(transport){
          this.gameSelector.setEvents();
          this.newCharacterForm = transport.responseText;
        }.bind(this)
      });
    }
  },

  cancelNewCharacterInfo: function(){
    var characterInfoBody = $('character_info').childElements()[1];
    characterInfoBody.innerHTML = this.oldCharacterInfo;
    this.details = null; //why
  },

  createCharacterInfo: function(button){
    if(this.validateCharacterInfo()){
      var characterInfoBody = $('character_info').childElements()[1];
      new Ajax.Request('/characters/', {
        method: 'post',
        parameters: $('character_info_form').serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '等待...');
        },
        onComplete: function(){
          Iyxzone.enableButton(button, '保存');
        },
        onSuccess: function(transport){
          characterInfoBody.innerHTML = transport.responseText;
          this.details = null;
        }.bind(this)
      });
    }
  },

  editCharacterInfo: function(characterID){
    var characterInfoBody = $('character_info').childElements()[1];
    this.oldCharacterInfo = characterInfoBody.innerHTML;
    var characterForm = this.characterToFormMappings.get(characterID);
    if(characterForm){
      characterInfoBody.innerHTML = characterForm;
      this.gameSelector.setEvents();
    }else{
      this.loading(characterInfoBody);
      new Ajax.Updater(characterInfoBody, '/characters/' + characterID + '/edit', {
      method: 'get',
      evalScripts: true, // guarantee that javascript is executed
      onComplete: function(transport){
        this.gameSelector.setEvents();
        this.characterToFormMappings.set(characterID, transport.responseText);
      }.bind(this)
      });
    }
  },

  cancelEditCharacterInfo: function(){
    var characterInfoBody = $('character_info').childElements()[1];
    characterInfoBody.innerHTML = this.oldCharacterInfo;
    this.details = null;
  },

  validateCharacterInfo: function(){
    var name = $('character_name').value;
    if(name == ''){
      error('人物昵称应该有的吧');
      return false;
    }

    var level = $('character_level').value;
    if(level.value == ''){
      error('等级不能不添啊');
      return false;
    }

    if($('character_game_id').value == ''){
      error('没有选择游戏，如有问题，请看提示');
      return false;
    }

    var gameDetails = this.gameSelector.getDetails();
    if(gameDetails){
      if(gameDetails.no_servers){
        tip('由于游戏数量庞大，很多游戏已经停服，我们没有把所有游戏统计完成。这个游戏的资料就还不完全，请您在左边的意见建议中告诉我们您所在游戏的所在服务器，我们会以最快速度为您添加。对您带来得不便，我们道歉');
        return false;
      }else{
        if($('character_server_id').value == ''){
          error('没有选择服务器');
          return false;
        }
      }
      if(!gameDetails.no_areas && $('character_area_id').value == ''){
        error('没有选择区域，如有问题，请看提示');
        return false;
      }
      if(!gameDetails.no_races && $('character_race_id').value == ''){
        error('没有选择种族');
        return false;
      }
      if(!gameDetails.no_professions && $('character_profession_id').value == ''){
        error('没有选择职业');
        return false;
      }
    }

    return true;
  },

  updateCharacterInfo: function(characterID, button){
    var characterInfoBody = $('character_info').childElements()[1];
    if(this.validateCharacterInfo()){
      new Ajax.Request('/characters/' + characterID , {
        method: 'put',
        parameters: $('character_info_form').serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '等待...');
        },
        onComplete: function(){
          Iyxzone.enableButton(button, '保存');
        },
        onSuccess: function(transport){
          this.characterToFormMappings.unset(characterID);
          characterInfoBody.innerHTML = transport.responseText;
          this.details = null;
        }.bind(this)
      });
    }
  },

  setupRatingInfo: function(rating){
    $('current_rate').innerHTML = "<li class='current-rating' style='width:"+ rating*30 +"px;'> Currently "+ rating +"/5 Stars.</li>";
    $('star_value').innerHTML = "<input id='game_rate' type='hidden' value='"+ rating +"' name='game_rate'/>";
  },

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
