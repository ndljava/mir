package com.leyou.ui.market {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.leyou.manager.UIManager;
	
	import flash.events.MouseEvent;

	public class FittingRoomWnd extends AutoWindow {
		private var closeBtn:NormalButton;

		public function FittingRoomWnd() {
			super(LibManager.getInstance().getXML("config/ui/fittingRoomRender.xml"));
			this.init();
		}

		private function init():void {
			this.closeBtn=this.getUIbyID("closeBtn") as NormalButton;
			this.closeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			super.show(toTop,false);
			this.x=UIManager.getInstance().marketWnd.x;
			this.y=UIManager.getInstance().marketWnd.y+370;
		}
		private function onBtnClick(evt:MouseEvent):void {
			UIManager.getInstance().fittingRoomWnd.open();
		}
	}
}