/**
 * TODO:
 * 点击后如果不更新返回后text消失
 */

Ajax.InPlaceEditorWithEmptyText = Class.create(Ajax.InPlaceEditor, {
 
  initialize: function($super, element, url, options){
    if(!options.emptyText)
      options.emptyText = "点击编辑...";
    if(!options.emptyClassName)
      options.emptyClassName = 'inplaceeditor-empty';
    $super(element, url, options);
    this.checkEmpty();
  },

  checkEmpty: function(){
    if (this.element.innerHTML.length == 0 && this.options.emptyText) {
      this.element.appendChild(new Element('span', { className : this.options.emptyClassName }).update(this.options.emptyText));
    }
  },

  getText: function($super){
    if (empty_span = this.element.select("." + this.options.emptyClassName).first()) {
      empty_span.remove();
    }
		this.element.innerHTML = this.element.innerHTML.replace(/<br>/g, '\n'); // a hack, in order to support multiple lines, i dont know why it becomes <br> here, i thought it should be <br/>...
    return $super();
  },

  onComplete : function($super, transport) {
    this.checkEmpty();
    return $super(transport);
  }

});
