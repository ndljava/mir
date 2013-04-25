package com.leyou.ui.guild.child {
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.NetEnum;
	import com.leyou.net.protocol.Cmd_Guild;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.net.protocol.scene.CmdScene;

	import flash.events.MouseEvent;

	public class GuildAddContributPanel extends AutoWindow {
		private var okBtn:NormalButton;
		private var cancelBtn:NormalButton;

		private var contributTxt:TextInput;
		private var memberTxt:TextInput;

		public function GuildAddContributPanel() {
			super(LibManager.getInstance().getXML("config/ui/guild/AddContributPage.xml"));
			this.init();
		}

		private function init():void {
			this.okBtn=this.getUIbyID("okBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("concelBtn") as NormalButton;

			this.contributTxt=this.getUIbyID("contribeLbl") as TextInput;
			this.memberTxt=this.getUIbyID("memberLbl") as TextInput;

			this.okBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {
			switch (e.target.name) {
				case "okBtn":
					inputContribut();
					break;
				case "concelBtn":
					this.hide();
					break;
			}
		}

		private function inputContribut():void {
			if (this.contributTxt.text != "" && this.memberTxt.text != "") {
				Cmd_Guild.cm_guildContribute(int(this.contributTxt.text));
				Cmd_Guild.cm_guildStroageType(4, 889, 0, this.memberTxt.text);
				Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, TaskEnum.CMD_GETGUILDVALUE);

				this.hide();
			}
		}

	}
}
