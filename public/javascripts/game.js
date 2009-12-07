GameManager = Class.create({

  initialize: function(){
  },

  prepare: function(game_selector, area_selector, server_selector, race_selector, profession_selector){
    this.game_selector = game_selector;
    this.area_selector = area_selector;
    this.server_selector = server_selector;
    this.race_selector = race_selector;
    this.profession_selector = profession_selector;
  },

  reset_game_info: function(){
    this.game_selector.value = '';
  },

  reset_area_info: function(){
    this.area_selector.innerHTML = '<option value="">---</option>';
  },

  setup_area_info: function(areas){
    var html = '<option value="">---</option>';
    for(var i=0;i<areas.length;i++){
      html += "<option value='" + areas[i].game_area.id + "'>" + areas[i].game_area.name + "</option>";
    }
    this.area_selector.innerHTML = html;
  },

  reset_server_info: function(){
    this.server_selector.innerHTML = '<option value="">---</option>';
  },

  setup_server_info: function(servers){
    var html = '<option value="">---</option>';
    for(var i=0;i<servers.length;i++){
      html += "<option value='" + servers[i].game_server.id + "'>" + servers[i].game_server.name + "</option>";
    }
    this.server_selector.innerHTML = html;
  },

  reset_profession_info: function(){
    this.profession_selector.innerHTML = '<option value="">---</option>';
  },

  setup_profession_info: function(professions){
    var html = '<option value="">---</option>';
    for(var i=0;i<professions.length;i++){
      html += "<option value='" + professions[i].game_profession.id + "'>" + professions[i].game_profession.name + "</option>";
    }
    this.profession_selector.innerHTML = html;
  },

  reset_race_info: function(){
    this.race_selector.innerHTML = '<option value="">---</option>';
  },

  setup_race_info: function(races){
    var html = '<option value="">---</option>';
    for(var i=0;i<races.length;i++){
      html += "<option value='" + races[i].game_race.id + "'>" + races[i].game_race.name + "</option>";
    }
    this.race_selector.innerHTML = html;
  },

  game_onchange: function(){
    if(this.game_selector.value == ''){
      this.reset();
      return;
    }
    new Ajax.Request('/games/' + this.game_selector.value + '/game_details', {
      method: 'get',
      onSuccess: function(transport){
        this.details = transport.responseText.evalJSON();
        this.reset_area_info();
        this.reset_server_info();
        if(this.profession_selector != null)
          this.reset_profession_info();
        if(this.race_selector != null)
          this.reset_race_info();
        if(!this.details.no_areas){
          this.no_areas = false;
          this.setup_area_info(this.details.areas);
        }else{
          this.no_areas = true;
          this.setup_server_info(this.details.servers);
        }
        if(!this.details.no_professions && this.profession_selector)
          this.setup_profession_info(this.details.professions);
        if(!this.details.no_races && this.race_selector)
          this.setup_race_info(this.details.races);
      }.bind(this)
    });
  },

  area_onchange: function(){
    if(this.area_selector.value == ''){
      this.reset_server_info();
      return;
    }
    new Ajax.Request('/games/' + this.game_selector.value + '/area_details?area_id=' + this.area_selector.value, {
      method: 'get',
      onSuccess: function(transport){
        var servers = transport.responseText.evalJSON();
        this.setup_server_info(servers);
      }.bind(this)
    });
  },

  reset: function(){
    this.reset_game_info();
    this.reset_area_info();
    this.reset_server_info();
    if(this.profession_selector)
      this.reset_profession_info();
    if(this.race_selector)
      this.reset_race_info();
  },

  get_details: function(){
    return this.details;
  }

});
