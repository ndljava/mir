package com.leyou.ui.role {
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.role.child.EquipGrid;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PlayerUtil;
	
	import flash.events.MouseEvent;

	public class RoleWnd extends AutoWindow {
		private var nameLbl:Label;
		private var lvLbl:Label;
		private var raceLbl:Label;
		private var detailBtn:NormalButton;
		private var ifFristShow:Boolean;
		private var gridArr:Object;
		private var _takeOffEquipId:int=-1;
		private var _dragWrisPos:int=-1; //记录拖动穿手镯的位置
		private var _dragRingPos:int=-1; //记录拖动穿戒指的位置
		private var wrisPos:int;
		private var ringPos:int;
		private var _waitPutPos:int; //发指令要放的位置

		public function RoleWnd() {
			super(LibManager.getInstance().getXML("config/ui/RoleWnd.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void {
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.raceLbl=this.getUIbyID("raceLbl") as Label;
			this.detailBtn=this.getUIbyID("detailBtn") as NormalButton;
			this.detailBtn.addEventListener(MouseEvent.CLICK, onDetailBtnClick);

			this.gridArr=new Object();
			var equipGrid:EquipGrid;
			var i:int;
			for (i=0; i < 10; i++) {
				equipGrid=new EquipGrid();
				equipGrid.y=110 + (i % 5) * 70;
				equipGrid.x=32 + (i % 2) * 272;
				equipGrid.dataId=ItemUtil.getTypeByPos(i);
				this.gridArr[equipGrid.dataId]=equipGrid;
				this.addToPane(equipGrid);
			}
			for (i=0; i < 3; i++) {
				equipGrid=new EquipGrid();
				equipGrid.x=90 + i * (172 - 95);
				equipGrid.y=440;
				equipGrid.dataId=ItemUtil.getTypeByPos(i + 10);
				this.gridArr[equipGrid.dataId]=equipGrid;
				this.gridArr[equipGrid.dataId]=equipGrid;
				this.addToPane(equipGrid);
			}
//			this.gridInfo=new Object();
		}

		public function updata(arr:Vector.<TClientItem>):void {
			for (var i:int=0; i < arr.length; i++) {
				if (arr[i].s != null) {
					this.updateGridInfo(i, arr[i]);
				}
			}
		}

		private function updateGridInfo(i:int, Info:TClientItem):void {
			if (i == 14) {
				(this.gridArr[2] as EquipGrid).updataInfo(Info);
			} else if (i == 13) {
				(this.gridArr[4] as EquipGrid).updataInfo(Info);
			} else if (i == 15) {
				(this.gridArr[0] as EquipGrid).updataInfo(Info);
			} else if (i == ItemEnum.U_ARMRINGL || i == ItemEnum.U_ARMRINGR) {
				(this.gridArr[i] as EquipGrid).updataInfo(Info);
			} else if (i == ItemEnum.U_RINGL || i == ItemEnum.U_RINGR) {
				(this.gridArr[i] as EquipGrid).updataInfo(Info);
			} else {
				(this.gridArr[i] as EquipGrid).updataInfo(Info);
			}
		}

		/**
		 *点击详细信息按钮
		 * @param evt
		 *
		 */
		private function onDetailBtnClick(evt:MouseEvent):void {
			UIManager.getInstance().propertyWnd.open();
		}

		public override function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			this.nameLbl.text=MyInfoManager.getInstance().name;
			this.lvLbl.text=MyInfoManager.getInstance().level + "级";
			this.raceLbl.text=PlayerUtil.getPlayerRaceByIdx(MyInfoManager.getInstance().race);
			super.show(toTop, toCenter);
		}

		public function set takeOffEquipId(id:int):void {
			this._takeOffEquipId=id;
		}

		public function takeOffResult(f:Boolean):void {
			if (this._takeOffEquipId == -1)
				return;
			if (f) { //成功
				MyInfoManager.getInstance().equips[_takeOffEquipId].s=null;
				(this.gridArr[this._takeOffEquipId] as EquipGrid).clearMe();
			} else { //失败
				UIManager.getInstance().noticeMidDownUproll.setNoticeStr(MyInfoManager.getInstance().equips[this._takeOffEquipId].s.name + " 脱装备失败", SystemNoticeEnum.IMG_WARN);
			}
			this._takeOffEquipId=-1;
		}

		/**
		 *拖动穿装备
		 * @param id
		 *
		 */
		public function takeOnEquip(id:int):void {
			var info:TClientItem=MyInfoManager.getInstance().backpackItems[id];
			var i:int=ItemEnum.equipPos[info.s.type];

			if (i == ItemEnum.U_ARMRINGL || i == ItemEnum.U_ARMRINGR || i == ItemEnum.U_RINGL || i == ItemEnum.U_RINGR) {
				i=this._waitPutPos;
			}
			this.updateGridInfo(i, info);
			MyInfoManager.getInstance().equips[i]=info;
			this._dragRingPos=-1;
			this._dragWrisPos=-1
		}

		public function set dragRingPos(pos:int):void {
			this._dragRingPos=pos;
		}

		public function set dragWrisPos(pos:int):void {
			this._dragWrisPos=pos;
		}

		public function set waitPutPos(pos:int):void {
			this._waitPutPos=pos;
		}

		public function get dragRingPos():int {
			return this._dragRingPos;
		}

		public function get dragWrisPos():int {
			return this._dragWrisPos;
		}

		/**
		 *计算穿戴手镯 戒指的位置的方法 两个位置都有东西的时候先左后右 （不受拖拽和空位的影响）
		 * @param flag
		 * @return
		 *
		 */
		public function checkWrisRingPos(flag:int):int {
			var pos:int;
			if (flag == ItemEnum.U_ARMRINGL || flag == ItemEnum.U_ARMRINGR) {
				if (this.gridArr[ItemEnum.U_ARMRINGL].isEmpty && this.gridArr[ItemEnum.U_ARMRINGR].isEmpty) {
					wrisPos=ItemEnum.U_ARMRINGL;
					pos=ItemEnum.U_ARMRINGL;
				} else if (this.gridArr[ItemEnum.U_ARMRINGL].isEmpty == false && this.gridArr[ItemEnum.U_ARMRINGR].isEmpty == false) {
					if (this.wrisPos == 0 || this.wrisPos == ItemEnum.U_ARMRINGR)
						this.wrisPos=ItemEnum.U_ARMRINGL;
					else if (this.wrisPos == ItemEnum.U_ARMRINGL)
						this.wrisPos=ItemEnum.U_ARMRINGR;
					pos=this.wrisPos;
				} else {
					if (this.gridArr[ItemEnum.U_ARMRINGL].isEmpty)
						pos=ItemEnum.U_ARMRINGL;
					else if (this.gridArr[ItemEnum.U_ARMRINGR].isEmpty)
						pos=ItemEnum.U_ARMRINGR;
				}
			} else if (flag == ItemEnum.U_RINGL || flag == ItemEnum.U_RINGR) {
				if (this.gridArr[ItemEnum.U_RINGL].isEmpty && this.gridArr[ItemEnum.U_RINGR].isEmpty)
					pos=ItemEnum.U_RINGR;
				else if (this.gridArr[ItemEnum.U_RINGL].isEmpty == false && this.gridArr[ItemEnum.U_RINGR].isEmpty == false) {
					if (this.ringPos == 0 || this.ringPos == ItemEnum.U_RINGR)
						this.ringPos=ItemEnum.U_RINGL;
					else if (this.ringPos == ItemEnum.U_RINGL)
						this.ringPos=ItemEnum.U_RINGR;
					pos=this.ringPos;
				} else {
					if (this.gridArr[ItemEnum.U_RINGR].isEmpty)
						pos=ItemEnum.U_RINGR;
					else if (this.gridArr[ItemEnum.U_RINGL].isEmpty)
						pos=ItemEnum.U_RINGL;
				}
			}
			return pos;
		}

		public function resetDragPos():void {
			this._dragRingPos=-1;
			this._dragWrisPos=-1;
		}

		public function updateLevel():void {
			this.lvLbl.text=MyInfoManager.getInstance().level.toString();
		}

		/**
		 *删除某个道具 
		 * @param info
		 * 
		 */		
		public function serv_removeItem(info:TClientItem):void {
			if (info == null)
				return;
			var e:Vector.<TClientItem>=MyInfoManager.getInstance().equips;
			for (var i:int=0; i < e.length; i++) {
				if (info.MakeIndex == e[i].MakeIndex && e[i].s != null) {
					MyInfoManager.getInstance().equips[i].s=null;
					if(this.gridArr[i]!=null){
						(this.gridArr[i] as EquipGrid).clearMe();
					}
				}
			}
		}

		
	}
}