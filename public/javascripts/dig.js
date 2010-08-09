Iyxzone.Dig = {

  version: '1.0',

  author: '高侠鸿'

};

Object.extend(Iyxzone.Dig, {

  iconDig: function(diggableType, diggableID, link){
    var span = $(link).parentNode.childElements()[0];

    new Ajax.Request(Iyxzone.URL.createDig(diggableType, diggableID), {
      method: 'post',
      onLoading: function(){
        $(link).writeAttribute("onclick", "");
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $(link).observe("click", function(e){
            tip("你已经赞过了");
          });
          span.addClassName('dug');
          span.update(parseInt(span.innerHTML) + 1);
        }else if(json.code == 0){
          $(link).observe("click", function(e){
            Iyxzone.Dig.iconDig(diggableType, diggableID, link);
          });
        }
      }.bind(this)
    });
  },

  textDig: function(diggableType, diggableID, link){
    new Ajax.Request(Iyxzone.URL.createDig(diggableType, diggableID), {
      method: 'post',
      onLoading: function(){
        $(link).writeAttribute("onclick", "");
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $(link).observe("click", function(e){
            tip("你已经赞过了");
          });
        }else if(json.code == 0){
          $(link).observe("click", function(e){
            Iyxzone.Dig.textDig(diggableType, diggableID, link);
          });
        }
      }.bind(this)
    });
  }

});
