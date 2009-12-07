GuildBuilder = Class.create({

	initialize: function(){
		this.form = $('guild_form');
		this.name = $('guild_name');
		this.description = $('guild_description');
		this.category = $('guild_game_id');
	},

	validate: function(){
		if(this.name.value == ''){
			error('名字不能为空');
			return false;
		}
		if(this.category.value == ''){
			error('游戏类别不能为空');
			return false;
		}
		if(this.name.value.length >= 100){
			error('名字最长100个字符');
			return false;
		}
		if(this.description.value.length >= 1000){
			error('描述最多1000个字符');
			return false;
		}
		return true;
	},

	save: function(){
		if(this.validate()){
			this.form.action = '/guilds';
			this.form.method = 'post';
			this.form.submit();
		}
	},

	update: function(guild_id){
		if(this.validate()){
			this.form.action = '/guilds/' + guild_id;
			this.form.method = 'put';
			this.form.submit(); 
		}
	}

});

GuildFeeder = Class.create({

	initialize: function(id){
		this.idx = 0;
		this.id = id;
	},

	more_feeds: function(){
		new Ajax.Request('/guilds/' + this.id + '/more_feeds?idx=' + this.idx, {
			method: 'get',
			onSuccess: function(transport){
				this.idx++;
			}.bind(this)
		});
	}

});
