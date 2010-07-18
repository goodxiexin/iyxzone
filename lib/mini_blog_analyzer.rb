require 'rubygems'
require 'ferret'

    class MiniBlogAnalyzer < ::Ferret::Analysis::Analyzer
      
      # Construct an Analyzer. Optional block can be used to
      # add more +TokenFilter+s. e.g.
      #
      #   analyzer = RMMSeg::Ferret::Analyzer.new { |tokenizer|
      #     Ferret::Analysis::LowerCaseFilter.new(tokenizer)
      #   }
      #
      def initialize(&brk)
        @brk = brk
      end
      
      def token_stream(field, text)
        t = Tokenizer.new(text)
        if @brk
          @brk.call(t)
        else
          t
        end
      end
    end

    # The Tokenizer tokenize text with RMMSeg::Algorithm.
    class Tokenizer < ::Ferret::Analysis::TokenStream
      # Create a new Tokenizer to tokenize +text+
      def initialize(str)
        self.text = str
      end

      # Get next token
      def next
        while true
          tok = @algor.next_token
          if tok.nil?
            return nil
          else
            if (tok.cixing == 65536 or tok.cixing == 1 or tok.cixing == 0) and tok.text.size > 3 and tok.freq < 250000000
              @token.text = tok.text
              @token.start = tok.start
              @token.end = tok.end
              @token.cixing = tok.cixing
              @token.freq = tok.freq
              return @token
            end
          end
        end
      end
      
      # Get the text being tokenized
      def text
        @text
      end

      # Set the text to be tokenized
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
