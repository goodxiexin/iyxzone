Iyxzone.Share = {
  version: '1.0',
  
  author: ['高侠鸿'],
  
  isValidURL: function(url){
    if(!url.match(/(http:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-%=&]+)?/)){
      return false;
    }else{
      return true;
    }
  },

  isVideoURL: function(url){
    var youkuSingle = /http:\/\/v\.youku\.com\/v_show\/id_[\w]*\=?\.html/;
    var youkuAlbum = /http:\/\/v\.youku\.com\/v_playlist\/[\w]*\.html/;
    
    // 目前只支持youku???
    if(url.match(youkuSingle) || url.match(youkuAlbum)){
      return true;
    }

    return false;
  },

  isInsiteURL: function(url){
    if(url.include("www.17gaming.com") || url.include("17gaming.com")){
      return true;
    }
    return false;
  },

  new: function(){
    var url = $('link').value;
    if(this.isInsiteURL(url)){
      error('站内内容请直接在站内分享，这里请分享站外内容');
    }else if(this.isVideoURL(url) || this.isValidURL(url)){
      facebox.set_width(450);
      facebox.loading();
      new Ajax.Request('/sharings/new', {
        method: 'get',
        parameters: 'at=shares&url=' + encodeURIComponent(url),
        onSuccess: function(transport){
          facebox.reveal(transport.responseText);
        }.bind(this)
      });
    }else{
      error('非法的url地址');
    }
  }

};
