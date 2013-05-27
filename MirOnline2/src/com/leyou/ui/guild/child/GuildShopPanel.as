package com.leyou.ui.guild.child {
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.window.children.WindInfo;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Guild;
	import com.leyou.ui.guild.child.children.GuildStoreGrid;
	import com.leyou.ui.guild.child.children.ShopRender;
	import com.leyou.utils.GuildUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class GuildShopPanel extends AutoSprite {
		private var pageLbl:Label;
		private var prePageBtn:NormalButton;
		private var nextPageBtn:NormalButton;
		private var containSP:Sprite;
		private var renderArr:Vector.<ShopRender>;
		private var selectRenderIdx:int=-1;
		private var overRenderIdx:int=-1;

		private var currentPage:int=0;
		private var pageSize:int=24;
		private var countPage:int=0;

		private var fullArr:Vector.<TClientItem>;

		public function GuildShopPanel() {
			super(LibManager.getInstance().getXML("config/ui/guild/GuildShopPage.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void {
			this.pageLbl=this.getUIbyID("pageLbl") as Label;
			this.prePageBtn=this.getUIbyID("prePageBtn") as NormalButton;
			this.nextPageBtn=this.getUIbyID("nextPageBtn") as NormalButton;

			this.containSP=new Sprite();
			this.containSP.x=2;
			this.containSP.y=10;
			this.addChild(this.containSP);

			this.renderArr=new Vector.<ShopRender>;

			this.containSP.addEventListener(MouseEvent.CLICK, onContainSPClick);
			this.containSP.addEventListener(MouseEvent.MOUSE_OVER, onConTainSPOver);
			this.containSP.addEventListener(MouseEvent.MOUSE_OUT, onContainSPOut);

			this.prePageBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.nextPageBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			this.fullArr=new Vector.<TClientItem>();
		}

		public function updateData():void {
			while (this.containSP.numChildren) {
				this.containSP.removeChildAt(0);
			}

			this.renderArr.length=0;
			this.renderArr=new Vector.<ShopRender>();
			var item:ShopRender;

			var arr:Vector.<Vector.<Vector.<TClientItem>>>=UIManager.getInstance().guildWnd.storeArr;
			this.fullArr=new Vector.<TClientItem>();

			for (var x1:int=0; x1 < arr.length; x1++) {
				if (x1 == 5 || x1 == 0)
					continue;

				for (var x2:int=0; x2 < arr[x1].length; x2++) {
					for (var x3:int=0; x3 < arr[x1][x2].length; x3++) {
						this.fullArr.push(arr[x1][x2][x3]);
					}
				}
			}

			for (var i:int=currentPage * pageSize; i < (currentPage * pageSize + pageSize); i++) {
				if (i >= fullArr.length)
					break;

				item=new ShopRender();
				item.name=i.toString();

				this.containSP.addChild(item);

				item.x=10 + this.renderArr.length % 4 * item.width;
				item.y=Math.floor(this.renderArr.length / 4) * item.height;

				item.update(fullArr[i]);
				this.renderArr.push(item);
			}

			countPage=(this.fullArr.length % pageSize == 0) ? fullArr.length / pageSize : Math.ceil(fullArr.length / pageSize);
			this.pageLbl.text=(currentPage + 1) + "/" + (countPage < 1 ? 1 : countPage);
			
			this.selectRenderIdx=-1;
			this.overRenderIdx=-1;
		}

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "prePageBtn": //上一页
					currentPage--;
					if (currentPage < 0)
						currentPage=0;
					break;
				case "nextPageBtn": //下一页
					currentPage++;
					if (currentPage >= countPage - 1)
						currentPage=countPage - 1;
					break;
			}

			updateData();
		}

		private function onContainSPClick(evt:MouseEvent):void {
			if (evt.target is ShopRender) {
				var idx:int=this.renderArr.indexOf(evt.target as ShopRender);
				if (this.selectRenderIdx == idx && this.selectRenderIdx>=this.renderArr.length)
					return;
                                  
				if (selectRenderIdx != -1) 
					this.renderArr[selectRenderIdx].renderSelectSta=false;

				this.selectRenderIdx=idx;
				this.renderArr[selectRenderIdx].renderSelectSta=true;

				confirmBuy();
			}
		}

		/**
		 * 确认购买
		 *
		 */
		private function confirmBuy():void {
			var tc:TClientItem=this.fullArr[currentPage * 24 + this.selectRenderIdx];
			if (tc == null)
				return;

			PopupManager.showConfirm("确认购买!!!", function():void {

				var arr:Array=GuildUtils.getMemberByName(UIManager.getInstance().guildWnd.memberArr, MyInfoManager.getInstance().name);
				if (arr == null)
					return;

				Cmd_Guild.cm_takeGuildItem(tc.MakeIndex, (arr[0] == "1" ? 1 : 0))
				Cmd_Guild.cm_guildStroage(1);
				Cmd_Guild.cm_guildStroage(2);
				Cmd_Guild.cm_guildStroage(3);
				Cmd_Guild.cm_guildStroage(4);
				Cmd_Guild.cm_guildStroage(5);
			});

		}


		private function onConTainSPOver(evt:MouseEvent):void {
			if (evt.target is ShopRender) {
				var idx:int=this.renderArr.indexOf(evt.target as ShopRender);
				if (this.selectRenderIdx == idx || this.overRenderIdx == idx)
					return;

				if (this.overRenderIdx != -1 && this.selectRenderIdx != this.overRenderIdx)
					this.renderArr[this.overRenderIdx].renderSelectSta=false;

				this.overRenderIdx=idx;
				this.renderArr[this.overRenderIdx].renderSelectSta=true;
			}
		}

		private function onContainSPOut(evt:MouseEvent):void {
			if (this.overRenderIdx != -1 && this.selectRenderIdx != this.overRenderIdx)
				this.renderArr[this.overRenderIdx].renderSelectSta=false;
			this.overRenderIdx=-1;
		}
	}
}
