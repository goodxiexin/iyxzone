Iyxzone.Event = {
  version: '1.0',
  author: ['高侠鸿'],
  Builder: {}
};

Object.extend(Iyxzone.Event.Builder, {

  gameSelector: null, 

  validate: function(onCreate){
    var title = $('event_title');
    if(title.value == ''){
      error('标题不能为空');
      return false;
    }
    if(title.value.length > 100){
      error('标题太长，最长100个字符');
      return false;
    }

    var description = $('event_description');
    if(description.value == ''){
      error('描述不能为空');
      return false;
    }
    if(description.value.length > 10000){
      error('描述最长10000个字符');
      return false;
    }

    var startTime = $('event_start_time');
    var endTime = $('event_end_time');
    if(startTime.value == ''){
      error('开始时间不能为空');
      return false;
    }
    if(endTime.value == ''){
      error('结束时间不能为空');
      return false;
    }

    var currentTimeJS = new Date().getTime();
    var startTimeJS = new Date(startTime.value).getTime();
    var endTimeJS = new Date(endTime.value).getTime();
    if(startTimeJS < currentTimeJS){
      error('开始时间不能比现在早');
      return false;
    }
    if(endTimeJS <= startTimeJS){
      error('结束时间不能比开始时间早');
      return false;
    }

    if(onCreate){
      var is_guild_event = $('is_guild_event').checked;
      if(is_guild_event){
        var guild_id = $('event_guild_id').value;
        if(guild_id == ''){
          error('工会活动必须选择工会');
          return false;
        }
      }
      
      var character_id = $('event_character_id').value;
      if(character_id == ''){
        error('游戏角色必须选择');
        return false
      }
    }

    return true;
  },

  save: function(event){
    Event.stop(event);
    if(this.validate(true)){
      var form = $('event_form');
      form.action = '/events';
      form.method = 'post';
      form.submit();
    }
  },

  update: function(eventID, event){
    Event.stop(event);
    if(this.validate(false)){
      var form = $('event_form');
      form.action = '/events/' + eventID;
      form.method = 'put';
      form.submit();
    }
  },

  userCharactersHTML: null,

  checkGuild: function(checkBox){
    if(checkBox.checked){
      this.userCharactersHTML = $('event_character_id').innerHTML;
      $('event_guild_selector').show();
      $('event_guild_id').value = '';
      $('event_character_id').innerHTML = "<option value=''>---</option>";
    }else{
      $('event_guild_id').value = '';
      $('event_guild_selector').hide();
      $('event_character_id').innerHTML = this.userCharactersHTML;
    }
  },

  guildOnChange: function(guildID){
    if(guildID == ''){
      $('event_character_id').innerHTML = "<option value=''>---</option>";
      return;
    }

    new Ajax.Request('/guilds/' + guildID + '/characters', {
      method: 'get',
      onSuccess: function(transport){
        var characters = transport.responseText.evalJSON();
        var selector = new Element('select');
        $('event_character_id').innerHTML = "<option value=''>---</option>";
        for(var i=0;i <characters.length;i++){
          var option = new Element('option', {value: characters[i].game_character.id}).update(characters[i].game_character.name);
          Element.insert($('event_character_id'), {bottom: option});
        }
      }.bind(this)
    });
  },

  reset: function(){
    $('event_character_id').value = '';
    $('is_guild_event').checked = false;
  }

});
