ChineseRegion = Class.create({

  initialize: function(){
  },

  prepare: function(region_selector, city_selector, district_selector){
    this.region_selector = region_selector;
    this.city_selector = city_selector;
    this.district_selector = district_selector;
  },

  reset_city_info: function(){
    this.city_selector.innerHTML = '<option value="">---</option>'; 
  },

  setup_city_info: function(cities){
    var html = ''; //<option value="">---</option>';
    for(var i=0;i<cities.length;i++){
      html += "<option value='" + cities[i].city.id + "'>" + cities[i].city.name + "</option>";
    }
    this.city_selector.innerHTML = html;
  },

  reset_district_info: function(){
    this.district_selector.innerHTML = '<option value="">---</option>'; 
  },

  setup_district_info: function(districts){
    var html = ''; //<option value="">---</option>';
    for(var i=0;i<districts.length;i++){
      html += "<option value='" + districts[i].district.id + "'>" + districts[i].district.name + "</option>";
    }
    this.district_selector.innerHTML = html;
  },

  region_onchange: function(){
    new Ajax.Request('/cities', {
      method: 'get',
      parameters: {region_id: this.region_selector.value},
      onSuccess: function(transport){
        details = transport.responseText.evalJSON();
        this.reset_city_info();
        this.reset_district_info();
        this.setup_city_info(details);
        this.city_onchange();
      }.bind(this)
    });
  },

  city_onchange: function(){
    new Ajax.Request('/districts', {
      method: 'get',
      parameters: {region_id: this.region_selector.value, city_id: this.city_selector.value},
      onSuccess: function(transport){
        details = transport.responseText.evalJSON();
        this.reset_district_info();
        this.setup_district_info(details);
      }.bind(this)
    });
  }

});
