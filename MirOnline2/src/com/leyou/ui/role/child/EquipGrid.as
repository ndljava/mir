package com.leyou.ui.role.child {
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.ui.backpack.child.ItemTip;

	public class EquipGrid extends GridBase {
		private var _type:int;

		public function EquipGrid() {
			super();
		}

		override protected function init():void {
			super.init();
			this.isLock=false;
			this.canMove=true;
			this.gridType=ItemEnum.TYPE_GRID_EQUIP;
			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/character/character_bg.png");
			this.bgBmp.alpha=0;
		}

		override public function updataInfo(info:*):void {
			this.reset();
			this.isLock=false;
			this.isEmpty=false;
			this.bgBmp.alpha=1;
			if (TClientItem(info).isJustFill) {
				return;
			}
			super.updataInfo(info);
			this.iconBmp.updateBmp("items/" + TClientItem(info).s.appr + ".png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.x=4 + (40 - 28) >> 1;
			this.iconBmp.y=4 + (40 - 30) >> 1;
		}

		override protected function reset():void {
			super.reset();
			this.isLock=false;
			this.isEmpty=true;
			this.bgBmp.alpha=0;
			this.iconBmp.bitmapData=null;
		}

		public function clearMe():void {
//			UIManager.getInstance().roleWnd.clearEquip(this.dataId);
			this.reset();
		}

		//经过事件
		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);
//			if (this.isEmpty){
//				
//				return;
//			}
			ItemTip.getInstance().show(this.dataId, this.gridType);
			ItemTip.getInstance().updataPs($x, $y);
		}

		//鼠标离开
		override public function mouseOutHandler():void {
			super.mouseOutHandler();
			ItemTip.getInstance().hide();
		}

		override public function switchHandler(fromItem:GridBase):void {
//			super.switchHandler(fromItem);
			if (this.gridType != fromItem.gridType) {
				if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
					var info:TClientItem=MyInfoManager.getInstance().backpackItems[fromItem.dataId];
					if (info == null)
						return;
					if (ItemEnum.equipPos[info.s.type] == null)
						return;
					var pos:int=ItemEnum.equipPos[info.s.type];
					if (pos == this.dataId) {
						MyInfoManager.getInstance().waitItemUse=fromItem.dataId;
						(fromItem as BackpackGrid).onUse();
					} else if ((this.dataId == ItemEnum.U_ARMRINGL || this.dataId == ItemEnum.U_ARMRINGR) && (pos == ItemEnum.U_ARMRINGL || pos == ItemEnum.U_ARMRINGR)) {
						UIManager.getInstance().roleWnd.dragWrisPos=this.dataId;
						MyInfoManager.getInstance().waitItemUse=fromItem.dataId;
						(fromItem as BackpackGrid).onUse();
					} else if ((this.dataId == ItemEnum.U_RINGL || this.dataId == ItemEnum.U_RINGR) && (pos == ItemEnum.U_RINGL || pos == ItemEnum.U_RINGR)) {
						UIManager.getInstance().roleWnd.dragRingPos=this.dataId;
						MyInfoManager.getInstance().waitItemUse=fromItem.dataId;
						(fromItem as BackpackGrid).onUse();
					}
				}
			}
		}
	}
}