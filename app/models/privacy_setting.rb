# 1 表示 所有人能
# 2 表示 好友或相同游戏才能
# 3 表示 好友才能
class PrivacySetting

  include ActsAsSetting

	acts_as_setting :bits => 2,
									:defaults => %w[2 2 2 2 3 3 3 3 1 1 1 1 2 1],
									:attributes => %w[profile basic_info character_info wall qq phone website email poke friend search send_mail leave_wall_message add_me_as_friend]

  # 没用上的: search, friend, mail, poke

  self.setting_opts[:attributes].each do |attribute|
    define_method "#{attribute}?" do |relationship|
      val = eval("self.#{attribute}")
      relationship == 'owner' || val == 1 || relationship == 'friend' || (val == 2 and relationship == 'same_game')
    end
  end

end
