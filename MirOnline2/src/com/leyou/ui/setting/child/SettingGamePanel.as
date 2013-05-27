package com.leyou.ui.setting.child {
	import com.ace.gameData.setting.SettingGameInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.button.event.ButtonEvent;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Chat;
	import com.leyou.net.protocol.Cmd_Team;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SettingGamePanel extends AutoSprite {
		private var drugChBox:CheckBox;
		private var npcChBox:CheckBox;
		private var monsterChBox:CheckBox;
		private var snowChBox:CheckBox;
		private var onlyDrugChBox:CheckBox;
		private var simpleNameBtn:RadioButton;
		private var complexNameBtn:RadioButton;
		private var autoPickupChBox:CheckBox;
		private var groupChatChBox:CheckBox;
		private var natureHumanChBox:CheckBox;
		private var guildAndChBox:CheckBox;
		private var coupleTransferChBox:CheckBox;
		private var teacherPuilTransferChBox:CheckBox;
		private var tradeChBox:CheckBox;
		private var gruopChBox:CheckBox;
		private var joinGuildChBox:CheckBox;
		private var privateChatChBox:CheckBox;
		private var guildChatChBox:CheckBox;
		private var shiftAttackChBox:CheckBox;
		private var warehouseLockChBox:CheckBox;
		private var loginLockChBox:CheckBox;
		private var _settinginfor:SettingGameInfo;

		public function SettingGamePanel() {
			super(LibManager.getInstance().getXML("config/ui/setting/SettingGame.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {
			this.drugChBox=this.getUIbyID("drugChBox") as CheckBox;
			this.npcChBox=this.getUIbyID("npcChBox") as CheckBox;
			this.monsterChBox=this.getUIbyID("monsterChBox") as CheckBox;
			this.snowChBox=this.getUIbyID("snowChBox") as CheckBox;
			this.onlyDrugChBox=this.getUIbyID("onlyDrugChBox") as CheckBox;
			this.simpleNameBtn=this.getUIbyID("simpleNameBtn") as RadioButton;
			this.complexNameBtn=this.getUIbyID("complexNameBtn") as RadioButton;
			this.autoPickupChBox=this.getUIbyID("autoPickupChBox") as CheckBox;
			this.groupChatChBox=this.getUIbyID("groupChatChBox") as CheckBox;
			this.natureHumanChBox=this.getUIbyID("natureHumanChBox") as CheckBox;
			this.guildAndChBox=this.getUIbyID("guildAndChBox") as CheckBox;
			this.coupleTransferChBox=this.getUIbyID("coupleTransferChBox") as CheckBox;
			this.teacherPuilTransferChBox=this.getUIbyID("teacherPuilTransferChBox") as CheckBox;
			this.tradeChBox=this.getUIbyID("tradeChBox") as CheckBox;
			this.gruopChBox=this.getUIbyID("gruopChBox") as CheckBox;
			this.joinGuildChBox=this.getUIbyID("joinGuildChBox") as CheckBox;
			this.privateChatChBox=this.getUIbyID("privateChatChBox") as CheckBox;
			this.guildChatChBox=this.getUIbyID("guildChatChBox") as CheckBox;
			this.shiftAttackChBox=this.getUIbyID("shiftAttackChBox") as CheckBox;
			this.warehouseLockChBox=this.getUIbyID("warehouseLockChBox") as CheckBox;
			this.loginLockChBox=this.getUIbyID("loginLockChBox") as CheckBox;

			this.drugChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.npcChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.monsterChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.snowChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.onlyDrugChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.simpleNameBtn.addEventListener(ButtonEvent.Switch_Change, onClick);
			this.autoPickupChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.groupChatChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.natureHumanChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.guildAndChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.coupleTransferChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.teacherPuilTransferChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.tradeChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.gruopChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.joinGuildChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.privateChatChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.guildChatChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.shiftAttackChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.warehouseLockChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.loginLockChBox.addEventListener(MouseEvent.CLICK, onClick);
		}

		public function updataInfo(infor:SettingGameInfo):void {
			this._settinginfor=infor;
			if (infor.drug == 1)
				this.drugChBox.turnOn(false);
			else
				this.drugChBox.turnOff(false);
			if (infor.npc == 1)
				this.npcChBox.turnOn(false);
			else
				this.npcChBox.turnOff(false);
			if (infor.monster == 1)
				this.monsterChBox.turnOn(false);
			else
				this.monsterChBox.turnOff(false);
			if (infor.snow == 1)
				this.snowChBox.turnOn(false);
			else
				this.snowChBox.turnOff(false);
			if (infor.onlyDrug == 1)
				this.onlyDrugChBox.turnOn(false);
			else
				this.onlyDrugChBox.turnOff(false);
			if (infor.simpleName == 1)
				this.simpleNameBtn.turnOn(false);
			else {
				this.simpleNameBtn.turnOff(false);
				this.complexNameBtn.turnOn(false);
			}
			if (infor.autoPickup == 1)
				this.autoPickupChBox.turnOn(false);
			else
				this.autoPickupChBox.turnOff(false);
			if (infor.groupChat == 1)
				this.groupChatChBox.turnOn(false);
			else
				this.groupChatChBox.turnOff(false);
			if (infor.natureHuman == 1)
				this.natureHumanChBox.turnOn(false);
			else
				this.natureHumanChBox.turnOff(false);
			if (infor.guildAnd == 1)
				this.guildAndChBox.turnOn(false);
			else
				this.guildAndChBox.turnOff(false);
			if (infor.coupleTransfer == 1)
				this.coupleTransferChBox.turnOn(false);
			else
				this.coupleTransferChBox.turnOff(false);
			if (infor.teacherPuilTransfer == 1)
				this.teacherPuilTransferChBox.turnOn(false);
			else
				this.teacherPuilTransferChBox.turnOff(false);
			if (infor.trade == 1)
				this.tradeChBox.turnOn(false);
			else
				this.tradeChBox.turnOff(false);
			if (infor.gruop == 1) {
				this.gruopChBox.turnOn(false);
			} else {
				this.gruopChBox.turnOff(false);
			}
			UIManager.getInstance().teamWnd.setTeamState((infor.gruop == 1 ? true : false));

			if (infor.joinGuild == 1)
				this.joinGuildChBox.turnOn(false);
			else
				this.joinGuildChBox.turnOff(false);
			if (infor.privateChat == 1)
				this.privateChatChBox.turnOn(false);
			else
				this.privateChatChBox.turnOff(false);
			if (infor.guildChat == 1)
				this.guildChatChBox.turnOn(false);
			else
				this.guildChatChBox.turnOff(false);
			if (infor.shiftAttack == 1)
				this.shiftAttackChBox.turnOn(false);
			else
				this.shiftAttackChBox.turnOff(false);
			if (infor.warehouseLock == 1)
				this.warehouseLockChBox.turnOn(false);
			else
				this.warehouseLockChBox.turnOff(false);
			if (infor.loginLock == 1)
				this.loginLockChBox.turnOn(false);
			else
				this.loginLockChBox.turnOff(false);
		}

		private function onClick(evt:Event):void {
			switch (evt.target.name) {
				case "drugChBox": //显示药品格
					if (this.drugChBox.isOn)
						this._settinginfor.drug=1;
					else
						this._settinginfor.drug=0;
					UIManager.getInstance().settingWnd.saveClientData();
					break;
				case "npcChBox": //显示NPC名称
					if (this.npcChBox.isOn)
						this._settinginfor.npc=1;
					else
						this._settinginfor.npc=0;
					UIManager.getInstance().settingWnd.saveClientData();
					break;
				case "monsterChBox": //显示怪物名称
					if (this.monsterChBox.isOn)
						this._settinginfor.monster=1;
					else
						this._settinginfor.monster=0;
					UIManager.getInstance().settingWnd.saveClientData();
					break;
				case "snowChBox": //启用飘血设置
					if (this.snowChBox.isOn)
						this._settinginfor.snow=1;
					else
						this._settinginfor.snow=0;
					UIManager.getInstance().settingWnd.saveClientData();
					break;
				case "onlyDrugChBox": //只能显示药品格
					if (this.onlyDrugChBox.isOn)
						this._settinginfor.onlyDrug=1;
					else
						this._settinginfor.onlyDrug=0;
					UIManager.getInstance().settingWnd.saveClientData();
					break;
				case "complexNameBtn": //显示简单人名
				case "simpleNameBtn": //显示完整人名
					if (this.simpleNameBtn.isOn) {
						this._settinginfor.simpleName=1;
						this._settinginfor.complexName=0;
					} else {
						this._settinginfor.complexName=1;
						this._settinginfor.simpleName=0;
					}
					UIManager.getInstance().settingWnd.saveClientData();
					break;
				case "autoPickupChBox": //自动拾取物品
					if (this.autoPickupChBox.isOn)
						this._settinginfor.autoPickup=1;
					else
						this._settinginfor.autoPickup=0;
					UIManager.getInstance().settingWnd.saveClientData();
					break;
				case "groupChatChBox": //允许组队聊天
					Cmd_Chat.cm_say("@拒绝组队聊天");
					break;
				case "natureHumanChBox": //允许天人合一
					Cmd_Chat.cm_say("@允许天地合一");
					break;
				case "guildAndChBox": //允许行会合一
					Cmd_Chat.cm_say("@允许行会合一");
					break;
				case "coupleTransferChBox": //允许夫妻传送
					Cmd_Chat.cm_say("@允许夫妻传送");
					break;
				case "teacherPuilTransferChBox": //允许师徒传送
					Cmd_Chat.cm_say("@允许师徒传送");
					break;
				case "tradeChBox": //允许交易\
					Cmd_Chat.cm_say("@拒绝交易");
					break;
				case "gruopChBox": //允许组队
					//					Cmd_Chat.cm_say("@允许组队");
					if (this.gruopChBox.isOn)
						this._settinginfor.gruop=1;
					else
						this._settinginfor.gruop=0;

					UIManager.getInstance().settingWnd.saveClientData();
					UIManager.getInstance().teamWnd.setTeamState(this._settinginfor.gruop == 1 ? true : false);
					break;
				case "joinGuildChBox": //允许加入行会
					if (this.joinGuildChBox.isOn)
						this._settinginfor.joinGuild=1;
					else
						this._settinginfor.joinGuild=0;
					UIManager.getInstance().settingWnd.saveClientData();
					break;
				case "privateChatChBox": //允许私人聊天
					Cmd_Chat.cm_say("@拒绝私聊");
					break;
				case "guildChatChBox": //允许行会聊天
					Cmd_Chat.cm_say("@拒绝行会聊天");
					break;
				case "shiftAttackChBox": //免Shift攻击
					if (this.shiftAttackChBox.isOn)
						this._settinginfor.shiftAttack=1;
					else
						this._settinginfor.shiftAttack=0;
					UIManager.getInstance().settingWnd.saveClientData();
					break;
				case "warehouseLockChBox": //启用仓库锁
					if (this.warehouseLockChBox.isOn)
						this._settinginfor.warehouseLock=1;
					else
						this._settinginfor.warehouseLock=0;
					UIManager.getInstance().settingWnd.saveClientData();
					break;
				case "loginLockChBox": //启用登录锁
					if (this.loginLockChBox.isOn)
						this._settinginfor.loginLock=1;
					else
						this._settinginfor.loginLock=0;
					UIManager.getInstance().settingWnd.saveClientData();
					break; //“加入行会” 1019
			}
		}

		public function get settingInfo():SettingGameInfo {
			return _settinginfor;
		}

		public function setSettingIsOnTeam(v:Boolean):void {
			if(v)
				this.gruopChBox.turnOn();
			else 
				this.gruopChBox.turnOff();
			
			if (this.gruopChBox.isOn)
				this._settinginfor.gruop=1;
			else
				this._settinginfor.gruop=0;
			
			UIManager.getInstance().settingWnd.saveClientData();
			UIManager.getInstance().teamWnd.setTeamState(this._settinginfor.gruop == 1 ? true : false);
		}

		public function check(body:String):void {
			if (body.indexOf("禁止群聊") != -1) { //组队聊天
				this._settinginfor.groupChat=0;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("允许群聊") != -1) { //组队聊天
				this._settinginfor.groupChat=1;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("禁止私聊") != -1) {
				this._settinginfor.privateChat=0;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("允许私聊") != -1) {
				this._settinginfor.privateChat=1;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("禁止行会聊天") != -1) {
				this._settinginfor.guildChat=0;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("允许行会聊天") != -1) {
				this._settinginfor.guildChat=1;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("允许天地合一") != -1) {
				this._settinginfor.natureHuman=1;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("禁止天地合一") != -1) {
				this._settinginfor.natureHuman=0;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("禁止行会合一") != -1) {
				this._settinginfor.guildAnd=0;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("允许行会合一") != -1) {
				this._settinginfor.guildAnd=1;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("允许夫妻传送") != -1) {
				this._settinginfor.coupleTransfer=1;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("禁止夫妻传送") != -1) {
				this._settinginfor.coupleTransfer=0;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("禁止师徒传送") != -1) {
				this._settinginfor.teacherPuilTransfer=0;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("允许师徒传送") != -1) {
				this._settinginfor.teacherPuilTransfer=1;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("禁止交易") != -1) {
				this._settinginfor.trade=0;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			} else if (body.indexOf("允许交易") != -1) {
				this._settinginfor.trade=1;
				this.updataInfo(this._settinginfor);
				UIManager.getInstance().settingWnd.saveClientData();
			}
		}
	}
}
