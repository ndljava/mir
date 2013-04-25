package com.leyou.ui.guild {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;

	import flash.events.MouseEvent;

	public class SellMessageWnd extends AutoWindow {
		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;
		private var nameLbl:Label; //道具名字
		private var buyerInput:TextInput; // 购买人
		private var contributionInput:TextInput; //贡献
		private var goldIngotInput:TextInput; //元宝

		public function SellMessageWnd() {
			super(LibManager.getInstance().getXML("config/ui/guild/MessageWnd06.xml"));
			this.init();
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.buyerInput=this.getUIbyID("buyerInput") as TextInput;
			this.contributionInput=this.getUIbyID("contributionInput") as TextInput;
			this.goldIngotInput=this.getUIbyID("goldIngotInput") as TextInput;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "confirmBtn": //确定
					break;
				case "cancelBtn": //取消
					this.open();
					break;
			}
		}
	}
}