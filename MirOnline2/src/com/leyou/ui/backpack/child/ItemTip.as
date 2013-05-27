package com.leyou.ui.backpack.child {
	import com.ace.enum.ItemEnum;
	import com.ace.enum.TickEnum;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.backPack.TSClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.tools.SpriteNoEvt;
	import com.leyou.data.net.market.TShopInfo;
	import com.leyou.data.net.shop.TStdItem;
	import com.leyou.enum.SkillEnum;
	import com.leyou.enum.TipsEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.tips.TipsEquip;
	import com.leyou.ui.tips.TipsEquipsEmpty;
	import com.leyou.ui.tips.TipsItem;
	import com.leyou.ui.tips.TipsSkill;
	import com.leyou.utils.TipsUtil;

	import flash.display.Sprite;
	import flash.display.Stage;

	public class ItemTip extends SpriteNoEvt {
		private static var INSTANCE:ItemTip; //非自己

		private var stg:Stage;
		private var itemId:int;
		private var tipsItem:TipsItem;
		private var tipsEquip:TipsEquip;
		private var tipsSkill:TipsSkill;
		private var tipsEquipEmpty:TipsEquipsEmpty;

		private var tipsItemI:TipsItem;
		private var tipsEquipI:TipsEquip;
		private var tipsEquipII:TipsEquip;


		public static function getInstance():ItemTip {
			if (!INSTANCE)
				INSTANCE=new ItemTip();

			return INSTANCE;
		}

		public function ItemTip() {
			this.init();
		}

		public function setup($stg:Stage):void {
			this.stg=$stg;
		}

		private function init():void {

			this.tipsItem=new TipsItem();
			this.tipsItem.visible=false;
			this.addChild(this.tipsItem);

			this.tipsEquip=new TipsEquip();
			this.tipsEquip.visible=false;
			this.addChild(this.tipsEquip);

			this.tipsSkill=new TipsSkill();
			this.tipsSkill.visible=false;
			this.addChild(this.tipsSkill);

			this.tipsEquipEmpty=new TipsEquipsEmpty();
			this.tipsEquipEmpty.visible=false;
			this.addChild(this.tipsEquipEmpty);

			this.tipsItemI=new TipsItem();
			this.tipsItemI.visible=false;
			this.addChild(this.tipsItemI);

			this.tipsEquipI=new TipsEquip();
			this.tipsEquipI.visible=false;
			this.addChild(this.tipsEquipI);

			this.tipsEquipII=new TipsEquip();
			this.tipsEquipII.visible=false;
			this.addChild(this.tipsEquipII);
		}

		public function show(id:int, grid:String):void {
			if (id == -1)
				return;
			this.itemId=id;
			this.stg.addChild(this);
			this.visible=true;
			var type:int;
			var info:*;
			var arr:Vector.<TClientItem>;
			switch (grid) {
				case ItemEnum.TYPE_GRID_BACKPACK: //背包格子
					info=MyInfoManager.getInstance().backpackItems[this.itemId];
					if (info == null || info.s == null)
						return;
					type=(info as TClientItem).s.type;
					if (TipsUtil.getTipsType(type) == TipsEnum.TYPE_TIPS_ITEM) {
						this.tipsItem.bagTips(info);
						this.tipsItem.visible=true;
//						arr=UIManager.getInstance().roleWnd.checkDress((info as TClientItem).s.name);
//						if (arr != null&&arr.length>=1) {
//							this.tipsItemI.bagTips(arr[0],true);
//							this.tipsItemI.visible=true;
//						}
					} else if (TipsUtil.getTipsType(type) == TipsEnum.TYPE_TIPS_EQUIP) {
						this.tipsEquip.bagTip(info);
						this.tipsEquip.visible=true;
						arr=UIManager.getInstance().roleWnd.checkDress((info as TClientItem).s.type);
						if (arr != null && arr.length >= 1) {
							this.tipsEquipI.bagTip(arr[0], true);
							this.tipsEquipI.visible=true;
							if (arr.length == 2) {
								this.tipsEquipII.bagTip(arr[1], true);
								this.tipsEquipII.visible=true;
							}
						}
					}
					break;
				case ItemEnum.TYPE_GRID_STORAGE:
					info=MyInfoManager.getInstance().backpackItems[this.itemId];
					if (info == null || info.s == null)
						return;
					type=(info as TClientItem).s.type;
					if (TipsUtil.getTipsType(type) == TipsEnum.TYPE_TIPS_ITEM) {
						this.tipsItem.bagTips(info);
						this.tipsItem.visible=true;
//						arr=UIManager.getInstance().roleWnd.checkDress((info as TClientItem).s.name);
//						if (arr != null&&arr.length>=1) {
//							this.tipsItemI.bagTips(arr[0],true);
//							this.tipsItemI.visible=true;
//						}
					} else if (TipsUtil.getTipsType(type) == TipsEnum.TYPE_TIPS_EQUIP) {
						this.tipsEquip.bagTip(info);
						this.tipsEquip.visible=true;
						arr=UIManager.getInstance().roleWnd.checkDress((info as TClientItem).s.type);
						if (arr != null && arr.length >= 1) {
							this.tipsEquipI.bagTip(arr[0], true);
							this.tipsEquipI.visible=true;
							if (arr.length == 2) {
								this.tipsEquipII.bagTip(arr[1], true);
								this.tipsEquipII.visible=true;
							}
						}
					}
					break;
				case ItemEnum.TYPE_GRID_GUILD:
					break;
				case ItemEnum.TYPE_GRID_PLAYER:
					break;
				case ItemEnum.TYPE_GRID_SHOP: //商店格子
					info=UIManager.getInstance().shopWnd.getInfoByIdx(this.itemId);
					if (info == null)
						return;
					type=(info as TStdItem).StdMode;
					if (TipsUtil.getTipsType(type) == TipsEnum.TYPE_TIPS_ITEM) { //道具
						this.tipsItem.shopTip(info);
						this.tipsItem.visible=true;
//						arr=UIManager.getInstance().roleWnd.checkDress((info as TStdItem).Name);
//						if (arr != null&&arr.length>=1) {
//							this.tipsItemI.bagTips(arr[0],true);
//							this.tipsItemI.visible=true;
//						}
					} else if (TipsUtil.getTipsType(type) == TipsEnum.TYPE_TIPS_EQUIP) { //装备
						this.tipsEquip.shopTip(info);
						this.tipsEquip.visible=true;
						arr=UIManager.getInstance().roleWnd.checkDress((info as TStdItem).StdMode);
						if (arr != null && arr.length >= 1) {
							this.tipsEquipI.bagTip(arr[0], true);
							this.tipsEquipI.visible=true;
							if (arr.length == 2) {
								this.tipsEquipII.bagTip(arr[1], true);
								this.tipsEquipII.visible=true;
							}
						}
					}
					break;
				case ItemEnum.TYPE_GRID_SKILL: //技能格子
					this.tipsSkill.skillWndTip(MyInfoManager.getInstance().skills[this.itemId]);
					this.tipsSkill.visible=true;
					break;
				case ItemEnum.TYPE_GRID_SHORTCUT:
					this.tipsSkill.skillWndTip(MyInfoManager.getInstance().skills[this.itemId], 1);
					this.tipsSkill.visible=true;
					break;
				case SkillEnum.TYPS_SKILLBTN_TIPS: //技能学习按钮
					this.tipsSkill.skillBtnTip(MyInfoManager.getInstance().skills[this.itemId]);
					this.tipsSkill.visible=true;
					break;
				case ItemEnum.TYPE_GRID_MARKET: //商城
					info=UIManager.getInstance().marketWnd.getInfoByGridId(this.itemId);
					if (info == null)
						return;
					type=(info as TShopInfo).stdInfo.StdMode;
					if (TipsUtil.getTipsType(type) == TipsEnum.TYPE_TIPS_ITEM) {
						this.tipsItem.marketTip(info, UIManager.getInstance().marketWnd.currentBtnIndex);
						this.tipsItem.visible=true;
//						arr=UIManager.getInstance().roleWnd.checkDress((info as TShopInfo).stdInfo.Name);
//						if (arr != null&&arr.length>=1) {
//							this.tipsItemI.bagTips(arr[0],true);
//							this.tipsItemI.visible=true;
//						}
					} else if (TipsUtil.getTipsType(type) == TipsEnum.TYPE_TIPS_EQUIP) {
						this.tipsEquip.marketTip(info, UIManager.getInstance().marketWnd.currentBtnIndex);
						this.tipsEquip.visible=true;
						arr=UIManager.getInstance().roleWnd.checkDress((info as TShopInfo).stdInfo.StdMode);
						if (arr != null && arr.length >= 1) {
							this.tipsEquipI.bagTip(arr[0], true);
							this.tipsEquipI.visible=true;
							if (arr.length == 2) {
								this.tipsEquipII.bagTip(arr[1], true);
								this.tipsEquipII.visible=true;
							}
						}
					}
					break;
				case ItemEnum.TYPE_GRID_EQUIP: //人物面板
					info=MyInfoManager.getInstance().equips[this.itemId];
					if ((info as TClientItem).s == null && this.itemId == 2) {
						this.itemId=14;
						info=MyInfoManager.getInstance().equips[this.itemId];
					}
					if ((info as TClientItem).s == null && this.itemId == 4) {
						this.itemId=13;
						info=MyInfoManager.getInstance().equips[this.itemId];
					}
					if ((info as TClientItem).s == null && this.itemId == 0) {

						if (MyInfoManager.getInstance().equips.length > 15) {
							this.itemId=15;
							info=MyInfoManager.getInstance().equips[this.itemId];
						}
					}
					if (info == null || (info as TClientItem).s == null) {
						this.tipsEquipEmpty.equipEmptyTips(itemId);
						this.tipsEquipEmpty.visible=true;
					} else {
						if (this.itemId == 9) {
							tipsItem.bagTips(info);
							tipsItem.visible=true;
						} else {
							this.tipsEquip.bagTip(info);
							this.tipsEquip.visible=true;
						}
					}
					break;
				case ItemEnum.TYPE_GRID_OTHER_EQUIP:
					if (this.itemId >= UIManager.getInstance().otherRoleWnd.equipInfo.length)
						return;
					info=UIManager.getInstance().otherRoleWnd.equipInfo[this.itemId];
					if (info == null || (info as TSClientItem).wIndex <= 0)
						return;
					if (this.itemId == 9) {
						this.tipsItem.otherRoleItem(info);
						this.tipsItem.visible=true;
					} else {
						this.tipsEquip.otherRoleTip(info);
						this.tipsEquip.visible=true;
					}
					break;
				case ItemEnum.TYPE_GRID_LOST:
					info=UIManager.getInstance().lostWnd.itemData[id].UserItem.toTClientItem();
					if (info == null || info.s == null)
						return;

					type=(info as TClientItem).s.type;

					if (TipsUtil.getTipsType(type) == TipsEnum.TYPE_TIPS_ITEM) {
						this.tipsItem.bagTips(info);
						this.tipsItem.visible=true;
					} else if (TipsUtil.getTipsType(type) == TipsEnum.TYPE_TIPS_EQUIP) {
						this.tipsEquip.bagTip(info);
						this.tipsEquip.visible=true;
					}
					break;
				case ItemEnum.TYPE_GRID_LOSTRENDER:
					info=UIManager.getInstance().lostWnd.itemData[id];
					if (info == null)
						return;

					this.tipsItem.LostRenderTips(info);
					this.tipsItem.visible=true;

					break;
			}
		}

		public function showString(str:String):void {
			if (str == "")
				return;
			this.visible=true;
			this.stg.addChild(this);
			this.tipsEquipEmpty.showBuffTips(str);
			this.tipsEquipEmpty.visible=true;
		}

		public function hide():void {
			this.visible=false;
			this.tipsEquip.visible=false;
			this.tipsItem.visible=false;
			this.tipsSkill.visible=false;
			this.tipsEquipEmpty.visible=false;

			this.tipsItemI.visible=false;
			this.tipsEquipI.visible=false;
			this.tipsEquipII.visible=false;
		}

		public function updataPs($x:Number, $y:Number):void {
			this.x=$x + ItemEnum.TIP_PX;
			this.y=$y + ItemEnum.TIP_PY;

			//如果超出边界、做处理
//			var sp:Sprite;
			var w:Number;
			var h:Number;
			if (this.tipsEquip.visible == true) {
				w=this.tipsEquip.width;
				h=this.tipsEquip.height;
				this.tipsEquip.x=0;
				if (this.tipsEquipI.visible == true) {
					this.tipsEquipI.x=this.tipsEquip.width;
					w+=this.tipsEquipI.width;
					if (this.tipsEquipI.height > h)
						h=this.tipsEquipI.height;
				}
				if (this.tipsEquipII.visible == true) {
					this.tipsEquipII.x=this.tipsEquipI.x + this.tipsEquipI.width;
					w+=this.tipsEquipII.width;
					if (this.tipsEquipII.height > h)
						h=this.tipsEquipII.height;
				}
				if (this.x + w > this.stg.stageWidth) {
					if (this.tipsEquipII.visible == true) {
						this.tipsEquipII.x=0;
						this.tipsEquipI.x=this.tipsEquipII.width;
						this.tipsEquip.x=this.tipsEquipI.x + this.tipsEquipI.width;
					} else if (this.tipsEquipI.visible == true) {
						this.tipsEquipI.x=0;
						this.tipsEquip.x=this.tipsEquipI.x + this.tipsEquipI.width;
					}
//					this.x=this.x-w;
				}
//				sp=this.tipsEquip;
			} else if (this.tipsItem.visible == true) {
				w=this.tipsItem.width;
				h=this.tipsItem.height;
//				if (this.tipsItemI.visible == true) {
//					this.tipsItemI.x=this.tipsItem.width;
//					w+=this.tipsItemI.width;
//					if (this.tipsItemI.height > h)
//						h=this.tipsItemI.height;
//				}
//				sp=this.tipsItem;
			} else if (this.tipsSkill.visible == true) {
				w=this.tipsSkill.width;
				h=this.tipsSkill.height;
//				sp=this.tipsSkill;
			}

			else if (this.tipsEquipEmpty.visible == true) {
				w=this.tipsEquipEmpty.width;
				h=this.tipsEquipEmpty.height;
//				sp=this.tipsEquipEmpty;
			}
//			if (sp) {
			if (this.x + w > this.stg.stageWidth)
				this.x=this.x - w;
//				this.x=this.stg.stageWidth - w;

			if (this.y + h > this.stg.stageHeight)
				this.y=this.stg.stageHeight - h;
//			}
			//			trace("x:" + this.x + "/n+y:" + this.y);
		}
	}
}
