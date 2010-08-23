Iyxzone.Guild = {
  
  version: '1.6',
  
  author: ['高侠鸿'],
  
  Builder: {},
  
  Presentor: {},

  Invitation: {},

  Request: {},

  MemberManager: {},

  follow: function(name, gid){
    new Ajax.Request('/mini_topic_attentions', {
      method: 'post',
      parameters: {'name': name},
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      }.bind(this),
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('follow_guild_' + gid).innerHTML = '<a onclick="Iyxzone.Guild.unfollow(' + json.id + ', \'' + name + '\', ' + gid + '); return false;" href="#"><span class="i iNoFollow"></span>取消关注</a>';
        }else{
          error('发生错误');
        }
      }.bind(this)
    });

  },

  unfollow: function(id, name, gid){
    new Ajax.Request('/mini_topic_attentions/' + id, {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('follow_guild_' + gid).update('<a onclick="Iyxzone.Guild.follow(\'' + name + '\', ' + gid + '); return false;" href="#"><span class="i iFollow"></span>关注</a>');
        }else{
          error('发生错误');
        }
      }.bind(this)
    });
  }

};

// destroy
Object.extend(Iyxzone.Guild, {

  deleteGuild: function(guildID, userID){
    new Ajax.Request(Iyxzone.URL.deleteGuild(guildID), {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.listGuild(userID);
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  confirmDeletingGuild: function(guildID, userID){
    Iyxzone.Facebox.confirmWithCallback("你确定要删除这个工会吗", null, null, function(){
      this.deleteGuild(guildID, userID);
    }.bind(this));
  }

});

// 一些guild/show页面上的函数
Object.extend(Iyxzone.Guild.Presentor, {

  feedIdx: null,

  fetchSize: null,

  curTab: null,

  guildID: null,

  albumID: null,

  presidentID: null,

  cache: new Hash(),

  init: function(guildID, albumID, presidentID, fetchSize){
    this.guildID = guildID;
    this.albumID = albumID;
    this.presidentID = presidentID;
    this.curTab = 'feed';
    this.feedIdx = 1;
    this.fetchSize = fetchSize;
    this.cache.set('feed', $('presentation').innerHTML);
  },

  setTab: function(type){
    $('tab_feed').writeAttribute('class', 'fix unSelected');
    $('tab_topic').writeAttribute('class', 'fix unSelected');
    $('tab_photo').writeAttribute('class', 'fix unSelected');
    $('tab_wall').writeAttribute('class', 'fix unSelected');
    $('tab_' + type).writeAttribute('class', 'fix');
  },

  showFeeds: function(){
    if(this.curTab == 'feed')
      return;
  
    this.setTab('feed');
    this.curTab = 'feed';
    this.feedIdx = 1;

    // html 必然存在 
    var html = this.cache.get('feed');
    if(html){
      $('presentation').innerHTML = html;
      return;
    }
  },

  moreFeeds: function(){
    // send ajax request
    new Ajax.Request('/feed_deliveries', {
      method: 'get',
      parameters: {recipient_id: this.guildID, recipient_type: 'Guild', fetch: this.fetchSize, idx: this.feedIdx},
      onLoading: function(){
        $('more_feed_panel').innerHTML = '<div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div>';
        this.cache.set('feed', $('presentation').innerHTML);
      }.bind(this),
      onSuccess: function(transport){
        var newFeeds = new Element('div').update(transport.responseText);
        var moreFeeds = new Element('div');
        var len = newFeeds.childElements().length;
        if(len == 0 || len < this.fetchSize){
          moreFeeds.update(this.noFeedHTML());
        }else{
          moreFeeds.update(this.moreFeedHTML());
        }
        
        if(this.curTab == 'feed'){
          $('feed_list').insert({bottom: newFeeds.innerHTML});
          $('more_feed_panel').update(moreFeeds.innerHTML);
          this.cache.set('feed', $('presentation').innerHTML);
        }else{
          var html = this.cache.get('feed');
          var tmp = new Element('div').update(html);
          var oldFeedList = tmp.childElements()[0];
          var oldMoreFeeds = tmp.childElements()[2];
          oldFeedList.insert({bottom: newFeeds.innerHTML});
          oldMoreFeeds.update(moreFeeds.innerHTML);
          this.cache.set('feed', tmp.innerHTML);
        }
  
        this.feedIdx = this.feedIdx + 1; 
      }.bind(this)
    });
  },

  noFeedHTML: function(){
    return this.baseHTML('<div class="jl-more">没有更多了...</div>');
  },

  moreFeedHTML: function(){
    return this.baseHTML('<a href="javascript:void(0)" onclick="Iyxzone.Guild.Presentor.moreFeeds();" class="jl-more">更多新鲜事</a>');
  },

  baseHTML: function(con){
    var html = '<div class="round04 round_r_t jl-read-more space s_clear">';
    html += '<div class="round_l_t"><div class="round_r_b"><div class="round_l_b"><div class="round_m"><div class="round_body" id="more_feed_link">';
    html +=  con;
    html += '</div></div></div></div></div></div>';
    return html;
  },

  showPhotos: function(){
    if(this.curTab == 'photo')
      return;

    this.setTab('photo');
    this.curTab = 'photo';

    var html = this.cache.get('photo')
    
    if(html){
      $('presentation').innerHTML = html;
      return;
    }

    new Ajax.Request('/guild_photos?album_id=' + this.albumID, {
      method: 'get',
      onLoading: function(){
        $('presentation').update('<div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div>');
        this.cache.set('photo', $('presentation').innerHTML); //这保证了最多1个请求
      }.bind(this),
      onSuccess: function(transport){
        this.cache.set('photo', transport.responseText);
        if(this.curTab == 'photo'){
          $('presentation').innerHTML = transport.responseText;
        }
      }.bind(this)
    });
  },

  showTopics: function(){
    if(this.curTab == 'topic')
      return;

    this.setTab('topic');
    this.curTab = 'topic';

    var html = this.cache.get('topic');

    if(html){
      $('presentation').innerHTML = html;
      return;
    }

    new Ajax.Request('/guilds/' + this.guildID + '/topics', {
      method: 'get',
      onLoading: function(){
        $('presentation').update('<div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div>');
        this.cache.set('topic', $('presentation').innerHTML); //这保证了最多1个请求
      }.bind(this),
      onSuccess: function(transport){
        this.cache.set('topic', transport.responseText);
        if(this.curTab == 'topic'){
          $('presentation').innerHTML = transport.responseText;
        }
      }.bind(this)
    });
  },

  showWall: function(){
    if(this.curTab == 'wall')
      return;

    this.setTab('wall');
    this.curTab = 'wall';

    var html = this.cache.get('wall');

    if(html){
      $('presentation').innerHTML = html;
      return;
    }

    new Ajax.Request('/wall_messages/index_with_form', {
      method: 'get',
      parameters: {wall_type: 'guild', wall_id: this.guildID, recipient_id: this.presidentID},
      onLoading: function(){
        $('presentation').update('<div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div>');
        this.cache.set('wall', $('presentation').innerHTML); //这保证了最多1个请求
      }.bind(this),
      onSuccess: function(transport){
        this.cache.set('wall', transport.responseText);
        if(this.curTab == 'wall'){
          $('presentation').innerHTML = transport.responseText;
        }
      }.bind(this)
    });      
  }

});

Object.extend(Iyxzone.Guild.Builder, {

  validate: function(onCreate){
    var name = $('guild_name').value;
    if(name == ''){
      error("名字不能为空");
      return false;
    }else if(name.length >= 100){
      error("名字最长100个字");
      return false;
    }

    var characterID = $('guild_character_id').value;
    if(characterID == ''){
      error("请选择游戏角色");
      return false;
    }

    var desc = $('guild_description').value;
    if(desc == ''){
      error("介绍下工会把");
      return false;
    }else if(desc.length > 1000){
      error("工会介绍最长10000个字");
      return false;
    }

    return true;
  },

  save: function(form, button){
    Iyxzone.disableButtonThree(button, '请等待..');
    if(this.validate()){
      new Ajax.Request(Iyxzone.URL.createGuild(), {
        method: 'post',
        parameters: $(form).serialize(),
        onLoading: function(){
          Iyxzone.changeCursor('wait');
        },
        onComplete: function(){
          Iyxzone.changeCursor('default');
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.newGuildInvitation(json.id);
          }else{
            error("保存的时候发生错误，请稍后再试");
            Iyxzone.enableButtonThree(button, '提交');
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButtonThree(button, '提交');
    } 
  },
  
  update: function(guildID, form, button){
    Iyxzone.disableButtonThree(button, '请等待..');
    if(this.validate()){
      new Ajax.Request(Iyxzone.URL.updateGuild(guildID), {
        method: 'post',
        parameters: $(form).serialize(),
        onLoading: function(){
          Iyxzone.changeCursor('wait');
        },
        onComplete: function(){
          Iyxzone.changeCursor('default');
        },
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.showGuild(guildID);
          }else{
            error("保存的时候发生错误，请稍后再试");
            Iyxzone.enableButtonThree(button, '提交');
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButtonThree(button, '提交');
    }
  }

});

Iyxzone.Guild.Invitation = {
  
  Builder: {},

  // 在所有的邀请页面接受请求
  accept1: function(invitationID, guildID){
    var btn1 = $('gi_btn1_' + invitationID);
    var btn2 = $('gi_btn2_' + invitationID);

    new Ajax.Request(Iyxzone.URL.acceptGuildInvitation(guildID, invitationID), {
      method: 'put',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        btn1.disabled = 'disabled';
        btn2.disabled = 'disabled';
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        btn1.disabled = '';
        btn2.disabled = '';
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('gi_' + invitationID).innerHTML = '<div class="hd"><span class="icon-invitation"></span>你已经加入了工会，快去看看<a href="' + Iyxzone.URL.showGuild(guildID) + '"><strong>工会主页</strong></a></div>'; 
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  decline1: function(invitationID, guildID){
    var btn1 = $('gi_btn1_' + invitationID);
    var btn2 = $('gi_btn2_' + invitationID);

    new Ajax.Request(Iyxzone.URL.declineGuildInvitation(guildID, invitationID), {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        btn1.disabled = 'disabled';
        btn2.disabled = 'disabled';
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        Iyxzone.Facebox.close();
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('gi_' + invitationID).innerHTML = '<strong class="nowrap"><span class="icon-success"></span>已经拒绝邀请！</strong>';
          setTimeout(function(){new Effect.Fade('guild_invitation_' + invitationID);}, 2000);
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  accept2: function(invitationID, guildID){
    var btn1 = $('gi_btn1');
    var btn2 = $('gi_btn2');

    new Ajax.Request(Iyxzone.URL.acceptGuildInvitation(guildID, invitationID), {
      method: 'put',
      parameters: {'status': status},
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        btn1.disabled = 'disabled';
        btn2.disabled = 'disabled';
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        btn1.disabled = '';
        btn2.disabled = '';
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showGuild(guildID);
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  decline2: function(invitationID, guildID){
    var btn1 = $('gi_btn1');
    var btn2 = $('gi_btn2');

    new Ajax.Request(Iyxzone.URL.declineGuildInvitation(guildID, invitationID), {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        btn1.disabled = 'disabled';
        btn2.disabled = 'disabled';
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        Iyxzone.Facebox.close();
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showGuild(guildID);
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  }

}

Object.extend(Iyxzone.Guild.Invitation.Builder, {

  selected: new Hash(),

  onClick: function(td, val){
    if(this.selected.get(val)){
      td.setStyle({background: 'white'});
      this.selected.unset(val);
    }else{
      this.selected.set(val, td)
      td.setStyle({background: '#DEFEBB'});
    } 
  },

  submit: function(button, guildID){
    if(this.selected.size() == 0){
      error('你必须至少邀请一个游戏角色');
    }else{
      Iyxzone.disableButton(button,'请等待..');

      // construct url
      var params = "";
      this.selected.each(function(pair){
        if(params != "")
          params += "&";
        params += 'values[]=' + pair.key;
      });
 
      new Ajax.Request(Iyxzone.URL.createGuildInvitation(guildID), {
        method: 'post',
        parameters: params,
        onLoading: function(){},
        onComplete: function(){},
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            window.location.href = Iyxzone.URL.showGuild(guildID);
          }else if(json.code == 0){
            error("发生错误，请稍后再试试");
            Iyxzone.enableButton(button, '确定'); 
          }
        }.bind(this)
      });
    }
  },

  reset: function(){
    this.selected = new Hash();
  },

  search: function(){
    var val = this.field.value;
    var ul = $('invitee_list');
    var els = ul.childElements();

    els.each(function(li){
      var pinyin = li.readAttribute('pinyin');
      var name = li.readAttribute('name');
      if(name.include(val) || pinyin.include(val)){
        li.show();
      }else{
        li.hide();
      }
    }.bind(this));

    this.timer = setTimeout(this.search.bind(this), 300);
  },

  startObservingInput: function(field){
    this.field = field;
    this.timer = setTimeout(this.search.bind(this), 300);
  },

  stopObservingInput: function(){
    clearTimeout(this.timer);
  }

});

Object.extend(Iyxzone.Guild.Request, {

  send: function(guildID, form, btn){
    new Ajax.Request(Iyxzone.URL.createGuildRequest(guildID), {
      method: 'post', 
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.disableButton(btn, "发送中..");
      },
      onComplete: function(){
        Iyxzone.enableButton(btn, "完成");
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          Iyxzone.Facebox.close();
          window.location.href = Iyxzone.URL.showGuild(guildID);
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  accept: function(guildID, requestID){
    var btn1 = $('gr_btn1_' + requestID);
    var btn2 = $('gr_btn2_' + requestID);

    new Ajax.Request(Iyxzone.URL.acceptGuildRequest(guildID, requestID), {
      method: 'put', 
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        btn1.writeAttribute('onclick', '');
        btn2.writeAttribute('onclick', '');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('gr_' + requestID + '_info').innerHTML = '<strong class="nowrap"><span class="icon-success"></span>成功！</strong>';
          setTimeout(function(){new Effect.Fade('gr_' + requestID );}, 2000);
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
          btn1.writeAttribute('onclick', 'Iyxzone.Guild.Request.accept(' + guildID + ',' + requestID + ');');
          btn2.writeAttribute('onclick', 'Iyxzone.Guild.Request.decline(' + guildID + ',' + requestID + ');');        
        }
      }.bind(this)
    });
  },

  decline: function(guildID, requestID){
    var btn1 = $('gr_btn1_' + requestID);
    var btn2 = $('gr_btn2_' + requestID);

    new Ajax.Request(Iyxzone.URL.declineGuildRequest(guildID, requestID), {
      method: 'delete', 
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        btn1.writeAttribute('onclick', '');
        btn2.writeAttribute('onclick', '');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('gr_' + requestID + '_info').innerHTML = '<strong class="nowrap"><span class="icon-success"></span>成功拒绝！</strong>';
          setTimeout(function(){new Effect.Fade('gr_' + requestID );}, 2000);
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
          btn1.writeAttribute('onclick', 'Iyxzone.Guild.Request.accept(' + guildID + ',' + requestID + ');');
          btn2.writeAttribute('onclick', 'Iyxzone.Guild.Request.decline(' + guildID + ',' + requestID + ');');
        }
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.Guild.MemberManager, {

  currentID: null,

  currentStatus: null,

  guildID: null,

  roleList: null,

  setGuildID: function(guildID){
    this.guildID = guildID;
  },

  startObservingInput: function(field){
    this.field = field;
    this.timer = setTimeout(this.search.bind(this), 300);
  },

  stopObservingInput: function(field){
    clearTimeout(this.timer);
  },

  search: function(){
    var val = this.field.value;
    var ul = $('members');
    ul.childElements().each(function(li){
      var pinyin = li.readAttribute('pinyin');
      var name = li.readAttribute('name');
      if(pinyin.include(val) || name.include(val)){
        li.show();
      }else{
        li.hide();
      }
    }.bind(this));
    this.timer = setTimeout(this.search.bind(this), 300);
  },

  buildRoleList: function(){
    this.roleList = new Element('div', {'class': 'drop-wrap'});
    var div = new Element('div', {'class': 'wrap-bg'});
    var dl = new Element('dl');
    var dd = new Element('dd', {'class': 'jt-cutline'});
    var veteran = new Element('a', {href: 'javascript:void(0)'}).update('工会长老');
    var member = new Element('a', {href: 'javascript:void(0)'}).update('普通会员');
      
    dd.appendChild(veteran);
    dd.appendChild(member);
    dl.appendChild(dd);
    this.roleList.appendChild(div);
    this.roleList.appendChild(dl);

    document.observe('click', function(){
      this.roleList.hide();
    }.bind(this));
    veteran.observe('click', function(event){
      Event.stop(event);
      this.changeRole(3);
    }.bind(this));
    member.observe('click', function(event){
      Event.stop(event);
      this.changeRole(4);
    }.bind(this));
  },

  toggleRoleList: function(membershipID, status, event, span){
    Event.stop(event);

    if(this.isChanging){
      return;
    }
    
    if(this.roleList){
      if(this.currentID == membershipID){
        if(this.roleList.visible()){
          this.roleList.hide();
          this.currentID = null;
          this.currentStatus = null;
        }else{
          this.roleList.show();
          this.currentID = membershipID;
          this.currentStatus = status;
        }
      }else{
        if(this.roleList.visible()){
          Element.insert(span, {after: this.roleList});
          this.currentID = membershipID;
          this.currentStatus = status;
        }else{
          Element.insert(span, {after: this.roleList});
          this.roleList.show();
          this.currentID = membershipID;
          this.currentStatus = status;
        }
      }
    }else{
      this.buildRoleList();
      Element.insert(span, {after: this.roleList});
      this.currentID = membershipID;
      this.currentStatus = status;
    }
  },

  changeRole: function(status){
    if(this.isChanging){
      return;
    }

    if(status == this.currentStatus){
      this.roleList.hide();
    }else{
      new Ajax.Request(Iyxzone.URL.updateMembership(this.guildID, this.currentID), {
        method: 'put',
        parameters: 'status=' + status,
        onLoading: function(){
          this.isChanging = true;
          Iyxzone.changeCursor('wait');
          this.roleList.hide();
        }.bind(this),
        onComplete: function(){
          this.isChanging = false;
          Iyxzone.changeCursor('default');
        }.bind(this),
        onSuccess: function(transport){
          var json = transport.responseText.evalJSON();
          if(json.code == 1){
            $("ms_" + this.currentID).update(status == 3 ? '长老' : '会员');
            $('ms_' + this.currentID).writeAttribute('onclick', "Iyxzone.Guild.MemberManager.toggleRoleList(" + this.currentID + ", " + status + ", event, $(this).up());");
            this.currentStatus = status;
          }else if(json.code == 0){
            error("发生错误，请稍后再试");
          }
        }.bind(this)
      });
    }
  },

  evict: function(membershipID, guildID, link){
    new Ajax.Request(Iyxzone.URL.deleteMembership(guildID, membershipID), {
      method: 'delete',
      onLoading: function(){
        $(link).writeAttribute('onclick', '');
      },
      onComplete: function(){
        Iyxzone.Facebox.close();
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('m_' + membershipID + '_info').innerHTML = '<strong class="nowrap"><span class="icon-success"></span>成功剔除此人！</strong>';
          setTimeout(function(){new Effect.Fade('m_' + membershipID);}, 2000); 
        }else{
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    }); 
  },

  confirmEvicting: function(membershipID, guildID, link){
    Iyxzone.Facebox.confirmWithCallback("你确定要剔除此人吗?", null, null, function(){
      this.evict(membershipID, guildID, link);
    }.bind(this));
  }

});
