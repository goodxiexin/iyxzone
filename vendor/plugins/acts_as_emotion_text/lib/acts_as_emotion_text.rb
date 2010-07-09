# ActsAsEmotionText

module Emotion

	Symbols = [ '[惊吓]', '[晕]', '[流鼻涕]', '[挖鼻子]', '[鼓掌]', '[骷髅]', '[坏笑]', '[傲慢]', '[大哭]', '[砸头]', '[衰]', '[哭]', '[可爱]', '[冷汗]', '[抽烟]', '[擦汗]', '[亲亲]', '[糗]', '[吃惊]', '[左哼哼]', '[疑问]', '[惊恐]', '[睡觉]', '[皱眉头]', '[可怜]', '[打呵欠]', '[害羞]', '[花痴]', '[右哼哼]', '[囧]', '[大便]', '[咒骂]', '[贼笑]', '[嘘]', '[吐]', '[苦恼]', '[白眼]', '[流汗]', '[大笑]', '[羞]', '[撇嘴]', '[偷笑]', '[BS]', '[困]', '[火]', '[闭嘴]', '[抓狂]', '[强]', '[不行]', '[装酷]' ]
	
  Re = /\[((惊吓)|(晕)|(流鼻涕)|(挖鼻子)|(鼓掌)|(骷髅)|(坏笑)|(傲慢)|(大哭)|(砸头)|(衰)|(哭)|(可爱)|(冷汗)|(抽烟)|(擦汗)|(亲亲)|(糗)|(吃惊)|(左哼哼)|(疑问)|(惊恐)|(睡觉)|(皱眉头)|(可怜)|(打呵欠)|(害羞)|(花痴)|(右哼哼)|(囧)|(大便)|(咒骂)|(贼笑)|(嘘)|(吐)|(苦恼)|(白眼)|(流汗)|(大笑)|(羞)|(撇嘴)|(偷笑)|(BS)|(困)|(火)|(闭嘴)|(抓狂)|(强)|(不行)|(装酷))\]/

  def self.included base
    base.extend(ClassMethods)
  end

  def self.map name
    "<img src='/images/faces/#{name}.gif'>"
  end 

  def self.parse content
    content.gsub(Re, "<img src='/images/faces/\\1.gif'/>")
  end

  module ClassMethods
    
    def acts_as_emotion_text options={}
    
      cattr_accessor :emotion_opts

      self.emotion_opts = options

      before_save :save_emotion_text

      include Emotion::InstanceMethods

      extend Emotion::SingletonMethods

    end
  
  end

  module InstanceMethods

    def save_emotion_text
      self.class.emotion_opts[:columns].each do |column|
        eval("self.#{column}").gsub!(Re, "<img src='/images/faces/\\1.gif'/>")
      end
    end

  end

  module SingletonMethods

  end

end

ActiveRecord::Base.send(:include, Emotion)
