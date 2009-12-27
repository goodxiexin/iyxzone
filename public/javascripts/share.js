Iyxzone.Share = {
  version: '1.0',
  
  author: ['高侠鸿'],
  
  getPage: function(link){
    this.node = new Element('script', {type: 'text/javascript', src: 'http://www.baidu.com'});
    var head = $('shared_link');
    head.appendChild(this.node);
    alert(this.node.innerHTML);
  }
};
