Iyxzone.Status = {
  version: '1.0',
  author: ['高侠鸿'],
  Builder: {}
};

Object.extend(Iyxzone.Status.Builder, {

  validate: function(){
    if($('status_content').value == ''){
      error('状态不能为空');
      return false;
    }else if($('status_content').value.length > 140){
      error('字数不能超过140');
      return false;
    }
    return true;
  },

  save: function(button, form){
    Iyxzone.disableButtonThree(button, '发布中..');
    if(this.validate()){
      new Ajax.Request('/statuses', {
        method: 'post', 
        parameters: form.serialize(),
				onComplete: function(){
					Iyxzone.enableButtonThree(button, '发布');
          if($('words_count')){
            $('words_count').innerHTML = '0/140';
          } 
				}
      });
    }else{
      Iyxzone.enableButtonThree(button, '发布');
    }
  }

});
