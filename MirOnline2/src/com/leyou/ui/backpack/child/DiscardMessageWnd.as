package com.leyou.ui.backpack.child {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;

	import flash.events.MouseEvent;

	public class DiscardMessageWnd extends AutoWindow {
		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;
		private var nameLbl:Label;

		public function DiscardMessageWnd() {
			super(LibManager.getInstance().getXML("config/ui/backPack/MessageWnd04.xml"));
			this.init();
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "confirmBtn": //确定按钮
					break;
				case "cancelBtn": //取消按钮
					this.open();
					break;
			}
		}
	}
}