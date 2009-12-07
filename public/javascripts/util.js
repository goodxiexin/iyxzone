function pluralize(str){
	if(str == 'status')
		return 'statuses';
	else
		return str + 's';
}

function limit_words_of_textarea(text_area, max, count_div){
  if(text_area.value.length > max){
    text_area.value = text_area.value.substring(0, max);
    return false;
  }
  $(count_div).innerHTML = text_area.value.length + "/" + max;
}

function set_comment_box(app, id, commentor_login, commentor_id){
	$(app + '_comment_content_' + id).value = "回复" + commentor_login + ":";
	$(app + '_comment_recipient_' + id).value = commentor_id;	
	$('add_' + app + '_comment_' + id).hide();
	$(app + '_comment_' + id).show();
	$(app + '_comment_content_' + id).focus();
	window.scrollTo(0, $(app + '_comment_content_' + id).positionedOffset().top);
}

function set_wall_box(commentor_login, commentor_id){
	$('comment_content').value = "回复" + commentor_login + ":";
	$('comment_recipient_id').value = commentor_id;
	$('comment_content').focus();
	window.scrollTo(0, $('comment_content').positionedOffset().top);
}

function validate_comment(content){
  if(content.value.length == 0){
    error('评论不能为空');
    return false;
  }
  if(content.value.length > 140){
    error('评论最多140个字节');
    return false;
  }
  return true;
}

function show_comment_form(app, id, login){
	$('add_' + app + '_comment_' + id).hide();
  $(app + '_comment_' + id).show();
  if(login != null)
    $(app + '_comment_content_' + id).value = "回复" + login + ":";
  $(app + '_comment_content_' + id).focus();
}

function hide_comment_form(app, id){
  $(app + '_comment_' + id).hide();
  $('add_' + app + '_comment_' + id).show();
}

function submit_comment(app, id){
  if(validate_comment($(app + '_comment_content_' + id))){
    new Ajax.Request('/' + pluralize(app) + '/' + id + '/comments', {
			method: 'post',
			parameters: $(app+'_comment_form_' + id).serialize()
		});
  }
}

function show_more_comments(app, id, link){
	link.innerHTML = '<img src="/images/loading.gif" />';
	new Ajax.Request('/' + pluralize(app) + '/' + id + '/comments', {
		method: 'get',
		onSuccess: function(transport){
			$(app + '_comments_' + id).innerHTML = transport.responseText;
		}
	});
}

function toggle_notification_menu(url){
	var notices = $('notices');
	var menu = $('notice_menu');
	var root = $('root_notice_menu');
	if(notices.innerHTML == ''){
		notices.innerHTML = "<img src='/images/loading.gif' />";
		new Ajax.Request(url, {
			method: 'get',
			onSuccess: function(transport){
				notices.innerHTML = transport.responseText;
			}
		});
		menu.setStyle({
			position: 'absolute',
			left: (root.positionedOffset().left) + 'px',
			top: (root.positionedOffset().top + root.getHeight()) + 'px',
			width: '200px',
			height: '200px',
			background: 'black',
			border: '2px solid #eeeeee',
		});
	}
	menu.toggle();
  
}

function toggle_setting_menu(url){
	var menu = $('setting_menu');
	var root = $('root_setting_menu');
	menu.setStyle({
		position: 'absolute',
		left: (root.positionedOffset().left) + 'px',
    top: (root.positionedOffset().top + root.getHeight() + 10) + 'px',
    width: '200px',
    height: '200px',
    background: 'black',
    border: '2px solid #eeeeee'});
	menu.toggle();
}

function play_video(video_id, video_link){
  $('video_' + video_id).innerHTML = video_link;
}

