package com.leyou.ui.trade.child {
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Trade;
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.ui.backpack.child.ItemTip;

	public class TradeGrid extends GridBase {

		private var numLbl:Label;

		public function TradeGrid() {
			super(-1);
		}

		override protected function init():void {
			super.init();
			this.isLock=true;
			this.gridType=ItemEnum.TYPE_GRID_TRADE;

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

		override public function updataInfo(info:*):void {
			this.reset();
			super.updataInfo(info);

			//this.numLbl.text=TClientItem(info).s.name;
			if (info != null) {
				this.iconBmp.updateBmp("items/" + TClientItem(info).s.appr + ".png");
				this.dataId=MyInfoManager.getInstance().backpackItems.indexOf(info);
				if (TClientItem(info).Addvalue[0] > 1)
					this.numLbl.text=TClientItem(info).Addvalue[0];
			} else {
				this.iconBmp.bitmapData=null;
				this.numLbl.text="";
			}
		}
		
		override protected function reset():void
		{
			this.dataId=-1;
		}

		//经过事件
		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);
			if (this.isEmpty)
				return;

			ItemTip.getInstance().show(this.dataId, this.gridType);
			ItemTip.getInstance().updataPs($x, $y);
		}

		//鼠标离开
		override public function mouseOutHandler():void {
			super.mouseOutHandler();
			ItemTip.getInstance().hide();
		}

		override public function mouseDownHandler($x:Number, $y:Number):void {
			//send_DragdealAddItem();
		}

		public function send_DragdealAddItem():void {
			//设置当前render的index;
			UIManager.getInstance().tradeWnd.waitIndex=int(this.parent.name.split("_")[1]);

			var g:GridBase;
			if (BackpackGrid.menuState == 2)
				g=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, MyInfoManager.getInstance().waitItemFromId);
			else
				g=DragManager.getInstance().grid;

			if (g == null)
				return;

			g.enable=false;
			
			var tc:TClientItem=g.data as TClientItem;
			if (this.dataId != -1 || tc == null || tc.s == null || g.gridType != ItemEnum.TYPE_GRID_BACKPACK)
				return;

			MyInfoManager.getInstance().waitItemFromId=g.gridId;

			//协议
			Cmd_Trade.cm_dealAddItem(tc);
			BackpackGrid.menuState=-1;
		}

		override public function switchHandler(fromItem:GridBase):void {
			//super.switchHandler(fromItem);

			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
				//send_DragdealAddItem();
			}
		}

		override public function mouseUpHandler($x:Number, $y:Number):void {
			//super.mouseUpHandler($x,$y);
			//trace("dddddddddddddddd");
		}


	}
}
