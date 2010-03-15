Iyxzone.Event = {
  version: '1.0',
  author: ['高侠鸿'],
  Builder: {},
  Summary: {},
  ParticipantManager: {}
};

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

  save: function(event, button){
    Event.stop(event);
    if(this.validate(true)){
			Iyxzone.disableButton(button, '请等待..');
      var form = $('event_form');
      form.action = '/events';
      form.method = 'post';
      form.submit();
    }
  },

  update: function(eventID, event, button){
    Event.stop(event);
    if(this.validate(false)){
			Iyxzone.disableButton(button, '请等待..');
      var form = $('event_form');
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
    if($('event_character_id'))
      $('event_character_id').value = '';
    if($('is_guild_event'))
      $('is_guild_event').checked = false;
  }

});

Object.extend(Iyxzone.Event.Summary, {

  Attendance : {},

  Boss : {},

  Gear : {},

  Rule : {}

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
  
    setTimeout(this.save.bind(this), 20000);
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

  lateOnchange: function(characterID, checkbox){
    var info = this.summary.get(characterID);
    if(checkbox.checked){
      info.late = 1;
    }else{
      info.late = 0;
    }
    this.summary.set(characterID, info); 
  },

  selectCharacters: function(){
    $('friend-wrap').toggle();
  },

  addCharacters: function(){
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
            this.summary.set(id, {late: 0, complete: 100});
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
          var json = transport.responseText.evalJSON();
          if(json.errors){
            alert(json.errors);
          }else{
            var boss = json.boss;
            this.cancelBoss();
            var html = '<li><span><input type="checkbox" value=1 boss_id=' + boss.id + ' name="' + boss.name + '" reward=' + boss.reward + ' />' + boss.name + '-' + boss.reward + '</span></li>';
            Element.insert($$('ul.checkboxes')[0], {bottom: html});
            this.reset();
            Element.insert('bosses', {bottom: this.getBossHTML(boss.id, 1, boss.name, boss.reward)});
            this.summary.set(boss.id, {count: 1, name: boss.name, reward: boss.reward});
          }
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
    }

    setTimeout(this.save.bind(this), 20000);
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
    html += '<td><div style="position:relative;text-align:left;">';
    html += '<a href="javascript:void(0)" onclick="Iyxzone.Event.Summary.Gear.toggleCharacterList(' + id + ', this)">点击选择获得者</a>';
    html += '<div class="drop-box" style="position: absolute; left: 0pt; top: 40px; display: none;" character_id=""></div>';
    html += '</div></td>';
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

  toggleCharacterList: function(id, div){
    var list = div.next();
    if(list.visible()){
      list.hide();
      return;
    }
    var characterIDs = new Array();

    this.summary.keys().each(function(key){
      var gearID = key.substr(0, key.indexOf('_'));
      var characterID = key.substr(key.indexOf('_') + 1);
      if(gearID == id){
        characterIDs.push(characterID);
      }
    }.bind(this));
    
    var list = div.next();
    if(list.innerHTML == ''){
      list.innerHTML = $('gear_recipients').innerHTML;
    }
    var items = list.childElements();
    items.each(function(i){
      var characterID = i.readAttribute('character_id');
      if(characterIDs.include(characterID)){
        i.hide();
      }else{
        i.writeAttribute({gear_id: id});
        i.observe('click', this.selectCharacter.bindAsEventListener(this));
        i.show();
      }
    }.bind(this));

    list.show();
  },

  selectCharacter: function(mouseEvent){
    var a = Event.findElement(mouseEvent, 'a');
    
    var characterID = a.readAttribute('character_id');
    var gearID = a.readAttribute('gear_id');
    
    // some elements
    var list = a.up('div');
    var currentCharacter = list.previous();
    var characterTd = list.up('td');
    var countTd = characterTd.previous().previous();
    var delTd = characterTd.next();
    var tr = characterTd.up('tr');
    var oldCharacterID = list.readAttribute('character_id');
 
    if(oldCharacterID != ''){
      this.summary.unset(gearID + '_' + oldCharacterID);
    }

    if(characterID != ''){
      var count = countTd.childElements()[0].innerHTML;
      this.summary.set(gearID + '_' + characterID, {count: count});
    }

    if(characterID == ''){
      Element.replace(currentCharacter, "<a class='member-toggle' onclick='Iyxzone.Event.Summary.Gear.toggleCharacterList(" + gearID + ", this)' >" + "点击选择接收者" + "</a>");
      delTd.childElements()[0].writeAttribute('onclick', "Iyxzone.Event.Summary.Gear.remove(" + gearID + ", null, this)");
      countTd.childElements()[1].childElements()[0].writeAttribute('onblur', "Iyxzone.Event.Summary.Gear.updateCount(this, " + gearID + ", null)");
    }else{
      Element.replace(list.previous(), "<a class='member-toggle' onclick='Iyxzone.Event.Summary.Gear.toggleCharacterList(" + gearID + ", this)' >" + a.innerHTML + "</a>");
      delTd.childElements()[0].writeAttribute('onclick', "Iyxzone.Event.Summary.Gear.remove(" + gearID + "," + characterID + ", this)");
      countTd.childElements()[1].childElements()[0].writeAttribute('onblur', "Iyxzone.Event.Summary.Gear.updateCount(this, " + gearID + "," + characterID + ")");    
    }
  
    list.writeAttribute('character_id', characterID);
    tr.writeAttribute('id', 'gear_' + gearID + '_' + characterID);
    list.hide();
  },

  save: function(){
    var params = '';
    var values = this.summary.values();

    this.summary.each(function(pair){
      var key = pair.key;
      var gearID = key.substr(0, key.indexOf('_'));
      var characterID = key.substr(key.indexOf('_') + 1);
      var count = pair.value.count;
      params += "info[" + gearID + "_" + characterID + "][count]=" + count + "&";
    }.bind(this));

    new Ajax.Request('/events/' + this.eventID + '/summary/save?step=3&authenticity_token=' + encodeURIComponent(this.token), {
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
      var key = pair.key;
      var gearID = key.substr(0, key.indexOf('_'));
      var characterID = key.substr(key.indexOf('_') + 1);
      var count = pair.value.count;
      params += "info[" + gearID + "_" + characterID + "][count]=" + count + "&";
    }.bind(this));

    new Ajax.Request('/events/' + this.eventID + '/summary/next?step=3&authenticity_token=' + encodeURIComponent(this.token), {
      method: 'post',
      parameters: params
    });
  },

  prev: function(){
    var params = '';
    var values = this.summary.values();

    this.summary.each(function(pair){
      var key = pair.key;
      var gearID = key.substr(0, key.indexOf('_'));
      var characterID = key.substr(key.indexOf('_') + 1);
      var count = pair.value.count;
      params += "info[" + gearID + "_" + characterID + "][count]=" + count + "&";
    }.bind(this));

    new Ajax.Request('/events/' + this.eventID + '/summary/prev?step=3&authenticity_token=' + encodeURIComponent(this.token), {
      method: 'post',
      parameters: params
    });
  },

  newGear: function(){
    $('new_gear').hide();
    $('new_gear_name').show();
    $('gear_name').value = '输入装备名字';
    $('new_gear_cost').show();
    $('gear_cost').value = '输入装备所需积分';
    $('new_gear_submit').show();
  },

  cancelGear: function(){
    $('new_gear_name').hide();
    $('new_gear_cost').hide();
    $('new_gear_submit').hide();
    $('new_gear').show();
  },

  validateGear: function(){
    return true;
  },

  createGear: function(){
    if(this.validateGear()){
      new Ajax.Request('/guilds/' + this.guildID + '/gears?authenticity_token=' + encodeURIComponent(this.token), {
        method: 'post',
        parameters: 'gear[name]=' + $('gear_name').value + '&gear[cost]=' + $('gear_cost').value,
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.errors){
            alert(json.errors);
          }else{
            this.cancelGear();
            var gear = json.gear;
            var html = '<li><span><input type="checkbox" value=1 gear_id=' + gear.id + ' name="' + gear.name + '" cost=' + gear.cost + ' />' + gear.name + '-' + gear.cost + '</span></li>';
            Element.insert($$('ul.checkboxes')[0], {bottom: html});
            this.reset();
            Element.insert('gears', {bottom: this.getGearHTML(gear.id, 1, gear.name, gear.cost)});
          }
        }.bind(this)
      });
    }

  }  

});

Object.extend(Iyxzone.Event.Summary.Rule, {

  summary: new Hash(), // Rule id and recipient id to count

  eventID: null,

  guildID: null,

  token: null,

  load: function(eventID, guildID, token, ids, characterIDs, counts, reasons, outcomes){
    this.eventID = eventID;
    this.guildID = guildID;
    this.token = token;

    for(var i=0;i<ids.length;i++){
      this.summary.set(ids[i] + '_' + characterIDs[i], {reason: reasons[i], count: counts[i], outcome: outcomes[i]});
    }

    setTimeout(this.save.bind(this), 5000);
  },

  reset: function(){
    $$('input').each(function(input){
      if(input.type == 'checkbox' && input.readAttribute('character_id')){
        input.checked = false;
      }
    }.bind(this));
  },

  addCharacters: function(){
    var params = "";
    var characters = new Array();

    $$('input').each(function(e){
      if(e.type == 'checkbox' && e.checked){
        var id = e.readAttribute('character_id');
        var avatar = e.readAttribute('avatar');
        var name = e.readAttribute('name');
        Element.insert('rewards', {bottom: this.getRewardHTML(id, 1, name, avatar)});
      }
    }.bind(this));

    $('friend-wrap').hide();
    this.reset();
  },

  getRewardHTML: function(characterID, count, name, avatar){
    var html = '<tr class="jl-cutline" id="rule_' + '_' + characterID + '">';
    html += '<td class="tl"><div style="position:relative;text-align:left">';
    html += '<img src="/images/' + avatar + '" class="w-l" align="absmiddle"><span><strong>' + name + '</strong></span>';
    html += '</div></td>';
    html += '<td><div style="position:relative;text-align:left">';
    html += '<a onclick="Iyxzone.Event.Summary.Rule.toggleRuleList(' + characterID + ', this)" class="member-toggle">点击选择规定</a>';
    html += '<div class="drop-box" style="position: absolute; left: 0px; top: 0px; display:none" rule_id=""></div>';
    html += '</div></td>';
    html += '<td>';
    html += '<a onclick="Iyxzone.Event.Summary.Rule.editCount(this)">' + count + '</a>';
    html += '<div class="textfield" style="width: 40px; margin: 0 auto;display:none"><input type="text" value=' + count + ' onblur="Iyxzone.Event.Summary.Rule.updateCount(this, null, ' + characterID + ')"></div>';
    html += '</td>';
    html += '<td></td>';
    html += '<td><a href="javascript: void(0)" onclick="Iyxzone.Event.Summary.Rule.remove(null, ' + characterID + ', this)" class="icon-active" /></a></td>';
    html += '</tr>';
    return html;
  },

  toggleRuleList: function(id, div){
    var list = div.next();
    if(list.visible()){
      list.hide();
      return;
    }

    var ruleIDs = new Array();

    this.summary.keys().each(function(key){
      var ruleID = key.substr(0, key.indexOf('_'));
      var characterID = key.substr(key.indexOf('_') + 1);
      if(characterID == id){
        ruleIDs.push(ruleID);
      }
    }.bind(this));

    list.innerHTML = $('rule_selector').innerHTML;
    var items = list.childElements();
    items.each(function(i){
      var ruleID = i.readAttribute('rule_id');
      if(ruleIDs.include(ruleID)){
        i.hide();
      }else{
        i.writeAttribute({character_id: id});
        i.observe('click', this.selectRule.bindAsEventListener(this));
        i.show();
      }
    }.bind(this));

    list.show();    
  },

  selectRule: function(mouseEvent){
    var a = Event.findElement(mouseEvent, 'a');

    var characterID = a.readAttribute('character_id');
    var ruleID = a.readAttribute('rule_id');
    var outcome = a.readAttribute('outcome');

    // some elements
    var list = a.up('div');
    var currentRule = list.previous();
    var ruleTd = list.up('td');
    var countTd = ruleTd.next();
    var outcomeTd = ruleTd.next().next();
    var delTd = ruleTd.next().next().next();
    var tr = ruleTd.up('tr');
    var oldRuleID = list.readAttribute('rule_id');

    if(oldRuleID != ''){
      this.summary.unset(oldRuleID + '_' + characterID);
    }

    if(ruleID != ''){
      var count = countTd.childElements()[0].innerHTML;
      this.summary.set(ruleID + '_' + characterID, {count: count});
      alert(this.summary.keys());
    }

    if(ruleID == ''){
      Element.replace(currentRule, "<a class='member-toggle' onclick='Iyxzone.Event.Summary.Rule.toggleRuleList(" + characterID + ", this)' >" + "点击选择规则" + "</a>");
      delTd.childElements()[0].writeAttribute('onclick', "Iyxzone.Event.Summary.Rule.remove(null, " + characterID + ", this)");
      countTd.childElements()[1].childElements()[0].writeAttribute('onblur', "Iyxzone.Event.Summary.Rule.updateCount(this, null, " + characterID + ")");
    }else{
      Element.replace(currentRule, "<a class='member-toggle' onclick='Iyxzone.Event.Summary.Rule.toggleRuleList(" + characterID + ", this)' >" + a.innerHTML + "</a>");
      delTd.childElements()[0].writeAttribute('onclick', "Iyxzone.Event.Summary.Rule.remove(" + ruleID + "," + characterID + ", this)");
      countTd.childElements()[1].childElements()[0].writeAttribute('onblur', "Iyxzone.Event.Summary.Rule.updateCount(this, " + ruleID + "," + characterID + ")");
    }

    outcomeTd.innerHTML = outcome;
    list.writeAttribute('rule_id', ruleID);
    tr.writeAttribute('id', 'rule_' + ruleID + '_' + characterID);
    list.hide();
  },

  selectCharacters: function(){
    $('friend-wrap').toggle();
  },

  remove: function(ruleID, characterID, div){
    if(ruleID == null){
      div.up().up().remove();
    }else{
      this.summary.unset(ruleID + '_' + characterID);
      $('rule_' + ruleID + '_' + characterID).remove();
    }
  },

  editCount: function(div){
    div.hide();
    div.next().show();
  },

  updateCount: function(field, ruleID, characterID){
    var div = field.up();
    var row = div.up().up();
    div.previous().innerHTML = field.value;
    div.hide();
    div.previous().show();
    if(ruleID != null){
      var info = this.summary.get(ruleID + '_' + characterID);
      info.count = field.value;
      this.summary.set(ruleID + '_' + characterID, info);
    }
  },

  save: function(){
    var params = '';
    var values = this.summary.values();

    this.summary.each(function(pair){
      var key = pair.key;
      var ruleID = key.substr(0, key.indexOf('_'));
      var characterID = key.substr(key.indexOf('_') + 1);
      var count = pair.value.count;
      params += "info[" + ruleID + "_" + characterID + "][count]=" + count + "&";
    }.bind(this));

    new Ajax.Request('/events/' + this.eventID + '/summary/save?step=4&authenticity_token=' + encodeURIComponent(this.token), {
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
      var key = pair.key;
      var RuleID = key.substr(0, key.indexOf('_'));
      var characterID = key.substr(key.indexOf('_') + 1);
      var count = pair.value.count;
      params += "info[" + RuleID + "_" + characterID + "][count]=" + count + "&";
    }.bind(this));

    new Ajax.Request('/events/' + this.eventID + '/summary/next?step=4&authenticity_token=' + encodeURIComponent(this.token), {
      method: 'post',
      parameters: params
    });
  },

  prev: function(){
    var params = '';
    var values = this.summary.values();

    this.summary.each(function(pair){
      var key = pair.key;
      var RuleID = key.substr(0, key.indexOf('_'));
      var characterID = key.substr(key.indexOf('_') + 1);
      var count = pair.value.count;
      params += "info[" + RuleID + "_" + characterID + "][count]=" + count + "&";
    }.bind(this));

    new Ajax.Request('/events/' + this.eventID + '/summary/prev?step=4&authenticity_token=' + encodeURIComponent(this.token), {
      method: 'post',
      parameters: params
    });
  },

  newRule: function(){
    $('new_rule').hide();
    $('new_rule_reason').show();
    $('rule_reason').value = '输入原因';
    $('new_rule_outcome').show();
    $('rule_outcome').value = '输入赏罚';
    $('new_rule_submit').show();
  },

  cancelRule: function(){
    $('new_rule_reason').hide();
    $('new_rule_outcome').hide();
    $('new_rule_submit').hide();
    $('new_rule').show();
  },

  validateRule: function(){
    return true;
  },

  createRule: function(){
    if(this.validateRule()){
      new Ajax.Request('/guilds/' + this.guildID + '/rules?authenticity_token=' + encodeURIComponent(this.token), {
        method: 'post',
        parameters: 'rule[reason]=' + $('rule_reason').value + '&rule[outcome]=' + $('rule_outcome').value,
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.errors){
            alert(json.errors);
          }else{
            var rule = json.guild_rule;
            this.cancelRule();
            Element.insert('rule_selector', {bottom: "<a class='member-toggle' rule_id='" + rule.id + "' outcome=" + rule.outcome + "><span><strong>" + rule.reason + "</strong></span></a>"}); 
          }
        }.bind(this)
      });
    }

  }

});

