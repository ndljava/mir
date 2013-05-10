package com.leyou.ui.forge.child {
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.leyou.net.protocol.Cmd_Forge;
	import com.leyou.ui.backpack.child.BackpackGrid;

	public class ForgeGrid extends GridBase {

		private var tc:TClientItem;

		public function ForgeGrid(id:int) {
			super(id);
		}

		override protected function init():void {
			super.init();

			this.iconBmp.x=(40 - 28) >> 1;
			this.iconBmp.y=(40 - 30) >> 1;

			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
			//this.iconBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/lock.png");
			this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/select.png");

			this.isLock=false;
			//this.canMove=false;
			this.gridType=ItemEnum.TYPE_GRID_FORGE;
		}

		override public function switchHandler(fromItem:GridBase):void {

			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {

				var tc:TClientItem=fromItem.data;
				if (tc == null || tc.s == null)
					return;

				MyInfoManager.getInstance().waitItemFromId=fromItem.gridId;
				Cmd_Forge.cm_fifItem(tc.MakeIndex);
			}
		}

		override public function mouseDownHandler($x:Number, $y:Number):void {

		}

		override public function mouseMoveHandler($x:Number, $y:Number):void {

		}

		override public function mouseOutHandler():void {

		}

		override public function mouseOverHandler($x:Number, $y:Number):void {

		}

		override public function mouseUpHandler($x:Number, $y:Number):void {

		}

		override public function updataInfo(info:*):void {
			this.reset();
			this.unlocking();

			if (info == null)
				return;

			if (TClientItem(info).isJustFill) {
				return;
			}

			super.updataInfo(info);

			this.iconBmp.updateBmp("items/" + TClientItem(info).s.appr + ".png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;

			//this.dataId=MyInfoManager.getInstance().backpackItems.indexOf(info);
			tc=info;
		}

		override public function get data():* {
			return tc;
		}

	}
}
