Iyxzone.Chat = {
  version: '1.0',
  author: ['高侠鸿']
};

Object.extend(Iyxzone.Chat, {

  friendID: null,

  buildForm: function(friendID, token){
    var div = new Element('div', {id: 'chat-form-' + friendID, style: 'border: 1px solid black; padding: 10px; display:none'});

    var html = '';
    html += "<div id='chat-history-" + friendID + "'></div>";
    html += "<div><textarea type='text' id='message-content-" + friendID + "' rows=4 cols=50 value='' ></textarea></div>";
    html += "<div><button onclick='Iyxzone.Chat.sendMessage(" + friendID + ", this, event, \"" + token + "\");'>提交</button><button onclick='Iyxzone.Chat.hideForm(" + friendID + ")'>关闭</button></div>";
 
    div.innerHTML = html;

    document.body.appendChild(div);

    return div;
  },

  buildMessageHTML: function(message){
    var html = '';
    html += message.poster_login + "(" + message.created_at + "): " + message.content + "<br/>";
    return html;
  },

  fetchMessages: function(friendID){
    new Ajax.Request('/messages?friend_id=' + friendID, {
      method: 'get',
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        json.each(function(m){
          Element.insert('chat-history-' + friendID, {bottom: this.buildMessageHTML(m)});
        }.bind(this));
      }.bind(this)
    });
  },

  showForm: function(friendID, token){
    var form = $('chat-form-' + friendID);

    if(form == null){
      form = this.buildForm(friendID, token);
      form.show();
      new Draggable('chat-form-' + friendID);
      this.fetchMessages(friendID);
    }else{
      form.show();
    }
  },

  hideForm: function(friendID){
    $('chat-form-' + friendID).hide();
  },

  insertMessage: function(message, friendID, token){
    var form = $('chat-form-' + friendID);
    
    if(form == null){
      form = this.buildForm(friendID, token);
      form.show();
      new Draggable('chat-form-' + friendID);
      this.fetchMessages(friendID);
    }else{
      form.show(); 
      Element.insert('chat-history-' + friendID, {bottom: this.buildMessageHTML(message)});
    }
  },

  sendMessage: function(friendID, button, event, token){
    Event.stop(event);
    new Ajax.Request('/messages?friend_id=' + friendID + "&authenticity_token=" + encodeURIComponent(token) + "&message[content]=" + $('message-content-' + friendID).value, {
      method: 'post',
      onSuccess: function(transport){
        var message = transport.responseText.evalJSON();
        Element.insert('chat-history-' + friendID, {bottom: this.buildMessageHTML(message)});
        $('message-content-' + friendID).clear();
      }.bind(this)
    });
  }

});
