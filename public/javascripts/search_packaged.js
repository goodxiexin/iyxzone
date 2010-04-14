Iyxzone.Game={version:'1.0',author:['高侠鸿'],pinyins:null,infos:null,Suggestor:{},Selector:Class.create({}),PinyinSelector:Class.create({}),Feeder:{},initPinyinSelector:function(game,area,server,race,profession,prompt,initValue,options){if(Iyxzone.Game.infos==null||Iyxzone.Game.pinyins==null){alert('错误');return;}
$(game).innerHTML='';if(prompt)
$(game).update('<option value="">---</option>');Iyxzone.Game.infos.each(function(info){Element.insert(game,{bottom:'<option value='+info.game.id+'>'+info.game.name+'</option>'});}.bind(this));$(game).value='';return new Iyxzone.Game.PinyinSelector(game,area,server,race,profession,initValue,options);}};Iyxzone.Game.Selector=Class.create({details:new Hash(),initialize:function(gameSelectorID,areaSelectorID,serverSelectID,raceSelectorID,professionSelectorID,gameDetails,options){this.gameSelectorID=gameSelectorID;this.areaSelectorID=areaSelectorID;this.serverSelectID=serverSelectID;this.raceSelectorID=raceSelectorID;this.professionSelectorID=professionSelectorID;this.details=gameDetails;this.options=Object.extend({onGameChange:Prototype.emptyFunction,onAreaChange:Prototype.emptyFunction,onServerChange:Prototype.emptyFunction,onRaceChange:Prototype.emptyFunction,onProfessionChange:Prototype.emptyFunction},options||{});this.setEvents();},setEvents:function(){if(this.gameSelectorID)
Event.observe(this.gameSelectorID,'change',this.gameChange.bind(this));if(this.areaSelectorID)
Event.observe(this.areaSelectorID,'change',this.areaChange.bind(this));if(this.serverSelectID)
Event.observe(this.serverSelectID,'change',this.serverChange.bind(this));if(this.raceSelectorID)
Event.observe(this.raceSelectorID,'change',this.raceChange.bind(this));if(this.professionSelectorID)
Event.observe(this.professionSelectorID,'change',this.professionChange.bind(this));},resetGameInfo:function(){$(this.gameSelectorID).value='';},resetAreaInfo:function(){if($(this.areaSelectorID))
$(this.areaSelectorID).update('<option value="">---</option>');},setupAreaInfo:function(areas){var html='<option value="">---</option>';for(var i=0;i<areas.length;i++){html+="<option value='"+areas[i].id+"'>"+areas[i].name+"</option>";}
$(this.areaSelectorID).update(html);},resetServerInfo:function(){$(this.serverSelectID).update('<option value="">---</option>');},setupServerInfo:function(servers){var html='<option value="">---</option>';for(var i=0;i<servers.length;i++){html+="<option value='"+servers[i].id+"'>"+servers[i].name+"</option>";}
$(this.serverSelectID).update(html);},resetProfessionInfo:function(){$(this.professionSelectorID).update('<option value="">---</option>');},setupProfessionInfo:function(professions){var html='<option value="">---</option>';for(var i=0;i<professions.length;i++){html+="<option value='"+professions[i].id+"'>"+professions[i].name+"</option>";}
$(this.professionSelectorID).update(html);},resetRaceInfo:function(){$(this.raceSelectorID).update('<option value="">---</option>');},setupRaceInfo:function(races){var html='<option value="">---</option>';for(var i=0;i<races.length;i++){html+="<option value='"+races[i].id+"'>"+races[i].name+"</option>";}
$(this.raceSelectorID).update(html);},gameChange:function(){if(this.gameSelectorID&&$(this.gameSelectorID).value==''){this.reset();return;}
new Ajax.Request('/game_details/'+$(this.gameSelectorID).value+'.json',{method:'get',onSuccess:function(transport){this.details=transport.responseText.evalJSON().game;if(this.areaSelectorID)
this.resetAreaInfo();if(this.serverSelectID)
this.resetServerInfo();if(this.raceSelectorID)
this.resetRaceInfo();if(this.professionSelectorID)
this.resetProfessionInfo();if(!this.details.no_areas){this.setupAreaInfo(this.details.areas);}else{this.setupServerInfo(this.details.servers);}
if(!this.details.no_professions&&this.professionSelectorID)
this.setupProfessionInfo(this.details.professions);if(!this.details.no_races&&this.raceSelectorID)
this.setupRaceInfo(this.details.races);this.options.onGameChange($(this.gameSelectorID).value);}.bind(this)});},areaChange:function(){if(this.areaSelectorID&&$(this.areaSelectorID).value==''){if(this.serverSelectID)
this.resetServerInfo();return;}
new Ajax.Request('/area_details/'+$(this.areaSelectorID).value+'.json',{method:'get',onSuccess:function(transport){var areaInfo=transport.responseText.evalJSON().game_area;if(this.serverSelectID)
this.setupServerInfo(areaInfo.servers);this.options.onAreaChange($(this.areaSelectorID).value);}.bind(this)});},serverChange:function(){if(this.serverSelectID&&$(this.serverSelectID).value==''){return;}
this.options.onServerChange($(this.serverSelectID).value);},raceChange:function(){if(this.raceSelectorID&&$(this.raceSelectorID).value==''){return;}
this.options.onRaceChange($(this.raceSelectorID).value);},professionChange:function(){if(this.professionSelectorID&&$(this.professionSelectorID).value==''){return;}
this.options.onProfessionChange($(this.professionSelectorID).value);},reset:function(){this.resetGameInfo();if(this.areaSelectorID)
this.resetAreaInfo();if(this.serverSelectID)
this.resetServerInfo();if(this.professionSelectorID)
this.resetProfessionInfo();if(this.raceSelectorID)
this.resetRaceInfo();this.details=null;},getDetails:function(){return this.details;}});Iyxzone.Game.PinyinSelector=Class.create(Iyxzone.Game.Selector,{initialize:function($super,gameSelectorID,areaSelectorID,serverSelectID,raceSelectorID,professionSelectorID,gameDetails,options){if(Iyxzone.Game.pinyins==null){return;}
this.mappings=new Hash();this.keyPressed='';this.lastPressedAt=null;this.currentGameID=null;var i=0;for(var i=0;i<26;i++){var code=97+i;var j=this.binarySearch(code);if(j!=-1){this.mappings.set(code,j);this.mappings.set(code-32,j);}}
$super(gameSelectorID,areaSelectorID,serverSelectID,raceSelectorID,professionSelectorID,gameDetails,options);},setEvents:function($super){$super();Event.observe($(this.gameSelectorID),'keyup',function(e){Event.stop(e);this.onKeyUp(e);}.bind(this));Event.observe($(this.gameSelectorID),'blur',function(e){this.lastPressedAt=null;this.keyPressed='';}.bind(this));},binarySearch:function(keyCode){var pinyins=Iyxzone.Game.pinyins;var size=pinyins.length;var i=0;var j=size-1;var c1=pinyins[i].toLowerCase().charCodeAt(0);var c2=pinyins[j].toLowerCase().charCodeAt(0);if(c1>keyCode)return-1;if(c2<keyCode)return-1;while(i!=j-1){var m=Math.ceil((i+j)/2);var c=pinyins[m].toLowerCase().charCodeAt(0);if(c<keyCode){i=m;}else{j=m;}}
c1=pinyins[i].toLowerCase().charCodeAt(0);c2=pinyins[j].toLowerCase().charCodeAt(0);if(c1!=keyCode&&c2!=keyCode)return-1;if(c1==keyCode)return i;if(c2==keyCode)return j;},onKeyUp:function(e){var pinyins=Iyxzone.Game.pinyins;var code=e.keyCode;var now=new Date().getTime();if(this.lastPressedAt==null||(now-this.lastPressedAt)<1000){this.lastPressedAt=now;this.keyPressed+=String.fromCharCode(e.keyCode);}else{this.lastPressedAt=now;this.keyPressed=String.fromCharCode(e.keyCode);}
var len=this.keyPressed.length;var startPos=this.mappings.get(this.keyPressed.charCodeAt(0));if(startPos==null)return;for(var i=startPos;i<pinyins.length;i++){if(pinyins[i].substr(0,len)==this.keyPressed.toLowerCase()){if($(this.gameSelectorID).selectedIndex!=i){$(this.gameSelectorID).value=$(this.gameSelectorID).options[i].value;this.currentGameID=$(this.gameSelectorID).value;setTimeout(this.fireGameChangeEvent.bind(this),500);}
return;}}},fireGameChangeEvent:function(){if(this.currentGameID==null)return;$(this.gameSelectorID).simulate('change');this.currentGameID=null;}});Iyxzone.Game.Autocompleter=Class.create(Autocompleter.Base,{initialize:function(element,update,url,options){this.baseInitialize(element,update,options);this.options.asynchronous=true;this.options.onComplete=this.onComplete.bind(this);this.options.defaultParams=this.options.parameters||null;this.url=url;this.comp=this.options.comp;this.emptyText=this.options.emptyText||"没有匹配的..."
Event.observe(element,'focus',this.onInputFocus.bindAsEventListener(this));},onInputFocus:function(e){this.options.onInputFocus(this.element);},getUpdatedChoices:function(){this.startIndicator();var entry=encodeURIComponent(this.options.paramName)+'='+encodeURIComponent(this.getToken());this.options.parameters=this.options.callback?this.options.callback(this.element,entry):entry;if(this.options.defaultParams)
this.options.parameters+='&'+this.options.defaultParams;this.options.parameters+='&tag[name]='+this.element.value;new Ajax.Request(this.url,this.options);},onComplete:function(request){if(request.responseText.indexOf('li')<0){this.update.update(this.options.emptyText);}else{this.updateChoices(request.responseText);}
if(this.comp){this.update.setStyle({position:'absolute',left:this.comp.positionedOffset().left+'px',top:(this.comp.positionedOffset().top+this.comp.getHeight())+'px',width:(this.comp.getWidth()-10)+'px',maxHeight:'200px',overflow:'auto',padding:'5px',background:'white',border:'1px solid #E7F0E0'});}}});Object.extend(Iyxzone.Game.Suggestor,{tagNames:new Array(),tagList:null,prepare:function(){this.tagList=new TextBoxList($('game_tags'),{onBoxDispose:this.removeTag.bind(this),holderClassName:'friend-select-list s_clear',bitClassName:''});new Iyxzone.Game.Autocompleter(this.tagList.getMainInput(),$('game_tag_list'),'/auto_complete_for_game_tags',{method:'get',emptyText:'没有匹配的关键字...',afterUpdateElement:this.afterSelectTag.bind(this),onInputFocus:this.showTips.bind(this),comp:this.tagList.holder});},showTips:function(){$('game_tag_list').innerHTML='输入游戏特点, 拼音或者汉字';$('game_tag_list').setStyle({position:'absolute',left:this.tagList.holder.positionedOffset().left+'px',top:(this.tagList.holder.positionedOffset().top+this.tagList.holder.getHeight())+'px',width:(this.tagList.holder.getWidth()-10)+'px',maxHeight:'200px',overflow:'auto',padding:'5px',background:'white',border:'1px solid #E7F0E0'});$('game_tag_list').show();},afterSelectTag:function(input,selectedLI){var text=selectedLI.childElements()[0].innerHTML;this.addTag(text);input.clear();},hasTag:function(tagName){for(var i=0;i<this.tagNames.length;i++){if(tagName==this.tagNames[i])
return true;}
return false;},addTag:function(tagName){if(this.hasTag(tagName)){tip('你已经选择了该标签');return;}
this.tagList.add(tagName,tagName);this.tagNames.push(tagName);},removeTag:function(box,input){var tagNames=Iyxzone.Game.Suggestor.tagNames;var text=input.value;for(var i=0;i<tagNames.length;i++){if(text==tagNames[i])
tagNames.splice(i,1);}},suggest:function(button){if(this.tagNames.length==0){notice('请您点击游戏相关类型，以便我们向您推荐');}else{var newGame=$('new_game');new Ajax.Request('/game_suggestions/game_tags',{method:'get',parameters:{selected_tags:this.tagNames.join(','),new_game:newGame.checked},onLoading:function(){Iyxzone.disableButton(button,'请等待..');},onComplete:function(){Iyxzone.enableButton(button,'推荐');},onSuccess:function(transport){$('game_suggestion_area').update(transport.responseText);}.bind(this)});}},toggleAdvancedOptions:function(){if($('advanced_options').visible()){Effect.BlindUp($('advanced_options'));}else{Effect.BlindDown($('advanced_options'));}}});Object.extend(Iyxzone.Game.Feeder,{idx:0,moreFeeds:function(gameID){$('more_feed').innerHTML='<img src="/images/loading.gif" />';new Ajax.Request('/games/'+gameID+'/more_feeds?idx='+this.idx,{method:'get',onSuccess:function(transport){this.idx++;}.bind(this)});}});Iyxzone.Search={version:'1.0',author:['高侠鸿'],showUserForm:function(){$('user_form').getInputs('text')[0].value='用户昵称';$('user_form').show();$('character_form').hide();},toggleUserForm:function(){$('user_form').getInputs('text')[0].value='好友名字';$('user_form').toggle();},validateUserForm:function(){var value=$('user_form').getInputs('text')[0].value;if(value=='好友名字'||value==''){error('请输入好友名字');return false;}
return true;},searchUsers:function(button){if(this.validateUserForm()){Iyxzone.disableButton(button,'请等待..');window.location.href=$('user_form').action+'?'+$('user_form').serialize();}},showCharacterForm:function(){$('character_form').getInputs('text')[0].value='游戏角色名字';$('character_form').show();$('user_form').hide();},toggleCharacterForm:function(){$('character_form').getInputs('text')[0].value='游戏角色名字';$('character_form').toggle();},toggleCharacterOptions:function(){var characterOptions=$('character_options');if(characterOptions.visible()){Effect.BlindUp(characterOptions);}else{Effect.BlindDown(characterOptions);}},validateCharacterForm:function(){var value=$('character_form').getInputs('text')[0].value;if((value=='角色名字'||value=='')&&$('game_id').value==''&&$('area_id').value==''&&$('server_id').value==''){error('请输入你要查找的玩家的信息');return false;}
if(value=='角色名字'||value=='')
$('character_form').getInputs('text')[0].clear();return true;},searchCharacters:function(button){if(this.validateCharacterForm()){Iyxzone.disableButton(button,'请等待..');window.location.href=$('character_form').action+'?'+$('character_form').serialize();}},toggleMsnEmailForm:function(){$('msn_email_form').toggle();},toggleMsnInput:function(){$('msn_input_form').show();$('email_input_form').hide();var group=document.forms['msn_input_form'].elements['contact'];group[0].checked=true;group[1].checked=false;},toggleEmailInput:function(){$('msn_input_form').hide();$('email_input_form').show();var group=document.forms['email_input_form'].elements['contact'];group[0].checked=false;group[1].checked=true;},checkMsnInput:function(){Iyxzone.disableButton($('msn_submit_btn'),'请等待..');var form=$('msn_input_form');var id=form.getInputs('text')[0];var pwd=form.getInputs('password')[0];if(id.value==''){error('请输入msn用户名');Iyxzone.enableButton($('msn_submit_btn'),'导入');return false;}
if(pwd.value==''){error('请输入msn密码');Iyxzone.enableButton($('msn_submit_btn'),'导入');return false;}
return true;},checkEmailInput:function(){Iyxzone.disableButton($('email_submit_btn'),'请等待..');var form=$('email_input_form');var email=form.getInputs('text')[0];var pwd=form.getInputs('password')[0];if(email.value==''){error('请输入邮箱');Iyxzone.enableButton($('email_submit_btn'),'导入');return false;}else if(!email.value.match(/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/)){error('非法的邮箱地址');Iyxzone.enableButton($('email_submit_btn'),'导入');return false;}
if(pwd.value==''){error('请输入邮箱密码');Iyxzone.enableButton($('email_submit_btn'),'导入');return false;}
return true;}};Iyxzone.Friend={version:'1.0',author:['高侠鸿'],Suggestor:{},Tagger:Class.create({})};Iyxzone.Comrade={version:'1.0',author:['高侠鸿'],Suggestor:{}};Object.extend(Iyxzone.Friend.Suggestor,{newSuggestion:function(suggestionID,token,nicerLayout){var url='/friend_suggestions/new';var exceptIDs=[];var suggestions=$('friend_suggestions').childElements();for(var i=0;i<suggestions.length;i++){exceptIDs.push(suggestions[i].readAttribute('suggestion_id'));}
var exceptParam="";for(var i=0;i<exceptIDs.length;i++){exceptParam+="except_ids[]="+exceptIDs[i]+"&";}
url+="?"+exceptParam;new Ajax.Request(url,{method:'get',parameters:{sid:suggestionID,authenticity_token:encodeURIComponent(token),nicer:nicerLayout},onSuccess:function(transport){var card=$('friend_suggestion_'+suggestionID);var temp_parent=new Element('div');temp_parent.update(transport.responseText);var li=temp_parent.childElements()[0];li.setStyle({'opacity':0});Element.replace(card,li);new Effect.Opacity(li,{from:0,to:1})}.bind(this)});}});Object.extend(Iyxzone.Comrade.Suggestor,{newSuggestion:function(serverID,suggestionID,token){var url='friend_suggestions/new';var exceptIDs=[];var suggestions=$('server_'+serverID+'_suggestions').childElements();for(var i=0;i<suggestions.length;i++){exceptIDs.push(suggestions[i].readAttribute('suggestion_id'));}
var exceptParam="";for(var i=0;i<exceptIDs.length;i++){exceptParam+="except_ids[]="+exceptIDs[i]+"&";}
url+="?"+exceptParam;new Ajax.Request(url,{method:'get',parameters:{sid:suggestionID,server_id:serverID,authenticity_token:encodeURIComponent(token)},onSuccess:function(transport){var card=$('comrade_suggestion_'+suggestionID);var temp_parent=new Element('div');temp_parent.update(transport.responseText);var li=temp_parent.childElements()[0];li.setStyle({'opacity':0});Element.replace(card,li);new Effect.Opacity(li,{from:0,to:1})}.bind(this)});}});Iyxzone.Friend.Autocompleter=Class.create(Autocompleter.Local,{initialize:function($super,element,update,options){options=Object.extend({selector:function(instance){var options=instance.options;var pinyins=options.pinyins;var names=options.names;var ids=options.ids;var token=instance.getToken();var ret=[];for(var i=0;i<pinyins.length;i++){var pinyinPos=options.ignoreCase?pinyins[i].toLowerCase().indexOf(token.toLowerCase()):pinyins[i].indexOf(token);var namePos=options.ignoreCase?names[i].toLowerCase().indexOf(token.toLowerCase()):names[i].indexOf(token);if(pinyinPos>=0||namePos>=0){ret.push('<li style="list-style-type:none;" id='+ids[i]+' ><a href="javascript:void(0)">'+names[i]+'</a></li>');}}
if(ret.length==0){return options.emptyText;}else{return"<ul>"+ret.join('')+"</ul>";}}},options||{});Event.observe(element,'focus',this.showTip.bindAsEventListener(this));$super(element,update,null,options);},showTip:function(){this.update.update(this.options.tipText);var comp=this.options.comp;this.update.setStyle({position:'absolute',left:comp.positionedOffset().left+'px',top:(comp.positionedOffset().top+comp.getHeight())+'px',width:(comp.getWidth()-10)+'px',maxHeight:'200px',overflowX:'hidden',overflowY:'auto',padding:'5px',background:'white',border:'1px solid #E7F0E0'});this.update.show();},onClick:function($super,event){Event.stop(event);$super(event);},updateChoices:function($super,data){if(data.indexOf('ul')<0){this.update.update(data);this.update.show();}else{$super(data);}
var comp=this.options.comp;this.update.setStyle({position:'absolute',left:comp.positionedOffset().left+'px',top:(comp.positionedOffset().top+comp.getHeight())+'px',width:(comp.getWidth()-10)+'px',maxHeight:'200px',overflowX:'hidden',autoflowY:'auto',padding:'5px',background:'white',border:'1px solid #E7F0E0'});}});Iyxzone.Friend.Tagger=Class.create({initialize:function(max,tagInfos,toggleButton,input,friendList,friendTable,friendItems,gameSelector,confirmButton,cancelButton){this.max=max;this.tags=new Hash();this.newTags=new Hash();this.delTags=new Array();this.toggleButton=$(toggleButton);this.friendList=$(friendList);this.friendTable=$(friendTable);this.friendItems=$(friendItems);this.confirmButton=$(confirmButton);this.cancelButton=$(cancelButton);this.gameSelector=$(gameSelector);this.taggedUserList=new TextBoxList(input,{onBoxDispose:this.removeBox.bind(this),holderClassName:'friend-select-list s_clear',bitClassName:''});for(var i=0;i<tagInfos.length;i++){var info=tagInfos[i];var el=this.taggedUserList.add(info.friend_id,info.friend_name);this.tags.set(info.friend_id,[info.tag_id,el]);}
var inputs=$$('input');for(var i=0;i<inputs.length;i++){if(inputs[i].type=='checkbox'){inputs[i].checked=false;inputs[i].observe('click',this.afterCheckFriend.bindAsEventListener(this));if(this.tags.keys().include(inputs[i].value)){inputs[i].checked=true;}}}
Event.observe(this.toggleButton,'click',function(e){this.toggleFriends();Event.stop(e);}.bind(this),false);Event.observe(this.confirmButton,'click',function(event){Event.stop(event);var checked=new Hash();var delTags=new Array();var newTags=new Array();var inputs=$$('input');for(var i=0;i<inputs.length;i++){if(inputs[i].type=='checkbox'&&inputs[i].checked){checked.set(inputs[i].value,{id:inputs[i].value,login:inputs[i].readAttribute('login')});}}
this.tags.keys().each(function(key){if(!checked.keys().include(key)){delTags.push(key);}}.bind(this));this.newTags.keys().each(function(key){if(!checked.keys().include(key)){delTags.push(key);}}.bind(this));this.removeTags(delTags);var tagIDs=this.tags.keys();var newTagIDs=this.newTags.keys();checked.each(function(pair){var input=pair.value;var key=pair.key;if(!tagIDs.include(key)&&!newTagIDs.include(key)){newTags.push(input);}}.bind(this));this.addTags(newTags);this.toggleFriends();}.bind(this));Event.observe(this.cancelButton,'click',function(event){Event.stop(event);this.toggleFriends();}.bind(this),false);Event.observe(this.gameSelector,'change',function(e){this.getFriends(this.gameSelector.value);Event.stop(e);}.bind(this),false);var pinyins=[];var names=[];var ids=[];this.friendItems.childElements().each(function(li){pinyins.push(li.down('input').readAttribute('pinyin'));names.push(li.down('input').readAttribute('login'));ids.push(li.down('input').value);}.bind(this));new Iyxzone.Friend.Autocompleter(this.taggedUserList.getMainInput(),this.friendList,{ids:ids,names:names,pinyins:pinyins,afterUpdateElement:this.afterSelectFriend.bind(this),tipText:'输入你好友的名字或者拼音',emptyText:'没有匹配的好友...',comp:this.taggedUserList.holder});},removeBox:function(el,input){var friendID=input.value;var tagInfo=this.tags.unset(friendID);if(tagInfo){this.delTags.push(tagInfo[0]);}else{this.newTags.unset(friendID);}
var inputs=$$('input');for(var i=0;i<inputs.length;i++){if(inputs[i].type=='checkbox'&&inputs[i].value==friendID){inputs[i].checked=false;}}},removeTags:function(friendIDs){for(var i=0;i<friendIDs.length;i++){var friendID=friendIDs[i];var tagInfo=this.tags.unset(friendID);if(tagInfo){this.delTags.push(tagInfo[0]);tagInfo[1].remove();}else{var div=this.newTags.unset(friendID);div.remove();}}},addTags:function(friends){for(var i=0;i<friends.length;i++){var el=this.taggedUserList.add(friends[i].id,friends[i].login);this.newTags.set(friends[i].id,el);}},getNewTags:function(){return this.newTags.keys();},getDelTags:function(){return this.delTags;},getFriends:function(game_id){var friends=this.friendItems.childElements();friends.each(function(f){var info=f.readAttribute('info').evalJSON();var games=info.games;if(game_id=='all'||games.include(game_id)){f.show();}else{f.hide();}}.bind(this));},toggleFriends:function(){if(!this.friendTable.visible()){var pos=this.toggleButton.positionedOffset();this.friendTable.setStyle({position:'absolute',left:(pos.left+this.toggleButton.getWidth()-this.friendTable.getWidth())+'px',top:(pos.top+this.toggleButton.getHeight())+'px'});this.friendTable.show();}else{this.friendTable.hide();}},afterSelectFriend:function(input,selectedLI){var id=selectedLI.readAttribute('id');var login=selectedLI.childElements()[0].innerHTML;input.clear();if(this.tags.keys().include(id)||this.newTags.keys().include(id)){return;}else{if(this.tags.keys().length+this.newTags.keys().length>=this.max){error('最多选'+this.max+'个!');return;}
this.addTags([{id:id,login:login}]);input.clear();var inputs=$$('input');for(var i=0;i<inputs.length;i++){if(inputs[i].type=='checkbox'&&inputs[i].value==id){inputs[i].checked=true;}}}},afterCheckFriend:function(mouseEvent){var checkbox=mouseEvent.target;if(!checkbox.checked){return;}
var inputs=$$('input');var checked=0;for(var i=0;i<inputs.length;i++){if(inputs[i].type=='checkbox'&&inputs[i].checked)
checked++;}
if(checked>this.max){error('最多选'+this.max+'个!');checkbox.checked=false;return;}},reset:function(tagInfos){this.newTags.each(function(pair){var friendID=pair.key;var div=pair.value;for(var i=0;i<tagInfos.length;i++){if(tagInfos[i].friend_id==friendID){this.tags.set(friendID,[tagInfos[i].id,div])}}}.bind(this));this.delTags=new Array();this.newTags=new Hash();}});(function(){var eventMatchers={'HTMLEvents':/^(?:load|unload|abort|error|select|change|submit|reset|focus|blur|resize|scroll)$/,'MouseEvents':/^(?:click|mouse(?:down|up|over|move|out))$/}
var defaultOptions={pointerX:0,pointerY:0,button:0,ctrlKey:false,altKey:false,shiftKey:false,metaKey:false,bubbles:true,cancelable:true}
Event.simulate=function(element,eventName){var options=Object.extend(defaultOptions,arguments[2]||{});var oEvent,eventType=null;element=$(element);for(var name in eventMatchers){if(eventMatchers[name].test(eventName)){eventType=name;break;}}
if(!eventType)
throw new SyntaxError('Only HTMLEvents and MouseEvents interfaces are supported');if(document.createEvent){oEvent=document.createEvent(eventType);if(eventType=='HTMLEvents'){oEvent.initEvent(eventName,options.bubbles,options.cancelable);}
else{oEvent.initMouseEvent(eventName,options.bubbles,options.cancelable,document.defaultView,options.button,options.pointerX,options.pointerY,options.pointerX,options.pointerY,options.ctrlKey,options.altKey,options.shiftKey,options.metaKey,options.button,element);}
element.dispatchEvent(oEvent);}
else{options.clientX=options.pointerX;options.clientY=options.pointerY;oEvent=Object.extend(document.createEventObject(),options);element.fireEvent('on'+eventName,oEvent);}
return element;}
Element.addMethods({simulate:Event.simulate});})()