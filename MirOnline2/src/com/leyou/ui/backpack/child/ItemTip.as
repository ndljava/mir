package com.leyou.ui.backpack.child {
	import com.ace.enum.ItemEnum;
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
		}

		public function show(id:int, grid:String):void {
			if (id == -1)
				return
			this.itemId=id;
			this.stg.addChild(this);
			this.visible=true;
			var type:int;
			var info:*;
			switch (grid) {
				case ItemEnum.TYPE_GRID_BACKPACK: //背包格子
					info=MyInfoManager.getInstance().backpackItems[this.itemId];
					if (info == null || info.s==null)
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
				case ItemEnum.TYPE_GRID_STORAGE:
					info=MyInfoManager.getInstance().backpackItems[this.itemId];
					if (info == null || info.s==null)
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
					} else if (TipsUtil.getTipsType(type) == TipsEnum.TYPE_TIPS_EQUIP) { //装备
						this.tipsEquip.shopTip(info);
						this.tipsEquip.visible=true;
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
					} else if (TipsUtil.getTipsType(type) == TipsEnum.TYPE_TIPS_EQUIP) {
						this.tipsEquip.marketTip(info,UIManager.getInstance().marketWnd.currentBtnIndex);
						this.tipsEquip.visible=true;
					}
					break;
				case ItemEnum.TYPE_GRID_EQUIP: //人物面板
					info=MyInfoManager.getInstance().equips[this.itemId];
					if((info as TClientItem).s==null&&this.itemId==2){
						this.itemId=14;
						info=MyInfoManager.getInstance().equips[this.itemId];
					}
					if((info as TClientItem).s==null&&this.itemId==4){
						this.itemId=13;
						info=MyInfoManager.getInstance().equips[this.itemId];
					}
					if((info as TClientItem).s==null&&this.itemId==0){
						
						if(MyInfoManager.getInstance().equips.length>15){
							this.itemId=15;
							info=MyInfoManager.getInstance().equips[this.itemId];
						}	
					}
					if (info == null|| (info as TClientItem).s == null){
						this.tipsEquipEmpty.equipEmptyTips(itemId);
						this.tipsEquipEmpty.visible=true;
					}
					else{
						this.tipsEquip.bagTip(info);
						this.tipsEquip.visible=true;
					}
					break;
				case ItemEnum.TYPE_GRID_OTHER_EQUIP:
					if(this.itemId>=UIManager.getInstance().otherRoleWnd.equipInfo.length)
						return;
					info=UIManager.getInstance().otherRoleWnd.equipInfo[this.itemId];
					if(info==null||(info as TSClientItem).wIndex<=0)
						return;
					this.tipsEquip.otherRoleTip(info);
					this.tipsEquip.visible=true;
					break;
			}
		}

		public function hide():void {
			this.visible=false;
			this.tipsEquip.visible=false;
			this.tipsItem.visible=false;
			this.tipsSkill.visible=false;
			this.tipsEquipEmpty.visible=false;
		}

		public function updataPs($x:Number, $y:Number):void {
			this.x=$x + ItemEnum.TIP_PX;
			this.y=$y + ItemEnum.TIP_PY;

			//如果超出边界、做处理
			var sp:Sprite;
			if (this.tipsEquip.visible == true)
				sp=this.tipsEquip;
			else if (this.tipsItem.visible == true)
				sp=this.tipsItem;
			else if (this.tipsSkill.visible == true)
				sp=this.tipsSkill;

			if (sp) {
				if (this.x + sp.width > this.stg.stageWidth)
					this.x=this.stg.stageWidth - sp.width;
				if (this.y + sp.height > this.stg.stageHeight)
					this.y=this.stg.stageHeight - sp.height;
			}
		}
	}
}
