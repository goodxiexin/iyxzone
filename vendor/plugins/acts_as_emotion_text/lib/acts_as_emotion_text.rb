# ActsAsEmotionText

module Emotion

  #Symbols = ['[-_-]', '[@o@]', '[-|-]', '[o_o]', '[ToT]', '[*_*]']
	Symbols = [ '[惊吓]', '[晕]', '[流鼻涕]', '[挖鼻子]', '[鼓掌]', '[骷髅]', '[坏笑]', '[傲慢]', '[大哭]', '[砸头]', '[衰]', '[哭]', '[可爱]', '[冷汗]', '[抽烟]', '[擦汗]', '[亲亲]', '[糗]', '[吃惊]', '[左哼哼]', '[疑问]', '[惊恐]', '[睡觉]', '[皱眉头]', '[可怜]', '[打呵欠]', '[害羞]', '[花痴]', '[右哼哼]', '[囧]', '[大便]', '[咒骂]', '[贼笑]', '[嘘]', '[吐]', '[苦恼]', '[白眼]', '[流汗]', '[大笑]', '[羞]', '[撇嘴]', '[偷笑]', '[BS]', '[困]', '[火]', '[闭嘴]', '[抓狂]', '[强]', '[不行]', '[装酷]' ]
	Re = /\[((惊吓)|(晕)|(流鼻涕)|(挖鼻子)|(鼓掌)|(骷髅)|(坏笑)|(傲慢)|(大哭)|(砸头)|(衰)|(哭)|(可爱)|(冷汗)|(抽烟)|(擦汗)|(亲亲)|(糗)|(吃惊)|(左哼哼)|(疑问)|(惊恐)|(睡觉)|(皱眉头)|(可怜)|(打呵欠)|(害羞)|(花痴)|(右哼哼)|(囧)|(大便)|(咒骂)|(贼笑)|(嘘)|(吐)|(苦恼)|(白眼)|(流汗)|(大笑)|(羞)|(撇嘴)|(偷笑)|(BS)|(困)|(火)|(闭嘴)|(抓狂)|(强)|(不行)|(装酷))\]/
	#ImagePaths = ['/faces/0.gif', '/faces/1.gif', '/faces/2.gif', '/faces/3.gif', '/faces/4.gif', '/faces/5.gif']

  def acts_as_emotion_text(options={})
    define_method("before_create") do
      options[:columns].each do |column|
        Symbols.each_with_index do |s, i|
          #eval("self.#{column}").gsub!("#{s}", "<img src='#{ImagePaths[i]}'/>")
          eval("self.#{column}").gsub!(Re, "<img src='/images/faces/\\1.gif'/>")
        end
      end
    end
  end

end

ActiveRecord::Base.extend(Emotion)
