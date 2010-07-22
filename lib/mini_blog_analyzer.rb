require 'rubygems'
require 'ferret'

class MiniBlogAnalyzer < Ferret::Analysis::Analyzer
      
  def initialize
  end
      
  def token_stream(field, text)
    Ferret::Analysis::LowerCaseFilter.new(Tokenizer.new(text))
  end

end

class Tokenizer < ::Ferret::Analysis::TokenStream
      
  def initialize(str)
    self.text = str
  end

  def next
    while true
      tok = @algor.next_token
      if tok.nil?
        return nil
      else
        #if tok.cx_game or ((tok.cx_unkown or tok.cx_noun) and tok.text.size > 3 and tok.freq < 5000000)
          @token.text = tok.text
          @token.start = tok.start
          @token.end = tok.end
          @token.cixing = tok.cixing
          @token.freq = tok.freq
          return @token
        #end
      end
    end
  end
      
  def text
    @text
  end

  def text=(str)
    @token = CToken.new("", 0, 0, 0, 0)
    @text = str
    @algor = RMMSeg::Algorithm.new(@text)
  end
  
end

class CToken < ::Ferret::Analysis::Token

  attr_accessor :cixing, :freq
      
  def initialize text, s, e, c, f
    super text, s, e
    @cixing = c
    @freq = f
  end

end
