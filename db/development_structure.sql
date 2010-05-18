CREATE TABLE `albums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `poster_id` int(11) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `photos_count` int(11) DEFAULT '0',
  `privilege` int(11) DEFAULT '1',
  `cover_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `comments_count` int(11) DEFAULT '0',
  `uploaded_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `verified` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_albums_on_owner_id` (`owner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `icon_class` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `about` text COLLATE utf8_unicode_ci,
  `comments_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `blog_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `blog_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `blogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poster_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `title` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` mediumtext COLLATE utf8_unicode_ci,
  `content_abstract` text COLLATE utf8_unicode_ci,
  `digs_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `tags_count` int(11) DEFAULT '0',
  `viewings_count` int(11) DEFAULT '0',
  `draft` tinyint(1) DEFAULT '1',
  `privilege` int(11) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `verified` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_blogs_on_poster_id` (`poster_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `bosses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `guild_id` int(11) DEFAULT NULL,
  `reward` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_bosses_on_guild_id` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `chinese_characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `utf8_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pinyin` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20903 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `cities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `region_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_cities_on_region_id` (`region_id`)
) ENGINE=InnoDB AUTO_INCREMENT=338 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poster_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `commentable_id` int(11) DEFAULT NULL,
  `commentable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `verified` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_comments_on_commentable_id_and_commentable_type` (`commentable_id`,`commentable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `comrade_suggestions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `comrade_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `area_id` int(11) DEFAULT NULL,
  `server_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_comrade_suggestions_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `digs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poster_id` int(11) DEFAULT NULL,
  `diggable_id` int(11) DEFAULT NULL,
  `diggable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_digs_on_diggable_id_and_diggable_type` (`diggable_id`,`diggable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `districts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_districts_on_city_id` (`city_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4223 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `to` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_send_attempt` int(11) DEFAULT '0',
  `mail` text COLLATE utf8_unicode_ci,
  `created_on` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `poster_id` int(11) DEFAULT NULL,
  `character_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `game_server_id` int(11) DEFAULT NULL,
  `game_area_id` int(11) DEFAULT NULL,
  `guild_id` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `expired` tinyint(1) DEFAULT '0',
  `description` text COLLATE utf8_unicode_ci,
  `privilege` int(11) DEFAULT '1',
  `comments_count` int(11) DEFAULT '0',
  `invitations_count` int(11) DEFAULT '0',
  `requests_count` int(11) DEFAULT '0',
  `confirmed_count` int(11) DEFAULT '0',
  `maybe_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `verified` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_events_on_poster_id` (`poster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `feed_deliveries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `recipient_id` int(11) DEFAULT NULL,
  `recipient_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `feed_item_id` int(11) DEFAULT NULL,
  `item_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_feed_deliveries_on_recipient_id_and_recipient_type` (`recipient_id`,`recipient_type`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `feed_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` text COLLATE utf8_unicode_ci,
  `originator_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `originator_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `forums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `topics_count` int(11) DEFAULT '0',
  `posts_count` int(11) DEFAULT '0',
  `guild_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `friend_suggestions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `suggested_friend_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_friend_suggestions_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `friend_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poster_id` int(11) DEFAULT NULL,
  `tagged_user_id` int(11) DEFAULT NULL,
  `taggable_id` int(11) DEFAULT NULL,
  `taggable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_friend_tags_on_taggable_id_and_taggable_type` (`taggable_id`,`taggable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `friendships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `friend_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `data` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_friendships_on_user_id_and_friend_id` (`user_id`,`friend_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `game_areas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `servers_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_game_areas_on_game_id` (`game_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2724 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `game_attentions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_game_attentions_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `game_characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `server_id` int(11) DEFAULT NULL,
  `area_id` int(11) DEFAULT NULL,
  `profession_id` int(11) DEFAULT NULL,
  `race_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pinyin` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `playing` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_game_characters_on_user_id` (`user_id`),
  KEY `index_game_characters_on_name_and_pinyin` (`name`,`pinyin`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `game_professions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_game_professions_on_game_id` (`game_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2625 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `game_races` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_game_races_on_game_id` (`game_id`)
) ENGINE=InnoDB AUTO_INCREMENT=226 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `game_servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `area_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_game_servers_on_game_id_and_area_id` (`game_id`,`area_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11292 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `games` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pinyin` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `official_web` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `agent` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sale_date` date DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `average_rating` float DEFAULT '0',
  `stop_running` tinyint(1) DEFAULT '0',
  `areas_count` int(11) DEFAULT '0',
  `servers_count` int(11) DEFAULT '0',
  `professions_count` int(11) DEFAULT '0',
  `races_count` int(11) DEFAULT '0',
  `attentions_count` int(11) DEFAULT '0',
  `ratings_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `characters_count` int(11) DEFAULT '0',
  `last_week_characters_count` int(11) DEFAULT '0',
  `last_week_attentions_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=671 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `gameswithholes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `txtid` int(11) DEFAULT NULL,
  `sqlid` int(11) DEFAULT NULL,
  `gamename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=671 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `gears` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gear_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `boss_id` int(11) DEFAULT NULL,
  `guild_id` int(11) DEFAULT NULL,
  `cost` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_gears_on_guild_id` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `guestbooks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `priority` int(11) DEFAULT NULL,
  `done_date` date DEFAULT NULL,
  `reply` text COLLATE utf8_unicode_ci,
  `catagory` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `guild_friendships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guild_id` int(11) DEFAULT NULL,
  `friend_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `guild_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reason` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `outcome` int(11) DEFAULT NULL,
  `rule_type` int(11) DEFAULT NULL,
  `guild_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_guild_rules_on_guild_id` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `guilds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `game_area_id` int(11) DEFAULT NULL,
  `game_server_id` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `president_id` int(11) DEFAULT NULL,
  `character_id` int(11) DEFAULT NULL,
  `members_count` int(11) DEFAULT '0',
  `veterans_count` int(11) DEFAULT '0',
  `invitations_count` int(11) DEFAULT '0',
  `requests_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `verified` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_guilds_on_president_id` (`president_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `delete_by_sender` tinyint(1) DEFAULT '0',
  `delete_by_recipient` tinyint(1) DEFAULT '0',
  `read_by_recipient` tinyint(1) DEFAULT '0',
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `parent_id` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_mails_on_sender_id_and_recipient_id` (`sender_id`,`recipient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `memberships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `guild_id` int(11) DEFAULT NULL,
  `character_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_memberships_on_user_id_and_guild_id` (`user_id`,`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poster_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `content` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `read` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_messages_on_recipient_id_and_poster_id` (`recipient_id`,`poster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) DEFAULT NULL,
  `poster_id` int(11) DEFAULT NULL,
  `news_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `origin_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` text COLLATE utf8_unicode_ci,
  `data_abstract` text COLLATE utf8_unicode_ci,
  `video_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumbnail_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `embed_html` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comments_count` int(11) DEFAULT '0',
  `viewings_count` int(11) DEFAULT '0',
  `sharings_count` int(11) DEFAULT '0',
  `digs_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `news_pictures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `news_id` int(11) DEFAULT NULL,
  `notation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `notices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `producer_id` int(11) DEFAULT NULL,
  `producer_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `data` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `read` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_notices_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` text COLLATE utf8_unicode_ci,
  `category` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `read` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_notifications_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `online_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `session_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `participations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `participant_id` int(11) DEFAULT NULL,
  `character_id` int(11) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_participations_on_participant_id_and_event_id` (`participant_id`,`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `photo_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poster_id` int(11) DEFAULT NULL,
  `tagged_user_id` int(11) DEFAULT NULL,
  `photo_id` int(11) DEFAULT NULL,
  `photo_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `x` int(11) DEFAULT NULL,
  `y` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `content` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `verified` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_photo_tags_on_photo_id` (`photo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `digs_count` int(11) DEFAULT '0',
  `tags_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `album_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `poster_id` int(11) DEFAULT NULL,
  `privilege` int(11) DEFAULT NULL,
  `notation` text COLLATE utf8_unicode_ci,
  `parent_id` int(11) DEFAULT NULL,
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `verified` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_photos_on_album_id` (`album_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `poke_deliveries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `poke_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_poke_deliveries_on_recipient_id` (`recipient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `pokes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `span_class` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_html` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `poll_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `poll_id` int(11) DEFAULT NULL,
  `votes_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_poll_answers_on_poll_id` (`poll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `poll_invitations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `poll_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_poll_invitations_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `polls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `poster_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `explanation` text COLLATE utf8_unicode_ci,
  `max_multiple` int(11) DEFAULT '1',
  `no_deadline` tinyint(1) DEFAULT '1',
  `deadline` date DEFAULT NULL,
  `summary` text COLLATE utf8_unicode_ci,
  `privilege` int(11) DEFAULT '1',
  `invitees_count` int(11) DEFAULT '0',
  `digs_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `votes_count` int(11) DEFAULT '0',
  `voters_count` int(11) DEFAULT '0',
  `answers_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `verified` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_polls_on_poster_id` (`poster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) DEFAULT NULL,
  `forum_id` int(11) DEFAULT NULL,
  `poster_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `floor` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `gender` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `login` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `region_id` int(11) DEFAULT NULL,
  `city_id` int(11) DEFAULT NULL,
  `district_id` int(11) DEFAULT NULL,
  `qq` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `birthday` datetime DEFAULT NULL,
  `about_me` text COLLATE utf8_unicode_ci,
  `completeness` int(11) DEFAULT '0',
  `skin_id` int(11) DEFAULT '1',
  `viewings_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_profiles_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rating` int(11) DEFAULT '3',
  `rateable_id` int(11) NOT NULL,
  `rateable_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ratings_on_rateable_id_and_rateable_type` (`rateable_id`,`rateable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `regions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reportable_id` int(11) DEFAULT NULL,
  `reportable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `poster_id` int(11) DEFAULT NULL,
  `category` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `role_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_role_users_on_role_id_and_user_id` (`role_id`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `shares` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shareable_id` int(11) DEFAULT NULL,
  `shareable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `digs_count` int(11) DEFAULT '0',
  `sharings_count` int(11) DEFAULT '0',
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sharings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reason` text COLLATE utf8_unicode_ci,
  `shareable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `share_id` int(11) DEFAULT NULL,
  `poster_id` int(11) DEFAULT NULL,
  `comments_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `verified` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_sharings_on_poster_id` (`poster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `signup_invitations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) DEFAULT NULL,
  `recipient_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `skins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `css` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'missing',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poster_id` int(11) DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `comments_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `verified` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_statuses_on_poster_id` (`poster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) DEFAULT NULL,
  `taggable_id` int(11) DEFAULT NULL,
  `taggable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `poster_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_taggings_on_taggable_id_and_taggable_type` (`taggable_id`,`taggable_type`)
) ENGINE=InnoDB AUTO_INCREMENT=2254 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pinyin` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `taggable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `taggings_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `verified` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prerequisite` text COLLATE utf8_unicode_ci,
  `requirement` text COLLATE utf8_unicode_ci,
  `reward` text COLLATE utf8_unicode_ci,
  `description` text COLLATE utf8_unicode_ci,
  `catagory` int(11) DEFAULT '1',
  `starts_at` datetime DEFAULT '2010-05-11 13:42:42',
  `expires_at` datetime DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `state` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `forum_id` int(11) DEFAULT NULL,
  `poster_id` int(11) DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `content_abstract` text COLLATE utf8_unicode_ci,
  `posts_count` int(11) DEFAULT '0',
  `viewings_count` int(11) DEFAULT '0',
  `top` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `task_id` int(11) DEFAULT NULL,
  `starts_at` datetime DEFAULT NULL,
  `done_at` datetime DEFAULT NULL,
  `achievement` text COLLATE utf8_unicode_ci,
  `goal` text COLLATE utf8_unicode_ci,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gender` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'male',
  `crypted_password` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `salt` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remember_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `activation_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `activated_at` datetime DEFAULT NULL,
  `password_reset_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `invite_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qq_invite_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `msn_invite_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `invite_method` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT '1',
  `avatar_id` int(11) DEFAULT NULL,
  `pinyin` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_seen_at` datetime DEFAULT NULL,
  `privacy_setting` bigint(20) DEFAULT '0',
  `mail_setting` bigint(20) DEFAULT '0',
  `application_setting` bigint(20) DEFAULT '0',
  `characters_count` int(11) DEFAULT '0',
  `games_count` int(11) DEFAULT '0',
  `game_attentions_count` int(11) DEFAULT '0',
  `sharings_count` int(11) DEFAULT '0',
  `notices_count` int(11) DEFAULT '0',
  `unread_notices_count` int(11) DEFAULT '0',
  `notifications_count` int(11) DEFAULT '0',
  `unread_notifications_count` int(11) DEFAULT '0',
  `friends_count` int(11) DEFAULT '0',
  `albums_count1` int(11) DEFAULT '0',
  `albums_count2` int(11) DEFAULT '0',
  `albums_count3` int(11) DEFAULT '0',
  `albums_count4` int(11) DEFAULT '0',
  `photos_count` int(11) DEFAULT '0',
  `guilds_count` int(11) DEFAULT '0',
  `participated_guilds_count` int(11) DEFAULT '0',
  `polls_count` int(11) DEFAULT '0',
  `participated_polls_count` int(11) DEFAULT '0',
  `blogs_count1` int(11) DEFAULT '0',
  `blogs_count2` int(11) DEFAULT '0',
  `blogs_count3` int(11) DEFAULT '0',
  `blogs_count4` int(11) DEFAULT '0',
  `drafts_count` int(11) DEFAULT '0',
  `videos_count1` int(11) DEFAULT '0',
  `videos_count2` int(11) DEFAULT '0',
  `videos_count3` int(11) DEFAULT '0',
  `videos_count4` int(11) DEFAULT '0',
  `statuses_count` int(11) DEFAULT '0',
  `friend_requests_count` int(11) DEFAULT '0',
  `guild_requests_count` int(11) DEFAULT '0',
  `event_requests_count` int(11) DEFAULT '0',
  `guild_invitations_count` int(11) DEFAULT '0',
  `event_invitations_count` int(11) DEFAULT '0',
  `poll_invitations_count` int(11) DEFAULT '0',
  `poke_deliveries_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_users_on_login_and_pinyin` (`login`,`pinyin`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poster_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `video_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `embed_html` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumbnail_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `digs_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `tags_count` int(11) DEFAULT '0',
  `privilege` int(11) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `verified` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_videos_on_poster_id` (`poster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `viewings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `viewable_id` int(11) DEFAULT NULL,
  `viewable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `viewed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_viewings_on_viewable_id_and_viewable_type` (`viewable_id`,`viewable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `votes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `answer_ids` text COLLATE utf8_unicode_ci,
  `voter_id` int(11) DEFAULT NULL,
  `poll_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_votes_on_poll_id` (`poll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20090707071656');

INSERT INTO schema_migrations (version) VALUES ('20090810061507');

INSERT INTO schema_migrations (version) VALUES ('20090907150009');

INSERT INTO schema_migrations (version) VALUES ('20090907150010');

INSERT INTO schema_migrations (version) VALUES ('20090907150011');

INSERT INTO schema_migrations (version) VALUES ('20090908080440');

INSERT INTO schema_migrations (version) VALUES ('20090908085732');

INSERT INTO schema_migrations (version) VALUES ('20090908085733');

INSERT INTO schema_migrations (version) VALUES ('20090908085734');

INSERT INTO schema_migrations (version) VALUES ('20090908085735');

INSERT INTO schema_migrations (version) VALUES ('20090908085736');

INSERT INTO schema_migrations (version) VALUES ('20090923074604');

INSERT INTO schema_migrations (version) VALUES ('20090926131653');

INSERT INTO schema_migrations (version) VALUES ('20091011080154');

INSERT INTO schema_migrations (version) VALUES ('20091011080155');

INSERT INTO schema_migrations (version) VALUES ('20091011090317');

INSERT INTO schema_migrations (version) VALUES ('20091011143225');

INSERT INTO schema_migrations (version) VALUES ('20091011143229');

INSERT INTO schema_migrations (version) VALUES ('20091011145912');

INSERT INTO schema_migrations (version) VALUES ('20091011145915');

INSERT INTO schema_migrations (version) VALUES ('20091011151443');

INSERT INTO schema_migrations (version) VALUES ('20091012071828');

INSERT INTO schema_migrations (version) VALUES ('20091012124341');

INSERT INTO schema_migrations (version) VALUES ('20091013051812');

INSERT INTO schema_migrations (version) VALUES ('20091013180753');

INSERT INTO schema_migrations (version) VALUES ('20091015045738');

INSERT INTO schema_migrations (version) VALUES ('20091015052124');

INSERT INTO schema_migrations (version) VALUES ('20091017050836');

INSERT INTO schema_migrations (version) VALUES ('20091017050844');

INSERT INTO schema_migrations (version) VALUES ('20091017140927');

INSERT INTO schema_migrations (version) VALUES ('20091017141104');

INSERT INTO schema_migrations (version) VALUES ('20091017141152');

INSERT INTO schema_migrations (version) VALUES ('20091017141157');

INSERT INTO schema_migrations (version) VALUES ('20091017150453');

INSERT INTO schema_migrations (version) VALUES ('20091017152153');

INSERT INTO schema_migrations (version) VALUES ('20091017152158');

INSERT INTO schema_migrations (version) VALUES ('20091017152230');

INSERT INTO schema_migrations (version) VALUES ('20091017152252');

INSERT INTO schema_migrations (version) VALUES ('20091017152256');

INSERT INTO schema_migrations (version) VALUES ('20091017152300');

INSERT INTO schema_migrations (version) VALUES ('20091018031453');

INSERT INTO schema_migrations (version) VALUES ('20091018031635');

INSERT INTO schema_migrations (version) VALUES ('20091018031744');

INSERT INTO schema_migrations (version) VALUES ('20091018042250');

INSERT INTO schema_migrations (version) VALUES ('20091018044631');

INSERT INTO schema_migrations (version) VALUES ('20091018045613');

INSERT INTO schema_migrations (version) VALUES ('20091018052901');

INSERT INTO schema_migrations (version) VALUES ('20091018062701');

INSERT INTO schema_migrations (version) VALUES ('20091018065040');

INSERT INTO schema_migrations (version) VALUES ('20091018070856');

INSERT INTO schema_migrations (version) VALUES ('20091018071001');

INSERT INTO schema_migrations (version) VALUES ('20091018071923');

INSERT INTO schema_migrations (version) VALUES ('20091018073722');

INSERT INTO schema_migrations (version) VALUES ('20091018075806');

INSERT INTO schema_migrations (version) VALUES ('20091018080718');

INSERT INTO schema_migrations (version) VALUES ('20091018081056');

INSERT INTO schema_migrations (version) VALUES ('20091018085001');

INSERT INTO schema_migrations (version) VALUES ('20091018090800');

INSERT INTO schema_migrations (version) VALUES ('20091018140307');

INSERT INTO schema_migrations (version) VALUES ('20091018141042');

INSERT INTO schema_migrations (version) VALUES ('20091018142154');

INSERT INTO schema_migrations (version) VALUES ('20091018144600');

INSERT INTO schema_migrations (version) VALUES ('20091018145653');

INSERT INTO schema_migrations (version) VALUES ('20091018150528');

INSERT INTO schema_migrations (version) VALUES ('20091018151510');

INSERT INTO schema_migrations (version) VALUES ('20091018153527');

INSERT INTO schema_migrations (version) VALUES ('20091018154736');

INSERT INTO schema_migrations (version) VALUES ('20091018162131');

INSERT INTO schema_migrations (version) VALUES ('20091018163613');

INSERT INTO schema_migrations (version) VALUES ('20091018165725');

INSERT INTO schema_migrations (version) VALUES ('20091018170924');

INSERT INTO schema_migrations (version) VALUES ('20091018171744');

INSERT INTO schema_migrations (version) VALUES ('20091018180705');

INSERT INTO schema_migrations (version) VALUES ('20091018183318');

INSERT INTO schema_migrations (version) VALUES ('20091019040729');

INSERT INTO schema_migrations (version) VALUES ('20091019050738');

INSERT INTO schema_migrations (version) VALUES ('20091019051530');

INSERT INTO schema_migrations (version) VALUES ('20091019060606');

INSERT INTO schema_migrations (version) VALUES ('20091019061651');

INSERT INTO schema_migrations (version) VALUES ('20091019064836');

INSERT INTO schema_migrations (version) VALUES ('20091019070020');

INSERT INTO schema_migrations (version) VALUES ('20091019072002');

INSERT INTO schema_migrations (version) VALUES ('20091019073452');

INSERT INTO schema_migrations (version) VALUES ('20091019074526');

INSERT INTO schema_migrations (version) VALUES ('20091019081000');

INSERT INTO schema_migrations (version) VALUES ('20091019140345');

INSERT INTO schema_migrations (version) VALUES ('20091019140638');

INSERT INTO schema_migrations (version) VALUES ('20091019142541');

INSERT INTO schema_migrations (version) VALUES ('20091019143942');

INSERT INTO schema_migrations (version) VALUES ('20091019145058');

INSERT INTO schema_migrations (version) VALUES ('20091019155720');

INSERT INTO schema_migrations (version) VALUES ('20091019160632');

INSERT INTO schema_migrations (version) VALUES ('20091019162049');

INSERT INTO schema_migrations (version) VALUES ('20091019165144');

INSERT INTO schema_migrations (version) VALUES ('20091019170700');

INSERT INTO schema_migrations (version) VALUES ('20091019172728');

INSERT INTO schema_migrations (version) VALUES ('20091019173615');

INSERT INTO schema_migrations (version) VALUES ('20091021082133');

INSERT INTO schema_migrations (version) VALUES ('20091021083842');

INSERT INTO schema_migrations (version) VALUES ('20091021084925');

INSERT INTO schema_migrations (version) VALUES ('20091021090224');

INSERT INTO schema_migrations (version) VALUES ('20091021094308');

INSERT INTO schema_migrations (version) VALUES ('20091021100306');

INSERT INTO schema_migrations (version) VALUES ('20091021102637');

INSERT INTO schema_migrations (version) VALUES ('20091021103718');

INSERT INTO schema_migrations (version) VALUES ('20091021133805');

INSERT INTO schema_migrations (version) VALUES ('20091021135522');

INSERT INTO schema_migrations (version) VALUES ('20091021141244');

INSERT INTO schema_migrations (version) VALUES ('20091021141627');

INSERT INTO schema_migrations (version) VALUES ('20091021143414');

INSERT INTO schema_migrations (version) VALUES ('20091021143647');

INSERT INTO schema_migrations (version) VALUES ('20091021151040');

INSERT INTO schema_migrations (version) VALUES ('20091021151724');

INSERT INTO schema_migrations (version) VALUES ('20091021152300');

INSERT INTO schema_migrations (version) VALUES ('20091021155256');

INSERT INTO schema_migrations (version) VALUES ('20091021160320');

INSERT INTO schema_migrations (version) VALUES ('20091021161723');

INSERT INTO schema_migrations (version) VALUES ('20091021162928');

INSERT INTO schema_migrations (version) VALUES ('20091021163442');

INSERT INTO schema_migrations (version) VALUES ('20091021164431');

INSERT INTO schema_migrations (version) VALUES ('20091021165635');

INSERT INTO schema_migrations (version) VALUES ('20091021170538');

INSERT INTO schema_migrations (version) VALUES ('20091021171139');

INSERT INTO schema_migrations (version) VALUES ('20091021172045');

INSERT INTO schema_migrations (version) VALUES ('20091021172512');

INSERT INTO schema_migrations (version) VALUES ('20091021173649');

INSERT INTO schema_migrations (version) VALUES ('20091021174640');

INSERT INTO schema_migrations (version) VALUES ('20091021175618');

INSERT INTO schema_migrations (version) VALUES ('20091021180937');

INSERT INTO schema_migrations (version) VALUES ('20091021181652');

INSERT INTO schema_migrations (version) VALUES ('20091021181748');

INSERT INTO schema_migrations (version) VALUES ('20091021182951');

INSERT INTO schema_migrations (version) VALUES ('20091023115905');

INSERT INTO schema_migrations (version) VALUES ('20091023120028');

INSERT INTO schema_migrations (version) VALUES ('20091024063451');

INSERT INTO schema_migrations (version) VALUES ('20091024095604');

INSERT INTO schema_migrations (version) VALUES ('20091025065902');

INSERT INTO schema_migrations (version) VALUES ('20091025071857');

INSERT INTO schema_migrations (version) VALUES ('20091026125709');

INSERT INTO schema_migrations (version) VALUES ('20091027095356');

INSERT INTO schema_migrations (version) VALUES ('20091027102142');

INSERT INTO schema_migrations (version) VALUES ('20091028083324');

INSERT INTO schema_migrations (version) VALUES ('20091028084336');

INSERT INTO schema_migrations (version) VALUES ('20091028163643');

INSERT INTO schema_migrations (version) VALUES ('20091105063746');

INSERT INTO schema_migrations (version) VALUES ('20091108132556');

INSERT INTO schema_migrations (version) VALUES ('20091108132557');

INSERT INTO schema_migrations (version) VALUES ('20091108132558');

INSERT INTO schema_migrations (version) VALUES ('20091120074431');

INSERT INTO schema_migrations (version) VALUES ('20091121151424');

INSERT INTO schema_migrations (version) VALUES ('20091223160309');

INSERT INTO schema_migrations (version) VALUES ('20091225062455');

INSERT INTO schema_migrations (version) VALUES ('20091228153228');

INSERT INTO schema_migrations (version) VALUES ('20091228153258');

INSERT INTO schema_migrations (version) VALUES ('20100119074251');

INSERT INTO schema_migrations (version) VALUES ('20100119074257');

INSERT INTO schema_migrations (version) VALUES ('20100119075038');

INSERT INTO schema_migrations (version) VALUES ('20100201024834');

INSERT INTO schema_migrations (version) VALUES ('20100201033652');

INSERT INTO schema_migrations (version) VALUES ('20100204133656');

INSERT INTO schema_migrations (version) VALUES ('20100222064840');

INSERT INTO schema_migrations (version) VALUES ('20100224085559');

INSERT INTO schema_migrations (version) VALUES ('20100309072232');

INSERT INTO schema_migrations (version) VALUES ('20100321120645');

INSERT INTO schema_migrations (version) VALUES ('20100402080614');

INSERT INTO schema_migrations (version) VALUES ('20100402082104');

INSERT INTO schema_migrations (version) VALUES ('20100407140840');

INSERT INTO schema_migrations (version) VALUES ('20100408143203');

INSERT INTO schema_migrations (version) VALUES ('20100415043012');

INSERT INTO schema_migrations (version) VALUES ('20100415052934');

INSERT INTO schema_migrations (version) VALUES ('20100415060827');

INSERT INTO schema_migrations (version) VALUES ('20100415085914');

INSERT INTO schema_migrations (version) VALUES ('20100416062427');

INSERT INTO schema_migrations (version) VALUES ('20100419134333');

INSERT INTO schema_migrations (version) VALUES ('20100420025650');

INSERT INTO schema_migrations (version) VALUES ('20100420064605');

INSERT INTO schema_migrations (version) VALUES ('20100420071333');

INSERT INTO schema_migrations (version) VALUES ('20100420072658');

INSERT INTO schema_migrations (version) VALUES ('20100420164437');

INSERT INTO schema_migrations (version) VALUES ('20100422072054');

INSERT INTO schema_migrations (version) VALUES ('20100423034632');

INSERT INTO schema_migrations (version) VALUES ('20100425065936');

INSERT INTO schema_migrations (version) VALUES ('20100426130650');

INSERT INTO schema_migrations (version) VALUES ('20100427094546');

INSERT INTO schema_migrations (version) VALUES ('20100428021057');

INSERT INTO schema_migrations (version) VALUES ('20100428031910');

INSERT INTO schema_migrations (version) VALUES ('20100502091021');

INSERT INTO schema_migrations (version) VALUES ('20100504094536');

INSERT INTO schema_migrations (version) VALUES ('20100506052501');