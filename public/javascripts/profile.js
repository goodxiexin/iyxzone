ProfileManager = Class.create({

  initialize: function(profile_id){
    this.profile_id = profile_id;
    this.loading_image = new Image();
    this.loading_image.src = "/images/loading.gif";
    this.binfo = $('basic_info');
    this.binfo_head = this.binfo.childElements()[0];
    this.binfo_body = this.binfo.childElements()[1];
    this.cinfo = $('contact_info');
		this.cinfo_head = this.cinfo.childElements()[0];
		this.cinfo_body = this.cinfo.childElements()[1];
    this.ginfo = $('character_info');
		this.ginfo_head = this.ginfo.childElements()[0];
		this.ginfo_body = this.ginfo.childElements()[1];
		this.character_forms = new Hash();
    this.game_manager = new GameManager();
    this.region_manager = new ChineseRegion();
  },

	loading: function(div){
		div.innerHTML = "<img src='" + this.loading_image.src + "'/>";
	},

  edit_basic_info: function(){
    // change css class of this.binfo_head
    this.old_binfo = this.binfo_body.innerHTML;
    if(this.binfo_form){
      this.binfo_body.innerHTML = this.binfo_form;
    }else{
      this.loading(this.binfo_body);
      new Ajax.Request('/profiles/' + this.profile_id + '/edit?type=1', {
        method: 'get',
        onSuccess: function(transport){
          this.binfo_form = transport.responseText;
          this.binfo_body.innerHTML = this.binfo_form;
          this.region_manager.prepare($('profile_region_id'), $('profile_city_id'), $('profile_district_id'));
        }.bind(this)
      });
    }
  },

  leave_edit_basic_info: function(){
    this.binfo_body.innerHTML = this.old_binfo; 
  },

  validate_basic_info: function(){
    return true;
  },

  update_basic_info: function(){
    if(this.validate_basic_info()){
      new Ajax.Request('/profiles/' + this.profile_id + '?type=1', {
        method: 'put',
        parameters: $('basic_info_form').serialize(),
        onSuccess: function(transport){
          this.binfo_form = null;
          //this.binfo_head
          this.binfo_body.innerHTML = transport.responseText;
        }.bind(this)
      });
    }
  },

  edit_contact_info: function(){
    // change css class of this.cinfo_head
    this.old_cinfo = this.cinfo_body.innerHTML;
    if(this.cinfo_form){
      this.cinfo_body.innerHTML = this.cinfo_form;
    }else{
      this.loading(this.cinfo_body);
      new Ajax.Request('/profiles/' + this.profile_id + '/edit?type=2', {
        method: 'get',
        onSuccess: function(transport){
          this.cinfo_form = transport.responseText;
          this.cinfo_body.innerHTML = this.cinfo_form;
        }.bind(this)
      });
    }
  },

  leave_edit_contact_info: function(){
    this.cinfo_body.innerHTML = this.old_cinfo;
  },

  validate_contact_info: function(){
    return true;
  },

  update_contact_info: function(){
    if(this.validate_contact_info()){
      new Ajax.Request('/profiles/' + this.profile_id + '?type=2', {
        method: 'put',
        parameters: $('contact_info_form').serialize(),
        onSuccess: function(transport){
          this.cinfo_form = null;
          //this.cinfo_head
          this.cinfo_body.innerHTML = transport.responseText;
        }.bind(this)
      });
    }
  },

  setup_rating_info: function(rating){
	    $('current_rate').innerHTML = "<li class='current-rating' style='width:"+ rating*30 +"px;'> Currently "+ rating +"/5 Stars.</li>";
        $('star_value').innerHTML = "<input id='game_rate' type='hidden' value='"+ rating +"' name='game_rate'/>";
  },

	new_character_info: function(){
		// change head CSS
		this.old_ginfo = this.ginfo_body.innerHTML;
		if(this.new_form){
			this.ginfo_body.innerHTML = this.new_form;
		}else{
			this.loading(this.ginfo_body);
			new Ajax.Request('/characters/new', {
				method: 'get',
				onSuccess: function(transport){
					this.new_form = transport.responseText;
					this.ginfo_body.innerHTML = this.new_form;
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

	leave_new_character_info: function(){
		this.ginfo_body.innerHTML = this.old_ginfo;
    this.details = null;
	},

	create_character_info: function(){
		if(this.validate_character_info()){
			new Ajax.Request('/characters/', {
				method: 'post',
				parameters: $('character_info_form').serialize(),
				onSuccess: function(transport){
					this.ginfo_body.innerHTML = transport.responseText;
          this.details = null;
				}.bind(this)
			});
		}
	},

	edit_character_info: function(character_id){
    // change css class of this.ginfo_head
		var form = this.character_forms.get(character_id);
		this.old_ginfo = this.ginfo_body.innerHTML;
    if(form){
      this.ginfo_body.innerHTML = form;
    }else{
      this.loading(this.ginfo_body);
      new Ajax.Request('/characters/' + character_id + '/edit', {
        method: 'get',
        onSuccess: function(transport){
					form = transport.responseText;
					this.character_forms.set(character_id, form);
					this.ginfo_body.innerHTML = form;
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

  leave_edit_character_info: function(character_id){
		this.ginfo_body.innerHTML = this.old_ginfo;
    this.details = null;
  },

  validate_character_info: function(new_data){
    if($('character_name').value == ''){
      error("人物昵称不能不添呀");
      return false;
    }
    if($('character_level').value == ''){
      error('等级不能不添啊');
      return false
    }
    if($('character_game_id').value == ''){
      error('没有选择游戏，如有问题，请看提示');
      return false;
    }
    if(this.details){
      if(this.details.no_servers){
        tip("由于游戏数量庞大，很多游戏已经停服，我们没有把所有游戏统计完成。这个游戏的资料就还不完全，请您在左边的意见／建议中告诉我们您所在游戏的所在服务器，我们会以最快速度为您添加。对您带来得不便，我们道歉。");
        return false;
      }
      if(!this.details.no_areas && $('character_area_id').value == ''){
        error('没有选择区域，如有问题，请看提示');
        return false;
      }
      if(!this.details.no_races && $('character_race_id').value == ''){
        error('没有选择种族');
        return false;
      }
      if(!this.details.no_professions && $('character_profession_id').value == ''){
        error('没有选择职业');
        return false;
      }
    }
    return true;
  },

  update_character_info: function(character_id){
    if(this.validate_character_info()){
      new Ajax.Request('/characters/' + character_id , {
        method: 'put',
        parameters: $('character_info_form').serialize(),
        onSuccess: function(transport){
					this.character_forms.unset(character_id);
          //this.ginfo_head
					this.ginfo_body.innerHTML = transport.responseText;
          this.details = null;
        }.bind(this)
      });
    }
  },

  change_game: function(){
    this.game_manager.game_onchange();
    this.details = this.game_manager.get_details();
  },

  change_area: function(){
    this.game_manager.area_onchange();
  },

  change_region: function(){
    this.region_manager.region_onchange();
  },

  change_city: function(){
    this.region_manager.city_onchange();
  }

});

ProfileFeeder = Class.create({

	initialize: function(id){
		this.idx = 0;
		this.id = id;
	},

	more_feeds: function(){
		new Ajax.Request('/profiles/' + this.id + '/more_feeds?idx=' + this.idx, {
			method: 'get',
			onSuccess: function(transport){
				this.idx++;
			}.bind(this)
		});
	}

});
