Iyxzone.Forum = {

  version: '1.6',

  author: ['高侠鸿'],

  TopicBuilder: {},

  PostBuilder: {}

};

// some topic operations
Object.extend(Iyxzone.Forum, {

  toggleTopic: function(topicID, forumID, link, at){
    new Ajax.Request(Iyxzone.URL.toggleTopic(topicID), {
      method: 'put',
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
          if(at == 'index'){
            window.location.href = Iyxzone.URL.listTopic(forumID);
          }else if(at == 'top_index'){
            window.location.href = Iyxzone.URL.listTopTopic(forumID);
          }else if(at == 'forum_show'){
            window.location.href = Iyxzone.URL.showForum(forumID);
          }else if(at == 'topic_show'){
            window.location.href = Iyxzone.URL.showTopic(topicID);
          }
        }else if(json.code == 0){
          error("发生错误");
          $(link).writeAttribute('onclick', "Iyxzone.Forum.toggleTopic(" + topicID + ", " + forumID + ", this, '" + at + "');");
        }
      }.bind(this)
    });
  },

  deleteTopic: function(topicID, forumID, link, at){
    new Ajax.Request(Iyxzone.URL.deleteTopic(topicID), {
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
          Iyxzone.Facebox.close();
          if(at == 'topic_show'){
            window.location.href = Iyxzone.URL.showForum(forumID);
          }else{
            $('topic_' + topicID).remove();
          }
        }else if(json.code == 0){
          error("发生错误");
          $(link).writeAttribute('onclick', "Iyxzone.URL.deleteTopic(" + topicID + ", " + forumID + ", this, '" + at + "');");
        }
      }.bind(this)
    }); 
  },

  confirmDeletingTopic: function(topicID, forumID, link, at){
    Iyxzone.Facebox.confirmWithCallback("你确定要删除这篇帖子吗?", null, null, function(){
      this.deleteTopic(topicID, forumID, link, at);
    }.bind(this));
  }

});

Object.extend(Iyxzone.Forum.TopicBuilder, {
  
  editor: null,

  forumID: null,

  init: function(forumID, albums, textAreaID, token){
    this.forumID = forumID;

    // set nicEditors
    nicEditors.albums = albums;
    nicEditors.authenticityToken = token;
    this.editor = new nicEditor({buttonList: ['bold','italic','underline','left','center','right','justify','ol','ul','fontSize','fontFamily','fontFormat','emotion','link','forecolor']}).panelInstance(textAreaID);

    // set last content and beforeunload
    window.onbeforeunload = function(){
      return "你还没保存，你确定要离开?";
    };
  },
  
  validate: function(){
    if($('topic_subject').value == ''){
      error('标题不能为空');
      return false;
    }
    if($('topic_subject').value.length > 100){
      error('标题最长100个字符');
      return false;
    }
    var content = this.editor.instanceById('topic_content').getContent();

    if(content.length < 6){
      error('内容不能少于6个字符');
      return false;
    }
    if(content.length > 100000){
      error('内容最长100000个字符');
      return false;
    }
    return true;
  },

  prepare: function(form){
    // fix nicEdit bug
    for(var i=0;i<this.editor.nicInstances.length;i++){
      this.editor.nicInstances[i].saveContent();
    }
    window.onbeforeunload = null;   
    return $(form).serialize();
  },

  save: function(form){
    var btn = $(form).down('button', 0);
    Iyxzone.disableButtonThree(btn, '正在发布..');
    if(this.validate()){
      var params = this.prepare(form);
      new Ajax.Request(Iyxzone.URL.createTopic(this.forumID), {      
        method: 'post',
        parameters: params,
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.showTopic(json.id);
          }else{
            error("发生错误");
            Iyxzone.enableButton(btn, '发布');
          } 
        }.bind(this)
      }); 
      window.onbeforeunload = null;
      this.editor.instanceById('topic_content').saveContent();
    }else{
      Iyxzone.enableButtonThree(btn, '发布');
    }   
  }

});

Object.extend(Iyxzone.Forum.PostBuilder, {
  
  editor: null,

  topicID: null,

  init: function(topicID, albums, textAreaID, token){
    this.topicID = topicID;

    // set nicEditors
    nicEditors.albums = albums;
    nicEditors.authenticityToken = token;
    this.editor = new nicEditor({buttonList: ['bold','italic','underline','left','center','right','justify','ol','ul','fontSize','fontFamily','fontFormat','emotion','link','forecolor']}).panelInstance(textAreaID);
  },

  validate: function(){
    var content = this.editor.instanceById('post_content').getContent();
    if(content.length < 6){
      error('回复不能少于6个字符');
      return false;
    }
    if(content.length > 100000){
      error('回复最长100000个字符');
      return false;
    }
    return true;
  },

  prepare: function(form){
    // fix nicEdit bug
    for(var i=0;i<this.editor.nicInstances.length;i++){
      this.editor.nicInstances[i].saveContent();
    }
    return $(form).serialize();
  },  

  save: function(form){
    var btn = $(form).down('button', 0);
    Iyxzone.disableButtonThree(btn, '正在发布..');
    if(this.validate(form)){
      var params = this.prepare(form);
      new Ajax.Request(Iyxzone.URL.createPost(this.topicID), {
        method: 'post',
        parameters: params,
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.showTopic(this.topicID);
          }else{
            error("发生错误");
            Iyxzone.enableButtonThree(btn, '发布');
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButtonThree(btn, '发布');
    }   
  },

  reply: function(floor, name, id){
    $('post_recipient_id').value = id;
    if(floor)
      this.editor.instanceById('post_content').setContent("<span style='font-size: 14px;font-weight:bold'>回复" + floor + "楼" + name + ":</span><hr/>");
    else
      this.editor.instanceById('post_content').setContent("<span style='font-size: 14px;font-weight:bold'>回复楼主:</span><hr/>");
    window.scrollTo(0, $('new_post').cumulativeOffset().top);
  }

});

// some post operations
Object.extend(Iyxzone.Forum, {

  deletePost: function(postID, topicID, forumID, link){
    new Ajax.Request(Iyxzone.URL.deletePost(postID), {
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
          Iyxzone.Facebox.close();
          $('post_' + postID).remove();
        }else{
          error("发生错误");
          $(link).writeAttribute('onclick', "Iyxzone.Forum.confirmDeletingPost(" + postID + ", " + topicID + ", " + forumID + ", this);");
        }
      }.bind(this)
    });
  },

  confirmDeletingPost: function(postID, topicID, forumID, link){
    Iyxzone.Facebox.confirmWithCallback("你确定要删除这个回复吗", null, null, function(){
      this.deletePost(postID, topicID, forumID, link);
    }.bind(this));
  }

});
