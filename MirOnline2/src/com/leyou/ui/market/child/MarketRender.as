package com.leyou.ui.market.child {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.net.market.TShopInfo;
	import com.leyou.enum.MarketEnum;
	import com.leyou.manager.UIManager;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;

	public class MarketRender extends AutoSprite {
		private var itemNameLbl:Label;
		private var prePriceLbl:Label;
		private var nowPriceLbl:Label;
		private var previewBtn:NormalButton;
		private var givingBtn:NormalButton;
		private var buyBtn:NormalButton;
		private var item:TShopInfo;
		private var _id:int;
		private var line:Shape;

		private var grid:MarketGrid;

		public function MarketRender() {
			super(LibManager.getInstance().getXML("config/ui/market/MarketRender.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {
			this.itemNameLbl=this.getUIbyID("itemNameLbl") as Label;
			this.prePriceLbl=this.getUIbyID("prePriceLbl") as Label;
			this.nowPriceLbl=this.getUIbyID("nowPriceLbl") as Label;
			this.previewBtn=this.getUIbyID("previewBtn") as NormalButton;
			this.givingBtn=this.getUIbyID("givingBtn") as NormalButton;
			this.buyBtn=this.getUIbyID("buyBtn") as NormalButton;

			this.previewBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.givingBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.buyBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			this.grid=new MarketGrid();
			this.grid.x=15;
			this.grid.y=17;
			this.addChild(this.grid);
			this.line=new Shape();
			this.drawLine(this.prePriceLbl);
			this.line.x=this.prePriceLbl.x;
			this.line.y=this.prePriceLbl.y;
			this.addChild(this.line);
		}

		public function updataInfo(item:TShopInfo,btnIdx:int):void {
			this.item=item;
			this.itemNameLbl.text=item.stdInfo.Name;
			if(btnIdx==MarketEnum.BAR_FAIR)
				this.nowPriceLbl.text="现价:" + (item.stdInfo.Price * .01).toString() + "积分";
			else this.nowPriceLbl.text="现价:" + (item.stdInfo.Price * .01).toString() + "元宝";
			if (item.Introduce1.indexOf(":") == -1) {
				this.prePriceLbl.text="";
				this.line.visible=false;
			} else {
				item.Introduce1=item.Introduce1.replace("\r", "");
				this.prePriceLbl.text="原价:" + item.Introduce1.slice(item.Introduce1.indexOf(":") + 1, item.Introduce1.indexOf("宝") + 1);
				this.drawLine(this.prePriceLbl);
				this.line.visible=true;
			}
			this.grid.updataInfo(item.stdInfo);
		}

		private function onBtnClick(evt:MouseEvent):void {
			if (evt.currentTarget.name == "previewBtn") {
				UIManager.getInstance().fittingRoomWnd.open();

			}
			if (evt.currentTarget.name == "givingBtn") {

			}
			if (evt.currentTarget.name == "buyBtn") {
				UIManager.getInstance().marketWnd.buyItem(this.item.stdInfo.Name);
			}
		}

		public function set id(i:int):void {
			this._id=i;
			this.grid.dataId=this._id;
		}
		
		public function set previewBtnSta(sta:Boolean):void{
			this.previewBtn.mouseEnabled=sta;
			this.previewBtn.setActive(sta);
		}

		private function drawLine(lbl:Label):void {
			this.line.graphics.clear();
			this.line.graphics.lineStyle(1, 0xFFFFFF);
			this.line.graphics.moveTo(0, lbl.textHeight * .6);
			this.line.graphics.lineTo(lbl.textWidth, lbl.textHeight * .6);

		}
	}
}