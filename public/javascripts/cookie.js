Iyxzone.Cookie = {

  version: '1.0',

  author: '高侠鸿'

};

Object.extend(Iyxzone.Cookie, {

  // expireDays如果不设置，那按照浏览器的不同，可能会有所不同
  // 比如firefox，默认就是session，意思是session结束（浏览器关闭），该cookie过期
  // 实际上firefox会保存cookie，对每个tab，这是后话
  set: function( name, value, expYear, expMonth, expDay, path, domain, secure){
    var cookieStr = name + "=" + escape ( value );

    if(expYear){
      var expires = new Date(expYear, expMonth, expDay);
      cookieStr += "; expires=" + expires.toUTCString();
    }

    if(path)
      cookieStr += "; path=" + escape(path);

    if(domain)
      cookiStr += "; domain=" + escape(domain);

    if(secure)
      cookieStr += "; secure";
    
    document.cookie = cookieStr;
  },

  unset: function(name){
    var cookieDate = new Date();  // current date & time
    cookieDate.setTime(cookieDate.getTime() - 1);
    document.cookie = cookie_name += "=; expires=" + cookieDate.toUTCString();
  },

  get: function(name){
    var results = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
    
    if(results)
      return (unescape(results[2]));
    else
      return null;
  }

});
