package com.leyou.ui.shop {
	import com.ace.enum.UIEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.window.children.InputWindow;
	import com.ace.ui.window.children.PopWindow;
	import com.ace.ui.window.children.WindInfo;
	import com.leyou.data.net.shop.TStdItem;
	import com.leyou.enum.ChatEnum;
	import com.leyou.enum.ShopEnum;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.ui.shop.child.GridShop;
	
	import flash.events.MouseEvent;

	public class ShopWnd extends AutoWindow {
		private var pageLbl:Label;
		private var prePageBtn:NormalButton;
		private var nextPageBtn:NormalButton;
		private var currentPage:int=1; //当前页
		private var sumPage:int=1; //总页数
//		private var renderArr:Vector.<ShopListRender>;
		private var renderArr:Vector.<GridShop>;
		private var overRenderIdx:int=-1;
		private var clickRenderIdx:int;
		private var npc:int;
		private var goodCount:int;
		private var goodIdx:int;
		private var itemArr:Vector.<TStdItem>;
		private var _evt:MouseEvent;
		private var doubleClick:Boolean;
		private var inputW:InputWindow;

		public function ShopWnd() {
			super(LibManager.getInstance().getXML("config/ui/ShopWnd.xml"));
			this.init();
		}

		private function init():void {

			this.itemArr=new Vector.<TStdItem>;
			this.pageLbl=this.getUIbyID("pageLbl") as Label;
			this.prePageBtn=this.getUIbyID("prePageBtn") as NormalButton;
			this.nextPageBtn=this.getUIbyID("nextPageBtn") as NormalButton;

			this.prePageBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.nextPageBtn.addEventListener(MouseEvent.CLICK, onClick);

//			this.renderArr=new Vector.<ShopListRender>;
//			for (var i:int=0; i < ShopEnum.PAGE_RENDER_NUM; i++) {
//				var render:ShopListRender=new ShopListRender();
//				render.name=i.toString();
//				if (i % 2 == 0)
//					render.x=32;
//				else if (i % 2 == 1)
//					render.x=200;
//				render.y=58 + (Math.ceil((i + 1) / 2) - 1) * ShopEnum.SHOPRENDER_HEIGHT;
//				render.visible=false;
//				render.id=i;
//				render.addEventListener(MouseEvent.CLICK, onRenderClick);
//				render.addEventListener(MouseEvent.ROLL_OUT, onRenderOut);
//				render.addEventListener(MouseEvent.MOUSE_OVER, onRenderOver);
//				render.addEventListener(MouseEvent.MOUSE_UP,onRenderUp);
//				
//
//				render.doubleClickEnabled=true;
//				render.addEventListener(MouseEvent.DOUBLE_CLICK, onRenderDoubleClick);
//				this.renderArr.push(render);
//				this.addChild(render);
//			}
			this.renderArr=new Vector.<GridShop>;
			for (var i:int=0; i < ShopEnum.PAGE_RENDER_NUM; i++) {
				var render:GridShop=new GridShop();
				render.name=i.toString();
				if (i % 2 == 0)
					render.x=32 + 3;
				else if (i % 2 == 1)
					render.x=200;
				render.y=58 + (Math.ceil((i + 1) / 2) - 1) * ShopEnum.SHOPRENDER_HEIGHT + 3;
				render.visible=false;
				render.id=i;
				this.renderArr.push(render);
				this.addChild(render);
			}
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			super.show(toTop, toCenter);
			UIManager.getInstance().backPackWnd.show(true, false);
			UIManager.getInstance().backPackWnd.x=this.x + this.width;
			UIManager.getInstance().backPackWnd.y=this.y;

			UIManager.getInstance().backPackWnd.setShopBtnActive(true);
		}

		override public function hide():void {
			super.hide();
			UIManager.getInstance().backPackWnd.setShopBtnActive(false);
			this.clearMe();
		}

		private function clearMe():void {
			this.currentPage=1;
			this.itemArr.length=0;
		}

//
//		public function updata(arr:Vector.<TStdItem>):void {
//			if (arr == null)
//				return;
//			this.sumPage=Math.ceil(arr.length / ShopEnum.PAGE_RENDER_NUM);
//			var render:ShopListRender;
//			this.sumPage=Math.ceil(arr.length / ShopEnum.PAGE_RENDER_NUM);
//			for (var i:int=(this.currentPage - 1) * ShopEnum.PAGE_RENDER_NUM; i < (this.currentPage) * ShopEnum.PAGE_RENDER_NUM; i++) {
//				render=this.renderArr[i % ShopEnum.PAGE_RENDER_NUM];
//				if (i >= arr.length) {
//					render.visible=false;
//					continue;
//				} else {
//					render.visible=true;
//					render.updataInfo(arr[i]);
//				}
//			}
//			this.pageLbl.text=String(currentPage + "/" + this.sumPage);
//		}

		public function updata(arr:Vector.<TStdItem>):void {
			if (arr == null)
				return;
			this.sumPage=Math.ceil(arr.length / ShopEnum.PAGE_RENDER_NUM);
			var render:GridShop;
			this.sumPage=Math.ceil(arr.length / ShopEnum.PAGE_RENDER_NUM);
			for (var i:int=(this.currentPage - 1) * ShopEnum.PAGE_RENDER_NUM; i < (this.currentPage) * ShopEnum.PAGE_RENDER_NUM; i++) {
				render=this.renderArr[i % ShopEnum.PAGE_RENDER_NUM];
				if (i >= arr.length) {
					render.visible=false;
					continue;
				} else {
					render.visible=true;
					render.updataInfo(arr[i]);
				}
			}
			this.pageLbl.text=String(currentPage + "/" + this.sumPage);
		}

		private function onClick(evt:MouseEvent):void {
			if (evt.target.name == "nextPageBtn") {
				if (this.currentPage >= this.sumPage)
					return;
				this.currentPage++;
				this.updata(itemArr);

			} else if (evt.target.name == "prePageBtn") {
				if (this.currentPage <= 1)
					return;
				this.currentPage--;
				this.updata(this.itemArr);
			}
		}

		//点击render
//		private function onRenderClick(evt:MouseEvent):void {
//			this.doubleClick=false;
//			this._evt=evt;
//			var timer:Timer=new Timer(260, 1);
//			timer.addEventListener(TimerEvent.TIMER, checkRenderClick);
//			timer.start();
//		}
//
//		//双击
//		private function onRenderDoubleClick(evt:MouseEvent):void {
//			this.doubleClick=true;
//			this._evt=evt;
//		}

//		private function checkRenderClick(evt:TimerEvent):void {
//			if (!(this._evt.target is ShopListRender) && !(this._evt.target is ShopGrid))
//				return;
//			var idx:int;
//			if (this._evt.target is ShopListRender)
//				idx=int((this._evt.target as ShopListRender).name);
//			else if (this._evt.target is ShopGrid)
//				idx=int((this._evt.target as ShopGrid).parent.name);
//			if (this.doubleClick) {
//				this.renderDoubleClick(idx);
//			} else if (!this.doubleClick) {
//				this.renderClick(idx);
//			}
//		}

		private function ok(str:String):void {
			if (str == ""||int(str) <=0)
				return;
			Cmd_Task.cm_userBuyItem(this.npc, 12 + (this.currentPage - 1) * ShopEnum.PAGE_RENDER_NUM + this.clickRenderIdx, int(str), this.itemArr[(this.currentPage - 1) * ShopEnum.PAGE_RENDER_NUM + this.clickRenderIdx].Name);
		}

		private function cancle():void {
		}

		//移出render
		private function onRenderOut(evt:MouseEvent):void {
//			if (this.overRenderIdx != -1 && this.renderArr[this.overRenderIdx]) {
//				this.renderArr[this.overRenderIdx].highLight=false;
//				this.overRenderIdx=-1;
//			}
		}

		//移过render
		private function onRenderOver(evt:MouseEvent):void {
//			if (evt.target is ShopListRender) {
//				var idx:int=int((evt.target as ShopListRender).name);
//				if (idx != this.overRenderIdx) {
//					if (this.overRenderIdx != -1 && this.renderArr[this.overRenderIdx])
//						this.renderArr[this.overRenderIdx].highLight=false;
//					this.overRenderIdx=idx;
//					if (this.renderArr[this.overRenderIdx])
//						this.renderArr[this.overRenderIdx].highLight=true;
//				}
//			}
		}


		public function ser_ShowShopWnd(arr:Vector.<TStdItem>, npc:int, count:int, idx:int):void {
			this.show(true, true);
			this.npc=npc;
			this.goodCount=count;
			this.sumPage=goodCount;
			this.goodIdx=idx;
			this.itemArr=this.itemArr.concat(arr);
			this.currentPage=1;
			this.updata(this.itemArr);
			Cmd_Task.cm_closeNpcWin();
			if (goodCount > this.goodIdx)
				Cmd_Task.cm_userGetDeailItem(npc, goodIdx + 1);
		}

		public function buyFailed(reson:int):void {
			switch (reson) {
				case 1: //1: FrmDlg.DMessageDlg ('此物品被卖出.', [mbOk]);
					UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_SYSTEM, "物品购买失败");
					break;
				case 2: //2: FrmDlg.DMessageDlg ('您无法携带更多物品了.', [mbOk]);
					UIManager.getInstance().noticeMidDownUproll.setNoticeStr("您无法携带更多物品了",SystemNoticeEnum.IMG_PROMPT);
					break;
				case 3: //3: FrmDlg.DMessageDlg ('您没有足够的钱来购买此物品.', [mbOk]);
					UIManager.getInstance().noticeMidDownUproll.setNoticeStr("您没有足够的钱来购买此物品",SystemNoticeEnum.IMG_PROMPT);
					break;
			}
		}

		/**
		 * 卖出
		 * @param makeIdx
		 * @param name
		 *
		 */
		public function sellItem(makeIdx:int, name:String):void {
			Cmd_Task.cm_userSellItem(this.npc, makeIdx, name);
		}

		public function renderClick(idx:int):void {
			this.clickRenderIdx=idx;
			var win:WindInfo=WindInfo.getInputInfo("请输入购买数量");
			win.okFun=ok;
			win.cancelFun=cancle;
			inputW=PopWindow.showWnd(UIEnum.WND_TYPE_INPUT,win,"shop_inputWnd") as InputWindow;
			inputW.textbox.text="1";
			inputW.textbox.restrict="0-9";
			inputW.textbox.input.maxChars=4;
//			if (this.inputAlertWnd == null || !this.inputAlertWndSta) {
//				this.inputAlertWnd=ConfirmInputWindow.showWin("请输入购买数量", ok, cancle, 1, null, true);
//				this.inputAlertWnd.textbox.text="1";
//				this.inputAlertWnd.textbox.restrict="0-9";
//				this.inputAlertWnd.textbox.input.maxChars=4;
//				this.inputAlertWndSta=true;
//			} else if (this.inputAlertWndSta) {
//				this.inputAlertWnd.textbox.text="1";
//			}
		}

		public function renderDoubleClick(idx:int):void {
			var table:TItemInfo=TableManager.getInstance().getItemByName(this.itemArr[(this.currentPage - 1) * ShopEnum.PAGE_RENDER_NUM + idx].Name);
			var count:int;
			if(table)
				count=table.stackNum;
			else count=1;
			Cmd_Task.cm_userBuyItem(this.npc, 12 + (this.currentPage - 1) * ShopEnum.PAGE_RENDER_NUM + idx, table.stackNum, this.itemArr[(this.currentPage - 1) * ShopEnum.PAGE_RENDER_NUM + idx].Name);
		}

		public function getInfoByIdx(idx:int):TStdItem {
			if (this.itemArr.length > 0)
				return this.itemArr[(this.currentPage - 1) * ShopEnum.PAGE_RENDER_NUM + idx];
			else
				return null;
		}
	}
}