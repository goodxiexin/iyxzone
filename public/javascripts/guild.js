Iyxzone.Guild = {
  version: '1.0',
  author: ['高侠鸿'],
  Builder: {},
  Feeder: {}
};

Object.extend(Iyxzone.Guild.Builder, {

  validate: function(){
    if($('guild_name').value == ''){
      error('名字不能为空');
      return false;
    }
    if($('guild_game_id') && $('guild_game_id').value == ''){
      error('游戏类别不能为空');
      return false;
    }
    if($('guild_name').value.length >= 100){
      error('名字最长100个字符');
      return false;
    }
    if($('guild_description').value.length >= 1000){
      error('描述最多1000个字符');
      return false;
    }
    return true;
  },

  save: function(){
    if(this.validate()){
      var form = $('guild_form');
      form.action = '/guilds';
      form.method = 'post';
      form.submit();
    }
  },

  update: function(guildID){
    if(this.validate()){
      var form = $('guild_form');
      form.action = '/guilds/' + guildID;
      form.method = 'put';
      form.submit();
    }
  }

});

Object.extend(Iyxzone.Guild.Editor, {

});

Object.extend(Iyxzone.Guild.Feeder, {
  
  idx: 0,

  moreFeeds: function(guildID){
    // show loading page
    $('more_feed').innerHTML = '<img src="/images/loading.gif" />';

    // send ajax request
    new Ajax.Request('/guilds/' + guildID + '/more_feeds?idx=' + this.idx, {
      method: 'get',
      onSuccess: function(){
        this.idx++;
      }
    });
  }

});
