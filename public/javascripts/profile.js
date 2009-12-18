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
    return true;
  },

  updateContactInfo: function(profileID){
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
