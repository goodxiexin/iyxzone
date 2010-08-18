Iyxzone.Tag = {

  version: '1.4',

  author: '高侠鸿'

};

Object.extend(Iyxzone.Tag, {

  validate: function(tagName){
    if(tagName == ""){
      error("写点什么吧");
      return false;
    }

    if(tagName.size > 10){
      error("你的评价太长了吧，最多只能10个字");
      return false;
    }

    return true;
  },

  showTags: function(taggableType, taggableID){
    new Ajax.Request(Iyxzone.URL.listTag(taggableType, taggableID), {
      method: 'get',
      onLoading: function(){},
      onComplete: function(){},
      onSuccess: function(transport){
        Element.replace($('tag_cloud'), transport.responseText);
      }.bind(this)
    }); 
  },

  addTag: function(taggableType, taggableID, tagName){
    new Ajax.Request(Iyxzone.URL.createTag(taggableType, taggableID), {
      method: 'post',
      parameters: {'tag_name': tagName, 'authenticity_token': this.token},
      onLoading: function(){
        Iyxzone.disableButton($('tag_submit'), '发送');
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          this.showTags(taggableType, taggableID);
        }else if(json.code == 0){
          error("发生错误，请稍后再试"); 
        }
      }.bind(this)
    });
  },

  submitForm: function(taggableType, taggableID, field){
    var tagName = $(field).value;

    if(this.validate(tagName)){
      this.addTag(taggableType, taggableID, tagName);
    }
  },

  deleteTag: function(taggableType, taggableID, tagID){
    new Ajax.Request(Iyxzone.URL.deleteTag(tagID, taggableType, taggableID), {
      method: 'delete',
      parameters: 'authenticity_token=' + this.token,
      onLoading: function(){
        this.isDeleting = true;
      }.bind(this),
      onComplete: function(){
        this.isDeleting = false;
        Iyxzone.Facebox.close();
      }.bind(this),
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('tag_' + tagID).remove();
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });  
  },

  confirmDeletingTag: function(taggableType, taggableID, tagID){
    // this prevents multiple tags being deleted at the same time
    if(this.isDeleting){
      return;
    }

    Iyxzone.Facebox.confirmWithCallback('你确定要删除这个印象吗?', null, null, function(){
      this.deleteTag(taggableType, taggableID, tagID);
    }.bind(this));
  },

  init: function(token){
    this.token = encodeURIComponent(token);
  }

}); 

