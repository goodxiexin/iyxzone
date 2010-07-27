module RMMSeg
  module Dictionary
    @dictionaries = []

    class << self
      attr_accessor :dictionaries

      def add_dictionary(path, type)
        @dictionaries << [type, path]
      end

      def load_dictionaries()
        @dictionaries.each do |type, path|
          if type == :chars
            load_chars(path)
          elsif type == :words
            load_words(path)
          end
        end
      end
    end
  end

end
