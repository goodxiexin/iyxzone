VideoBuilder = Class.create({
  
  initialize: function(tag_builder){
    this.tag_builder = tag_builder;
  },

  valid: function(){
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

  save: function(){
    if(this.valid()){
      var new_tags = this.tag_builder.get_new_tags();
      for(var i=0;i<new_tags.length;i++){
        var el = new Element("input", {type: 'hidden', value: new_tags[i], id: 'video[tags][]', name: 'video[tags][]' });
        $('video_form').appendChild(el);
      }
      $('video_form').submit();
    } 
  }

});
