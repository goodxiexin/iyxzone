Iyxzone.Guild = {
  version: '1.4',
  author: ['高侠鸿'],
  Builder: {},
  Editor: {},
  MemberManager: {},
  Presentor: {}
};

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
