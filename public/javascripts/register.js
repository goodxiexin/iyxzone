Iyxzone.Register = {
  version: '1.0',
  author: ['高侠鸿']
};

Object.extend(Iyxzone.Register, {

  gameSelector: null,

  load: function(div){
    $(div).innerHTML = '<img src="/images/loading.gif" />';
  },

  error: function(div, content){
    var span = new Element('span', {'class': 'icon-warn'});
    $(div).className = 'red';
    $(div).update(content);
    Element.insert($(div), {'top': span}); 
  },

  clearError: function(div){
    $(div).innerHTML = '';
  },

  pass: function(div){
    $(div).innerHTML = '';
    $(div).className = 'fldstatus';
  },

  tip: function(div, content){
    $(div).className = '';
    $(div).update(content);
  },

  showLoginRequirement: function(){
    this.tip('login_info', '只能由数字，字母组成，大小4-16字符');
  },

  validateLogin: function(){
    var login = $('user_login').value;

    if(login == ''){
      this.error('login_info', '不能为空');
      return false;
    }

    if(login.length < 2){
      this.error('login_info', '至少要2个字符');
      return false;
    }
    if(login.length > 100){
      this.error('login_info', '最多100个字符');
      return false;
    }

  },

  showEmailRequirement: function(){
    this.tip('email_info', '输入合法的邮件地址');
  },

  validateEmail: function(){
    var email = $('user_email').value;

    if(email == ''){
      this.error('email_info', '邮件不能为空');
      return false;
    }

    if(email.match(/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/)){
      this.load('email_info');

      new Ajax.Request('/register/validates_email_uniqueness?email='+encodeURIComponent(email), {
        method: 'get',
        onSuccess: function(transport){
          if(transport.responseText == 'yes'){
            this.pass('email_info');
          }else{
            this.error('email_info', '该邮箱已被注册');
          }
        }.bind(this)
      });

      return true;
    }else{
      this.error('email_info', '非法的邮件格式');
      return false;
    }
  },

  showPasswordRequirement: function(){
    this.tip('password_info', '密码6－20个字符');
  },

  validatePassword: function(){
    var password = $('user_password').value;
    var strongReg = new RegExp("^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$", "g");
    var mediumReg = new RegExp("^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");

    // check length
    if(password == ''){
      this.error('password_info', '密码不能为空');
      return false;
    }
    if(password.length < 6){
      this.error('password_info', '至少6个字符');
      return false;
    }
    if(password.length > 20){
      this.error('password_info', '最多20个字符');
      return false;
    }

    // check strength
    if(password.match(strongReg)){
      this.tip('password_info', '密码强度: 强');
      return true;
    }else if(password.match(mediumReg)){
      this.tip('password_info', '密码强度: 中');
      return true;
    }else{
      this.tip('password_info', '密码强度: 弱');
      return true;
    }
  },

  showPasswordConfirmRequirement: function(){
    this.tip('password_confirmation_info', '确认你的密码');
  },

  validatePasswordConfirmation: function(){
    var password = $('user_password').value;
    var passwordConfirmation = $('user_password_confirmation').value;

    if(password == ''){
      this.error('password_info', '密码不能为空');
      return false;
    }

    if(password == passwordConfirmation){
      this.pass('password_confirmation_info');
      return true;
    }else{
      this.error('password_confirmation_info', '两次密码不一致');
      return false;
    }
  },

  gameSelectors: new Hash(), // characterID => gameSelector

  characterID: 1, // start from 1

  isCharacterNameValid: function(id){
    var name = $('profile_new_characters_' + id + '_name').value;
    var div = 'character_' + id + '_name_error';

    this.clearError(div);

    if(name.length == ''){
      this.error(div, '游戏角色的名称不能为空');
      return false;
    }

    return true
  },

  isCharacterLevelValid: function(id){
    var level = $('profile_new_characters_' + id + '_level').value;
    var div = 'character_' + id + '_level_error';

    this.clearError(div);

    if(level == ''){
      this.error(div, '等级不能为空');
      return false;
    }

    if(!parseInt(level)){
      this.error(div, '等级不合法');
      return false;
    }

    return true;
  },

  isGameValid: function(id){
    var valid = true;
    var gameID = $('profile_new_characters_' + id + '_game_id').value;
    var gameDiv = 'character_' + id + '_game_id_error';
    var areaID = $('profile_new_characters_' + id + '_area_id').value;
    var areaDiv = 'character_' + id + '_area_id_error';
    var serverID = $('profile_new_characters_' + id + '_server_id').value;
    var serverDiv = 'character_' + id + '_server_id_error';
    var raceID = $('profile_new_characters_' + id + '_race_id').value;
    var raceDiv = 'character_' + id + '_race_id_error';
    var professionID = $('profile_new_characters_' + id + '_profession_id').value;
    var professionDiv = 'character_' + id + '_profession_id_error';
    var game = this.gameSelectors.get(id).getDetails();
    this.clearError(gameDiv);
    this.clearError(areaDiv);
    this.clearError(serverDiv);
    this.clearError(raceDiv);
    this.clearError(professionDiv);

    if(gameID == ''){
      this.error(gameDiv, "请选择游戏");
      valid = false;
    }

    if(game && !game.no_areas && areaID == ''){
      this.error(areaDiv, "请选择服务区");
      valid = false;
    }

    if(game && !game.no_servers && serverID == ''){
      this.error(serverDiv, "请选择服务器");
      valid = false;
    }

    if(game && !game.no_races && raceID == ''){
      this.error(raceDiv, "请选择种族");
      valid = false;
    }

    if(game && !game.no_professions && professionID == ''){
      this.error(professionDiv, "请选择职业");
      valid = false;
    }

    return valid;
  },

  validateCharacters: function(){
    var valid = true;

    this.gameSelectors.keys().each(function(id){
      valid &= this.isCharacterNameValid(id);
      valid &= this.isCharacterLevelValid(id);
      valid &= this.isGameValid(id);
    }.bind(this));

    return valid;
  },

  newCharacter: function(){
    var id = this.characterID;
    var div = new Element('div', {id: 'character_' + id});

    var html = '<div class="rows s_clear"><div class="fldid"><label>人物昵称：</label></div><div class="fldvalue"><div class="textfield" style="width: 100px;"><input id="profile_new_characters_' + id + '_name" name="profile[new_characters][' + id + '][name]" onblur="Iyxzone.Register.isCharacterNameValid(' + id + ')" size="30" type="text"></div></div><span class="red" id="character_' + id + '_name_error"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label>级别：</label></div><div class="fldvalue"><div style="width: 100px;" class="textfield"><input id="profile_new_characters_' + id + '_level" name="profile[new_characters][' + id + '][level]" onblur="Iyxzone.Register.isCharacterLevelValid(' + id + ')" size="30" type="text"></div></div><span class="red" id="character_' + id + '_level_error"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label for="inbox">游戏：</label></div><div class="fldvalue"><select id="profile_new_characters_' + id + '_game_id" name="profile[new_characters][' + id + '][game_id]"><option value="">---</option></select></div><span class="red" id="character_' + id + '_game_id_error"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label for="inbox">区域：</label></div><div class="fldvalue"><select id="profile_new_characters_' + id + '_area_id" name="profile[new_characters][' + id + '][area_id]"><option value="">---</option></select></div><span class="red" id="character_' + id + '_area_id_error"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label for="inbox">服务器：</label></div><div class="fldvalue"><select id="profile_new_characters_' + id + '_server_id" name="profile[new_characters][' + id + '][server_id]"><option value="">---</option></select></div><span class="red" id="character_' + id + '_server_id_error"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label for="inbox">种族：</label></div><div class="fldvalue"><select id="profile_new_characters_' + id + '_race_id" name="profile[new_characters][' + id + '][race_id]"><option value="">---</option></select></div><span class="red" id="character_' + id + '_race_id_error"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label for="inbox">职业：</label></div><div class="fldvalue"><select id="profile_new_characters_' + id + '_profession_id" name="profile[new_characters][' + id + '][profession_id]"><option value="">---</option></select></div><span class="red" id="character_' + id + '_profession_id_error"></span></div>';
    html += '<div class="rows s_clear"><div class="fldid"><label>正在玩：</label></div><div class="fldvalue"><input name="profile[new_characters][' + id + '][playing]" value="0" type="hidden"><input checked="checked" id="profile_new_characters_' + id + '_playing" name="profile[new_characters][' + id + '][playing]" value="1" type="checkbox"></div></div>';
    html += '<p class="foot s_clear"><a class="right red" href="javascript:void(0)" onclick="Iyxzone.Register.removeCharacter(' + id + '); return false;">删除本游戏角色</a></p>';

    div.update(html);
    $('characters').appendChild(div);
    
    this.characterID++;
    
    // set game info
    var prefix = 'profile_new_characters_' + id + '_';
    var selector = Iyxzone.Game.initPinyinSelector(
      prefix + 'game_id',
      prefix + 'area_id',
      prefix + 'server_id',
      prefix + 'race_id',
      prefix + 'profession_id',
      true, //start with -- 
      null,
      {});
    this.gameSelectors.set(id, selector);
  },

  removeCharacter: function(id){
    this.gameSelectors.unset(id);
    $('character_' + id).remove();
  },

  submit: function(button, form){
    var valid = true;
    valid &= this.validateCharacters();
    valid &= this.validateLogin();
    valid &= this.validateEmail();
    valid &= this.validatePassword();
    valid &= this.validatePasswordConfirmation();
    
    if(!valid)
      return;

    if(!$('agree_contact').checked){
      tip("请查看协议");
      return;
    }

    if(this.gameSelectors.keys().count == 0){
      tip("至少要有1个游戏角色");
      return;
    }

    new Ajax.Request('/users/', {
      method: 'post',
      parameters: form.serialize(),
			onloading: function(){
				Iyxzone.disableButton(button, '等待中..');
			}
    }); 
  }

});
