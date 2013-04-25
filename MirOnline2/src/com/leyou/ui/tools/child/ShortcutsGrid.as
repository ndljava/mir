package com.leyou.ui.tools.child {
	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.playerSkill.TClientMagic;
	import com.ace.manager.LibManager;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.backpack.child.ItemTip;
	import com.leyou.ui.cdTimer.CDTimer;
	import com.leyou.utils.ItemUtil;

	import flash.display.Shape;

	/**
	 *
	 * @author Administrator
	 */
	/**
	 *
	 * @author Administrator
	 */
	public class ShortcutsGrid extends GridBase {
		private var numLbl:Label;
		private var shortcutKeyLbl:Label;

		private var _cloneGridType:String; //克隆的格子类型：技能、背包
		private var isCD:Boolean;

		public function ShortcutsGrid(id:int=-1) {
			super(id);
		}

		override protected function init():void {
			super.init();
			this.isLock=false;
			this.dataId=-1;
			this.gridType=ItemEnum.TYPE_GRID_SHORTCUT;

			this.numLbl=new Label("", FontEnum.STYLE_NAME_DIC["White10right"]);
			this.numLbl.x=30;
			this.numLbl.y=23;
			this.addChild(this.numLbl);

			this.shortcutKeyLbl=new Label(this.gridId.toString(), FontEnum.STYLE_NAME_DIC["GreenBold12"]);
			shortcutKeyLbl.x=2;
			shortcutKeyLbl.y=2;
			this.addChild(shortcutKeyLbl);

			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/mainUI/icon_skill.png");

		}

		override public function set gridId(value:int):void {
			super.gridId=value;
			this.shortcutKeyLbl && (this.shortcutKeyLbl.text=this.gridId.toString());
		}

		override public function switchHandler(fromItem:GridBase):void {
//			super.switchHandler(fromItem);
			//如果是同类
			if (fromItem.gridType == ItemEnum.TYPE_GRID_SHORTCUT) {
				var obj:Object;
				if (!this.isEmpty) {
					obj=new Object();
					obj.dataId=this.dataId;
					obj._cloneGridType=this.cloneGridType;
				}
				this._cloneGridType=(fromItem as ShortcutsGrid).cloneGridType;
				this.updataInfo(null);
				this.iconBmp.bitmapData=fromItem.itemBmp;
				this.dataId=fromItem.dataId;
				if ((fromItem as ShortcutsGrid).cloneGridType == ItemEnum.TYPE_GRID_BACKPACK)
					this.numLbl.text=MyInfoManager.getInstance().itemTotalNum(this.dataId, false).toString();
				else
					this.numLbl.text="";
				if (this.numLbl.text == "0")
					this.numLbl.text="";
				if ((fromItem as ShortcutsGrid).cloneGridType == ItemEnum.TYPE_GRID_SKILL)
					UIManager.getInstance().skillWnd.setSkillGridShortCut(this.dataId, this.gridId);
				if (obj) {
					if (obj._cloneGridType == ItemEnum.TYPE_GRID_BACKPACK)
						(fromItem as ShortcutsGrid).updateItem(MyInfoManager.getInstance().getItemByItemId(obj.dataId));
					if (obj._cloneGridType == ItemEnum.TYPE_GRID_SKILL)
						(fromItem as ShortcutsGrid).updateItem(MyInfoManager.getInstance().skills[obj.dataId], obj.dataId);
				} else {
					fromItem.dataId=-1;
					fromItem.dropHandler();
				}
			}
			//如果是主动技能
			if (fromItem.gridType == ItemEnum.TYPE_GRID_SKILL) {
				//如果该技能还没有学习
				if (MyInfoManager.getInstance().skills[fromItem.dataId].isLearn == false)
					return;
				UIManager.getInstance().toolsWnd.checkSKill(fromItem.dataId);
				if (this.cloneGridType == ItemEnum.TYPE_GRID_SKILL)
					UIManager.getInstance().skillWnd.setSkillGridShortCut(this.dataId, -1);
				this._cloneGridType=ItemEnum.TYPE_GRID_SKILL;
				this.updataInfo(null);
				this.dataId=fromItem.dataId;
				this.iconBmp.bitmapData=fromItem.itemBmp;
				UIManager.getInstance().skillWnd.setSkillGridShortCut(this.dataId, this.gridId);
			}

			//如果是药品
			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
				if (ItemUtil.ITEM_TOOL.indexOf(MyInfoManager.getInstance().backpackItems[fromItem.dataId].s.type) == -1)
					return;
				UIManager.getInstance().toolsWnd.checkSKill(MyInfoManager.getInstance().backpackItems[fromItem.dataId].s.id);
				if (this.cloneGridType == ItemEnum.TYPE_GRID_SKILL)
					UIManager.getInstance().skillWnd.setSkillGridShortCut(this.dataId, -1);
				this._cloneGridType=ItemEnum.TYPE_GRID_BACKPACK;
				this.updataInfo(null);
				this.dataId=MyInfoManager.getInstance().backpackItems[fromItem.dataId].s.id;
				this.iconBmp.bitmapData=fromItem.itemBmp;
				this.numLbl.text=MyInfoManager.getInstance().itemTotalNum(this.dataId, false).toString(); //显示总药品数量
			}

			this.iconBmp.x=(this.bgBmp.bitmapData.width - this.iconBmp.width) >> 1;
			this.iconBmp.y=(this.bgBmp.bitmapData.height - this.iconBmp.height) >> 1;
			UIManager.getInstance().toolsWnd.saveData();
		}

		override public function mouseOverHandler($x:Number, $y:Number):void {
			if (this.dataId == -1)
				return;
			super.mouseOverHandler($x, $y);
			if (this._cloneGridType == ItemEnum.TYPE_GRID_BACKPACK) {
				var tc:TClientItem=MyInfoManager.getInstance().getItemByItemId(this.dataId);
				ItemTip.getInstance().show(MyInfoManager.getInstance().backpackItems.indexOf(tc), ItemEnum.TYPE_GRID_BACKPACK);
			} else if (this._cloneGridType == ItemEnum.TYPE_GRID_SKILL) {
				ItemTip.getInstance().show(this.dataId, ItemEnum.TYPE_GRID_SHORTCUT);
			}
			ItemTip.getInstance().updataPs($x, $y);

		}

		override public function mouseOutHandler():void {
			ItemTip.getInstance().hide();
		}

		public function updateItem(info:*, dataid:int=-1):void {
			if (info is TClientItem) {
				this._cloneGridType=ItemEnum.TYPE_GRID_BACKPACK;
				this.updataInfo(null);
				this.dataId=info.s.id;
				this.iconBmp.updateBmp("items/" + info.s.appr + ".png");
				this.numLbl.text=MyInfoManager.getInstance().itemTotalNum(this.dataId, false).toString(); //显示总药品数量
			} else if (info is TClientMagic) {
				if (info.def == null)
					return;
				this._cloneGridType=ItemEnum.TYPE_GRID_SKILL;
				this.updataInfo(null);
				this.dataId=dataid;
				this.iconBmp.updateBmp("skillIco/" + (800 + info.def.btEffect * 2) + ".png");
				UIManager.getInstance().skillWnd.setSkillGridShortCut(this.dataId, this.gridId); //在技能面板上显示快捷键
			}
			this.iconBmp.x=(40 - 28) >> 1;
			this.iconBmp.y=(40 - 30) >> 1;
		}

		override public function dropHandler():void {
			if (this._cloneGridType == ItemEnum.TYPE_GRID_SKILL)
				UIManager.getInstance().skillWnd.setSkillGridShortCut(this.dataId, -1);
			this.reset();
			UIManager.getInstance().toolsWnd.saveData();
		}

		public function clearMe():void {
			this.reset();
		}

		override protected function reset():void {
			super.reset();
			this.numLbl.text="";
			this.isLock=false;
			this.dataId=-1;
			this.iconBmp.bitmapData=null;
			this.isEmpty=true;
			this._cloneGridType="";
		}

		//使用
		public function onUse():void {
			if (this.dataId == -1)
				return;
			//如果是药品
			if (this._cloneGridType == ItemEnum.TYPE_GRID_BACKPACK) {
				UIManager.getInstance().backPackWnd.useItem(this.dataId);
			}
			//如果是技能
			if (this._cloneGridType == ItemEnum.TYPE_GRID_SKILL) {
				UIManager.getInstance().mirScene.useMagic(MyInfoManager.getInstance().skills[this.dataId].def.wMagicId);
			}
		}

		//使用道具后，更新数量
		public function updataNum():void {
			var num:int=MyInfoManager.getInstance().itemTotalNum(this.dataId, false);
			if (num == 0)
				this.dropHandler();
			else
				this.numLbl.text=num.toString(); //显示总药品数量
		}


		public function get cloneGridType():String {
			return this._cloneGridType;
		}

		private function cdTimer(time:int=5000):void {
			if (this.isCD == true)
				return;
			var cd:CDTimer=new CDTimer(this.width, this.height, time);
			cd.cdEndFun=this.cdEnd;
			this.addChild(cd);
			cd.start();
			this.isCD=true;
			this.mouseEnabled=false;
		}

		private function cdEnd():void {
			this.isCD=false;
			this.mouseEnabled=true;
		}
	}
}