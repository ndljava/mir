package com.leyou.ui.friend {
	import com.ace.manager.LibManager;
	import com.leyou.ui.chat.child.MenuButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class MeunList extends Sprite {
		private var dataArr:Array;
		public var listClickFun:Function;
		public var listKey:Array;

		public function MeunList(data:Array, key:Array) {
			this.dataArr=data;
			this.listKey=key;
			this.init();
		}

		private function init():void {
			var norBtn:MenuButton;
			for (var i:int=0; i < dataArr.length; i++) {
				norBtn=new MenuButton(LibManager.getInstance().getImg("ui/other/button_font.png"),dataArr[i],0,20);
				norBtn.name=listKey[i].toString();
				norBtn.y=norBtn.height * i;
				this.addChild(norBtn);
			}
			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(evt:MouseEvent):void {
			var idx:int=int((evt.target as MenuButton).name);
			var index:int=listKey.indexOf(idx, 0);
			if (this.listClickFun != null)
				this.listClickFun(idx, dataArr[index]);
		}
	}
}