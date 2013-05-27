package com.leyou.ui.stall.child {
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.lable.Label;
	import com.ace.ui.window.children.SimpleWindow;
	import com.ace.ui.window.children.WindInfo;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Stall;
	import com.leyou.ui.backpack.child.BackpackGrid;

	public class StallGrid extends GridBase {
		private var numLbl:Label;

		public static var POPWIND:SimpleWindow;
		
		public function StallGrid(id:int=-1) {
			super(id);
		}

		override protected function init():void {
			super.init();
			this.isLock=true;
			this.canMove=false;
			this.gridType=ItemEnum.TYPE_GRID_STALL;

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

		public function updateInfo(info:TClientItem):void {
			super.updataInfo(info);

			if (info != null) {
				this.iconBmp.updateBmp("items/" + TClientItem(info).s.appr + ".png");
				//this.dataId=MyInfoManager.getInstance().backpackItems.indexOf(info);
				if (TClientItem(info).Addvalue[0] > 1)
					this.numLbl.text=TClientItem(info).Addvalue[0];
			} else {
				this.iconBmp.bitmapData=null;
				this.numLbl.text="";
			}
		}

		override public function mouseUpHandler($x:Number, $y:Number):void {
			//ConfirmWindow.showWin("你确定要购买么?", buyItem);

		}

		override public function mouseDownHandler($x:Number, $y:Number):void {
			//super.mouseDownHandler($x, $y);
		}

		private function buyItem():void {
			var renderIndex:int=UIManager.getInstance().stallWnd.itemRenderArr.indexOf(this.parent as StallListRender);

			if (renderIndex >= UIManager.getInstance().stallWnd.itemOtherDataArr.length)
				return;

			var tc:TClientItem=UIManager.getInstance().stallWnd.itemOtherDataArr[renderIndex] as TClientItem;
			if (tc == null || tc.s == null)
				return;

			Cmd_Stall.cm_buybtitem(tc.MakeIndex, tc.nPrice);
		}

		override public function switchHandler(fromItem:GridBase):void {
			super.switchHandler(fromItem);
			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {


			}
		}

		public function confirmBuy():void {

			var renderIndex:int=UIManager.getInstance().stallWnd.itemRenderArr.indexOf(this.parent as StallListRender);

			if (renderIndex >= UIManager.getInstance().stallWnd.itemOtherDataArr.length)
				return;

			var tc:TClientItem=UIManager.getInstance().stallWnd.itemOtherDataArr[renderIndex] as TClientItem;
			if (tc == null || tc.s == null)
				return;

			POPWIND=PopupManager.showConfirm("你确定要购买么?", buyItem);
		}

		public function send_ChangeItem():void {

			var g:GridBase;
			if (BackpackGrid.menuState == 2)
				g=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, MyInfoManager.getInstance().waitItemFromId);
			else
				g=DragManager.getInstance().grid;

			if (g == null)
				return;

			var tc:TClientItem=g.data;
			if (tc == null || tc.s == null || g.gridType != ItemEnum.TYPE_GRID_BACKPACK)
				return;

			POPWIND=PopupManager.showConfirmInput("请输入价钱:", okPrice, cancelFunc);

			function okPrice(i:String):void {
				if (i == null || i == "0" || i == "" || int(i) == 0)
					return;

				if (i != "" && i.match(/^[0-9]+$/g).length == 0) {
					PopupManager.showAlert("请输入正确的价钱!", function():void {
						POPWIND=PopupManager.showConfirmInput("请输入价钱:", okPrice);
					});
					return;
				}

				if (i.length >= 10) {
					PopupManager.showAlert("请输入正确的数值!", function():void {
						POPWIND=PopupManager.showConfirmInput("请输入价钱:", okPrice);
					});
					return;
				}

				MyInfoManager.getInstance().waitItemFromId=g.initId;

				Cmd_Stall.cm_btItem_add(tc.MakeIndex, int(i));
				tc.nPrice=int(i);
				BackpackGrid.menuState=-1;
			}

			function cancelFunc():void {
				BackpackGrid.menuState=-1;
			}
		}



	}
}
