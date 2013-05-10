package com.leyou.ui.forge {
	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Forge;
	import com.leyou.ui.backpack.BackpackWnd;
	import com.leyou.ui.forge.child.ForgeGrid;

	import flash.events.MouseEvent;

	public class ForgeWnd extends AutoWindow {

		private var titleNameLbl:Label;
		private var contextTxT:TextArea;
		private var confirmBtn:NormalButton;

		private var gridlist:Vector.<ForgeGrid>;

		private var gridDataList:Vector.<TClientItem>;

		public var forgeItem:Boolean=false;

		public function ForgeWnd() {
			super(LibManager.getInstance().getXML("config/ui/ForgeWnd.xml"));
			this.init();
		}

		private function init():void {
			this.titleNameLbl=this.getUIbyID("titleLbl") as Label;
			this.contextTxT=this.getUIbyID("descTxt") as TextArea;
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);

			var bgrid:TextArea=new TextArea(230, 145, false);
			bgrid.x=26;
			bgrid.y=66;

			this.addToPane(bgrid);

			gridlist=new Vector.<ForgeGrid>();
			gridDataList=new Vector.<TClientItem>();

			var grid:ForgeGrid;

			for (var i:int=0; i < 15; i++) {
				grid=new ForgeGrid(i);

				grid.x=35 + i % 5 * (grid.width + 5);
				grid.y=75 + Math.floor(i / 5) * (grid.height + 5);

				this.addToPane(grid);
				this.gridlist.push(grid);
			}

			this.mouseChildren=true;
		}

		private function updateGridList():void {
			var grid:GridBase;
			for (var i:int=0; i < this.gridlist.length; i++) {
				if (i < this.gridDataList.length) {
					this.gridlist[i].updataInfo(this.gridDataList[i]);
				} else {
					this.gridlist[i].updataInfo(null);
				}
			}
		}

		/**
		 * 根据id
		 * @param id
		 *
		 */
		public function updateOneGridByID(id:int):void {
			if (id == -1)
				return;

			var tc:TClientItem=MyInfoManager.getInstance().backpackItems[id];
			if (tc == null || tc.s == null)
				return;

			this.gridDataList.length=0;
			this.gridDataList.push(tc);

			updateGridList();
		}

		/**
		 *删除一个格子
		 * @param mid
		 *
		 */
		public function dropOneGrid(mid:int):void {
			var tc:TClientItem;
			for (var i:int=0; i < this.gridDataList.length; i++) {
				if (this.gridDataList[i].MakeIndex == mid) {
					this.gridDataList.splice(i, 1);
					this.gridlist[i].updataInfo(null);
				}
			}
		}

		public function updateOneGrid():void {
			var g:GridBase=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, MyInfoManager.getInstance().waitItemFromId);
			if (g.data == null || g.data.s == null)
				return;

			this.gridDataList.push(g.data);
			updateGridList();

			MyInfoManager.getInstance().resetItem(g.dataId);
			g.updataInfo(null);
			MyInfoManager.getInstance().resetWaitItem();
		}

		private function onClick(e:MouseEvent):void {
			if (this.gridDataList.length > 0) {
				Cmd_Forge.cm_fifItemOk();
				forgeItem=true;
			}
		}

		public function serv_show(body:String):void {
			super.show();

			var bag:BackpackWnd=UIManager.getInstance().backPackWnd;
			bag.show();

			bag.x=(UIEnum.WIDTH - bag.width - this.width) / 2;
			this.x=bag.x + bag.width + 5;
			this.y=bag.y;

			var arr:Array=body.split("/");
			this.titleNameLbl.text=arr[0];
			this.contextTxT.setText(arr[1]);
		}

		override public function hide():void {
			super.hide();
			UIManager.getInstance().backPackWnd.refresh();
		}


	}
}
