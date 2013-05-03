package com.leyou.ui.tools {
	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.HideInput;
	import com.greensock.TweenMax;
	import com.leyou.config.Core;
	import com.leyou.data.tool.data.ShortCutGridInfo;
	import com.leyou.manager.ShareObjManage;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.NetEnum;
	import com.leyou.net.protocol.Cmd_Chat;
	import com.leyou.net.protocol.Cmd_Guild;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.net.protocol.Cmd_Trade;
	import com.leyou.net.protocol.Cmd_backPack;
	import com.leyou.net.protocol.scene.CmdScene;
	import com.leyou.ui.tools.child.ShortcutsGrid;
	import com.leyou.utils.FilterUtil;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class ToolsWnd extends AutoSprite {
		public var initOk:Boolean;
		private var shortCutDic:Vector.<ShortcutsGrid>;
		private var chatTinput:HideInput;
		private var sendBtn:NormalButton;
		private var backpackBtn:ImgButton;
		private var skillBtn:ImgButton;
		private var friendBtn:ImgButton;
		private var playerBtn:ImgButton;
		private var settingBtn:ImgButton;
		private var teamBtn:ImgButton;
		private var shopBtn:ImgButton;
		private var tradeBtn:ImgButton;
		private var mountBtn:ImgButton;
		private var guildBtn:ImgButton;
		private var memberBtn:ImgButton;
//		private var expImg:Image;
		private var expScaleBitMap:ScaleBitmap;
		private var expWidth:int;
		private var expHight:int;

		private var tw:TweenMax;

		private var gridBg:Sprite;

		public function ToolsWnd() {
			super(LibManager.getInstance().getXML("config/ui/ToolsWnd.xml"));
			this.mouseChildren=true;
			this.mouseEnabled=true;
			this.init();
		}


		private function init():void {

//			this.chatTinput=this.getUIbyID("chatTinput") as HideInput;
//			this.sendBtn=this.getUIbyID("sendBtn") as NormalButton;
			this.backpackBtn=this.getUIbyID("backpackBtn") as ImgButton;
			this.skillBtn=this.getUIbyID("skillBtn") as ImgButton;
			this.friendBtn=this.getUIbyID("friendBtn") as ImgButton;
			this.playerBtn=this.getUIbyID("playerBtn") as ImgButton;
			this.settingBtn=this.getUIbyID("settingBtn") as ImgButton;
			this.teamBtn=this.getUIbyID("teamBtn") as ImgButton;
			this.shopBtn=this.getUIbyID("shopBtn") as ImgButton;
			this.tradeBtn=this.getUIbyID("tradeBtn") as ImgButton;
			this.mountBtn=this.getUIbyID("mountBtn") as ImgButton;
			this.guildBtn=this.getUIbyID("guildBtn") as ImgButton;
			this.memberBtn=this.getUIbyID("memberBtn") as ImgButton;
//			this.expImg=this.getUIbyID("expImg") as Image;

			this.expScaleBitMap=new ScaleBitmap(LibManager.getInstance().getImg("ui/mainUI/main_exp_bar_hp.png"));
			this.expScaleBitMap.scale9Grid=new Rectangle(2, 2, 715, 6);
			this.expScaleBitMap.x=110.5;
			this.expScaleBitMap.y=93;
			this.addChildAt(this.expScaleBitMap, this.numChildren - 7);
			this.expWidth=717;
			this.expHight=8;


//			this.expScaleBitMap.setSize(this.expImg.width, this.expImg.height);

			this.gridBg=new Sprite;
			this.addChild(gridBg);
			this.gridBg.x=108;
			this.gridBg.y=50;

			//this.sendBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.backpackBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.skillBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.friendBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.playerBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.settingBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.teamBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.shopBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.tradeBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.mountBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.guildBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.memberBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.addShoruCutKey();
			this.addEventListener(MouseEvent.CLICK, onThisCLick);
		}

		private function onThisCLick(evt:MouseEvent):void {
			evt.stopPropagation();
		}

		//添加快捷键
		private function addShoruCutKey():void {
			this.shortCutDic=new Vector.<ShortcutsGrid>;

			var keyGrid:ShortcutsGrid;
			for (var i:int=0; i < 10; i++) {
				if (i == 9)
					keyGrid=new ShortcutsGrid(0);
				else
					keyGrid=new ShortcutsGrid(i + 1);
				keyGrid.x=(i * 42);
				this.gridBg.addChild(keyGrid);
				this.shortCutDic[i]=keyGrid;
			}

			this.gridBg.graphics.beginFill(0x00);
			this.gridBg.graphics.drawRect(0, 0, this.gridBg.width, this.gridBg.height);
			this.gridBg.graphics.endFill();
		}

		private function onClick(evt:MouseEvent):void {

			switch (evt.target.name) {
				case "memberBtn":
					Cmd_backPack.cm_addStarItem();
					break;
				case "sendBtn":
					Cmd_Task.cm_clickNpc(NetEnum.NPC_STORAGE);
					break;
				case "backpackBtn":
					UIManager.getInstance().backPackWnd.open(); //打开背包

					break;
				case "skillBtn":
					UIManager.getInstance().skillWnd.open();
					break;
				case "friendBtn":
					UIManager.getInstance().friendWnd.open();
					break;
				case "playerBtn":
					UIManager.getInstance().roleWnd.open();
					break;
				case "settingBtn":
					UIManager.getInstance().settingWnd.open();
					break;
				case "teamBtn":
					UIManager.getInstance().teamWnd.open();
					break;
				case "shopBtn":
					UIManager.getInstance().marketWnd.open();
					break;
				case "tradeBtn":
					Cmd_Trade.cm_dealTry();
					break;
				case "mountBtn":
					Cmd_Chat.upAndDownHorse();
					break;
				case "guildBtn":
					Cmd_Guild.cm_openGuildDlg();
					break;
			}
			evt.stopImmediatePropagation();
		}

		//读取shareobject 并且更新信息
		public function readData():void {
			this.initOk=true;
			var shareOBj:Object=ShareObjManage.getInstance().readFile(MyInfoManager.getInstance().name + "tool");
			if (shareOBj == null) {
				return;
			}
			var info:Object
			for (var i:int=0; i < 10; i++) {
				if (shareOBj[i] == null)
					continue;
				info=new Object();
				if (shareOBj[i].gridType == ItemEnum.TYPE_GRID_SKILL) {
					if (shareOBj[i].itemId < MyInfoManager.getInstance().skills.length) {
						info=MyInfoManager.getInstance().skills[shareOBj[i].itemId];
						this.shortCutDic[i].updateItem(info, shareOBj[i].itemId);
					}
				}
				if (shareOBj[i].gridType == ItemEnum.TYPE_GRID_BACKPACK) {
					info=MyInfoManager.getInstance().getItemByItemId(shareOBj[i].itemId);
					this.shortCutDic[i].updateItem(info);
				}
			}
		}

		//保存shareObject数据
		public function saveData():void {
			var info:ShortCutGridInfo;
			var obj:Object=new Object();
			for (var i:int=0; i < 10; i++) {
				if (this.shortCutDic[i].dataId != -1) {
					info=new ShortCutGridInfo();
					info.gridType=this.shortCutDic[i].cloneGridType;
					info.itemId=this.shortCutDic[i].dataId;
					obj[i]=info;
				} else
					obj[i]=null;
			}
			ShareObjManage.getInstance().saveFile(MyInfoManager.getInstance().name + "tool", obj);
		}

		/**
		 *显示拖拽光圈
		 *
		 */
		public function showDragGlowFilter(v:Boolean):void {
			if (v)
				tw=FilterUtil.showGlowFilter(this.gridBg);
			else {
				if (tw != null)
					tw.kill();
				this.gridBg.filters=[];
			}
		}

		//快捷键按下
		public function onShortcutDown(keyNum:int):void {
			for each (var render:ShortcutsGrid in this.shortCutDic) {
				if (render.gridId == keyNum) {
					render.onUse();
					return;
				}
			}
		}

		public function updataShortcutGrid(itemId:int):void {
			for each (var render:ShortcutsGrid in this.shortCutDic) {
				if (render.dataId == itemId) {
					render.updataNum();
					return;
				}
			}
		}

		public function get shortCutGrid():Object {
			return this.shortCutDic;
		}

		public function checkSKill(id:int, deleteF:Boolean=true):int {
			for (var i:* in this.shortCutDic) {
				if ((this.shortCutDic[i] as ShortcutsGrid).dataId == id) {
					if (deleteF) {
						if ((this.shortCutDic[i] as ShortcutsGrid).dataId >= 0 && (this.shortCutDic[i] as ShortcutsGrid).cloneGridType == ItemEnum.TYPE_GRID_SKILL)
							UIManager.getInstance().skillWnd.setSkillGridShortCut((this.shortCutDic[i] as ShortcutsGrid).dataId, -1);
						(this.shortCutDic[i] as ShortcutsGrid).dropHandler();
					}
					return i;
				}
			}
			return -1;
		}

		/**
		 *更新经验
		 * @param exp
		 * @param maxExp
		 *
		 */
		public function updateExp():void {
			var exp:uint=MyInfoManager.getInstance().baseInfo.Exp;
			var maxExp:uint=MyInfoManager.getInstance().baseInfo.MaxExp;
			var w:Number=Number(exp / maxExp) * this.expWidth;
			if (w > this.expWidth)
				w=this.expWidth;
			this.expScaleBitMap.setSize(w, this.expHight);
//			this.expScaleBitMap.setSize(0.1, this.expHight);
		}

		public function resize():void {
			this.x=(UIEnum.WIDTH - 934) / 2;
			this.y=UIEnum.HEIGHT - 105;
		}
	}
}
