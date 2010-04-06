scriptTransport = Class.create({

  initialize: function() {
    this.readyState = 0;
  },

  open: function(method, url, asynchronous) {
    this.readyState = 1;
    this.onreadystatechange();
    this.url = url;
    this.userAgent = navigator.userAgent.toLowerCase();
    this.setBrowser();
    this.prepareGetScriptXS();
  },

  send : function(body) {
    this.readyState = 2;
    this.onreadystatechange();
    this.getScriptXS(this.url);
  },

  setBrowser : function(body) {
    scriptTransport.prototype.browser = {
        version: (this.userAgent.match(/.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/) || [])[1],
        safari: /webkit/.test(this.userAgent),
        opera: /opera/.test(this.userAgent),
        msie: /msie/.test(this.userAgent) && !/opera/.test(this.userAgent),
        mozilla: /mozilla/.test(this.userAgent) && !/(compatible|webkit)/.test(this.userAgent),
        konqueror: this.userAgent.match(/konqueror/i)
    };
  },

  prepareGetScriptXS : function() {
    if (this.browser.safari || this.browser.konqueror) {
        _xsajax$node = [];
        _xsajax$nodes = 0;
    }
  },

  callback : function() {
    this.status = 200; //(_xsajax$transport_status) ? _xsajax$transport_status : 200;
    this.readyState = 4;
    this.onreadystatechange();
  },

  getScriptXS : function() {

    /* determine arguments */
    var arg = {
        'url': null
    };
    arg.url = arguments[0];

    /* generate <script> node */
    this.node = document.createElement('SCRIPT');
    this.node.type = 'text/javascript';
    this.node.src = arg.url;

    /* optionally apply event handler to <script> node for
   garbage collecting <script> node after loading and/or
   calling a custom callback function */
    var node_helper = null;

    if (this.browser.msie) {

        function mybind(obj) {
            temp = function() {
                if (this.readyState == "complete" || this.readyState == "loaded") {
                    return obj.callback.call(obj);
                }
            };
            return temp;
        }
        /* MSIE doesn't support the "onload" event on
           <script> nodes, but it at least supports an
           "onreadystatechange" event instead. But notice:
           according to the MSDN documentation we would have
           to look for the state "complete", but in practice
           for <script> the state transitions from "loading"
           to "loaded". So, we check for both here... */
        this.node.onreadystatechange = mybind(this);

        } else if (this.browser.safari || this.browser.konqueror) {
        /* Safari/WebKit and Konqueror/KHTML do not emit
           _any_ events at all, but we can exploit the fact
           that dynamically generated <script> DOM nodes
           are executed in sequence (although the scripts
           theirself are still loaded in parallel) */
        _xsajax$nodes++;

        var helper = 'var ctx = _xsajax$node[' + _xsajax$nodes + '];' + 'ctx.callback.call(ctx.node);' + 'setTimeout(function () {' + '    ctx.node_helper.parentNode.removeChild(ctx.node_helper);' + '}, 100);';
        node_helper = document.createElement('SCRIPT');
        node_helper.type = 'text/javascript';
        node_helper.appendChild(document.createTextNode(helper));
        _xsajax$node[_xsajax$nodes] = {
            callback: this.callback.bind(this),
            node: this.node,
            node_helper: node_helper
        };
    } else {
        /* Firefox, Opera and other reasonable browsers can
           use the regular "onload" event... */
        this.node.onload = this.callback.bind(this);
    }

    /* inject <script> node into <head> of document */
    this.readyState = 3;
    this.onreadystatechange();
    var head = document.getElementsByTagName('HEAD')[0];
    head.appendChild(this.node);

    /* optionally inject helper <script> node into <head>
   (Notice: we have to use a strange indirection via
   setTimeout() to insert this second <script> node here or
   at least Konqueror (and perhaps also Safari) for unknown
   reasons will not execute the first <script> node at all) */
    if (node_helper !== null) {
        setTimeout(function() {
            var head = document.getElementsByTagName('HEAD')[0];
            head.appendChild(node_helper);
        }, 100);
    }

  },

  setRequestHeader : function() {
  },

  onreadystatechange : function() {
  },

  getResponseHeader: function(){
  }

});
//
//------------------------------- Extend prototype a bit -----------------------
//
Ajax.CrossSiteRequest = Class.create(Ajax.Request, {
    initialize: function($super, url, options) {
        $super(options);
        this.transport = new scriptTransport();
        this.request(url);
    }    
});
