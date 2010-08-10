Iyxzone.PersonalPhoto = {

  version: '1.0',

  author: '高侠鸿'

};

// edit, update photo
Object.extend(Iyxzone.PersonalPhoto, {

  updateMultiplePhotos: function(btn, form, albumID){
    new Ajax.Request(Iyxzone.URL.updateMultiplePhoto(albumID), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.disableButton(btn, '请等待..');
      },
      onComplete: function(){},
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showAlbum(albumID);
        }else{
          error("保存的时候发生错误，请稍后再试试");
          Iyxzone.enableButton(btn, '保存修改');
        }
      }.bind(this)
    });
  },

  updatePhoto: function(at, btn, form, photoID, albumID){
    // check description
    var desc = $('photo_notation').value;
    if(desc.value != '' && desc.length > 500){
      $('errors').innerHTML = "照片描述最长500个字";
      return;
    }
    
    // record new album id
    var newAlbumID = $('photo_album_id').value;

    new Ajax.Request(Iyxzone.URL.updatePhoto(photoID), {
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
            if(newAlbumID != albumID){
              window.location.href = Iyxzone.URL.showAlbum(newAlbumID);
            }else{
              notice("修改成功");
            }
          }else if(at == 'photo'){
            window.location.href = Iyxzone.URL.showPhoto(photoID);
          }
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  deletePhoto: function(photoID, albumID){
    new Ajax.Request(Iyxzone.URL.deletePhoto(photoID), {
      method: 'delete',
      onLoading: function(){},
      onComplete: function(){},
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showAlbum(albumID);
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
