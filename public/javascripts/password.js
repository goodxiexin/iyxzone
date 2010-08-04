Iyxzone.Password = {
  version: '1.0',
  author: ['高侠鸿']
};

Object.extend(Iyxzone.Password, {

  codes: null,

  validate: function(){
    var str='';
    var len = this.codes.length;
    for(var i=0;i < len; i++){
      str += this.codes[i];
    }
    return str == $('validation_code').value;
  },

  resetValidation: function(){
    var validation = Iyxzone.validationCode(4);
//    $('validation').innerHTML = validation.div.innerHTML;
    $('validation').update( validation.div.innerHTML);
    this.codes = validation.codes;
  },

  send: function(button, form){
    Iyxzone.disableButton(button, '正在发送');
    if(this.validate()){
      form.submit();
    }else{
      error('验证码不正确');
      Iyxzone.enableButton(button, '发送邮件');
    }
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

  showPasswordConfirmRequirement: function(){
    this.tip('password_confirmation_info', '确认你的密码');
  },

  showPasswordRequirement: function(){
    this.tip('password_info', '密码6－20个字符');
  },

  validatePassword: function(){
    var password = $('password').value;
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
    if(strongReg.exec(strongReg)){
      this.tip('password_info', '密码强度: 强');
      return true;
    }else if(mediumReg.exec(mediumReg)){
      this.tip('password_info', '密码强度: 中');
      return true;
    }else{
      this.tip('password_info', '密码强度: 弱');
      return true;
    } 
  },

  validatePasswordConfirmation: function(){
    var password = $('password').value;
    var passwordConfirmation = $('password_confirmation').value;
    
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

  reset: function(button, form){
    Iyxzone.disableButton(button, '正在发送');
    if(this.validatePassword() && this.validatePasswordConfirmation()){
      form.submit();
    }else{
      Iyxzone.enableButton(button, '重置');
    }
  }

});
