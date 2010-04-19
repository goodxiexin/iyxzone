module EscapeHTML

  def self.included base
    base.extend(ClassMethods)
  end

  module ClassMethods
  
    def escape_html opts={}

      cattr_accessor :escape_html_opts

      self.escape_html_opts = opts

      before_save :escape_html

      include EscapeHTML::InstanceMethods

      extend EscapeHTML::SingletonMethods

    end
  
  end

  module InstanceMethods

  protected

    def escape_html
      opts = self.class.escape_html_opts
      return if opts[:sanitize].blank?
      (opts[:sanitize].is_a?(Array) ? opts[:sanitize] : [opts[:sanitize]]).each do |col|
        html = eval("self.#{col}")
        if !html.blank? 
          # escape html
          html = CGI.escapeHTML(html)
          # save
          eval("self.#{col} = html")
        end
      end
    end

  end

  module SingletonMethods
  end

end

ActiveRecord::Base.send(:include, EscapeHTML)
