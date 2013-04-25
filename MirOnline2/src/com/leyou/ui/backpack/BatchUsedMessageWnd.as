package com.leyou.ui.backpack {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;

	import flash.events.MouseEvent;

	public class BatchUsedMessageWnd extends AutoWindow {
		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;
		private var numInput:TextInput;
		private var maxNumBtn:NormalButton;
		private var nameLbl:Label;

		public function BatchUsedMessageWnd() {
			super(LibManager.getInstance().getXML("config/ui/backPack/MessageWnd03.xml"));
			this.init();
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;
			this.numInput=this.getUIbyID("numInput") as TextInput;
			this.maxNumBtn=this.getUIbyID("maxNumBtn") as NormalButton;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.maxNumBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "confirmBtn": //确定按钮
					break;
				case "cancelBtn": //取消按钮
					this.open();
					break;
				case "maxNumBtn": //最大值按钮
					break;
			}
		}
	}
}