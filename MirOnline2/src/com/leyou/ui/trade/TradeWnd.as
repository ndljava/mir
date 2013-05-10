package com.leyou.ui.trade {
	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.game.scene.part.LivingModel;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.enum.TradeEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Trade;
	import com.leyou.ui.trade.child.TradeRender;
	import com.leyou.utils.PlayerUtil;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	public class TradeWnd extends AutoWindow {
		private var playerNameLbl:Label;
		private var raceLbl:Label;
		private var lvLbl:Label;
		private var gameMoneyLbl:TextInput;
		private var gameGoldLbl:TextInput;
		private var gameMoneyILbl:TextInput;
		private var gameGoldILbl:TextInput;

		private var shelvesBtn:NormalButton;
		private var sureBtn:NormalButton;
		private var lockBtn:NormalButton;
		private var lockImg:Image;
		private var lockIImg:Image;
		private var renderArr:Vector.<TradeRender>;

		/**
		 * 对方的物品
		 */
		private var playItemArr:Vector.<TClientItem>
		/**
		 * 自己的物品 记录index
		 */
		public var selfItemArr:Vector.<GridBase>;

		public var waitIndex:int=-1;

		private var gridList1:ScrollPane;
		private var gridList:ScrollPane;

		/**
		 *物品上架
		 */
		public var isshelves:Boolean=false;

		public function TradeWnd() {
			super(LibManager.getInstance().getXML("config/ui/tradeWnd.xml"));
			this.init();
		}

		private function init():void {
			this.playerNameLbl=this.getUIbyID("playerNameLbl") as Label;
			this.raceLbl=this.getUIbyID("raceLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			//			this.gameMoneyLbl=this.getUIbyID("gameMoneyLbl") as TextInput;
			this.gameGoldLbl=this.getUIbyID("gameGoldLbl") as TextInput;
			//			this.gameMoneyILbl=this.getUIbyID("gameMoneyILbl") as TextInput;
			this.gameGoldILbl=this.getUIbyID("gameGoldILbl") as TextInput;
			this.shelvesBtn=this.getUIbyID("shelvesBtn") as NormalButton;
			this.sureBtn=this.getUIbyID("sureBtn") as NormalButton;
			this.lockBtn=this.getUIbyID("lockBtn") as NormalButton;
			this.lockImg=this.getUIbyID("lockImg") as Image;
			this.lockIImg=this.getUIbyID("lockIImg") as Image;
			this.gridList1=this.getUIbyID("gridList") as ScrollPane;
			this.gridList=this.getUIbyID("gridList2") as ScrollPane;

			this.gameGoldILbl.text="";
			this.gameGoldLbl.text="";
			//this.gameMoneyILbl.text="";
			//this.gameMoneyLbl.text="";
			this.gameGoldILbl.restrict="0-9";

			//this.gameMoneyILbl.visible=false;
			//this.gameMoneyLbl.visible=false;
			this.gameGoldLbl.mouseEnabled=false;
			this.gameGoldLbl.enable=false;

			//this.gameMoneyLbl.addEventListener(FocusEvent.FOCUS_OUT, onInputChange);
			//this.gameGoldLbl.addEventListener(FocusEvent.FOCUS_OUT, onInputChange);
			//this.gameMoneyILbl.addEventListener(FocusEvent.FOCUS_OUT, onInputChange);

			this.gameGoldILbl.addEventListener(FocusEvent.FOCUS_OUT, onInputChange);
			this.shelvesBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.sureBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.lockBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.lockBtn.visible=false;

			var render:TradeRender;
			this.renderArr=new Vector.<TradeRender>;
			for (var i:int=0; i < 20; i++) {
				render=new TradeRender();

				if (i < 10) {
					render.y=(Math.ceil((i + 1) / 2) - 1) * TradeEnum.TRADERENDER_HEIGHT;
					this.gridList.addToPane(render);
				} else {
					render.y=(Math.ceil((i - 10 + 1) / 2) - 1) * TradeEnum.TRADERENDER_HEIGHT;
					render.itemGrid.isLock=false;
					this.gridList1.addToPane(render);
				}

				if (i % 2 != 0)
					render.x=168;

				render.name="traderender_" + i;
				this.renderArr.push(render);
			}

			this.playItemArr=new Vector.<TClientItem>;
			this.selfItemArr=new Vector.<GridBase>;
			this.sureBtn.setActive(false);

			this.setLock();
		}

		/**
		 * 设置锁定状态
		 * @param $state 状态
		 * @param $self 是否自己
		 *
		 */
		public function setLock($state:Boolean=false, $self:Boolean=true):void {
			if (!$state) {
				this.lockIImg.visible=false;
				this.lockImg.visible=false;

				this.gameGoldILbl.enable=true;
			} else {
				if ($self) {

					this.addToPane(this.lockIImg);
					this.lockIImg.visible=true;
					for (var i:int=6; i < renderArr.length; i++) {
						this.renderArr[i].itemGrid.isLock=true;
					}

					this.gameGoldILbl.enable=false;
				} else {
					this.addToPane(this.lockImg);
					this.lockImg.visible=true;
				}
			}
		}

		override public function hide():void {
			super.hide();
			Cmd_Trade.cm_dealCancel();
			UIManager.getInstance().backPackWnd.setNeatenState(true);

			this.clearData();
		}

		/**
		 * 打开面板
		 *
		 */
		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			super.show();

			UIManager.getInstance().backPackWnd.show();
			UIManager.getInstance().backPackWnd.x=(UIEnum.WIDTH - this.width - UIManager.getInstance().backPackWnd.width) / 2;
			this.x=UIManager.getInstance().backPackWnd.x + UIManager.getInstance().backPackWnd.width;

			//清空数据
			for (var i:int=0; i < renderArr.length; i++) {
				this.renderArr[i].updataInfo(null);
				if (i >= 10)
					this.renderArr[i].itemGrid.isLock=false;
			}

			this.setLock();
			this.clearData();

			this.sureBtn.setActive(false);
		}

		private function clearData():void {
			var i:int=0;

			if (selfItemArr.length > 0) {
				for (i=0; i < selfItemArr.length; i++) {
					selfItemArr[i].enable=true;
					selfItemArr[i].isLock=false;
				}
			}

			this.playItemArr.length=0;

			this.gameGoldLbl.text="";
			this.gameGoldILbl.text="";
			this.gameGoldILbl.enable=true;
			this.gameGoldILbl.mouseEnabled=true;
			this.gameGoldILbl.mouseChildren=true;
			this.selfItemArr.length=0;

			this.shelvesBtn.text="物品上架";
			isshelves=false;
		}

		/**
		 *  交易事件
		 * @param evt
		 *
		 */
		private function onBtnClick(evt:MouseEvent):void {
			if (evt.currentTarget.name == "shelvesBtn") { //上架按钮

				if (NormalButton(evt.currentTarget).text.indexOf("取消上架") > -1) {
					NormalButton(evt.currentTarget).text="物品上架";
					isshelves=false;
				} else {
					NormalButton(evt.currentTarget).text="取消上架";
					isshelves=true;

					UIManager.getInstance().backPackWnd.show();
					UIManager.getInstance().backPackWnd.x=(UIEnum.WIDTH - this.width - UIManager.getInstance().backPackWnd.width) / 2;
					this.x=UIManager.getInstance().backPackWnd.x + UIManager.getInstance().backPackWnd.width;
				}
			}

			if (evt.currentTarget.name == "lockBtn") { //锁定按钮
				this.setLock(true);
			}

			if (evt.currentTarget.name == "sureBtn") { //确定按钮
				Cmd_Trade.cm_dealEnd();
				this.setLock(true);
			}

		}

		private function onInputChange(evt:Event):void {
			//			if (evt.currentTarget.name == "gameMoneyLbl") { //别人的游戏币
			//				trace("gameMoneyLbl");
			//			}
			//			if (evt.currentTarget.name == "gameGoldLbl") { //别人的元宝
			//				trace("gameGoldLbl");
			//			}
			//			if (evt.currentTarget.name == "gameMoneyILbl") { //自己的游戏@制造 太阳水币
			//				trace("gameMoneyILbl");
			//			}
			if (evt.currentTarget.name == "gameGoldILbl") { //自己的元宝
				//trace("gameGoldILbl");
				if (TextInput(evt.currentTarget).text != "" && TextInput(evt.currentTarget).text != null) {
					Cmd_Trade.cm_dealChgGold(int(TextInput(evt.currentTarget).text));
				}
			}
		}

		public function serv_showPanel(body:String):void {
			this.show();

			//改变对方昵称;
			var selectPlay:LivingModel=UIManager.getInstance().mirScene.getPlayerByName(body);
			this.playerNameLbl.text="" + selectPlay.infoB.name;
			this.raceLbl.text="" + PlayerUtil.getPlayerRaceByIdx(selectPlay.infoB.race);
			this.lvLbl.text="" + selectPlay.infoB.level;
			this.lvLbl.visible=false;
		}

		/**
		 * 更新自己物品
		 *
		 */
		public function serv_UpdataSelfItem():void {
			var g:GridBase=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, MyInfoManager.getInstance().waitItemFromId);
			if (this.renderArr[this.waitIndex].getGrid() != -1) {
				var rindex:String;
				for (rindex in this.renderArr) {
					if (int(rindex) > 10 && this.renderArr[rindex].getGrid() == -1) {
						this.waitIndex=int(rindex);
						break;
					}
				}
			}

			this.renderArr[this.waitIndex].updataInfo(g.data);
			this.waitIndex=-1;

			//记录
			this.selfItemArr.push(g);
			this.sureBtn.setActive(true);
			MyInfoManager.getInstance().resetWaitItem();

			UIManager.getInstance().backPackWnd.setNeatenState(false);
			UIManager.getInstance().backPackWnd.mouseChildren=true;

			//g.enable=false;
			g.isLock=true;
		}

		/**
		 * 更新玩家物品
		 * @param $info
		 *
		 */
		public function serv_UpdatePlayerItem($info:TClientItem):void {
			if (this.playItemArr.length >= 10)
				return;

			this.playItemArr.push($info);

			for (var i:int=0; i < this.playItemArr.length; i++) {
				this.renderArr[i].updataInfo(playItemArr[i]);
			}

			this.sureBtn.setActive(true);
		}

		/**
		 * 设置自己的金币
		 * @param $i
		 *
		 */
		public function serv_setSelfGold($num:int=0):void {
			this.gameGoldILbl.text="" + $num;
			this.gameGoldILbl.enable=false;
			this.gameGoldILbl.mouseEnabled=false;
			this.gameGoldILbl.mouseChildren=false;

			this.sureBtn.setActive(true);
		}

		/**
		 * 设置对方的金币
		 * @param $i
		 *
		 */
		public function serv_setPlayGold($i:int=0):void {
			this.gameGoldLbl.text="" + $i;
			this.sureBtn.setActive(true);
		}

		/**
		 * 取消交易
		 *
		 */
		public function serv_CancelTrade():void {
			super.hide();
			this.clearData();
		}

		/**
		 * 交易结束处理
		 *
		 */
		public function serv_TradeEnd():void {
			super.hide();

			var i:int=0;
			if (selfItemArr.length > 0) {
				for (i=0; i < selfItemArr.length; i++)
					if (selfItemArr[i].dataId != -1)
						MyInfoManager.getInstance().resetItem(selfItemArr[i].dataId);
			}

			if (playItemArr.length > 0) {
				for (i=0; i < playItemArr.length; i++) {
					MyInfoManager.getInstance().addItem(ItemEnum.TYPE_GRID_TRADE, playItemArr[i]);
				}
			}

			//刷新背包
			UIManager.getInstance().backPackWnd.refresh();
			UIManager.getInstance().backPackWnd.setNeatenState(true);
			this.clearData();
		}

	}
}
