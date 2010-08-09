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
