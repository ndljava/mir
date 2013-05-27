package com.leyou.ui.setting {
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.setting.SettingGameInfo;
	import com.ace.gameData.setting.SettingVideoInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.manager.ShareObjManage;
	import com.leyou.net.protocol.Cmd_Chat;
	import com.leyou.ui.setting.child.SettingGamePanel;
	import com.leyou.ui.setting.child.SettingVideoPanel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SettingWnd extends AutoWindow {
		private var settingTabBar:TabBar;
		private var restoreBtn:NormalButton;
//		private var saveBtn:NormalButton;
//		private var confirmBtn:NormalButton;
		private var settingGamePanel:SettingGamePanel;
		private var settingVideoPanel:SettingVideoPanel;
		private var settingGameInfo:SettingGameInfo;
		private var settingVideoInfo:SettingVideoInfo;

		public function SettingWnd() {
			super(LibManager.getInstance().getXML("config/ui/SettingWnd.xml"));
			this.init();
		}

		private function init():void {
			this.settingGameInfo=new SettingGameInfo();
			this.settingVideoInfo=new SettingVideoInfo();
			this.settingTabBar=this.getUIbyID("settingTabBar") as TabBar;
			this.restoreBtn=this.getUIbyID("restoreBtn") as NormalButton;
//			this.saveBtn=this.getUIbyID("saveBtn") as NormalButton;
//			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;

			this.settingTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);
			this.restoreBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
//			this.saveBtn.addEventListener(MouseEvent.CLICK, onSaveBtnClick);
//			this.confirmBtn.addEventListener(MouseEvent.CLICK, onConfirmBtnClick);

			this.settingGamePanel=new SettingGamePanel();
			this.settingVideoPanel=new SettingVideoPanel();

			this.settingTabBar.addToTab(settingGamePanel, 0);
			this.settingTabBar.addToTab(settingVideoPanel, 1);
			 
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			super.show(toTop, toCenter);
			this.getClientData();
			this.updata();
		}

		private function initSettingGameInfo():void {
			if (this.settingGameInfo == null)
				this.settingGameInfo=new SettingGameInfo();
			this.settingGameInfo.drug=1;
			this.settingGameInfo.autoPickup=1;
			this.settingGameInfo.complexName=1;
			this.settingGameInfo.coupleTransfer=0;
			this.settingGameInfo.groupChat=1;
			this.settingGameInfo.gruop=0;
			this.settingGameInfo.guildAnd=0;
			this.settingGameInfo.guildChat=1;
			this.settingGameInfo.joinGuild=0;
			this.settingGameInfo.loginLock=0;
			this.settingGameInfo.monster=1;
			this.settingGameInfo.natureHuman=0;
			this.settingGameInfo.npc=1;
			this.settingGameInfo.onlyDrug=1;
			this.settingGameInfo.privateChat=1;
			this.settingGameInfo.shiftAttack=0;
			this.settingGameInfo.simpleName=0;
			this.settingGameInfo.snow=1;
			this.settingGameInfo.teacherPuilTransfer=0;
			this.settingGameInfo.trade=1;
			this.settingGameInfo.warehouseLock=0;
		}

		public function updata():void {
			this.settingVideoPanel.updataInfo(this.settingVideoInfo);
			this.settingGamePanel.updataInfo(this.settingGameInfo);
		}

		public function initData():void{
			this.getClientData();
			this.updata();
		}
		
		//点击导航栏
		private function onTabBarChangeIndex(evt:Event):void {
			trace(this.settingTabBar.turnOnIndex);
		}

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "restoreBtn":
					restorn();
					break;
			}
		}

		public function checkServReturn(body:String):void {
			this.settingGamePanel.check(body);
		}

		private function restorn():void {
			if (this.settingTabBar.turnOnIndex == 0) {
				this.restornSetting();
				this.settingGamePanel.updataInfo(this.settingGameInfo);
			} else if (this.settingTabBar.turnOnIndex == 1) {
				this.restormSettingVideo();
				this.settingVideoPanel.updataInfo(this.settingVideoInfo);
			}
			this.saveClientData();
		}

		private function restornSetting():void {
			this.settingGameInfo=this.settingGamePanel.settingInfo;
			this.settingGameInfo.drug=1;
			this.settingGameInfo.autoPickup=1;
			this.settingGameInfo.complexName=1;
			if (this.settingGameInfo.coupleTransfer != 0)
				Cmd_Chat.cm_say("@允许夫妻传送");
//			this.settingGameInfo.coupleTransfer=0;
			if (this.settingGameInfo.groupChat != 1)
				Cmd_Chat.cm_say("@拒绝组队聊天");
//			this.settingGameInfo.groupChat=1;
			this.settingGameInfo.gruop=0;
			if (this.settingGameInfo.guildAnd != 0)
				Cmd_Chat.cm_say("@允许行会合一");
//			this.settingGameInfo.guildAnd=0;
			if (this.settingGameInfo.guildChat != 1)
				Cmd_Chat.cm_say("@拒绝行会聊天");
//			this.settingGameInfo.guildChat=1;
			this.settingGameInfo.joinGuild=0;
			this.settingGameInfo.loginLock=0;
			this.settingGameInfo.monster=1;
			if (this.settingGameInfo.natureHuman != 0)
				Cmd_Chat.cm_say("@允许天地合一");
//			this.settingGameInfo.natureHuman=0;
			this.settingGameInfo.npc=1;
			this.settingGameInfo.onlyDrug=1;
			if (this.settingGameInfo.privateChat != 1)
				Cmd_Chat.cm_say("@拒绝私聊");
//			this.settingGameInfo.privateChat=1;
			this.settingGameInfo.shiftAttack=0;
			this.settingGameInfo.simpleName=0;
			this.settingGameInfo.snow=1;
			if (this.settingGameInfo.teacherPuilTransfer != 0)
				Cmd_Chat.cm_say("@允许师徒传送");
//			this.settingGameInfo.teacherPuilTransfer=0;
			if (this.settingGameInfo.trade != -1)
				Cmd_Chat.cm_say("@拒绝交易");
//			this.settingGameInfo.trade=1;
			this.settingGameInfo.warehouseLock=0;
		}

		private function restormSettingVideo():void {
			if (this.settingVideoInfo == null)
				this.settingVideoInfo=new SettingVideoInfo();
			this.settingVideoInfo.bgMusic=1;
			this.settingVideoInfo.interfaceSound=1;
			this.settingVideoInfo.sceneMusicRepeat=1;
			this.settingVideoInfo.skillSound=1;
			this.settingVideoInfo.turnOffMusic=1;
			this.settingVideoInfo.windowMode=1;
		}

		private function getClientData():void {
			var id:String=MyInfoManager.getInstance().name;
			var shareObj:Object=ShareObjManage.getInstance().readFile(id + "setting");
			if (shareObj != null && shareObj.gameInfo != null) {
				this.settingGameInfo.autoPickup=shareObj.gameInfo.autoPickup;
				this.settingGameInfo.complexName=shareObj.gameInfo.complexName;
				this.settingGameInfo.coupleTransfer=shareObj.gameInfo.coupleTransfer;
				this.settingGameInfo.drug=shareObj.gameInfo.drug;
				this.settingGameInfo.groupChat=shareObj.gameInfo.groupChat;
				this.settingGameInfo.gruop=shareObj.gameInfo.gruop;
				this.settingGameInfo.guildAnd=shareObj.gameInfo.guildAnd;
				this.settingGameInfo.guildChat=shareObj.gameInfo.guildChat;
				this.settingGameInfo.joinGuild=shareObj.gameInfo.joinGuild;
				this.settingGameInfo.loginLock=shareObj.gameInfo.loginLock;
				this.settingGameInfo.monster=shareObj.gameInfo.monster;
				this.settingGameInfo.natureHuman=shareObj.gameInfo.natureHuman;
				this.settingGameInfo.npc=shareObj.gameInfo.npc;
				this.settingGameInfo.onlyDrug=shareObj.gameInfo.onlyDrug;
				this.settingGameInfo.privateChat=shareObj.gameInfo.privateChat;
				this.settingGameInfo.shiftAttack=shareObj.gameInfo.shiftAttack;
				this.settingGameInfo.snow=shareObj.gameInfo.snow;
				this.settingGameInfo.simpleName=shareObj.gameInfo.simpleName;
				this.settingGameInfo.teacherPuilTransfer=shareObj.gameInfo.teacherPuilTransfer;
				this.settingGameInfo.trade=shareObj.gameInfo.trade;
				this.settingGameInfo.warehouseLock=shareObj.gameInfo.warehouseLock;
			} else
				this.initSettingGameInfo();
			if (shareObj != null && shareObj.videoInfo != null) {
				this.settingVideoInfo.bgMusic=shareObj.videoInfo.bgMusic;
				this.settingVideoInfo.interfaceSound=shareObj.videoInfo.interfaceSound;
				this.settingVideoInfo.sceneMusicRepeat=shareObj.videoInfo.sceneMusicRepeat;
				this.settingVideoInfo.skillSound=shareObj.videoInfo.skillSound;
				this.settingVideoInfo.turnOffMusic=shareObj.videoInfo.turnOffMusic;
				this.settingVideoInfo.windowMode=shareObj.videoInfo.windowMode;
			} else
				this.restormSettingVideo();

		}

		public function saveClientData():void {
			var obj:Object=new Object();
			obj.gameInfo=this.settingGameInfo;
			obj.videoInfo=this.settingVideoInfo;
			ShareObjManage.getInstance().saveFile(MyInfoManager.getInstance().name + "setting", obj);
		}

		/**
		 *返回设置面板中第一个板上的信息
		 * @return
		 *
		 */
		public function get settingInfo():SettingGameInfo {
			if (this.settingGamePanel.settingInfo == null) {
				this.getClientData();
				this.updata();
			}
			return this.settingGamePanel.settingInfo;
		}

		public function get videoInfo():SettingVideoInfo {
			if (this.settingVideoPanel.settingVideoInfo == null) {
				this.getClientData();
				this.updata();
			}
			return this.settingVideoPanel.settingVideoInfo;
		}
		
		public function get settingGamePane():SettingGamePanel{
			return this.settingGamePanel;
		}
		
	}
}