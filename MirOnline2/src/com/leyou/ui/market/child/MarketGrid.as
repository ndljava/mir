package com.leyou.ui.market.child {
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.leyou.ui.backpack.child.ItemTip;
	import com.leyou.ui.shop.child.ShopGrid;

	public class MarketGrid extends ShopGrid {
		public function MarketGrid() {
			super();
		}
		override protected function init():void{
			super.init();
			this.gridType=ItemEnum.TYPE_GRID_MARKET;
		}
		//经过事件
		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);
			if (this.isEmpty)
				return;
			ItemTip.getInstance().show(this.dataId,this.gridType);
			ItemTip.getInstance().updataPs($x, $y);
		}
		override public function switchHandler(fromItem:GridBase):void{
			
		}
	}
}