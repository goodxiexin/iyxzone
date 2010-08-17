Iyxzone.Notification = {

  version: '1.0',

  author: ['高侠鸿']

};

Object.extend(Iyxzone.Notification, {

  destroy: function(id, link){
    new Ajax.Request(Iyxzone.URL.deleteNotification(id), {
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
          $('notification_' + id).remove();
        }else if(json.code == 0){
          error('发生错误，请稍后再试');
          $(link).writeAttribute('onclick', "Iyxzone.Notification.detroy(" + id + ", this);");
        }
      }.bind(this)
    });
  },

  destroyAll: function(userID, link){
    new Ajax.Request(Iyxzone.URL.deleteAllNotification(userID), {
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
          window.location.href = Iyxzone.URL.listNotification(userID);
        }else if(json.code == 0){
          error('发生错误，请稍后再试');
          $(link).writeAttribute('onclick', "Iyxzone.Notification.confirmDestroyingAll(" + userID + ", this);");
        }
      }.bind(this)
    });      
  },

  confirmDestroyingAll: function(userID, link){
    Iyxzone.Facebox.confirmWithCallback("你确定要删除所有通知吗", null, null, function(){
      this.destroyAll(userID, link);
    }.bind(this));
  } 

});

