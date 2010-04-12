Iyxzone.Search = {
  
  version: '1.0',
  
  author: ['高侠鸿'],
  
  showUserForm: function(){
    $('user_form').getInputs('text')[0].value = '用户昵称';
    $('user_form').show();
    $('character_form').hide();
  },

	toggleUserForm: function(){
    $('user_form').getInputs('text')[0].value = '好友名字';
    $('user_form').toggle();
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
      Iyxzone.disableButton(button, '请等待..');
      window.location.href = $('user_form').action + '?' + $('user_form').serialize();
    }
  },

  showCharacterForm: function(){
    $('character_form').getInputs('text')[0].value = '游戏角色名字';
    $('character_form').show();
    $('user_form').hide();
  },

	toggleCharacterForm: function(){
    $('character_form').getInputs('text')[0].value = '游戏角色名字';
    $('character_form').toggle();
		//$('character_options').toggle();
	},

  toggleCharacterOptions: function(){
    var characterOptions = $('character_options');
    if(characterOptions.visible()){
      Effect.BlindUp(characterOptions);
    }else{
      Effect.BlindDown(characterOptions);
    }
  },

	toggleMSNForm: function(){
    $('msnform').toggle();
	},

  validateCharacterForm: function(){
    var value = $('character_form').getInputs('text')[0].value;
    if((value  == '角色名字' || value == '') && $('game_id').value == '' && $('area_id').value == '' && $('server_id').value == ''){
      error('请输入你要查找的玩家的信息');
      return false;
    }
    if(value  == '角色名字' || value == '')
      $('character_form').getInputs('text')[0].clear();
    return true;
  },

  searchCharacters: function(button){
    if(this.validateCharacterForm()){
      Iyxzone.disableButton(button, '请等待..');
      window.location.href = $('character_form').action + '?' + $('character_form').serialize();
    }
  }

};

