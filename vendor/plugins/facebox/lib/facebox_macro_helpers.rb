module FaceboxMacroHelpers

  DEFAULT_FACEBOX_WIDTH = 350

  def facebox_button(text, url, options={})
    width = options.delete(:width) || DEFAULT_FACEBOX_WIDTH
    options = options.merge({
      :rel => 'facebox',
      :facebox_href => url,
      :facebox_width => width,
      :facebox_type => 'normal'})

    content_tag :button, text, options  
  end

  def facebox_link(text, url, options={})
    width = options.delete(:width) || DEFAULT_FACEBOX_WIDTH
    options = options.merge({
			:rel => 'facebox',
      :facebox_href => url,
      :facebox_width => width,
			:facebox_type => 'normal'})

    link_to text, "javascript:void(0)", options
  end

	def facebox_tip text, msg, options={}
    width = options.delete(:width) || DEFAULT_FACEBOX_WIDTH
		link_to_function text, "facebox.set_width(#{width});tip('#{msg}');", options
	end

	def facebox_notice text, msg, options={}
    width = options.delete(:width) || DEFAULT_FACEBOX_WIDTH
		link_to_function text, "facebox.set_width(#{width}); alert('#{msg}');", options
	end

  def facebox_button_confirm text, url, confirm_options={}, html_options={}
    width = html_options.delete(:width) || DEFAULT_FACEBOX_WIDTH
    confirm_msg = confirm_options[:msg] || "你确定吗"
    method = confirm_options[:method] || 'post'
    options = html_options.merge({
      :rel => 'facebox',
      :facebox_href => url, 
      :facebox_width => width, 
      :facebox_confirm => confirm_msg, 
      :facebox_method => method,
      :authenticity_token => form_authenticity_token,
      :facebox_type => 'confirm'})

    content_tag :button, text, options
  end

  def facebox_confirm text, url, confirm_options={}, html_options={}
    width = html_options.delete(:width) || DEFAULT_FACEBOX_WIDTH
    confirm_msg = confirm_options[:msg] || "你确定吗"
    method = confirm_options[:method] || 'post'
    options = html_options.merge({
			:rel => 'facebox',
      :facebox_href => url, 
      :facebox_width => width, 
			:facebox_confirm => confirm_msg, 
			:facebox_method => method,
			:authenticity_token => form_authenticity_token,
			:facebox_type => 'confirm'})

    link_to text, "javascript:void(0)", options
  end

	def facebox_confirm_with_validation(text, url, confirm_options={}, html_options={})
    width = html_options.delete(:width) || DEFAULT_FACEBOX_WIDTH
		confirm_msg = confirm_options[:msg] || "你确定吗"
		method = confirm_options[:method] || "post"
		options = html_options.merge({
			:rel => 'facebox',
      :facebox_href => url,
      :facebox_width => width, 
			:facebox_confirm => confirm_msg, 
			:facebox_method => method,
			:authenticity_token => form_authenticity_token, 
			:facebox_type => 'confirm_with_validation'})
		
		link_to text, "javascript:void(0)", options
	end

end
