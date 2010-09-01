Iyxzone.URL = {

  author: "高侠鸿",

  // TODO: params的格式比较限制，可以改变
  buildParams: function(params){
    var str = "";
    var hash = new Hash(params); // 这是因为javascript其实是没有hash的
    hash.keys().each(function(key){
      if(str != "")
        str += "&"
      var val = hash.get(key);
      str += encodeURIComponent(key) + "=" + encodeURIComponent(val);
    }.bind(this));
    return str;
  },

  build: function(baseURL, params){
    if(params == null){
      return baseURL;
    }else{
      if(baseURL.indexOf("?") > 0)
        return baseURL + "&" + this.buildParams(params);
      else
        return baseURL + "?" + this.buildParams(params);
    }
  }
};

// blog and draft urls
Object.extend(Iyxzone.URL, {

  showBlog: function(blogID, params){
    return this.build("/blogs/" + blogID, params);
  },

  createBlog: function(params){
    return this.build("/blogs", params);
  },

  createMultipleBlog: function(params){
    return this.build("/blogs/create_multiple", params);
  },

  createDraft: function(params){
    return this.build("/drafts", params);
  },

  editDraft: function(draftID, params){
    return this.build("/drafts/" + draftID + "/edit", params);
  },

  updateBlog: function(blogID, params){
    return this.build("/blogs/" + blogID, params);
  },

  updateDraft: function(draftID, params){
    return this.build("/drafts/" + draftID, params);
  },

  deleteBlog: function(blogID, params){
    return this.build("/blogs/" + blogID, params);
  },

  deleteDraft: function(draftID, params){
    return this.build("/drafts/" + draftID, params);
  },

  listBlog: function(userID, params){
    return this.build("/blogs?uid=" + userID, params);
  },

  listGameBlog: function(gameID, params){
    return this.build("/games/" + gameID + "/blogs", params);
  },

  listDraft: function(userID, params){
    return this.build("/drafts?uid=" + userID, params);
  }

});

// video url
Object.extend(Iyxzone.URL, {

  createVideo: function(params){
    return this.build("/videos", params);
  },

  showVideo: function(videoID, params){
    return this.build("/videos/" + videoID, params);
  },

  deleteVideo: function(videoID, params){
    return this.build("/videos/" + videoID, params);
  },

  updateVideo: function(videoID, params){
    return this.build("/videos/" + videoID, params);
  },

  listVideo: function(userID, params){
    return this.build("/videos?uid=" + userID, params);
  }

});

// poll  url
Object.extend(Iyxzone.URL, {

  createPoll: function(params){
    return this.build("/polls", params);
  },

  showPoll: function(pollID, params){
    return this.build("/polls/" + pollID, params);
  },

  updatePoll: function(pollID, params){
    return this.build("/polls/" + pollID, params);
  },

  deletePoll: function(pollID, params){
    return this.build("/polls/" + pollID, params);
  },

  listPoll: function(userID, params){
    return this.build("/polls?uid=" + userID, params);
  },

  createVote: function(pollID, params){
    return this.build("/polls/" + pollID + "/votes", params);
  },

  createPollAnswer: function(pollID, params){
    return this.build("/polls/" + pollID + "/answers", params);
  },

  createPollInvitation: function(pollID, params){
    return this.build("/polls/" + pollID + "/invitations", params);
  }

});

// dig
Object.extend(Iyxzone.URL, {

  createDig: function(diggableType, diggableID, params){
    return this.build("/digs", Object.extend({'diggable_type': diggableType, 'diggable_id': diggableID}, params || {}));
  }

});

// photo tag
Object.extend(Iyxzone.URL, {

  createPhotoTag: function(photoType, photoID, params){
    return this.build("/photo_tags", Object.extend({'photo_type': photoType, 'photo_id': photoID}, params || {}));
  },

  deletePhotoTag: function(tagID, params){
    return this.build("/photo_tags/" + tagID, params);
  }

});

Object.extend(Iyxzone.URL, {

  newFriendRequest: function(friendID, params){
    return this.build("/friend_requests/new?friend_id=" + friendID, params);
  },

  createFriendRequest: function(friendID, params){
    return this.build("/friend_requests?friend_id=" + friendID, params);
  },

  createMultipleFriendRequests: function(params){
    return this.build("/friend_requests/create_multiple", params);
  },
  
  acceptFriendRequest: function(requestID, params){
    return this.build("/friend_requests/" + requestID + "/accept", params);
  },

  declineFriendRequest: function(requestID, params){
    return this.build("/friend_requests/" + requestID + "/decline", params);
  }

});

// personal album and photo
Object.extend(Iyxzone.URL, {

  createAlbum: function(params){
    return this.build("/personal_albums", params);
  },

  updateAlbum: function(albumID, params){
    return this.build("/personal_albums/" + albumID, params);
  },

  showAlbum: function(albumID, params){
    return this.build("/personal_albums/" + albumID, params);
  },

  showEventAlbum: function(albumID, params){
    return this.build("/event_albums/" + albumID, params);
  },

  listEventPhoto: function(albumID, params){
    return this.build("/event_photos?album_id=" + albumID, params);
  },

  showGuildAlbum: function(albumID, params){
    return this.build("/guild_albums/" + albumID, params);
  },

  listGuildPhoto: function(albumID, params){
    return this.build("/guild_photos?album_id=" + albumID, params);
  },

  listAlbum: function(userID, params){
    return this.build("/personal_albums?uid=" + userID, params);
  },

  listGameAlbum: function(gameID, params){
    return this.build("/games/" + gameID + "/albums", params);
  },

  deleteAlbum: function(albumID, params){
    return this.build("/personal_albums/" + albumID, params);
  },

  editMultiplePhoto: function(albumID, photoIDs, params){
    var ids = "";
    photoIDs.each(function(id){
      if(ids != "")
        ids += "&";
      ids += "ids[]=" + id;
    });
    return this.build("/personal_photos/edit_multiple?album_id=" + albumID + "&" + ids, params);     
  },

  editMultipleEventPhoto: function(albumID, photoIDs, params){
    var ids = "";
    photoIDs.each(function(id){
      if(ids != "")
        ids += "&";
      ids += "ids[]=" + id;
    });
    return this.build("/event_photos/edit_multiple?album_id=" + albumID + "&" + ids, params);
  },

  editMultipleGuildPhoto: function(albumID, photoIDs, params){
    var ids = "";
    photoIDs.each(function(id){
      if(ids != "")
        ids += "&";
      ids += "ids[]=" + id;
    });
    return this.build("/guild_photos/edit_multiple?album_id=" + albumID + "&" + ids, params);
  },

  updateMultiplePhoto: function(albumID, params){
    return this.build("/personal_photos/update_multiple?album_id=" + albumID, params);
  },

  updateMultipleEventPhoto: function(albumID, params){
    return this.build("/event_photos/update_multiple?album_id=" + albumID, params);
  },

  updateMultipleGuildPhoto: function(albumID, params){
    return this.build("/guild_photos/update_multiple?album_id=" + albumID, params);
  },

  showPhoto: function(photoID, params){
    return this.build("/personal_photos/" + photoID, params);
  },

  showEventPhoto: function(photoID, params){
    return this.build("/event_photos/" + photoID, params);
  },

  showGuildPhoto: function(photoID, params){
    return this.build("/guild_photos/" + photoID, params);
  },

  updatePhoto: function(photoID, params){
    return this.build("/personal_photos/" + photoID, params);
  },

  updateEventPhoto: function(photoID, params){
    return this.build("/event_photos/" + photoID, params);
  },

  updateGuildPhoto: function(photoID, params){
    return this.build("/guild_photos/" + photoID, params);
  },

  deletePhoto: function(photoID, params){
    return this.build("/personal_photos/" + photoID, params);
  },

  deleteEventPhoto: function(photoID, params){
    return this.build("/event_photos/" + photoID, params);
  },

  deleteGuildPhoto: function(photoID, params){
    return this.build("/guild_photos/" + photoID, params);
  }  

});

// fan url
Object.extend(Iyxzone.URL, {

  followIdol: function(idolID, params){
    return this.build("/idols/" + idolID + "/follow", params);
  },

  unfollowIdol: function(idolID, params){
    return this.build("/idols/" + idolID + "/unfollow", params);
  },
  
  followMultipleIdols: function(params){
    return this.build("/idols/follow_multiple", params);
  },

  deleteFan: function(fanID, params){
    return this.build("/fans/" + fanID, params);
  }

});

// avatar album, photo
Object.extend(Iyxzone.URL, {

  showAvatarAlbum: function(albumID, params){
    return this.build("/avatar_albums/" + albumID, params);
  },

  updateAvatarAlbum: function(albumID, params){
    return this.build("/avatar_albums/" + albumID, params);
  },

  updateAvatar: function(photoID, params){
    return this.build("/avatars/" + photoID, params);
  },

  showAvatar: function(photoID, params){
    return this.build("/avatars/" + photoID, params);
  },

  deleteAvatar: function(photoID, params){
    return this.build("/avatars/" + photoID, params);
  }

});

// profile url
Object.extend(Iyxzone.URL, {
  
  showProfile: function(profileID, params){
    return this.build("/profiles/" + profileID, params);
  }

});

// tag
Object.extend(Iyxzone.URL, {

  createTag: function(taggableType, taggableID, params){
    return this.build("/tags", Object.extend({'taggable_type': taggableType, 'taggable_id': taggableID}, params || {}));
  },

  // 不是真的删除tag，只是删除taggable关于这个tag的所有taggings
  deleteTag: function(tagID, taggableType, taggableID, params){
    return this.build("/tags/" + tagID, Object.extend({'taggable_type': taggableType, 'taggable_id': taggableID}, params|| {}));
  },

  listTag: function(taggableType, taggableID, params){
    return this.build("/tags", Object.extend({'taggable_type': taggableType, 'taggable_id': taggableID}, params || {}));
  }

});

// game
Object.extend(Iyxzone.URL, {

  showGame: function(gameID, params){
    return this.build("/games/" + gameID, params);
  },

  listGameDetails: function(params){
    return this.build("/game_details", params);
  }

});

// event
Object.extend(Iyxzone.URL, {

  createEvent: function(params){
    return this.build("/events", params);
  },

  showEvent: function(eventID, params){
    return this.build("/events/" + eventID, params);
  },

  listEvent: function(userID, params){
    return this.build("/events?uid=" + userID, params);
  },

  updateEvent: function(eventID, params){
    return this.build("/events/" + eventID, params);
  },

  deleteEvent: function(eventID, params){
    return this.build("/events/" + eventID, params);
  },

  newEventInvitation: function(eventID, params){
    return this.build("/events/" + eventID + "/invitations/new", params);
  },

  createEventInvitation: function(eventID, params){
    return this.build("/events/" + eventID + "/invitations", params);
  },

  acceptEventInvitation: function(eventID, invitationID, params){
    return this.build("/events/" + eventID + "/invitations/" + invitationID + "/accept", params);
  },

  declineEventInvitation: function(eventID, invitationID, params){
    return this.build("/events/" + eventID + "/invitations/" + invitationID + "/decline", params);
  },

  createEventRequest: function(eventID, params){
    return this.build("/events/" + eventID + "/requests", params);
  },

  acceptEventRequest: function(eventID, requestID, params){
    return this.build("/events/" + eventID + "/requests/" + requestID + "/accept", params);
  },

  declineEventRequest: function(eventID, requestID, params){
    return this.build("/events/" + eventID + "/requests/" + requestID + "/decline", params);
  },

  deleteParticipation: function(eventID, participationID, params){
    return this.build("/events/" + eventID + "/participations/" + participationID, params);
  },

  updateParticipation: function(eventID, participationID, params){
    return this.build("/events/" + eventID + "/participations/" + participationID, params);
  }

});

// mini blog url
Object.extend(Iyxzone.URL, {

  listMiniBlog: function(userID, params){
    return this.build("/mini_blogs?uid=" + userID, params);
  },

  miniBlogHome: function(params){
    return this.build("/mini_blogs/home", params);
  }

});

// login
Object.extend(Iyxzone.URL, {

  login: function(params){
    return this.build("/sessions", params);
  },

  loginFailure: function(params){
    return this.build("/sessions", params);
  },

  home: function(params){
    return this.build("/home", params);
  }

});

// sharing
Object.extend(Iyxzone.URL, {

  newSharing: function(params){
    return this.build("/sharings/new", params);
  }

});

// notification url
Object.extend(Iyxzone.URL, {

  deleteNotification: function(id, params){
    return this.build("/notifications/" + id, params);
  },

  deleteAllNotification: function(userID, params){
    return this.build("/notifications/destroy_all", params);
  },

  listNotification: function(userID, params){
    return this.build("/notifications", params);
  }

});

// poke url
Object.extend(Iyxzone.URL, {

  createPoke: function(params){
    return this.build("/pokes", params);
  },

  deletePoke: function(id, params){
    return this.build("/pokes/" + id, params);
  },

  deleteAllPoke: function(userID, params){
    return this.build("/pokes/destroy_all", params);
  },

  listPoke: function(userID, params){
    return this.build("/pokes", params);
  }

});

// setting url
Object.extend(Iyxzone.URL, {

  updateApplicationSetting: function(params){
    return this.build("/application_setting", params);
  },

  editMailSetting: function(params){
    return this.build("/mail_setting/edit", params);
  },

  updateMailSetting: function(params){
    return this.build("/mail_setting", params);
  },

  updatePrivacySetting: function(params){
    return this.build("/privacy_setting", params);
  },

  editProfilePrivacySetting: function(params){
    return this.build("/privacy_setting/edit?type=0", params);
  }, 

  editGoingPrivacySetting: function(params){
    return this.build("/privacy_setting/edit?type=1", params);
  },

  editOutsidePrivacySetting: function(params){
    return this.build("/privacy_setting/edit?type=2", params);
  },

  updatePasswordSetting: function(params){
    return this.build("/password_setting", params);
  }

});

// rating
Object.extend(Iyxzone.URL, {

  createRating: function(rateableType, rateableID, params){
    return this.build("/ratings", Object.extend({'rateable_type': rateableType, 'rateable_id': rateableID}, params || {}));
  }

});

// friend
Object.extend(Iyxzone.URL, {

  destroyFriend: function(friendID, params){
    return this.build("/friends/" + friendID, params);
  }

});

// email contacts
Object.extend(Iyxzone.URL, {

  parseEmailContacts: function(params){
    return this.build("/email_contacts/parse", params);
  },

  createMultipleSignupInvitations: function(params){
    return this.build("/signup_invitations/create_multiple", params);
  },

  listSignupInvitation: function(params){
    return this.build("/signup_invitations", params);
  },

  createSignupInvitation: function(params){
    return this.build("/signup_invitations", params);
  }

});

// guild
Object.extend(Iyxzone.URL, {

  createGuild: function(params){
    return this.build("/guilds", params);
  },

  updateGuild: function(guildID, params){
    return this.build("/guilds/" + guildID, params);
  },

  showGuild: function(guildID, params){
    return this.build("/guilds/" + guildID, params);
  },

  deleteGuild: function(guildID, params){
    return this.build("/guilds/" + guildID, params);
  },

  listGuild: function(userID, params){
    return this.build("/guilds?uid=" + userID, params);
  },

  newGuildInvitation: function(guildID, params){
    return this.build("/guilds/" + guildID + "/invitations/new", params);
  },

  createGuildInvitation: function(guildID, params){
    return this.build("/guilds/" + guildID + "/invitations", params);
  },

  acceptGuildInvitation: function(guildID, invitationID, params){
    return this.build("/guilds/" + guildID + "/invitations/" + invitationID + "/accept", params);
  },

  declineGuildInvitation: function(guildID, invitationID, params){
    return this.build("/guilds/" + guildID + "/invitations/" + invitationID + "/decline", params);
  },

  createGuildRequest: function(guildID, requestID, params){
    return this.build("/guilds/" + guildID + "/requests", params);
  },

  acceptGuildRequest: function(guildID, requestID, params){
    return this.build("/guilds/" + guildID + "/requests/" + requestID + "/accept", params);
  },

  declineGuildRequest: function(guildID, requestID, params){
    return this.build("/guilds/" + guildID + "/requests/" + requestID + "/decline", params);
  },

  updateMembership: function(guildID, membershipID, params){
    return this.build("/guilds/" + guildID + "/memberships/" + membershipID, params);
  },

  deleteMembership: function(guildID, membershipID, params){
    return this.build("/guilds/" + guildID + "/memberships/" + membershipID, params);
  }

});

// report
Object.extend(Iyxzone.URL, {

  createReport: function(params){
    return this.build("/reports", params);
  }

});

// feed delivery
Object.extend(Iyxzone.URL, {

  moreFeedDelivery: function(params){
    return this.build("/feed_deliveries", params);
  },

  showFeedDelivery: function(deliveryID, params){
    return this.build("/feed_deliveries/" + deliveryID, params);
  },

  deleteFeedDelivery: function(deliveryID, params){
    return this.build("/feed_deliveries/" + deliveryID, params);
  }

});

// mini blog
Object.extend(Iyxzone.URL, {

  deleteMiniImage: function(imageID, params){
    return this.build("/mini_images/" + imageID, params);
  },

  createMiniLink: function(params){
    return this.build("/mini_links", params);
  },

  listMiniBlog: function(type, params){
    return this.build("/mini_blogs/" + type, params);
  },

  deleteMiniBlog: function(blogID, params){
    return this.build("/mini_blogs/" + blogID, params);
  },

  forwardMiniBlog: function(blogID, params){
    return this.build("/mini_blogs/" + blogID + "/forward", params);
  },

  createMiniBlog: function(params){
    return this.build("/mini_blogs", params);
  },

  createMiniTopicAttention: function(params){
    return this.build("/mini_topic_attentions", params);
  },

  deleteMiniTopicAttention: function(id, params){
    return this.build("/mini_topic_attentions/" + id, params);
  }

});

// comment
Object.extend(Iyxzone.URL, {

  createComment: function(params){
    return this.build("/comments", params);
  },

  deleteComment: function(id, params){
    return this.build("/comments/" + id, params);
  },

  createWallMessage: function(params){
    return this.build("/wall_messages", params);
  },

  deleteWallMessage: function(messageID, params){
    return this.build("/wall_messages/" + messageID, params);
  },

  listWallMessagesWithForm: function(params){
    return this.build("/wall_messages/index_with_form", params);
  }

});

// profile
Object.extend(Iyxzone.URL, {

  editProfile: function(profileID, params){
    return this.build("/profiles/" + profileID + "/edit", params);
  },

  updateProfile: function(profileID, params){
    return this.build("/profiles/" + profileID, params);
  }

});

// chinese region
Object.extend(Iyxzone.URL, {

  showCity: function(cityID, params){
    return this.build("/cities/" + cityID, params);
  },

  showRegion: function(regionID, params){
    return this.build("/regions/" + regionID, params);
  }

});

// guestbook
Object.extend(Iyxzone.URL, {

  createGuestbook: function(params){
    return this.build("/guestbooks", params);
  }

});

// notices
Object.extend(Iyxzone.URL, {

  listNotice: function(params){
    return this.build("/notices", params);
  },

  readNotice: function(noticeID, params){
    return this.build("/notices/" + noticeID + "/read", params)
  }

});

// Skin
Object.extend(Iyxzone.URL, {

  showSkin: function(skinID, params){
    return this.build("/skins/" + skinID, params);
  }

});

// captcha
Object.extend(Iyxzone.URL, {

  newCaptcha: function(params){
    return this.build("/captchas/new", params);
  }

});

// instant message
Object.extend(Iyxzone.URL, {

  readMessage: function(params){
    return this.build("/messages/read", params);
  },

  listMessage: function(params){
    return this.build("/messages", params);
  },

  createMessage: function(params){
    return this.build("/messages", params);
  }

});

//rss
Object.extend(Iyxzone.URL, {

  createRssFeed: function(params){
    return this.build("/rss_feeds", params);
  },

  destroyRssFeed: function(rssID, params){
    return this.build("/rss_feeds/" + rssID, params);
  },

  showRssFeed: function(rssID, params){
    return this.build("/rss_feeds/" + rssID, params);
  },

  newRssFeed: function(params){
    return this.build("/rss_feeds/new", params);
  }

});

// forum
Object.extend(Iyxzone.URL, {

  showForum: function(forumID, params){
    return this.build("/forums/" + forumID, params);
  },

  createTopic: function(forumID, params){
    return this.build("/topics", Object.extend({'forum_id': forumID}, params || {}));
  },

  listTopic: function(forumID, params){
    return this.build("/topics", Object.extend({'forum_id': forumID}, params || {}));
  },

  listTopTopic: function(forumID, params){
    return this.build("/topics/top", Object.extend({'forum_id': forumID}, params || {}));
  },

  listGuildTopic: function(guildID, params){
    return this.build("/guilds/" + guildID + "/topics", params);
  },

  toggleTopic: function(topicID, params){
    return this.build("/topics/" + topicID + "/toggle", params);
  }, 

  deleteTopic: function(topicID, params){
    return this.build("/topics/" + topicID, params);
  },

  showTopic: function(topicID, params){
    return this.build("/topics/" + topicID, params);
  },

  createPost: function(topicID, params){
    return this.build("/posts", Object.extend({'topic_id': topicID}, params || {}));
  },

  deletePost: function(postID, params){
    return this.build("/posts/" + postID, params);
  }

});
