package com.leyou.ui.chat {
	import com.ace.enum.FontEnum;
	import com.ace.enum.KeysEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.KeysManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.input.children.HideInput;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
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
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
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

		private var currentChannelIdx:int; //当前的频道
		private var currentMenuIdx:int;
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
		private var focusFlag:Boolean;

		private var chatLongNum:int;
		private var chatFlag:Boolean;
		private var privateFlag:Boolean;

		private var chatMemoryArr:Vector.<String>;

//		private var chatMemoryIdx:int=-1;


		public function ChatWnd() {
			super(LibManager.getInstance().getXML("config/ui/ChatWnd.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void {
			chatMemoryArr=new Vector.<String>;
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
			this.chatInput.closeEvent();

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

			this.chatComBox=new ChannelComboBox(49, 22, ChatEnum.COMBOX_CHAT_CHANNEL);
			this.chatComBox.x=0;
			this.chatComBox.y=253; //253
			this.chatComBox.onClickItemFun=this.onComBoxClick;
			this.addChild(this.chatComBox);
			this.chatComBox.setItem(["~ 普通", "! 区域", "!! 组队", "!~ 行会", "!@ 千里", "/ 私聊"], [ChatEnum.COLOR_COMPOSITE_UINT, ChatEnum.COLOR_AREA_UINT, ChatEnum.COLOR_TEAM_UINT, ChatEnum.COLOR_GUILD_UINT, ChatEnum.COLOR_UNION_UINT, ChatEnum.COLOR_PRIVATE_UINT]);

			this.messageTxtArea=new RichTextFiled(294, 184);
			this.messageTxtArea.onTextClick=this.onClickPlayerName;
			this.gridList.addToPane(this.messageTxtArea);

			this.privateChatRender=new PrivateChatRender();
			this.privateChatRender.x=55;
			this.privateChatRender.y=211;
			this.privateChatRender.visible=false;
			this.addChild(this.privateChatRender);

			this.chatInput.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			this.chatInput.input.tabEnabled=false;
			this.chatInput.input.useRichTextClipboard=false;

			this.sendBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.faceBtn.addEventListener(MouseEvent.CLICK, onClick);


			this.chatTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);
			this.currentChannelIdx=ChatEnum.CHANNEL_COMPOSITE;
			this.currentMenuIdx=ChatEnum.CHANNEL_COMPOSITE;

			this.horn=new Horn();
			this.horn.timeOutFun=nextHorn;
			this.addChild(this.horn);
			this.hornArr=new Vector.<String>;
			this.hornStr=new String();
		}

		private function onKeyUp(evt:KeyboardEvent):void {
			var idx:int;
			if (evt.keyCode != KeysEnum.ENTER && this.stage.focus == this.chatInput.input)
				this.chatLongNum=this.chatInput.text.length;
			if (evt.keyCode == KeysEnum.ENTER && this.stage.focus == this.chatInput.input) {
				if (this.chatLongNum < this.chatInput.text.length) {
					this.chatLongNum=this.chatInput.text.length;
					this.chatFlag=true;
				}
			}
			if (!KeysManager.getInstance().isDown(KeysEnum.SHIFT))
				evt.stopPropagation();
			switch (evt.keyCode) {
				case KeysEnum.ENTER:
					if (!this.chatInput.text == "" && this.stage.focus == this.chatInput.input) {
						if (!this.chatFlag) {
							this.sendChatCmd();
							return;
						} else {
							this.chatFlag=false;
							return;
						}

					} else {
//						if (!this.focusFlag && this.stage.focus == (this.chatInput.input as HideInput))
//							if (this.stage.focus == this.chatInput.input)
//								this.stage.focus=null;
//							else if (!this.focusFlag&&this.stage.focus != this.chatInput.input)
//								this.stage.focus=this.chatInput.input;
//						if (this.focusFlag)
//							this.focusFlag=false;
//						if(!this.focusFlag){
//							trace(this.focusFlag);
							if (this.stage.focus == this.chatInput.input)
								this.stage.focus=null;
							else if (this.stage.focus != this.chatInput.input)
								this.stage.focus=this.chatInput.input;
//						}
//						else if (this.focusFlag)
//						{
//							trace(this.focusFlag);
//							this.focusFlag=false;
//						}
					}
//					if (this.stage.focus == this.chatInput.input)
//						this.stage.focus=null;
//					else
//						this.stage.focus=this.chatInput.input;
					break;
				case KeysEnum.SPACE:
					if (this.chatInput.text.length == 2 && this.changeChannel(chatInput.text)) {
						this.chatInput.text="";
						return;
					}
					break;
				case KeysEnum.UP:
					if (this.chatMemoryArr.length > 0) {
						if (this.chatMemoryArr.indexOf(this.chatInput.text) == -1)
							idx=0;
						else
							idx=this.chatMemoryArr.indexOf(this.chatInput.text) + 1;
						if (idx < this.chatMemoryArr.length)
							this.chatInput.text=this.chatMemoryArr[idx];
					}
//					if (this.chatMemoryIdx < this.chatMemoryArr.length)
//						this.chatMemoryIdx++;
//					if (this.chatMemoryIdx < this.chatMemoryArr.length) {
//						this.chatInput.text=this.chatMemoryArr[this.chatMemoryIdx];
//					}
					this.chatInput.input.setSelection(this.chatInput.text.length, this.chatInput.text.length);
					break;
				case KeysEnum.DOWN:
					if (this.chatMemoryArr.length > 0) {
						if (this.chatMemoryArr.indexOf(this.chatInput.text) == -1)
							idx=0;
						else
							idx=this.chatMemoryArr.indexOf(this.chatInput.text) - 1;
						if (idx >= 0 && idx < this.chatMemoryArr.length)
							this.chatInput.text=this.chatMemoryArr[idx];
					}
//					if (this.chatMemoryIdx >= 0)
//						this.chatMemoryIdx--;
//					if (this.chatMemoryIdx >= 0 && this.chatMemoryIdx < this.chatMemoryArr.length) {
//						this.chatInput.text=this.chatMemoryArr[this.chatMemoryIdx];
//					}
					this.chatInput.input.setSelection(this.chatInput.text.length, this.chatInput.text.length);
					break;
				default:
					if (this.chatInput.text.length == 1 && this.chatInput.text.indexOf("!") == -1 && this.changeChannel(chatInput.text)) {
						this.chatInput.text="";
						return;
					} else if (this.chatInput.text.length == 2 && this.chatInput.text.indexOf("!") == 0 && this.changeChannel(chatInput.text)) {
						this.chatInput.text="";
						return;
					}
					break;
			}
			var btArr:ByteArray=new ByteArray();
			if (this.currentMenuIdx == ChatEnum.CHANNEL_UNION) {
				btArr.writeMultiByte(this.chatInput.text, "gb2312");
				if (btArr.length > ChatEnum.MESSAGE_HORN_LONG * 2) {
					btArr.length=ChatEnum.MESSAGE_HORN_LONG * 2;
					btArr.position=0;
					this.chatInput.text=btArr.readMultiByte(ChatEnum.MESSAGE_HORN_LONG * 2, "gb2312");
//				if (this.chatInput.text.length > ChatEnum.MESSAGE_HORN_LONG) {
//					this.chatInput.text=this.chatInput.text.substr(0, ChatEnum.MESSAGE_HORN_LONG);
				}
			} else {
				btArr.writeMultiByte(this.chatInput.text, "gb2312");
				if (btArr.length > ChatEnum.MESSAGE_LONG * 2) {
					btArr.length=ChatEnum.MESSAGE_LONG * 2;
					btArr.position=0;
					this.chatInput.text=btArr.readMultiByte(ChatEnum.MESSAGE_LONG * 2, "gb2312");
				}
//				this.chatInput.text=this.chatInput.text.substr(0, ChatEnum.MESSAGE_LONG);
			}
		}

		/**
		 *
		 * @param sign
		 */
		public function addFaceSign(sign:String):void {
			this.chatInput.text+=sign;
			if (this.chatInput.text.length > ChatEnum.MESSAGE_LONG)
				this.chatInput.text=this.chatInput.text.substr(0, ChatEnum.MESSAGE_LONG);
			this.chatInput.input.setSelection(this.chatInput.input.text.length, this.chatInput.input.text.length);
			this.onStageEnter(false);
		}

		/**
		 *点击 tabbar 中按钮
		 * @param evt
		 *
		 */
		private function onTabBarChangeIndex(evt:Event=null):void {
			if (this.chatTabBar.turnOnIndex != this.currentMenuIdx) {
				if (this.currentMenuIdx == ChatEnum.CHANNEL_PRIVATE)
					this.channelChange(false);
				this.chatComBox.setSelectTextByIdx(this.chatTabBar.turnOnIndex);
				this.currentMenuIdx=this.chatTabBar.turnOnIndex;
			}
			if (this.chatTabBar.turnOnIndex == this.currentChannelIdx) {
				if (this.currentChannelIdx == ChatEnum.CHANNEL_PRIVATE) {
					this.channelChange(true);
				}
				this.setInputTextColor(this.currentChannelIdx);
				return;
			}

			if (this.currentChannelIdx == ChatEnum.CHANNEL_PRIVATE)
				this.channelChange(false);
			else if (this.chatTabBar.turnOnIndex == ChatEnum.CHANNEL_PRIVATE)
				this.channelChange(true);
			this.currentChannelIdx=this.chatTabBar.turnOnIndex;
			this.messageTxtArea.clearContain();
			this.gridList.updateUI();
			this.gridList.scrollTo(1);
//			this.chatComBox.setSelectTextByIdx(this.currentChannelIdx);
//			this.currentMenuIdx=this.currentChannelIdx;
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
			if (idx == this.currentMenuIdx) {
				if (this.currentMenuIdx == ChatEnum.CHANNEL_PRIVATE) 
					this.channelChange(true);
				this.setInputTextColor(this.currentMenuIdx);
				return;
			}
			if (this.currentMenuIdx == ChatEnum.CHANNEL_PRIVATE)
				this.channelChange(false);
			if (idx == ChatEnum.CHANNEL_PRIVATE)
				this.channelChange(true);
			this.currentMenuIdx=idx;
			this.chatComBox.setSelectTextByIdx(this.currentMenuIdx);
			this.setInputTextColor(this.currentMenuIdx);
			if (this.currentChannelIdx == ChatEnum.CHANNEL_COMPOSITE)
				return;
			else {
				this.chatTabBar.turnToTab(idx);
				this.onTabBarChangeIndex();
			}
		}

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
//						trace(this.faceWnd.numChildren);
					}
					break;
			}
		}

		//发送聊天信息
		private function sendChatCmd():void {
			this.stage.focus=null;
			if (this.chatInput.text == "")
				return;
			var str:String=this.chatInput.text;
//			if (str.length == 2 && changeChannel(str)) {
//				this.onTabBarChangeIndex();
//				this.chatInput.text="";
//				return;
//			}
			switch (this.currentMenuIdx) {
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
//					} else {\
//					if(!MyInfoManager.getInstance().hasGuild){
////						servOnChat(ChatEnum.CHANNEL_GUILD, "请加入行会后再在行会频道发言");
//						this.messageTxtArea.appendHtmlText(this.getColorStr("请加入行会后再在行会频道发言", ChatEnum.COLOR_SYSYTEM));
//						this.chatInput.text="";
//						return;
//					}else 
					if (UIManager.getInstance().settingWnd.settingInfo.groupChat == 0) { //设置面板中禁止行会聊天
						UIManager.getInstance().noticeMidDownUproll.setNoticeStr("您已设置禁止行会聊天", SystemNoticeEnum.IMG_PROMPT);
						this.chatInput.text="";
						return;
					} else
						str=ChatEnum.FLAG_GUILD + str;
//						this.channelTime[ChatEnum.FLAG_GUILD]=getTimer();
//					}
					break;
				case ChatEnum.CHANNEL_PRIVATE:
					if (getTimer() - this.channelTime[ChatEnum.CHANNEL_PRIVATE] < ChatEnum.TIME_PRIVATE) {
						this.servOnChat(ChatEnum.CHANNEL_PRIVATE, "您发言速度过快，请稍后再试");
						this.chatInput.text="";
						return;
					} else if (UIManager.getInstance().settingWnd.settingInfo.privateChat == 0) {
						UIManager.getInstance().noticeMidDownUproll.setNoticeStr("您已设置禁止私聊!", SystemNoticeEnum.IMG_PROMPT);
						this.chatInput.text == "";
						return;
					} else {
						if (this.privateChatRender.chatPlayerName == "") {
							UIManager.getInstance().noticeMidDownUproll.setNoticeStr("请输入密聊玩家名字", SystemNoticeEnum.IMG_WRONG); //私聊人的名字问空 弹提示 暂无
							this.chatInput.text="";
							return;
						} else {
							this.privateChatRender.checkPrivatePlayerName();
							this.showSelfToPan(this.privateChatRender.chatPlayerName + str);
							str=ChatEnum.FLAG_PRIVATE + this.privateChatRender.chatPlayerName + str;
							this.channelTime[ChatEnum.FLAG_PRIVATE]=getTimer();
						}
					}
					break;
				case ChatEnum.CHANNEL_TEAM:
//					if (getTimer() - this.channelTime[ChatEnum.CHANNEL_TEAM] < ChatEnum.TIME_TEAM) {
//						this.servOnChat(ChatEnum.CHANNEL_TEAM, "您发言速度过快，请稍后再试");
//						this.chatInput.text="";
//						return;
//					} else {
					if (!MyInfoManager.getInstance().hasTeam) {
						this.messageTxtArea.appendHtmlText(this.getColorStr("请加入队伍后再在组队频道发言!", ChatEnum.COLOR_SYSYTEM));
//						servOnChat(ChatEnum.CHANNEL_TEAM, "请加入队伍后再在组队频道发言");
						this.chatInput.text="";
						return;
					} else if (UIManager.getInstance().settingWnd.settingInfo.groupChat == 0) {
						UIManager.getInstance().noticeMidDownUproll.setNoticeStr("您已设置禁止组队聊天!", SystemNoticeEnum.IMG_PROMPT);
						this.chatInput.text == "";
						return;
					} else
						str=ChatEnum.FLAG_TEAM + str;
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
							this.chatMemoryArr.unshift(this.chatInput.text);
							if (this.chatMemoryArr.length > ChatEnum.CHAT_MEMORY_LONG)
								this.chatMemoryArr.pop();
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
				this.chatMemoryArr.unshift(this.chatInput.text);
				if (this.chatMemoryArr.length > ChatEnum.CHAT_MEMORY_LONG)
					this.chatMemoryArr.pop();
				this.chatInput.text="";
				this.stage.focus=null;
			} else {

			}
		}

		//焦点
		public function onStageEnter(f:Boolean=true):void {
//			trace("stage");
			this.focusFlag=f;
			this.stage.focus=this.chatInput.input;
			
//			this.onKeyUp(null);
		}

		//服务器发过来聊天
		public function servOnChat(channel:int, str:String):void {
//			return;
			if (channel == ChatEnum.CHANNEL_COMPOSITE) {
				if (str.match("(!)"))
					channel=ChatEnum.CHANNEL_AREA;
			}
			this.addMessage(channel, str);
			if (channel == ChatEnum.CHANNEL_SYSTEM) //系统频道
				this.showMessage(channel);
			else if (channel == this.currentChannelIdx || channel == ChatEnum.CHANNEL_SYSTEM_ALL || this.currentChannelIdx == ChatEnum.CHANNEL_COMPOSITE)
				this.showMessage(channel);
			else {
				//不是当前频道的信息 显示有新消息特效
			}
//			if (channel != ChatEnum.CHANNEL_SYSTEM && this.currentChannelIdx != channel && channel != ChatEnum.CHANNEL_SYSTEM_ALL&&this.currentChannelIdx!=ChatEnum.CHANNEL_COMPOSITE) {
//				
//			} else if(this.currentChannelIdx==ChatEnum.CHANNEL_COMPOSITE)
//				this.showMessage(this.currentChannelIdx);
//			else this.showMessage(channel);
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
					if (this.channelFalg[this.compositeMessage[this.compositeMessage.length - 1].channelIdx]) {
						if (this.compositeMessage.length >= ChatEnum.MESSAGE_MAX_NUM) {
							this.messageTxtArea.clearContain();
							for (var i:int=0; i < this.compositeMessage.length; i++) {
								this.messageTxtArea.appendHtmlText(compositeMessage[i].contain);
							}
						} else
							this.messageTxtArea.appendHtmlText(compositeMessage[this.compositeMessage.length - 1].contain);
					}
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
			var i:int;
			if (systemF) {
				if (arr.length >= ChatEnum.MESSAGE_MAX_NUM) {
					this.systemMesTxtArea.clearContain();
					for (i=0; i < arr.length; i++) {
						this.systemMesTxtArea.appendHtmlText(arr[i]);
					}
				} else
					this.systemMesTxtArea.appendHtmlText(arr[arr.length - 1]);
			} else {
				if (arr.length >= ChatEnum.MESSAGE_MAX_NUM) {
					this.messageTxtArea.clearContain();
					for (i=0; i < arr.length; i++) {
						this.messageTxtArea.appendHtmlText(arr[i]);
					}
				}
				this.messageTxtArea.appendHtmlText(arr[arr.length - 1]);
			}
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
			if (flag == this.privateFlag) {
				if (flag == true)
					this.privateChatRender.setComBoxFocs();
				return;
			}

			if (flag) { //显示私聊
				this.privateChatRender.visible=true;
				this.systemGridList.y-=22;
				this.gridList.y-=22;
				this.bg.y-=22;
				this._bg.y-=22;
				this.addChild(this.privateChatRender);
				this.privateChatRender.setComBoxFocs();
				this.privateFlag=true;
			} else { //隐藏私聊
				this.privateChatRender.visible=false;
				this.systemGridList.y+=22;
				this.gridList.y+=22;
				this.bg.y+=22;
				this._bg.y+=22;
				this.privateChatRender.setComboxSta(false);
				this.privateFlag=false;
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
		public function onClickPlayerName(str:String):void {
			var name:String=str;
			this.onComBoxClick(ChatEnum.CHANNEL_PRIVATE, "");
			this.privateChatRender.onClickPlayerName(name);
		}

		public function onSign1Down():void {
//			var f:Boolean=KeysManager.getInstance().isDown(KeysEnum.SHIFT);
//			trace("1+"+f);
			if (KeysManager.getInstance().isDown(KeysEnum.SHIFT))
				this.checkSign(1);
		}

		public function onSign2Down():void {
//			var f:Boolean=KeysManager.getInstance().isDown(KeysEnum.SHIFT);
//			trace("2+"+f);
			if (KeysManager.getInstance().isDown(KeysEnum.SHIFT))
				this.checkSign(2);
		}

		public function onSign3Down():void {
//			var f:Boolean=KeysManager.getInstance().isDown(KeysEnum.SHIFT);
//			trace("3+"+f);
			if (KeysManager.getInstance().isDown(KeysEnum.SHIFT))
				this.checkSign(3);
		}

		public function onSignDivideDown():void {
//			trace("4+"+KeysManager.getInstance().isDown(KeysEnum.SHIFT));
			this.checkSign(4);
		}

		private function checkSign(flag:int):void {
			this.chatInput.text="";
			if (flag == 1)
				this.onStageEnter();
			else if (flag == 2)
				this.onStageEnter();
			else if (flag == 3)
				this.onStageEnter();
			else {
				this.chatInput.text="/";
				(this.chatInput.text.length == 1 && this.changeChannel(chatInput.text))
				this.chatInput.text="";
			}
		}

		public function resize():void {
			var xx:Number=UIManager.getInstance().toolsWnd.x;
			var yy:Number=UIEnum.HEIGHT;
			if (xx > 290)
				this.y=yy - this.height + 90;
			else
				this.y=yy - 332 - 30;
		}




	}
}