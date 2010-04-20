Iyxzone.News = {
  version: '1.0',
  author: ['李玉山'],
  Builder: {}
};

Object.extend(Iyxzone.News.Builder, {

  editor:null,

  validateTextNews: function() {
    if ($('news_title').value == '') {
      error("请填写标题")
      return false;
    }
    if ($('news_title').length > 300) {
      error("标题最长为300个字节")
      return false;
    }
    if ($('news_data').value == '') {
      error("请填写内容")
      return false;
    }
    if ($('news_data').length > 10000) {
      error("内容最长为10000个字节")
      return false;
    }
    if ($('news_game_id').value == '') {
      error("请选择与新闻相关的游戏")
      return false;
    }
    return true;
  },

  validateVideoNews: function() {
    if ($('news_title').value == '') {
      error("请填写标题")
      return false;
    }
    if ($('news_title').length > 300) {
      error("标题最长为300个字节")
      return false;
    }
    if ($('news_video_url').value == '') {
      error("请填写视频url")
      return false;
    }
    if ($('news_game_id').value == '') {
      error("请选择与新闻相关的游戏")
      return false;
    }
    return true;
  },

  prepare: function(form) {
    for(var i=0; i<this.editor.nicInstances.length; i++) {
      this.editor.nicInstances[i].saveContent();
    }
    this.parameters = $(form).serialize();
  },

  saveTextNews: function(button, form){
    Iyxzone.disableButtonThree(button, '发布中..');
    if(this.validateTextNews()) {
      this.prepare(form);
      new Ajax.Request('/admin/news', {
        method: 'post',
        parameters: this.parameters
      });
    }else{
      Iyxzone.enableButtonThree(button, '发布');
    }
  },

  updateTextNews: function(button, newsID, form){
    Iyxzone.disableButtonThree(button, '修改中..')
    if (this.validateTextNews()) {
      this.prepare(form);
      new Ajax.Request('/admin/news/' + newsID, {
        method: 'put',
        parameters: this.parameters
      });
    }else{
      Iyxzone.enableButtonThree(button, '修改');
    }
  },

  saveVideoNews: function(button, form){
    Iyxzone.disableButtonThree(button, '发布中..');
    if(this.validateVideoNews()) {
      new Ajax.Request('/admin/news', {
        method: 'post',
        parameters: $(form).serialize(),
      });
    }else{
      Iyxzone.enableButtonThree(button, '发布');
    }
  },

  updateVideoNews: function(button, newsID, form){
    Iyxzone.disableButtonThree(button, '修改中..');
    if(this.validateVideoNews()) {
      new Ajax.Request('/admin/news/' + newsID, {
        method: 'put',
        parameters: $(form).serialize(),
      });
    }else{
      Iyxzone.enableButtonThree(button, '修改');
    }
  },

  expand: function(data){
    $('news-data').update(data);
    $('news-expand').hide();
    $('news-hide').show();
  },

  hide: function(data){
    $('news-data').update(data);
    $('news-expand').show();
    $('news-hide').show();
  },

  init: function(textAreaID, token, albumInfos){
    this.editor = new nicEditor().panelInstance(textAreaID);
    nicEditors.albums = albumInfos;
    nicEditors.authenticity_token = token;
  }

});
