package com.leyou.ui.shop.child {
	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.lable.Label;
	import com.ace.ui.window.children.ConfirmWindow;
	import com.ace.ui.window.children.PopWindow;
	import com.ace.ui.window.children.WindInfo;
	import com.leyou.data.net.shop.TStdItem;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.backpack.child.ItemTip;

	import flash.geom.Rectangle;

	public class GridShop extends GridBase {
		private var nameLbl:Label;
		private var moneyKindLbl:Label;
		private var priceLbl:Label;
		private var _id:int;

		public function GridShop() {
			super(0);
		}

		override protected function init():void {
			super.init();
			this.isLock=false;
			this.canMove=false;
			this.gridType=ItemEnum.TYPE_GRID_SHOP;

			this.iconBmp.x=(40 - 28) >> 1;
			this.iconBmp.y=(40 - 30) >> 1;

			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");

			var select:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg("ui/other/textinput_focus.png"));
			select.scale9Grid=new Rectangle(2, 2, 200, 20);
			select.x=-3;
			select.y=-3;
			select.setSize(165, 50);
			this.selectBmp.bitmapData=select.bitmapData;

			var bg:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.STYLE_NAME_DIC["PanelBgOut"]));
			bg.scale9Grid=FontEnum.RECTANGLE_DIC["PanelBgOut"];
			bg.setSize(165, 50);
			bg.x=-3;
			bg.y=-3;
			this.addChildAt(bg, 0);

			this.nameLbl=new Label();
			this.nameLbl.x=42 - 3;
			this.nameLbl.y=3 - 3;
			this.addChild(this.nameLbl);

			this.moneyKindLbl=new Label();
			this.moneyKindLbl.x=42 - 3;
			this.moneyKindLbl.y=24 - 3;
			this.addChild(this.moneyKindLbl);

			this.priceLbl=new Label();
			this.priceLbl.x=100 - 3 - 20;
			this.priceLbl.y=24 - 3;
			this.addChild(this.priceLbl);
		}

		override public function updataInfo(info:*):void {
			super.updataInfo(info);
			this.canMove=false;
			if (info != null)
				this.iconBmp.updateBmp("items/" + info.Looks + ".png");
			this.nameLbl.text=info.Name;
			this.moneyKindLbl.text="金币" + ":";
			this.priceLbl.text=info.Price.toString();
		}

		//经过事件
		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);
			if (this.isEmpty)
				return;
			ItemTip.getInstance().show(this._id, this.gridType);
			ItemTip.getInstance().updataPs($x, $y);
		}

		//鼠标离开
		override public function mouseOutHandler():void {
			super.mouseOutHandler();
			ItemTip.getInstance().hide();
		}

		override public function switchHandler(fromItem:GridBase):void {
			super.switchHandler(fromItem);

			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
				if (fromItem) {
					var tc:TClientItem=MyInfoManager.getInstance().backpackItems[fromItem.dataId] as TClientItem;
					if (tc == null || tc.s == null)
						return;

					var win:WindInfo=WindInfo.getAlertInfo("确认卖出?");
					win.okFun=okFun;
					win.showClose=true;
					PopWindow.showWnd(UIEnum.WND_TYPE_ALERT, win, "sell_alert");
//					WindInfo.getConfirmInfo("确认卖出?", function():void {
//						MyInfoManager.getInstance().waitItemFromId=fromItem.dataId;
//						//协议
//						UIManager.getInstance().shopWnd.sellItem(tc.MakeIndex, tc.s.name);
//					});

				}
			} else {
			}
			function okFun():void {
				MyInfoManager.getInstance().waitItemFromId=fromItem.dataId;
				//协议
				UIManager.getInstance().shopWnd.sellItem(tc.MakeIndex, tc.s.name);
			}
		}

		override public function doubleClickHandler():void {
			UIManager.getInstance().shopWnd.renderDoubleClick(this._id);
		}

		override public function mouseUpHandler($x:Number, $y:Number):void {
			UIManager.getInstance().shopWnd.renderClick(this.id);
		}

		public function set id(i:int):void {
			this._id=i;
		}

		public function get id():int {
			return this._id;
		}

	}
}