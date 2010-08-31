Iyxzone.Album = {
  
  version: '1.5',

  author: ['高侠鸿'],

  Builder: {}

};

// destroy album
Object.extend(Iyxzone.Album, {

  deleteAlbum: function(btn, albumID, userID){
    var params = "";
    if($('migration_0')){
      if($('migration_0').checked){
        params = {"migration": 0};
      }else{
        params = {"migration": 1, "migrate_to": $('migrate_to').value};
      }
    }

    new Ajax.Request(Iyxzone.URL.deleteAlbum(albumID), {
      method: 'delete',
      parameters: params,
      onLoading: function(){
        Iyxzone.disableButton(btn, "发送中..");
      },
      onComplete: function(){},
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.listAlbum(userID);
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
          Iyxzone.enableButton(btn, "完成");
        }
      }.bind(this)
    });
  },

  updateAlbum: function(btn, form, albumID){
  }

});

// create ablum
Object.extend(Iyxzone.Album.Builder, {

  gameTagger: null,

  init: function(max, tags, input, list){
    this.gameTagger = new Iyxzone.Game.Tagger(max, tags, input, list);
  },

  clearError: function(){
    //$('errors').innerHTML = '';
    //$('errors').hide();
  },

  addError: function(error){
    alert(error);
    //$('errors').innerHTML = $('errors').innerHTML + "<br/>" + error;
    //if(!$('errors').visible()){
    //  $('errors').show();
    //}
  },

  validate: function(){
    this.clearError();

    // title
    var title = $('album_title').value;
    if(title == ''){
      this.addError('标题不能为空');
      return false;
    }
    if(title.length > 100){
      this.addError('标题最长100个字');
      return false;
    }  

    // description
    var desc = $('album_description').value;
    if(desc != '' && desc.length > 500){
      this.addError('介绍最多500个字');
      return false;
    }

    // privilege
    var privilege = $('album_privilege').value;
    if(privilege == ''){
      this.addError('请选择权限');
      return false;
    }

    return true;
  },

  buildParams: function(form){
    var params = $(form).serialize();

    var newGames = this.gameTagger.getNewRelGames();
    var delGames = this.gameTagger.getDelRelGames();
    for(var i=0;i<newGames.length;i++){
      params += "&album[new_relative_games][]=" + newGames[i];
    }
    for(var i=0;i<delGames.length;i++){
      params += "&album[del_relative_games][]=" + delGames[i];
    }

    return params; 
  },

  create: function(at, btn, form, userID){
    Iyxzone.disableButton(btn, '请等待..');

    if(this.validate()){
      new Ajax.Request(Iyxzone.URL.createAlbum(), {
        method: 'post',
        parameters: this.buildParams(form),
        onLoading: function(){},
        onComplete: function(){},
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            Iyxzone.Facebox.close();
            if(at == 'index'){
              window.location.href = Iyxzone.URL.listAlbum(userID);
            }else if(at == 'select'){
              var title = $('album_title').value;
              $('album_id').update($('album_id').innerHTML + '<option value=' + json.id + '>' + title + '</option>');
              $('album_id').value = json.id;
            }
          }else if(json.code == 0){
            error("发生错误");
            Iyxzone.enableButton(btn, '完成');
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButton(btn, '完成');
    }
  },

  update: function(btn, form, albumID){
    Iyxzone.disableButton(btn, "请等待..");

    if(this.validate()){
      new Ajax.Request(Iyxzone.URL.updateAlbum(albumID), {
        method: 'put',
        parameters: this.buildParams(form),
        onLoading: function(){},
        onComplete: function(){},
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            Iyxzone.Facebox.close();
          }else{
            error("发生错误，请稍后再试");
            Iyxzone.enableButton(btn, '完成');
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButton(btn, '完成');
    }
  }

});
