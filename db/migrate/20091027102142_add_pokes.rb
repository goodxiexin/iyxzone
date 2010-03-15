class AddPokes < ActiveRecord::Migration
  def self.up
    Poke.create(:name => '打招呼', :span_class => "i-f i-f-hello", :content_html => "跟你打声招呼<span class='i-f i-f-hello'></span>说：嗨～～")
    Poke.create(:name => '踩一下', :span_class => "i-f i-f-tread", :content_html => " 突然踩了<span class='i-f i-f-tread'></span>你一下说：哎呀，你怎么把脚放在我的脚下面啦！")
    Poke.create(:name => '拍一下', :span_class => "i-f i-f-beat", :content_html => " 拍拍<span class='i-f i-f-beat'></span>你的啤酒肚子说：几个月啦？")
    Poke.create(:name => '胜利', :span_class => "i-f i-f-victory", :content_html => " 向你比划出胜利<span class='i-f i-f-victory'></span>的动作：你out了！")
    Poke.create(:name => '施舍', :span_class => "i-f i-f-give", :content_html => "施舍了<span class='i-f i-f-give'></span>你2两银子：给，爷赏你的。")
    Poke.create(:name => '献飞吻', :span_class => "i-f i-f-kiss", :content_html => "献飞吻<span class='i-f i-f-kiss'></span>给你：我老爱老爱你了！")
    Poke.create(:name => '送花', :span_class => "i-f i-f-flower", :content_html => "殷勤的献花<span class='i-f i-f-flower'></span>给你。")
    Poke.create(:name => '拥抱', :span_class => "i-f i-f-hug", :content_html => "向你拥抱<span class='i-f i-f-hug'></span>：好久不见了！")
    Poke.create(:name => '作揖', :span_class => "i-f i-f-bow", :content_html => "向你作揖<span class='i-f i-f-bow'></span>：兄弟这厢有礼了！")
    Poke.create(:name => '颁奖', :span_class => "i-f i-f-award", :content_html => "颁奖<span class='i-f i-f-award'></span>给你：你RP实在是太好了，难怪不停地死机！")
    Poke.create(:name => '送蛋糕', :span_class => "i-f i-f-cake", :content_html => "送了一个蛋糕<span class='i-f i-f-cake'></span>给你：小样，饿了吧，爷送你的！")
    Poke.create(:name => '发怒', :span_class => "i-f i-f-anger", :content_html => "怒火心中烧<span class='i-f i-f-anger'></span>抽出十根面条狠狠地抽了你。")
  end

  def self.down
  end
end
