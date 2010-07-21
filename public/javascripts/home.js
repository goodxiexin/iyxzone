Iyxzone.Home = {

  version: '1.0',

  author: ['高侠鸿'],

  Feeder: {},

  NoticeManager: {}

};

Object.extend(Iyxzone.Home.NoticeManager, {

  fetch: function(){
    new Ajax.Request('notices/first_ten', {
      method: 'get',
      onSuccess: function(transport){
        $('my_notices').update(transport.responseText);
      }.bind(this)
    });
  },

  read: function(noticeID, token){
    new Ajax.Request('/notices/' + noticeID + '/read', {
      method: 'put',
      parameters: "authenticity_token=" + encodeURIComponent(token),
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onSuccess: function(transport){
        $('my_notices').innerHTML = transport.responseText;
        Iyxzone.changeCursor('default');
      }.bind(this)
    });
  },

  readSingle: function(noticeID, token){
    new Ajax.Request('/notices/' + noticeID + '/read', {
      method: 'put',
      parameters: "single=1&authenticity_token=" + encodeURIComponent(token),
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onSuccess: function(transport){
        Iyxzone.changeCursor('default');
        $('my_notices').innerHTML = transport.responseText;
      }.bind(this)
    });    
  }

});

Object.extend(Iyxzone.Home.Feeder, {
  
  idx: 1, 

  type: 'all',

  cache: new Hash(),

  loading: function(div){
    div.innerHTML = "<div class='ajaxLoading'><img src='/images/ajax-loader.gif' /></div>";
  },

  setTab: function(type){
    $('tab_all').className = '';
    $('tab_blog').className = '';
    $('tab_photo').className = '';
    $('tab_video').className = '';
    $('tab_' + type).className = 'hover';
    this.type = type;
  },

  showFeeds: function(userID, type, fetchSize){
    if(this.type == type)
      return;

    // save old
    this.cache.set(this.type, {html: $('feed_panel').innerHTML, idx: this.idx});

    // try to load from cache
    var info = this.cache.get(type);
    if(info){
      $('feed_list').innerHTML = info.html;
      this.idx = info.idx;
      this.setTab(type);
      return;
    }

    // get new
    new Ajax.Request('/feed_deliveries', {
      method: 'get',
      parameters: {recipient_id: userID, recipient_type: 'User', category: type, fetch: fetchSize},
      onLoading: function(){
        this.idx = 0;
        this.setTab(type);
        $('feed_list').update('');
        this.loading($('more_feed_panel'));
      }.bind(this),
      onSuccess: function(transport){
        if(this.type == type){
          this.handleResult(transport, userID, fetchSize);
          this.idx = 1;
        }
      }.bind(this)
    });
  },

  moreFeeds: function(userID, fetchSize){
    var old_type = this.type;

    new Ajax.Request('/feed_deliveries', {
      method: 'get',
      parameters: {recipient_id: userID, recipient_type: 'User', fetch: fetchSize, category: this.type, idx: this.idx},
      onLoading: function(){
        this.loading($('more_feed_panel'));
      }.bind(this),
      onSuccess: function(transport){
        if(this.type == old_type){
          this.handleResult(transport, userID, fetchSize);
          this.idx++;
        }
      }.bind(this)
    });
  },

  handleResult: function(transport, userID, fetchSize){
    var tmp = new Element('div');
    tmp.innerHTML = transport.responseText;
    $('feed_list').insert({bottom: tmp.innerHTML});
    var len = tmp.childElements().length;
    if(len == 0 || len < fetchSize){ //说明没有了
      $('more_feed_panel').update(this.noFeedHTML());
    }else{
      $('more_feed_panel').update(this.moreFeedHTML(userID, fetchSize));
    }
  },

  noFeedHTML: function(){
    return this.baseHTML('<div class="jl-more">没有更多了...</div>');
  },

  moreFeedHTML: function(userID, fetchSize){
    return this.baseHTML('<a href="javascript:void(0)" onclick="Iyxzone.Home.Feeder.moreFeeds(' + userID + ', ' + fetchSize + ');" class="jl-more">更多新鲜事</a>');
  },

  baseHTML: function(con){
    var html = '<div class="round04 round_r_t jl-read-more space s_clear">';
    html += '<div class="round_l_t"><div class="round_r_b"><div class="round_l_b"><div class="round_m"><div class="round_body" id="more_feed_link">';
    html +=  con;
    html += '</div></div></div></div></div></div>';
    return html;
  }

});
