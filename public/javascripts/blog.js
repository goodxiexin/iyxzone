Iyxzone.Blog = {

  version: '1.6',

  author: ['高侠鸿 '],

  Builder: {}

};

Object.extend(Iyxzone.Blog, {
  
  deleteBlog: function(id, userID){
    new Ajax.Request(Iyxzone.URL.deleteBlog(id), { 
      method: 'delete',
      onLoading: function(){
      },
      onComplete: function(){
        Iyxzone.Facebox.close();
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.listBlog(userID);
        }else if(json.code == 0){
          error('删除的时候发生错误，请稍后再试');
        }
      }.bind(this)
    });
  },

  confirmDeletingBlog: function(id, userID){
    Iyxzone.Facebox.confirmWithCallback("你确定要删除这篇日志吗", null, null, function(){
      Iyxzone.Blog.deleteBlog(id, userID);
    });
  },

  deleteDraft: function(id, userID){
    new Ajax.Request(Iyxzone.URL.deleteDraft(id), {
      method: 'delete',
      onLoading: function(){
      },
      onComplete: function(){
        Iyxzone.Facebox.close();
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.listDraft(userID);
        }else if(json.code == 0){
          error('删除的时候发生错误，请稍后再试');
        }
      }.bind(this)
    });
  },

  confirmDeletingDraft: function(id, userID){
    Iyxzone.Facebox.confirmWithCallback("你确定要删除这篇日志吗", null, null, function(){
      Iyxzone.Blog.deleteDraft(id, userID);
    });
  }

});

Object.extend(Iyxzone.Blog.Builder, {  

  saved: false, 

  editor: null, // initialize this in your page

  friendTagger: null, // initialize this in your page
 
  gameTagger: null,
 
  lastContent: null,

  contentChanged: function(){
    return (this.lastContent != this.editor.nicInstances[0].getContent());
  },

  validate: function(){
    if($('blog_privilege').value == ''){
      error("清选择权限");
      return false;
    }
    if($('blog_title').value == ''){
      error("标题不能为空");
      return false;
    }
    if($('blog_title').length > 100){
      error("标题最长100个字符");
      return false;
    }
    return true;
  },

  prepare: function(form){
    // fix nicEdit bug
    for(var i=0;i<this.editor.nicInstances.length;i++){
      this.editor.nicInstances[i].saveContent();
    }
    
    this.parameters = $(form).serialize();

    var newTags = this.friendTagger.getNewTags();
    var delTags = this.friendTagger.getDelTags();
    for(var i=0;i<newTags.length;i++){
      this.parameters += "&blog[new_friend_tags][]=" + newTags[i];
    }
    for(var i=0;i<delTags.length;i++){
      this.parameters += "&blog[del_friend_tags][]=" + delTags[i];
    }

    var newGames = this.gameTagger.getNewRelGames();
    var delGames = this.gameTagger.getDelRelGames();
    for(var i=0;i<newGames.length;i++){
      this.parameters += "&blog[new_relative_games][]=" + newGames[i];
    }
    for(var i=0;i<delGames.length;i++){
      this.parameters += "&blog[del_relative_games][]=" + delGames[i];
    }
    
    window.onbeforeunload = null;
  },

  saveBlog: function(button, form){
    Iyxzone.disableButtonThree(button, '发布中..');
    if(this.validate()){
      this.prepare(form);
      new Ajax.Request(Iyxzone.URL.createBlog(), {
        method: 'post', 
        parameters: this.parameters,
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.showBlog(json.id);
          }else{
            error("发生错误");
            Iyxzone.enableButton(button, "完成");
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButtonThree(button, '发布');
    }
  },
    
  saveDraft: function(button, form){
    Iyxzone.disableButtonThree(button, '保存中..');
    if(this.validate()){
      this.prepare(form);
      new Ajax.Request(Iyxzone.URL.createDraft(), {
        method: 'post',
        parameters: this.parameters,
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.editDraft(json.id, {"tip": 1});
          }else{
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButtonThree(button, '保存为草稿');
    }
  },

  updateBlog: function(button, blogID, form){
    Iyxzone.disableButtonThree(button, '修改中..');
    if(this.validate()){
      this.prepare(form);
      new Ajax.Request(Iyxzone.URL.updateBlog(blogID), {
        method: 'put',
        parameters: this.parameters,
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.showBlog(blogID);
          }else{
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButtonThree(button, '修改');
    }
  },

  updateDraft: function(button, draftID, form){
    Iyxzone.disableButtonThree(button, '保存中..');
    if(this.validate()){
      this.prepare(form);
      new Ajax.Request(Iyxzone.URL.updateDraft(draftID), {
        method: 'put',
        parameters: this.parameters,
        onComplete: function(){
          Iyxzone.enableButtonThree(button, '保存为草稿');
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            this.friendTagger.reset();
            this.lastContent = this.editor.nicInstances[0].getContent();  
            tip('保存成功，可以继续写了');
            $('errors').innerHTML = '';
            this.saved = true;
          }else{
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButtonThree(button, '保存为草稿');
    }
  },

  init: function(textAreaID, token, albumInfos, max, tagInfos, toggleButton, input, friendList, friendTable, friendItems, gameSelector, confirmButton, cancelButton, max2, gameInfos, gameInput, gameList){
    // set nicEditor
    this.editor = new nicEditor().panelInstance(textAreaID);
    nicEditors.albums = albumInfos;
    nicEditors.authenticityToken = token;

    // set last content and beforeunload
    this.lastContent = $(textAreaID).value;
    window.onbeforeunload = function(){ 
      if(Iyxzone.Blog.Builder.contentChanged()){
        return "你还没保存，你确定要离开?";
      }else{
        return null;
      }
    };

    // set friend tagger
    this.friendTagger = new Iyxzone.Friend.Tagger(max, tagInfos, toggleButton, input, friendList, friendTable, friendItems, gameSelector, confirmButton, cancelButton);

    // set game tagger
    this.gameTagger = new Iyxzone.Game.Tagger(max2, gameInfos, gameInput, gameList);
  }

});
