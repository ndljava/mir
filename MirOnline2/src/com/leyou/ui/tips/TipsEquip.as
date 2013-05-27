package com.leyou.ui.tips {
	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.backPack.TSClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.net.market.TShopInfo;
	import com.leyou.data.net.shop.TStdItem;
	import com.leyou.data.tips.EquipTipsInfo;
	import com.leyou.enum.MarketEnum;
	import com.leyou.enum.TipsEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_backPack;
	import com.leyou.ui.tips.child.TipsGrid;
	import com.leyou.utils.TipsUtil;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;

	public class TipsEquip extends Sprite {
		private var bg:ScaleBitmap;
		private var lbl:Label;
		private var w:Number;
		private var grid:TipsGrid;
		private var info:EquipTipsInfo;
		private var lbll:Label;
		private var img:Image;

		public function TipsEquip() {
			super();
			this.init();
		}

		private function init():void {
			this.info=new EquipTipsInfo();
			this.bg=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.STYLE_NAME_DIC["PanelBgOut"]));
			this.bg.scale9Grid=FontEnum.RECTANGLE_DIC["PanelBgOut"];
			this.bg.alpha=.8;
			this.addChildAt(this.bg, 0);
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
			
			this.img=new Image();
			this.img.updateBmp("ui/other/tips_equip.png");
			this.img.visible=false;
			this.addChild(img);

		}

		private function updateInfo(info:EquipTipsInfo,f:Boolean):void {
			var i:int;
			this.lbll.htmlText="";
			this.lbl.htmlText=TipsUtil.getColorStr(info.name, TipsEnum.COLOR_YELLOW);
//			this.lbl.htmlText+=TipsUtil.getColorStr("签名：" + info.sign, TipsEnum.COLOR_YELLOW);//签名暂时屏蔽掉
			this.lbl.htmlText+=TipsUtil.getColorStr("类型：" + info.type, TipsEnum.COLOR_WHITE);
			if (info.durability != "")
				this.lbl.htmlText+=TipsUtil.getColorStr("耐久：" + info.durability, TipsEnum.COLOR_WHITE);
			this.lbl.htmlText+=TipsUtil.getColorStr("重量：" + info.wight, TipsEnum.COLOR_WHITE);
			if (info.numStr != null && info.numStr != "")
				this.lbl.htmlText+=TipsUtil.getColorStr("数量：" + info.numStr, TipsEnum.COLOR_WHITE);
			if (info.properArr != null) {
				for (i=0; i < info.properArr.length; i++) {
//					this.lbl.htmlText+=TipsUtil.getColorStr(info.properArr[i], TipsEnum.COLOR_GOLD);
					this.lbl.htmlText+=info.properArr[i];
				}
			}
			if (info.limit != null) {
				for (i=0; i < info.limit.length; i++) {
					//					this.lbl.htmlText+=TipsUtil.getColorStr(info.limit[i], TipsEnum.COLOR_WHITE);
					this.lbl.htmlText+=info.limit[i];
				}
			}
			if (info.instruction1 != "" && info.instruction1 != null)
				this.lbll.htmlText=TipsUtil.getColorStr(info.instruction1, TipsEnum.COLOR_BLUE);
//				this.lbl.htmlText+=TipsUtil.getColorStr(info.instruction1, TipsEnum.COLOR_BLUE);
			if (info.instruction2 != "" && info.instruction2 != null) {
				if (info.instruction2.indexOf("属性") != -1) {
					while (info.instruction2.indexOf("|") != -1)
						info.instruction2=info.instruction2.replace("|", "<br>");
				} else {
					while (info.instruction2.indexOf("|") != -1)
						info.instruction2=info.instruction2.replace("|", "");
				}
				this.lbl.htmlText+=TipsUtil.getColorStr(info.instruction2, TipsEnum.COLOR_DIRT);
			}
			if (info.price != "")
				this.lbl.htmlText+=info.price;
//				this.lbl.htmlText+=TipsUtil.getColorStr("售价："+info.price,TipsEnum.COLOR_GOLD);
			if (this.lbl.height + 2 < this.lbll.y + this.lbll.height + 2)
				this.bg.setSize(this.w + 2, this.lbll.y + this.lbll.height + 2);
			else
				this.bg.setSize(this.w + 2, this.lbl.height + 2);

			this.grid.updataInfo(info);
			if(f){
				this.img.x=this.w-this.img.width;
				this.img.visible=true;
			}
			else this.img.visible=false;
		}

		/**
		 *背包中的装备
		 * @param info
		 *
		 */
		public function bagTip(info:TClientItem,flag:Boolean=false):void {
			if (info == null || info.s == null)
				return;
			this.info.clearMe();
			this.info.name=info.s.name;
			this.info.durability=Math.ceil(info.Dura / 1000) + "/" + Math.ceil(info.DuraMax / 1000);
			this.info.instruction1=TipsUtil.getInstructionByFlag(info.s.limitCheck, TipsEnum.TYPE_TIPS_EQUIP);
			this.info.instruction2=info.s.note;
			this.info.limit=TipsUtil.getLimitStr(info.s.limitType, info.s.limitLevle);
			if (UIManager.getInstance().shopWnd.visible)
				this.info.price=info.s.price * .5 + "金币";
			else
				this.info.price="";
//			var obj:Object=ItemEnum.itemNameDic;
			this.info.wight=info.s.weight;
			this.info.type=ItemEnum.itemNameDic[TipsUtil.getTypeName(info.s.type,info.s.shape)];
			this.info.properArr=TipsUtil.getProperNum(info.s);
			this.info.Looks=info.s.appr;
			if (info.s.type == 25)
				this.info.numStr=info.Dura + "/" + info.DuraMax;
			this.updateInfo(this.info,flag);
		}

		/**
		 *商城中的装备
		 * @param info
		 *
		 */
		public function marketTip(info:TShopInfo, btnIdx:int,f:Boolean=false):void {
			if (info == null)
				return;
			this.info.clearMe();
			this.info.name=info.stdInfo.Name;
			this.info.instruction1=TipsUtil.getInstructionByFlag(info.stdInfo.LimitCheck, TipsEnum.TYPE_TIPS_EQUIP);
			this.info.instruction2=info.sIntroduce;
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

			this.info.type=ItemEnum.itemNameDic[TipsUtil.getTypeName(info.stdInfo.StdMode,info.stdInfo.Shape)];
			this.info.Looks=info.stdInfo.Looks;
			this.info.wight=info.stdInfo.Weight;
//			this.info.numStr=info.
			this.updateInfo(this.info,f);
		}

		/**
		 *商店中的装备
		 *
		 */
		public function shopTip(info:TStdItem,f:Boolean=false):void {
			if (info == null)
				return;
			this.info.clearMe();
			this.info.name=info.Name;
			this.info.instruction1=TipsUtil.getInstructionByFlag(info.LimitCheck, TipsEnum.TYPE_TIPS_EQUIP);
//			this.info.instruction2=info.n
			if (MyInfoManager.getInstance().baseInfo.gameCoin >= info.Price)
				this.info.price=TipsUtil.getColorStr("售价：" + info.Price+ "金币", TipsEnum.COLOR_GREEN);
			else
				this.info.price=TipsUtil.getColorStr("售价：" + info.Price + "金币", TipsEnum.COLOR_RED);
//			this.info.price=info.Price + "金币";
			this.info.type=ItemEnum.itemNameDic[TipsUtil.getTypeName(info.StdMode,info.Shape)];
			this.info.Looks=info.Looks;
			this.info.wight=info.Weight;
			var tInfo:TItemInfo=TableManager.getInstance().getItemByName(info.Name);
			this.info.properArr=TipsUtil.getProperNum(tInfo);//属性
			this.info.limit=TipsUtil.getLimitStr(info.Need,info.NeedLevel);
			this.info.durability=Math.ceil(info.DuraMax / 1000) + "/" + Math.ceil(info.DuraMax / 1000);
//			this.info.durability=Math.ceil(info.Dura / 1000) + "/" + Math.ceil(info.DuraMax / 1000);
			this.updateInfo(this.info,f);
		}

		/**
		 *其他玩家的装备
		 * @param info
		 *
		 */
		public function otherRoleTip(info:TSClientItem):void {
			var tInfo:TItemInfo=TableManager.getInstance().getItemInfo(info.wIndex - 1);
//			tInfo.source=info.
			if (tInfo == null)
				return;
			this.info.clearMe();
			tInfo=Cmd_backPack.GetItemAddValue(null, tInfo, info.btValue);
			this.info.name=tInfo.name;
			this.info.instruction1=TipsUtil.getInstructionByFlag(tInfo.limitCheck, TipsEnum.TYPE_TIPS_EQUIP);
			this.info.limit=TipsUtil.getLimitStr(tInfo.limitType, tInfo.limitLevle, false);
			this.info.type=ItemEnum.itemNameDic[TipsUtil.getTypeName(tInfo.type,tInfo.shape)];
			this.info.Looks=tInfo.appr;
			if (tInfo.type == 25) //毒药 和 符
				this.info.numStr=info.Dura + "/" + info.DuraMax;
			else
				this.info.durability=Math.ceil(info.Dura / 1000) + "/" + Math.ceil(info.DuraMax / 1000);
			this.info.properArr=TipsUtil.getProperNum(tInfo);
			this.info.wight=tInfo.weight;
			this.updateInfo(this.info,false);
		}
		
		
		
	}
}