package com.leyou.ui.lost.child {
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.backpack.child.ItemTip;

	public class LostGrid extends GridBase {
		private var numLbl:Label;

		public function LostGrid(id:int=-1) {
			super(id);
		}

		override protected function init():void {
			super.init();

			this.isLock=false;
			this.gridType=ItemEnum.TYPE_GRID_LOST;

			this.iconBmp.x=(40 - 28) >> 1;
			this.iconBmp.y=(40 - 30) >> 1;

			this.numLbl=new Label();
			this.numLbl.x=22;
			this.numLbl.y=24;
			this.addChild(this.numLbl);

			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
			//this.iconBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/lock.png");
			this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/select.png");
		}

		override public function mouseDownHandler($x:Number, $y:Number):void {


		}

		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);
			if (this.isEmpty)
				return;

			var i:int=UIManager.getInstance().lostWnd.getRenderToIndex(this.parent as LostRender);
			if (i == -1)
				return;
			
			if(LostRender(this.parent).isEmpty())
				return ;

			ItemTip.getInstance().show(i, this.gridType);
			ItemTip.getInstance().updataPs($x, $y);
		}

		override public function mouseOutHandler():void {
			super.mouseOutHandler();
			ItemTip.getInstance().hide();
		}

		override public function switchHandler(fromItem:GridBase):void {
			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
				//super.switchHandler(fromItem);
			}
		}

		override public function updataInfo(info:*):void {
			this.reset();
			this.unlocking();

			super.updataInfo(info);

			if (info == null)
				this.iconBmp.bitmapData=null;
			else
				this.iconBmp.updateBmp("items/" + TItemInfo(info).appr + ".png");
		}

		public function sendLost():void {

		}
	}
}
