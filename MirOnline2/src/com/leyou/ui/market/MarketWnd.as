package com.leyou.ui.market {
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.net.market.TShopInfo;
	import com.leyou.enum.MarketEnum;
	import com.leyou.net.protocol.Cmd_Market;
	import com.leyou.ui.market.child.MarketRender;
	
	import flash.events.MouseEvent;
	
	import flashx.textLayout.elements.BreakElement;

	public class MarketWnd extends AutoWindow {
		private var btnArr:Vector.<NormalButton>;
		private var prePageBtn:NormalButton;
		private var nextPageBtn:NormalButton;
		private var pageLbl:Label;
		private var integralLbl:Label;
		private var moneyLbl:Label;
		private var currentBtnIdx:int; //当前栏的按钮索引
		private var currentSumPage:int; //当前栏的总页数
		private var currentPage:int=0; //当前栏的当前页数
		private var renderArr:Vector.<MarketRender>;

		private var specialItem:Vector.<TShopInfo>;
		private var weaponsItem:Vector.<TShopInfo>;
		private var clothesItem:Vector.<TShopInfo>;
		private var jewelryItem:Vector.<TShopInfo>;
		private var fireworksItem:Vector.<TShopInfo>;
		private var fairItem:Vector.<TShopInfo>;
		private var hotItem:Vector.<TShopInfo>;

		private var pageFlag:int;

		public function MarketWnd() {
			super(LibManager.getInstance().getXML("config/ui/MarketWnd.xml"));
			this.init();
		}

		private function init():void {
			this.hideBG();
			this.btnArr=new Vector.<NormalButton>;
			this.renderArr=new Vector.<MarketRender>;
			this.btnArr.push(this.getUIbyID("specialBtn") as NormalButton);
			this.btnArr.push(this.getUIbyID("weaponsBtn") as NormalButton);
			this.btnArr.push(this.getUIbyID("clothesBtn") as NormalButton);
			this.btnArr.push(this.getUIbyID("jewelryBtn") as NormalButton);
			this.btnArr.push(this.getUIbyID("fireworksBtn") as NormalButton);
			this.btnArr.push(this.getUIbyID("fairBtn") as NormalButton);
			this.btnArr.push(this.getUIbyID("hotBtn") as NormalButton);

			this.prePageBtn=this.getUIbyID("prePageBtn") as NormalButton;
			this.nextPageBtn=this.getUIbyID("nextPageBtn") as NormalButton;
			this.pageLbl=this.getUIbyID("pageLbl") as Label;
			this.integralLbl=this.getUIbyID("integralLbl") as Label;
			this.moneyLbl=this.getUIbyID("moneyLbl") as Label;

			this.clsBtn.x=994;
			this.clsBtn.y=31;
			this.addToPane(this.clsBtn);

			var i:int;
			for (i=0; i < 7; i++) {
				this.btnArr[i].addEventListener(MouseEvent.CLICK, onClick);
			}
			this.prePageBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.nextPageBtn.addEventListener(MouseEvent.CLICK, onClick);

			var render:MarketRender;
			for (i=0; i < 12; i++) {
				render=new MarketRender();
				render.name=i.toString();
				if (i % 3 == 0)
					render.x=226;
				if (i % 3 == 1)
					render.x=471;
				if (i % 3 == 2)
					render.x=716;
				render.y=136 + (Math.ceil((i + 1) / 3) - 1) * MarketEnum.MARKETRENDER_HEIGHT;
				render.visible=false;
				render.id=i;
				this.renderArr.push(render);
				this.addChild(render);
			}

			this.specialItem=new Vector.<TShopInfo>;
			this.weaponsItem=new Vector.<TShopInfo>;
			this.clothesItem=new Vector.<TShopInfo>;
			this.jewelryItem=new Vector.<TShopInfo>;
			this.fireworksItem=new Vector.<TShopInfo>;
			this.fairItem=new Vector.<TShopInfo>;
			this.hotItem=new Vector.<TShopInfo>;
		}

		public function updata(itemArr:Vector.<TShopInfo>):void {
			for (var i:int=this.currentPage * MarketEnum.CLIENT_NUM_PER_PAGE; i < (this.currentPage + 1) * MarketEnum.CLIENT_NUM_PER_PAGE; i++) {
				if (i < itemArr.length) {
					this.renderArr[i % 12].visible=true;
					this.renderArr[i % 12].updataInfo(itemArr[i],this.currentBtnIdx);
					if (this.currentBtnIdx == MarketEnum.BAR_HOT || this.currentBtnIdx == MarketEnum.BAR_SPECIAL)
						this.renderArr[i % 12].previewBtnSta=false;
					else
						this.renderArr[i % 12].previewBtnSta=true;
				} else
					this.renderArr[i % 12].visible=false;
			}
		}

		private function onClick(evt:MouseEvent):void {
			switch (evt.currentTarget.name) {
				case "specialBtn":
					if (this.currentBtnIdx == MarketEnum.BAR_SPECIAL)
						return;
					this.currentBtnIdx=0;
					this.currentPage=0;
					this.updata(this.specialItem);
					this.currentSumPage=Math.ceil(this.specialItem.length / MarketEnum.CLIENT_NUM_PER_PAGE);
					this.updataPage();
					break;
				case "weaponsBtn":
					if (this.currentBtnIdx == MarketEnum.BAR_WEAPONS)
						return;
					this.currentBtnIdx=MarketEnum.BAR_WEAPONS;
					this.currentPage=0;
					if (this.weaponsItem.length == 0) {
						this.pageFlag=0;
						Cmd_Market.cm_openShop(this.currentBtnIdx, this.currentPage);
					} else {
						this.updata(this.weaponsItem);
						this.currentSumPage=Math.ceil(this.weaponsItem.length / MarketEnum.CLIENT_NUM_PER_PAGE);
						this.updataPage();
					}
					break;
				case "clothesBtn":
					if (this.currentBtnIdx == MarketEnum.BAR_CLOTHES)
						return;
					this.currentBtnIdx=MarketEnum.BAR_CLOTHES;
					this.currentPage=0;
					if (this.clothesItem.length == 0) {
						this.pageFlag=0;
						Cmd_Market.cm_openShop(this.currentBtnIdx, this.currentPage);
					} else {
						this.updata(this.clothesItem);
						this.currentSumPage=Math.ceil(this.clothesItem.length / MarketEnum.CLIENT_NUM_PER_PAGE);
						this.updataPage();
					}
					break;
				case "jewelryBtn":
					if (this.currentBtnIdx == MarketEnum.BAR_JEWELRY)
						return;
					this.currentBtnIdx=MarketEnum.BAR_JEWELRY;
					this.currentPage=0;
					if (this.jewelryItem.length == 0) {
						this.pageFlag=0;
						Cmd_Market.cm_openShop(this.currentBtnIdx, this.currentPage);
					} else {
						this.updata(this.jewelryItem);
						this.currentSumPage=Math.ceil(this.jewelryItem.length / MarketEnum.CLIENT_NUM_PER_PAGE);
						this.updataPage();
					}
					break;
				case "fireworksBtn":
					if (this.currentBtnIdx == MarketEnum.BAR_FIREWORK)
						return;
					this.currentBtnIdx=MarketEnum.BAR_FIREWORK;
					this.currentPage=0;
					if (this.fireworksItem.length == 0) {
						this.pageFlag=0;
						this.updata(this.fireworksItem);
						Cmd_Market.cm_openShop(this.currentBtnIdx, this.currentPage);
					} else {
						this.updata(this.fireworksItem);
						this.currentSumPage=Math.ceil(this.fireworksItem.length / MarketEnum.CLIENT_NUM_PER_PAGE);
						this.updataPage();
					}
					break;
				case "fairBtn":
					if (this.currentBtnIdx == MarketEnum.BAR_FAIR)
						return;
					this.currentBtnIdx=MarketEnum.BAR_FAIR;
					this.currentPage=0;
					if (this.fairItem.length == 0) {
						this.pageFlag=0;
						Cmd_Market.cm_openShop(this.currentBtnIdx, this.currentPage);
					} else {
						this.updata(this.fairItem);
						this.currentSumPage=Math.ceil(this.fairItem.length / MarketEnum.CLIENT_NUM_PER_PAGE);
						this.updataPage();
					}
					break;
				case "hotBtn":
					this.currentBtnIdx=MarketEnum.BAR_HOT;
					this.currentPage=0;
					this.updata(this.hotItem);
					this.currentSumPage=Math.ceil(this.hotItem.length / MarketEnum.CLIENT_NUM_PER_PAGE);
					this.updataPage();
					break;
				case "prePageBtn":
					if (this.currentPage <= 0)
						return;
					this.currentPage--;
					this.refreshPage();
					break;
				case "nextPageBtn":
					if (this.currentPage + 1 >= this.currentSumPage)
						return;
					this.currentPage++;
					this.refreshPage();
					break;
			}
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			super.show(toTop, toCenter);
			if (this.hotItem.length == 0) {
				this.currentBtnIdx=MarketEnum.BAR_HOT;
				this.currentPage=0;
				Cmd_Market.cm_openShop(MarketEnum.BAR_SPECIAL, this.currentPage);
			}
		}

		public function hideBG():void {
			this.bg.visible=this.statusBg.visible=false;
		}

		/**
		 *购买物品
		 * @param name
		 *
		 */
		public function buyItem(name:String):void {
			if (this.currentBtnIdx != MarketEnum.BAR_HOT) {
				Cmd_Market.cm_buyShopItem(this.currentBtnIdx, name);
			}
			if (this.currentBtnIdx == MarketEnum.BAR_HOT) {
				Cmd_Market.cm_buyShopItem(MarketEnum.BAR_SPECIAL, name);
			}
		}

		/**
		 *更新元宝数量
		 *
		 */
		public function updataGold():void {
			this.moneyLbl.text=MyInfoManager.getInstance().baseInfo.gameGold.toString();
			this.updateIntegration();
		}

		/**
		 *更新积分数量 
		 * 
		 */		
		public function updateIntegration():void{
			//暂无
			this.integralLbl.text=MyInfoManager.getInstance().baseInfo.gameScore.toString();
		}
		/**
		 *添加商品
		 * @param itemArr
		 * @param sumPage
		 *
		 */
		public function addItem(itemArr:Vector.<TShopInfo>, sumPage:int):void {
			switch (currentBtnIdx) {
				case MarketEnum.BAR_HOT:
					this.specialItem=this.specialItem.concat(itemArr);
					this.pageFlag++;
					if (this.pageFlag < sumPage) {
						Cmd_Market.cm_openShop(MarketEnum.BAR_SPECIAL, this.pageFlag);
					}
					break;
				case MarketEnum.BAR_CLOTHES:
					this.clothesItem=this.clothesItem.concat(itemArr);
					this.updata(this.clothesItem);
					this.pageFlag++;
					if (this.pageFlag < sumPage) {
						this.updata(this.clothesItem);
						this.currentSumPage=1;
						this.updataPage();
						Cmd_Market.cm_openShop(MarketEnum.BAR_CLOTHES, this.pageFlag);
					} else {
						this.currentSumPage=Math.ceil(this.clothesItem.length / MarketEnum.CLIENT_NUM_PER_PAGE);
						this.updataPage();
						this.updata(this.clothesItem);
					}
					break;
				case MarketEnum.BAR_FAIR:
					this.fairItem=this.fairItem.concat(itemArr);
					this.pageFlag++;
					if (this.pageFlag < sumPage) {
						this.updata(this.fairItem);
						this.currentSumPage=1;
						this.updataPage();
						Cmd_Market.cm_openShop(MarketEnum.BAR_FAIR, this.pageFlag);
					} else {
						this.currentSumPage=Math.ceil(this.fairItem.length / MarketEnum.CLIENT_NUM_PER_PAGE);
						this.updataPage();
						this.updata(this.fairItem);
					}
					break;
				case MarketEnum.BAR_FIREWORK:
					this.fireworksItem=this.fireworksItem.concat(itemArr);
					this.pageFlag++;
					if (this.pageFlag < sumPage) {
						this.updata(this.fireworksItem);
						this.currentSumPage=1;
						this.updataPage();
						Cmd_Market.cm_openShop(MarketEnum.BAR_FIREWORK, this.pageFlag);
					} else {
						this.currentSumPage=Math.ceil(this.fireworksItem.length / MarketEnum.CLIENT_NUM_PER_PAGE);
						this.updataPage();
						this.updata(this.fireworksItem);
					}
					break;
				case MarketEnum.BAR_JEWELRY:
					this.jewelryItem=this.jewelryItem.concat(itemArr);
					this.pageFlag++;
					if (this.pageFlag < sumPage) {
						this.updata(this.jewelryItem);
						this.currentSumPage=1;
						this.updataPage();
						Cmd_Market.cm_openShop(MarketEnum.BAR_JEWELRY, this.pageFlag);
					} else {
						this.currentSumPage=Math.ceil(this.jewelryItem.length / MarketEnum.CLIENT_NUM_PER_PAGE);
						this.updataPage();
						this.updata(this.jewelryItem);
					}
					break;
				case MarketEnum.BAR_WEAPONS:
					this.weaponsItem=this.weaponsItem.concat(itemArr);
					this.pageFlag++;
					if (this.pageFlag < sumPage) {
						this.updata(this.weaponsItem);
						this.currentSumPage=1;
						this.updataPage();
						Cmd_Market.cm_openShop(MarketEnum.BAR_WEAPONS, this.pageFlag);
					} else {
						this.currentSumPage=Math.ceil(this.weaponsItem.length / MarketEnum.CLIENT_NUM_PER_PAGE);
						this.updataPage();
						this.updata(this.weaponsItem);
					}
					break;
			}
		}

		//更新页码显示
		private function updataPage():void {
			this.pageLbl.text=this.currentPage + 1 + "/" + this.currentSumPage;
		}

		/**
		 *添加热卖商品
		 * @param itemArr
		 *
		 */
		public function addHotItem(itemArr:Vector.<TShopInfo>):void {
			if (this.hotItem.length > 0)
				return;
			this.hotItem=itemArr;
			if (this.currentBtnIdx == MarketEnum.BAR_HOT) {
				this.updata(this.hotItem);
				this.currentSumPage=Math.ceil(this.hotItem.length / MarketEnum.CLIENT_NUM_PER_PAGE);
				this.updataPage();
			}
		}

		//翻页
		private function refreshPage():void {
			var item:Vector.<TShopInfo>;
			switch (this.currentBtnIdx) {
				case MarketEnum.BAR_CLOTHES:
					item=this.clothesItem;
					break;
				case MarketEnum.BAR_FAIR:
					item=this.fairItem;
					break;
				case MarketEnum.BAR_FIREWORK:
					item=this.fireworksItem;
					break;
				case MarketEnum.BAR_HOT:
					item=this.hotItem;
					break;
				case MarketEnum.BAR_JEWELRY:
					item=this.jewelryItem;
					break;
				case MarketEnum.BAR_SPECIAL:
					item=this.specialItem;
					break;
				case MarketEnum.BAR_WEAPONS:
					item=this.weaponsItem;
					break;
			}
			this.updata(item);
			this.updataPage();
		}

		public function getInfoByGridId(id:int):TShopInfo {
			var info:TShopInfo;
			switch (this.currentBtnIdx) {
				case MarketEnum.BAR_CLOTHES:
					if (this.clothesItem.length > 0)
						info=this.clothesItem[this.currentPage * MarketEnum.CLIENT_NUM_PER_PAGE + id];
					break;
				case MarketEnum.BAR_FAIR:
					if (this.fairItem.length > 0)
						info=this.fairItem[this.currentPage * MarketEnum.CLIENT_NUM_PER_PAGE + id];
					break;
				case MarketEnum.BAR_FIREWORK:
					if (this.fireworksItem.length)
						info=this.fireworksItem[this.currentPage * MarketEnum.CLIENT_NUM_PER_PAGE + id];
					break;
				case MarketEnum.BAR_HOT:
					if (this.hotItem.length > 0)
						info=this.hotItem[this.currentPage * MarketEnum.CLIENT_NUM_PER_PAGE + id];
					break;
				case MarketEnum.BAR_JEWELRY:
					if (this.jewelryItem.length > 0)
						info=this.jewelryItem[this.currentPage * MarketEnum.CLIENT_NUM_PER_PAGE + id];
					break;
				case MarketEnum.BAR_SPECIAL:
					if (this.specialItem.length > 0)
						info=this.specialItem[this.currentPage * MarketEnum.CLIENT_NUM_PER_PAGE + id];
					break;
				case MarketEnum.BAR_WEAPONS:
					if (this.weaponsItem.length > 0)
						info=this.weaponsItem[this.currentPage * MarketEnum.CLIENT_NUM_PER_PAGE + id];
					break;
			}
			return info;
		}
		
		public function get currentBtnIndex():int{
			return this.currentBtnIdx;
		}
	}
}