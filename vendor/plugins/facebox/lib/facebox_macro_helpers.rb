module FaceboxMacroHelpers

  def facebox_button(text, url, options={})
    width = options.delete(:width) || 'null'
    method = options.delete(:method) || 'get'
    button_to_function text, "Iyxzone.Facebox.link('#{url}', '#{method}', #{width});", options
  end

  def facebox_link(text, url, options={})
    width = options.delete(:width) || 'null'
    method = options.delete(:method) || 'get'
    link_to_function text, "Iyxzone.Facebox.link('#{url}', '#{method}', #{width});", options
  end

	def facebox_tip text, msg, options={}
    width = options.delete(:width) || 'null'
    title = options.delete(:title) || '提示'
    link_to_function text, "Iyxzone.Facebox.tip('#{msg}', '#{title}', #{width});", options
  end

	def facebox_notice text, msg, options={}
    width = options.delete(:width) || 'null'
    title = options.delete(:title) || '提示'
		link_to_function text, "Iyxzone.Facebox.notice('#{msg}', '#{title}', #{width});", options
  end

  def facebox_button_confirm text, url, confirm_options={}, html_options={}
    width = html_options.delete(:width) || "null"
    confirm_msg = confirm_options[:msg] || "你确定吗"
    method = confirm_options[:method] || 'post'
    title = confirm_options[:title] || '确认'
    button_to_function text, "Iyxzone.Facebox.confirm('#{confirm_msg}', '#{title}', #{width}, '#{url}', '#{form_authenticity_token}', '#{method}');", html_options
  end

  def facebox_confirm text, url, confirm_options={}, html_options={}
    width = html_options.delete(:width) || "null"
    confirm_msg = confirm_options[:msg] || "你确定吗"
    method = confirm_options[:method] || 'post'
    title = confirm_options[:title] || '确认'
    link_to_function text, "Iyxzone.Facebox.confirm('#{confirm_msg}', '#{title}', #{width}, '#{url}', '#{form_authenticity_token}', '#{method}');", html_options
  end

	def facebox_confirm_with_validation(text, url, confirm_options={}, html_options={})
    width = html_options.delete(:width) || "null"
		confirm_msg = confirm_options[:msg] || "你确定吗"
		method = confirm_options[:method] || "post"
    title = confirm_options[:title] || "确认"
		link_to_function text, "Iyxzone.Facebox.confirmWithValidation('#{confirm_msg}', '#{title}', #{width}, '#{url}', '#{form_authenticity_token}', '#{method}');", html_options
	end

end
