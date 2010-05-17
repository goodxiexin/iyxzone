class ConfigFormBuilder < ActionView::Helpers::FormBuilder

  def check_box field, *args
    options = args.last.is_a?(Hash) ? args.pop : {}
    label_text = options.delete(:label)
    "<div class='rows s_clear'><div class='fldid'></div><div class='fldstatus fldstatus-lock'></div><div class='fldvalue'>#{super}#{label_text}</div></div>"
  end
  
  def select field, *args
    options = args.last.is_a?(Hash) ? args.pop : {}
    label_text = options.delete(:label)
    if label_text
      "<div class='rows s_clear'><div class='fldid'>#{label_text}: </div><div class='fldstatus fldstatus-lock'></div><div class='fldvalue'>#{super}</div></div>"
    else
      "<div class='rows s_clear'><div class='fldstatus fldstatus-lock'></div><div class='fldvalue'>#{super}</div></div>"
    end
  end

  def span text, *args
    options = args.last.is_a?(Hash) ? args.pop : {}
    label_text = options.delete(:label)
    if label_text
      "<div class='rows s_clear'><div class='fldid'>#{label_text}: </div><div class='fldstatus fldstatus-lock'></div><div class='fldvalue'><span>#{text}</span></div></div>"
    else
      "<div class='rows s_clear'><div class='fldstatus fldstatus-lock'></div><div class='fldvalue'><span>#{text}</span></div></div>"
    end
  end

  def submit options
    submit_opts = options.delete(:submit)
    submit_html = 
      if submit_opts.blank?
        ''
      elsif submit_opts.is_a? Hash
        "<span class='button'><span>#{@template.content_tag :button, submit_opts.delete(:text), submit_opts}</span></span>"
      end

    cancel_opts = options.delete(:cancel)
    cancel_html = 
      if cancel_opts.blank?
        ''
      elsif cancel_opts.is_a? Hash
        "<span class='button button-gray'><span>#{@template.content_tag :button, cancel_opts.delete(:text), cancel_opts.merge({:type => 'button'})}</span></span>"
      end

    "<div class='buttons s_clear'><div class='fldid'>&nbsp;</div><div class='fldstatus fldstatus-none'></div><div class='fldvalue'>#{submit_html}#{cancel_html}</div></div>"
  end

end

