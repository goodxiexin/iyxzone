module InPlaceEditorMacroHelpers
 
  DEFAULT_TEXT_AREA_OPTIONS = {
		:okControl => false, 
		:cancelControl => false, 
		:submitOnBlur => true, 
		:clickToEditText => "'点击更新'", 
		:savingText => "'正在更新...'"
  }

	def text_area_js field, url, empty_text, object_name, property, options
    function = "new Ajax.InPlaceTextArea("
    function << "'#{field}', "
    function << "'#{url}', "

    ajax_options = {:method => "'put'"}.merge(options[:ajax_options] || {})
 
    js_options = DEFAULT_TEXT_AREA_OPTIONS

    js_options['updateClass'] = %('#{object_name}')
    js_options['updateAttr'] = %('#{property}')
    js_options['emptyText'] = %('#{empty_text}')
    js_options['token'] = %('#{form_authenticity_token}')
    js_options['paramName'] = %('#{options[:param_name]}') if options[:param_name]
    js_options['cancelText'] = %('#{options[:cancel_text]}') if options[:cancel_text]
		js_options['cancelControl'] = options[:cancel_control] unless options[:cancel_control].nil?
    js_options['okText'] = %('#{options[:save_text]}') if options[:save_text]
		js_options['okControl'] = options[:ok_control] unless options[:ok_control].nil?
		js_options['submitOnBlur'] = options[:submit_on_blur] if options[:submit_on_blur]
    js_options['loadingText'] = %('#{options[:loading_text]}') if options[:loading_text]
    js_options['savingText'] = %('#{options[:saving_text]}') if options[:saving_text]
    js_options['rows'] = options[:rows] if options[:rows]
    js_options['cols'] = options[:cols] if options[:cols]
    js_options['size'] = options[:size] if options[:size]
    js_options['externalControl'] = "'#{options[:external_control]}'" if options[:external_control]
    js_options['loadTextURL'] = "'#{url_for(options[:load_text_url])}'" if options[:load_text_url]
    js_options['ajaxOptions'] = options_for_javascript ajax_options
    js_options['htmlResponse'] = !options[:script] if options[:script]
    js_options['clickToEditText'] = %('#{options[:click_to_edit_text]}') if options[:click_to_edit_text]
    js_options['textBetweenControls'] = %('#{options[:text_between_controls]}') if options[:text_between_controls]
		js_options['emptyText'] = "'#{options[:empty_text]}'" if options[:empty_text]
		js_options['emptyClassName'] = "'#{options[:empty_class_name]}'" if options[:empty_class_name]

    function << options_for_javascript(js_options) unless js_options.empty?
    
    function << ')'
 
    javascript_tag function
  end
  
  def in_place_text_area object, property, empty_text="", options={}
    object_name = object.class.to_s.underscore
		span_id = "#{object_name}_#{property}_#{object.to_param}"
		url = "/#{object_name.pluralize}/#{object.id}.json"
 
		return content_tag(:span, h(object.send(property)), {:id => span_id}) + text_area_js(span_id, url, empty_text, object_name, property, options)
  end

end
