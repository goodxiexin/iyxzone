/*
 * hack了那煞笔的InPlaceEditor, 实在是不怎么好用，迫不得已
 */
Ajax.InPlaceTextArea = Class.create(Ajax.InPlaceEditor, {
 
  initialize: function($super, element, url, options){
    options = Object.extend({
      "emptyText" : "点击编辑...",
      "emptyClassName" : "inplaceeditor-empty",
      "htmlResponse" : false
    }, options || {});

    options.textAreaStyle = {"width" : '90%'};

    options.callback = this.callbackHandler.bind(this);
    options.onComplete = this.onCompleteHandler.bind(this);

    $super(element, url, options);

    //this.checkEmpty();
    this.checkElement();
  },

  checkElement: function(){
    if(this.element.innerHTML.length == 0){
      this.element.appendChild(new Element("span", {"className" : this.options.emptyClassName}).update(this.options.emptyText));
    }else{
//      this.element.innerHTML = this.element.innerHTML.replace(/\n/g, '<br/>');
      this.element.update( this.element.innerHTML.replace(/\n/g, '<br/>'));
    }
  },
 
  getText: function($super) {
    if (empty_span = this.element.select("." + this.options.emptyClassName).first()) {
      empty_span.remove();
    }
//    this.element.innerHTML = this.element.innerHTML.replace(/<br>/g, '\n'); 
    this.element.update( this.element.innerHTML.replace(/<br>/g, '\n')); 
    return $super();
  },

  callbackHandler: function(form, value){
    var param = this.options.paramName;
    if((param == null || param == 'value') && this.options.updateClass && this.options.updateAttr){
      param = (this.options.updateClass + "[" + this.options.updateAttr + "]");
    }
    return param + "=" + value + "&authenticity_token=" + encodeURIComponent(this.options.token);
  },

  onCompleteHandler: function(transport, element){
    if (transport && transport.status == 200) {
      new Effect.Highlight(element.id, {"startcolor": "#00ffff"});
      var json = transport.responseText.evalJSON();
//      element.innerHTML = eval("json." + this.options.updateClass + "." + this.options.updateAttr);
      element.update( eval("json." + this.options.updateClass + "." + this.options.updateAttr));
      this.checkElement();
    }
  }, 

  createEditField: function(){
    var text = (this.options.loadTextURL ? this.options.loadingText : this.getText());
    var fld;

		var div_decorator = document.createElement("div");
//		div_decorator.setStyle(this.options.textAreaStyle);

    fld = document.createElement('textarea');
    fld.name = this.options.paramName;
		Element.extend(fld);
		fld.setStyle(this.options.textAreaStyle);
    fld.value = text; // No HTML breaks conversion anymore
    fld.className = 'editor_field';
    if (this.options.submitOnBlur)
      fld.onblur = this._boundSubmitHandler;
    this._controls.editor = fld;

		div_decorator.appendChild(fld);
		this._controls.decorator = div_decorator;

    if (this.options.loadTextURL)
      this.loadExternalText();
   // this._form.appendChild(this._controls.editor);
    this._form.appendChild(this._controls.decorator);
		//$('editor_field').setStyle(this.options.textAreaStyle);

  }

});
