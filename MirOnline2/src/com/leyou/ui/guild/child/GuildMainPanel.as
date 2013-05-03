package com.leyou.ui.guild.child {
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.ui.window.children.WindInfo;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Guild;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.utils.GuildUtils;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	public class GuildMainPanel extends AutoSprite {
		private var nameLbl:Label;
		private var leaderNameLbl:Label;
		private var lvLbl:Label;
		private var memberNumLbl:Label;
		private var storeLbl:Label;
		private var contributeLbl:Label;
		private var goldCoinsLbl:Label;
		private var goldIngotLbl:Label;
		private var noticeNumLbl:Label;
		private var noticeText:TextArea;
		private var saveBtn:NormalButton;
		private var getDividendsBtn:NormalButton;

		private var storeBtn:NormalButton;
		private var contribBtn:NormalButton;
		private var goldCoinsBtn:NormalButton;
		private var goldIngotBtn:NormalButton;

		/**
		 *选择存储金币/行会元宝索引
		 */
		public var selectStoreBtnIndex:int=-1;
		/**
		 *选择存储数量
		 */
		public var inputGoldNum:int=-1;


		public function GuildMainPanel() {
			super(LibManager.getInstance().getXML("config/ui/guild/GuildMainPage.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void {
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.leaderNameLbl=this.getUIbyID("leaderNameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.memberNumLbl=this.getUIbyID("memberNumLbl") as Label;
			this.storeLbl=this.getUIbyID("storeLbl") as Label;
			this.contributeLbl=this.getUIbyID("contributeLbl") as Label;
			this.goldCoinsLbl=this.getUIbyID("goldCoinsLbl") as Label;
			this.goldIngotLbl=this.getUIbyID("goldIngotLbl") as Label;
			this.noticeNumLbl=this.getUIbyID("noticeLbl") as Label;
			this.saveBtn=this.getUIbyID("saveBtn") as NormalButton;
			this.getDividendsBtn=this.getUIbyID("getDividendsBtn") as NormalButton;
			this.noticeText=this.getUIbyID("noticeText") as TextArea;

			this.saveBtn=this.getUIbyID("saveBtn") as NormalButton;
			this.getDividendsBtn=this.getUIbyID("getDividendsBtn") as NormalButton;

			this.storeBtn=this.getUIbyID("storeBtn") as NormalButton;
			this.contribBtn=this.getUIbyID("contribBtn") as NormalButton;
			this.goldCoinsBtn=this.getUIbyID("goldCoinsBtn") as NormalButton;
			this.goldIngotBtn=this.getUIbyID("goldIngotBtn") as NormalButton;

			this.saveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.getDividendsBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			this.storeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.contribBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.goldCoinsBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.goldIngotBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			this.noticeText.addEventListener(KeyboardEvent.KEY_UP, onInputKey);
		}

		public function updateData(info:Array):void {
			this.nameLbl.text=info[0] + "";
			this.leaderNameLbl.text=UIManager.getInstance().guildWnd.memberArr[0][2] + "";

			var lv:int=UIManager.getInstance().guildWnd.guildLv;
			var cross:String;

			if (lv <= 1000)
				cross="☆";
			else if (lv <= 3000)
				cross="☆☆";
			else if (lv <= 8000)
				cross="☆☆☆";
			else if (lv <= 15000)
				cross="☆☆☆☆";
			else if (lv <= 30000)
				cross="☆☆☆☆☆";

			this.lvLbl.text=cross + "";

			this.memberNumLbl.text=UIManager.getInstance().guildWnd.guildMemeberNum + "/" + UIManager.getInstance().guildWnd.guildMemeberTopNum;

			this.contributeLbl.text=UIManager.getInstance().guildWnd.storeContribute + "";
			this.goldCoinsLbl.text="" + UIManager.getInstance().guildWnd.storeFund;
			this.noticeText.setText(UIManager.getInstance().guildWnd.guildContent[3] + "");
			this.noticeNumLbl.text=this.noticeText.text.length + "/1000";

			var arr:Array=GuildUtils.getMemberByName(UIManager.getInstance().guildWnd.memberArr, MyInfoManager.getInstance().name);
			if (arr == null)
				return;

			if (arr[0] != "1") {
				this.storeBtn.visible=false;
				this.contribBtn.visible=false;
				this.goldCoinsBtn.visible=false;
				this.goldIngotBtn.visible=false;
			} else {
				this.storeBtn.visible=true;
				this.contribBtn.visible=true;
				this.goldCoinsBtn.visible=true;
				this.goldIngotBtn.visible=true;
			}
		}

		public function set coinsTxt(s:String):void {
			this.goldCoinsLbl.text=s;
		}

		public function set goldTxt(s:String):void {
			this.goldIngotLbl.text=s;
		}

		public function set storeTxt(s:String):void {
			this.storeLbl.text=s;
		}

		private function onBtnClick(evt:MouseEvent):void {
			var arr:Array=GuildUtils.getMemberByName(UIManager.getInstance().guildWnd.memberArr, MyInfoManager.getInstance().name);
			if (arr == null || arr[0] != "1")
				return;

			switch (evt.target.name) {
				case "saveBtn": //保存  
					if (this.noticeText.text != null && this.noticeText.text != "")
						Cmd_Guild.cm_guildUpdateNotice(this.noticeText.text);
					break;
				case "getDividendsBtn": // 
					break;
				case "storeBtn": // 
					changeGoldFunc(0, "请输入元宝数量:")
					break;
				case "contribBtn": // 
					UIManager.getInstance().guildAddCtbWnd.show();
					break;
				case "goldCoinsBtn": // 
					changeMoneyFunc();
					break;
				case "goldIngotBtn": // 
					changeGoldFunc(1, "请输入转存元宝数量:")
					break;
			}
		}

		private function onInputKey(e:KeyboardEvent):void {
			this.noticeNumLbl.text=this.noticeText.text.length + "/1000";
		}

		/**
		 * 更新贡献值
		 *
		 */
		private function changeContribFunc():void {
			PopupManager.showConfirmInput("请输入贡献数:", function(msg:String):void {
				if (msg == null || msg.match(/\d*/g).length == 0 || msg == "0")
					return;

				Cmd_Guild.cm_guildContribute(int(msg));
				PopupManager.showConfirmInput("请贡献给的玩家:", inputContribMember);
			});

			function inputContribMember(msg:String):void {
				if (msg == null || msg == "")
					return;

				Cmd_Guild.cm_guildStroageType(4, 889, 0, msg);
				Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, TaskEnum.CMD_GETGUILDVALUE);
			}
		}

		/**
		 * 更改银两数量
		 *
		 */
		private function changeMoneyFunc():void {
			PopupManager.showConfirmInput("请输入银两数:", function(msg:String):void {
				if (msg == null || msg.match(/\d*/g).length == 0 || msg == "0")
					return;

				Cmd_Guild.cm_addGuildGold(int(msg));
				Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, TaskEnum.CMD_GETGUILDVALUE);
			});
		}

		/**
		 * 更改金币数量
		 * @param i
		 * @param str
		 *
		 */
		private function changeGoldFunc(i:int, str:String):void {
			PopupManager.showConfirmInput(str, function(msg:String):void {
				if (msg == null || msg.match(/\d*/g).length == 0 || msg == "0")
					return;
 
				if (i == 1)
					Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, TaskEnum.CMD_SETGUILDVALUE + ",行会元宝," + int(msg));
				else
					Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, TaskEnum.CMD_SETGUILDVALUE + ",储备元宝," + int(msg));

				Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, TaskEnum.CMD_GETGUILDVALUE);
			});
		}

	}
}
