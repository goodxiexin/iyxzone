require 'rubygems'
require 'ferret'

class ChineseAnalyzer < Ferret::Analysis::Analyzer
  
  def initialize
    # ( ) [ ] 被自动省略
    @stop_words = [",", "，", ".", "。", "\"", "\'", "“", "”", "‘", "’"] 
  end
      
  def token_stream(field, text)
    Ferret::Analysis::StopFilter.new(Ferret::Analysis::LowerCaseFilter.new(ChineseTokenizer.new(text)), @stop_words) 
  end

end

class ChineseTokenizer < ::Ferret::Analysis::TokenStream
      
  def initialize(str)
    self.text = str
  end

  def next
    tok = @algor.next_token
    if tok
      @token.text = tok.text
      @token.start = tok.start
      @token.end = tok.end
      @token.cixing = tok.cixing
      @token.freq = tok.freq
      return @token
    else
      nil
    end 
  end
      
  def text
    @text
  end

  def text=(str)
    @token = ChineseToken.new("", 0, 0, 0, 0)
    @text = str
    @algor = RMMSeg::Algorithm.new(@text)
  end
  
end

class ChineseToken < ::Ferret::Analysis::Token

  attr_accessor :cixing, :freq
      
  # 没这个
  # 会导致struct的内存便宜两不对，然后运行有segment fault
  def initialize text, s, e, c, f
    super text, s, e
    @cixing = c
    @freq = f
  end

end
