package com.leyou.ui.shop.child {
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.lable.Label;
	import com.ace.ui.window.children.ConfirmWindow;
	import com.ace.ui.window.children.WindInfo;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.ui.backpack.child.ItemTip;
	
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	public class ShopGrid extends GridBase {
		public function ShopGrid() {
			super(0);
		}

		override protected function init():void {
			super.init();
			this.isLock=false;
			this.canMove=false;
			this.gridType=ItemEnum.TYPE_GRID_SHOP;

			this.iconBmp.x=(40 - 28) >> 1;
			this.iconBmp.y=(40 - 30) >> 1;

			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
			//this.iconBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/lock.png");
			this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/select.png");
		}

		override public function updataInfo(info:*):void {
			super.updataInfo(info);
			this.iconBmp.bitmapData=null;
			this.canMove=false;
			if (info != null)
				this.iconBmp.updateBmp("items/" + info.Looks + ".png");
		}

		//经过事件
		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);
			if (this.isEmpty)
				return;
			ItemTip.getInstance().show(this.dataId,this.gridType);
			ItemTip.getInstance().updataPs($x, $y);
		}

		//鼠标离开
		override public function mouseOutHandler():void {
			super.mouseOutHandler();
			ItemTip.getInstance().hide();
		}

		override public function switchHandler(fromItem:GridBase):void {
			super.switchHandler(fromItem);

			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
				if (fromItem) {
					var tc:TClientItem=MyInfoManager.getInstance().backpackItems[fromItem.dataId] as TClientItem;
					if (tc == null)
						return;
					
					PopupManager.showConfirm("确认卖出?",function():void
					{
						MyInfoManager.getInstance().waitItemFromId=fromItem.dataId;
						//协议
						UIManager.getInstance().shopWnd.sellItem(tc.MakeIndex, tc.s.name);
					});
					
				}
			} else {


			}
		}
	}
}