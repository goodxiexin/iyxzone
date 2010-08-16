Iyxzone.Idol = {
  
  version: '1.0',

  author: '高侠鸿',

  Pub: {}

};

// follow, unfollow
Object.extend(Iyxzone.Idol, {

  follow: function(idolID, link){
    new Ajax.Request(Iyxzone.URL.followIdol(idolID), {
      method: 'post',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        $(link).writeAttribute("onclick", "");
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          var unfollowLink = '<a href="javascript:void(0)" onclick="Iyxzone.Idol.unfollow(' + idolID + ', this);"><span class="i iNoFollow"></span>不做粉丝</a>';
          if($('idol_' + idolID + '_op'))
            $('idol_' + idolID + '_op').innerHTML =  unfollowLink;
        }else if(json.code == 0){
          error('发生错误，请稍后再试');
          $(link).writeAttribute('onclick', "Iyxzone.Idol.follow(idolID, this);");
        }
      }.bind(this)
    });
  },

  unfollow: function(idolID, link){
    new Ajax.Request(Iyxzone.URL.unfollowIdol(idolID), {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        $(link).writeAttribute('onclick', '');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          var followLink = '<a href="javascript:void(0)" onclick="Iyxzone.Idol.follow(' + idolID + ', this);"><span class="i iFollow"></span>成为粉丝</a>';
          if($('idol_' + idolID + '_op'))
            $('idol_' + idolID + '_op').innerHTML = followLink;
        }else if(json.code == 0){
          error('发生错误，请稍后再试');
          $(link).writeAttribute('click', "Iyxzone.Idol.unfollow(idolID, this);");
        }
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.Idol.Pub, {

  
  infos: new Hash(), //game_id => {:game => game_info, :idols => idol_infos}

  idolHTMLCache: new Hash(), // idol_id => idol info html

  addGameIdols: function(gameInfo, idols){
    var gameID = gameInfo.id;
    this.infos.set(gameID, {'game': gameInfo, 'idols': idols});
  },

  getIdolInfo: function(gameID, idolID){
    var info = this.infos.get(gameID);
    if(info){
      var idols = info.idols;
      for(var i=0;i<idols.length;i++){
        if(idols[i].id == idolID){
          return idols[i];
        }
      }
      return null;
    }else{
      return null;
    } 
  },

  getGameInfo: function(gameID){
    var info = this.infos.get(gameID);
    if(info){
      return info.game;
    }else{
      return null;
    }
  },

  curIdolID: null,

  hideIdolInfo: function(idolID){
    $('idol_info_' + idolID).remove();
    $('idol_' + idolID).writeAttribute('class', '');
    if(this.curIdolID == idolID){
      this.curIdolID = null;
    }
  },

  showIdolInfo: function(idolID, gameID, img){
    if(this.curIdolID == idolID){
      return;
    }

    var gameInfo = this.getGameInfo(gameID);
    var idolInfo = this.getIdolInfo(gameID, idolID);
    
    if(gameInfo == null || idolInfo == null){
      return;
    }

    if(this.curIdolID != null){
      this.hideIdolInfo(this.curIdolID);
    }
    this.curIdolID = idolID;

    var div = this.idolHTMLCache.get(idolID);
    if(div == null){
      div = this.buildIdolHTML(gameInfo, idolInfo, img);
      this.idolHTMLCache.set(idolID, div);
    }

    $('idol_' + idolID).appendChild(div);
    $('idol_' + idolID).writeAttribute('class', 'selected');
  },

  buildIdolHTML: function(gameInfo, idolInfo, img){
    var div = new Element('div', {'class': 'starCard box04', 'id': 'idol_info_' + idolInfo.id});
    var html = '';
    html += '<div class="wrap">';
    html += '<div class="op"><a href="javascript:void(0)" onclick="Iyxzone.Idol.Pub.hideIdolInfo(' + idolInfo.id + ');" class="icon-active"></a></div>';
    html += '<div class="avatar"><img alt="" class="imgbox01" src="' + img.src + '"></img><br/>';
    html += '<div id="idol_' + idolInfo.id + '_op">';
    if(idolInfo.followed){
      html += '<a href="javascript:void(0)" onclick="Iyxzone.Idol.unfollow(' + idolInfo.id + ', this);" ><span class="i iNoFollow"></span>不做粉丝</a>';
    }else{
      html += '<a href="javascript:void(0)" onclick="Iyxzone.Idol.follow(' + idolInfo.id + ', this);" ><span class="i iFollow"></span>成为粉丝</a>';
    }
    html += '</div>';
    html += '</div>';
    html += '<div class="con">';
    html += '<div class="memberName"><a class="red" target="_blank" href="' + Iyxzone.URL.showProfile(idolInfo.profile_id) + '">' + idolInfo.login + '</a></div>';
    html += '<div class="gameName"><a target="_blank" href="' + Iyxzone.URL.showGame(gameInfo.id) + '">' + gameInfo.name + '</a></div>';
    html += '<div class="data fix">';
    html += '<div class="left pipe"><span class="num">' + idolInfo.fans_count + '</span><br/>粉丝</div>';
    html += '<div class="left"><span class="num">' + idolInfo.mini_blogs_count + '</span><br/>微博</div>';
    html += '</div>';
    html += '<div class="intro">' + idolInfo.motto + '</div>';
    html += '<div><a target="_blank" href="' + Iyxzone.URL.listMiniBlog(idolInfo.id) + '">查看个人微博>></a></div>';
    html += '</div>';
    html += '</div>';
    div.update(html);
    return div;
  },

  toggleAllIdols: function(gameID, cb){
    var checkboxes = $$('input[type="checkbox"][id^="cb_' + gameID + '_"]');
    for(var i=0;i<checkboxes.length;i++){
      checkboxes[i].checked = cb.checked;
    }
  },

  followMultiple: function(gameID, btn){
    var idolIDs = new Array();
    var checkboxes = $$('input[type="checkbox"][id^="cb_' + gameID + '_"]');
    for(var i=0;i<checkboxes.length;i++){
      if(checkboxes[i].checked){
        var idolID = checkboxes[i].id.split('_').last();
        idolIDs.push(idolID);
      }
    }

    var params = "";
    for(var i=0;i<idolIDs.length;i++){
      params += "ids[]=" +idolIDs[i];
      params += "&";
    }
    
    new Ajax.Request(Iyxzone.URL.followMultipleIdols(), {
      method: 'post',
      parameters: params,
      onLoading: function(){
        Iyxzone.changeCursor('wait');
        $(btn).disabled = 'disabled';
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
        $(btn).disabled = '';
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          notice("你已经成功成为了他们的粉丝");
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  }

});
