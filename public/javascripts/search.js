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
    $('character_form').show();
    $('user_form').hide();
  },

	toggleCharacterForm: function(){
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
  },

  toggleMsnEmailForm: function(){
    $('msn_email_form').toggle();
  },

  toggleMsnInput: function(){
    $('msn_input_form').show();
    $('email_input_form').hide();
    var group = document.forms['msn_input_form'].elements['contact'];
    group[0].checked = true;
    group[1].checked = false;
  },

  toggleEmailInput: function(){
    $('msn_input_form').hide();
    $('email_input_form').show();
    var group = document.forms['email_input_form'].elements['contact'];
    group[0].checked = false;
    group[1].checked = true;
  },

  checkMsnInput: function(){
    Iyxzone.disableButton($('msn_submit_btn'), '请等待..');
    var form = $('msn_input_form');
    var id = form.getInputs('text')[0];
    var pwd = form.getInputs('password')[0];
    if(id.value == ''){
      error('请输入msn用户名');
      Iyxzone.enableButton($('msn_submit_btn'), '导入');
      return false;
    }
    if(pwd.value == ''){
      error('请输入msn密码');
      Iyxzone.enableButton($('msn_submit_btn'), '导入');
      return false;
    }
    return true;
  },

  checkEmailInput: function(){
    Iyxzone.disableButton($('email_submit_btn'),'请等待..');
    var form = $('email_input_form');
    var email = form.getInputs('text')[0];
    var pwd = form.getInputs('password')[0];
    if(email.value == ''){
      error('请输入邮箱');
      Iyxzone.enableButton($('email_submit_btn'),'导入');
      return false;
    }else if(!/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/.exec(email.value)){
      error('非法的邮箱地址');
      Iyxzone.enableButton($('email_submit_btn'),'导入');
      return false;
    }
    if(pwd.value == ''){
      error('请输入邮箱密码');
      Iyxzone.enableButton($('email_submit_btn'), '导入');
      return false;
    }
    return true;
  }

};

