Iyxzone.FeedDelivery = {

  version: "1.1",

  author: "高侠鸿"

};

// get photos in feed delivery
Object.extend(Iyxzone.FeedDelivery, {

  morePhotos: function(deliveryID){
    new Ajax.Request(Iyxzone.URL.showFeedDelivery(deliveryID) + '.json', {
      method: 'get',
      onSuccess: function(transport){
        var photos = transport.responseText.evalJSON();
        var div = new Element('div', {'class': 'sList fix'});
        var ul = new Element('ul');
        for(var i=0;i<photos.length;i++){
          ul.insert({bottom: '<li><a href="/' + photos[i].type + 's/' + photos[i].id + '"><img src="' + photos[i].url + '" class="imgbox01" /></a>'});
        }
        div.appendChild(ul);
        $('photos_feed_' + deliveryID).update('');
        $('photos_feed_' + deliveryID).appendChild(div);
      }
    });
  }

});

// delete feed delivery
Object.extend(Iyxzone.FeedDelivery, {

  destroy: function(deliveryID, link){
    new Ajax.Request(Iyxzone.URL.deleteFeedDelivery(deliveryID), {
      method: 'delete',
      onLoading: function(){
        $(link).writeAttribute('onclick', '');
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        $(link).writeAttribute('onclick', "Iyxzone.FeedDelivery.destroy(" + deliveryID + ", this);");
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          Effect.BlindUp($('fd_' + deliveryID));
        }else if(json.code == 0){
          error("发生错误");
        }
      }
    });
  }

});
