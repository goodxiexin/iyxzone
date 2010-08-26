Iyxzone.Guestbook = {

  version: '1.1',

  author: '高侠鸿'

};

Object.extend(Iyxzone.Guestbook, {

  validate: function(){
    var desc = $('guestbook_description').value;
    if(desc.length == 0){
      alert("写点什么吧");
      return false;
    }else if(desc.length > 1000){
      alert("最多1000个字");
      return false;
    }

    var cate = $('guestbook_catagory').value;
    if(cate == ''){
      alert('请选择类别');
      return false;
    }

    return true;
  },

  submit: function(form){
    var btn1 = $(form).down('button', 0);
    var btn2 = $(form).down('button', 1);

    if(this.validate()){
      new Ajax.Request(Iyxzone.URL.createGuestbook(), {
        method: 'post',
        parameters: $(form).serialize(),
        onLoading: function(transport){
          Iyxzone.disableButton(btn1, btn1.innerHTML);
          Iyxzone.disableButton(btn2, btn2.innerHTML);
          Iyxzone.changeCursor('wait');
        },
        onComplete: function(transport){
          Iyxzone.changeCursor('default');
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            Iyxzone.Facebox.close();
          }else if(json.code == 0){
            error("发生错误");
            Iyxzone.enableButton(btn1, btn1.innerHTML);
            Iyxzone.enableButton(btn2, btn2.innerHTML);
          }
        }.bind(this)
      });
    }
  }

});
