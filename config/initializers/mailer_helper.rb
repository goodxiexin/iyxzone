module MailerHelper

  def link_to content, src, opts
    "<a src=\"#{SITE_URL}/#{src}\" target=\"_blank\" #{opts.map{|k,v| "#{k}=\"#{v}\""}.join(' ')} >#{content}</a>"
  end

  def image_tag src, opts
    "<img src=\"#{SITE_URL}#{src}\" #{opts.map{|k,v| "#{k}=\"#{v}\""}.join(' ')} />"
  end

  def td_header text
    "<a href='javascript:void(0)' style='color:#333;text-decoration:none;font-size:12px;width:260px;height:22px;line-height:22px;overflow:hidden;text-overflow:ellipsis;-o-text-overflow:ellipsis;word-wrap:normal;white-space:nowrap;word-break:keep-all;display:block'>#{text}</a>"
  end

end
