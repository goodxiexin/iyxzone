Iyxzone.URL = {
  author: "高侠鸿",

  // params should be an non-empty hash
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

// friend request url
Object.extend(Iyxzone.URL, {

  createFriendRequest: function(friendID, params){
    return this.build("/friend_requests?friend_id=" + friendID, params);
  },

  acceptFriendRequest: function(requestID, params){
    return this.build("/friend_requests/" + requestID + "/accept", params);
  },

  declineFriendRequest: function(requestID, params){
    return this.build("/friend_requests/" + requestID + "/decline", params);
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
  }

});

// profile url
Object.extend(Iyxzone.URL, {
  
  showProfile: function(profileID, params){
    return this.build("/profiles/" + profileID, params);
  }

});

// game url
Object.extend(Iyxzone.URL, {

  showGame: function(gameID, params){
    return this.build("/games/" + gameID, params);
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
