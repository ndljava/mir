package com.leyou.ui.chat {
	import com.ace.enum.FontEnum;
	import com.ace.enum.KeysEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.ui.window.children.AlertWindow;
	import com.leyou.data.chat.ChatInfo;
	import com.leyou.enum.ChatEnum;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Chat;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.ui.chat.child.ChannelComboBox;
	import com.leyou.ui.chat.child.FaceWnd;
	import com.leyou.ui.chat.child.Horn;
	import com.leyou.ui.chat.child.PrivateChatRender;
	import com.leyou.ui.chat.child.RichTextFiled;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	public class ChatWnd extends AutoSprite {
		private var messageTxtArea:RichTextFiled;
		private var systemMesTxtArea:RichTextFiled;
		private var chatInput:TextInput;
		private var sendBtn:ImgButton;
		private var chatTabBar:TabBar;
		private var chatComBox:ChannelComboBox;
		private var gridList:ScrollPane;
		private var faceBtn:ImgButton;
		private var systemGridList:ScrollPane;

//		private var messages:Vector.<ChatInfo>;
		private var currentChannelIdx:int; //当前的频道
		private var channelFalg:Object; //各频道是否在综合频道显示的标记
		private var channelTime:Object; //各个频道上次发言的时间
		private var privateChatRender:PrivateChatRender;
		private var bg:ScaleBitmap;
		private var _bg:ScaleBitmap;

		private var compositeMessage:Vector.<ChatInfo>; //综合频道
		private var areaMessage:Vector.<String>; //区域
		private var teamMessage:Vector.<String>; //组队
		private var guildMessage:Vector.<String>; //行会
		private var unionMessage:Vector.<String>; //联盟
		private var privateMessage:Vector.<String>; //私聊
		private var systeMesasge:Vector.<String>; //

		private var faceWnd:FaceWnd;
		private var horn:Horn; //喇叭
		private var hornArr:Vector.<String>; //喇叭信息
		private var _hornFlag:Boolean;
		private var hornStr:String;

		public function ChatWnd() {
			super(super(LibManager.getInstance().getXML("config/ui/ChatWnd.xml")));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void {
//			this.messages=new Vector.<ChatInfo>;
			this.compositeMessage=new Vector.<ChatInfo>;
			this.areaMessage=new Vector.<String>;
			this.teamMessage=new Vector.<String>;
			this.guildMessage=new Vector.<String>;
			this.unionMessage=new Vector.<String>;
			this.privateMessage=new Vector.<String>;
			this.systeMesasge=new Vector.<String>;

			this.channelFalg=new Object();
			this.channelFalg[ChatEnum.CHANNEL_AREA]=true;
			this.channelFalg[ChatEnum.CHANNEL_GUILD]=true;
			this.channelFalg[ChatEnum.CHANNEL_PRIVATE]=true;
			this.channelFalg[ChatEnum.CHANNEL_TEAM]=true;
			this.channelFalg[ChatEnum.CHANNEL_UNION]=true;
			this.channelFalg[ChatEnum.CHANNEL_COMPOSITE]=true;
			this.channelFalg[ChatEnum.CHANNEL_SYSTEM_ALL]=true;

			this.channelTime=new Object();
			this.channelTime[ChatEnum.CHANNEL_COMPOSITE]=0;
//			this.channelTime[ChatEnum.CHANNEL_GUILD]=0;
			this.channelTime[ChatEnum.CHANNEL_PRIVATE]=0;
//			this.channelTime[ChatEnum.CHANNEL_TEAM]=0;
//			this.channelTime[ChatEnum.CHANNEL_UNION]=0;

			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.chatInput=this.getUIbyID("chatInput") as TextInput;
			this.sendBtn=this.getUIbyID("sendBtn") as ImgButton;
			this.chatTabBar=this.getUIbyID("chatTabBar") as TabBar;
			this.faceBtn=this.getUIbyID("faceBtn") as ImgButton;
			this.systemGridList=this.getUIbyID("systemGridList") as ScrollPane;

			this.bg=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.STYLE_NAME_DIC["PanelBgOut"]));
			this.bg.scale9Grid=FontEnum.RECTANGLE_DIC["PanelBgOut"];
			this.bg.setSize(294, 184);
			this.bg.alpha=.8;
			this.bg.x=0;
			this.bg.y=50;
			this.addChildAt(this.bg, 0);

			this._bg=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.STYLE_NAME_DIC["PanelBgOut"]));
			this._bg.scale9Grid=FontEnum.RECTANGLE_DIC["PanelBgOut"];
			this._bg.setSize(294, 56);
			this._bg.alpha=.8;
			this._bg.x=0;
			this._bg.y=-3;
			this.addChildAt(this._bg, 0);
			this.systemMesTxtArea=new RichTextFiled(294, 51, false);
			this.systemGridList.addToPane(this.systemMesTxtArea);

			this.chatComBox=new ChannelComboBox(49, 22);
			this.chatComBox.x=0;
			this.chatComBox.y=253; //253
			this.chatComBox.onClickItemFun=this.onComBoxClick;
			this.addChild(this.chatComBox);
			this.chatComBox.setItem(["~", "!", "!!", "!~", "!~~", "/"], [ChatEnum.COLOR_COMPOSITE_UINT, ChatEnum.COLOR_AREA_UINT, ChatEnum.COLOR_TEAM_UINT, ChatEnum.COLOR_GUILD_UINT, ChatEnum.COLOR_UNION_UINT, ChatEnum.COLOR_PRIVATE_UINT]);

			this.messageTxtArea=new RichTextFiled(294, 184);
			this.messageTxtArea.onTextClick=this.onClickPlayerName;
			this.gridList.addToPane(this.messageTxtArea);

			this.privateChatRender=new PrivateChatRender();
			this.privateChatRender.x=55;
			this.privateChatRender.y=211;
			this.privateChatRender.visible=false;
			this.addChild(this.privateChatRender);

			this.chatInput.input.maxChars=ChatEnum.MESSAGE_LONG;
			this.chatInput.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			this.sendBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.faceBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.chatTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);
			this.currentChannelIdx=ChatEnum.CHANNEL_COMPOSITE;

			this.horn=new Horn();
			this.horn.timeOutFun=nextHorn;
			this.addChild(this.horn);
			this.hornArr=new Vector.<String>;
			this.hornStr=new String();
		}

		private function onKeyUp(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case KeysEnum.ENTER:
					this.sendChatCmd();
					break;
				case KeysEnum.SPACE:
					if (this.chatInput.text.length <= 4 && this.changeChannel(chatInput.text)) {
						this.chatInput.text="";
						evt.stopImmediatePropagation();
						return;
					} else if (this.currentChannelIdx == ChatEnum.CHANNEL_UNION) {
						if (this.chatInput.text.length > ChatEnum.MESSAGE_HORN_LONG) {
							this.chatInput.text=this.chatInput.text.substr(0, ChatEnum.MESSAGE_HORN_LONG);
						}
					} else if (this.chatInput.text.length > ChatEnum.MESSAGE_LONG) {
						this.chatInput.text=this.chatInput.text.substr(0, ChatEnum.MESSAGE_LONG);
					}

					break;
				default:
					break;
			}
			evt.stopImmediatePropagation();
		}

		public function addFaceSign(sign:String):void {
			this.chatInput.text+=sign;
			if (this.chatInput.text.length > ChatEnum.MESSAGE_LONG)
				this.chatInput.text=this.chatInput.text.substr(0, ChatEnum.MESSAGE_LONG);
			this.chatInput.input.setSelection(this.chatInput.input.text.length, this.chatInput.input.text.length);
			this.onStageEnter();
		}

		/**
		 *点击 tabbar 中按钮
		 * @param evt
		 *
		 */
		private function onTabBarChangeIndex(evt:Event=null):void {
			if (this.chatTabBar.turnOnIndex == this.currentChannelIdx)
				return;
			if (this.currentChannelIdx == ChatEnum.CHANNEL_PRIVATE)
				this.channelChange(false);
			else if (this.chatTabBar.turnOnIndex == ChatEnum.CHANNEL_PRIVATE)
				this.channelChange(true);
			this.currentChannelIdx=this.chatTabBar.turnOnIndex;
			this.messageTxtArea.clearContain();
			this.gridList.updateUI();
			this.gridList.scrollTo(1);
			this.chatComBox.setSelectTextByIdx(this.currentChannelIdx);
			this.setInputTextColor(this.currentChannelIdx);
			this.chatComBox.setItemSta(false);
			var i:int;
			if (this.currentChannelIdx != ChatEnum.CHANNEL_COMPOSITE) {
				var arr:Vector.<String>;
				switch (this.currentChannelIdx) {
					case ChatEnum.CHANNEL_AREA:
						arr=this.areaMessage;
						break;
					case ChatEnum.CHANNEL_GUILD:
						arr=this.guildMessage;
						break;
					case ChatEnum.CHANNEL_PRIVATE:
						arr=this.privateMessage;
						break;
					case ChatEnum.CHANNEL_TEAM:
						arr=this.teamMessage;
						break;
					case ChatEnum.CHANNEL_UNION:
						arr=this.unionMessage;
						break;
				}
				for (i=0; i < arr.length; i++) {
					this.messageTxtArea.appendHtmlText(arr[i]);
				}
			} else if (this.currentChannelIdx == ChatEnum.CHANNEL_COMPOSITE) {
				for (i=0; i < this.compositeMessage.length; i++) {
					if (this.channelFalg[this.compositeMessage[i].channelIdx])
						this.messageTxtArea.appendHtmlText(this.compositeMessage[i].contain);
				}
			}
			this.gridList.updateUI();
			this.gridList.scrollTo(1);
		}

		/**
		 *
		 * @param idx
		 * @param str
		 *
		 */
		private function onComBoxClick(idx:int, str:String):void {
			if (idx == this.currentChannelIdx)
				return;
			this.chatTabBar.turnToTab(idx);
			this.onTabBarChangeIndex();
		}
		private var f:int;

		private function onClick(evt:MouseEvent):void {
			var contain:Array;
			var i:int;
			switch (evt.target.name) {
				case "sendBtn":
					this.sendChatCmd();
					break;
				case "faceBtn":
					if (this.faceWnd != null) {
						if (this.faceWnd.visible)
							this.faceWnd.visible=false;
						else
							this.faceWnd.visible=true;
					} else {
						this.faceWnd=new FaceWnd();
						this.faceWnd.x=290;
						this.faceWnd.y=100;
						this.addChild(this.faceWnd);
						trace(this.faceWnd.numChildren);
					}
					break;
			}
		}

		//发送聊天信息
		private function sendChatCmd():void {
			if (this.chatInput.text == "")
				return;
			var str:String=this.chatInput.text;
//			if (str.length == 2 && changeChannel(str)) {
//				this.onTabBarChangeIndex();
//				this.chatInput.text="";
//				return;
//			}
			switch (this.currentChannelIdx) {
				case ChatEnum.CHANNEL_COMPOSITE:
					if (getTimer() - this.channelTime[ChatEnum.CHANNEL_COMPOSITE] < ChatEnum.TIME_COMPOSITE) {
						servOnChat(ChatEnum.CHANNEL_COMPOSITE, "您发言速度过快，请稍后再试");
						this.chatInput.text="";
						return;
					} else
						this.channelTime[ChatEnum.CHANNEL_COMPOSITE]=getTimer();
					break;
				case ChatEnum.CHANNEL_AREA:
					if (getTimer() - this.channelTime[ChatEnum.CHANNEL_COMPOSITE] < ChatEnum.TIME_AREA) {
						this.servOnChat(ChatEnum.CHANNEL_AREA, "您发言速度过快，请稍后再试");
						this.chatInput.text="";
						return;
					} else {
						str=ChatEnum.FLAG_AREA + str;
						this.channelTime[ChatEnum.CHANNEL_AREA]=getTimer();
					}
					break;
				case ChatEnum.CHANNEL_GUILD:
//					if (getTimer() - this.channelTime[ChatEnum.CHANNEL_GUILD] < ChatEnum.TIME_GUILD) {
//						this.servOnChat(ChatEnum.CHANNEL_GUILD, "您发言速度过快，请稍后再试");
//						this.chatInput.text="";
//						return;
//					} else {
					if (MyInfoManager.getInstance().hasGuild)
						str=ChatEnum.FLAG_GUILD + str;
					else {
//						servOnChat(ChatEnum.CHANNEL_GUILD, "请加入行会后再在行会频道发言");
						this.messageTxtArea.appendHtmlText(this.getColorStr("请加入行会后再在行会频道发言", ChatEnum.COLOR_SYSYTEM));
						this.chatInput.text="";
						return;
					}
//						this.channelTime[ChatEnum.FLAG_GUILD]=getTimer();
//					}
					break;
				case ChatEnum.CHANNEL_PRIVATE:
					if (getTimer() - this.channelTime[ChatEnum.CHANNEL_PRIVATE] < ChatEnum.TIME_PRIVATE) {
						this.servOnChat(ChatEnum.CHANNEL_PRIVATE, "您发言速度过快，请稍后再试");
						this.chatInput.text="";
						return;
					} else {
						if (this.privateChatRender.chatPlayerName == "") {
							//私聊人的名字问空 弹提示 暂无
							return;
						}
						this.privateChatRender.checkPrivatePlayerName();
						this.showSelfToPan(this.privateChatRender.chatPlayerName + str);
						str=ChatEnum.FLAG_PRIVATE + this.privateChatRender.chatPlayerName + str;
						this.channelTime[ChatEnum.FLAG_PRIVATE]=getTimer();
					}
					break;
				case ChatEnum.CHANNEL_TEAM:
//					if (getTimer() - this.channelTime[ChatEnum.CHANNEL_TEAM] < ChatEnum.TIME_TEAM) {
//						this.servOnChat(ChatEnum.CHANNEL_TEAM, "您发言速度过快，请稍后再试");
//						this.chatInput.text="";
//						return;
//					} else {
					if (MyInfoManager.getInstance().hasTeam)
						str=ChatEnum.FLAG_TEAM + str;
					else {
						this.messageTxtArea.appendHtmlText(this.getColorStr("请加入队伍后再在组队频道发言", ChatEnum.COLOR_SYSYTEM));
//						servOnChat(ChatEnum.CHANNEL_TEAM, "请加入队伍后再在组队频道发言");
						this.chatInput.text="";
						return;
					}
//						this.channelTime[ChatEnum.CHANNEL_TEAM]=getTimer();
//					}
					break;
				case ChatEnum.CHANNEL_UNION:
//					if (getTimer() - this.channelTime[ChatEnum.CHANNEL_UNION] < ChatEnum.TIME_UINT) {
//						this.servOnChat(ChatEnum.CHANNEL_UNION, "您发言速度过快，请稍后再试");
//						this.chatInput.text="";
//						return;
//					} else {
					if (MyInfoManager.getInstance().getItemByItemName("千里传音卷轴") != null) {
						var info:TItemInfo=TableManager.getInstance().getItemByName("千里传音卷轴");
						if (info) {
							this._hornFlag=true;
							this.hornStr=str;
							UIManager.getInstance().backPackWnd.useItem(info.id);
						}
					} else { //提示没有 千里传音卷轴
						UIManager.getInstance().noticeMidDownUproll.setNoticeStr("您没有千里传音卷轴 不能发送千里传音", SystemNoticeEnum.IMG_WARN);
//							AlertWindow.showWin("您没有千里传音卷轴 不能发送千里传音");
					}
					this.chatInput.text="";
//						this.channelTime[ChatEnum.CHANNEL_UNION]=getTimer();
//					}
					return;
					break;
			}
			if (cheakSpeakContain(str)) {
				Cmd_Chat.cm_say(str);
				this.chatInput.text="";
				this.stage.focus=null;
			} else {

			}
		}

		//焦点
		public function onStageEnter():void {
			this.stage.focus=this.chatInput.input;
		}

		//服务器发过来聊天
		public function servOnChat(channel:int, str:String):void {
			if (channel == ChatEnum.CHANNEL_COMPOSITE) {
				if (str.match("(!)"))
					channel=ChatEnum.CHANNEL_AREA;
			}
			this.addMessage(channel, str);
			if (channel != ChatEnum.CHANNEL_SYSTEM && this.currentChannelIdx != channel && channel != ChatEnum.CHANNEL_SYSTEM_ALL) {
				//不是当前频道的信息 显示有新消息特效
			} else
				this.showMessage(channel);
		}

		/**
		 *将信息显示在聊天栏内
		 *
		 */
		private function showMessage(channel:int):void {
			switch (channel) {
				case ChatEnum.CHANNEL_AREA:
					this.showM(this.areaMessage);
					break;
				case ChatEnum.CHANNEL_COMPOSITE:
					if (this.channelFalg[this.compositeMessage[this.compositeMessage.length - 1].channelIdx])
						this.messageTxtArea.appendHtmlText(compositeMessage[this.compositeMessage.length - 1].contain);
					break;
				case ChatEnum.CHANNEL_GUILD:
					this.showM(this.guildMessage);
					break;
				case ChatEnum.CHANNEL_PRIVATE:
					this.showM(this.privateMessage);
					break;
				case ChatEnum.CHANNEL_SYSTEM:
					this.showM(this.systeMesasge, true);
					break;
				case ChatEnum.CHANNEL_TEAM:
					this.showM(this.teamMessage);
					break;
				case ChatEnum.CHANNEL_UNION:
					this.showM(this.unionMessage);
					break;
				case ChatEnum.CHANNEL_SYSTEM_ALL:
					this.showMessage(this.currentChannelIdx);
					break;
			}
			if (channel == ChatEnum.CHANNEL_SYSTEM) {
				this.systemGridList.updateUI();
				this.systemGridList.scrollTo(1);
			} else {
				this.gridList.updateUI();
				this.gridList.scrollTo(1);
			}
		}

		private function showM(arr:Vector.<String>, systemF:Boolean=false):void {
			if (systemF)
				this.systemMesTxtArea.appendHtmlText(arr[arr.length - 1]);
			else
				this.messageTxtArea.appendHtmlText(arr[arr.length - 1]);
		}

		//添加聊天信息
		private function addMessage(channel:int, str:String):void {
			str=this.getColorContain(str, channel);
			switch (channel) {
				case ChatEnum.CHANNEL_SYSTEM_ALL:
					this.areaMessage.push(str);
					if (this.areaMessage.length > ChatEnum.MESSAGE_MAX_NUM)
						this.areaMessage.shift();
					this.guildMessage.push(str);
					if (this.guildMessage.length > ChatEnum.MESSAGE_MAX_NUM)
						this.guildMessage.shift();
					this.privateMessage.push(str);
					if (this.privateMessage.length > ChatEnum.MESSAGE_MAX_NUM)
						this.privateMessage.shift();
					this.teamMessage.push(str);
					if (this.teamMessage.length > ChatEnum.MESSAGE_MAX_NUM)
						this.teamMessage.shift();
					this.unionMessage.push(str);
					if (this.unionMessage.length > ChatEnum.MESSAGE_MAX_NUM)
						this.unionMessage.shift();
					break;
				case ChatEnum.CHANNEL_AREA:
					this.areaMessage.push(str);
					if (this.areaMessage.length > ChatEnum.MESSAGE_MAX_NUM)
						this.areaMessage.shift();
					break;
				case ChatEnum.CHANNEL_GUILD:
					this.guildMessage.push(str);
					if (this.guildMessage.length > ChatEnum.MESSAGE_MAX_NUM)
						this.guildMessage.shift();
					break;
				case ChatEnum.CHANNEL_PRIVATE:
					this.privateMessage.push(str);
					if (this.privateMessage.length > ChatEnum.MESSAGE_MAX_NUM)
						this.privateMessage.shift();
					break;
				case ChatEnum.CHANNEL_SYSTEM:
					this.systeMesasge.push(str);
					if (this.systeMesasge.length > ChatEnum.MESSAGE_MAX_NUM)
						this.systeMesasge.shift();
					break;
				case ChatEnum.CHANNEL_TEAM:
					this.teamMessage.push(str);
					if (this.teamMessage.length > ChatEnum.MESSAGE_MAX_NUM)
						this.teamMessage.shift();
					break;
				case ChatEnum.CHANNEL_UNION:
					this.unionMessage.push(str);
					if (this.unionMessage.length > ChatEnum.MESSAGE_MAX_NUM)
						this.unionMessage.shift();
					break;
			}
			if (channel != ChatEnum.CHANNEL_SYSTEM) {
				var info:ChatInfo=new ChatInfo();
				info.channelIdx=channel;
				info.contain=str;
				this.compositeMessage.push(info);
				if (this.compositeMessage.length > ChatEnum.MESSAGE_MAX_NUM)
					this.compositeMessage.shift();
			}
		}

		private function getColorContain(contain:String, channel:int):String {
			var name:String=new String();
			var str:String=new String();
			switch (channel) {
				case ChatEnum.CHANNEL_AREA:
					if (contain.indexOf(":") == -1) {
						str=contain;
						str=this.getColorStr(str, ChatEnum.COLOR_SYSYTEM);
					} else {
						name=contain.substring(0, contain.indexOf(":") + 1);
						name=name.slice(3);
//						name="<a href='event:" + "$@@$" + "'>" + name + "</a>";
						name="<a href='event:" + name.substring(0, name.length - 1) + "'>" + name + "</a>";
						str=contain.slice(contain.indexOf(":") + 1);
						name=this.getColorStr(name, ChatEnum.COLOR_USER);
						name=this.getColorStr("【区域】", ChatEnum.COLOR_AREA) + name;
						str=this.getColorStr(str, ChatEnum.COLOR_AREA);
					}
					break;
				case ChatEnum.CHANNEL_SYSTEM:
					str=contain;
					str=this.getColorStr("【系统】" + str, ChatEnum.COLOR_SYSYTEM);
					break;
				case ChatEnum.CHANNEL_GUILD:
					if (contain.indexOf(":") == -1) {
						str=contain;
						str=this.getColorStr(str, ChatEnum.COLOR_SYSYTEM);
					} else {
						name=contain.substring(0, contain.indexOf(":") + 1);
//						name="<a href='event:" + "$@@$" + "'>" + name + "</a>";
						name="<a href='event:" + name.substring(0, name.length - 1) + "'>" + name + "</a>";
//						name="<a href='event:over"+name.substr(0,name.length-1)+"'>"+name+"</a>";
						str=contain.slice(contain.indexOf(":") + 1);
						name=this.getColorStr("【行会】", ChatEnum.COLOR_GUILD) + this.getColorStr(name, ChatEnum.COLOR_USER);
						str=this.getColorStr(str, ChatEnum.COLOR_GUILD);
					}
					break;
				case ChatEnum.CHANNEL_PRIVATE:
					if (contain.indexOf("=>") == -1) {
						str=contain;
						str=this.getColorStr(str, ChatEnum.COLOR_SYSYTEM);
					} else {
						name=contain.substring(0, contain.indexOf("=>"));
						name=name.substring(0, name.indexOf("]") + 1);
//						name="<a href='event:" + "$@@$" + "'>" + name + "</a>";
						this.privateChatRender.checkPrivatePlayerName(name);
						name="<a href='event:" + name.substring(0, name.length - 1) + "'>" + name + "</a>";
						str=contain.slice(contain.indexOf("=>") + 2);
						name=this.getColorStr("【私聊】", ChatEnum.COLOR_PRIVATE) + this.getColorStr(name, ChatEnum.COLOR_USER) + this.getColorStr("对你说:", ChatEnum.COLOR_PRIVATE);
						str=this.getColorStr(str, ChatEnum.COLOR_PRIVATE);
					}
					break;
				case ChatEnum.CHANNEL_TEAM:
					if (contain.indexOf(":") == -1) {
						str=contain;
						str=this.getColorStr(str, ChatEnum.COLOR_SYSYTEM);
					} else {
						name=contain.substring(0, contain.indexOf(":") + 1);
						name=name.slice(4);
//						name="<a href='event:" + "$@@$" + "'>" + name + "</a>";
						name="<a href='event:" + name.substring(0, name.length - 1) + "'>" + name + "</a>";
						str=contain.slice(contain.indexOf(":") + 1);
						name=this.getColorStr("【组队】", ChatEnum.COLOR_TEAM) + this.getColorStr(name, ChatEnum.COLOR_USER);
						str=this.getColorStr(str, ChatEnum.COLOR_TEAM);
					}
					break;
				case ChatEnum.CHANNEL_UNION:
					if (contain.indexOf("：") == -1) {
						str=contain;
						str=this.getColorStr(str, ChatEnum.COLOR_SYSYTEM);
					} else {
						name=contain.substring(0, contain.indexOf("：") + 1);
//						name="<a href='event:" + "$@@$" + "'>" + name + "</a>";
						name="<a href='event:" + name.substring(0, name.length - 1) + "'>" + name + "</a>";
						str=contain.slice(contain.indexOf("：") + 1);
						name=this.getColorStr("【喇叭】", ChatEnum.COLOR_UNION) + this.getColorStr(name, ChatEnum.COLOR_USER);
						str=this.getColorStr(str, ChatEnum.COLOR_UNION);
					}
					break;
				case ChatEnum.CHANNEL_COMPOSITE:
					if (contain.indexOf(":") == -1) {
						str=contain;
						str=this.getColorStr(str, ChatEnum.COLOR_SYSYTEM);
					} else {
						name=contain.substring(0, contain.indexOf(":") + 1);
//						name="<a href='event:" + "$@@$" + "'>" + name + "</a>";
						name="<a href='event:" + name.substring(0, name.length - 1) + "'>" + name + "</a>";
//						name="<a href='event:over"+name.substr(0,name.length-1)+"'>"+name+"</a>";
						str=contain.slice(contain.indexOf(":") + 1);
						name=this.getColorStr("【普通】", ChatEnum.COLOR_COMPOSITE) + this.getColorStr(name, ChatEnum.COLOR_USER);
						str=this.getColorStr(str, ChatEnum.COLOR_COMPOSITE);
					}
					break;
				case ChatEnum.CHANNEL_SYSTEM_ALL:
					str=contain;
					str=this.getColorStr(str, ChatEnum.COLOR_SYSYTEM);
					break;
			}
//			if(name!=""&&name!=null){
//				name="<a href='event:" + "$@@$" + "'>" + name + "</a>";
//			}
			return name + str;
		}

		private function changeChannel(str:String):Boolean {
			if (str.indexOf(ChatEnum.FLAG_TEAM) == 0) {
				this.chatTabBar.turnToTab(ChatEnum.CHANNEL_TEAM);
				return true;
			}
			if (str.indexOf(ChatEnum.FLAG_UNION) == 0) {
				this.chatTabBar.turnToTab(ChatEnum.CHANNEL_UNION);
				return true;
			}
			if (str.indexOf(ChatEnum.FLAG_GUILD) == 0) {
				this.chatTabBar.turnToTab(ChatEnum.CHANNEL_GUILD);
				return true;
			}
			if (str.indexOf(ChatEnum.FLAG_COMPOSITE) == 0) {
				this.chatTabBar.turnToTab(ChatEnum.CHANNEL_COMPOSITE);
				return true;
			}
			if (str.indexOf(ChatEnum.FLAG_PRIVATE) == 0) {
				this.chatTabBar.turnToTab(ChatEnum.CHANNEL_PRIVATE);
				return true;
			}
			if (str.indexOf(ChatEnum.FLAG_AREA) == 0) {
				this.chatTabBar.turnToTab(ChatEnum.CHANNEL_AREA);
				return true;
			}
//			switch (str) {
//				case "/M": //转换到区域
//					this.chatTabBar.turnToTab(ChatEnum.CHANNEL_AREA);
//					return true;
//				case "/G": //行会
//					this.chatTabBar.turnToTab(ChatEnum.CHANNEL_GUILD);
//					return true;
//				case "/R": //私聊
//					this.chatTabBar.turnToTab(ChatEnum.CHANNEL_PRIVATE);
//					return true;
//				case "/P": //组队 
//					this.chatTabBar.turnToTab(ChatEnum.CHANNEL_TEAM);
//					return true;
//				case "/S": //普通 综合
//					this.chatTabBar.turnToTab(ChatEnum.CHANNEL_COMPOSITE);
//					return true;
//			}
			return false;
		}

		/**
		 *检查发言内容
		 * @param str
		 *
		 */
		private function cheakSpeakContain(str:String):Boolean {
			return true;
		}

		private function getColorStr(str:String, color:String):String {
			str="<font color='" + color + "'>" + str + "</font>";
			return str;
		}

		private function showSelfToPan(str:String):void {
			var name:String=str.substring(0, str.indexOf(" "));
			name="<a href='event:" + name + "'>" + name + "</a>";
			var contaion:String=str.slice(str.indexOf(" "));
			contaion=this.getColorStr("【私聊】你对", ChatEnum.COLOR_PRIVATE) + this.getColorStr(name, ChatEnum.COLOR_USER) + this.getColorStr("说:", ChatEnum.COLOR_PRIVATE) + this.getColorStr(contaion, ChatEnum.COLOR_PRIVATE);
			this.addMessage(ChatEnum.CHANNEL_PRIVATE, contaion);
			this.showMessage(ChatEnum.CHANNEL_PRIVATE);
		}

		private function channelChange(flag:Boolean):void {
			if (flag) { //显示私聊
				this.privateChatRender.visible=true;
				this.systemGridList.y-=22;
				this.gridList.y-=22;
				this.bg.y-=22;
				this._bg.y-=22;
				this.addChild(this.privateChatRender);
			} else { //隐藏私聊
				this.privateChatRender.visible=false;
				this.systemGridList.y+=22;
				this.gridList.y+=22;
				this.bg.y+=22;
				this._bg.y+=22;
				this.privateChatRender.setComboxSta(false);
			}
		}

		//设置聊天框输入内容的颜色 根据频道的不同	
		private function setInputTextColor(channel:int):void {
			switch (channel) {
				case ChatEnum.CHANNEL_AREA:
					this.chatInput.input.textColor=ChatEnum.COLOR_AREA_UINT;
					break;
				case ChatEnum.CHANNEL_COMPOSITE:
					this.chatInput.input.textColor=ChatEnum.COLOR_COMPOSITE_UINT;
					break;
				case ChatEnum.CHANNEL_GUILD:
					this.chatInput.input.textColor=ChatEnum.COLOR_GUILD_UINT;
					break;
				case ChatEnum.CHANNEL_PRIVATE:
					this.chatInput.input.textColor=ChatEnum.COLOR_PRIVATE_UINT
					break;
				case ChatEnum.CHANNEL_TEAM:
					this.chatInput.input.textColor=ChatEnum.COLOR_TEAM_UINT;
					break;
				case ChatEnum.CHANNEL_UNION:
					this.chatInput.input.textColor=ChatEnum.COLOR_UNION_UINT;
					break;
			}
		}

		public function get face():Vector.<Sprite> {
			return this.faceWnd.face;
		}

		public function addHorn(str:String):void {
			var idx:int=str.indexOf("：");
			str=this.getColorStr(str.substring(0, idx + 1), ChatEnum.COLOR_USER) + this.getColorStr(str.substring(idx + 1, str.length), ChatEnum.COLOR_HORN);
			if (this.hornArr.length > 0)
				this.hornArr.push(str);
			else {
				this.hornArr.push(str);
				this.horn.setStr(str);
				this.horn.y=-this.horn.height - 3;
			}

		}

		private function nextHorn():void {
			this.hornArr.shift();
			if (this.hornArr.length > 0) {
				this.horn.setStr(this.hornArr[this.hornArr.length - 1]);
				this.horn.y=-this.horn.height - 3;
			}
		}

		public function get hornFlag():Boolean {
			return this._hornFlag;
		}

		/**
		 *发送千里传音指令
		 *
		 */
		public function sendHorn(npcId:int):void {
			_hornFlag=false;
			Cmd_Task.cm_merchantDlgSelect(npcId, TaskEnum.CMD_HORN + "," + this.hornStr);
		}

		//点击玩家的名字
		private function onClickPlayerName(str:String):void {
			var name:String=str;
//			if(this.currentChannelIdx!=ChatEnum.CHANNEL_PRIVATE)
			this.onComBoxClick(ChatEnum.CHANNEL_PRIVATE, "");
			this.privateChatRender.onClickPlayerName(name);
		}

		public function resize():void {
			var xx:Number=UIManager.getInstance().toolsWnd.x;
			if (xx > 290)
				this.y=UIEnum.HEIGHT - this.height + 90;
			else
				this.y=UIEnum.HEIGHT - 332 - 30;
		}
	}
}