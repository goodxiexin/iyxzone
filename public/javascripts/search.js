UserSearcher = Class.create({

	initialize: function(){
		this.panel = $('search_panel');
		this.normal_form = $('normal_form');
    this.character_form = $('character_form');
    this.character_options = $('character_options'); 
	  this.game_manager = new GameManager();
    this.game_manager.prepare($('game_id'), $('area_id'), $('server_id'));
    this.advanced_on = false;
  },

	show_normal_form: function(){
    this.normal_form.getInputs('text')[0].value = '好友名字';
    this.normal_form.show();
    this.character_form.hide();
  },

  show_character_form: function(){
    this.character_form.getInputs('text')[0].value = '角色名字';
    this.normal_form.hide();
    this.character_form.show();
  },

	game_onchange: function(){
    this.game_manager.game_onchange();
  },
    
  area_onchange: function(){
    this.game_manager.area_onchange();
  },

  toggle_character_options: function(){
    this.advanced_on = !this.advanced_on;
    if(this.character_options.visible()){
      Effect.BlindUp(this.character_options); 
    }else{
      Effect.BlindDown(this.character_options); 
    } 
  },

  validate_character: function(){
    var value = this.character_form.getInputs('text')[0].value;
    if(value  == '角色名字' || value == ''){
      error('请输入角色名字');
      return false;
    }
    if(!this.advanced_on){
      this.game_manager.reset(); // set game_id, area_id, server_id to null
    }
    return true;
  },

  validate_user: function(){
    var value = this.normal_form.getInputs('text')[0].value; 
    if(value  == '角色名字' || value == ''){
      error('请输入好友名字');
      return false;
    }
    return true;
  },

});

