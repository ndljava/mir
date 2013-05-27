package com.leyou.ui.backpack {
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
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.greensock.TweenMax;
	import com.leyou.manager.MenuManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.protocol.Cmd_Stall;
	import com.leyou.net.protocol.Cmd_backPack;
	import com.leyou.net.protocol.scene.CmdScene;
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.ItemUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class BackpackWnd extends AutoWindow {
		public var initOK:Boolean;

		private var gridList:ScrollPane;
		private var storageBtn:NormalButton;
		private var fastShopBtn:NormalButton;
		private var stallBtn:NormalButton;
		private var bagTabBar:TabBar;
		private var coinLbl:Label;
		private var goldLbl:Label;
		private var BagcapacityLbl:Label;
		private var weightLbl:Label;
		private var neatenBtn:NormalButton;

		private var bgGlow:ScaleBitmap;
		/**
		 * 是否快速卖出
		 */
		public var isShopBtn:Boolean=false;

		private var tw:TweenMax;

		/**
		 * 特殊物品 记录
		 */
		public var useItem31:int=-1;

		public var rightBorder:Boolean=false;

		public function BackpackWnd() {
			super(LibManager.getInstance().getXML("config/ui/BackpackWnd.xml"));
			this.init();
			this.initData(MyInfoManager.getInstance().backpackItems);
		}

		private function init():void {
			//根据数据显示格子，格子用索引保存
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.storageBtn=this.getUIbyID("storageBtn") as NormalButton;
			this.stallBtn=this.getUIbyID("stallBtn") as NormalButton;
			this.fastShopBtn=this.getUIbyID("fastShopBtn") as NormalButton;
			this.neatenBtn=this.getUIbyID("neatenBtn") as NormalButton;
			this.bagTabBar=this.getUIbyID("bagTabBar") as TabBar;
			this.coinLbl=this.getUIbyID("coinLbl") as Label;
			this.goldLbl=this.getUIbyID("goldLbl") as Label;
			this.BagcapacityLbl=this.getUIbyID("Bagcapacity") as Label;
			this.weightLbl=this.getUIbyID("weightLbl") as Label;
			this.bgGlow=this.getUIbyID("glowBg") as ScaleBitmap;

			this.storageBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.fastShopBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.stallBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.neatenBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.bagTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeIndex);

			//填充格子
			var g:BackpackGrid;
			for (var i:int=0; i < ItemEnum.BACKPACK_GRID_TOTAL; i++) {
				g=new BackpackGrid(i);
				g.x=(i % ItemEnum.GRID_HORIZONTAL) * (ItemEnum.ITEM_BG_WIDTH + ItemEnum.GRID_SPACE);
				g.y=int(i / ItemEnum.GRID_HORIZONTAL) * ItemEnum.ITEM_BG_HEIGHT;
				DragManager.getInstance().addGrid(g);
				this.gridList.addToPane(g);
			}

			this.BagcapacityLbl.text="0/60";
			this.gridList.mouseEnabled=false;
			this.fastShopBtn.setActive(false);

			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

		private function onMouseOut(e:MouseEvent):void {
			if (e.target is BackpackWnd)
				MenuManager.getInstance().visible(false);
		}

		public function setNeatenState(b:Boolean):void {
			this.neatenBtn.mouseChildren=this.neatenBtn.mouseEnabled=b;
		}

		/**
		 * tab 选项
		 * @param evt
		 */
		private function onChangeIndex(evt:Event):void {
			updateTab();
		}

		private function updateTab():void {
			switch (this.bagTabBar.turnOnIndex) {
				case -1:
					this.initData(MyInfoManager.getInstance().backpackItems);
					break;
				case 0:
					this.initData(MyInfoManager.getInstance().backpackItems);
					break;
				case 1:
					changeType(ItemUtil.EQUIP_TYPE);
					break;
				case 2:
					changeType([0, 1, 2, 3]);
					break;
				case 3:
					changeType(ItemUtil.EQUIP_TYPE.concat([0, 1, 2, 3]), true);
					break;
			}
		}

		/**
		 *显示拖拽光圈
		 *
		 */
		public function showDragGlowFilter(v:Boolean):void {
			if (!this.visible)
				return;

			if (v) {
				tw=FilterUtil.showGlowFilter(this.bgGlow);
			} else {
				if (tw)
					tw.kill();
				this.bgGlow.filters=[];
			}
		}

		/**
		 * 过滤类别
		 * @param type
		 *
		 */
		private function changeType(type:Array, reverse:Boolean=false):void {
			var arr:Vector.<TClientItem>=MyInfoManager.getInstance().backpackItems;

			var tmp2:Vector.<TClientItem>=arr.filter(function(item:TClientItem, _i:int, arr:Vector.<TClientItem>):Boolean {
				if (item.s != null && _i < ItemEnum.BACKPACK_GRID_TOTAL) {
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
			tmp=tmp.concat(tmp2);
			tmp.length=ItemEnum.BACKPACK_GRID_TOTAL + ItemEnum.STORAGE_GRIDE_TOTAL;

			this.initData(tmp);
		}

		private function onClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "storageBtn":
					UIManager.getInstance().storageWnd.show();
					UIManager.getInstance().storageWnd.x=(UIEnum.WIDTH - this.width - UIManager.getInstance().storageWnd.width) / 2;
					this.x=UIManager.getInstance().storageWnd.x + UIManager.getInstance().storageWnd.width + 5;
					break;
				case "stallBtn":
					Cmd_Stall.cm_btItem();
					break;
				case "fastShopBtn":
					isShopBtn=!isShopBtn;
					if (isShopBtn)
						NormalButton(evt.target).text="取消快速卖出";
					else
						NormalButton(evt.target).text="快速卖出";
					break;
				case "neatenBtn":
					Cmd_backPack.cm_queryBagItems();
					if (getEnableLen() > 0)
						this.mouseChildren=false;
					break;
			}
		}

		private function getEnableLen():int {

			var l:int=0;
			var g:GridBase;
			for (var i:int=0; i < ItemEnum.BACKPACK_GRID_TOTAL; i++) {
				g=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, i);
				if (g.enable && g.dataId != -1 && g.data != null && g.data.s != null)
					l++;
			}

			return l;
		}

		//填充数据
		public function initData(arr:Vector.<TClientItem>):void {

			var g:GridBase;
			for (var i:int=0; i < ItemEnum.BACKPACK_GRID_TOTAL; i++) {
				g=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, i);
				if ((this.bagTabBar.turnOnIndex > 0) && (arr[i] == null || arr[i].s == null))
					g.visible=false;
				else {
					if (i < ItemEnum.BACKPACK_GRID_OPEN)
						g.updataInfo(arr[i]); //有数据则填充，无数据则开锁
					g.visible=true;
				}
			}

			//隐藏滚动条
			//if(this.bagTabBar.turnOnIndex > 0 && arr.length>56)
			//	this.gridList.scrollTo(0);

			this.BagcapacityLbl.text=MyInfoManager.getInstance().getBagNum() + "/46";
			this.mouseChildren=true;
		}

		/**
		 * 刷新整个背包
		 *
		 */
		public function refresh():void {
			this.initOK=true;
			//DragManager.getInstance().resetGrid(ItemEnum.TYPE_GRID_BACKPACK);
			this.updateTab();
		}

		/**
		 *	更新一个格子 根据index
		 * @param id
		 */
		public function updatOneGrid(id:int, ps:int=-1):void {

			var info:TClientItem=MyInfoManager.getInstance().backpackItems[id];

			var g:GridBase;
			var i:int=ps == -1 ? getDragIdByDataID(id) : ps;

			g=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, i);

			if ((this.bagTabBar.turnOnIndex > 0) && (info == null || info.s == null))
				g.visible=false;
			else {
				g.updataInfo(info); //有数据则填充，无数据则开锁
				g.visible=true;
			}
		}

		public function updateCD(id:int):void {

			var g:GridBase;
			var i:int=getDragIdByDataID(id)
			if (i == -1)
				return;

			g=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, i);
			BackpackGrid(g).cdTimer(500);
		}

		public function updateBackType():void {
			if (this.bagTabBar.turnOnIndex > 0)
				this.updateTab();
		}

		private function getDragIdByDataID(id:int):int {
			var i:int=0;
			var g:GridBase;

			var did:int=-1;
			for (i=0; i < ItemEnum.BACKPACK_GRID_TOTAL; i++) {
				g=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, i);
				if (g.dataId == id)
					return g.initId;

				if (did == -1 && g.dataId == -1)
					did=g.initId;
			}

			return did;
		}

		/**
		 * 设置快速卖出的状态
		 * @param b
		 *
		 */
		public function setShopBtnActive(b:Boolean):void {
			this.fastShopBtn.setActive(b);
			if (!b)
				this.fastShopBtn.text="快速卖出";
		}

		/**
		 * 丢弃一个格子 根据makeindex
		 * @param id
		 *
		 */
		public function dropOneGridByMakeIndex(mIndex:int):void {
			var info:TClientItem=MyInfoManager.getInstance().getItemByMakeIndex(mIndex);
			if (info == null)
				return;

			var id:int=MyInfoManager.getInstance().backpackItems.indexOf(info);
			MyInfoManager.getInstance().resetItem(id)
			updatOneGrid(id);
			//updateTab();

			UIManager.getInstance().toolsWnd.updataShortcutGrid(info.s.id);
		}

		/**
		 * 删除一个格子
		 * @param id
		 *
		 */
		public function delOneGridByID(id:int):void {
			useItem31=-1;
			MyInfoManager.getInstance().resetItem(id)
			updatOneGrid(id);
			updateTab();
		}

		public function useItem(itemId:int):void {
			var info:TClientItem;
			for (var i:int=0; i < ItemEnum.BACKPACK_GRID_OPEN; i++) {
				info=MyInfoManager.getInstance().backpackItems[i];
				if (info.s && (info.s.id == itemId)) {
					if (info.s.name == "千里传音卷轴") {
						MyInfoManager.getInstance().waitItemUse=i;
						CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_EAT, info.MakeIndex, 0, 0, 0, info.s.name);
						return;
					}
					var ii:int=getDragIdByDataID(i);
					var g:GridBase=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, ii);
					if (g)
						(g as BackpackGrid).onUse();
					return;
				}
			}
		}

		/**
		 * 设置背包重量
		 * @param i
		 *
		 */
		public function setBagWeight(str:String):void {
			this.weightLbl.text=str + "";
		}

		public function setBagcapacityLbl(i:int):void {
			this.BagcapacityLbl.text=i + "";
		}

		/**
		 * 是否匹配拖拽
		 * @param tc
		 * @return
		 *
		 */
		public function matchToDrag(tc:TClientItem):Boolean {
			switch (this.bagTabBar.turnOnIndex) {
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

		public function updataMoney():void {
			this.coinLbl.text=ItemUtil.getSplitMoneyTextTo4(MyInfoManager.getInstance().baseInfo.gameCoin.toString()); //金币
			this.goldLbl.text=ItemUtil.getSplitMoneyTextTo4(MyInfoManager.getInstance().baseInfo.gameGold.toString()); //元宝
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			this.setStopPrg(false);
			super.show(toTop, toCenter);
			DragManager.getInstance().turnOn();

			this.x=UIEnum.WIDTH - this.width - 100;

			if (UIManager.getInstance().storageWnd.visible) {
				UIManager.getInstance().storageWnd.x=(UIEnum.WIDTH - this.width - UIManager.getInstance().storageWnd.width) / 2;
				this.x=UIManager.getInstance().storageWnd.x + UIManager.getInstance().storageWnd.width + 5;
			}
		}

		override public function set x(value:Number):void {
			super.x=value;
			//			trace(this.x + this.width, UIEnum.WIDTH)
			//			if (this.x + this.width == UIEnum.WIDTH)
			//				this.rightBorder=true;
			//			else
			//				this.rightBorder=false;
		}

		override public function hide():void {
			DragManager.getInstance().turnOff();
			super.hide();
			MenuManager.getInstance().visible(false);

			if (UIManager.getInstance().stallWnd.visible) {
				UIManager.getInstance().stallWnd.x=(UIEnum.WIDTH - UIManager.getInstance().stallWnd.width) / 2;
			}

			if (UIManager.getInstance().storageWnd.visible) {
				UIManager.getInstance().storageWnd.x=(UIEnum.WIDTH - UIManager.getInstance().storageWnd.width) / 2;
			}
		}

		public function cdTest():void {
			for (var i:int=0; i < 30; i++) {
				var g:BackpackGrid;
				g=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, i) as BackpackGrid;
					//g.startCD();
			}
		}

		public function resize():void {
			this.y=(UIEnum.HEIGHT-this.height)/2;
		}

	}
}
