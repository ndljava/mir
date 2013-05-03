package com.leyou.ui.backpack.child {
	import com.ace.ICommon.IMenu;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.print;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.window.children.AlertWindow;
	import com.ace.ui.window.children.ConfirmWindow;
	import com.ace.ui.window.children.PopWindow;
	import com.ace.ui.window.children.WindInfo;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.manager.MenuManager;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.protocol.Cmd_Forge;
	import com.leyou.net.protocol.Cmd_Guild;
	import com.leyou.net.protocol.Cmd_Role;
	import com.leyou.net.protocol.Cmd_Trade;
	import com.leyou.net.protocol.Cmd_backPack;
	import com.leyou.net.protocol.scene.CmdScene;
	import com.leyou.ui.UiTester;
	import com.leyou.ui.cdTimer.CDTimer;
	import com.leyou.ui.storage.child.StorageGrid;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.GuildUtils;
	import com.leyou.utils.ItemUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class BackpackGrid extends GridBase implements IMenu {

		private var numLbl:Label;
		private var isCDIng:Boolean;

		public static var menuState:int=-1;

		public function BackpackGrid(id:int) {
			super(id);
		}

		override protected function init():void {
			super.init();

			this.isLock=true;
			this.gridType=ItemEnum.TYPE_GRID_BACKPACK;

			this.numLbl=new Label();
			this.numLbl.x=22;
			this.numLbl.y=24;
			this.addChild(this.numLbl);

			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
			this.iconBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/lock.png");
			this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/select.png");
		}

		override public function updataInfo(info:*):void {
			this.reset();
			this.unlocking();

			if (info == null)
				return;

			if (TClientItem(info).isJustFill) {
				return;
			}

			super.updataInfo(info);

			if (TClientItem(info).Addvalue[0] > 1) {
				this.numLbl.text=TClientItem(info).Addvalue[0];
			} else {
				this.numLbl.text="";
			}

			this.iconBmp.updateBmp("items/" + TClientItem(info).s.appr + ".png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;

			this.dataId=MyInfoManager.getInstance().backpackItems.indexOf(info);
		}

		override protected function reset():void {
			super.reset();
			this.numLbl.text="";
			this.dataId=-1;
		}

		//经过事件
		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);
			if (this.isEmpty || data == null)
				return;

			ItemTip.getInstance().show(dataId, this.gridType);
			ItemTip.getInstance().updataPs($x, $y);

			MenuManager.getInstance().visible(false);
		}

		override public function mouseDownHandler($x:Number, $y:Number):void {
			super.mouseDownHandler($x, $y);

			//仓库批量存取
			if (UIManager.getInstance().storageWnd.visible && UIManager.getInstance().storageWnd.isbatchSave) {

				MyInfoManager.getInstance().waitItemFromId=this.dataId; //从背包
				MyInfoManager.getInstance().waitItemToId=MyInfoManager.getInstance().findEmptyPs(ItemEnum.TYPE_GRID_STORAGE);
				Cmd_backPack.cm_userStorageItem(MyInfoManager.getInstance().talkNpcId, data);
				UIManager.getInstance().backPackWnd.mouseChildren=false;
				return;
			} else if (UIManager.getInstance().shopWnd.visible && UIManager.getInstance().backPackWnd.isShopBtn) { //npc 批量卖出

				if (data == null || data.s == null)
					return;

				PopupManager.showConfirm("确认卖出?", function():void {
					MyInfoManager.getInstance().waitItemFromId=this.dataId;
					UIManager.getInstance().shopWnd.sellItem(data.MakeIndex, data.s.name);
				});
				return;
			}

			MenuManager.getInstance().visible(false);

//			if (menuState == 2) {
//				if (MyInfoManager.getInstance().waitItemFromId != -1) {
//
//					var g:GridBase=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, MyInfoManager.getInstance().waitItemFromId);
//					var info1:TClientItem=g.data;
//
//					if (info1 == null || info1.s == null)
//						return;
//
//					//trace(MyInfoManager.getInstance().waitItemFromId, "====", this.gridId, this.dataId,info1.s.name,this.data.s.name);
//
//					if (this.dataId != -1) {
//						//相等叠加-----------不相等替换
//						if (info1.s.id != this.data.s.id) {
//							g.updataInfo(this.data);
//							this.updataInfo(info1);
//
//							g.enable=true;
//						} else if (info1.s.stackNum > 1) {
//							MyInfoManager.getInstance().waitItemFromId=g.dataId;
//							Cmd_backPack.cm_bothItem(info1.MakeIndex, this.data.MakeIndex);
//							return;
//						}
//					} else {
//						this.updataInfo(info1);
//					}
//
//					MyInfoManager.getInstance().resetWaitItem();
//
//				} else
//					MyInfoManager.getInstance().waitItemFromId=this.gridId;
//
//					//trace(MyInfoManager.getInstance().waitItemFromId, "====11111",this.data.s.name);
//			} //else
				//MyInfoManager.getInstance().resetWaitItem();
		}

		public function onMenuClick(index:int):void {
			menuState=index;
			switch (index) {
				case 1: //使用
					if (data != null) {
						MyInfoManager.getInstance().waitItemUse=this.dataId;
						onUse();
					}
					break;
				case 2: //移除
					this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
					break;
				case 3: //拆分
					UIManager.getInstance().backPackSplitWnd.showPanel(data);
					break;
				case 4: //展示

					break;
				case 5: //丢弃
					UIManager.getInstance().backPackDropWnd.showPanel(data);
					break;
			}
		}

		//鼠标离开
		override public function mouseOutHandler():void {
			super.mouseOutHandler();
			ItemTip.getInstance().hide();

			if (DragManager.getInstance().grid != null && this.dataId != -1 && this.data.s != null) {
				UIManager.getInstance().storageWnd.showDragGlowFilter(true);
				if (ItemUtil.EQUIP_TYPE.concat(ItemUtil.ITEM_TOOL).indexOf(this.data.s.type) > -1)
					UIManager.getInstance().toolsWnd.showDragGlowFilter(true);
			}
		}

		public function set numLable(i:int):void {
			this.numLbl.text=i + "";
		}

		public function get numLable():int {
			return int(this.numLbl.text);
		}

		override public function get data():* {
			if (this.dataId == -1)
				return null;
			return MyInfoManager.getInstance().backpackItems[this.dataId];
		}

		override public function dropHandler():void {
			if (this.data == null || this.data.s == null)
				return;

			UIManager.getInstance().backPackDropWnd.showPanel(data);
		}

		override public function switchHandler(fromItem:GridBase):void {
			UIManager.getInstance().storageWnd.showDragGlowFilter(false);
			UIManager.getInstance().toolsWnd.showDragGlowFilter(false);

			MyInfoManager.getInstance().resetWaitItem();

			if (this.gridType == fromItem.gridType) {

				var g:GridBase=fromItem;

//				if (menuState == 2 && MyInfoManager.getInstance().waitItemFromId != -1) {
//					g=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, MyInfoManager.getInstance().waitItemFromId);
//				} else
//					g=fromItem;

				var info1:TClientItem=g.data;

				if (info1 == null || info1.s == null)
					return;

				//物品叠加
				if (this.dataId != -1) {

					if (info1.s.id != this.data.s.id || info1.s.stackNum <= 1) {
						g.updataInfo(this.data);
						this.updataInfo(info1);

						var gid:int=g.gridId;
						g.gridId=this.gridId;
						this.gridId=gid;

						g.enable=true;

						//super.switchHandler(fromItem);
						//强制刷新
						MyInfoManager.getInstance().resetWaitItem();

					} else {
						MyInfoManager.getInstance().waitItemFromId=fromItem.dataId;
						Cmd_backPack.cm_bothItem(info1.MakeIndex, this.data.MakeIndex);
						return;
					}
				} else {
					this.updataInfo(info1);
					g.updataInfo(new TClientItem(true));
				}

			} else {
				//如果是是从仓库来的，
				if (fromItem.gridType == ItemEnum.TYPE_GRID_STORAGE) {

					if (!UIManager.getInstance().backPackWnd.matchToDrag(StorageGrid(fromItem).data))
						return;

					MyInfoManager.getInstance().waitItemFromId=fromItem.dataId; //从仓库
					MyInfoManager.getInstance().waitItemToId=this.initId; //到背包
					Cmd_backPack.cm_userTakeBackStorageItem(MyInfoManager.getInstance().talkNpcId, MyInfoManager.getInstance().backpackItems[fromItem.dataId]);
				}

				//如果是是玩家交易拖回，
				if (fromItem.gridType == ItemEnum.TYPE_GRID_TRADE) {
					MyInfoManager.getInstance().waitItemFromId=fromItem.dataId; //从仓库
					MyInfoManager.getInstance().waitItemToId=this.dataId; //到背包

					var info:TClientItem=MyInfoManager.getInstance().backpackItems[fromItem.dataId] as TClientItem;
					if (info == null)
						return;

					Cmd_Trade.cm_dealDelItem(info);
				}

				//工会
				if (fromItem.gridType == ItemEnum.TYPE_GRID_GUILD) {
					MyInfoManager.getInstance().waitItemFromId=fromItem.dataId; //从仓库
					MyInfoManager.getInstance().waitItemToId=this.dataId; //到背包

					var tc:TClientItem=UIManager.getInstance().guildWnd.storeArr[5][UIManager.getInstance().guildWnd.currentStorePage][fromItem.dataId] as TClientItem;
					if (tc == null)
						return;

					var arr:Array=GuildUtils.getMemberByName(UIManager.getInstance().guildWnd.memberArr, MyInfoManager.getInstance().name);
					if (arr == null)
						return;

					Cmd_Guild.cm_takeGuildItem(tc.MakeIndex, (arr[0] == "1" ? 1 : 0))
				}

				//角色
				if (fromItem.gridType == ItemEnum.TYPE_GRID_EQUIP) {
					var equip:TClientItem;
					//多个物品id当到一个格子的问题
					if (fromItem.dataId == 2 || fromItem.dataId == 0 || fromItem.dataId == 4) {
						equip=MyInfoManager.getInstance().equips[fromItem.dataId];
						if (equip == null || equip.s == null) {

							var i:int;
							if (fromItem.dataId == 2)
								i=14;
							else if (fromItem.dataId == 4)
								i=13;
							else if (fromItem.dataId == 0)
								i=15;

							equip=MyInfoManager.getInstance().equips[i];
							if (equip == null || equip.s == null)
								return;
							else {
								UIManager.getInstance().roleWnd.takeOffEquipId=i;
								Cmd_Role.cm_takeOffItem(equip.MakeIndex, fromItem.dataId, equip.s.name);
							}

						} else {
							UIManager.getInstance().roleWnd.takeOffEquipId=fromItem.dataId;
							Cmd_Role.cm_takeOffItem(equip.MakeIndex, fromItem.dataId, equip.s.name);
						}
					} else {
						equip=MyInfoManager.getInstance().equips[fromItem.dataId];
						if (equip == null || equip.s == null)
							return;

						UIManager.getInstance().roleWnd.takeOffEquipId=fromItem.dataId;
						Cmd_Role.cm_takeOffItem(equip.MakeIndex, fromItem.dataId, equip.s.name);
					}
				}

				//装备合成
				if (fromItem.gridType == ItemEnum.TYPE_GRID_FORGE) {
					var tc1:TClientItem=fromItem.data;
					if (tc1 == null || tc1.s == null)
						return;

					Cmd_Forge.cm_delfIfitem(tc1.MakeIndex);
					MyInfoManager.getInstance().addItem(ItemEnum.TYPE_GRID_BACKPACK,tc1);
					this.updataInfo(tc1);
					UIManager.getInstance().forgeWnd.dropOneGrid(tc1.MakeIndex);
				}
			}

			if (menuState == 2) {
				menuState=-1;
				MyInfoManager.getInstance().waitItemFromId=-1
				return;
			}
		}

		override public function mouseUpHandler($x:Number, $y:Number):void {

			if (data == null || data.s == null)
				return;

			var menuArr:Vector.<MenuInfo>=new Vector.<MenuInfo>;

			if (ItemUtil.EQUIP_TYPE.indexOf(data.s.type) > -1)
				menuArr.push(new MenuInfo("装备", 1));
			else
				menuArr.push(new MenuInfo("使用", 1));

			menuArr.push(new MenuInfo("移动", 2));

			if (data.Addvalue[0] > 1)
				menuArr.push(new MenuInfo("拆分", 3));

			menuArr.push(new MenuInfo("展示", 4));

			if (data.boBind < 1)
				menuArr.push(new MenuInfo("丢弃", 5));

			MenuManager.getInstance().show(menuArr, this, new Point($x, $y));
//			MyInfoManager.getInstance().resetWaitItem();

		}

		override public function set enable(value:Boolean):void {
			super.enable=value;
			if (!value) {
				this.iconBmp.filters=[FilterUtil.enablefilter];
			} else {
				this.iconBmp.filters=[];
			}
		}

		override public function mouseMoveHandler($x:Number, $y:Number):void {
			super.mouseMoveHandler($x, $y);
			if (this.isEmpty)
				return;
			ItemTip.getInstance().updataPs($x, $y);
		}

		override public function doubleClickHandler():void {
			super.doubleClickHandler();
			this.onUse();
		}

		private var tt:Array=[5, 6, 10, 11, 15, 16, 19, 20, 21, 22, 23, 24, 26, 30, 25, 52, 62, 53, 63, 54, 64, 42, 41, 29, 7];

		public function onUse():void {
			var info:TClientItem=data;
			if (info.s.name == "千里传音卷轴") {
//				AlertWindow.showWin("请在聊天中的 世界频道 使用千里传音 ");
				UIManager.getInstance().noticeMidDownUproll.setNoticeStr("请在聊天中的 世界频道 使用千里传音卷轴 ", SystemNoticeEnum.IMG_WRONG);
				return;
			}

			if (info.s.type == 4) { //技能书
				if (MyInfoManager.getInstance().level < info.s.durableMax) {
					UIManager.getInstance().noticeMidDownUproll.setNoticeStr("您的等级不足 " + info.s.durableMax + "，不能使用此书", SystemNoticeEnum.IMG_PROMPT);
					return;
				}
			}

			MyInfoManager.getInstance().waitItemUse=this.dataId;

			//装备类型道具
			if (ItemUtil.EQUIP_TYPE.concat(tt).indexOf(info.s.type) != -1) {
				print("使用物品：" + info.MakeIndex);
				var pos:int=this.checkPos(ItemUtil.getTakeOnPosition(info.s.type));
				CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_TAKEONITEM, info.MakeIndex, pos, 0, 0, info.s.name);
				return;
			}

			//药品类
			switch (info.s.type) {
				case 0:
				case 1:
				case 2:
				case 3:
				case 4:
					CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_EAT, info.MakeIndex, 0, 0, 0, info.s.name);
					break;
				case 31: //特殊物品
					//UIManager.getInstance().backPackWnd.useItem31=31;
					CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_EAT, info.MakeIndex, 0, 0, 0, info.s.name);
					break;
				default:
					CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_EAT, info.MakeIndex, 0, 0, 0, info.s.name);
					break;
			}
		}

		private function cdTimer(time:int=5000):void {
			if (this.isCDIng == true)
				return;

			var cd:CDTimer=new CDTimer(this.width, this.height, time);
			cd.cdEndFun=this.cdEnd;
			this.addChild(cd);
			this.mouseEnabled=false;
			cd.start();
			this.isCDIng=true;
		}

		private function cdEnd():void {
			this.isCDIng=false;
			this.mouseEnabled=true;
		}

		public function startCD():void {
			this.cdTimer();
		}

		//如果是手镯 或者项链 计算其位置
		private function checkPos(pos:int):int {
			var p:int;
			if (pos == ItemEnum.U_ARMRINGL || pos == ItemEnum.U_ARMRINGR) {
				if (UIManager.getInstance().roleWnd.dragWrisPos <= 0)
					p=UIManager.getInstance().roleWnd.checkWrisRingPos(pos);
				else
					p=UIManager.getInstance().roleWnd.dragWrisPos;
				UIManager.getInstance().roleWnd.waitPutPos=p;
			} else if (pos == ItemEnum.U_RINGL || pos == ItemEnum.U_RINGR) {
				if (UIManager.getInstance().roleWnd.dragRingPos > 0)
					p=UIManager.getInstance().roleWnd.dragRingPos;
				else
					p=UIManager.getInstance().roleWnd.checkWrisRingPos(pos);
				UIManager.getInstance().roleWnd.waitPutPos=p;
			} else
				p=pos;
			return p;
		}
	}
}
