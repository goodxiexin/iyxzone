Iyxzone.Video = {

  version: '1.4',

  author: ['高侠鸿'],

  Builder: {},

  play: function(videoID, videoLink){
     $('video_' + videoID).update(videoLink);
  }
};

// delete video
Object.extend(Iyxzone.Video, {
  
  deleteVideo: function(videoID, userID){
    new Ajax.Request(Iyxzone.URL.deleteVideo(videoID), {
      method: 'delete',
      onLoading: function(){
      },
      onComplete: function(){
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.listVideo(userID);
        }else if(json.code == 0){
          error('删除的时候发生错误，请稍后再试');
        }
      }.bind(this)
    });
  },

  confirmDeletingVideo: function(videoID, userID){
    Iyxzone.Facebox.confirmWithCallback("你确定要删除这个视频吗?", null, null, function(){
      Iyxzone.Video.deleteVideo(videoID, userID);
    }.bind(this));
  }

});

// create video
Object.extend(Iyxzone.Video.Builder, {

  friendTagger: null, //initialize this in your page

  gameTagger: null,

  validate: function(){
    if($('video_title').value == ''){
      error('标题不能为空');
      return false;
    }
    if($('video_video_url').value == ''){
      error('url不能为空');
      return false;
    }
    if($('video_title').length >= 100){
      facebox.show_error('标题太长了，最长100个字符');
      return false;
    }
    return true;
  },  

  prepare: function(form){
    this.parameters = $(form).serialize();

    var newTags = this.friendTagger.getNewTags();
    var delTags = this.friendTagger.getDelTags();
    for(var i=0;i<newTags.length;i++){
      this.parameters += "&video[new_friend_tags][]=" + newTags[i];
    }
    for(var i=0;i<delTags.length;i++){
      this.parameters += "&video[del_friend_tags][]=" + delTags[i];
    }

    var newGames = this.gameTagger.getNewRelGames();
    var delGames = this.gameTagger.getDelRelGames();
    for(var i=0;i<newGames.length;i++){
      this.parameters += "&video[new_relative_games][]=" + newGames[i];
    }
    for(var i=0;i<delGames.length;i++){
      this.parameters += "&video[del_relative_games][]=" + delGames[i];
    }
  },

  save: function(button, form){
    Iyxzone.disableButtonThree(button, '发布中..');
    if(this.validate()){
      this.prepare(form);
      new Ajax.Request(Iyxzone.URL.createVideo(), {
        method: 'post',
        parameters: this.parameters,
        onLoading: function(){
        },
        onComplete: function(){
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.showVideo(json.id);
          }else if(json.code == 0){
            error('不是合法的视频url，请检查你的视频url');
            Iyxzone.enableButtonThree(button, '保存');
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButtonThree(button, '保存');
    }
  },

  update: function(button, form, videoID){
    Iyxzone.disableButtonThree(button, '更新中..');
    if(this.validate()){
      this.prepare(form);
      new Ajax.Request(Iyxzone.URL.updateVideo(videoID), {
        method: 'put',
        parameters: this.parameters,
        onLoading: function(){
        },
        onComplete: function(){
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.showVideo(videoID);
          }else if(json.code == 0){
            error('不是合法的视频url，请检查你的视频url');
            Iyxzone.enableButtonThree(button, '保存');
          }
        }.bind(this)
      });
    }else{
      iyxzone.enablebuttonthree(button, '更新');
    }
  },

  init: function(max, tagInfos, toggleButton, input, friendList, friendTable, friendItems, gameSelector, confirmButton, cancelButton, max2, gameInfos, gameInput, gameList){
    // set friend tagger
    this.friendTagger = new Iyxzone.Friend.Tagger(max, tagInfos, toggleButton, input, friendList, friendTable, friendItems, gameSelector, confirmButton, cancelButton); 

    // set game tagger
    this.gameTagger = new Iyxzone.Game.Tagger(max2, gameInfos, gameInput, gameList);
  }

});
