Iyxzone.Event = {

  version: '1.7',

  author: ['高侠鸿'],

  Builder: {},

  Invitation: {},

  Participation: {},

  ParticipantManager: {},

  Presentor: {},

  follow: function(name, eid){
    new Ajax.Request('/mini_topic_attentions', {
      method: 'post',
      parameters: {'name': name},
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      }.bind(this),
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('follow_event_' + eid).innerHTML = '<a onclick="Iyxzone.Event.unfollow(' + json.id + ', \'' + name + '\', ' + eid + '); return false;" href="#"><span class="i iNoFollow"></span>取消关注</a>';
        }else{
          error('发生错误');
        }
      }.bind(this)
    });

  },

  unfollow: function(id, name, eid){
    new Ajax.Request('/mini_topic_attentions/' + id, {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('follow_event_' + eid).update('<a onclick="Iyxzone.Event.follow(\'' + name + '\', ' + eid + '); return false;" href="#"><span class="i iFollow"></span>关注</a>');
        }else{
          error('发生错误');
        }
      }.bind(this)
    });
  }
};

// 一些在event show页面的操作
Object.extend(Iyxzone.Event.Presentor, {

  posterID: null,

  eventID: null,

  curTab: null,

  cache: new Hash(),

  init: function(eventID, posterID){
    this.eventID = eventID;
    this.posterID = posterID;
    this.cache.set('photo', $('presentation').innerHTML);
  },

  setTab: function(type){
    $('tab_photo').writeAttribute('class', 'fix unSelected');
    $('tab_wall').writeAttribute('class', 'fix unSelected');
    $('tab_' + type).writeAttribute('class', 'fix');
    this.curTab = type;
  },

  showPhotos: function(){
    if(this.curTab == 'photo')
      return;

    this.setTab('photo');

    var html = this.cache.get('photo');
    //一定存在
    if(html){
      $('presentation').innerHTML = html;
      return;
    }
  },

  showWall: function(){
    if(this.curTab == 'wall')
      return;

    this.setTab('wall');
    
    var html = this.cache.get('wall');
    if(html){
      $('presentation').innerHTML = html;
      return;
    }

    new Ajax.Request('/wall_messages/index_with_form', {
      method: 'get',
      parameters: {wall_id: this.eventID, wall_type: 'Event', recipient_id: this.posterID},
      onLoading: function(){
        $('presentation').innerHTML = '<div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div>';
        this.cache.set('wall', $('presentation').innerHTML);
      }.bind(this),
      onSuccess: function(transport){
        this.cache.set('wall', transport.responseText);
        if(this.curTab == 'wall'){
          $('presentation').innerHTML = transport.responseText;
        }
      }.bind(this)
    });   
  } 

});

Object.extend(Iyxzone.Event.ParticipantManager, {

  startObserving: function(field){
    this.field = field;
    this.timer = setTimeout(this.search.bind(this), 300);
  },

  stopObserving: function(field){
    clearTimeout(this.timer);
  },

  search: function(){
    var val = this.field.value;
    var ul = $('participations');
    ul.childElements().each(function(li){
      var pinyin = li.readAttribute('pinyin');
      var name = li.readAttribute('name');
      if(pinyin.include(val) || name.include(val)){
        li.show();
      }else{
        li.hide();
      }
    }.bind(this));
    this.timer = setTimeout(this.search.bind(this), 300);
  }

});



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
    var startTimeJS = Date.parseFormattedString(startTime.value);
    var endTimeJS = Date.parseFormattedString(endTime.value);
    if(onCreate && startTimeJS < currentTimeJS){
      error('开始时间不能比现在早');
      return false;
    }
    if(endTimeJS <= currentTimeJS){
      error('结束时间不能比现在早');
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

  save: function(form, button){
    Iyxzone.disableButton(button, '请等待..');
    if(this.validate(true)){
      new Ajax.Request(Iyxzone.URL.createEvent(), {
        method: 'post',
        parameters: form.serialize(),
        onLoading: function(){
          Iyxzone.changeCursor('wait');
        },
        onComplete: function(){
          Iyxzone.changeCursor('default');
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.newEventInvitation(json.id);
          }else{
            error("保存的时候发生错误，请稍后再试");
            Iyxzone.enableButton(button, '提交');
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButton(button, '提交');
    } 
  },

  update: function(eventID, form, button){
    Iyxzone.disableButton(button, '请等待..');
    if(this.validate(false)){
      new Ajax.Request(Iyxzone.URL.updateEvent(eventID), {
        method: 'post',
        parameters: form.serialize(),
        onLoading: function(){
          Iyxzone.changeCursor('wait');
        },
        onComplete: function(){
          Iyxzone.changeCursor('default');
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.showEvent(eventID);
          }else{
            error("保存的时候发生错误，请稍后再试");
            Iyxzone.enableButton(button, '提交');
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButton(button, '提交');
    }
  },

  userCharactersHTML: null,

  checkGuild: function(checkBox){
    if(checkBox.checked){
      this.userCharactersHTML = $('event_character_id').innerHTML;
      $('event_guild_selector').show();
      $('event_guild_id').value = '';
      $('event_character_id').update( "<option value=''>---</option>");
    }else{
      $('event_guild_id').value = '';
      $('event_guild_selector').hide();
      $('event_character_id').update( this.userCharactersHTML);
    }
  },

  guildOnChange: function(guildID){
    if(guildID == ''){
      $('event_character_id').update( "<option value=''>---</option>");
      return;
    }

    new Ajax.Request('/characters?guild_id=' + guildID, {
      method: 'get',
      onSuccess: function(transport){
        var characters = transport.responseText.evalJSON();
        var selector = new Element('select');
        $('event_character_id').update( "<option value=''>---</option>");
        for(var i=0;i <characters.length;i++){
          var option = new Element('option', {value: characters[i].game_character.id}).update(characters[i].game_character.name);
          Element.insert($('event_character_id'), {bottom: option});
        }
      }.bind(this)
    });
  },

  reset: function(){
    if($('event_character_id'))
      $('event_character_id').value = '';
    if($('is_guild_event'))
      $('is_guild_event').checked = false;
  }

});

Iyxzone.Event.Invitation = {
  
  Builder: {},

  // 在所有的邀请页面接受请求
  accept1: function(invitationID, eventID, status, btn){
    var btn1 = $('ei_btn1_' + invitationID);
    var btn2 = $('ei_btn2_' + invitationID);
    var btn3 = $('ei_btn3_' + invitationID);

    new Ajax.Request(Iyxzone.URL.acceptEventInvitation(eventID, invitationID), {
      method: 'put',
      parameters: {'status': status},
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        btn1.disabled = 'disabled';
        btn2.disabled = 'disabled';
        btn3.disabled = 'disabled';        
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        btn1.disabled = '';
        btn2.disabled = '';
        btn3.disabled = '';
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('ei_' + invitationID).innerHTML = '<div class="hd"><span class="icon-invitation"></span>你已经加入了活动，快去看看<a href="' + Iyxzone.URL.showEvent(eventID) + '"><strong>活动主页</strong></a></div>'; 
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  decline1: function(invitationID, eventID, link, at){
    var btn1 = $('ei_btn1_' + invitationID);
    var btn2 = $('ei_btn2_' + invitationID);
    var btn3 = $('ei_btn3_' + invitationID);

    new Ajax.Request(Iyxzone.URL.declineEventInvitation(eventID, invitationID), {
      method: 'delete',
      parameters: {'status': status},
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        btn1.disabled = 'disabled';
        btn2.disabled = 'disabled';
        btn3.disabled = 'disabled';        
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        Iyxzone.Facebox.close();
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('ei_' + invitationID).innerHTML = '<strong class="nowrap"><span class="icon-success"></span>已经拒绝邀请！</strong>';
          setTimeout(function(){new Effect.Fade('event_invitation_' + invitationID);}, 2000);
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  // 在所有的邀请页面接受请求
  accept2: function(invitationID, eventID, status, btn){
    var btn1 = $('ei_btn1');
    var btn2 = $('ei_btn2');
    var btn3 = $('ei_btn3');

    new Ajax.Request(Iyxzone.URL.acceptEventInvitation(eventID, invitationID), {
      method: 'put',
      parameters: {'status': status},
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        btn1.disabled = 'disabled';
        btn2.disabled = 'disabled';
        btn3.disabled = 'disabled';        
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        btn1.disabled = '';
        btn2.disabled = '';
        btn3.disabled = '';
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showEvent(eventID);
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  decline2: function(invitationID, eventID, link, at){
    var btn1 = $('ei_btn1');
    var btn2 = $('ei_btn2');
    var btn3 = $('ei_btn3');

    new Ajax.Request(Iyxzone.URL.declineEventInvitation(eventID, invitationID), {
      method: 'delete',
      parameters: {'status': status},
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        btn1.disabled = 'disabled';
        btn2.disabled = 'disabled';
        btn3.disabled = 'disabled';        
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        Iyxzone.Facebox.close();
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showEvent(eventID);
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  }

}

Object.extend(Iyxzone.Event.Invitation.Builder, {

  selected: new Hash(),

  onClick: function(td, val){
    if(this.selected.get(val)){
      td.setStyle({background: 'white'});
      this.selected.unset(val);
    }else{
      this.selected.set(val, td)
      td.setStyle({background: '#DEFEBB'});
    } 
  },

  submit: function(button, eventID){
    if(this.selected.size() == 0){
      error('你必须至少邀请一个游戏角色');
    }else{
      Iyxzone.disableButton(button,'请等待..');

      // construct url
      var url = Iyxzone.URL.createEventInvitation(eventID);
      var params = "";
      this.selected.each(function(pair){
        if(params != "")
          params += "&";
        params += 'values[]=' + pair.key;
      });
      
      new Ajax.Request(Iyxzone.URL.createEventInvitation(eventID), {
        method: 'post',
        parameters: params,
        onLoading: function(){},
        onComplete: function(){},
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.showEvent(eventID);
          }else if(json.code == 0){
            error("发生错误，请稍后再试试");
            Iyxzone.enableButton(button, '确定'); 
          }
        }.bind(this)
      });
    }
  },

  reset: function(){
    this.selected = new Hash();
  },

  search: function(){
    var val = this.field.value;
    var ul = $('invitee_list');
    var els = ul.childElements();

    els.each(function(li){
      var pinyin = li.readAttribute('pinyin');
      var name = li.readAttribute('name');
      if(name.include(val) || pinyin.include(val)){
        li.show();
      }else{
        li.hide();
      }
    }.bind(this));

    this.timer = setTimeout(this.search.bind(this), 300);
  },

  startObservingInput: function(field){
    this.field = field;
    this.timer = setTimeout(this.search.bind(this), 300);
  },

  stopObservingInput: function(){
    clearTimeout(this.timer);
  }


});

Object.extend(Iyxzone.Event.Participation, {

  update: function(participationID, eventID, form, btn){
    new Ajax.Request(Iyxzone.URL.updateParticipation(eventID, participationID), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.disableButton(btn, '发送中');
      },
      onComplete: function(){
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showEvent(eventID);
        }else{
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  }

});
