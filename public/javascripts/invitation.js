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

  onClick: function(td, val){
    if(this.selected.get(val)){
      td.setStyle({background: 'white'});
      this.selected.unset(val);
    }else{
      this.selected.set(val, td)
      td.setStyle({background: '#DEFEBB'});
    } 
  },

  submit: function(form){
    form.action += '?';
    if(this.selected.size() == 0){
      error('你必须至少邀请一个游戏角色');
    }else{
      this.selected.each(function(pair){
        var el = new Element("input", {type: 'hidden', value: pair.key, id: 'values[]', name: 'values[]'});
        form.appendChild(el);
      });
      form.submit();
    }
  },

  reset: function(){
    this.selected = new Hash();
  },

  search: function(){
    var val = this.field.value;
    var ul = $('invitee_list');
    var els = ul.childElements();

    els.each(function(li){
      var pinyin = li.readAttribute('pinyin');
      var name = li.readAttribute('name');
      if(name.include(val) || pinyin.include(val)){
        li.show();
      }else{
        li.hide();
      }
    }.bind(this));

    this.timer = setTimeout(this.search.bind(this), 300);
  },

  startObserving: function(field){
    this.field = field;
    this.timer = setTimeout(this.search.bind(this), 300);
  },

  stopObserving: function(){
    clearTimeout(this.timer);
  }

});

