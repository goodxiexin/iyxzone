Iyxzone.Rating = {

  version: '1.3',

  author: ['高侠鸿'],

  maximum: 5

};

Object.extend(Iyxzone.Rating, {
  
  set: function(rating, rateableID, rateableType, link){
    var stars = $(link).up().childElements();
    var i = 0;
    for(i=0; i < stars.length; i++){
      if(i < rating)
        stars[i].className = 'lit';
      else
        stars[i].className = '';
    }
    $(rateableType + '_' + rateableID + '_rating').value = rating;
  },
  
  buildRatingHTML: function(rating){
    var html = '';
    html += '<div class="star-ratings-block s_clear">';
    for(var i=0;i<Math.floor(rating);i++){
      html += '<a class="lit" href="javascript:void(0)"></a>';
    }
    for(var i=0;i<this.maximum - Math.ceil(rating);i++){
      html += '<a href="javascript:void(0)"></a>';
    }
    html += '</div>';
    return html;
  },
  
  submit: function(form, btn, rateableType, rateableID){
    new Ajax.Request(Iyxzone.URL.createRating(rateableType, rateableID), {
      method: 'post',
      onLoading: function(){
        Iyxzone.disableButton($(btn), '发送..');
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          var html = this.buildRatingHTML(json.average_rating);
          Element.replace($(rateableType + '_' + rateableID + '_rating_form'), html);
        }else if(json.code == 0){
          Iyxzone.enableButton($(btn), '提交');
          error("发生错误");
        }
      }.bind(this)
    });
  }

});
