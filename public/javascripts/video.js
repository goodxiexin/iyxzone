Iyxzone.Video = {
  version: '1.0',
  author: ['高侠鸿'],
  Builder: {},
  play: function(videoID, videoLink){
     $('video_' + videoID).innerHTML = videoLink;
  }
};

Object.extend(Iyxzone.Video.Builder, {

  tagBuilder: null, //initialize this in your page

  validate: function(){
    if($('video_title').value == ''){
      error('标题不能为空');
      return false;
    }
    if($('video_url').value == ''){
      error('url不能为空');
      return false;
    }
    if(!$('video_url').value.include('youku')){
      error('现在只有youku的视频才能解析。。慢慢都会有的');
      return false;
    }
    if($('video_game_id').value == ''){
      error('游戏类别不能为空');
      return false;
    }
    if($('video_title').length >= 100){
      facebox.show_error('标题太长了，最长100个字符');
      return false;
    }
    return true;
  },  

  prepare: function(form){
    var newTags = this.tagBuilder.getNewTags();
    var delTags = this.tagBuilder.getDelTags();
    for(var i=0;i<newTags.length;i++){
      var el = new Element("input", {type: 'hidden', value: newTags[i], id: 'video[new_friend_tags][]', name: 'video[new_friend_tags][]' });
      form.appendChild(el);
    }
    for(var i=0;i<delTags.length;i++){
      var el = new Element("input", {type: 'hidden', value: delTags[i], id: 'video[del_friend_tags][]', name: 'video[del_friend_tags][]' });
      form.appendChild(el);
    }
  },

  save: function(button, form){
    Iyxzone.disableButtonThree(button, '发布中..');
    if(this.validate()){
      this.prepare(form);
      form.submit();
    }else{
      Iyxzone.enableButtonThree(button, '保存');
    }
  },

  update: function(button, form){
    Iyxzone.disableButtonThree(button, '更新中..');
    if(this.validate()){
      this.prepare(form);
      form.submit();
    }else{
      Iyxzone.enableButtonThree(button, '更新');
    }
  }

});
