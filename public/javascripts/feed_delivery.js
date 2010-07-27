Iyxzone.FeedDelivery = {
  version: "1.0",
  author: "高侠鸿",
  morePhotos: function(deliveryID){
    new Ajax.Request('/feed_deliveries/' + deliveryID + '.json', {
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
};
