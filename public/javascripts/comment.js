/**
 * TODO:
 * 点击document.body时候，能够触发hideForm事件
 */

Iyxzone.Comment = {
  version: '1.0',
  author: ['高侠鸿']
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

  showForm: function(commentableType, commentableID, login){
    $('add_' + commentableType + '_comment_' + commentableID).hide();
    $(commentableType + '_comment_' + commentableID).show();
    if(login != null)
      $(commentableType + '_comment_content_' + commentableID).value = "回复" + login + ":";
    $(commentableType + '_comment_content_' + commentableID).focus();
  },

  hideForm: function(commentableType, commentableID){
    $(commentableType + '_comment_' + commentableID).hide();
    $('add_' + commentableType + '_comment_' + commentableID).show();
  },

  save: function(commentableType, commentableID, button){
    if(Iyxzone.Comment.validate($(commentableType + '_comment_content_' + commentableID))){
      new Ajax.Request('/comments?commentable_id=' + commentableID + '&commentable_type=' + commentableType, {
        method: 'post',
        parameters: $(commentableType+'_comment_form_' + commentableID).serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '等待');
        },
        onComplete: function(){
          Iyxzone.enableButton(button, '发布');
        }
      });
    }
  },

  set: function(commentableType, commentableID, login, commentorID){
    $(commentableType + '_comment_content_' + commentableID).value = "回复" + login + ":";
    $(commentableType + '_comment_recipient_' + commentableID).value = commentorID;
    $('add_' + commentableType + '_comment_' + commentableID).hide();
    $(commentableType + '_comment_' + commentableID).show();
    $(commentableType + '_comment_content_' + commentableID).focus();
    window.scrollTo(0, $(commentableType + '_comment_content_' + commentableID).positionedOffset().top);
  },

  more: function(commentableType, commentableID, link){
    link.innerHTML = '<img src="/images/loading.gif" />';
    new Ajax.Request('/comments?commentable_id=' + commentableID + '&commentable_type=' + commentableType, {
      method: 'get',
      onSuccess: function(transport){
        $(commentableType + '_comments_' + commentableID).innerHTML = transport.responseText;
      }
    });
  },

  toggleBox: function(commentableType, commentableID){
    var box = $(commentableType + '_comment_box_' + commentableID);
    if(!box.visible()){
      Effect.BlindDown(box);
      $(commentableType + '_comment_content_' + commentableID).focus();
    }else{
      Effect.BlindUp(box);
    }
  }

});

Iyxzone.WallMessage = Class.create({});

Object.extend(Iyxzone.WallMessage, {

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

  save: function(wallType, wallID, button){
    if(Iyxzone.WallMessage.validate($('comment_content'))){
      new Ajax.Request('/' + wallType + 's/' + wallID + '/wall_messages', {
        method: 'post',
        parameters: $('wall_message_form').serialize(),
        onLoading: function(){
          Iyxzone.disableButton(button, '请等待..');
        },
        onComplete: function(){
          Iyxzone.enableButton(button, '发布');
        }
      });
    } 
  },

  set: function(login){
    $('comment_content').value = '回复' + login + '：';
    $('comment_content').focus();
  }

});
