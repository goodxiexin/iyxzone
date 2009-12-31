Iyxzone.Register = {
  version: '1.0',
  author: ['高侠鸿'],
  Manager: {}
};

Object.extend(Iyxzone.Register.Manager, {

  gameSelector: null,

  load: function(div){
    div.innerHTML = '<img src="/images/loading.gif" />';
  },

  showLoginRequirement: function(){
    $('login_info').innerHTML = '只能由数字，字母组成，大小4-16字符';
  },

  validateLogin: function(){
    var login = $('user_login');
    var loginInfo = $('login_info');

    if(login.value == ''){
      loginInfo.innerHTML = '不能为空';
      return false;
    }

    if(login.value.length < 6){
      loginInfo.innerHTML = '至少要4个字符';
      return false;
    }
    if(login.value.length > 16){
      loginInfo.innerHTML = '最多16个字符';
      return false;
    }

    first = login.value[0];
    if((first >= 'a' && first <= 'z') || (first >= 'A' && first <= 'Z')){
      if(login.value.match(/[A-Za-z0-9\_]+/)){
        loginInfo.innerHTML = '';
        loginInfo.addClassName('fldstatus');
        return true;
      }else{
        loginInfo.innerHTML = '只允许字母和数字';
        return false;
      }
    }else{
      loginInfo.innerHTML = '必须以字母开头';
      return false;
    }
  },

  showEmailRequirement: function(){
    $('email_info').innerHTML = '输入合法的邮件地址';
  },

  validateEmail: function(){
    var email = $('user_email');
    var emailInfo = $('email_info');

    if(email.value == ''){
      emailInfo.innerHTML = '邮件不能为空';
      return false;
    }

    if(email.value.match(/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/)){
      this.load(emailInfo);
      new Ajax.Request('/register/validates_email_uniqueness?email='+encodeURIComponent(email.value), {
        method: 'get',
        onSuccess: function(transport){
          if(transport.responseText == 'yes'){
            emailInfo.innerHTML = '';
            emailInfo.addClassName('fldstatus');
          }else{
            emailInfo.innerHTML = '该邮箱已被注册';
          }
        }.bind(this)
      });
      return true;
    }else{
      emailInfo.innerHTML = '非法的邮件格式';
      return false;
    }
  },

  showPasswordRequirement: function(){
    $('password_info').innerHTML = '密码6－20个字符';
  },

  validatePassword: function(){
    var password = $('user_password');
    var passwordInfo = $('password_info');
    var strongReg = new RegExp("^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$", "g");
    var mediumReg = new RegExp("^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");

    // check length
    if(password.value.length < 6){
      passwordInfo.innerHTML = '至少6个字符';
      return false;
    }
    if(password.value.length > 20){
      passwordInfo.innerHTML = '最多20个字符';
      return false;
    }

    // check strength
    if(password.value.match(strongReg)){
      passwordInfo.innerHTML = '密码强度: 强';
      return true;
    }else if(password.value.match(mediumReg)){
      passwordInfo.innerHTML = '密码强度: 中';
      return true;
    }else{
      passwordInfo.innerHTML = '密码强度: 弱';
      return true;
    }
  },

  showPasswordConfirmRequirement: function(){
    $('password_confirmation_info').innerHTML = '确认你的密码';
  },

  validatePasswordConfirmation: function(){
    var password = $('user_password');
    var passwordInfo = $('password_info');
    var passwordConfirmation = $('user_password_confirmation');
    var confirmationInfo = $('password_confirmation_info');

    if(password.value == ''){
      passwordInfo.innerHTML = '密码不能为空';
      return false;
    }

    if(password.value == passwordConfirmation.value){
      confirmationInfo.innerHTML = '两次密码一致';
      return true;
    }else{
      confirmationInfo.innerHTML = '两次密码不一致';
      return false;
    }
  },

  validateCharacterInfo: function(){
    $('character_name_info').innerHTML = '';
    $('character_level_info').innerHTML = '';
    $('character_game_info').innerHTML = '';
    $('character_area_info').innerHTML = '';
    $('character_server_info').innerHTML = '';
    $('character_profession_info').innerHTML = '';
    $('character_race_info').innerHTML = '';

    var name = $('character_name').value;
    var info = $('character_name_info');
    if(name == ''){
      info.innerHTML = '人物昵称应该有的吧';
      return false;
    }

    var level = $('character_level').value;
    info = $('character_level_info');
    if(level.value == ''){
      info.innerHTML = '等级不能不添啊';
      return false;
    }

    if($('character_game_id').value == ''){
      $('character_game_info') = '没有选择游戏，如有问题，请看提示';
      return false;
    }

    var gameDetails = this.gameSelector.getDetails();
    if(gameDetails){
      if(gameDetails.no_servers){
        tip("由于游戏数量庞大，很多游戏已经停服，我们没有把所有游戏统计完成。这个游戏的资料就还不完全，请您在左边的意见／建议中告诉我们您所在游戏的所在服务器，我们会以最快速度为您添加。对您带来得不便，我们道歉。");
        return false;
      }else{
        if($('character_server_id').value == ''){
          info.innerHTML = '没有选择服务器';
          return false;
        }
      }
      if(!gameDetails.no_areas && $('character_area_id').value == ''){
        info.innerHTML = '没有选择区域，如有问题，请看提示';
        return false;
      }
      if(!gameDetails.no_races && $('character_race_id').value == ''){
        info.innerHTML = '没有选择种族';
        return false;
      }
      if(!gameDetails.no_professions && $('character_profession_id').value == ''){
        info.innerHTML = '没有选择职业';
        return false;
      }
    }

    return true;  
  },

  oldCharacterHTML: null,

  newCharacterForm: null,

  characters: new Hash(),

  characterID: 0,

  toHTML: function(info){
    var html = '';
    html += "<li id='character_" + info.id + "'>";
    html += "<h4>" + info.name + "</h4>";
    html += "<a href=# onclick='Iyxzone.Register.Manager.editCharacter(" + info.id + ")'>编辑</a>";
    html += "<a href=# onclick='Iyxzone.Register.Manager.removeCharacter(" + info.id +")'>删除</a>";
    html += "<div><p>等级:" + info.level + "</p>";
    html += "<p>游戏:" + info.gameName + "</p>";
    html += "<ul class='star-rating'>";
    html += "<li class='current-rating' style='width:"+ (info.gameRate * 30) + "px;'>";
    html += "Currently"+ info.gameRate + "/5 Stars.";
    html += "</li>"
    html += "</ul>"
    if(info.areaID != null)
      html += "<p>服务区:" + info.areaName + "</p>";
    html += "<p>服务器:" + info.serverName + "</p>";
    if (info.professionID != null)
      html += "<p>职业:" + info.professionName + "</p>";
    if (info.raceID != null)
      html += "<p>种族:" + info.raceName + "</p>";
    html += "</div></li>";
    return html;
  },

  newCharacter: function(){
    this.oldCharacterHTML = $('character_info').innerHTML;
    if(this.newCharacterForm){
      $('character_info').innerHTML = this.newCharacterForm;
      this.gameSelector.setEvents();
    }else{
      this.load($('character_info'));
      new Ajax.Request('/register/new_character', {
        method: 'get',
        onSuccess: function(transport){
          this.newCharacterForm = transport.responseText;
          $('character_info').innerHTML = this.newCharacterForm;
          this.gameSelector.setEvents();
        }.bind(this)
      });
    }
  },

  cancelNewCharacter: function(){
    $('character_info').innerHTML = this.oldCharacterHTML;  
    //this.gameSelector.reset();
  },

  createCharacter: function(){
    if(this.validateCharacterInfo()){
      var newInfo = {
        id: this.characterID,
        name: $('character_name').value,
        level: $('character_level').value,
        gameID: $('character_game_id').value,
        gameName: $('character_game_id').options[$('character_game_id').selectedIndex].text,
        gameRate: $('game_rate').value,
        areaID: $('character_area_id').value,
        areaName: $('character_area_id').options[$('character_area_id').selectedIndex].text,
        serverID: $('character_server_id').value,
        serverName: $('character_server_id').options[$('character_server_id').selectedIndex].text,
        professionID: $('character_profession_id').value,
        professionName: $('character_profession_id').options[$('character_profession_id').selectedIndex].text,
        raceID: $('character_race_id').value,
        raceName: $('character_race_id').options[$('character_race_id').selectedIndex].text,
        playing: $('character_playing').value
      };
      $('character_info').innerHTML = this.oldCharacterHTML;
      // update existing ratings
      this.characters.each(function(c){
        var info = c.value;
        if(info.gameID == newInfo.gameID){
          info.gameRate = newInfo.gameRate;
          this.characters.set(c.key, info);
          Element.replace($('character_' + c.key), this.toHTML(info));
        }
      }.bind(this));

      // inserting new ratings
      this.characters.set(newInfo.id, newInfo);
      this.characterID += 1;
      Element.insert($('characters'), {top: this.toHTML(newInfo)});
      //this.gameSelector.reset();//gameDetails = null;
    }
  },

  editCharacter: function(characterID){
    var info = this.characters.get(characterID);
    var params = {
      'id': info.id,
      'rating': info.gameRate,
      'character[game_id]': info.gameID,
      'character[area_id]': info.areaID,
      'character[server_id]': info.serverID,  
      'character[race_id]': info.raceID,
      'character[profession_id]': info.professionID,
      'character[name]': info.name,
      'character[level]': info.level
    };

    this.oldCharacterHTML = $('character_info').innerHTML;
    this.load($('character_info'));

    new Ajax.Request('/register/edit_character', {
      method: 'get',
      parameters: params,
      onSuccess: function(transport){
        $('character_info').innerHTML = transport.responseText;
        this.gameSelector.setEvents();
      }.bind(this)
    });
  },

  cancelEditCharacter: function(){
    $('character_info').innerHTML = this.oldCharacterHTML;
    //this.gameSelector.reset();//gameDetails = null;
  },

  updateCharacter: function(characterID){
    if(this.validateCharacterInfo()){
      var newInfo = {
        id: characterID,
        name: $('character_name').value,
        level: $('character_level').value,
        gameID: $('character_game_id').value,
        gameName: $('character_game_id').options[$('character_game_id').selectedIndex].text,
        gameRate: $('game_rate').value,
        areaID: $('character_area_id').value,
        areaName: $('character_area_id').options[$('character_area_id').selectedIndex].text,
        serverID: $('character_server_id').value,
        serverName: $('character_server_id').options[$('character_server_id').selectedIndex].text,
        professionID: $('character_profession_id').value,
        professionName: $('character_profession_id').options[$('character_profession_id').selectedIndex].text,
        raceID: $('character_race_id').value,
        raceName: $('character_race_id').options[$('character_race_id').selectedIndex].text,
        updating: $('character_playing').value
      }; 
      this.characters.set(characterID, newInfo);
      $('character_info').innerHTML = this.oldCharacterHTML;
      //this.gameSelector.reset();//gameDetails = null;

      // update all characters
      this.characters.each(function(c){
        var info = c.value;
        if(info.gameID == newInfo.gameID){
          info.gameRate = newInfo.gameRate;//info.updateGameRate(newInfo.rating);
          this.characters.set(c.key, info);
          Element.replace($('character_' + c.key), this.toHTML(info));
        }
      }.bind(this));
    }
  },

  removeCharacter: function(characterID){
    this.characters.unset(characterID);
    $('character_' + characterID).remove();
  },

  submit: function(){
    if(!this.validateLogin()) return;
    if(!this.validateEmail()) return;
    if(!this.validatePassword()) return;
    if(!this.validatePasswordConfirmation()) return;
/*
    if(this.characters.size() == 0){
      error('至少要有1个游戏角色');
      return;
    }
*/
    if(!$('allow').checked){
      error('必须同意才能注册');
      return;
    }

    // construct parameters
    var form = $('register_form');
    var ratings = new Hash();
    var params = form.serialize() + '&';
    this.characters.each(function(p){
      var info = p.value;
      params += 'characters[][name]=' + info.name + '&';
      params += 'characters[][level]=' + info.level + '&';
      params += 'characters[][game_id]=' + info.gameID+ '&';
      params += 'characters[][area_id]=' + info.areaID+ '&';
      params += 'characters[][server_id]=' + info.serverID+ '&';
      params += 'characters[][profession_id]=' + info.professionID+ '&';
      params += 'characters[][race_id]=' + info.raceID+ '&';
      ratings.set(info.gameID, info.gameRate);
    });
    ratings.each(function(r){
      params += 'rating[][rateable_id]=' + r.key + '&';
      params += 'rating[][rating]=' + r.value + '&';
    });

    // send request
    new Ajax.Request('/users', {method: 'post', parameters: params});
  },

  setupRating: function(rating){
    $('game_rate').value = rating;
    $('current_rate').innerHTML = "<li class='current-rating' style='width:"+ rating*30 +"px;'> Currently "+ rating +"/5 Stars.</li>"; 
  }

});
