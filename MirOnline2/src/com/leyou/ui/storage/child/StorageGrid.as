package com.leyou.ui.storage.child {
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_backPack;
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.utils.ItemUtil;

	public class StorageGrid extends BackpackGrid {

		public function StorageGrid(id:int) {
			super(id);
		}

		override protected function init():void {
			super.init();
			this.gridType=ItemEnum.TYPE_GRID_STORAGE;
			this.mouseChildren=true;
		}

		override public function updataInfo(info:*):void {
			super.updataInfo(info);
		}

		override protected function reset():void {
			super.reset();
		}

		override public function dropHandler():void {

		}

		override public function mouseDownHandler($x:Number, $y:Number):void {
			//仓库批量存取
			if (UIManager.getInstance().backPackWnd.visible && UIManager.getInstance().storageWnd.isbatchSave) {
				MyInfoManager.getInstance().waitItemFromId=this.dataId; //从仓库
				MyInfoManager.getInstance().waitItemToId=MyInfoManager.getInstance().findEmptyPs(ItemEnum.TYPE_GRID_BACKPACK);
				Cmd_backPack.cm_userTakeBackStorageItem(MyInfoManager.getInstance().talkNpcId, data);
				UIManager.getInstance().storageWnd.mouseChildren=false;
			}
		}

		override public function switchHandler(fromItem:GridBase):void {

			UIManager.getInstance().backPackWnd.showDragGlowFilter(false);
			UIManager.getInstance().toolsWnd.showDragGlowFilter(false);

			super.switchHandler(fromItem);
			if (this.gridType != fromItem.gridType) {

				//如果来自背包
				if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {

					if (!UIManager.getInstance().storageWnd.matchToDrag(BackpackGrid(fromItem).data))
						return;

					MyInfoManager.getInstance().waitItemFromId=fromItem.dataId; //从背包
					MyInfoManager.getInstance().waitItemToId=this.initId; //到仓库
					Cmd_backPack.cm_userStorageItem(MyInfoManager.getInstance().talkNpcId, MyInfoManager.getInstance().backpackItems[fromItem.dataId]);
					return ;
				}
			}
			
			MyInfoManager.getInstance().resetWaitItem();
		}

		override public function mouseMoveHandler($x:Number, $y:Number):void {
			super.mouseMoveHandler($x, $y);
		}

		override public function doubleClickHandler():void {

		}

		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);
		}

		override public function mouseOutHandler():void {
			super.mouseOutHandler();
			
			if (DragManager.getInstance().grid != null && this.data!=null && this.data.s!=null) {
				UIManager.getInstance().storageWnd.showDragGlowFilter(true);
				if (ItemUtil.EQUIP_TYPE.concat(ItemUtil.ITEM_TOOL).indexOf(this.data.s.type) > -1)
					UIManager.getInstance().toolsWnd.showDragGlowFilter(true);
			}
		}

		override public function mouseUpHandler($x:Number, $y:Number):void {
			//super.mouseUpHandler($x,$y);
			if (BackpackGrid.menuState == 2) {
				if (MyInfoManager.getInstance().waitItemFromId != -1) {
					
					var g:GridBase=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, MyInfoManager.getInstance().waitItemFromId);
					var info1:TClientItem=BackpackGrid(g).data;
					
					if (info1 == null || info1.s == null)
						return;
					
					MyInfoManager.getInstance().waitItemFromId=g.dataId; //从背包
					MyInfoManager.getInstance().waitItemToId=this.dataId; //到仓库
					Cmd_backPack.cm_userStorageItem(MyInfoManager.getInstance().talkNpcId, MyInfoManager.getInstance().backpackItems[g.dataId]);
				}
				
				BackpackGrid.menuState=-1;
				//MyInfoManager.getInstance().resetWaitItem();
			}
		}

	}
}
