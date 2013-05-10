package com.leyou.ui.friend {
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.leyou.ui.chat.child.MenuButton;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

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
			for (var i:int=0; i < dataArr.length; i++) {
				var bmp:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg("ui/other/button_font.png"));
				bmp.scale9Grid=new Rectangle(5, 5, 42, 15);
				var norBtn:MenuButton=new MenuButton(bmp.bitmapData, dataArr[i], bmp.width, 20);
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