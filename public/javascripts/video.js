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

  save: function(button){
    if(this.validate()){
      var newTags = this.tagBuilder.getNewTags();
      for(var i=0;i<newTags.length;i++){
        var el = new Element("input", {type: 'hidden', value: newTags[i], id: 'video[friend_tags][]', name: 'video[friend_tags][]' });
        $('video_form').appendChild(el);
      }
      Iyxzone.disableButton(button, '等待...');
      $('video_form').submit();
    }
  },

  update: function(videoID, button){
    if(this.validate()){
      var newTags = this.tagBuilder.getNewTags();
      for(var i=0;i<newTags.length;i++){
        var el = new Element("input", {type: 'hidden', value: newTags[i], id: 'video[friend_tags][]', name: 'video[friend_tags][]' });
        $('video_form').appendChild(el);
      }
      Iyxzone.disableButton(button, '等待...');
      new Ajax.Request('/videos/'+videoID, {
				method: 'put',
				parameters: $('video_form').serialize(),
			});
    }
  },

});
