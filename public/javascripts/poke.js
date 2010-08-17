Iyxzone.Poke = {

  version: '1.0',

  author: '高侠鸿'

};

Object.extend(Iyxzone.Poke, {

  deliver: function(form, btn){
    new Ajax.Request(Iyxzone.URL.createPoke(), {
      method: 'post',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.disableButton(btn, "正在发送");
      },
      onComplete: function(){},
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          notice("发送成功");
        }else{
          error("发生错误");
        }
      }.bind(this)
    });
  },

  destroy: function(pokeID, link){
    new Ajax.Request(Iyxzone.URL.deletePoke(pokeID), {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        $(link).writeAttribute('onclick', '');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('pd_' + pokeID).remove();
        }else if(json.code == 0){
          error("发生错误，稍后再试");
          $(link).writeAttribute('onclick', "Iyxzone.Poke.destroy(" + pokeID + ", this);");
        }
      }.bind(this)
    });
  },

  destroyAll: function(userID, link){
    new Ajax.Request(Iyxzone.URL.deleteAllPoke(userID), {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        $(link).writeAttribute('onclick', '');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.listPoke(userID);
        }else if(json.code == 0){
          error("发生错误，稍后再试");
          $(link).writeAttribute('onclick', "Iyxzone.Poke.confirmDestroyingAll(" + userID + ", this);");
        }
      }.bind(this)
    });    
  },

  confirmDestroyingAll: function(userID, link){
    Iyxzone.Facebox.confirmWithCallback("你确定要删除所有招呼吗", null, null, function(){
      this.destroyAll(userID, link);
    }.bind(this));
  },

  reply: function(pokeID, recipientID, link){
    new Ajax.Request(Iyxzone.URL.createPoke(), {
      method: 'post',
      parameters: {'delivery[recipient_id]': recipientID, 'delivery[poke_id]': pokeID},
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        $(link).writeAttribute('onclick', '');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        $(link).writeAttribute('onclick', "Iyxzone.Poke.reply(" + pokeID + "," + recipientID + ", this);");
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          notice("回复成功");
        }else{
          error("发生错误");
        }
      }.bind(this)
    });
  }

});
