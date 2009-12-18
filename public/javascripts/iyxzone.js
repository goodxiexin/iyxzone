Iyxzone = {};

Object.extend(Iyxzone, {

  version: 1.0,

  author: ['高侠鸿'],

  // some utilities
  disableButton: function(button, text){
    button.writeAttribute({disabled: 'disabled'});
    this.background = button.style.background;
    button.setStyle({
      background: 'grey',
      opacity: 0.5
    });
    button.value = text;
  },

  enableButton: function(button, text){
    button.disabled = '';
    button.setStyle({
      background: this.background,
      opacity: 1
    });
    button.value = text;
  }

});

