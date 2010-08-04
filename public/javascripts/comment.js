/**
 * TODO:
 * 点击document.body时候，能够触发hideForm事件
 */

Iyxzone.Comment = {
  version: '1.1',
  author: ['高侠鸿'],
  changeLog: '修正了wall message的一个bug',
  checkLength: function(field, max){
    var fieldID = field.id;
    var count = field.value.length;
    if(count > max){
      field.value = field.value.substr(0, max);
    }else{
      var wordsCountID = fieldID.gsub('comment_content_', '') + '_words_count';
      $(wordsCountID).innerHTML = count + '/' + max;
    }
  }
};

Object.extend(Iyxzone.Comment, {

  pluralize: function(str){
    if(str == 'status')
      return 'statuses';
    else
      return str + 's';
  },

  validate: function(content){
    if(content.value.length == 0){
      error('评论不能为空');
      return false;
    }
    if(content.value.length > 140){
      error('评论最多140个字节');
      return false;
    }
    return true;
  },

  showForm: function(commentableType, commentableID, login, recipientID){
    $('add_' + commentableType + '_comment_' + commentableID).hide();
    $(commentableType + '_comment_' + commentableID).show();
    $(commentableType + '_comment_recipient_' + commentableID).value = recipientID;
    $(commentableType + '_comment_content_' + commentableID).focus();
    if(login == null)
      $(commentableType + '_comment_content_' + commentableID).value = "";
    else
      $(commentableType + '_comment_content_' + commentableID).value = "回复" + login + "：";
  },

  hideForm: function(commentableType, commentableID, event){
    Event.stop(event);
    $(commentableType + '_comment_' + commentableID).hide();
    $('add_' + commentableType + '_comment_' + commentableID).show();
  },

  save: function(commentableType, commentableID, button, event){
    Event.stop(event);
    if(Iyxzone.Comment.validate($(commentableType + '_comment_content_' + commentableID))){
      new Ajax.Request('/comments', { 
        method: 'post',
        parameters: $(commentableType+'_comment_form_' + commentableID).serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '请等待..');
        },
        onComplete: function(){
          Iyxzone.enableButton(button, '发布');
          $(commentableType + '_comment_' + commentableID).hide();
          $('add_' + commentableType + '_comment_' + commentableID).show();
        }
      });
    }
  },

  set: function(commentableType, commentableID, login, commentorID){
    this.showForm(commentableType, commentableID, login, commentorID);
    Element.scrollTo(commentableType + '_comment_form_' + commentableID);
  },

  moreCommentsInFoldedBox: function(commentableType, commentableID, offset, limit, link){
    var div = link.up();
    
    if(offset < 1)
      offset = 1;
    if(limit < 0)
      limit = 0;
    
    new Ajax.Request('/comments',{
      method: 'get',
      parameters: {commentable_id: commentableID, commentable_type: commentableType, offset: offset, limit: limit},
      onLoading: function(){
        div.update('显示更多<img src="/images/small-ajax-loader.gif"/>');
      }.bind(this),
      onSuccess: function(transport){
        $(commentableType + '_comments_' + commentableID).update(transport.responseText);
        if(offset == 1){
          div.remove();
        }else{
          div.update('<a href="javascript:void(0)" onclick="Iyxzone.Comment.moreCommentsInFoldedBox(\'' + commentableType + '\', ' + commentableID + ', ' + (offset - limit) + ', ' + limit + ', $(this))">显示更多' + (offset - 1) + '条</a>');
        }
      }.bind(this)
    });
  },

  moreComments: function(commentableType, commentableID, offset, limit, link){
    if(offset < 0)
      offset = 0;
    if(limit < 0)
      limit = 0;

    var div = link.up();

    new Ajax.Request('/comments', {
      method: 'get',
      parameters: {commentable_id: commentableID, commentable_type: commentableType, offset: offset, limit: limit},
      onLoading: function(){
        div.update('显示较早评论<img src="/images/small-ajax-loader.gif"/>');
      }.bind(this),
      onSuccess: function(transport){
        $(commentableType + '_comments_' + commentableID).insert({top: transport.responseText});
        if(offset == 0){
          div.update('没有评论了');
        }else{
          div.update('<a href="javascript:void(0)" onclick="Iyxzone.Comment.moreComments(\'' + commentableType + '\', ' + commentableID + ', ' + (offset - limit) + ', ' + limit + ', $(this))">显示较早评论</a>');
        }
      }.bind(this)
    });
  },

  toggleBox: function(commentableType, commentableID, commentsCount){
    var box = $(commentableType + '_comment_box_' + commentableID);
    var link = $(commentableType + '_comment_link_' + commentableID);
    if(!box.visible()){
      Effect.BlindDown(box);
      if(link)
        link.update('收起回复')
    }else{
      Effect.BlindUp(box);
      if(link)
        link.update(commentsCount + '条回复')
    }
  }

});

Iyxzone.WallMessage = {
  version: '1.1',
  author: ['高侠鸿'],
  changeLog: ['修正了回复别人后，默认的收到评论的人没有恢复']
};

Object.extend(Iyxzone.WallMessage, {

  checkLength: function(field, max){
    var fieldID = field.id;
    var count = field.value.length;
    if(count > max){
      field.value = field.value.substr(0, max);
    }else{
      var wordsCountID = fieldID.gsub('message_content_', '') + '_words_count';
      $(wordsCountID).innerHTML = count + '/' + max;
    }
  },

  validate: function(content){
    if(content.value.length == 0){
      error('留言不能为空');
      return false;
    }
    if(content.value.length > 140){
      error('留言最多140个字节');
      return false;
    }
    return true; 
  },

  save: function(wallType, wallID, defaultRecipientID, button, form){
		if(this.validate($('wall_message_content_' + wallID))){
			new Ajax.Request('/wall_messages', {
        method: 'post',
        onLoading: function(){
          Iyxzone.disableButton(button, '请等待..');
        }.bind(this),
        onComplete: function(){
          Iyxzone.enableButton(button, '发布');
          $('comment_recipient_id').value = defaultRecipientID;
          $('comment_content').focus();
        }.bind(this),
				parameters: $(form).serialize()
      });
		} 
  },

  fetch: function(wallType, wallID){
    new Ajax.Request('/wall_messages?wall_type=' + wallType + '&wall_id=' + wallID, {
      method: 'get',
      onLoading: function(){
        $('comments').innerHTML = '<img src="images/loading.gif" />';
      },
      onSuccess: function(transport){
        $('comments').update( transport.responseText);
      }
    });
  },

  set: function(wallType, wallID, login, id){
    $('comment_recipient_id').value = id;
    $('wall_message_content_' + wallID).focus();
    $('wall_message_content_' + wallID).value = '回复' + login + '：';
  }

});
