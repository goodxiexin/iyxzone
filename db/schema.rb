# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100420141939) do

  create_table "albums", :force => true do |t|
    t.string   "type"
    t.integer  "poster_id"
    t.integer  "owner_id"
    t.integer  "game_id"
    t.integer  "photos_count",   :default => 0
    t.integer  "privilege",      :default => 1
    t.integer  "cover_id"
    t.string   "title"
    t.text     "description"
    t.integer  "comments_count", :default => 0
    t.datetime "uploaded_at"
    t.datetime "created_at"
  end

  add_index "albums", ["owner_id"], :name => "index_albums_on_owner_id"

  create_table "applications", :force => true do |t|
    t.string   "name"
    t.string   "icon_class"
    t.text     "about"
    t.integer  "comments_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_images", :force => true do |t|
    t.integer  "blog_id"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "game_id"
    t.string   "title",            :limit => 64
    t.text     "content",          :limit => 16777215
    t.text     "content_abstract"
    t.integer  "digs_count",                           :default => 0
    t.integer  "comments_count",                       :default => 0
    t.integer  "tags_count",                           :default => 0
    t.integer  "viewings_count",                       :default => 0
    t.boolean  "draft",                                :default => true
    t.integer  "privilege",                            :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "verified",                             :default => 0
  end

  add_index "blogs", ["poster_id"], :name => "index_blogs_on_poster_id"

  create_table "bosses", :force => true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.integer  "guild_id"
    t.integer  "reward"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bosses", ["guild_id"], :name => "index_bosses_on_guild_id"

  create_table "chinese_characters", :force => true do |t|
    t.string "utf8_code"
    t.string "pinyin"
  end

  create_table "cities", :force => true do |t|
    t.string  "name"
    t.integer "region_id"
  end

  add_index "cities", ["region_id"], :name => "index_cities_on_region_id"

  create_table "comments", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "recipient_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "verified",         :default => 0
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

  create_table "comrade_suggestions", :force => true do |t|
    t.integer "user_id"
    t.integer "comrade_id"
    t.integer "game_id"
    t.integer "area_id"
    t.integer "server_id"
  end

  add_index "comrade_suggestions", ["user_id"], :name => "index_comrade_suggestions_on_user_id"

  create_table "digs", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "diggable_id"
    t.string   "diggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "digs", ["diggable_id", "diggable_type"], :name => "index_digs_on_diggable_id_and_diggable_type"

  create_table "districts", :force => true do |t|
    t.string  "name"
    t.integer "city_id"
  end

  add_index "districts", ["city_id"], :name => "index_districts_on_city_id"

  create_table "emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "last_send_attempt", :default => 0
    t.text     "mail"
    t.datetime "created_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.integer  "poster_id"
    t.integer  "character_id"
    t.integer  "game_id"
    t.integer  "game_server_id"
    t.integer  "game_area_id"
    t.integer  "guild_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "expired",           :default => false
    t.text     "description"
    t.integer  "privilege",         :default => 1
    t.integer  "comments_count",    :default => 0
    t.integer  "invitations_count", :default => 0
    t.integer  "requests_count",    :default => 0
    t.integer  "confirmed_count",   :default => 0
    t.integer  "maybe_count",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "verified",          :default => 0
  end

  add_index "events", ["poster_id"], :name => "index_events_on_poster_id"

  create_table "feed_deliveries", :force => true do |t|
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.integer  "feed_item_id"
    t.string   "item_type"
    t.datetime "created_at"
  end

  add_index "feed_deliveries", ["recipient_id", "recipient_type"], :name => "index_feed_deliveries_on_recipient_id_and_recipient_type"

  create_table "feed_items", :force => true do |t|
    t.text     "data"
    t.string   "originator_type"
    t.integer  "originator_id"
    t.datetime "created_at"
  end

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "topics_count", :default => 0
    t.integer  "posts_count",  :default => 0
    t.integer  "guild_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friend_suggestions", :force => true do |t|
    t.integer "user_id"
    t.integer "suggested_friend_id"
  end

  add_index "friend_suggestions", ["user_id"], :name => "index_friend_suggestions_on_user_id"

  create_table "friend_tags", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "tagged_user_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friend_tags", ["taggable_id", "taggable_type"], :name => "index_friend_tags_on_taggable_id_and_taggable_type"

  create_table "friendships", :force => true do |t|
    t.integer  "friend_id"
    t.integer  "user_id"
    t.integer  "status"
    t.string   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["user_id", "friend_id"], :name => "index_friendships_on_user_id_and_friend_id"

  create_table "game_areas", :force => true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.integer  "servers_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_areas", ["game_id"], :name => "index_game_areas_on_game_id"

  create_table "game_attentions", :force => true do |t|
    t.integer "user_id"
    t.integer "game_id"
  end

  add_index "game_attentions", ["user_id"], :name => "index_game_attentions_on_user_id"

  create_table "game_characters", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "server_id"
    t.integer  "area_id"
    t.integer  "profession_id"
    t.integer  "race_id"
    t.string   "name"
    t.string   "pinyin"
    t.integer  "level"
    t.boolean  "playing",       :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_characters", ["name", "pinyin"], :name => "index_game_characters_on_name_and_pinyin"
  add_index "game_characters", ["user_id"], :name => "index_game_characters_on_user_id"

  create_table "game_professions", :force => true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_professions", ["game_id"], :name => "index_game_professions_on_game_id"

  create_table "game_races", :force => true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_races", ["game_id"], :name => "index_game_races_on_game_id"

  create_table "game_servers", :force => true do |t|
    t.string   "name"
    t.string   "ip"
    t.integer  "game_id"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_servers", ["game_id", "area_id"], :name => "index_game_servers_on_game_id_and_area_id"

  create_table "games", :force => true do |t|
    t.string   "name"
    t.string   "pinyin"
    t.string   "official_web"
    t.string   "company"
    t.string   "agent"
    t.date     "sale_date"
    t.text     "description"
    t.float    "average_rating",             :default => 0.0
    t.boolean  "stop_running",               :default => false
    t.boolean  "no_areas",                   :default => false
    t.boolean  "no_servers",                 :default => false
    t.boolean  "no_races",                   :default => false
    t.boolean  "no_professions",             :default => false
    t.integer  "areas_count",                :default => 0
    t.integer  "servers_count",              :default => 0
    t.integer  "professions_count",          :default => 0
    t.integer  "races_count",                :default => 0
    t.integer  "attentions_count",           :default => 0
    t.integer  "ratings_count",              :default => 0
    t.integer  "comments_count",             :default => 0
    t.integer  "characters_count",           :default => 0
    t.integer  "last_week_characters_count", :default => 0
    t.integer  "last_week_attentions_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gameswithholes", :force => true do |t|
    t.integer  "txtid"
    t.integer  "sqlid"
    t.string   "gamename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gears", :force => true do |t|
    t.string   "name"
    t.string   "gear_type"
    t.integer  "boss_id"
    t.integer  "guild_id"
    t.integer  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gears", ["guild_id"], :name => "index_gears_on_guild_id"

  create_table "guestbooks", :force => true do |t|
    t.integer  "user_id"
    t.text     "description"
    t.integer  "priority"
    t.date     "done_date"
    t.text     "reply"
    t.string   "catagory"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guild_friendships", :force => true do |t|
    t.integer  "guild_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guild_rules", :force => true do |t|
    t.string   "reason"
    t.integer  "outcome"
    t.integer  "rule_type"
    t.integer  "guild_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guild_rules", ["guild_id"], :name => "index_guild_rules_on_guild_id"

  create_table "guilds", :force => true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.integer  "game_area_id"
    t.integer  "game_server_id"
    t.text     "description"
    t.integer  "president_id"
    t.integer  "character_id"
    t.integer  "members_count",     :default => 0
    t.integer  "veterans_count",    :default => 0
    t.integer  "invitations_count", :default => 0
    t.integer  "requests_count",    :default => 0
    t.integer  "comments_count",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "verified",          :default => 0
  end

  add_index "guilds", ["president_id"], :name => "index_guilds_on_president_id"

  create_table "links", :force => true do |t|
    t.string "url"
  end

  create_table "mails", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "delete_by_sender",    :default => false
    t.boolean  "delete_by_recipient", :default => false
    t.boolean  "read_by_recipient",   :default => false
    t.string   "title"
    t.text     "content"
    t.integer  "parent_id",           :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mails", ["sender_id", "recipient_id"], :name => "index_mails_on_sender_id_and_recipient_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "guild_id"
    t.integer  "character_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["user_id", "guild_id"], :name => "index_memberships_on_user_id_and_guild_id"

  create_table "messages", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "recipient_id"
    t.string   "content"
    t.boolean  "read",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["recipient_id", "poster_id"], :name => "index_messages_on_recipient_id_and_poster_id"

  create_table "news", :force => true do |t|
    t.integer  "game_id"
    t.integer  "poster_id"
    t.string   "news_type"
    t.string   "origin_address"
    t.string   "title"
    t.text     "data"
    t.text     "data_abstract"
    t.integer  "comments_count", :default => 0
    t.integer  "viewings_count", :default => 0
    t.integer  "sharings_count", :default => 0
    t.integer  "digs_count",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "video_url"
    t.string   "embed_html"
    t.string   "thumbnail_url"
  end

  create_table "notices", :force => true do |t|
    t.integer  "producer_id"
    t.string   "producer_type"
    t.integer  "user_id"
    t.string   "data"
    t.boolean  "read",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notices", ["user_id"], :name => "index_notices_on_user_id"

  create_table "notifications", :force => true do |t|
    t.text     "data"
    t.integer  "category"
    t.integer  "user_id"
    t.boolean  "read",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "online_users", :force => true do |t|
    t.integer "user_id"
    t.string  "session_id"
    t.integer "status",     :default => 0
  end

  create_table "participations", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "character_id"
    t.integer  "event_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["participant_id", "event_id"], :name => "index_participations_on_participant_id_and_event_id"

  create_table "photo_tags", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "tagged_user_id"
    t.integer  "photo_id"
    t.string   "photo_type"
    t.integer  "x"
    t.integer  "y"
    t.integer  "width"
    t.integer  "height"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "verified",       :default => 0
  end

  add_index "photo_tags", ["photo_id"], :name => "index_photo_tags_on_photo_id"

  create_table "photos", :force => true do |t|
    t.string   "type"
    t.integer  "digs_count",     :default => 0
    t.integer  "tags_count",     :default => 0
    t.integer  "comments_count", :default => 0
    t.integer  "album_id"
    t.integer  "game_id"
    t.integer  "poster_id"
    t.integer  "privilege"
    t.text     "notation"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "verified",       :default => 0
  end

  add_index "photos", ["album_id"], :name => "index_photos_on_album_id"

  create_table "poke_deliveries", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "poke_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "poke_deliveries", ["recipient_id"], :name => "index_poke_deliveries_on_recipient_id"

  create_table "pokes", :force => true do |t|
    t.string "name"
    t.string "span_class"
    t.string "content_html"
  end

  create_table "poll_answers", :force => true do |t|
    t.string   "description"
    t.integer  "poll_id"
    t.integer  "votes_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "poll_answers", ["poll_id"], :name => "index_poll_answers_on_poll_id"

  create_table "poll_invitations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "poll_invitations", ["user_id"], :name => "index_poll_invitations_on_user_id"

  create_table "polls", :force => true do |t|
    t.string   "name"
    t.integer  "poster_id"
    t.integer  "game_id"
    t.text     "description"
    t.text     "explanation"
    t.integer  "max_multiple",   :default => 1
    t.boolean  "no_deadline",    :default => true
    t.date     "deadline"
    t.text     "summary"
    t.integer  "privilege",      :default => 1
    t.integer  "invitees_count", :default => 0
    t.integer  "digs_count",     :default => 0
    t.integer  "comments_count", :default => 0
    t.integer  "votes_count",    :default => 0
    t.integer  "voters_count",   :default => 0
    t.integer  "answers_count",  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "verified",       :default => 0
  end

  add_index "polls", ["poster_id"], :name => "index_polls_on_poster_id"

  create_table "posts", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "forum_id"
    t.integer  "poster_id"
    t.integer  "recipient_id"
    t.text     "content"
    t.integer  "floor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "gender"
    t.string   "login"
    t.integer  "region_id"
    t.integer  "city_id"
    t.integer  "district_id"
    t.string   "qq"
    t.string   "phone"
    t.string   "website"
    t.datetime "birthday"
    t.text     "about_me"
    t.integer  "completeness",   :default => 0
    t.integer  "skin_id",        :default => 1
    t.integer  "viewings_count", :default => 0
    t.integer  "comments_count", :default => 0
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "ratings", :force => true do |t|
    t.integer  "rating",        :default => 3
    t.integer  "rateable_id",                  :null => false
    t.string   "rateable_type",                :null => false
    t.integer  "user_id",       :default => 0, :null => false
    t.datetime "created_at"
  end

  add_index "ratings", ["rateable_id", "rateable_type"], :name => "index_ratings_on_rateable_id_and_rateable_type"

  create_table "regions", :force => true do |t|
    t.string "name"
  end

  create_table "role_users", :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "role_users", ["role_id", "user_id"], :name => "index_role_users_on_role_id_and_user_id"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "shares", :force => true do |t|
    t.integer  "shareable_id"
    t.string   "shareable_type"
    t.integer  "digs_count",     :default => 0
    t.integer  "sharings_count", :default => 0
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sharings", :force => true do |t|
    t.string   "title"
    t.text     "reason"
    t.string   "shareable_type"
    t.integer  "share_id"
    t.integer  "poster_id"
    t.integer  "comments_count", :default => 0
    t.datetime "created_at"
    t.integer  "verified",       :default => 0
  end

  add_index "sharings", ["poster_id"], :name => "index_sharings_on_poster_id"

  create_table "signup_invitations", :force => true do |t|
    t.integer  "sender_id"
    t.string   "recipient_email"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skins", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "css",                               :null => false
    t.string   "thumbnail",  :default => "missing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.integer  "poster_id"
    t.text     "content"
    t.integer  "comments_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "verified",       :default => 0
  end

  add_index "statuses", ["poster_id"], :name => "index_statuses_on_poster_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "poster_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.string   "pinyin"
    t.string   "taggable_type"
    t.integer  "taggings_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "verified",       :default => 0
  end

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "poster_id"
    t.string   "subject"
    t.text     "content"
    t.text     "content_abstract"
    t.integer  "posts_count",      :default => 0
    t.integer  "viewings_count",   :default => 0
    t.boolean  "top",              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "gender",                                   :default => "male"
    t.string   "crypted_password",           :limit => 40
    t.string   "salt",                       :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code"
    t.datetime "activated_at"
    t.string   "password_reset_code"
    t.string   "invite_code"
    t.string   "qq_invite_code"
    t.string   "msn_invite_code"
    t.string   "invite_method"
    t.boolean  "enabled",                                  :default => true
    t.integer  "avatar_id"
    t.string   "pinyin"
    t.datetime "last_seen_at"
    t.integer  "privacy_setting",            :limit => 8,  :default => 123076522
    t.integer  "mail_setting",               :limit => 8,  :default => 562949953421311
    t.integer  "application_setting",        :limit => 8,  :default => 262143
    t.integer  "characters_count",                         :default => 0
    t.integer  "games_count",                              :default => 0
    t.integer  "game_attentions_count",                    :default => 0
    t.integer  "sharings_count",                           :default => 0
    t.integer  "notices_count",                            :default => 0
    t.integer  "unread_notices_count",                     :default => 0
    t.integer  "notifications_count",                      :default => 0
    t.integer  "unread_notifications_count",               :default => 0
    t.integer  "friends_count",                            :default => 0
    t.integer  "albums_count1",                            :default => 0
    t.integer  "albums_count2",                            :default => 0
    t.integer  "albums_count3",                            :default => 0
    t.integer  "albums_count4",                            :default => 0
    t.integer  "photos_count",                             :default => 0
    t.integer  "guilds_count",                             :default => 0
    t.integer  "participated_guilds_count",                :default => 0
    t.integer  "polls_count",                              :default => 0
    t.integer  "participated_polls_count",                 :default => 0
    t.integer  "blogs_count1",                             :default => 0
    t.integer  "blogs_count2",                             :default => 0
    t.integer  "blogs_count3",                             :default => 0
    t.integer  "blogs_count4",                             :default => 0
    t.integer  "drafts_count",                             :default => 0
    t.integer  "videos_count1",                            :default => 0
    t.integer  "videos_count2",                            :default => 0
    t.integer  "videos_count3",                            :default => 0
    t.integer  "videos_count4",                            :default => 0
    t.integer  "statuses_count",                           :default => 0
    t.integer  "friend_requests_count",                    :default => 0
    t.integer  "guild_requests_count",                     :default => 0
    t.integer  "event_requests_count",                     :default => 0
    t.integer  "guild_invitations_count",                  :default => 0
    t.integer  "event_invitations_count",                  :default => 0
    t.integer  "poll_invitations_count",                   :default => 0
    t.integer  "poke_deliveries_count",                    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login", "pinyin"], :name => "index_users_on_login_and_pinyin"

  create_table "videos", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "game_id"
    t.string   "title"
    t.text     "description"
    t.string   "video_url"
    t.string   "embed_html"
    t.string   "thumbnail_url"
    t.integer  "digs_count",     :default => 0
    t.integer  "comments_count", :default => 0
    t.integer  "tags_count",     :default => 0
    t.integer  "privilege",      :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "verified",       :default => 0
  end

  add_index "videos", ["poster_id"], :name => "index_videos_on_poster_id"

  create_table "viewings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.datetime "viewed_at"
  end

  add_index "viewings", ["viewable_id", "viewable_type"], :name => "index_viewings_on_viewable_id_and_viewable_type"

  create_table "votes", :force => true do |t|
    t.text     "answer_ids"
    t.integer  "voter_id"
    t.integer  "poll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["poll_id"], :name => "index_votes_on_poll_id"

end
