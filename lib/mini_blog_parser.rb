class MiniBlogParser

  def initialize
  end

  def self.parse content
    @ptr = 0
    @base = 0
    @state = 0
    @topic_start = 0
    @refer_start = 0
    @http_start = 0
    @nodes = []
    @content = content
    @len = @content.size

    while @ptr != @len
      ch = @content[@ptr..@ptr]
      if @state == 0
        if ch =~ blank
          @state = 0
          @ptr += 1
        elsif ch == '#'
          @topic_start = @ptr
          @state = 2
          @ptr += 1
        elsif ch == '@'
          @refer_start = @ptr
          @state = 5
          @ptr += 1
        else
          if http?
            @http_start = @ptr
            @state = 4
            @ptr += 7
          else
            @state = 1
            @ptr += 1
          end
        end
      elsif @state == 1
        if ch =~ blank
          @state = 1
          @ptr += 1
        elsif ch == '#'
          @topic_start = @ptr
          @state = 2
          @ptr += 1
        elsif ch == '@'
          @refer_start = @ptr
          @state = 5
          @ptr += 1
        else
          if http?
            @http_start = @ptr
            @state = 4
            @ptr += 7
          else
            @state = 1
            @ptr += 1
          end
        end
      elsif @state == 2
        if ch == '#'
          @topic_start = @ptr
          @state = 2
          @ptr += 1
        else
          if sharp?
            @state = 3
            @ptr += 1
          else
            if ch == '@'
              @refer_start = @ptr
              @state = 5
              @ptr += 1
            elsif http?
              @http_start = @ptr
              @ptr += 7
              @state = 4
            else
              @state = 1
              @ptr += 1
            end
          end
        end
      elsif @state == 3
        if ch =~ blank
          @state = 3
          @ptr += 1
        elsif ch == '#'
          parse_text_and_topic
          @ptr += 1
          @base = @ptr
          @state = 0
        elsif ch == '@'
          @state = 3
          @ptr += 1
        else
          @state = 3
          @ptr += 1
        end
      elsif @state == 4
        if ch =~ blank
          parse_text_and_http
          @base = @ptr
          @ptr += 1
          @state = 0
        elsif ch == '['
          parse_text_and_http
          @base = @ptr
          @state = 0
        elsif ch == '#'
          @state = 4
          @ptr += 1
        elsif ch == '@'
          @state = 4
          @ptr += 1
        else
          @state = 4
          @ptr += 1
        end
      elsif @state == 5
        if ch =~ blank
          @state = 1
          @ptr += 1
        elsif ch == '#'
          @topic_start = @ptr
          @state = 2
          @ptr += 1
        elsif ch == '@'
          @refer_start = @ptr
          @state = 5
          @ptr += 1
        else
          if http?
            @http_start = @ptr
            @state = 4
            @ptr += 7 
          else
            if ch =~ /[a-zA-Z0-9_\-]/
              @state = 6
              @ptr += 1
            elsif chinese?
              @state = 6
              @ptr += 3
            else
              @state = 1
              @ptr += 1
            end
          end
        end
      elsif @state == 6
        if ch =~ blank
          parse_text_and_refer
          @base = @ptr
          @ptr += 1
          @state = 0
        elsif ch == '#'
          parse_text_and_refer
          @base = @ptr
          @topic_start = @ptr
          @ptr += 1
          @state = 2
        elsif ch == '@'
          parse_text_and_refer
          @base = @ptr
          @refer_start = @ptr
          @ptr += 1
          @state = 5
        else
          if http?
            parse_text_and_refer
            @base = @ptr
            @http_start = @ptr
            @ptr += 7
            @state = 4
          else
            if ch =~ /[a-zA-Z0-9_\-]/
              @state = 6
              @ptr += 1
            elsif chinese?
              @state = 6
              @ptr += 3
            else
              parse_text_and_refer
              @base = @ptr
              @ptr += 1
              @state = 1
            end
          end
        end 
      end
    end

    if @state == 0
    elsif @state == 1
      parse_text
    elsif @state == 2
      parse_text
    elsif @state == 3
      parse_text
    elsif @state == 4
      parse_text_and_http
    elsif @state == 5
      @nodes.push({:type => 'text', :val => @content[@base..(@ptr-1)]})
    elsif @state == 6
      parse_text_and_refer
    end

    @nodes
  end

protected

  def self.print
    puts @nodes.map{|n| "#{n[:type]}:'#{n[:val]}'"}.join(', ')
  end

  def self.blank
    /[ |\r|\t]/
  end

  def self.http?
    @content[@ptr..(@ptr+6)] == 'http://' and @content[@ptr + 7] and !(@content[(@ptr+7)..(@ptr+7)] =~ blank) and (@content[(@ptr+7)..(@ptr+7)] != '[') 
  end

  def self.chinese?
    @content[@ptr..(@ptr+2)] =~ chinese_reg
  end

  def self.chinese_reg
    if @chinese_reg.nil?
      s = [0x4E00].pack("U")
      e = [0x9FA5].pack("U") 
      @chinese_reg = /[#{s}-#{e}]/
      puts @chinese_reg
    end
    @chinese_reg
  end

  def self.sharp?
    @content[(@ptr+1)..(@len-1)].include? '#'
  end

  def self.parse_text_and_http
    if @base != @http_start
      @nodes.push({:type => 'text', :val => @content[@base..(@http_start-1)]})
    end
    @nodes.push({:type => 'link', :val => @content[@http_start..(@ptr-1)]})
  end

  def self.parse_text_and_refer
    if @base != @refer_start
      @nodes.push({:type => 'text', :val => @content[@base..(@refer_start-1)]})
    end
    @nodes.push({:type => 'ref', :val => @content[(@refer_start+1)..(@ptr-1)]})
  end

  def self.parse_text_and_topic
    if @base != @topic_start
      @nodes.push({:type => 'text', :val => @content[@base..(@topic_start-1)]})
    end
    @nodes.push({:type => 'topic', :val => @content[(@topic_start+1)..(@ptr-1)]})
  end    

  def self.parse_text
    @nodes.push({:type => 'text', :val => @content[@base..(@ptr-1)]})
  end

end
