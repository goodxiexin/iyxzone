Iyxzone.Chat = Class.create({
  version: '1.0',
  author: ['高侠鸿']
});

Object.extend(Iyxzone.Chat, {

  userID: null, // 当前用户

  myLogin: null,

  myIcon: null,
  
  friendID: null, // 当前和谁在聊

  onlineFriendIDs: new Hash(), // 当前在线好友, friendID => div 

  unreadMessages: new Hash(), // friendID => messages, unreadMessages.keys()是 onlineFriendIDs 的一个子集

  blinkFriendID: null, // 当前在闪烁的是哪个好友的消息 

  blinkFriendIcon: null, // 当前在闪烁的好友的头像

  blankIcon: null,

  blinkTimer: null,

  // toggle 在线好友  
  toggleOnline: function(link){
    if($('chat-list').visible()){
      link.up().up().writeAttribute('class', '')
    }else{
      link.up().up().writeAttribute('class', 'im-expand')
    }

    $('chat-list').toggle();
  },

  // 显示聊天栏
  showBar: function(){
    $('tiny-chat-bar').hide();
    $('chat-bar').show();
  },

  hideBar: function(){
    $('tiny-chat-bar').show();
    $('chat-bar').hide();
  },

  // 闪烁头像
  toggleIcon: function(){
    var target = $('tiny-im-icon');

    if(target.innerHTML == '' || target.down('img').src.include('/images/blank.gif')){
      target.update( this.blinkFriendIcon);
    }else{
      target.update( '<img src="/images/blank.gif" class="left w-l" width=20 height=20 />');
    }

    target = $('im-icon');

    if(target.down('img').src.include('/images/blank.gif')){
      target.update( this.blinkFriendIcon);
    }else{
      target.update( '<img src="/images/blank.gif" class="left w-l" width=20 height=20 />');
    }

    this.blinkTimer = setTimeout(this.toggleIcon.bind(this), 300);
  },

  // 根据未读的信息，设置当前闪烁的头像
  setBlink: function(){
    if(this.blinkFriendID == null && this.unreadMessages.keys().length != 0){
      this.blinkFriendID = this.unreadMessages.keys()[0];
      this.blinkFriendIcon = '<img src="' + this.unreadMessages.get(this.blinkFriendID).avatar + '" class="left w-l" width=20 height=20/>';
      this.blinkTimer = setTimeout(this.toggleIcon.bind(this), 300);

      $('tiny-im-icon').observe('click', this.showUnreadMessages.bindAsEventListener(this));
      $('im-icon').observe('click', this.showUnreadMessages.bindAsEventListener(this));
    }
  },

  // 先取消当前闪烁的头像，再根据未读的信息，设置新的闪烁头像
  resetBlink: function(){
    clearTimeout(this.blinkTimer);
    
    $('tiny-im-icon').stopObserving('click');
    $('im-icon').stopObserving('click');
    $('tiny-im-icon').innerHTML = '';
    $('im-icon').update( this.myIcon);

    this.blinkFriendID = null;
    this.setBlink();
  },

  // 在 view 里初始化的函数
  set: function(onlineFriends, friendIDs, infos, token, myInfo){
    this.token = token;
    this.myIcon = '<img src="' + myInfo.avatar + '" class="left w-l" width=20 height=20/>';
    this.myLogin = myInfo.login;
    for(var i=0;i<infos.length;i++){
      this.unreadMessages.set(friendIDs[i], infos[i]);
    }
    for(var i=0;i<onlineFriends.length;i++){
      this.newOnlineFriend(onlineFriends[i]);
    }
    this.blankIcon = new Image();
    this.blankIcon.src = '/images/blank.gif';
    this.setBlink();
  },

  // 搜索
  search: function(){
    var key = this.searchField.value;
    $('chat-list').childElements().each(function(li){
      if(key == '' || li.readAttribute('pinyin').indexOf(key) >= 0 || li.readAttribute('login').indexOf(key) >= 0){
        li.show();
      }else{
        li.hide();
      }
    }.bind(this));
    this.searchTimer = setTimeout(this.search.bind(this) , 200); 
  },

  startObservingSearch: function(field){
    this.searchField = field;
    this.searchTimer = setTimeout(this.search.bind(this) , 200); 
  },

  stopObservingSearch: function(){
    clearTimeout(this.searchTimer);
  },

  buildChatForm: function(friendID, friendLogin){
    var div = new Element('div', {"id": 'chat-form-' + friendID, "class": 'im-dialog', "left": '500px', "top": '100px'});
    div.hide();
    
    var html = '';
    html += '<div class="head s_clear"><span class="left">与 ' + friendLogin + ' 交谈</span><a class="z-close right" href="#" onclick="Iyxzone.Chat.hideForm(' + friendID + ')"></a></div>';
    html += '<div class="con"><div class="im-dlg-show" id="chat-form-content-' + friendID + '"></div></div>';
    html += '<div class="foot">';
    html += '<div class="im-dlg-send s_clear">';
    html += '<textarea class="left" id="message-content-' + friendID + '" name=""></textarea>';
    html += '<div class="right">';
    html += '<button type="submit" class="right btn-v2 w-l" onclick=\'Iyxzone.Chat.sendMessage(' + friendID + ', "' + friendLogin + '", this, event);\'>确定</button><a href="javascript:void(0)" onclick="Iyxzone.Emotion.Manager.toggleFaces(this, $(\'message-content-' + friendID + '\'), event);" class="icon-face right w-l"></a><p class="rows">字数：<span id="im_words_count_' + friendID + '">0/200</span></p>';
    html += '</div></div>';
    html += '<div class="im-dlg-log">';
    html += '<h2><a class="" href="javascript:void(0)" onclick="Iyxzone.Chat.toggleHistory(' + friendID + ', this);">聊天记录<span/></a></h2>';
    html += '<div style="display: none;" class="im-dlg-show rows" id="chat-history-' + friendID + '"></div>';
    html += '</div></div></div>';

    $(div).update( html);
    document.body.appendChild(div);

    new Iyxzone.limitedTextField($('message-content-' + friendID), 200, $('im_words_count_' + friendID));

    return div;
  },

  // 关闭聊天窗口
  hideForm: function(friendID){
    $('chat-form-' + friendID).hide();
  },

  // 构造消息的html
  buildMessageHTML: function(login, message){
    var html = '';

    if(login == this.myLogin)
      html += '<h4 class="own">' + login + "(" + message.created_at + ")</h4>";
    else
      html += '<h4>' + login + "(" + message.created_at + ")</h4>";

    html += '<p>' + message.content + "</p>";
    return html;
  },

  // 告诉服务器这条消息读过了
  markRead: function(messages){
    var params = '';
    for(var i = 0;i < messages.length; i++)
      params += 'ids[]=' + messages[i].id + '&';

    new Ajax.Request('/messages/read?authenticity_token=' + encodeURIComponent(this.token), {
      method: 'put',
      parameters: params
    });
  },

  showChatForm: function(friendID, friendLogin){
    var form = $('chat-form-' + friendID);
    var info = this.unreadMessages.unset(friendID);
    
    if(form == null){
      form = this.buildChatForm(friendID, friendLogin);
      form.setStyle({'left': '500px', 'top': '100px'});
      form.show();
      new Draggable('chat-form-' + friendID);
    }else{
      form.show();
    }

    form.observe('click', function(event){
      Event.stop(event);
    });

    if(info){
      info.messages.each(function(m){
        Element.insert('chat-form-content-' + friendID, {bottom: this.buildMessageHTML(friendLogin, m, false)});
      }.bind(this));
    }

    if(this.blinkFriendID == friendID){
      this.resetBlink();
    }

    // send ajax request 
    if(info){
      this.markRead(info.messages);
    }

  },

  showUnreadMessages: function(){
    if(this.blinkFriendID == null){
      return;
    }

    this.showChatForm(this.blinkFriendID, this.unreadMessages.get(this.blinkFriendID).login); 
  },

  // 显示 聊天历史
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
          $(cont).update( '<image src="/images/loading.gif" />');
        },
        onSuccess: function(transport){
          $(cont).update( transport.responseText);
        }.bind(this)
      });
    }
  },

  // 发送消息
  sendMessage: function(friendID, friendLogin, button, event){
    Event.stop(event);
    new Ajax.Request('/messages?friend_id=' + friendID + "&authenticity_token=" + encodeURIComponent(this.token) + "&message[content]=" + $('message-content-' + friendID).value, {
      method: 'post',
      onLoading: function(){
        $('message-content-' + friendID).clear();        
      },
      onSuccess: function(transport){
        var message = transport.responseText.evalJSON();
        Element.insert('chat-form-content-' + friendID, {bottom: this.buildMessageHTML(this.myLogin, message)});
      }.bind(this)
    });
  },

  // 接收 消息
  recvMessage: function(message, senderInfo){
    var friendID = senderInfo.id;
    var avatar = senderInfo.avatar;
    var login = senderInfo.login;
    var form = $('chat-form-' + friendID);
   
    // set data
    if(form == null || (form && !form.visible())){
      var info = this.unreadMessages.get(friendID);
      if(info){
        info.messages.push(message);
        this.unreadMessages.set(friendID, info);
      }else{
        this.unreadMessages.set(friendID, {messages: [message], login: login, avatar: avatar});
      }
      this.setBlink();
    }else{
      Element.insert('chat-form-content-' + friendID, {bottom: this.buildMessageHTML(login, message)});
      
      // send ajax request
      this.markRead([message]);
    }
  },

  modifyCounter: function(by){
    var h = $('online_friends_count').innerHTML;
    var count = parseInt(h.substr(1, h.length - 1));
    $('online_friends_count').update('[' + (count + by) + ']');

    h= $('tiny_online_friends_count').innerHTML;
    count = parseInt(h.substr(1, h.length - 1));
    $('tiny_online_friends_count').update('[' + (count + by) + ']');
  },

  // 新的好友上线
  newOnlineFriend: function(info){
    var friendID = info.id;
    if(this.onlineFriendIDs.keys().include(friendID)){
      return;
    }else{
      var dd = new Element('dd', {pinyin: info.pinyin, login: info.login});
      $(dd).update( '<a href="javascript: void(0)" ondblclick="Iyxzone.Chat.showChatForm(' + info.id + ', \'' + info.login + '\');"><img src="' + info.avatar + '" class="left w-l" width=20 height=20 /><span class="left">' + info.login  + '</span></a>');
      $('chat-list').appendChild(dd);
      this.onlineFriendIDs.set(friendID, dd);

      this.modifyCounter(1);
    }
  },

  // 好友下线
  friendOffline: function(friendID){
    var dd = this.onlineFriendIDs.unset(friendID);
    if(dd){
      dd.remove();
      this.modifyCounter(-1);
    }      
  },

  init: function(){
    $(document.body).observe('click', function(){
      this.hideBar();
    }.bind(this));
    $('chat-bar').observe('click', function(event){
      Event.stop(event);
    });
    $('tiny-chat-bar').observe('click', function(event){
      Event.stop(event);
    });
  }

});
