PollBuilder = Class.create({

  initialize: function(){
    this.form = $('poll_form');
    this.answers = $('poll_answers');
  },

  answer_input_html: function(){
    var html = "<div class='poll_answer'>";
    html += '<label for="">选项</label>';
    html += '<input id="answers__description" type="text" size="30" name="answers[][description]"/>';
    html += '<a onclick="poll_builder.remove_answer(this)" href="#">delete</a>';
    html += '</div>';
    return html;
  },

  valid: function(){
    if($('poll_game_id').value == ''){
      error('游戏类别不能为空');
      return false;
    }
    if($('poll_name').value == ''){
      error('标题不能为空');
      return false;
    }
    if($('poll_name').value.length > 100){
      error('标题最长100个字符');
      return false;
    }
    if($('poll_description').value.length > 5000){
      error('描述最长5000个字符');
      return false;
    }
    if($('poll_privilege').value == ''){
      error('权限不能为空');
      return false;
    }
    var inputs = $$('input');
    var cnt = 0;
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'text' && inputs[i].readAttribute('id') == 'answers__description' && inputs[i].value != ''){
        cnt++;
      }
    }
    if(cnt < 2){
      error('至少要有2个选项');
      return false;
    }
    if($('poll_end_date').value == ''){
      error('结束日期不能为空'); 
      return false;
    }
    var current_time = new Date().getTime();
    var end_time = new Date($('poll_end_date').value).getTime();
    if(end_time <= current_time){
      error('结束时间不对');
      return false;
    }
    return true;
  },

  save: function(){
    if(this.valid()){
      this.form.action = '/polls';
      this.form.submit();
    }
  }

});

function validate_multiple_selection(max, this_checkbox){
  var inputs = $$('input');
  var selected = 0;
  for(var i=0;i<inputs.length;i++){
    if(inputs[i].type == 'checkbox' && inputs[i].checked && inputs[i].readAttribute('id') != 'anonymous')
      selected++;
  }
  if(selected > max){
    alert('你最多只能选' + max + '项');
    this_checkbox.checked = false;
  }
}

function drawPercentBar(width, percent, color, background) { 
  var pixels = width * (percent / 100); 
  if (!background) { background = "none"; }
    
  document.write("<div style=\"position: relative; line-height: 1em; background-color: " 
                   + background + "; border: 1px solid black; width: " 
                   + width + "px\">"); 
  document.write("<div style=\"height: 1.5em; width: " + pixels + "px; background-color: "
                  + color + ";\"></div>"); 
  document.write("<div style=\"position: absolute; text-align: center; padding-top: .25em; width: " 
                   + width + "px; top: 0; left: 0\">" + percent + "%</div>"); 

  document.write("</div>"); 
}
