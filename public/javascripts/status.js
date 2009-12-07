StatusBuilder = Class.create({

  initialize: function(){
    this.content = $('status_content');
    this.form = $('status_form');
  },

  validate: function(){
    if(this.content.value == ''){
      error('状态不能为空');
      return false;
    }
    return true;
  },

  submit: function(){
    if(this.validate())
      new Ajax.Request('/statuses?home=0', {method: 'post', parameters: this.form.serialize()});
  }

});
