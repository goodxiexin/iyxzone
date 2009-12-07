GameSuggestor = Class.create({

	initialize: function(){
		this.tags = new Array();
		this.input = $('the_game_tags');
		this.input.clear();
	},

	has_tag: function(tag_name){
		for(var i=0;i<this.tags.length;i++){
			if(tag_name == this.tags[i])
				return true;
		}
		return false;
	},

	add_tag: function(tag_name){
		if(!this.has_tag(tag_name)){
			if(this.input.value == '')
				this.input.value = tag_name;
			else
				this.input.value = tag_name + "," + this.input.value;
			this.tags.push(tag_name);
		}else{
			alert('你已经选择了');
		}
	},

	suggest: function(){
		if(this.input.value == ''){
			notice('请您点击游戏相关类型，以便我们向您推荐');
		}else{
			new Ajax.Request('/game_suggestions/game_tags', { 
				method: 'get',
				parameters: {selected_tags: this.input.value, new_game: $('new_game').checked},
				onSuccess: function(transport){
					$('game_suggestion_area').innerHTML = transport.responseText;
					this.input.clear();
					this.tags = [];					
				}.bind(this)
			});
		}	
	},

  toggle_advanced_options: function(){
    if($('advanced_options').visible()){
      Effect.BlindUp($('advanced_options'));
    }else{
      Effect.BlindDown($('advanced_options'));
    } 
  }		

});
