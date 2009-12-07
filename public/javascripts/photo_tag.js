PhotoTagBuilder = Class.create({

	initialize: function(type, photo_id){
		this.photo_id = photo_id;
		this.photo = $('photo_' + photo_id);
		this.type = type;
		this.pos = this.photo.positionedOffset();
		this.square_size = this.photo.getWidth() * 15 /100;
		Event.observe(document.onresize? document : window, 'resize', function(){
      this.pos = this.photo.positionedOffset();
    }.bind(this));
		this.square;
		this.input;
		this.current_tag_id;
		// load all tags
		var tags = $('photo_tags').childElements();
		this.tags = new Hash();
		for(var i=0;i<tags.length;i++){
			this.tags.set(parseInt(tags[i].readAttribute('tag_id')), tags[i]);
		}
		this.photo.observe('mousemove', function(e){
			this.show_nearest_tag_with_info(e);
		}.bind(this));
	},

	start: function(){
		if(!this.square && !this.input){
			this.create_square();
			this.create_input();
		}
		this.show_square();
		this.show_input();
		this.photo.stopObserving('mousemove'); 
	},

	stay_in_photo: function(x, y){
    if(x < this.pos.left)
      x = this.pos.left;
    if(x > this.pos.left + this.photo.getWidth() - this.square_size)
      x = this.pos.left + this.photo.getWidth() - this.square_size;
    if(y < this.pos.top)
      y = this.pos.top;
    if(y > this.pos.top + this.photo.getHeight() - this.square_size)
      y = this.pos.top + this.photo.getHeight() - this.square_size;
    return [x,y];
  },

  enable_drag: function(){
    this.draggable = new Draggable(this.square, {
      snap: function(x, y, draggable){
        var xy = this.stay_in_photo(x, y);
        this.square.setStyle({
          left: xy[0] + 'px',
          top: xy[1] + 'px'
        });
        this.locate_input();
        return xy;
      }.bind(this)
    });
  },

	create_square: function(){
		this.square = $('square');
    this.square.setStyle({
      position: 'absolute',
      left: this.pos.left + 'px',
      top: this.pos.top + 'px',
      border: '2px solid #eeeeee',
      height: this.square_size + 'px',
      width: this.square_size + 'px',
      zIndex: 4});
		this.enable_drag();
	},

	show_square: function(){
		this.square.show();
	},

	hide_square: function(){
		this.square.hide();
	},

	create_input: function(){
	  this.input = $('input');
    this.tagged_user_id = $('tag_tagged_user_id');
    this.cancel_btn = $('cancel_btn');
    this.confirm_btn = $('confirm_btn');
		this.autocomplete = $('tag_tagged_user');
		this.content = $('tag_content');
    this.cancel_btn.observe('click', function(){
      this.hide_input();
      this.hide_square();
			this.photo.observe('mousemove', function(e){
				this.show_nearest_tag_with_info(e);
			}.bind(this));
    }.bind(this));
    this.confirm_btn.observe('click', function(){
      this.submit_tag();
    }.bind(this));
	},

	show_input: function(){
		this.locate_input();
		this.input.show();
	},

	hide_input: function(){
		this.input.hide();
	},	

	locate_input: function(){
    var top = this.square.positionedOffset().top;
    var left = this.square.positionedOffset().left + this.square.getWidth() + 10;
    this.input.setStyle({position: 'absolute', top: top + 'px', left: left + 'px', zIndex: 4});
	},

	after_select_friend: function(name, friend_id){
		this.tagged_user_id.value = friend_id;
		this.autocomplete.value = name;alert(name);
		if(this.friend_list){
			this.friend_list.hide();
			$('radio_' + this.tagged_user_id.value).checked = false;
		}
	},

	validate_tag: function(){
		if(this.tagged_user_id.value == ''){
			error('请选择一个好友');
			return false;
		}
		return true;
	},

	toggle_friends: function(token){
		if(this.friend_list){
			this.friend_list.toggle();
		}else{
			this.friend_list = new Element('div');
			this.input.appendChild(this.friend_list);
			this.friend_list.setStyle({
				position: 'absolute',
				left: (this.autocomplete.positionedOffset().left + this.autocomplete.getWidth() - 250) + 'px',
				top: (this.autocomplete.positionedOffset().top + 25) + 'px',
				width: '250px',
				height: '200px',
				overflow: 'auto',
				border: '1px solid black',
				background: 'white'
			});
			this.friend_list.innerHTML = '<img src="/images/loading.gif" />';
			new Ajax.Request('/photo_tags/all_friends', {
				method: 'get',
				parameters: 'authenticity_token=' + encodeURIComponent(token),
				onSuccess: function(transport){
					this.friend_list.innerHTML = transport.responseText;
				}.bind(this)
			});
		}
	},

	submit_tag: function(){
		if(this.validate_tag()){
			var params = "";
			params = $('tag_form').serialize();
			params += "&tag[x]=" + (this.square.positionedOffset().left - this.pos.left);
			params += "&tag[y]=" + (this.square.positionedOffset().top - this.pos.top);
			params += "&tag[width]=" + this.square.getWidth();
			params += "&tag[height]=" + this.square.getHeight();
			alert('/' + this.type + 's/' + this.photo_id + '/tags');
			new Ajax.Request('/' + this.type + 's/' + this.photo_id + '/tags', {
				method: 'post', 
				parameters: params,
				onSuccess: function(transport){
					this.autocomplete.clear();
					this.tagged_user_id.clear();
					this.content.clear();
					var tag = new Element('div');
					tag.innerHTML = transport.responseText;
					this.tags.set(tag.childElements()[0].readAttribute('tag_id'), tag.childElements()[0]);
					Element.insert($('photo_tags'), {bottom: tag.innerHTML});
				}.bind(this)
			});
		}
	},

	remove_tag: function(tag_id, authenticity_token){
		new Ajax.Request('/' + this.type + 's/' + this.photo_id + '/tags/' + tag_id, {
			method: 'delete',
			parameters: 'authenticity_token=' + encodeURIComponent(authenticity_token),
			onSuccess: function(transport){
				if($('square_'+tag_id)) $('square_'+tag_id).remove();
				if($('info_'+tag_id)) $('info_'+tag_id).remove();
				var tag = this.tags.unset(tag_id);
				if(tag) tag.remove();
			}.bind(this)
		});
	},

	show_nearest_tag_with_info: function(event){
		var distance = 100000000;
    var tag_id = -1;
    var photo_x = this.pos.left;
    var photo_y = this.pos.top;
    var mouse_x = event.pointerX();
    var mouse_y = event.pointerY();

    this.tags.each(function(pair){
      var x = photo_x + parseInt(pair.value.readAttribute('x'));
      var width = parseInt(pair.value.readAttribute('width'));
      var y = photo_y + parseInt(pair.value.readAttribute('y'));
      var height = parseInt(pair.value.readAttribute('height'));
      if(mouse_x >= x && mouse_x <= x + width && mouse_y >=y && mouse_y <= y + height){
        var delta_x = (x + width/2) - mouse_x; 
        var delta_y = (y + height/2) - mouse_y; 
        var delta = ((x + width/2) - mouse_x) * ((x + width/2) - mouse_x) + ((y + height/2) - mouse_y) * ((y + height/2) - mouse_y);
        if(delta < distance){
          distance = delta;
          tag_id = pair.key;
        }
      }else{
        if(pair.key == this.current_tag_id){
          this.hide_tag_with_info(this.current_tag_id);
          this.current_tag_id = -1;
        }
      }
    }.bind(this));

    if(tag_id >= 0){
      this.current_tag_id = tag_id;
      this.show_tag_with_info(tag_id);
    }
	},

  hide_tag_with_info: function(tag_id){
    var square = $('square_' + tag_id);
    var info = $('info_' + tag_id);
    if(square) square.hide();
    if(info) info.hide();
  },

	show_tag_with_info: function(tag_id){
		var tag = this.tags.get(tag_id);
    if(!tag) return;
    var square = $('square_'+tag_id);
    if(square){
      square.show();
    }else{
      var x = tag.readAttribute('x');
      var y = tag.readAttribute('y');
      var width = tag.readAttribute('width');
      var height = tag.readAttribute('height');
      var top = parseInt(y) + this.pos.top;
      var left = parseInt(x) + this.pos.left;
      square = new Element('div', {className: 'square-class', id: 'square_' + tag_id});
      square.setStyle({
        position: 'absolute',
        width: width + 'px',
        height: height + 'px',
        left: left + 'px',
        top: top + 'px',
				border: '2px solid #eeeeee',
        zIndex: 4});
      document.body.appendChild(square);
    }
    var info = $('info_' + tag_id);
		if(info){
      info.show();
    }else{
      var left = parseInt(tag.readAttribute('x')) + parseInt(tag.readAttribute('width')) + this.pos.left + 10;
      var top = parseInt(tag.readAttribute('y')) + this.pos.top;
      info = new Element('div', {id: 'info_' + tag_id}).update(tag.readAttribute('info'));
      info.setStyle({
        position: 'absolute',
        color: 'white',
        background: 'black',
        left: left + 'px',
        top: top + 'px',
        zIndex: 4});
      document.body.appendChild(info);
    }
	}

});

function select_friend(textfield, selected_li){
	tag_builder.after_select_friend(textfield.value, selected_li.readAttribute('id'));
}
