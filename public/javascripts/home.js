HomeManager = Class.create({

	initialize: function(id){
		this.loading_image = new Image();
		this.loading_image.src = '/images/loading.gif';
		this.feeds_div = $('feed_list');
		this.more_feeds_div = $('more_feed');
		this.idx = 0;
		this.feed_categories = $('feed_menu').childElements();
	},

	loading: function(){
		this.old_more_feeds_div = this.more_feeds_div.innerHTML;
		this.more_feeds_div.innerHTML = "<div style='textAligin: center'><img src='" + this.loading_image.src + "'/></div>";
	},

	show_feeds: function(type){
		for(var i=0;i < this.feed_categories.length;i++)
			this.feed_categories[i].className = '';
		if(type == null){
			this.feed_categories[0].className = 'hover';
		}else{
			this.feed_categories[type+1].className = 'hover';
		}
		this.idx = 0;
		this.feeds_div.innerHTML = '';
		this.loading();
		if(type != nil){
			this.type = type;
			new Ajax.Request('/home/feeds?type=' + type, {method: 'get'});
		}else{
			new Ajax.Request('/home/feeds', {method: 'get'});
		}
	},

	more_feeds: function(){
		if(this.type != nil){
			new Ajax.Request('/home/more_feeds?type=' + this.type + '&idx=' + this.idx, {
				method: 'get',
				onSuccess: function(transport){
					this.idx++;
				}.bind(this)
			});
		}else{
			new Ajax.Request('/home/more_feeds?idx=' + this.idx, {
				method: 'get',
				onSuccess: function(transport){
					this.idx++;
				}.bind(this)
			});
		}
	},

	fetch_notices: function(url){
		new Ajax.Request(url, {
			method: 'get',
			onSuccess: function(transport){
				$('my_notices').innerHTML = transport.responseText;
			}.bind(this)
		});
	},

	read_notice: function(url, token){
		new Ajax.Request(url,	{
			method: 'put',
			parameters: "authenticity_token=" + encodeURIComponent(token),
			onSuccess: function(transport){
				$('my_notices').innerHTML = transport.responseText;
			}.bind(this)
		});
	}

});
