Iyxzone.Poll = {
  version: '1.0',

  author: ['高侠鸿'],

  drawPercentBar: function(width, percent, color, background) {
    var pixels = width * (percent / 100);
    if(!background){ 
      background = "none"; 
    }
    document.write("<div style=\"position: relative; line-height: 1em; background-color: "
                   + background + "; border: 1px solid black; width: "
                   + width + "px\">");
    document.write("<div style=\"height: 1.5em; width: " + pixels + "px; background-color: "
                  + color + ";\"></div>");
    document.write("<div style=\"position: absolute; text-align: center; padding-top: .25em; width: "
                   + width + "px; top: 0; left: 0\">" + percent + "%</div>");
    document.write("</div>");
  },

  checkMultipleSelection: function(max, checkbox){
    var inputs = $$('input');
    var selected = 0;
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'checkbox' && inputs[i].checked && inputs[i].readAttribute('id') != 'anonymous')
        selected++;
    }
    if(selected > max){
      tip('你最多只能选' + max + '项');
      checkbox.checked = false;
    }
  }
};


Iyxzone.Poll.Builder = {

  validate: function(){
    var game_id = $('poll_game_id');
    if(game_id.value == ''){
      error('游戏类别不能为空');
      return false;
    }

    var name = $('poll_name');
    if(name.value == ''){
      error('标题不能为空');
      return false;
    }
    if(name.value.length > 100){
      error('标题最长100个字符');
      return false;
    }

    var description = $('poll_description');
    if(description.value.length > 5000){
      error('描述最长5000个字符');
      return false;
    }

    var privilege = $('poll_privilege');
    if(privilege.value == ''){
      error('权限不能为空');
      return false;
    }

    var inputs = $$('input');
    var cnt = 0;
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'text' && inputs[i].readAttribute('id') == 'poll_answers__description' && inputs[i].value != ''){
        cnt++;
      }
    }
    if(cnt < 2){
      error('至少要有2个选项');
      return false;
    }

    var endDate = $('poll_end_date');
    if(endDate.value == ''){
      error('结束日期不能为空');
      return false;
    }

    var currentTimeJS = new Date().getTime();
    var endTimeJS = new Date(endDate.value).getTime();
    if(endTimeJS <= currentTimeJS){
      error('结束时间不对');
      return false;
    }

    return true;
  },

  save: function(){
    if(this.validate()){
      var form = $('poll_form');
      form.action = '/polls';
      form.submit();
    }
  },

  toggleDescriptionInput: function(){
    $('description').toggle();
  },

  toggleExplanation: function(){
    $('explanation').toggle();
  },

  removeAnswer: function(link){
    $(link).up('.poll_answer').remove();
  }

};

