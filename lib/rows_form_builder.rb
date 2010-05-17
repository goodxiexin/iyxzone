class RowsFormBuilder < ActionView::Helpers::FormBuilder
  
  helpers = %w(file_field text_area check_box collection_select select)

  def calendar_date_select field, *args
    options = args.last.is_a?(Hash) ? args.pop : {}
    label_text = options.delete(:label)
    if label_text
      "<div class='rows s_clear'><div class='fldid'><label for='name'>开始时间：</label></div><div class='fldvalue'><div class='calendar-field'>#{@template.calendar_date_select @object_name, field, options}</div></div></div>"
    else
      "<div class='rows s_clear'><div class='fldvalue'><div class='calendar-field'>#{@template.calendar_date_select @object_name, field, options}</div></div></div>"
    end
  end

  def rows opts={}, &block
    block_html = block_given? ? @template.capture(&block) : ''
    label_text = opts.delete(:label)
    if label_text
      @template.concat "<div class='rows s_clear'><div class='fldid'>#{label_text}: </div><div class='fldvalue'>#{block_html}</div></div>"
    else
      @template.concat "<div class='rows s_clear'><div class='fldvalue'>#{block_html}</div></div>"
    end
  end

  def span text, *args
    options = args.last.is_a?(Hash) ? args.pop : {}
    label_text = options.delete(:label)
    if label_text
      "<div class='rows s_clear'><div class='fldid'>#{label_text}: </div><div class='fldvalue'><span>#{text}</span></div></div>"
    else
      "<div class='rows s_clear'><div class='fldvalue'><span>#{text}</span></div></div>"
    end
  end
 
  def text_field field, *args
    options = args.last.is_a?(Hash) ? args.pop : {}
    label_text = options.delete(:label)
    if label_text
      "<div class='rows s_clear'><div class='fldid'>#{label_text}: </div><div class='fldvalue'><div class='textfield'>#{super}</div></div></div>"
    else
      "<div class='rows s_clear'><div class='fldvalue'><div class='textfield'>#{super}</div></div></div>"
    end
  end

  def submit button_options
    button_html = 
      button_options.map do |button_text, button_attributes|
        "<span class='button03 w-l'><span>#{@template.content_tag :button, button_text, button_attributes}</span></span>"
      end.join

    "<div class='rows s_clear'><div class='fldid'>&nbsp;</div><div class='fldvalue'>#{button_html}</div></div>"
  end

  def z_submit options
    submit_opts = options.delete(:submit).merge({:type => 'submit'})
    submit_html = 
      if submit_opts.blank?
        ''
      elsif submit_opts.is_a? Hash
        "<span class='button'><span>#{@template.content_tag :button, submit_opts.delete(:text), submit_opts}</span></span>"
      elsif submit_opts.is_a? Array
        submit_opts.map{|opts| "<span class='button'><span>#{@template.content_tag :button, opts.delete(:text), opts}</span></span>"}.join
      end

    cancel_opts = options.delete(:cancel)
    cancel_html = 
      if cancel_opts.blank?
        ''
      elsif cancel_opts.is_a? Hash
        "<span class='button button-gray'><span>#{@template.content_tag :button, cancel_opts.delete(:text), cancel_opts.merge({:type => 'button'})}</span></span>"
      elsif cancel_opts.is_a? Array
        canel_opts.map{|opts| "<span class='button button-gray'><span>#{@template.content_tag :button, cancel_opts.delete(:text), cancel_opts.merge({:type => 'button'})}</span></span>"}.join
      end

    "<div class='z-submit s_clear space'><table class='center' cellpadding='0'><tr><td>#{submit_html}#{cancel_html}</td></tr></table></div>"
  end

  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.last.is_a?(Hash) ? args.pop : {}
      label_text = options.delete(:label)
      if label_text
        "<div class='rows s_clear'><div class='fldid'>#{label_text}: </div><div class='fldvalue'>#{super}</div></div>"
      else
        "<div class='rows s_clear'><div class='fldvalue'>#{super}</div></div>"
      end
    end
  end

end

