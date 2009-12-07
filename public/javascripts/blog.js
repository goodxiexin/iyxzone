BlogBuilder = Class.create({

  initialize: function(tag_builder){
    this.draft_id = 0;
    this.editor = new nicEditor({iconsPath:'/images/nicEditor/icons.gif'}).panelInstance('blog_content');
    this.form = $('blog_form');
    this.title = $('blog_title');
    this.privilege = $('blog_privilege');
    this.category = $('blog_game_id');
    this.tag_builder = tag_builder;
  },

  valid: function(){
		if(this.privilege.value == ''){
			error("清选择权限");
			return false;
		}
    if(this.category.value == ''){
      error("请选择游戏类别");
      return false;
    }
    if(this.title.value == ''){
      error("标题不能为空");
      return false;
    }
    if(this.title.value.length > 100){
      error("标题最长100个字符");
      return false;
    }
    return true;
  },

  // a hook for server to set draft id
  set_draft_id: function(draft_id){
    this.draft_id = draft_id;
  },

  // to fix nicEditor bug
  save_content: function(){
    for(var i=0;i<this.editor.nicInstances.length;i++){
      this.editor.nicInstances[i].saveContent();
    }
  },

  submit_form: function(){
    var new_tags = this.tag_builder.get_new_tags();
    for(var i=0;i<new_tags.length;i++){
      var el = new Element("input", {type: 'hidden', value: new_tags[i], id: 'blog[tags][]', name: 'blog[tags][]'});
      this.form.appendChild(el);
    }
    this.save_content();
    this.form.submit();
  },

  save_blog: function(){
    if(this.valid()){
      if(this.draft_id == 0){
        this.submit_form();
      }else{
        this.form.action = "/blogs/" + this.draft_id;
        this.form.method = 'put';
        this.submit_form();
      }
    }
  },

  save_draft: function(){
    if(this.valid()){
      this.save_content();
      if(this.draft_id == 0){
        new Ajax.Request('/drafts', {method: 'post', parameters: this.form.serialize(true)});
      }else{
        new Ajax.Request('/drafts/' + this.draft_id, {method: 'put', parameters: this.form.serialize(true)});
      }
    }
  },

  update_blog: function(){
    if(this.valid()){
      this.submit_form();
    }
  },

  update_draft: function(draft_id){
    if(this.valid()){
      this.save_content();
      new Ajax.Request('/drafts/' + draft_id, {method: 'put', parameters: this.form.serialize(true)});
    }
  }

});
