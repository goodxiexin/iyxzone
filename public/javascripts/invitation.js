/**
 * this only workds for event & guild & poll
 */
Iyxzone.Invitation = {
  version: '1.0',

  author: ['高侠鸿'],

  Builder: {}  

};

Object.extend(Iyxzone.Invitation.Builder, {

  selected: new Hash(),

  onClick: function(td, friendID){
    if(this.selected.get(friendID)){
      td.setStyle({background: 'white'});
      this.selected.unset(friendID);
    }else{
      this.selected.set(friendID, td);
      td.setStyle({background: '#526ea6'});
    } 
  },
  
  onMouseOver: function(td, friendID){
    if(!this.selected.get(friendID)){
      td.setStyle({background: '#e7ebf5'});
    }
  },

  onMouseOut: function(td, friendID){
    if(!this.selected.get(friendID)){
      td.setStyle({background: 'white'});
    }
  },

  submit: function(form){
    form.action += '?';
    if(this.selected.size() == 0){
      error('你必须至少邀请一个人');
    }else{
      this.selected.each( function(pair){
        var el = new Element("input", {type: 'hidden', value: pair.key, id: 'users[]', name: 'users[]'})
        form.appendChild(el);
      });
      form.submit();
    }
  }

});
