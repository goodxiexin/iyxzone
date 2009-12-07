FriendSuggestor = Class.create({

	initialize: function(){
	},

	new_friend_suggestion: function(suggestion_id, token){
		var url = 'friend_suggestions/new';
		var except_ids = [];
		var suggestions = $('friend_suggestions').childElements();
		for(var i=0;i<suggestions.length;i++){
			except_ids.push(suggestions[i].readAttribute('suggestion_id'));
		}
		var except_param = "";
		for(var i=0;i<except_ids.length;i++){
			except_param += "except_ids[]=" + except_ids[i] + "&";
		}
		url += "?" + except_param;
		new Ajax.Request(url, {
			method: 'get',
			parameters: {authenticity_token: token}, //encodeURIComponent(token)},
			onSuccess: function(transport){	
				var card = $('friend_suggestion_' + suggestion_id);
				var temp_parent = new Element('div');
				temp_parent.innerHTML = transport.responseText;
				var li = temp_parent.childElements()[0];
				li.hide();
				Element.replace(card, li);
				li.appear({duration: 3.0});
			}.bind(this)
		});
	},

	new_comrade_suggestion: function(server_id, suggestion_id, token){
		var url = 'friend_suggestions/new';
		var except_ids = [];
		var suggestions = $('server_' + server_id + '_suggestions').childElements();
    for(var i=0;i<suggestions.length;i++){
      except_ids.push(suggestions[i].readAttribute('suggestion_id'));
    }
    var except_param = "";
    for(var i=0;i<except_ids.length;i++){
      except_param += "except_ids[]=" + except_ids[i] + "&";
    }
    url += "?" + except_param;
    new Ajax.Request(url, {
      method: 'get',
      parameters: {server_id: server_id, authenticity_token: token}, //encodeURIComponent(token)},
      onSuccess: function(transport){ 
        var card = $('comrade_suggestion_' + suggestion_id); 
        var temp_parent = new Element('div');
        temp_parent.innerHTML = transport.responseText;
				var li = temp_parent.childElements()[0];
				li.hide();
        Element.replace(card, li);
				li.appear({duration: 3.0}); 
      }.bind(this)
    });

	},

});
