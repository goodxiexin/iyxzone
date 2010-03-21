class AddIndex < ActiveRecord::Migration

  def self.up
    add_index :albums, [:owner_id]
    add_index :blogs, [:poster_id]
    add_index :bosses, [:guild_id]
    add_index :cities, [:region_id]
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comrade_suggestions, [:user_id]
    add_index :digs, [:diggable_id, :diggable_type]
    add_index :districts, [:city_id]
    add_index :events, [:poster_id]
    add_index :feed_deliveries, [:recipient_id, :recipient_type]
    # feed_item ??
    # forum ??
    add_index :friendships, [:user_id, :friend_id]
    add_index :friend_suggestions, [:user_id]
    add_index :friend_tags, [:taggable_id, :taggable_type]
    # game ??
    add_index :game_areas, [:game_id]
    add_index :game_attentions, [:user_id]
    add_index :game_characters, [:user_id]
    add_index :game_professions, [:game_id]
    add_index :game_races, [:game_id]
    add_index :game_servers, [:game_id, :area_id]
    add_index :gears, [:guild_id]
    add_index :guilds, [:president_id]
    add_index :guild_rules, [:guild_id]
    # link ??
    add_index :mails, [:sender_id, :recipient_id]
    add_index :memberships, [:user_id, :guild_id]
    add_index :messages, [:recipient_id, :poster_id]
    # news ?
    add_index :notices, [:user_id]
    add_index :notifications, [:user_id]
    add_index :participations, [:participant_id, :event_id]
    add_index :photos, [:album_id]
    add_index :photo_tags, [:photo_id]
    # poke ??
    add_index :poke_deliveries, [:recipient_id]
    add_index :polls, [:poster_id]
    add_index :poll_answers, [:poll_id]
    add_index :poll_invitations, [:user_id]
    add_index :profiles, [:user_id]
    add_index :ratings, [:rateable_id, :rateable_type]
    # region ??
    # role ??
    add_index :role_users, [:role_id, :user_id]
    add_index :sharings, [:poster_id]
    # signup_invitation ??
    # skin ??
    add_index :statuses, [:poster_id]
    add_index :taggings, [:taggable_id, :taggable_type]
    # tag ??
    # user ??
    add_index :videos, [:poster_id]
    add_index :viewings, [:viewable_id, :viewable_type]
    add_index :votes, [:poll_id] 
  end

  def self.down
    remove_index :albums, [:owner_id]
    remove_index :blogs, [:poster_id]
    remove_index :bosses, [:guild_id]
    remove_index :cities, [:region_id]
    remove_index :comments, [:commentable_id, :commentable_type]
    remove_index :comrade_suggestions, [:user_id]
    remove_index :digs, [:diggable_id, :diggable_type]
    remove_index :districts, [:city_id]
    remove_index :events, [:poster_id]
    remove_index :feed_deliveries, [:recipient_id, :recipient_type]
    # feed_item ??
    # forum ??
    remove_index :friendships, [:user_id, :friend_id]
    remove_index :friend_suggestions, [:user_id]
    remove_index :friend_tags, [:taggable_id, :taggable_type]
    # game ??
    remove_index :game_areas, [:game_id]
    remove_index :game_attentions, [:user_id]
    remove_index :game_characters, [:user_id]
    remove_index :game_professions, [:game_id]
    remove_index :game_races, [:game_id]
    remove_index :game_servers, [:game_id, :area_id]
    remove_index :gears, [:guild_id]
    remove_index :guilds, [:president_id]
    remove_index :guild_rules, [:guild_id]
    # link ??
    remove_index :mails, [:sender_id, :recipient_id]
    remove_index :memberships, [:user_id, :guild_id]
    remove_index :messages, [:recipient_id, :poster_id]
    # news ?
    remove_index :notices, [:user_id]
    remove_index :notifications, [:user_id]
    remove_index :participations, [:participant_id, :event_id]
    remove_index :photos, [:album_id]
    remove_index :photo_tags, [:photo_id]
    # poke ??
    remove_index :poke_deliveries, [:recipient_id]
    remove_index :polls, [:poster_id]
    remove_index :poll_answers, [:poll_id]
    remove_index :poll_invitations, [:user_id]
    remove_index :profiles, [:user_id]
    remove_index :ratings, [:rateable_id, :rateable_type]
    # region ??
    # role ??
    remove_index :role_users, [:role_id, :user_id]
    remove_index :sharings, [:poster_id]
    # signup_invitation ??
    # skin ??
    remove_index :statuses, [:poster_id]
    remove_index :taggings, [:taggable_id, :taggable_type]
    # tag ??
    # user ??
    remove_index :videos, [:poster_id]
    remove_index :viewings, [:viewable_id, :viewable_type]
    remove_index :votes, [:poll_id]
  end

end
