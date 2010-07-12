require 'ferret'
require 'mmseg'

module Ferret::Analysis
  
  class ChineseAnalyzer < Analyzer
  
    def initialize
      @mmseg = Mmseg.createSeg("#{RAILS_ROOT}/dict", "")
    end
  
    def token_stream(field, text)
      Ferret::Analysis::LowerCaseFilter.new(ChineseTokenizer.new(@mmseg, text))
    end

  end

  class ChineseTokenizer < TokenStream
  
    def initialize(mmseg, text)
      @mmseg = mmseg
      self.text = text
    end
  
    def next
      if @mmseg.next
        @token.text = @text[@mmseg.start...@mmseg.end]
        @token.start = @mmseg.start
        @token.end = @mmseg.end
        @token
      end
    end
  
    def text
      @text
    end

    def text=(text)
      @text = text
      @mmseg.setText(text)
      @token = Ferret::Analysis::Token.new("", 0, 0)
    end    

  end

end
