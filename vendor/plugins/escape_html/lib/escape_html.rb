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
        # escape html
        eval("self.#{col}=CGI.escapeHTML(self.#{col})")
        # convert /n to <br/>
        eval("self.#{col}=self.#{col}.gsub '\n', '<br/>'")
      end
    end

  end

  module SingletonMethods
  end

end

ActiveRecord::Base.send(:include, EscapeHTML)
