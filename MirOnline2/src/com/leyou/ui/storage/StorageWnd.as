package com.leyou.ui.storage {
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.greensock.TweenMax;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.NetEnum;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.net.protocol.Cmd_backPack;
	import com.leyou.net.protocol.scene.CmdScene;
	import com.leyou.ui.storage.child.StorageGrid;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.ItemUtil;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class StorageWnd extends AutoWindow {

		private var gridList:ScrollPane;
		private var neatenBtn:NormalButton;
		private var getMoneyBtn:NormalButton;
		private var storageBtn:NormalButton;
		private var batchSaveBtn:NormalButton;
		private var bagCapacity:Label;
		private var batchSaveLbl:Label;
		private var moneyLbl:Label;
		private var storageTabBar:TabBar;
		private var glowBg:ScaleBitmap;

		/**
		 * 是否批量存取
		 */
		public var isbatchSave:Boolean=false;

		private var tw:TweenMax;

		public function StorageWnd() {
			super(LibManager.getInstance().getXML("config/ui/StorageWnd.xml"));
			this.init();
			this.initData(MyInfoManager.getInstance().backpackItems);
		}

		private function init():void {
			//根据数据显示格子，格子用索引保存
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.neatenBtn=this.getUIbyID("neatenBtn") as NormalButton;
			this.getMoneyBtn=this.getUIbyID("getMoneyBtn") as NormalButton;
			this.storageBtn=this.getUIbyID("storageBtn") as NormalButton;
			this.batchSaveBtn=this.getUIbyID("batchSaveBtn") as NormalButton;
			this.bagCapacity=this.getUIbyID("bagCapacity") as Label;
			this.batchSaveLbl=this.getUIbyID("batchSaveLbl") as Label;
			this.moneyLbl=this.getUIbyID("moneyLbl") as Label;
			this.storageTabBar=this.getUIbyID("storageTabBar") as TabBar;
			this.glowBg=this.getUIbyID("glowBg") as ScaleBitmap;

			this.neatenBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.getMoneyBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.storageBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.batchSaveBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.storageTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeTab);

			var g:StorageGrid;
			for (var i:int=ItemEnum.BACKPACK_GRID_TOTAL; i < (ItemEnum.STORAGE_GRIDE_TOTAL + ItemEnum.BACKPACK_GRID_TOTAL); i++) {
				g=new StorageGrid(i);
				g.x=((i - ItemEnum.BACKPACK_GRID_TOTAL) % ItemEnum.GRID_HORIZONTAL) * (ItemEnum.ITEM_BG_WIDTH + ItemEnum.GRID_SPACE);
				g.y=int((i - ItemEnum.BACKPACK_GRID_TOTAL) / ItemEnum.GRID_HORIZONTAL) * ItemEnum.ITEM_BG_HEIGHT;
				DragManager.getInstance().addGrid(g);
				this.gridList.addToPane(g);
			}
		}

		//填充数据
		public function initData(arr:Vector.<TClientItem>):void {
			var g:GridBase;
			for (var i:int=ItemEnum.BACKPACK_GRID_TOTAL; i < (ItemEnum.BACKPACK_GRID_TOTAL + ItemEnum.STORAGE_GRIDE_TOTAL); i++) {
				g=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_STORAGE, i);

				if (this.storageTabBar.turnOnIndex > 0 && (i >= arr.length || arr[i] == null || arr[i].s == null))
					g.visible=false;
				else
					g.visible=true;

				if (i < (ItemEnum.STORAGE_GRIDE_OPEN + ItemEnum.BACKPACK_GRID_TOTAL))
					g.updataInfo(arr[i]);
			}

			this.mouseChildren=true;
		}

		public function refresh():void {
			this.updateTab();
		}

		private function updateTab():void {
			//DragManager.getInstance().resetGrid(ItemEnum.TYPE_GRID_STORAGE);

			switch (this.storageTabBar.turnOnIndex) {
				case -1:
					this.initData(MyInfoManager.getInstance().backpackItems);
					break;
				case 0:
					this.initData(MyInfoManager.getInstance().backpackItems);
					break;
				case 1:
					changeTab(ItemUtil.EQUIP_TYPE);
					break;
				case 2:
					changeTab([0, 1, 2, 3]);
					break;
				case 3:
					changeTab(ItemUtil.EQUIP_TYPE.concat([0, 1, 2, 3]), true);
					break;
			}

			var len:int=MyInfoManager.getInstance().getBagNum(ItemEnum.TYPE_GRID_STORAGE);
			this.bagCapacity.text=len + "/70";
			this.moneyLbl.text="0";
		}

		private function onChangeTab(e:Event):void {
			updateTab();
		}

		private function changeTab(type:Array, reverse:Boolean=false):void {
			var arr:Vector.<TClientItem>=MyInfoManager.getInstance().backpackItems;

			var tmp2:Vector.<TClientItem>=arr.filter(function(item:TClientItem, i:int, arr:Vector.<TClientItem>):Boolean {
				if (item.s != null && i >= ItemEnum.BACKPACK_GRID_TOTAL) {
					for (var i:int=0; i < type.length; i++) {
						if (reverse) {
							if (item.s.type == type[i])
								return false;
						} else {
							if (item.s.type == type[i])
								return true;
						}
					}

					if (reverse)
						return true;
				}

				return false;
			});

			var tmp:Vector.<TClientItem>=new Vector.<TClientItem>();
			tmp.length=ItemEnum.BACKPACK_GRID_TOTAL;
			tmp=tmp.concat(tmp2);
			tmp.length=ItemEnum.STORAGE_GRIDE_OPEN + ItemEnum.BACKPACK_GRID_TOTAL;

			this.initData(tmp);
		}

		/**
		 *显示拖拽光圈
		 *
		 */
		public function showDragGlowFilter(v:Boolean):void {
			if (!this.visible)
				return;

			if (v)
				tw=FilterUtil.showGlowFilter(this.glowBg);
			else {
				tw.kill();
				this.glowBg.filters=[];
			}

			UIManager.getInstance().toolsWnd.showDragGlowFilter(v);
		}

		/**
		 * @param e
		 */
		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "neatenBtn":
//					storeRequestShow=true;
//					CmdScene.cm_sendDefaultMsg(MirProtocol.CM_ADDSTARITEM, 0, NetEnum.NPC_STORAGE, 0, 0);
					Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, TaskEnum.CMD_GETBACK);
					this.mouseChildren=false;
					break;
				case "getMoneyBtn":

					break;
				case "storageBtn":

					break;
				case "batchSaveBtn":
					UIManager.getInstance().backPackWnd.show();
					isbatchSave=!isbatchSave;
					if (isbatchSave)
						this.batchSaveBtn.text="取消批量存取";
					else
						this.batchSaveBtn.text="批量存取";
					break;
			}
		}

		/**
		 * 匹配拖拽
		 * @return
		 *
		 */
		public function matchToDrag(tc:TClientItem):Boolean {
			switch (this.storageTabBar.turnOnIndex) {
				case -1:
					return true;
				case 0:
					return true;
				case 1:
					return (ItemUtil.EQUIP_TYPE.indexOf(tc.s.type) == -1 ? false : true);
				case 2:
					return ([0, 1, 2, 3].indexOf(tc.s.type) == -1 ? false : true);
				case 3:
					return (ItemUtil.EQUIP_TYPE.concat([0, 1, 2, 3]).indexOf(tc.s.type) == -1 ? false : true);
			}

			return false;
		}

		//更新一个格子
		public function updatOneGrid(id:int):void {
			var info:TClientItem=MyInfoManager.getInstance().backpackItems[id];
			var g:GridBase;
			g=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_STORAGE, id);
			g.updataInfo(info); //有数据则填充，无数据则开锁

			this.updateTab();
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {

			Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, TaskEnum.CMD_GETBACK);
			this.setStopPrg(false);
			super.show(toTop, toCenter);
		}
	}
}
