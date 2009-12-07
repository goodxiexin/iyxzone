CharacterInfo = Class.create({
	
	initialize: function(id, name, level, game_id, game, rating, area_id, area, server_id, server, profession_id, profession, race_id, race){
		this.id = id;
		this.name = name;
		this.level = level;
		this.game_id = game_id;
		this.game = game;
    this.rating = rating;
		this.area_id = area_id;
		this.area = area;
		this.server_id = server_id;
		this.server = server;
		this.profession_id = profession_id;
		this.profession = profession;
		this.race_id = race_id;
		this.race = race;
	},

  update_game_rate: function(rating) {
    this.rating = rating;
  },

	name: function() { return this.name; },

	level: function() { return this.level;},

	game_id: function() { return this.game_id;},

  rating: function() {return this.rating;},

	area_id: function() { return this.area_id;},

	server_id: function() { return this.server_id; },

	profession_id: function() { return this.profession_id; },

	race_id: function() { return this.race_id; },

	to_html: function(){
		var html = '';
		html += "<li id='character_" + this.id + "'>";
		html += "<h4>" + this.name + "</h4>";
		html += "<a href=# onclick='register_manager.edit_character(" + this.id + ")'>编辑</a>";
		html += "<a href=# onclick='register_manager.remove_character(" + this.id +")'>删除</a>";
		html += "<div><p>等级:" + this.level + "</p>";
		html += "<p>游戏:" + this.game + "</p>";
    html += "<ul class='star-rating'>";
    html += "<li class='current-rating' style='width:"+ (this.rating * 30) + "px;'>";
    html += "Currently"+ this.rating + "/5 Stars.";
    html += "</li>"
    html += "</ul>"
		if(this.area != null)
			html += "<p>服务区:" + this.area + "</p>";
		html += "<p>服务器:" + this.server + "</p>";
    if (this.profession_id != null)
		  html += "<p>种族:" + this.race + "</p>";
    if (this.race_id != null)
		  html += "<p>职业:" + this.profession + "</p>";
		html += "</div></li>";
		return html;
	},

	to_hash: function(){
		return {
      'id'  : this.id,
      'rating'    : this.rating,
			'character[name]'		: this.name,
			'character[level]'		:	this.level,
			'character[game_id]'	:	this.game_id,
			'character[area_id]'	:	this.area_id,
			'character[server_id]':	this.server_id,
			'character[profession_id]' : this.profession_id,
			'character[race_id]'	:	this.race_id
		}
	}
	
});

RegisterManager = Class.create({

	initialize: function(){
		this.form = $('register_form');
		this.login_info = $('login_info');
		this.login = $('user_login');
		this.email_info = $('email_info');
		this.email = $('user_email');
		this.gender = $('user_gender');
		this.password_info = $('password_info');
		this.password = $('user_password');
		this.confirmation_info = $('password_confirmation_info');
		this.password_confirmation = $('user_password_confirmation');
		this.character_info = $('character_info');
		this.characters = new Hash();
		this.character_id = 0;
		this.loading_image = new Image();
		this.loading_image.src = '/images/loading.gif';
    this.game_manager = new GameManager();
	},

	load: function(div){
		div.innerHTML = '<img src="' + this.loading_image.src + '"/>';
	},

	show_login_requirement: function(){
		this.login_info.innerHTML = '只能由数字，字母组成，大小4-16字符';
	},

	validate_login: function(){
		if(this.login.value == ''){
			this.login_info.innerHTML = '不能为空';
			return false;
		}

		if(this.login.value.length < 6){
			this.login_info.innerHTML = '至少要4个字符';
			return false;
		}
		if(this.login.value.length > 16){
		  this.login_info.innerHTML = '最多16个字符';
			return false;
		}

		first = this.login.value[0];
		if((first >= 'a' && first <= 'z') || (first >= 'A' && first <= 'Z')){
			if(this.login.value.match(/[A-Za-z0-9\_]+/)){
				this.login_info.innerHTML = '合法';
				return true;
			}else{
				this.login_info.innerHTML = '只允许字母和数字';
				return false;
			}
		}else{
			this.login_info.innerHTML = '必须以字母开头';
			return false;
		}
	},

	show_email_requirement: function(){
		this.email_info.innerHTML = '输入合法的邮件地址';
	},

	validate_email: function(){
		if(this.email.value == ''){
		  this.email_info.innerHTML = '邮件不能为空';
		  return false;
		}

		if(this.email.value.match(/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/)){
			this.load(this.email_info);
			new Ajax.Request('/register/validates_email_uniqueness?email='+encodeURIComponent(this.email.value), {
        method: 'get',
			  onSuccess: function(transport){
			    if(transport.responseText == 'yes'){
			      this.email_info.innerHTML = '合法';
			    }else{
			      this.email_info.innerHTML = '该邮箱已被注册';
			    }
				}.bind(this)
			});
			return true;
		}else{
			this.email_info.innerHTML = '非法的邮件格式';
			return false;
		}
	},

	show_password_requirement: function(){
		this.password_info.innerHTML = '密码6－20个字符';
	},

	validate_password: function(){
		var strongReg = new RegExp("^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$", "g");
		var mediumReg = new RegExp("^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");

		// check length
		if(this.password.value.length < 6){
		  this.password_info.innerHTML = '至少6个字符';
		  return false;
		}
		if(this.password.value.length > 20){
		  this.password_info.innerHTML = '最多20个字符';
		  return false;
		}

		// check strength
		if(this.password.value.match(strongReg)){
		  this.password_info.innerHTML = '密码强度: 强';
		  return true;
		}else if(this.password.value.match(mediumReg)){
		  this.password_info.innerHTML = '密码强度: 中';
		  return true;
		}else{
			this.password_info.innerHTML = '密码强度: 弱';
			return true;
		}
	},

	show_password_confirm_requirement: function(){
		this.confirmation_info.innerHTML = '确认你的密码';
	},

	validate_password_confirmation: function(){
		if(this.password.value == ''){
		  this.password_info.innerHTML = '密码不能为空';
			return false;
		}

		if(this.password.value == this.password_confirmation.value){
			this.confirmation_info.innerHTML = '两次密码一致';
			return true;
		}else{
			this.confirmation_info.innerHTML = '两次密码不一致';
			return false;
		}
	},

  game_onchange: function(){
    this.game_manager.game_onchange();
  },

  area_onchange: function(){
    this.game_manager.area_onchange();
  },

  setup_rating_info: function(rating){
    $('game_rate').value = rating;
    $('current_rate').innerHTML = "<li class='current-rating' style='width:"+ rating*30 +"px;'> Currently "+ rating +"/5 Stars.</li>"; 
  },

	validate_character_info: function(new_data){
		$('character_name_info').innerHTML = '';
		$('character_level_info').innerHTML = '';
		$('character_game_info').innerHTML = '';
		$('character_area_info').innerHTML = '';
		$('character_server_info').innerHTML = '';
		$('character_profession_info').innerHTML = '';
		$('character_race_info').innerHTML = '';

		var name = $('character_name').value;
		var info = $('character_name_info');
		if(name == ''){
			info.innerHTML = '人物昵称应该有的吧';
			return false;
		}

		var level = $('character_level').value;
		info = $('character_level_info');
		if(level.value == ''){
			info.innerHTML = '等级不能不添啊';
			return false;
		}

    if($('character_game_id').value == ''){
      $('character_game_info') = '没有选择游戏，如有问题，请看提示';
      return false;
    }

    if(this.details){
      if(this.details.no_servers){
        tip("由于游戏数量庞大，很多游戏已经停服，我们没有把所有游戏统计完成。这个游戏的资料就还不完全，请您在左边的意见／建议中告诉我们您所在游戏的所在服务器，我们会以最快速度为您添加。对您带来得不便，我们道歉。");
        return false;
      }
      if(!this.details.no_areas && $('character_area_id').value == ''){
        info.innerHTML = '没有选择区域，如有问题，请看提示';
        return false;
      }
      if(!this.details.no_races && $('character_race_id').value == ''){
        info.innerHTML = '没有选择种族';
        return false;
      }
      if(!this.details.no_professions && $('character_profession_id').value == ''){
        info.innerHTML = '没有选择职业';
        return false;
      }
    }

		return true;  
	},

	new_character: function(){
		this.old_character = this.character_info.innerHTML;
		if(this.new_form){
			this.character_info.innerHTML = this.new_form;
      this.game_manager.prepare(
            $('character_game_id'),
            $('character_area_id'),
            $('character_server_id'),
            $('character_race_id'),
            $('character_profession_id'));
		}else{
			this.load(this.character_info);
			new Ajax.Request('/register/new_character', {
				method: 'get',
				onSuccess: function(transport){
					this.new_form = transport.responseText;
					this.character_info.innerHTML = this.new_form;
          this.game_manager.prepare(
            $('character_game_id'),
            $('character_area_id'),
            $('character_server_id'),
            $('character_race_id'),
            $('character_profession_id'));
				}.bind(this)
			});
		}
	},

	leave_new_character: function(){
		this.character_info.innerHTML = this.old_character;
	  this.details = null;
  },

	selected_text: function(list){
		for(var i=0;i<list.options.length;i++){
			if(list[i].selected){
				return list[i].text;
			}
		}
		return null;
	},

	create_character: function(){
		if(this.validate_character_info()){
			var new_info = new CharacterInfo(
        this.character_id,
        $('character_name').value,
        $('character_level').value,
        $('character_game_id').value,
        this.selected_text($('character_game_id')),
        $('game_rate').value,
        $('character_area_id').value,
        this.selected_text($('character_area_id')),
        $('character_server_id').value,
        this.selected_text($('character_server_id')),
        $('character_profession_id').value,
        this.selected_text($('character_profession_id')),
        $('character_race_id').value,
        this.selected_text($('character_race_id')));
			this.character_info.innerHTML = this.old_character;
      // update existing ratings
      this.characters.each(function(c){
        var info = c.value;
        if(info.game_id == new_info.game_id){ 
          info.update_game_rate(new_info.rating);
          this.characters.set(c.key, info);
          Element.replace($('character_' + c.key), info.to_html());
        }
      }.bind(this));
			this.characters.set(new_info.id, new_info);
			this.character_id += 1;
			Element.insert($('characters'), {top: new_info.to_html()});
      this.details = null;
		}
	},

	edit_character: function(character_id){
		var params = {character: this.characters.get(character_id).to_hash()};
    this.old_character = this.character_info.innerHTML;
    this.load(this.character_info);
    new Ajax.Request('/register/edit_character', {
      method: 'get',
			parameters: this.characters.get(character_id).to_hash(),
      onSuccess: function(transport){
				this.character_info.innerHTML = transport.responseText;
        this.game_manager.prepare(
            $('character_game_id'),
            $('character_area_id'),
            $('character_server_id'),
            $('character_race_id'),
            $('character_profession_id'));
      }.bind(this)
    });
  },	

	leave_edit_character: function(){
    this.character_info.innerHTML = this.old_character;
    this.details = null;
  },

	update_character: function(character_id){
    if(this.validate_character_info()){
			var new_info = new CharacterInfo(
        character_id,
        $('character_name').value,
        $('character_level').value,
			  $('character_game_id').value,
        this.selected_text($('character_game_id')),
        $('game_rate').value,
			  $('character_area_id').value,
        this.selected_text($('character_area_id')),
			  $('character_server_id').value,
        this.selected_text($('character_server_id')),
			  $('character_profession_id').value,
        this.selected_text($('character_profession_id')),
			  $('character_race_id').value,
        this.selected_text($('character_race_id')));
			this.characters.set(character_id, new_info);
			this.character_info.innerHTML = this.old_character;
      this.details = null;
      this.characters.each(function(c){
        var info = c.value;
        if(info.game_id == new_info.game_id){
          info.update_game_rate(new_info.rating);
          this.characters.set(c.key, info);
          Element.replace($('character_' + c.key), info.to_html());
        }
      }.bind(this));
    }
  },

	remove_character: function(character_id){
		this.characters.unset(character_id);
		$('character_' + character_id).remove();
	},

	submit: function(){
		if(!this.validate_login()) return; 
		if(!this.validate_email()) return;
		if(!this.validate_password()) return;
		if(!this.validate_password_confirmation()) return;

		if(this.characters.size() == 0){
			error('至少要有1个游戏角色');
			return;
		}
		
		// construct parameters
    var ratings = new Hash();
		var params = this.form.serialize() + '&';
		this.characters.each(function(p){
			var info = p.value;
			params += 'characters[][name]=' + info.name + '&';
			params += 'characters[][level]=' + info.level + '&';
			params += 'characters[][game_id]=' + info.game_id+ '&';
			params += 'characters[][area_id]=' + info.area_id+ '&';
			params += 'characters[][server_id]=' + info.server_id+ '&';
			params += 'characters[][profession_id]=' + info.profession_id+ '&';
			params += 'characters[][race_id]=' + info.race_id+ '&';
      ratings.set(p.game_id, p.rating);
		});
    ratings.each(function(r){
      params += 'rating[][rateable_id]=' + r.key + '&';
      params += 'rating[][rating]=' + r.value + '&';
    });

    // send request
		new Ajax.Request('/users', {method: 'post', parameters: params});	
	}

});

