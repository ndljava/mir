package com.leyou.ui.backpack {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.scrollBar.event.ScrollBarEvent;
	import com.ace.ui.slider.children.HSlider;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SplitMessageWnd extends AutoWindow {
		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;
		private var splitHSlider:HSlider;

		public function SplitMessageWnd() {
			super(LibManager.getInstance().getXML("config/ui/backPack/MessageWnd02.xml"));
			this.init();
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;
			this.splitHSlider=this.getUIbyID("splitHSlider") as HSlider;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.splitHSlider.addEventListener(ScrollBarEvent.Progress_Update, onChange);
		}

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "confirmBtn": //确定按钮
					break;
				case "cancelBtn":
					this.open();
					break;
			}
		}

		private function onChange(evt:Event):void {
//			this.splitHSlider.progress
		}
	}
}