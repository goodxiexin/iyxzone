function less_json_eval(json){return eval('(' +  json + ')')}  

function jq_defined(){return typeof(jQuery) != "undefined"}

function less_get_params(obj){
   
  if (jq_defined()) { return obj }
  if (obj == null) {return '';}
  var s = [];
  for (prop in obj){
    s.push(prop + "=" + obj[prop]);
  }
  return s.join('&') + '';
}

function less_merge_objects(a, b){
   
  if (b == null) {return a;}
  z = new Object;
  for (prop in a){z[prop] = a[prop]}
  for (prop in b){z[prop] = b[prop]}
  return z;
}

function less_ajax(url, verb, params, options){
   
  if (verb == undefined) {verb = 'get';}
  var res;
  if (jq_defined()){
    v = verb.toLowerCase() == 'get' ? 'GET' : 'POST'
    if (verb.toLowerCase() == 'get' || verb.toLowerCase() == 'post'){p = less_get_params(params);}
    else{p = less_get_params(less_merge_objects({'_method': verb.toLowerCase()}, params))} 
     
     
    res = jQuery.ajax(less_merge_objects({async:false, url: url, type: v, data: p}, options)).responseText;
  } else {  
    new Ajax.Request(url, less_merge_objects({asynchronous: false, method: verb, parameters: less_get_params(params), onComplete: function(r){res = r.responseText;}}, options));
  }
  if (url.indexOf('.json') == url.length-5){ return less_json_eval(res);}
  else {return res;}
}
function less_ajaxx(url, verb, params, options){
   
  if (verb == undefined) {verb = 'get';}
  if (jq_defined()){
    v = verb.toLowerCase() == 'get' ? 'GET' : 'POST'
    if (verb.toLowerCase() == 'get' || verb.toLowerCase() == 'post'){p = less_get_params(params);}
    else{p = less_get_params(less_merge_objects({'_method': verb.toLowerCase()}, params))} 
     
     
    jQuery.ajax(less_merge_objects({ url: url, type: v, data: p, complete: function(r){eval(r.responseText)}}, options));
  } else {  
    new Ajax.Request(url, less_merge_objects({method: verb, parameters: less_get_params(params), onComplete: function(r){eval(r.responseText);}}, options));
  }
}
function less_check_parameter(param) {
  if (param === undefined) {
    param = '';
  }
  return param;
}
function less_check_format(param) {
  if (param === undefined) {
    param = '';
  } else {
    param = '.'+ param;
  }
  return param
}
function users_path(format, verb){ format = less_check_format(format); return '/users' + format + '';}
function users_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/users' + format + '', verb, params, options);}
function users_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/users' + format + '', verb, params, options);}
function new_user_path(format, verb){ format = less_check_format(format); return '/users/new' + format + '';}
function new_user_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/users/new' + format + '', verb, params, options);}
function new_user_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/users/new' + format + '', verb, params, options);}
function edit_user_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/users/' + id + '/edit' + format + '';}
function edit_user_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/users/' + id + '/edit' + format + '', verb, params, options);}
function edit_user_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/users/' + id + '/edit' + format + '', verb, params, options);}
function user_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/users/' + id + '' + format + '';}
function user_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/users/' + id + '' + format + '', verb, params, options);}
function user_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/users/' + id + '' + format + '', verb, params, options);}
function sessions_path(format, verb){ format = less_check_format(format); return '/sessions' + format + '';}
function sessions_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/sessions' + format + '', verb, params, options);}
function sessions_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/sessions' + format + '', verb, params, options);}
function new_session_path(format, verb){ format = less_check_format(format); return '/sessions/new' + format + '';}
function new_session_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/sessions/new' + format + '', verb, params, options);}
function new_session_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/sessions/new' + format + '', verb, params, options);}
function edit_session_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/sessions/' + id + '/edit' + format + '';}
function edit_session_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/sessions/' + id + '/edit' + format + '', verb, params, options);}
function edit_session_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/sessions/' + id + '/edit' + format + '', verb, params, options);}
function session_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/sessions/' + id + '' + format + '';}
function session_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/sessions/' + id + '' + format + '', verb, params, options);}
function session_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/sessions/' + id + '' + format + '', verb, params, options);}
function root_path(verb){  return '';}
function root_ajax(verb, params, options){  return less_ajax('', verb, params, options);}
function root_ajaxx(verb, params, options){  return less_ajaxx('', verb, params, options);}
function signup_path(verb){  return '/signup';}
function signup_ajax(verb, params, options){  return less_ajax('/signup', verb, params, options);}
function signup_ajaxx(verb, params, options){  return less_ajaxx('/signup', verb, params, options);}
function login_path(verb){  return '/login';}
function login_ajax(verb, params, options){  return less_ajax('/login', verb, params, options);}
function login_ajaxx(verb, params, options){  return less_ajaxx('/login', verb, params, options);}
function logout_path(verb){  return '/logout';}
function logout_ajax(verb, params, options){  return less_ajax('/logout', verb, params, options);}
function logout_ajaxx(verb, params, options){  return less_ajaxx('/logout', verb, params, options);}
function activate_path(activation_code, verb){ activation_code = less_check_parameter(activation_code); return '/activate/' + activation_code + '';}
function activate_ajax(activation_code, verb, params, options){ activation_code = less_check_parameter(activation_code); return less_ajax('/activate/' + activation_code + '', verb, params, options);}
function activate_ajaxx(activation_code, verb, params, options){ activation_code = less_check_parameter(activation_code); return less_ajaxx('/activate/' + activation_code + '', verb, params, options);}
function forgot_password_path(verb){  return '/forgot_password';}
function forgot_password_ajax(verb, params, options){  return less_ajax('/forgot_password', verb, params, options);}
function forgot_password_ajaxx(verb, params, options){  return less_ajaxx('/forgot_password', verb, params, options);}
function reset_password_path(password_reset_code, verb){ password_reset_code = less_check_parameter(password_reset_code); return '/reset_password/' + password_reset_code + '';}
function reset_password_ajax(password_reset_code, verb, params, options){ password_reset_code = less_check_parameter(password_reset_code); return less_ajax('/reset_password/' + password_reset_code + '', verb, params, options);}
function reset_password_ajaxx(password_reset_code, verb, params, options){ password_reset_code = less_check_parameter(password_reset_code); return less_ajaxx('/reset_password/' + password_reset_code + '', verb, params, options);}
function home_path(verb){  return '/home';}
function home_ajax(verb, params, options){  return less_ajax('/home', verb, params, options);}
function home_ajaxx(verb, params, options){  return less_ajaxx('/home', verb, params, options);}
function profiles_path(format, verb){ format = less_check_format(format); return '/profiles' + format + '';}
function profiles_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/profiles' + format + '', verb, params, options);}
function profiles_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/profiles' + format + '', verb, params, options);}
function new_profile_path(format, verb){ format = less_check_format(format); return '/profiles/new' + format + '';}
function new_profile_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/profiles/new' + format + '', verb, params, options);}
function new_profile_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/profiles/new' + format + '', verb, params, options);}
function edit_profile_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/profiles/' + id + '/edit' + format + '';}
function edit_profile_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/profiles/' + id + '/edit' + format + '', verb, params, options);}
function edit_profile_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/profiles/' + id + '/edit' + format + '', verb, params, options);}
function profile_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/profiles/' + id + '' + format + '';}
function profile_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/profiles/' + id + '' + format + '', verb, params, options);}
function profile_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/profiles/' + id + '' + format + '', verb, params, options);}
function profile_comments_path(profile_id, format, verb){ profile_id = less_check_parameter(profile_id);format = less_check_format(format); return '/profiles/' + profile_id + '/comments' + format + '';}
function profile_comments_ajax(profile_id, format, verb, params, options){ profile_id = less_check_parameter(profile_id);format = less_check_format(format); return less_ajax('/profiles/' + profile_id + '/comments' + format + '', verb, params, options);}
function profile_comments_ajaxx(profile_id, format, verb, params, options){ profile_id = less_check_parameter(profile_id);format = less_check_format(format); return less_ajaxx('/profiles/' + profile_id + '/comments' + format + '', verb, params, options);}
function new_profile_comment_path(profile_id, format, verb){ profile_id = less_check_parameter(profile_id);format = less_check_format(format); return '/profiles/' + profile_id + '/comments/new' + format + '';}
function new_profile_comment_ajax(profile_id, format, verb, params, options){ profile_id = less_check_parameter(profile_id);format = less_check_format(format); return less_ajax('/profiles/' + profile_id + '/comments/new' + format + '', verb, params, options);}
function new_profile_comment_ajaxx(profile_id, format, verb, params, options){ profile_id = less_check_parameter(profile_id);format = less_check_format(format); return less_ajaxx('/profiles/' + profile_id + '/comments/new' + format + '', verb, params, options);}
function edit_profile_comment_path(profile_id, id, format, verb){ profile_id = less_check_parameter(profile_id);id = less_check_parameter(id);format = less_check_format(format); return '/profiles/' + profile_id + '/comments/' + id + '/edit' + format + '';}
function edit_profile_comment_ajax(profile_id, id, format, verb, params, options){ profile_id = less_check_parameter(profile_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/profiles/' + profile_id + '/comments/' + id + '/edit' + format + '', verb, params, options);}
function edit_profile_comment_ajaxx(profile_id, id, format, verb, params, options){ profile_id = less_check_parameter(profile_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/profiles/' + profile_id + '/comments/' + id + '/edit' + format + '', verb, params, options);}
function profile_comment_path(profile_id, id, format, verb){ profile_id = less_check_parameter(profile_id);id = less_check_parameter(id);format = less_check_format(format); return '/profiles/' + profile_id + '/comments/' + id + '' + format + '';}
function profile_comment_ajax(profile_id, id, format, verb, params, options){ profile_id = less_check_parameter(profile_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/profiles/' + profile_id + '/comments/' + id + '' + format + '', verb, params, options);}
function profile_comment_ajaxx(profile_id, id, format, verb, params, options){ profile_id = less_check_parameter(profile_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/profiles/' + profile_id + '/comments/' + id + '' + format + '', verb, params, options);}
function hot_blogs_path(format, verb){ format = less_check_format(format); return '/blogs/hot' + format + '';}
function hot_blogs_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/blogs/hot' + format + '', verb, params, options);}
function hot_blogs_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/blogs/hot' + format + '', verb, params, options);}
function recent_blogs_path(format, verb){ format = less_check_format(format); return '/blogs/recent' + format + '';}
function recent_blogs_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/blogs/recent' + format + '', verb, params, options);}
function recent_blogs_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/blogs/recent' + format + '', verb, params, options);}
function blogs_path(format, verb){ format = less_check_format(format); return '/blogs' + format + '';}
function blogs_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/blogs' + format + '', verb, params, options);}
function blogs_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/blogs' + format + '', verb, params, options);}
function new_blog_path(format, verb){ format = less_check_format(format); return '/blogs/new' + format + '';}
function new_blog_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/blogs/new' + format + '', verb, params, options);}
function new_blog_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/blogs/new' + format + '', verb, params, options);}
function edit_blog_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/blogs/' + id + '/edit' + format + '';}
function edit_blog_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/blogs/' + id + '/edit' + format + '', verb, params, options);}
function edit_blog_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/blogs/' + id + '/edit' + format + '', verb, params, options);}
function blog_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/blogs/' + id + '' + format + '';}
function blog_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/blogs/' + id + '' + format + '', verb, params, options);}
function blog_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/blogs/' + id + '' + format + '', verb, params, options);}
function blog_comments_path(blog_id, format, verb){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return '/blogs/' + blog_id + '/comments' + format + '';}
function blog_comments_ajax(blog_id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return less_ajax('/blogs/' + blog_id + '/comments' + format + '', verb, params, options);}
function blog_comments_ajaxx(blog_id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return less_ajaxx('/blogs/' + blog_id + '/comments' + format + '', verb, params, options);}
function new_blog_comment_path(blog_id, format, verb){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return '/blogs/' + blog_id + '/comments/new' + format + '';}
function new_blog_comment_ajax(blog_id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return less_ajax('/blogs/' + blog_id + '/comments/new' + format + '', verb, params, options);}
function new_blog_comment_ajaxx(blog_id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return less_ajaxx('/blogs/' + blog_id + '/comments/new' + format + '', verb, params, options);}
function edit_blog_comment_path(blog_id, id, format, verb){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return '/blogs/' + blog_id + '/comments/' + id + '/edit' + format + '';}
function edit_blog_comment_ajax(blog_id, id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/blogs/' + blog_id + '/comments/' + id + '/edit' + format + '', verb, params, options);}
function edit_blog_comment_ajaxx(blog_id, id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/blogs/' + blog_id + '/comments/' + id + '/edit' + format + '', verb, params, options);}
function blog_comment_path(blog_id, id, format, verb){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return '/blogs/' + blog_id + '/comments/' + id + '' + format + '';}
function blog_comment_ajax(blog_id, id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/blogs/' + blog_id + '/comments/' + id + '' + format + '', verb, params, options);}
function blog_comment_ajaxx(blog_id, id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/blogs/' + blog_id + '/comments/' + id + '' + format + '', verb, params, options);}
function blog_digs_path(blog_id, format, verb){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return '/blogs/' + blog_id + '/digs' + format + '';}
function blog_digs_ajax(blog_id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return less_ajax('/blogs/' + blog_id + '/digs' + format + '', verb, params, options);}
function blog_digs_ajaxx(blog_id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return less_ajaxx('/blogs/' + blog_id + '/digs' + format + '', verb, params, options);}
function new_blog_dig_path(blog_id, format, verb){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return '/blogs/' + blog_id + '/digs/new' + format + '';}
function new_blog_dig_ajax(blog_id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return less_ajax('/blogs/' + blog_id + '/digs/new' + format + '', verb, params, options);}
function new_blog_dig_ajaxx(blog_id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return less_ajaxx('/blogs/' + blog_id + '/digs/new' + format + '', verb, params, options);}
function edit_blog_dig_path(blog_id, id, format, verb){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return '/blogs/' + blog_id + '/digs/' + id + '/edit' + format + '';}
function edit_blog_dig_ajax(blog_id, id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/blogs/' + blog_id + '/digs/' + id + '/edit' + format + '', verb, params, options);}
function edit_blog_dig_ajaxx(blog_id, id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/blogs/' + blog_id + '/digs/' + id + '/edit' + format + '', verb, params, options);}
function blog_dig_path(blog_id, id, format, verb){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return '/blogs/' + blog_id + '/digs/' + id + '' + format + '';}
function blog_dig_ajax(blog_id, id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/blogs/' + blog_id + '/digs/' + id + '' + format + '', verb, params, options);}
function blog_dig_ajaxx(blog_id, id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/blogs/' + blog_id + '/digs/' + id + '' + format + '', verb, params, options);}
function blog_tags_path(blog_id, format, verb){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return '/blogs/' + blog_id + '/tags' + format + '';}
function blog_tags_ajax(blog_id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return less_ajax('/blogs/' + blog_id + '/tags' + format + '', verb, params, options);}
function blog_tags_ajaxx(blog_id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return less_ajaxx('/blogs/' + blog_id + '/tags' + format + '', verb, params, options);}
function new_blog_tag_path(blog_id, format, verb){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return '/blogs/' + blog_id + '/tags/new' + format + '';}
function new_blog_tag_ajax(blog_id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return less_ajax('/blogs/' + blog_id + '/tags/new' + format + '', verb, params, options);}
function new_blog_tag_ajaxx(blog_id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);format = less_check_format(format); return less_ajaxx('/blogs/' + blog_id + '/tags/new' + format + '', verb, params, options);}
function edit_blog_tag_path(blog_id, id, format, verb){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return '/blogs/' + blog_id + '/tags/' + id + '/edit' + format + '';}
function edit_blog_tag_ajax(blog_id, id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/blogs/' + blog_id + '/tags/' + id + '/edit' + format + '', verb, params, options);}
function edit_blog_tag_ajaxx(blog_id, id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/blogs/' + blog_id + '/tags/' + id + '/edit' + format + '', verb, params, options);}
function blog_tag_path(blog_id, id, format, verb){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return '/blogs/' + blog_id + '/tags/' + id + '' + format + '';}
function blog_tag_ajax(blog_id, id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/blogs/' + blog_id + '/tags/' + id + '' + format + '', verb, params, options);}
function blog_tag_ajaxx(blog_id, id, format, verb, params, options){ blog_id = less_check_parameter(blog_id);id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/blogs/' + blog_id + '/tags/' + id + '' + format + '', verb, params, options);}
function relative_blogs_path(format, verb){ format = less_check_format(format); return '/relative_blogs' + format + '';}
function relative_blogs_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/relative_blogs' + format + '', verb, params, options);}
function relative_blogs_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/relative_blogs' + format + '', verb, params, options);}
function new_relative_blog_path(format, verb){ format = less_check_format(format); return '/relative_blogs/new' + format + '';}
function new_relative_blog_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/relative_blogs/new' + format + '', verb, params, options);}
function new_relative_blog_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/relative_blogs/new' + format + '', verb, params, options);}
function edit_relative_blog_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/relative_blogs/' + id + '/edit' + format + '';}
function edit_relative_blog_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/relative_blogs/' + id + '/edit' + format + '', verb, params, options);}
function edit_relative_blog_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/relative_blogs/' + id + '/edit' + format + '', verb, params, options);}
function relative_blog_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/relative_blogs/' + id + '' + format + '';}
function relative_blog_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/relative_blogs/' + id + '' + format + '', verb, params, options);}
function relative_blog_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/relative_blogs/' + id + '' + format + '', verb, params, options);}
function friend_blogs_path(format, verb){ format = less_check_format(format); return '/friend_blogs' + format + '';}
function friend_blogs_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/friend_blogs' + format + '', verb, params, options);}
function friend_blogs_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/friend_blogs' + format + '', verb, params, options);}
function new_friend_blog_path(format, verb){ format = less_check_format(format); return '/friend_blogs/new' + format + '';}
function new_friend_blog_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/friend_blogs/new' + format + '', verb, params, options);}
function new_friend_blog_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/friend_blogs/new' + format + '', verb, params, options);}
function edit_friend_blog_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/friend_blogs/' + id + '/edit' + format + '';}
function edit_friend_blog_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/friend_blogs/' + id + '/edit' + format + '', verb, params, options);}
function edit_friend_blog_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/friend_blogs/' + id + '/edit' + format + '', verb, params, options);}
function friend_blog_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/friend_blogs/' + id + '' + format + '';}
function friend_blog_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/friend_blogs/' + id + '' + format + '', verb, params, options);}
function friend_blog_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/friend_blogs/' + id + '' + format + '', verb, params, options);}
function drafts_path(format, verb){ format = less_check_format(format); return '/drafts' + format + '';}
function drafts_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/drafts' + format + '', verb, params, options);}
function drafts_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/drafts' + format + '', verb, params, options);}
function new_draft_path(format, verb){ format = less_check_format(format); return '/drafts/new' + format + '';}
function new_draft_ajax(format, verb, params, options){ format = less_check_format(format); return less_ajax('/drafts/new' + format + '', verb, params, options);}
function new_draft_ajaxx(format, verb, params, options){ format = less_check_format(format); return less_ajaxx('/drafts/new' + format + '', verb, params, options);}
function edit_draft_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/drafts/' + id + '/edit' + format + '';}
function edit_draft_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/drafts/' + id + '/edit' + format + '', verb, params, options);}
function edit_draft_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/drafts/' + id + '/edit' + format + '', verb, params, options);}
function draft_path(id, format, verb){ id = less_check_parameter(id);format = less_check_format(format); return '/drafts/' + id + '' + format + '';}
function draft_ajax(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajax('/drafts/' + id + '' + format + '', verb, params, options);}
function draft_ajaxx(id, format, verb, params, options){ id = less_check_parameter(id);format = less_check_format(format); return less_ajaxx('/drafts/' + id + '' + format + '', verb, params, options);}
