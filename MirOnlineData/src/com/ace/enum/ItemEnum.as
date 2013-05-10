package com.ace.enum {
	import flash.utils.Dictionary;

	public class ItemEnum {

		public static const TYPE_GRID_BASE:String="baseGrid";
		public static const TYPE_GRID_BACKPACK:String="backpackGrid";
		public static const TYPE_GRID_STORAGE:String="storageGrid";
		public static const TYPE_GRID_PLAYER:String="playerGrid";
		public static const TYPE_GRID_SKILL:String="skillGrid";
		public static const TYPE_GRID_SHORTCUT:String="shortcutGrid";
		public static const TYPE_GRID_TRADE:String="tradeGrid";
		public static const TYPE_GRID_SHOP:String="shopGrid";
		public static const TYPE_GRID_STALL:String="stallGrid";
		public static const TYPE_GRID_GUILD:String="guildGrid";
		public static const TYPE_GRID_MARKET:String="marketGrid";
		public static const TYPE_GRID_EQUIP:String="EquipGrid";

		public static const TYPE_GRID_OTHER_EQUIP:String="otherEquip";
		public static const TYPE_GRID_FORGE:String="forgeGrid";
		public static const TYPE_GRID_LOST:String="lostGrid";
		public static const TYPE_GRID_LOSTRENDER:String="lostrenderGrid";
		
		//物品分类 0/1/2/3：药， 5/6:武器，10/11：盔甲，15：头盔，22/23：戒指，24/26：手镯，19/20/21：项链
		//		public static const TYPE_ITEM_DRUG:int=0;
		//		public static const TYPE_ITEM_WEAPON:int=0;
		//		public static const TYPE_ITEM_ARMOUR:int=0;
		//		public static const TYPE_ITEM_ARMET:int=0;
		//		public static const TYPE_ITEM_RING:int=0;
		//		public static const TYPE_ITEM_BANGLE:int=0;
		//		public static const TYPE_ITEM_NECKLACE:int=0;

		public static const ITEM_BG_WIDTH:int=38;
		public static const ITEM_BG_HEIGHT:int=38;

		public static const ITEM_ICO_WIDTH:int=33;
		public static const ITEM_ICO_HEIGHT:int=33;

		public static const GRID_HORIZONTAL:int=7;
		public static const GRID_SPACE:int=3;

		public static const BACKPACK_GRID_TOTAL:int=70;
		public static const BACKPACK_GRID_OPEN:int=46;

		public static const STORAGE_GRIDE_TOTAL:int=70;
		public static const STORAGE_GRIDE_OPEN:int=42;


		public static const TIP_PX:int=12;
		public static const TIP_PY:int=22;


		//public static const //装备项目
		public static const U_DRESS:uint=0; //衣服
		public static const U_WEAPON:uint=1; //武器
		public static const U_RIGHTHAND:uint=2; //右手
		public static const U_NECKLACE:uint=3; //项链
		public static const U_HELMET:uint=4; //头盔
		public static const U_ARMRINGL:uint=5; //左手手镯,符
		public static const U_ARMRINGR:uint=6; //右手手镯
		public static const U_RINGL:uint=7; //左戒指
		public static const U_RINGR:uint=8; //右戒指
		public static const U_BUJUK:uint=9; //物品
		public static const U_BELT:uint=10; //腰带
		public static const U_BOOTS:uint=11; //鞋
		public static const U_CHARM:uint=12; //宝石
		public static const U_ZHULI:uint=13; //斗笠
		public static const U_HORSE:uint=14; //马牌
		public static const U_ITEM:uint=15; //道具
		public static const U_Pf:uint=16;
		public static const U_Cs:uint=17;
		public static const U_Zp:uint=18;
		public static const U_Fw:uint=19;
		public static const U_St:uint=20;
		public static const U_Kz:uint=21;
		public static const U_Fs:uint=22;

		public static const TYPE_ITEM_FOOD:int=0; //食物
		public static const TYPE_ITEM_CROLL:int=1; //卷轴
		public static const TYPE_ITEM_BOOK:int=2; //书籍
		public static const TYPE_ITEM_WEAPON:int=3; //武器
		public static const TYPE_ITEM_THEROD:int=4; //法杖
		public static const TYPE_ITEM_UNKNOWN:int=5; //未知物品
		public static const TYPE_ITEM_DRESS_M:int=6; //衣服(男)
		public static const TYPE_ITEM_DRESS_W:int=7; //衣服(女)
		public static const TYPE_ITEM_HELMET:int=8; //头盔
		public static const TYPE_ITEM_NECKLACKE:int=9; //项链
		public static const TYPE_ITEM_RING:int=10; //戒指
		public static const TYPE_ITEM_WRISTBANDS:int=11; //护腕
		public static const TYPE_ITEM_POISON_SIGN:int=12; //毒药或符 
		public static const TYPE_ITEM_WINGS:int=13; //翅膀
		public static const TYPE_ITEM_MOUNT:int=14; //坐骑
		public static const TYPE_ITEM_ARTIFACT:int=15; //神器
		public static const TYPE_ITEM_SPECIAL:int=16; //特殊物品
		public static const TYPE_ITEM_UPGRADE_GEMS:int=17; //升级宝石
		public static const TYPE_ITEM_CLOTH:int=18; //布料
		public static const TYPE_ITEM_RAW_MATERIAL:int=19; //原料
		public static const TYPE_ITEM_MATERIAL:int=20; //材料
		public static const TYPE_ITEM_TASK_ITEN:int=21; //任务物品
		public static const TYPE_ITEM_THEDICE:int=22; //骰子类
		public static const TYPE_ITEM_GEM:int=23; //宝石
		public static const TYPE_ITEM_GOLD_BAR:int=24; //金条类
		public static const TYPE_ITEM_SHOES:int=25; //鞋子
		public static const TYPE_ITEM_BELT:int=26; //腰带
		public static const TYPE_ITEM_SHIELD:int=27; //盾牌
		public static const TYPE_ITEM_SCROLL_POTIONS:int=28; //药品卷轴
		public static const TYPE_ITEM_DRUG:int=29;//物品
		public static const TYPE_ITEM_SPECIAL_DRUG:int=30;//特殊药水
		private static var _itemNameDic:Object;

		public static function get itemNameDic():Object {
			if (_itemNameDic != null)
				return _itemNameDic;
			_itemNameDic=new Object();
			_itemNameDic[ItemEnum.TYPE_ITEM_FOOD]="食物";
			_itemNameDic[ItemEnum.TYPE_ITEM_CROLL]="卷轴";
			_itemNameDic[ItemEnum.TYPE_ITEM_BOOK]="书籍";
			_itemNameDic[ItemEnum.TYPE_ITEM_WEAPON]="武器"
			_itemNameDic[ItemEnum.TYPE_ITEM_THEROD]="法杖";
			_itemNameDic[ItemEnum.TYPE_ITEM_UNKNOWN]="未知物品";
			_itemNameDic[ItemEnum.TYPE_ITEM_DRESS_M]="衣服(男)";
			_itemNameDic[ItemEnum.TYPE_ITEM_DRESS_W]="衣服(女)";
			_itemNameDic[ItemEnum.TYPE_ITEM_HELMET]="头盔";
			_itemNameDic[ItemEnum.TYPE_ITEM_NECKLACKE]="项链";
			_itemNameDic[ItemEnum.TYPE_ITEM_RING]="戒指";
			_itemNameDic[ItemEnum.TYPE_ITEM_WRISTBANDS]="护腕";
			_itemNameDic[ItemEnum.TYPE_ITEM_POISON_SIGN]="毒药或符 ";
			_itemNameDic[ItemEnum.TYPE_ITEM_WINGS]="翅膀";
			_itemNameDic[ItemEnum.TYPE_ITEM_MOUNT]="坐骑";
			_itemNameDic[ItemEnum.TYPE_ITEM_ARTIFACT]="神器";
			_itemNameDic[ItemEnum.TYPE_ITEM_SPECIAL]="特殊物品";
			_itemNameDic[ItemEnum.TYPE_ITEM_UPGRADE_GEMS]="升级宝石";
			_itemNameDic[ItemEnum.TYPE_ITEM_CLOTH]="布料";
			_itemNameDic[ItemEnum.TYPE_ITEM_RAW_MATERIAL]="原料";
			_itemNameDic[ItemEnum.TYPE_ITEM_MATERIAL]="材料";
			_itemNameDic[ItemEnum.TYPE_ITEM_TASK_ITEN]="任务物品";
			_itemNameDic[ItemEnum.TYPE_ITEM_THEDICE]="骰子类";
			_itemNameDic[ItemEnum.TYPE_ITEM_GEM]="宝石";
			_itemNameDic[ItemEnum.TYPE_ITEM_GOLD_BAR]="金条类";
			_itemNameDic[ItemEnum.TYPE_ITEM_SHOES]="鞋子";
			_itemNameDic[ItemEnum.TYPE_ITEM_BELT]="腰带";
			_itemNameDic[ItemEnum.TYPE_ITEM_SHIELD]="盾牌";
			_itemNameDic[ItemEnum.TYPE_ITEM_SCROLL_POTIONS]="药水卷轴";
			_itemNameDic[TYPE_ITEM_DRUG]="药品";
			_itemNameDic[TYPE_ITEM_SPECIAL]="特殊药水";
			return _itemNameDic;
		}
		private static var _equipPos:Object;

		public static function get equipPos():Object {
			if (_equipPos != null)
				return _equipPos;
			_equipPos=new Object();
			_equipPos[5]=U_WEAPON; //武器
			_equipPos[6]=U_WEAPON; //法杖
			_equipPos[10]=U_DRESS; //男衣
			_equipPos[11]=U_DRESS; //女衣
			_equipPos[15]=U_HELMET; //头盔
			_equipPos[19]=U_NECKLACE; //项链
			_equipPos[20]=U_NECKLACE; //项链s
			_equipPos[21]=U_BUJUK; //特殊项链
			_equipPos[22]=U_RINGL; //戒指
			_equipPos[23]=U_RINGL; //戒指
			_equipPos[24]=U_ARMRINGL; //手镯

			_equipPos[25]=U_BUJUK; //毒药 附s
			_equipPos[26]=U_ARMRINGL; //手镯
			_equipPos[29]=U_HORSE; //马牌
			_equipPos[30]=U_HORSE; //神器
			_equipPos[46]=U_CHARM; //宝石
			_equipPos[52]=U_BOOTS; //鞋子
			_equipPos[53]=U_CHARM; //宝石
			_equipPos[54]=U_BELT; //腰带
			_equipPos[62]=U_BOOTS; //鞋子
			_equipPos[63]=U_CHARM; //盾牌
			_equipPos[64]=U_BELT; //腰带
			return _equipPos;
		}

		public static const ITEM_TYPE_DRUG:int=0; //药品
		public static const ITEM_TYPE_FOOD_I:int=1; //食物
		public static const ITEM_TYPE_FOOD_II:int=2; //食物
		public static const ITEM_TYPE_POTION_OR_SCROLL:int=3; //药水与卷轴
		public static const ITEN_TYPE_BOOK:int=4; //书籍
		public static const ITEM_TYPE_POTION_OR_SIGN:int=5; //毒药或者符
		public static const ITEM_TYPE_BUNDL_ITEM:int=31; //捆装物品
		public static const ITEM_TYPE_TASK_ITEM:int=36; //任务物品
		public static const ITEM_TYPE_ACTIVE_ITEM:int=41; //活动物品
		public static const ITEM_TYPE_MATERIAL:int=42; //材料material
		public static const ITEM_TYPE_SPECIAL_ITEM:int=45; //特殊物品
		public static const ITEM_TYPE_ILLEGAL_ITEM:int=47; //非法道具Illegal items
		public static const ITEM_TYPE_WEAPON_I:int=5; //武器weapons
		public static const ITEM_TYPE_WEAPON_II:int=6; //武器
		public static const ITEM_TYPE_SHIELD:int=63; //盾牌shield
		public static const ITEM_TYPE_NECKLACE_I:int=19; //项链
		public static const ITEM_TYPE_NECKLACE_II:int=20; //项链
		public static const ITEM_TYPE_WRIST_I:int=24; //护腕
		public static const ITEM_TYPE_NECKLACE_III:int=21; //项链
		public static const ITEM_TYPE_RING_I:int=22; //戒指
		public static const ITEM_TYPE_RING_II:int=23; //戒指
		public static const ITEM_TYPE_WRIST_II:int=26; //护腕
		public static const ITEM_TYPE_CLOTH_MEN:int=10; //衣服男
		public static const ITEM_TYPE_CLOTH_WOMEN:int=11; //衣服女
		public static const ITEM_TYPE_HELM:int=15; //头盔
		public static const ITEM_TYPE_SHOE:int=62; //鞋
		public static const ITEM_TYPE_BELT:int=64; //腰带
	}
}