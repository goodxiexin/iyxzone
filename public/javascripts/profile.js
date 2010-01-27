Iyxzone.Profile = {
  version: '1.0',
  author: ['高侠鸿'],
  Editor: {},
  Feeder: {}
};

Object.extend(Iyxzone.Profile.Editor, {

  loadingImage: new Image(),

  loading: function(div, title){
    div.innerHTML = '<div class="edit-toggle space edit"><h3 class="s_clear"><strong class="left">' + title + '</strong><a href="#" class="right">取消</a></h3><div class="formcontent con con2"><img src="/images/loading.gif"/></div></div>';
  },

  regionSelector: new Iyxzone.ChineseRegion.Selector('profile_region_id', 'profile_city_id', 'profile_district_id'), 

  gameSelector: null,

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
      frame.innerHTML = this.editBasicInfoHTML;
    }else{
      new Ajax.Request('/profiles/' + profileID + '/edit?type=1', {
        method: 'get',
        onLoading: function(){
          this.loading(frame, '基本信息');
        }.bind(this),
        onSuccess: function(transport){
          this.editBasicInfoHTML = transport.responseText;
          frame.innerHTML = this.editBasicInfoHTML;
          this.regionSelector.setEvents();
        }.bind(this)
      });
    }
  },

  cancelEditBasicInfo: function(){
    var frame = $('basic_info_frame');
    frame.innerHTML = this.basicInfoHTML;
    this.isEditingBasicInfo = false;
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

  updateBasicInfo: function(profileID, button, event){
    Event.stop(event);
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
          this.editBasicInfoHTML = null;
          //this.basicInfoHead
          var frame = $('basic_info_frame');
          frame.innerHTML = transport.responseText;
          this.isEditingBasicInfo = false;
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
      frame.innerHTML = this.editContactInfoHTML;
    }else{
      new Ajax.Request('/profiles/' + profileID + '/edit?type=2', {
        method: 'get',
        onLoading: function(){
          this.loading(frame, '联系信息');
        }.bind(this),
        onSuccess: function(transport){
          this.editContactInfoHTML = transport.responseText;
          frame.innerHTML = this.editContactInfoHTML;
          facebox.watchClickEvents();
        }.bind(this)
      });
    }
  },

  cancelEditContactInfo: function(){
    var frame = $('contact_info_frame');
    frame.innerHTML = this.contactInfoHTML;
    this.isEditingContactInfo = false;
  },

  validateContactInfo: function(){
    var qq = $('profile_qq').value;

    if(qq != ''){
      if(qq.match(/\d+/)){
        if(qq.length < 4 || qq.length > 15){
          error('qq号码长度不对');
          return false;
        }
      }else{
        error('qq号码只能由数字组成');
        return false;
      }
    }
  
    var phone = $('profile_phone').value;

    if(phone != ''){
      if(phone.match(/\d+/)){
        if(phone.length < 8 || phone.length > 15){
          error('联系电话长度不对');
          return false;
        }
      }else{
        error('联系电话只能由数字组成');
        return false;
      }
    }

    var url = $('profile_website').value;

    if(url != ''){
      if(!url.match(/^((https?:\/\/)?)(([a-zA-Z0-9_-])+(\.)?)*(:\d+)?(\/((\.)?(\?)?=?&?[a-zA-Z0-9_-](\?)?)*)*$/)){
        error('非法的url地址');
        return false;
      }
    }

    return true;
  },

  updateContactInfo: function(profileID, button, event){
    Event.stop(event);
    if(this.validateContactInfo()){
      new Ajax.Request('/profiles/' + profileID + '?type=2', {
        method: 'put',
        parameters: $('contact_info_form').serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '等待...');
        }.bind(this),
        onComplete: function(){
          Iyxzone.enableButton(button, '保存');
        }.bind(this),
        onSuccess: function(transport){
          this.editContactInfoHTML = null;
          var frame = $('contact_info_frame');
          frame.innerHTML = transport.responseText;
          this.isEditingContactInfo = false;
        }.bind(this)
      });
    }
  },

  charactersHTML: null,

  editCharactersHTML: null,

  charactersCount: 0,

  isEditingCharacters: false,

  editCharacters: function(profileID){
    if(this.isEditingCharacters)
      return
    else
      this.isEditingCharacters = true;

    var frame = $('character_frame');
    this.charactersHTML = frame.innerHTML;
    if(this.editCharactersHTML){
      frame.innerHTML = this.editCharactersHTML;
    }else{
      new Ajax.Updater('character_frame', '/profiles/' + profileID + '/edit?type=3', {
        method: 'get',
        evalScripts: true,
        onLoading: function(){
          this.loading(frame, '游戏角色信息');
        }.bind(this),
        onComplete: function(transport){
          this.editCharactersHTML = transport.responseText;
        }.bind(this)
      });
    }
  },

  cancelEditCharacters: function(){
    var frame = $('character_frame');
    frame.innerHTML = this.charactersHTML;
    this.isEditingCharacters = false;
  },

  newCharacter: function(){
    new Ajax.Updater('user_characters', '/characters/new?id=' + this.charactersCount, {
      insertion: 'bottom',
      method: 'get',
      evalScripts: true,
      onSuccess: function(){
        this.charactersCount++;
      }.bind(this)
    });
  },
  
  validateCharacterInfo: function(){
/*    var name = $('character_name').value;
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
      if(!gameDetails.no_professions && $('character_profession_id').value ==, {duration: 2.0});'){
        error('没有选择职业');
        return false;
      }
    }
*/
    return true;
  },

  updateCharacters: function(profileID, button, event){
    Event.stop(event);
    if(this.validateCharacterInfo()){
      var frame = $('character_frame');
      new Ajax.Request('/profiles/' + profileID + '?type=3', {
        method: 'put',
        parameters: $('characters_form').serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '等待...');
        },
        onComplete: function(){
          Iyxzone.enableButton(button, '保存');
        },
        onSuccess: function(transport){
          frame.innerHTML = transport.responseText;
          this.editCharactersHTML = null;
          this.isEditingCharacters = false;
        }.bind(this)
      });
    }
  },

  removeCharacter: function(characterID, token){
    new Ajax.Request('/characters/' + characterID, {
      method: 'delete',
      parameters: 'authenticity_token=' + encodeURIComponent(token),
      onSuccess: function(transport){
        this.charactersHTML = transport.responseText;
        $('character_' + characterID).remove();
      }.bind(this)
    });
  },

  removeNewCharacter: function(div){
    div.up().up().remove();
  },

  edit: function(profileID){
    this.editBasicInfo(profileID);
    this.editContactInfo(profileID);
    this.editCharacters(profileID);    
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
