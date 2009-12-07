FeedManager = Class.create({

	initialize: function(){
		this.idx = 0;
	},

	show_feeds: function(url){
		new Ajax.Request(url, {
			method: 'get',
			onSuccess: function(transport){
				this.idx++;
			}.bind(this)
		});
	},

	more_feeds: function(url){
		new Ajax.Request(url, {
			method: 'get',
			onSuccess: function(transport){
				this.idx++
	}

});
