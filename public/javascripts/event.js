Iyxzone.Event = {
  version: '1.0',
  author: ['高侠鸿'],
  Builder: {},
  Summary: {}
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

Object.extend(Iyxzone.Event.Summary, {

  Attendance : {},

  Boss : {},

  Gear : {},

  Reward : {}

});

Object.extend(Iyxzone.Event.Summary.Attendance, {

  summary: new Hash(), // character_id => { late => boolean, completes => percentage}

  eventID: null,

  token: null,

  load: function(eventID, token, characterIDs, lates, completes){
    this.eventID = eventID;
    this.token = token;
    for(var i=0;i<characterIDs.length;i++)
      this.summary.set(characterIDs[i], {late: lates[i], complete: completes[i]});
  },

  reset: function(){
    $$('input').each(function(input){
      if(input.type == 'checkbox' && input.readAttribute('character_id') != null){
        input.checked = false;
        if(this.summary.keys().include(input.readAttribute('character_id'))){
          input.checked = true;
        }
      }
    }.bind(this));

    this.summary.keys().each(function(id){
      $('late_' + id).checked = this.summary.get(id).late;
    }.bind(this));

    setTimeout(this.save.bind(this), 20000);
  },

  incComplete: function(characterID){
    var el = $('complete_' + characterID + '_bar');
    if(el == null)
      return;
 
    var num = this.summary.get(characterID).complete;
    if(num < 100){
      num += 10;
    }
    
    $('complete_' + characterID + '_bar').setStyle({width: num + '%'});
    $('complete_' + characterID + '_number').update(num + '%');
    
    var info = this.summary.get(characterID);
    info.complete = num;
    this.summary.set(characterID, info);
  },

  decComplete: function(characterID){
    var el = $('complete_' + characterID + '_bar');
    if(el == null)
      return;

    var num = this.summary.get(characterID).complete;
    if(num > 0){
      num -= 10;
    }

    $('complete_' + characterID + '_bar').setStyle({width: num + '%'});
    $('complete_' + characterID + '_number').update(num + '%');
  
    var info = this.summary.get(characterID);
    info.complete = num;
    this.summary.set(characterID, info);
  },

  lateOnchange: function(characterID){
    var info = this.summary.get(characterID);
    info.late = !info.late;
    this.summary.set(characterID, info); 
  },

  selectCharacters: function(){
    $('friend-wrap').toggle();
  },

  resetCharacters: function(){
    var newCharacterIds = [];
    var delCharacterIds = [];
    var characterIds = [];
    var params;
    $$('input').each(function(e){
      if(e.type == 'checkbox' && e.readAttribute('character_id') && e.checked)
        characterIds.push(e.readAttribute('character_id'));
    });

    this.summary.keys().each(function(k){
      if(!characterIds.include(k))
        delCharacterIds.push(k);
    }.bind(this));

    characterIds.each(function(k){
      if(!this.summary.keys().include(k))
        newCharacterIds.push(k)
    }.bind(this));

    delCharacterIds.each(function(id){
      this.summary.unset(id);
      $('character_' + id).remove();
      $('friend-wrap').hide();
    }.bind(this));

    params = "";

    newCharacterIds.each(function(id){
      params += "ids[]=" + id + "&";
    });

    if(params != ""){
      new Ajax.Updater('attendants', '/user/events/summary/new_attendant?step=1&event_id=' + this.eventID, {
        method: 'get',
        insertion: 'bottom',
        parameters: params,
        onSuccess: function(transport){
          newCharacterIds.each(function(id){
            this.summary.set(id, {late: false, complete: 100});
          }.bind(this));
          $('friend-wrap').hide();
        }.bind(this)
      });
    }
  },

  save: function(){
    var params = '';

    this.summary.each(function(pair){
      params += 'characters[' + pair.key + '][late]=' + pair.value.late + '&characters[' + pair.key + '][complete]=' + pair.value.complete + '&';
    });

    new Ajax.Request('/events/' + this.eventID + '/summary/save?step=1&authenticity_token=' + encodeURIComponent(this.token), {
      method: 'post',
      parameters: params,
      onSuccess: function(){
        setTimeout(this.save.bind(this), 20000);
      }.bind(this)
    });
  },

  remove: function(characterID){
    this.summary.unset(characterID);
    $('character_' + characterID).remove();
    $$('input').each(function(input){
      if(input.type == 'checkbox' && input.readAttribute('character_id') != null){
        input.checked = false;
        if(this.summary.keys().include(input.readAttribute('character_id'))){
          input.checked = true;
        }
      }
    }.bind(this));
  },

  next: function(){
    var params = '';
    this.summary.each(function(pair){
      params += 'characters[' + pair.key + '][late]=' + pair.value.late + '&characters[' + pair.key + '][complete]=' + pair.value.complete + '&';
    });
    new Ajax.Request('/events/' + this.eventID + '/summary/next?step=1&authenticity_token=' + encodeURIComponent(this.token), {
      method: 'post',
      parameters: params
    });
  }

});

Object.extend(Iyxzone.Event.Summary.Boss, {

  summary: new Hash(), // boss id to count

  eventID: null,

  guildID: null,

  token: null,

  load: function(eventID, guildID, token, ids, counts, names, rewards){
    this.eventID = eventID;
    this.guildID = guildID;
    this.token = token;

    for(var i=0;i<ids.length;i++){
      this.summary.set(ids[i], {name: names[i], count: counts[i], reward: rewards[i]});
      Element.insert('bosses', {bottom: this.getBossHTML(ids[i], counts[i], names[i], rewards[i])});
    }

    setTimeout(this.save.bind(this), 20000);
  },

  reset: function(){
    $$('input').each(function(input){
      if(input.type == 'checkbox' && input.readAttribute('boss_id')){
        input.checked = false;
      }
    }.bind(this));
  },

  selectBosses: function(){
    $('friend-wrap').toggle();
  },

  addBosses: function(){
    var params = "";
    var bosses = new Array();    
    
    $$('input').each(function(e){
      if(e.type == 'checkbox' && e.checked){
        var id = e.readAttribute('boss_id');
        var name = e.readAttribute('name');
        var reward = e.readAttribute('reward');
  
        if(this.summary.keys().include(id)){
          var info = this.summary.get(id);
          info.count++;
          this.summary.set(id, info);
          var td = $('boss_' + id).childElements()[1];
          var a = td.childElements()[0];
          a.innerHTML = info.count;
        }else{
          Element.insert('bosses', {bottom: this.getBossHTML(id, 1, name, reward)});
          this.summary.set(id, {count: 1, name: name, reward: reward});
        }
      }
    }.bind(this));

    $('friend-wrap').hide();
    this.reset();
  },

  getBossHTML: function(id, count, name, reward){
    var html = '';
    html += '<tr class="jl-cutline" id="boss_' + id + '">';
    html += '<td class="tl">' + name + '</td>';
    html += '<td>';
    html += '<a onclick="Iyxzone.Event.Summary.Boss.editCount(this)">' + count + '</a>';
    html += '<div class="textfield" style="width: 80px; margin: 0 auto;display:none"><input type="text" value=' + count + ' onblur="Iyxzone.Event.Summary.Boss.updateCount(this, ' + id + ')"></div>';
    html += '</td>';
    html += '<td>' + reward + '</td>';
    html += '<td><a href="javascript:void(0)" onclick="Iyxzone.Event.Summary.Boss.remove(' + id + ')" class="icon-active"></a></td>';
    html += '</tr>';
    return html;
  },

  remove: function(bossID){
    this.summary.unset(bossID);
    $('boss_' + bossID).remove();
  },

  save: function(){
    var params = '';
    var values = this.summary.values();

    this.summary.each(function(pair){
      var id = pair.key;
      var count = pair.value.count;
      params += "bosses[" + id + "][count]=" + count + "&";
    }.bind(this));

    new Ajax.Request('/events/' + this.eventID + '/summary/save?step=2&authenticity_token=' + encodeURIComponent(this.token), {
      method: 'post',
      parameters: params,
      onSuccess: function(transport){
        setTimeout(this.save.bind(this), 20000);
      }.bind(this)
    });
  },

  next: function(){
    var params = '';
    var values = this.summary.values();

    this.summary.each(function(pair){
      var id = pair.key;
      var count = pair.value.count;
      params += "bosses[" + id + "][count]=" + count + "&";
    }.bind(this));

    new Ajax.Request('/events/' + this.eventID + '/summary/next?step=2&authenticity_token=' + encodeURIComponent(this.token), {
      method: 'post',
      parameters: params
    });
  },

  prev: function(){
    var params = '';
    var values = this.summary.values();

    this.summary.each(function(pair){
      var id = pair.key;
      var count = pair.value.count;
      params += "bosses[" + id + "][count]=" + count + "&";
    }.bind(this));

    new Ajax.Request('/events/' + this.eventID + '/summary/prev?step=2&authenticity_token=' + encodeURIComponent(this.token), {
      method: 'post',
      parameters: params
    });
  },

  editCount: function(div){
    div.hide();
    div.next().show();
  },

  updateCount: function(field, bossID){
    var div = field.up();
    var row = div.up().up();
    div.previous().innerHTML = field.value;
    div.hide();
    div.previous().show();
    var info = this.summary.get(bossID);
    info.count = field.value;
    this.summary.set(bossID, info);
  },

  newBoss: function(){
    $('new_boss').hide();
    $('new_boss_name').show();
    $('boss_name').value = '输入BOSS名字';
    $('new_boss_reward').show();
    $('boss_reward').value = '输入BOSS分值';
    $('new_boss_submit').show();
  },

  cancelBoss: function(){
    $('new_boss_name').hide();
    $('new_boss_reward').hide();
    $('new_boss_submit').hide();
    $('new_boss').show();
  },
 
  validateBoss: function(){
    if($('boss_name').value == ''){
      error('必须输入名字');
      return false;
    }
    if($('boss_reward').value == ''){
      error('必须输入奖励');
      return false;
    }else{
      var reward = parseInt($('boss_reward'));
      if(reward == null){
        error('奖励必须是整数');
        return false;
      }else if(reward <= 0){
        error('奖励必须是正数');
        return false;
      }
    }

    return true;
  },

  createBoss: function(){
    if(this.validateBoss()){
      new Ajax.Request('/guilds/' + this.guildID + '/bosses?authenticity_token=' + encodeURIComponent(this.token), {
        method: 'post',
        parameters: 'boss[name]=' + $('boss_name').value + '&boss[reward]=' + $('boss_reward').value,
        onSuccess: function(transport){
          this.cancelBoss();
          var boss = transport.responseText.evalJSON().boss;
          var html = '<li><span><input type="checkbox" value=1 boss_id=' + boss.id + ' name="' + boss.name + '" reward=' + boss.reward + ' />' + boss.name + '-' + boss.reward + '</span></li>';
          Element.insert($$('ul.checkboxes')[0], {bottom: html});
          this.reset();
          Element.insert('bosses', {bottom: this.getBossHTML(boss.id, 1, boss.name, boss.reward)});
          this.summary.set(boss.id, {count: 1, name: boss.name, reward: boss.reward});
        }.bind(this)
      });
    }
  }

});

Object.extend(Iyxzone.Event.Summary.Gear, {

  summary: new Hash(), // gear id and recipient id to count

  eventID: null,

  guildID: null,

  token: null,

  load: function(eventID, guildID, token, ids, characterIDs, counts, names, costs){
    this.eventID = eventID;
    this.guildID = guildID;
    this.token = token;

    for(var i=0;i<ids.length;i++){
      this.summary.set(ids[i] + "_" + characterIDs[i], {name: names[i], count: counts[i], cost: costs[i]});
      Element.insert('gears', {bottom: this.getGearHTML(ids[i], characterIDs[i], counts[i], names[i], costs[i])});
    }

    //setTimeout(this.save.bind(this), 20000);
  },

  reset: function(){
    $$('input').each(function(input){
      if(input.type == 'checkbox' && input.readAttribute('gear_id')){
        input.checked = false;
      }
    }.bind(this));
  },

  selectGears: function(){
    $('friend-wrap').toggle();
  },  

  addGears: function(){
    var params = "";
    var gears = new Array();

    $$('input').each(function(e){
      if(e.type == 'checkbox' && e.checked){
        var id = e.readAttribute('gear_id');
        var name = e.readAttribute('name');
        var cost = e.readAttribute('cost');
    
        Element.insert('gears', {bottom: this.getGearHTML(id, 1, name, cost)});
      }
    }.bind(this));

    $('friend-wrap').hide();
    this.reset();
  },

  getGearHTML: function(id, count, name, cost){
    var html = '';
    html += '<tr class="jl-cutline" id="gear_' + id + '">';
    html += '<td class="tl">' + name + '</td>';
    html += '<td>';
    html += '<a onclick="Iyxzone.Event.Summary.Gear.editCount(this)">' + count + '</a>';
    html += '<div class="textfield" style="width: 80px; margin: 0 auto;display:none"><input type="text" value=' + count + ' onblur="Iyxzone.Event.Summary.Gear.updateCount(this, ' + id + ', null)"></div>';
    html += '</td>';
    html += '<td>' + cost + '</td>';
    html += '<td><a href="javascript:void(0)" onclick="Iyxzone.Event.Summary.Gear.showCharacterList(' + id + ', this)">点击选择获得者</a></td>';
    html += '<td><a href="javascript:void(0)" onclick="Iyxzone.Event.Summary.Gear.remove(' + id + ', null, this)" class="icon-active"></a></td>';
    html += '</tr>';
    return html;
  },

  editCount: function(div){
    div.hide();
    div.next().show();
  },

  updateCount: function(field, id, characterID){
    var div = field.up();
    var row = div.up().up();
    div.previous().innerHTML = field.value;
    div.hide();
    div.previous().show();
    if(characterID != null){
      var info = this.summary.get(id + '_' + characterID);
      info.count = field.value;
      this.summary.set(id + '_' + characterID, info);
    }
  },

  remove: function(id, characterID, div){
    this.summary.unset(id + '_' + characterID);
    if(characterID == null)
      div.up().up().remove();
    else
      $('gear_' + id + '_' + characterID).remove();
  },

  showCharacterList: function(id, div){
    var characterIDs = new Array();

    this.summary.keys().each(function(key){
      var gearID = key.substr(0, key.indexOf('_'));
      var characterID = key.substr(key.indexOf('_') + 1);
      if(gearID == id){
        characterIDs.push(characterID);
      }
    }.bind(this));

    var list = $('gear_recipients').clonechildElements();
    list.each(function(a){
      var characterID = a.readAttribute('character_id');
      if(characterIDs.include(characterID)){
        a.hide();
      }else{
        a.writeAttribute({gear_id: id});
        a.observe('click', this.selectCharacter.bindAsEventListener(this));
        a.show();
      }
    }.bind(this));

    $('gear_recipients').show();
  },

  selectCharacter: function(mouseEvent){
    var a = mouseEvent.target;
    var characterID = a.readAttribute('character_id');
    var gearID = a.readAttribute('gear_id');
    var key = gearID + '_' + characterID;
    var info = this.summery.get(key);

    if(info){
      this.summary.set(key, {count: info.count});
    }else{
      var count = a.up().up().previous().previous().childElements()[0].innerHTML;
      alert(count);
      this.summary.set(key, {count: count});
    }

    $('gear_recipients').hide();
  },

});

Object.extend(Iyxzone.Event.Summary.Reward, {

});

