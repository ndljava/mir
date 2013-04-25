package com.leyou.ui.shop.child {
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.data.net.shop.TStdItem;
	import com.leyou.data.shop.ShopInfo;

	public class ShopListRender extends AutoSprite {
		private var nameLbl:Label;
		private var moneyKindLbl:Label;
		private var priceLbl:Label;
		private var highLightSBM:ScaleBitmap;
		private var _id:int;
		
		private var grid:ShopGrid;

		public function ShopListRender() {
			super(LibManager.getInstance().getXML("config/ui/shop/BShopRender.xml"));
			this.init();
			this.mouseEnabled=true;
			this.mouseChildren=true;
		}

		private function init():void {
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.moneyKindLbl=this.getUIbyID("moneyKindLbl") as Label;
			this.priceLbl=this.getUIbyID("priceLbl") as Label;
			this.highLightSBM=this.getUIbyID("highLightSBM") as ScaleBitmap;
			this.highLightSBM.visible=false;
			
			this.grid=new ShopGrid();
			this.grid.x=3;
			this.grid.y=6;
			this.addChild(this.grid);
		}

		public function updataInfo(infor:TStdItem):void {
			this.nameLbl.text=infor.Name;
			this.moneyKindLbl.text="金币" + ":";
			this.priceLbl.text=infor.Price.toString();
			this.grid.updataInfo(infor);
			
		}

		public function set id(idx:int):void{
			this._id=idx;
			this.grid.dataId=this._id;
		}
		public function set highLight(flag:Boolean):void {
			this.highLightSBM.visible=flag;
		}
		
		public function get nameTxt():Label
		{
			return this.nameLbl;
		}
		
		public function get moneyKindTxt():Label
		{
			return this.moneyKindLbl;
		}
		
		public function get priceTxt():Label
		{
			return this.priceLbl;
		}

	}
}