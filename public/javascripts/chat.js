Iyxzone.Chat = Class.create({
  version: '1.0',
  author: ['高侠鸿']
});

Object.extend(Iyxzone.Chat, {

  friendID: null, // 当前和谁在聊

  unreadMessages: new Hash(), // friendID => messages

  blinkFriendID: null, // 当前在闪烁的是哪个好友的消息 

  blinkTimer: null,

  myIcon: null,

  search: function(key){
    $('chat-list').childElements().each(function(li){
      if(key == '' || li.readAttribute('pinyin').indexOf(key) >= 0 || li.readAttribute('login').indexOf(key) >= 0){
        li.show();
      }else{
        li.hide();
      }
    }.bind(this));
  },

  buildForm: function(friendID, friendLogin){
    var div = new Element('div', {"id": 'chat-form-' + friendID, "class": 'im-dialog', "left": '500px', "top": '100px'});
    div.hide();
    
    var html = '';
    html += '<div class="head s_clear"><span class="left">与 ' + friendLogin + ' 交谈</span><a class="z-close right" href="#" onclick="Iyxzone.Chat.hideForm(' + friendID + ')"></a></div>';
    html += '<div class="con"><div class="im-dlg-show" id="chat-form-content-' + friendID + '"></div></div>';
    html += '<div class="foot">';
    html += '<div class="im-dlg-send s_clear">';
    html += '<textarea class="left" id="message-content-' + friendID + '" name=""></textarea>';
    html += '<div class="right">';
    html += '<button type="submit" class="right btn-v2 w-l" onclick=\'Iyxzone.Chat.sendMessage(' + friendID + ', "' + friendLogin + '", this, event);\'>确定</button><a href="javascript:void(0)" onclick="Iyxzone.Emotion.Manager.toggleFaces(this, $(\'message-content-' + friendID + '\'));" class="icon-face right w-l"></a><p class="rows">字数：<span id="im_words_count_' + friendID + '">0/200</span></p>';
    html += '</div></div>';
    html += '<div class="im-dlg-log">';
    html += '<h2><a class="" href="javascript:void(0)" onclick="Iyxzone.Chat.toggleHistory(' + friendID + ', this);">聊天记录<span/></a></h2>';
    html += '<div style="display: none;" class="im-dlg-show rows" id="chat-history-' + friendID + '"></div>';
    html += '</div></div></div>';

    div.innerHTML = html;
    document.body.appendChild(div);

    new Iyxzone.limitedTextField($('message-content-' + friendID), 200, $('im_words_count_' + friendID));

    return div;
  },

  buildMessageHTML: function(friendLogin, message){
    var html = '';
    html += '<h4>' + friendLogin + "(" + message.created_at + ")</h4>";
    html += '<p>' + message.content + "</p>";
    return html;
  },

  markRead: function(messages){
    var params = '';
    for(var i = 0;i < messages.length; i++)
      params += 'ids[]=' + messages[i].id + '&';

    new Ajax.Request('/messages/read?authenticity_token=' + encodeURIComponent(this.token), {
      method: 'put',
      parameters: params
    });
  },

  set: function(friendIDs, infos, token){
    this.token = token;
    for(var i=0;i<infos.length;i++){
      this.unreadMessages.set(friendIDs[i], infos[i]);
    }
    if(this.unreadMessages.keys().length != 0){
      this.blinkFriendID = this.unreadMessages.keys()[0];
      var info = this.unreadMessages.get(this.blinkFriendID);
      this.blinkTimer = setTimeout(this.toggleIcon.bind(this), 300);
    }
    $('im-icon').observe('click', this.showUnreadMessages.bindAsEventListener(this));
  },

  showForm: function(friendID, friendLogin){
    var form = $('chat-form-' + friendID);
    var info = this.unreadMessages.unset(friendID);
    
    if(form == null){
      form = this.buildForm(friendID, friendLogin);
      form.setStyle({left: '500px', top: '100px'});
      form.show();
      new Draggable('chat-form-' + friendID);
    }else{
      form.show();
    }

    if(info){
      info.messages.each(function(m){
        Element.insert('chat-form-content-' + friendID, {bottom: this.buildMessageHTML(friendLogin, m)});
      }.bind(this));
    }

    if(this.blinkFriendID == friendID){
      clearTimeout(this.blinkTimer);
      $('im-icon').innerHTML = this.myIcon;

      this.blinkFriendID = null;
      if(this.unreadMessages.keys().length != 0){
        this.blinkFriendID = this.unreadMessages.keys()[0];
        this.blinkTimer = setTimeout(this.toggleIcon.bind(this), 300);
      }
    }

    // send ajax request 
    if(info){
      this.markRead(info.messages);
    }

  },

  hideForm: function(friendID){
    $('chat-form-' + friendID).hide();
  },

  toggleIcon: function(){
    if($('im-icon').down('img').src.include('/images/blank.gif')){
      $('im-icon').innerHTML = this.myIcon;
    }else{
      this.myIcon = $('im-icon').innerHTML;
      $('im-icon').innerHTML = '<img src="/images/blank.gif" class="left w-l" width=20 height=20 />';
    }
    this.blinkTimer = setTimeout(this.toggleIcon.bind(this), 300);
  },

  recvMessage: function(message, friendLogin, friendID){
    var form = $('chat-form-' + friendID);
    
    // set data
    if(form == null || (form && !form.visible())){
      if(this.blinkFriendID == null){
        this.blinkFriendID = friendID;
        this.blinkTimer = setTimeout(this.toggleIcon.bind(this), 300);
      }

      var info = this.unreadMessages.get(friendID);
      if(info){
        info.messages.push(message);
        this.unreadMessages.set(friendID, info);
      }else{
        this.unreadMessages.set(friendID, {messages: [message], login: friendLogin});
      }
    }else{
      Element.insert('chat-form-content-' + friendID, {bottom: this.buildMessageHTML(friendLogin, message)});
      
      // send ajax request
      this.markRead([message]);
    }
  },

  showUnreadMessages: function(){
    if(this.blinkFriendID == null){
      return;
    }
    
    this.showForm(this.blinkFriendID, this.unreadMessages.get(this.blinkFriendID).login); 
  },

  toggleHistory: function(friendID, link){
    var cont = $('chat-history-' + friendID);

    if(cont.visible()){
      cont.hide();
      link.writeAttribute("class", '');
    }else{
      cont.show();
      link.writeAttribute("class", 'show');
      if(cont.innerHTML != '')
        return;

      // send ajax
      new Ajax.Request('/messages?friend_id=' + friendID, {
        method: 'get',
        onLoading: function(){
          cont.innerHTML = '<image src="/images/loading.gif" />';
        },
        onSuccess: function(transport){
          cont.innerHTML = transport.responseText;
        }.bind(this)
      });
    }
  },

  sendMessage: function(friendID, friendLogin, button, event){
    Event.stop(event);
    new Ajax.Request('/messages?friend_id=' + friendID + "&authenticity_token=" + encodeURIComponent(this.token) + "&message[content]=" + $('message-content-' + friendID).value, {
      method: 'post',
      onLoading: function(){
        $('message-content-' + friendID).clear();        
      },
      onSuccess: function(transport){
        var message = transport.responseText.evalJSON();
        Element.insert('chat-form-content-' + friendID, {bottom: this.buildMessageHTML(friendLogin, message)});
      }.bind(this)
    });
  },

  toggleOnline: function(link){
    if($('chat-list').visible()){
      $(link.up()).up().writeAttribute("class", '');
    }else{
      $(link.up()).up().writeAttribute("class", 'im-expand');
    }

    $('chat-list').toggle();
  }

});
