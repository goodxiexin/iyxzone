Iyxzone.Avatar = {

  version: '1.0',

  author: '高侠鸿'

};

// edit, update photo
Object.extend(Iyxzone.Avatar, {

  updatePhoto: function(at, btn, form, photoID, albumID){
    // check description
    var desc = $('photo_notation').value;
    if(desc.value != '' && desc.length > 500){
      $('errors').innerHTML = "照片描述最长500个字";
      return;
    }
    
    new Ajax.Request(Iyxzone.URL.updateAvatar(photoID), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.disableButton(btn, "请等待..");
      },
      onComplete: function(){},
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          if(at == 'album'){
            window.location.href = Iyxzone.URL.showAvatarAlbum(albumID);
          }else if(at == 'photo'){
            window.location.href = Iyxzone.URL.showAvatar(photoID);
          }
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  deletePhoto: function(photoID, albumID){
    new Ajax.Request(Iyxzone.URL.deleteAvatar(photoID), {
      method: 'delete',
      onLoading: function(){},
      onComplete: function(){},
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showAvatarAlbum(albumID);
        }else{
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  confirmDeletingPhoto: function(photoID, albumID){
    Iyxzone.Facebox.confirmWithCallback("你确定要删除这张图片吗", null, null, function(){
      this.deletePhoto(photoID, albumID);
    }.bind(this));
  }

});
