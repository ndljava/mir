package com.leyou.ui.tips {
	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.lable.Label;
	import com.leyou.data.net.market.TShopInfo;
	import com.leyou.data.net.shop.TStdItem;
	import com.leyou.data.tips.ItemTipsInfo;
	import com.leyou.enum.MarketEnum;
	import com.leyou.enum.TipsEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.tips.child.TipsGrid;
	import com.leyou.utils.TipsUtil;

	import flash.display.Sprite;
	import flash.text.TextFormat;

	public class TipsItem extends Sprite {
		private var lbl:Label;
		private var Bg:ScaleBitmap;
		private var w:Number;
		private var grid:TipsGrid;
		private var info:ItemTipsInfo;
		private var lbll:Label;

		public function TipsItem() {
			super();
			this.init();
		}

		private function init():void {
			this.info=new ItemTipsInfo();
			this.Bg=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.STYLE_NAME_DIC["PanelBgOut"]));
			this.Bg.scale9Grid=FontEnum.RECTANGLE_DIC["PanelBgOut"];
			this.Bg.alpha=.8;
			this.addChildAt(this.Bg, 0);
			this.w=182;
			this.lbl=new Label();
			this.lbl.width=this.w - 2;
			this.lbl.wordWrap=true;
			this.lbl.multiline=true;
			this.lbl.x=2;
			this.lbl.y=2;
			this.addChild(this.lbl);
			var format:TextFormat=new TextFormat();
			format.size=12;
			this.lbl.defaultTextFormat=format;
			this.grid=new TipsGrid();
			this.grid.x=141;
			this.grid.y=3;
			this.addChild(this.grid);

			this.lbll=new Label();
			this.lbll.width=60;
			this.lbll.wordWrap=true;
			this.lbll.multiline=true;
			this.lbll.x=this.w - this.lbll.width;
			this.lbll.y=this.grid.y + this.grid.height;
			this.lbll.defaultTextFormat=format;
			this.addChild(this.lbll);
		}

		private function updataInfo(info:ItemTipsInfo):void {
			var i:int;
			this.lbll.htmlText="";
			this.lbl.htmlText=TipsUtil.getColorStr(info.name, TipsEnum.COLOR_YELLOW);
			this.lbl.htmlText+=TipsUtil.getColorStr("类型：" + info.type, TipsEnum.COLOR_WHITE);
			this.lbl.htmlText+=TipsUtil.getColorStr("重量：" + info.weight, TipsEnum.COLOR_WHITE);
			if (info.numStr != "" && info.numStr != null)
				this.lbl.htmlText+=TipsUtil.getColorStr("数量：" + info.numStr, TipsEnum.COLOR_WHITE);
			if (info.limit != null) {
				for (i=0; i < info.limit.length; i++) {
					//					this.lbl.htmlText+=TipsUtil.getColorStr(info.limit[i], TipsEnum.COLOR_WHITE);
					this.lbl.htmlText+=info.limit[i];
				}
			}
			if (info.proper.length > 0) {
				for (i=0; i < info.proper.length; i++) {
					this.lbl.htmlText+=TipsUtil.getColorStr(info.proper[i], TipsEnum.COLOR_GREEN);
				}
			}

			if (info.instruct1 != "" && info.instruct1 != null)
				this.lbll.htmlText=TipsUtil.getColorStr(info.instruct1, TipsEnum.COLOR_BLUE);
//				this.lbl.htmlText+=TipsUtil.getColorStr(info.instruct1, TipsEnum.COLOR_BLUE);
			if (info.instruct2 != "" && info.instruct2 != null) {
				if (info.instruct2.indexOf("属性") != -1) {
					while (info.instruct2.indexOf("|") != -1)
						info.instruct2=info.instruct2.replace("|", "<br>");
				} else {
					while (info.instruct2.indexOf("|") != -1)
						info.instruct2=info.instruct2.replace("|", "");
				}

				this.lbl.htmlText+=TipsUtil.getColorStr(info.instruct2, TipsEnum.COLOR_DIRT);
			}
			if (info.price != "")
				this.lbl.htmlText+=info.price;
//				this.lbl.htmlText+=TipsUtil.getColorStr("售价：" + info.price, TipsEnum.COLOR_GOLD);
			if (this.lbl.height + 2 < this.lbll.y + this.lbll.height + 2)
				this.Bg.setSize(this.w + 2, this.lbll.y + this.lbll.height + 2);
			else
				this.Bg.setSize(this.w + 2, this.lbl.height + 2);
			this.grid.updataInfo(info);
		}

		/**
		 *背包中的道具
		 * @param info
		 *
		 */
		public function bagTips(info:TClientItem):void {
			this.info.clearMe();
			this.info.name=info.s.name;
			this.info.type=ItemEnum.itemNameDic[TipsUtil.getTypeName(info.s.type)];
			if (UIManager.getInstance().shopWnd.visible)
				this.info.price=info.s.price*.5 + "金币";
			else
				this.info.price="";
			this.info.weight=info.s.weight;
			this.info.instruct1=TipsUtil.getInstructionByFlag(info.s.limitCheck, TipsEnum.TYPE_TIPS_ITEM);
			this.info.instruct2=info.s.note;
			this.info.Looks=info.s.appr;
			this.info.proper=TipsUtil.getProperNum(info.s);
			if (info.s.type == 25) //毒药 和 符
				this.info.numStr=info.Dura + "/" + info.DuraMax;
			if (info.s.type == 4) { //书籍
				if (info.s.shape == MyInfoManager.getInstance().race)
					this.info.limit.push(TipsUtil.getColorStr(TipsUtil.getBookNameByRace(info.s.shape), TipsEnum.COLOR_GREEN));
				else
					this.info.limit.push(TipsUtil.getColorStr(TipsUtil.getBookNameByRace(info.s.shape), TipsEnum.COLOR_RED));
				if (info.s.durableMax <= MyInfoManager.getInstance().level)
					this.info.limit.push(TipsUtil.getColorStr("需要等级：" + info.s.durableMax, TipsEnum.COLOR_GREEN));
				else
					this.info.limit.push(TipsUtil.getColorStr("需要等级：" + info.s.durableMax, TipsEnum.COLOR_RED));
			} else {
//				this.info.limit=TipsUtil.getLimitStr(info.s.limitType, info.s.limitLevle);
			}
			this.updataInfo(this.info);
		}

		/**
		 *商店中的道具
		 * @param shopInfo
		 *
		 */
		public function shopTip(shopInfo:TStdItem):void {
			this.info.clearMe();
			this.info.name=shopInfo.Name;
			this.info.type=ItemEnum.itemNameDic[TipsUtil.getTypeName(shopInfo.StdMode)];
			this.info.limit=TipsUtil.getLimitStr(shopInfo.Need, shopInfo.NeedLevel);
			if (shopInfo.Price <= MyInfoManager.getInstance().baseInfo.gameCoin)
				this.info.price=TipsUtil.getColorStr("售价：" + shopInfo.Price + "金币", TipsEnum.COLOR_GREEN);
			else
				this.info.price=TipsUtil.getColorStr("售价：" + shopInfo.Price + "金币", TipsEnum.COLOR_RED);
			this.info.weight=shopInfo.Weight;
			this.info.instruct1=TipsUtil.getInstructionByFlag(shopInfo.LimitCheck, TipsEnum.TYPE_TIPS_ITEM);
			this.info.Looks=shopInfo.Looks;
			this.updataInfo(this.info);
		}

		/**
		 *商城中的道具
		 * @param info
		 *
		 */
		public function marketTip(info:TShopInfo, btnIdx:int):void {
			this.info.clearMe();
			this.info.name=info.stdInfo.Name;
			this.info.type=ItemEnum.itemNameDic[TipsUtil.getTypeName(info.stdInfo.StdMode)];
			this.info.limit=TipsUtil.getLimitStr(info.stdInfo.Need, info.stdInfo.NeedLevel);
			if (btnIdx != MarketEnum.BAR_FAIR) {
				if (MyInfoManager.getInstance().baseInfo.gameGold >= info.stdInfo.Price / 100)
					this.info.price=TipsUtil.getColorStr("售价：" + info.stdInfo.Price / 100 + "元宝", TipsEnum.COLOR_GREEN);
				else
					this.info.price=TipsUtil.getColorStr("售价：" + info.stdInfo.Price / 100 + "元宝", TipsEnum.COLOR_RED);
			} else {
				if (MyInfoManager.getInstance().baseInfo.gameScore >= info.stdInfo.Price / 100)
					this.info.price=TipsUtil.getColorStr("售价：" + info.stdInfo.Price / 100 + "积分", TipsEnum.COLOR_GREEN);
				else
					this.info.price=TipsUtil.getColorStr("售价：" + info.stdInfo.Price / 100 + "积分", TipsEnum.COLOR_RED);
			}
//			this.info.price=String(info.stdInfo.Price / 100) + "元宝";
			this.info.weight=info.stdInfo.Weight;
			this.info.instruct1=TipsUtil.getInstructionByFlag(info.stdInfo.LimitCheck, TipsEnum.TYPE_TIPS_ITEM);
			this.info.instruct2=info.sIntroduce;
			this.info.Looks=info.stdInfo.Looks;
			this.updataInfo(this.info);
		}
	}
}