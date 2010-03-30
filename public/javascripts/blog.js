Iyxzone.Blog = {
  version: '1.0',
  author: ['高侠鸿'],
  Builder: {}
};


Object.extend(Iyxzone.Blog.Builder, {

  saved: false, 

  editor: null, // initialize this in your page

  tagBuilder: null, // initialize this in your page

  validate: function(){
    if($('blog_privilege').value == ''){
      error("清选择权限");
      return false;
    }
    if($('blog_game_id').value == ''){
      error("请选择游戏类别");
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
    for(var i=0;i<$(this).editor.nicInstances.length;i++){
      $(this).editor.nicInstances[i].saveContent();
    }
    
    $(this).parameters = form.serialize();
    var newTags = $(this).tagBuilder.getNewTags();
    var delTags = $(this).tagBuilder.getDelTags();
    for(var i=0;i<newTags.length;i++){
      $(this).parameters += "&blog[new_friend_tags][]=" + newTags[i];
    }
    for(var i=0;i<delTags.length;i++){
      $(this).parameters += "&blog[del_friend_tags][]=" + delTags[i];
    }
    
    window.onbeforeunload = null;
  },

  saveBlog: function(button, form){
    Iyxzone.disableButtonThree(button, '发布中..');
    if($(this).validate()){
      $(this).prepare(form);
      new Ajax.Request('/blogs', {
        method: 'post',
        parameters: $(this).parameters
      });
    }else{
      Iyxzone.enableButtonThree(button, '发布');
    }
  },
    
  saveDraft: function(button, form){
    Iyxzone.disableButtonThree(button, '保存中..');
    if($(this).validate()){
      $(this).prepare(form);
      new Ajax.Request('/drafts', {
        method: 'post',
        parameters: $(this).parameters
      });
    }else{
      Iyxzone.enableButtonThree(button, '保存为草稿');
    }
  },

  updateBlog: function(button, blogID, form){
    Iyxzone.disableButtonThree(button, '修改中..');
    if($(this).validate()){
      $(this).prepare(form);
      new Ajax.Request('/blogs/' + blogID, {
        method: 'put',
        parameters: $(this).parameters
      });
    }else{
      Iyxzone.enableButtonThree(button, '修改');
    }
  },

  updateDraft: function(button, draftID, form){
    Iyxzone.disableButtonThree(button, '保存中..');
    if($(this).validate()){
      $(this).prepare(form);
      new Ajax.Request('/drafts/' + draftID, {
        method: 'put',
        parameters: $(this).parameters,
        onSuccess: function(transport){
          var ret = transport.responseText.evalJSON();
          $(this).tagBuilder.reset(ret.tags);
					Iyxzone.enableButtonThree(button, '保存为草稿');
          tip('保存成功，可以继续写了');
          $('errors').innerHTML = '';
          $(this).saved = true;
        }.bind($(this))
      });
    }else{
      Iyxzone.enableButtonThree(button, '保存为草稿');
    }
  }

});
