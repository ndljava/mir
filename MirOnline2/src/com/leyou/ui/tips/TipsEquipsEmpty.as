package com.leyou.ui.tips {
	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.TipsEnum;
	import com.leyou.utils.TipsUtil;
	
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TipsEquipsEmpty extends Sprite {
		private var bg:ScaleBitmap;
		private var lbl:Label;

		public function TipsEquipsEmpty() {
			this.init();
		}

		private function init():void {
			this.bg=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.STYLE_NAME_DIC["PanelBgOut"]));
			this.bg.scale9Grid=FontEnum.RECTANGLE_DIC["PanelBgOut"];
			this.bg.alpha=.6;
			this.addChildAt(this.bg, 0);
			this.lbl=new Label();
			this.lbl.autoSize=TextFieldAutoSize.LEFT;
			this.addChild(this.lbl);
			
			var format:TextFormat=new TextFormat();
			format.size=12;
			this.lbl.defaultTextFormat=format;
		}

		private function updateInfo(str:String):void {
			//			this.lbl.htmlText=str;
			this.lbl.htmlText=TipsUtil.getColorStr(str, TipsEnum.COLOR_YELLOW);
			this.bg.setSize(this.lbl.width, this.lbl.height);
		}

		public function equipEmptyTips(id:int):void {
			var str:String=new String();
			switch (id) {
				case ItemEnum.U_HELMET: //头盔
				case ItemEnum.U_ZHULI:
					str="此栏只能佩戴头盔";
					break;
				case ItemEnum.U_DRESS: //衣服
				case ItemEnum.U_ITEM:
					str="此栏只能佩戴衣服";
					break;
				case ItemEnum.U_ARMRINGL: //左手镯
					str="此栏只能佩戴手镯";
					break;
				case ItemEnum.U_RINGL: //左手戒指
					str="此栏只能佩戴戒指";
					break;
				case ItemEnum.U_BELT: //腰带
					str="此栏只能佩戴腰带";
					break;
				case ItemEnum.U_NECKLACE: //项链
					str="此栏只能佩戴项链";
					break;
				case ItemEnum.U_RIGHTHAND: //勋章 马牌
				case ItemEnum.U_HORSE:
					str="此栏只能佩戴马牌";
					break;
				case ItemEnum.U_ARMRINGR: //右手镯
					str="此栏只能佩戴手镯";
					break;
				case ItemEnum.U_RINGR: //右手戒指
					str="此栏只能佩戴戒指";
					break;
				case ItemEnum.U_CHARM: //宝石
					str="此栏只能佩戴宝石";
					break;
				case ItemEnum.U_BOOTS: //鞋子
					str="此栏只能佩戴鞋子";
					break;
				case ItemEnum.U_WEAPON: //武器/物品
					str="此栏只能佩戴武器";
					break;
				case ItemEnum.U_BUJUK: //护身符
					str="此栏只能佩戴护身符";
					break;
			}
			this.updateInfo(str);
		}

		public function showString(str:String):void {
			this.updateInfo(str);
		}

		public static var blackStrokeFilters:Array = [new GlowFilter(0x000000, 1, 2, 2, 8)];
		public function showBuffTips(str:String):void {
			this.lbl.htmlText=str;
			this.bg.setSize(this.lbl.width, this.lbl.height);
			this.lbl.filters=blackStrokeFilters;
		}

		/**
		 * 任务tips
		 * @param str
		 *
		 */
		public function showTaskTips(str:String):void {
			this.lbl.htmlText=TipsUtil.getColorStr(str, TipsEnum.COLOR_WHITE);
			this.bg.setSize(this.lbl.width, this.lbl.height)
		}

	}
}
