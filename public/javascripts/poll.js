Iyxzone.Poll = {
  version: '1.0',

  author: ['高侠鸿'],

  drawPercentBar: function(width, percent, color, votes) {
    var pixels = width * (percent / 100);
    document.write("<td class='percent'><span class='percent01'><span class='"+color+"' style='width: " + percent + "%'><span/></span></span></td>");
    document.write("<td class='status'>" + votes + "(" + percent + "%)</td>");
  },

  Builder: {}
};

// vote
Object.extend(Iyxzone.Poll, {

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
  },

  vote: function(button, form, pollID){
    Iyxzone.disableButton(button, '发送中');

    // validate
    var inputs = $$('input');
    var selected = 0;
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'checkbox' && inputs[i].checked && inputs[i].readAttribute('id') != 'anonymous')
        selected++;
    }
    if(selected == 0){
      tip('你至少需要选1项');
      Iyxzone.enableButton(button, '提交');
    }

    new Ajax.Request(Iyxzone.URL.createVote(pollID), {
      method: 'post',
      parameters: $(form).serialize(),
      onLoading: function(){},
      onComplete: function(){},
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showPoll(pollID);
        }else if(json.code == 0){
          error("发生错误，请稍后在试试");
        }
      }.bind(this)
    });
  }

});

// add answer
Object.extend(Iyxzone.Poll, {

  addAnswer: function(button, form, pollID){
    Iyxzone.disableButton(button, '发送中');

    // validate
    // TODO

    new Ajax.Request(Iyxzone.URL.createPollAnswer(pollID), {
      method: 'post',
      parameters: $(form).serialize(),
      onLoading: function(){},
      onComplete: function(){},
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showPoll(pollID);
        }else if(json.code == 0){
          error("发生错误，请稍后在试试");
          Iyxzone.enableButton(button, '完成');
        }
      }.bind(this)
    });
  }

});

// edit deadline and explanation
Object.extend(Iyxzone.Poll, {

  updatePoll: function(button, form, pollID){
    Iyxzone.disableButton(button, '发送中');
    new Ajax.Request(Iyxzone.URL.updatePoll(pollID), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){},
      onComplete: function(){},
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showPoll(pollID);
        }else if(json.code == 0){
          error("发生错误，请稍后在试试");
          Iyxzone.enableButton(button, '完成');
        }
      }.bind(this)
    });
  }

});

// delete poll
Object.extend(Iyxzone.Poll, {

  deletePoll: function(userID, pollID){
    new Ajax.Request(Iyxzone.URL.deletePoll(pollID), {
      method: 'delete',
      onLoading: function(){
      },
      onComplete: function(){
        Iyxzone.Facebox.close();
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.listPoll(userID);
        }else if(json.code == 0){
          error('发生错误，请稍后再试试');
        }
      }.bind(this)
    });
  },

  confirmDeletingPoll: function(userID, pollID){
    Iyxzone.Facebox.confirmWithCallback("你确定要删除这个投票吗", null, null, function(){
      this.deletePoll(userID, pollID);
    }.bind(this)); 
  }

});

// create poll
Object.extend(Iyxzone.Poll.Builder, {

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
    
    var cnt = this.countAnswers(false);
    if(cnt < 2){
      error('至少要有2个选项');
      return false;
    }
    
    var endDate = $('poll_deadline');
    if($('poll_no_deadline_false').checked && endDate.value == ''){
      error('结束日期不能为空');
      return false;
    }

    var currentTimeJS = new Date().getTime();
    var endTimeJS = Date.parseFormattedString(endDate.value);
    if(endTimeJS <= currentTimeJS){
      error('结束时间不对');
      return false;
    }

    return true;
  },

  save: function(button, form){
    Iyxzone.disableButton(button, '请等待..');
    if(this.validate()){
      new Ajax.Request(Iyxzone.URL.createPoll(), {
        method: 'post',
        parameters: $(form).serialize(),
        onLoading: function(){
        },
        onComplete: function(){
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.showPoll(json.id);
          }else if(json.code == 0){
            error("发生错误，请稍后再试试");
            Iyxzone.enableButton(button, '发布投票');
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButton(button, '发布投票');
    }
  },

  toggleDescriptionInput: function(){
    $('descriptions').toggle();
  },

  toggleExplanation: function(){
    $('explanation').toggle();
  },

  toggleAdvancedOptions: function(){
    $('advanced_options').toggle();
  },
  
  showEndDate: function(){
    $('deadline_select').show();
  },

  hideEndDate: function(){
    $('deadline_select').hide();
  },

  countAnswers: function(allowEmpty){
    var inputs = $$('input');
    var cnt = 0;
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'text' && inputs[i].readAttribute('id') == 'poll_answers__description'){
        if(allowEmpty)
          cnt++;
        else if(inputs[i].value != '')
          cnt++;
      }
    }
    return cnt;
  },
  
  removeAnswer: function(link){
    var cnt = this.countAnswers(true);
    if(cnt <= 2){
      error('至少要有2个选项，不能再删除了');
      return;
    }
    $($(link).up()).remove();
    var maxSelector = $('max_multiple_select').childElements()[0];
    var originValue = maxSelector.value;
    tmpHTML = '';
    if(originValue > cnt - 1){
      originValue = cnt - 1;
    }
    for(var i=0;i<cnt-1;i++){
      var html = '<option value=' + (i+1);
      if(i+1 == originValue){
        html += ' selected="selected"';
      }
      html += '>' + (i+1) + '项</option>';
      tmpHTML += html;
    }
		$(maxSelector).update(tmpHTML);
  },

  incrementMaxSelector: function(){
    var cnt = this.countAnswers(true);
    var maxSelector = $('max_multiple_select').childElements()[0];
    var originValue = maxSelector.value;
		tmphtml = '';
    for(var i=0;i<cnt;i++){
      var html = '<option value="' + (i+1) +'"';
      if(i+1 == originValue){
        html += ' selected="selected"';
      }
      html += '>' + (i+1) + '项</option>';
      tmphtml += html;
    }
		$(maxSelector).update(tmphtml);
  }

});
