Iyxzone.RSS = {

  version: '1.3',

  author: '高侠鸿',

  Feeder: {}

};

Object.extend(Iyxzone.RSS, {

  submit: function(form){
    var btn = $(form).down('button', 0);

    new Ajax.Request(Iyxzone.URL.createRssFeed(), {
      method: 'post',
      parameters: $(form).serialize(),
      onLoading: function(transport){
        Iyxzone.changeCursor('wait');
        //Iyxzone.disableButton(btn, '发送..');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showRssFeed(json.id);
        }else{
          error("保存的时候发生错误");
         // Iyxzone.enableButton(btn, '完成');
        }
      }.bind(this)
    });
  },

  destroy: function(rssID, link){
    new Ajax.Request(Iyxzone.URL.destroyRssFeed(rssID), {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        $(link).writeAttribute('onclick', '');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.newRssFeed();
        }else{
          error("删除的时候发生错误");
          $(link).writeAttribute('onclick', "Iyxzone.RSS.destroy(" + rssID + ", this);");
        }
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.RSS.Feeder, {

  items: new Array(),

  addItem: function(item){
    this.items.push(item);
  },

  toggleAll: function(checkbox){
    var checked = checkbox.checked;
    var checkboxes = new Array();
    $$('input').each(function(input){
      if(input.type == 'checkbox'){
        input.checked = checked;
      }
    }.bind(this));
  },

  import: function(userID, btn){
    var checked = new Array();
    $$('input').each(function(input){
      if(input.type == 'checkbox' && input.checked){
        var idx = input.readAttribute('index');
        if(idx)
          checked.push(idx);
      }
    }.bind(this));

    var params = "";
    for(var i=0;i<checked.length;i++){
      var idx = checked[i];
      var item = this.items[idx];
      params += "blogs[" + idx + "][title]=" + encodeURIComponent(item.title) + "&blogs[" + idx + "][content]=" + encodeURIComponent(item.desc) + "&";
    }
    
    new Ajax.Request(Iyxzone.URL.createMultipleBlog(), {
      method: 'post',
      parameters: params,
      onLoading: function(transport){
        Iyxzone.changeCursor('wait');
        //Iyxzone.disableButton(btn, '导入..');
      },
      onComplete: function(transport){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.listBlog(userID);
        }else if(json.code == 0){
          error("发生错误");
          //Iyxzone.enableButton(btn, '导入');
        }
      }.bind(this)
    });
  }

});
