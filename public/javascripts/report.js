Iyxzone.Report = {

  version: '1.1',

  author: '高侠鸿'

};

Object.extend(Iyxzone.Report, {

  validate: function(){
    var con = $('report_content').value;
    if(con == ''){
      alert("说点什么吧");
      return false;
    }else if(con.length > 100){
      alert("最多100个字");
      return false;
    }

    var cat = $('report_category').value;
    if(cat == ''){
      alert("请选择类型");
      return false;
    }

    return true;
  },

  submit: function(form, btn){
    Iyxzone.disableButton(btn, '发送..');
    if(this.validate()){
      new Ajax.Request(Iyxzone.URL.createReport(), {
        method: 'post',
        parameters: $(form).serialize(),
        onLoading: function(){
        },
        onComplete: function(){
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            Iyxzone.Facebox.close();
          }else{
            Iyxzone.enableButton(btn, '完成');
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButton(btn, '完成');
    }
  }

});
