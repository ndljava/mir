package com.leyou.ui.stall.child {
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.backPack.TClientItem;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.shop.child.ShopListRender;
	import com.leyou.utils.ItemUtil;

	import flash.events.MouseEvent;

	public class StallListRender extends ShopListRender {

		private var itemGrid:StallGrid;

		public function StallListRender() {
			super();
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private function onMouseUp(e:MouseEvent):void {
			if (UIManager.getInstance().stallWnd.itemOtherDataArr.length == 0)
				itemGrid.send_ChangeItem();
			else  
				itemGrid.confirmBuy();
		}

		private function init():void {
			this.itemGrid=new StallGrid;
			this.itemGrid.x=3;
			this.itemGrid.y=6;

			this.addChild(itemGrid);

			this.moneyKindTxt.text="金币:";
			this.priceTxt.x-=25;
		}

		public function update(info:TClientItem):void {
			if (info == null) {
				this.nameTxt.text="";
				this.priceTxt.text="";

				this.itemGrid.updateInfo(null);
			} else {
				this.nameTxt.text=info.s.name + "";
				this.priceTxt.text=ItemUtil.getSplitMoneyTextTo4(String(info.nPrice)) + "";

				this.itemGrid.updateInfo(info);
			}
		}


	}
}
