package com.leyou.ui.role.child {
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.backPack.TSClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Role;
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.ui.backpack.child.ItemTip;
	import com.leyou.utils.FilterUtil;

	public class EquipGrid extends GridBase {
		private var _type:int;
		private var moveFlag:Boolean;

		public function EquipGrid() {
			super();
		}

		override protected function init():void {
			super.init();
			this.isLock=false;
			this.canMove=false;
			this.gridType=ItemEnum.TYPE_GRID_EQUIP;
			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/character/character_bg.png");
			this.bgBmp.alpha=0;

		}

		override public function updataInfo(info:*):void {
			this.reset();
			if ((this.gridType == ItemEnum.TYPE_GRID_EQUIP && (info as TClientItem).s == null || info == null) || (this.gridType == ItemEnum.TYPE_GRID_OTHER_EQUIP) && info == null)
				return;
			this.isLock=false;
			this.isEmpty=false;
			this.bgBmp.alpha=1;
			if (this.gridType == ItemEnum.TYPE_GRID_EQUIP) {
				if (TClientItem(info).isJustFill)
					return;
			}
			super.updataInfo(info);
			if (this.gridType == ItemEnum.TYPE_GRID_EQUIP)
				this.iconBmp.updateBmp("items/" + TClientItem(info).s.appr + ".png");
			if (this.gridType == ItemEnum.TYPE_GRID_OTHER_EQUIP) {
				this.iconBmp.updateBmp("items/" + TItemInfo(info).appr + ".png");
				this.canMove=false;
			}
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.x=4 + (40 - 28) >> 1;
			this.iconBmp.y=4 + (40 - 30) >> 1;
//			this.enable=false;
		}

		override protected function reset():void {
			super.reset();
			this.isLock=false;
			this.isEmpty=true;
			this.bgBmp.alpha=0;
			this.iconBmp.bitmapData=null;
			this.enable=true;
		}

		public function clearMe():void {
			this.reset();
		}

		//经过事件
		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);
			ItemTip.getInstance().show(this.dataId, this.gridType);
			ItemTip.getInstance().updataPs($x, $y);
		}

		//鼠标离开
		override public function mouseOutHandler():void {
			super.mouseOutHandler();
			ItemTip.getInstance().hide();
		}

		override public function switchHandler(fromItem:GridBase):void {
			if (this.gridType == ItemEnum.TYPE_GRID_OTHER_EQUIP) {
				fromItem.enable=true;
				return;
			}

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

		override public function doubleClickHandler():void {
			if (this.gridType != ItemEnum.TYPE_GRID_EQUIP || this.isEmpty == true)
				return;
			var equip:TClientItem;
			//多个物品id当到一个格子的问题
			if (this.dataId == 2 || this.dataId == 0 || this.dataId == 4) {
				equip=MyInfoManager.getInstance().equips[this.dataId];
				if (equip == null || equip.s == null) {
					var i:int;
					if (this.dataId == 2)
						i=14;
					else if (this.dataId == 4)
						i=13;
					else if (this.dataId == 0)
						i=15;

					equip=MyInfoManager.getInstance().equips[i];
					if (equip == null || equip.s == null)
						return;
					else {
						UIManager.getInstance().roleWnd.takeOffEquipId=i;
						Cmd_Role.cm_takeOffItem(equip.MakeIndex, this.dataId, equip.s.name);
					}

				} else {
					UIManager.getInstance().roleWnd.takeOffEquipId=this.dataId;
					Cmd_Role.cm_takeOffItem(equip.MakeIndex, this.dataId, equip.s.name);
				}
			} else {
				equip=MyInfoManager.getInstance().equips[this.dataId];
				if (equip == null || equip.s == null)
					return;

				UIManager.getInstance().roleWnd.takeOffEquipId=this.dataId;
				Cmd_Role.cm_takeOffItem(equip.MakeIndex, this.dataId, equip.s.name);
			}
		}

		override public function set enable(value:Boolean):void {
			super.enable=value;

			if (!value) {
				this.iconBmp.filters=[FilterUtil.enablefilter];
			} else {
				this.iconBmp.filters=[];
				this.moveFlag=false;
			}
		}

		override public function mouseDownHandler($x:Number, $y:Number):void {
			super.mouseDownHandler($x, $y);
			this.moveFlag=true;
		}

		override public function mouseMoveHandler($x:Number, $y:Number):void {
			if (this.moveFlag){
				this.enable=false;
				this.moveFlag=false;
			}
				
		}

		override public function mouseUpHandler($x:Number, $y:Number):void {
			this.moveFlag=false;
			UIManager.getInstance().roleWnd.mouseUp();
		}


	}
}