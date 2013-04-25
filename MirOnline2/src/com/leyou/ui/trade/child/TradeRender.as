package com.leyou.ui.trade.child {
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	
	import flash.events.MouseEvent;
	
	public class TradeRender extends AutoSprite {
		private var itemNameLbl:Label;
		public var itemGrid:TradeGrid;
		
		public function TradeRender() {
			super(LibManager.getInstance().getXML("config/ui/trade/tradeRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			itemGrid.send_DragdealAddItem();
		}
		
		private function init():void {
			this.itemNameLbl=this.getUIbyID("itemNameLbl") as Label;
			
			this.itemNameLbl.text="";
			
			this.itemGrid=new TradeGrid;
			this.itemGrid.x=8;
			this.itemGrid.y=8;
			this.addChild(itemGrid)
		}
		
		public function updataInfo($info:TClientItem):void {
			if ($info != null) {
				this.itemGrid.updataInfo($info);
				this.itemNameLbl.text=$info.s.name + "";
			} else {
				this.itemGrid.updataInfo(null);
				this.itemNameLbl.text="";
			}
		}
	}
}
