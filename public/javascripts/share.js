Iyxzone.Share = {
  version: '1.0',
  
  author: ['高侠鸿'],
  
  getPage: function(link){
    this.node = new Element('script', {type: 'text/javascript', src: 'http://www.baidu.com'});
    var head = $('shared_link');
    head.appendChild(this.node);
    alert(this.node.innerHTML);
  },

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
  },

  new: function(){
    var url = $('link').value;
    alert(url);
    if(this.isVideoURL(url) || this.isValidURL(url)){
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
