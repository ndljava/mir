package com.leyou.data.bag {

	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridSort;
	import com.ace.gameData.player.MyInfoManager;

	public class GridOrder extends GridSort {
		public function GridOrder() {
			super();
		}

		override public function resetGrid(type:String):void {

			//			var startIndex:int;
			//			var endIndex:int;
			//			if (type == ItemEnum.TYPE_GRID_BACKPACK) {
			//				startIndex=0;
			//				endIndex=ItemEnum.BACKPACK_GRID_OPEN;
			//			} else {
			//				startIndex=ItemEnum.BACKPACK_GRID_TOTAL;
			//				endIndex=ItemEnum.BACKPACK_GRID_TOTAL + ItemEnum.STORAGE_GRIDE_OPEN;
			//			}

			//var arr:Vector=MyInfoManager.getInstance().backpackItems;
			//for (var i:int=startIndex; i < endIndex; i++) {
			//如果在开启范围内
			//				if (i < ItemEnum.BACKPACK_GRID_OPEN || (i > ItemEnum.BACKPACK_GRID_TOTAL && i < (ItemEnum.STORAGE_GRIDE_OPEN + ItemEnum.BACKPACK_GRID_TOTAL)))
			//this.gridDic[type+i]=MyInfoManager.getInstance().backpackItems[i];


			//}

			super.resetGrid(type);

		}
	}

}
