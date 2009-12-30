Iyxzone.Search = {
  
  version: '1.0',
  
  author: ['高侠鸿'],
  
  showUserForm: function(){
    $('user_form').getInputs('text')[0].value = '好友名字';
    $('user_form').show();
    $('character_form').hide();
  },

  validateUserForm: function(){
    var value = $('user_form').getInputs('text')[0].value;
    if(value  == '好友名字' || value == ''){
      error('请输入好友名字');
      return false;
    }
    return true;
  },

  searchUsers: function(button){
    if(this.validateUserForm()){
      Iyxzone.disableButton(button, '等待...');
      $('user_form').submit();
    }
  },

  gameSelector: null, // initialize this in your page

  showCharacterForm: function(){
    $('character_form').getInputs('text')[0].value = '角色名字';
    $('character_form').show();
    $('user_form').hide();
  },

  toggleCharacterOptions: function(){
    var characterOptions = $('character_options');
    if(characterOptions.visible()){
      Effect.BlindUp(characterOptions);
    }else{
      Effect.BlindDown(characterOptions);
    }
  },

  validateCharacterForm: function(){
    var value = $('character_form').getInputs('text')[0].value;
    if(value  == '角色名字' || value == ''){
      error('请输入角色名字');
      return false;
    }
    return true;
  },

  searchCharacters: function(button){
    if(this.validateCharacterForm()){
      Iyxzone.disableButton(button, '等待...');
      $('character_form').submit();
    }
  },

};

