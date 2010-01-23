Iyxzone.Event = {
  version: '1.0',
  author: ['高侠鸿'],
  Builder: {}
};

Object.extend(Iyxzone.Event.Builder, {

  gameSelector: null, 

  validate: function(){
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

    var details = this.gameSelector.getDetails();
    var game = $('event_game_id');
    var server = $('event_game_server_id');
    var area = $('event_game_area_id');
    if(game.value == ''){
      error('游戏类别不能为空');
      return false;
    }
    if(!details.no_servers && server.value == ''){
      error('服务器不能为空');
      return false;
    }
    if(!details.no_areas && area.value == ''){
      error('服务区不能为空');
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

    return true;
  },

  save: function(){
    if(this.validate()){
      var form = $('event_form');
      form.action = '/events';
      form.submit();
    }
  },

  update: function(event){
    Event.stop(event);
    if(this.validate()){
      var form = $('event_form');
      form.submit();
    }
  }
  
});
