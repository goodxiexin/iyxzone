require 'ferret'
require 'mmseg'

module Ferret::Analysis
  
  class RMMSegAnalyzer < Analyzer
  
    def initialize
    end
  
    def token_stream(field, text)
      Ferret::Analysis::LowerCaseFilter.new(RMMSegTokenizer.new(text))
    end

  end

  class RMMSegTokenizer < TokenStream
  
    def initialize text
      self.text = text
    end
  
    def next
      tok = @algor.next_token
      if !tok.nil?
        @token.text = tok.text
        @token.start = tok.start
        @token.end = tok.end
        @token
      end
    end
  
    def text
      @text
    end

    def text=(text)
      @token = Ferret::Analysis::Token.new("", 0, 0)
      @text = text
      @algor = RMMSeg::Algorithm.new(@text)
    end    

  end

end
