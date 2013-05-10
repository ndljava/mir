package com.leyou.utils {
	import com.ace.enum.ItemEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.utils.HexUtil;
	import com.leyou.enum.TipsEnum;

	public class TipsUtil {
		public function TipsUtil() {
		}

		public static function getTypeName(type:int,shap:int):int {
			var name:int;
			switch (type) {
				case 0:
					name=ItemEnum.TYPE_ITEM_DRUG;
					break;
				case 1:
				case 2:
					name=ItemEnum.TYPE_ITEM_FOOD; //食物
					break;
				case 3:
					switch(shap){
						case 1:
						case 2:
						case 3://卷轴
						case 5:
						case 11:
							name=ItemEnum.TYPE_ITEM_CROLL;
							break;
						case 4:
						case 12:
						case 9://特殊药水
							name=ItemEnum.TYPE_ITEM_SPECIAL;
							break;
					}
//					name=ItemEnum.TYPE_ITEM_SCROLL_POTIONS; //药水卷轴
					break;
				case 50:
					name=ItemEnum.TYPE_ITEM_CROLL; //卷轴
					break;
				case 4:
					name=ItemEnum.TYPE_ITEM_BOOK; //书籍
					break;
				case 5:
					name=ItemEnum.TYPE_ITEM_WEAPON; //武器
					break;
				case 6:
					name=ItemEnum.TYPE_ITEM_THEROD; //法杖
					break;
				case 7:
				case 8:
				case 9:
				case 12:
				case 13:
				case 14:
				case 16:
				case 17:
				case 18:
				case 27:
				case 33:
				case 34:
				case 35:
				case 37:
				case 38:
				case 39:
				case 48:
				case 49:
				case 51:
				case 55:
				case 56:
				case 57:
				case 58:
				case 59:
				case 60:
				case 61:
					name=ItemEnum.TYPE_ITEM_UNKNOWN; //未知物品
					break;
				case 10:
					name=ItemEnum.TYPE_ITEM_DRESS_M; //衣服(男)
					break;
				case 11:
					name=ItemEnum.TYPE_ITEM_DRESS_W; //衣服(女)
					break;
				case 15:
					name=ItemEnum.TYPE_ITEM_HELMET; //头盔
					break;
				case 19:
				case 20:
				case 21:
					name=ItemEnum.TYPE_ITEM_NECKLACKE; //项链
					break;
				case 22:
				case 23:
					name=ItemEnum.TYPE_ITEM_RING; //戒指
					break;
				case 24:
				case 26:
					name=ItemEnum.TYPE_ITEM_WRISTBANDS; //护腕
					break;
				case 25:
					name=ItemEnum.TYPE_ITEM_POISON_SIGN; //毒药或符 
					break;
				case 28:
					name=ItemEnum.TYPE_ITEM_WINGS; //翅膀
					break;
				case 29:
					name=ItemEnum.TYPE_ITEM_MOUNT; //坐骑
					break;
				case 30:
					name=ItemEnum.TYPE_ITEM_ARTIFACT; //神器
					break;
				case 31:
					name=ItemEnum.TYPE_ITEM_SPECIAL; //特殊物品
					break;
				case 32:
					name=ItemEnum.TYPE_ITEM_UPGRADE_GEMS; //升级宝石
					break;
				case 36:
					name=ItemEnum.TYPE_ITEM_CLOTH; //布料
					break;
				case 40:
				case 41:
				case 43:
					name=ItemEnum.TYPE_ITEM_RAW_MATERIAL; //原料
					break;
				case 42:
					name=ItemEnum.TYPE_ITEM_MATERIAL; //材料
					break;
				case 44:
					name=ItemEnum.TYPE_ITEM_TASK_ITEN; //任务物品
					break;
				case 45:
					name=ItemEnum.TYPE_ITEM_THEDICE; //骰子类
					break;
				case 46:
				case 53:
					name=ItemEnum.TYPE_ITEM_GEM; //宝石
					break;
				case 47:
					name=ItemEnum.TYPE_ITEM_GOLD_BAR; //金条类
					break;
				case 52:
				case 62:
					name=ItemEnum.TYPE_ITEM_SHOES; //鞋子
					break;
				case 54:
				case 64:
					name=ItemEnum.TYPE_ITEM_BELT; //腰带
					break;
				case 53:
				case 63:
					name=ItemEnum.TYPE_ITEM_SHIELD; //盾牌
					break;
			}
			return name;
		}

		public static function getLimitType(type:int):String {
			switch (type) {
				case 0:
					return "等级限制:";
					break;
				case 1:
					return "攻击限制:";
					break;
				case 2:
					return "魔法限制:";
					break;
				case 3:
					return "道术限制:";
					break;
			}
			return null;
		}

		/**
		 *
		 * @param flag
		 * @return
		 *
		 */
		public static function getInstructionByFlag(flag:int, itemType:int):String {
			var contion:Array=new Array();
			var arr:Array=flag.toString(2).split(""); //有几个显示几个
			while (arr.length < 8)
				arr.unshift(0);
			//禁止爆出、禁止脱下、静止出售、禁止修理、禁止存仓、禁止交易、禁止丢弃、禁止日志
			if (arr[6] == 1 && arr[5] == 1 && arr[0] == 1 && arr[2] == 1) {
				contion.push("已绑定");
				if (itemType == TipsEnum.TYPE_TIPS_EQUIP && arr[1] == 1)
					contion.push("禁止脱下");
				if (arr[3] == 1 && itemType == TipsEnum.TYPE_TIPS_EQUIP)
					contion.push("禁止修理");
				if (arr[4] == 1)
					contion.push("禁止存仓");
			} else {
				if (arr[0] == 1)
					contion.push("禁止爆出");
				if (itemType == TipsEnum.TYPE_TIPS_EQUIP && arr[1] == 1)
					contion.push("禁止脱下");
				if (arr[2] == 1)
					contion.push("禁止出售");
				if (arr[3] == 1 && itemType == TipsEnum.TYPE_TIPS_EQUIP)
					contion.push("禁止修理");
				if (arr[4] == 1)
					contion.push("禁止存仓");
				if (arr[5] == 1)
					contion.push("禁止交易");
				if (arr[6] == 1)
					contion.push("禁止丢弃");
			}
			var str:String=new String();
			for (var i:int=0; i < contion.length; i++) {
				if (i == contion.length - 1)
					str+=contion[i];
				else
					str+=contion[i] + "<br>";
			}
			return str;
		}

		public static function getLimitStr(need:int, needLv:int,f:Boolean=true):Array {
			var arr:Array=new Array();
			var num:int;
			switch (need) {
				case 0:
//					if(MyInfoManager.getInstance().level>=needLv)
//						arr.push(getColorStr("需要等级：" + needLv,TipsEnum.COLOR_GREEN));
//					else arr.push(getColorStr("需要等级：" + needLv,TipsEnum.COLOR_WHITE));
					if(f){
						if (MyInfoManager.getInstance().level < needLv)
							arr.push(getColorStr("需要等级：" + needLv, TipsEnum.COLOR_RED));
						else
							arr.push(getColorStr("需要等级：" + needLv, TipsEnum.COLOR_GREEN));
					}
					else arr.push(getColorStr("需要等级：" + needLv, TipsEnum.COLOR_GREEN));
					break;
				case 1:
					if(f){
						num=HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.DC);
						if ( num< needLv)
							arr.push(getColorStr("需要攻击力：" + needLv, TipsEnum.COLOR_RED));
						else
							arr.push(getColorStr("需要攻击力：" + needLv, TipsEnum.COLOR_GREEN));
					}
					else arr.push(getColorStr("需要攻击力：" + needLv, TipsEnum.COLOR_GREEN));
					break;
				case 2:
					if(f){
						num=MyInfoManager.getInstance().baseInfo.MaxMP
						if ( num< needLv)
							arr.push(getColorStr("需要魔法力：" + needLv, TipsEnum.COLOR_RED));
						else
							arr.push(getColorStr("需要魔法力：" + needLv, TipsEnum.COLOR_GREEN));
					}
					else arr.push(getColorStr("需要魔法力：" + needLv, TipsEnum.COLOR_GREEN));
					break;
				case 3:
					if(f){
						num=HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.SC)
						if (num < needLv)
							arr.push(getColorStr("需要道术：" + needLv, TipsEnum.COLOR_RED));
						else
							arr.push(getColorStr("需要道术：" + needLv, TipsEnum.COLOR_GREEN));
					}
					else arr.push(getColorStr("需要道术：" + needLv, TipsEnum.COLOR_GREEN));
					break;
				case 4:
					if(f){
						//暂无转生等级吧？？？
						arr.push(getColorStr("需要转生等级：" + needLv, TipsEnum.COLOR_RED));
					}
					else //暂无转生等级吧？？？
						arr.push(getColorStr("需要转生等级：" + needLv, TipsEnum.COLOR_GREEN));
					break;
				case 5:
					if(f){
						if (MyInfoManager.getInstance().baseInfo.creditValue > needLv)
							arr.push(getColorStr("需要声望点：" + needLv, TipsEnum.COLOR_RED));
						else
							arr.push(getColorStr("需要声望点：" + needLv, TipsEnum.COLOR_GREEN));
					}
					else arr.push(getColorStr("需要声望点：" + needLv, TipsEnum.COLOR_GREEN));
					break;
				case 6:
					if(f){
						if (MyInfoManager.getInstance().hasGuild)
							arr.push(getColorStr("佩戴条件：拥有行会", TipsEnum.COLOR_GREEN));
						else
							arr.push(getColorStr("佩戴条件：拥有行会", TipsEnum.COLOR_RED));
					}
					else arr.push(getColorStr("佩戴条件：拥有行会", TipsEnum.COLOR_RED));
					break;
				case 7:
					if(f){
						//暂无沙城会员属性吧？？？？、
						arr.push(getColorStr("佩戴条件：沙城会员", TipsEnum.COLOR_RED));
					}
					else arr.push(getColorStr("佩戴条件：沙城会员", TipsEnum.COLOR_GREEN));
					break;
				case 8:
					if(f){
						//暂无会员属性 稍后做
						if (MyInfoManager.getInstance().isMember)
							arr.push(getColorStr("会员：" + needLv, TipsEnum.COLOR_GREEN));
						else
							arr.push(getColorStr("会员：" + needLv, TipsEnum.COLOR_RED));
					}
					else arr.push(getColorStr("会员：" + needLv, TipsEnum.COLOR_RED));
					break;
				case 10:
					arr.push("需要职业：" + needLv);
					arr.push("需要等级：" + needLv);
					break;
				case 11:
					arr.push("需要职业：" + needLv);
					arr.push("需要攻击力：" + needLv);
					break;
				case 12:
					arr.push("需要职业：" + needLv);
					arr.push("需要魔法力：" + needLv);
					break;
				case 13:
					arr.push("需要职业：" + needLv);
					arr.push("需要道术：" + needLv);
					break;
				case 40:
					arr.push("需要转生等级：" + needLv);
					arr.push("需要等级：" + needLv);
					break;
				case 41:
					arr.push("需要转生等级：" + needLv);
					arr.push("需要攻击力：" + needLv);
					break;
				case 42:
					arr.push("需要转生等级：" + needLv);
					arr.push("需要魔法力：" + needLv);
					break;
				case 43:
					arr.push("需要转生等级：" + needLv);
					arr.push("需要道术：" + needLv);
					break;
				case 44:
					arr.push("需要转生等级：" + needLv);
					arr.push("需要声望点：" + needLv);
					break;
				case 60:
					arr.push("佩戴条件：行会掌门");
					break;
				case 70:
					arr.push("佩戴条件：沙城城主");
					break;
			}
			return arr;
		}

		public static function getColorStr(str:String, color:String):String {
			return "<font color='" + color + "'>" + str + "</font>";
		}

		public static function getProperNum(info:TItemInfo):Array {
			var tInfo:TItemInfo=TableManager.getInstance().getItemInfo(info.id);
			var arr:Array=[];
			if (info.type == ItemEnum.ITEM_TYPE_DRUG) { //药品
				if (info.ac != 0)
					arr.push(getProperKey(info.ac, tInfo.ac, "HP回复：", false));
				if (info.mac != 0) 
					arr.push(getProperKey(info.mac, tInfo.mac, "MP回复：", false));
			} else if (info.type == ItemEnum.ITEM_TYPE_POTION_OR_SCROLL && info.shape == 12) { //如果是苹果
				if (info.ac != 0) 
					arr.push(getProperKey(info.ac, tInfo.ac, "HP增加：", false));
				if (info.ac2 != 0) 
					arr.push(getProperKey(info.ac2, tInfo.ac2, "攻速增加：", false));
				if (info.mac != 0) 
					arr.push(getProperKey(info.mac, tInfo.mac, "MP增加：", false));
				if (info.dc != 0) 
					arr.push(getProperKey(info.dc, tInfo.dc, "物攻增加：", false));
				if (info.mc != 0) 
					arr.push(getProperKey(info.mc, tInfo.mc, "魔攻增加：", false));
				if (info.sc != 0) 
					arr.push(getProperKey(info.sc, tInfo.sc, "道术增加：", false));
			} else if (info.type == ItemEnum.ITEM_TYPE_WEAPON_I || info.type == ItemEnum.ITEM_TYPE_WEAPON_II) { //武器
				if (info.dc != 0 || info.dc2 != 0)
					arr.push(getProperBaseKey(info.dc, info.dc2, tInfo.dc2, "物攻："));
				if (info.mc != 0 || info.mc2 != 0)
					arr.push(getProperBaseKey(info.mc, info.mc2, tInfo.mc2, "魔攻："));
				if (info.sc != 0 || info.sc2 != 0)
					arr.push(getProperBaseKey(info.sc, info.sc2, tInfo.sc2, "道术："));
				if (info.ac2 > 0)
					arr.push(getProperKey(info.ac2, tInfo.ac2, "准确：", false));
				if (info.ac > 0)
					arr.push(getProperKey(info.ac, tInfo.ac, "幸运：", false));
				if (info.mac > 0)
					arr.push(getProperKey(info.mac, tInfo.mac, "诅咒：", false));
				if (info.mac2 > 0)
					arr.push(getColorStr("攻击速度：-" + info.mac2, TipsEnum.COLOR_GOLD));
				if (info.source > 0)
					arr.push(getColorStr("强度：+" + info.source, TipsEnum.COLOR_GOLD));
				else if (info.source < 0)
					arr.push(getColorStr("神圣：" + Math.abs(info.source), TipsEnum.COLOR_GOLD));				
			} else if (info.type == ItemEnum.ITEM_TYPE_SHIELD) { //盾牌
				if (info.dc != 0 || info.dc2 != 0)
					arr.push(getProperBaseKey(info.dc, info.dc2, tInfo.dc2, "物攻："));
				if (info.mc != 0 || info.mc2 != 0)
					arr.push(getProperBaseKey(info.mc, info.mc2, tInfo.mc2, "魔攻："));
				if (info.sc != 0 || info.sc2 != 0)
					arr.push(getProperBaseKey(info.sc, info.sc2, tInfo.sc2, "道术："));
				if (info.mac > 0)
					arr.push(getProperKey(info.mac, tInfo.mac, "诅咒：", false));
				if (info.mac2 > 0)
					arr.push(getProperKey(info.mac2, tInfo.mac2, "幸运：", false));
			} else if (info.type == ItemEnum.ITEM_TYPE_NECKLACE_I || info.type == ItemEnum.ITEM_TYPE_NECKLACE_II || info.type == ItemEnum.ITEM_TYPE_NECKLACE_III || info.type == ItemEnum.ITEM_TYPE_WRIST_I) { //19
				if (info.dc != 0 || info.dc2 != 0) 
					arr.push(getProperBaseKey(info.dc, info.dc2, tInfo.dc2, "物攻："));
				if (info.mc != 0 || info.mc2 != 0) 
					arr.push(getProperBaseKey(info.mc, info.mc2, tInfo.mc2, "魔攻："));
				if (info.sc != 0 || info.sc2 != 0) 
					arr.push(getProperBaseKey(info.mc, info.sc2, tInfo.sc2, "道术："));
				if (info.type == ItemEnum.ITEM_TYPE_NECKLACE_I) {
					if (info.mac2 > 0)
						arr.push(getProperKey(info.mac2, tInfo.mac2, "幸运：", false));
					if (info.mac > 0)
						arr.push(getProperKey(info.mac, tInfo.mac, "诅咒：", false));
					
					if (info.ac2 > 0)
						arr.push(getProperKey(info.ac2, tInfo.ac2, "魔法躲避：", true));
				} else if (info.type == ItemEnum.ITEM_TYPE_NECKLACE_II || info.type == ItemEnum.ITEM_TYPE_WRIST_I) {
					if (info.ac2 > 0)
						arr.push(getProperKey(info.ac2, tInfo.ac2, "准确：", false));
					if (info.mac2 > 0)
						arr.push(getProperKey(info.mac2, tInfo.mac2, "敏捷：", false));
				} else if (info.type == ItemEnum.ITEM_TYPE_NECKLACE_III) {
					if (info.ac > 0)
						arr.push(getColorStr("攻击速度：+" + info.ac, TipsEnum.COLOR_GOLD));
					if (info.mac > 0)
						arr.push(getColorStr("攻击速度：-" + info.mac, TipsEnum.COLOR_GOLD));
					if (info.ac2 > 0)
						arr.push(getProperKey(info.ac2, tInfo.ac2, "体力恢复：", true));
					if (info.mac2 > 0)
						arr.push(getProperKey(info.mac2, tInfo.mac2, "魔法恢复：", false));
				}
			} else if (info.type == ItemEnum.ITEM_TYPE_SHOE) { //鞋
				if (info.ac != 0 || info.ac2 != 0)
					arr.push(getProperBaseKey(info.ac, info.ac2, tInfo.ac2, "防御："));
				if (info.mac != 0 || info.mac2 != 0)
					arr.push(getProperBaseKey(info.mac, info.mac2, tInfo.mac2, "魔防："));
				if (info.dc > 0)
					arr.push(getProperKey(info.dc, tInfo.dc, "准确：", false));
				if (info.mc > 0)
					arr.push(getProperKey(info.mc, tInfo.mc, "敏捷：", false));
				if (info.sc > 0)
					arr.push(getProperKey(info.sc, tInfo.sc, "魔法躲避：", true));
			} else if (info.type == ItemEnum.ITEM_TYPE_BELT) { //腰带
				if (info.ac != 0 || info.ac2 != 0)
					arr.push(getProperBaseKey(info.ac, info.ac2, tInfo.ac2, "防御："));
				if (info.mac != 0 || info.mac2 != 0)
					arr.push(getProperBaseKey(info.mac, info.mac2, tInfo.mac2, "魔防："));
				if (info.dc > 0)
					arr.push(getProperKey(info.dc, tInfo.dc, "体力恢复：", true));
				if (info.mc > 0)
					arr.push(getProperKey(info.mc, tInfo.mc, "魔法恢复：", true));
				if (info.sc > 0)
					arr.push(getProperKey(info.sc, tInfo.sc, "中毒恢复：", true));
			} else {
				if (info.ac != 0 || info.ac2 != 0)
					arr.push(getProperBaseKey(info.ac, info.ac2, tInfo.ac2, "防御："));
				if (info.mac != 0 || info.mac2 != 0)
					arr.push(getProperBaseKey(info.mac, info.mac2, tInfo.mac2, "魔防："));
				if (info.dc != 0 || info.dc2 != 0)
					arr.push(getProperBaseKey(info.dc, info.dc2, tInfo.dc2, "物攻："));
				if (info.mc != 0 || info.mc2 != 0)
					arr.push(getProperBaseKey(info.mc, info.mc2, tInfo.mc2, "魔攻："));
				if (info.sc != 0 || info.sc2 != 0)
					arr.push(getProperBaseKey(info.sc, info.sc2, tInfo.sc2, "道术："));
			}
			return arr;
		}

		private static function getProperKey(cur:int, tkey:int, name:String, flag:Boolean=false):String {
			var str:String;
			if (cur > tkey) {
				if (flag)
					str=getColorStr(name + tkey + "0%", TipsEnum.COLOR_GOLD) + getColorStr("+" + (cur - tkey) + "0%", TipsEnum.COLOR_PINK);
				else
					str=getColorStr(name + tkey, TipsEnum.COLOR_GOLD) + getColorStr("+" + (cur - tkey), TipsEnum.COLOR_PINK);
			} else {
				if (flag)
					str=getColorStr(name + tkey + "0%", TipsEnum.COLOR_GOLD);
				else
					str=getColorStr(name + tkey, TipsEnum.COLOR_GOLD);
			}
			return str;
		}

		private static function getProperBaseKey(key:int, key2:int, tKey:int, name:String):String {
			var str:String;
			if (key2 > tKey)
				str=getColorStr(name + key + "-" + tKey, TipsEnum.COLOR_GOLD) + getColorStr("+" + (key2 - tKey), TipsEnum.COLOR_PINK);
			else
				str=getColorStr(name + key + "-" + key2, TipsEnum.COLOR_GOLD);
			return str;
		}
		
		public static function getTipsType(type:int):int {
			var f:int;
			switch (type) {
				case 5:
				case 6:
				case 10:
				case 11:
				case 15:
				case 19:
				case 20:
				case 21:
				case 22:
				case 23:
				case 24:
				case 26:
				case 28:
				case 29:
				case 30:
//				case 32:
				case 52:
				case 54:
				case 62:
				case 63:
				case 64:
					f=TipsEnum.TYPE_TIPS_EQUIP;
					break;
				default:
					f=TipsEnum.TYPE_TIPS_ITEM;
					break;
			}
			return f;
		}

		public static function checkItem(arr:Array, num:int):Boolean {
			var item:TClientItem;
			var bagNum:int;
			for (var i:int=0; i < arr.length; i++) {
				item=null;
				bagNum=0;
				item=MyInfoManager.getInstance().getItemByItemName(arr[i]);
				if (item != null) {
					bagNum=item.Dura
					if (num <= bagNum) {
						return true;
					} else if (arr.length == 2) {
						item=MyInfoManager.getInstance().equips[ItemEnum.U_BUJUK];
						if (item) {
							if (num <= bagNum + item.Dura)
								return true;
						}
					}
				} else if (arr.length == 2) {
					item=MyInfoManager.getInstance().equips[ItemEnum.U_BUJUK];
					if (item) {
						if (num <= item.Dura)
							return true;
					}
				}
			}
			return false;
		}

		public static function getBookNameByRace(i:int):String {
//			0	战士秘籍
//			1	法师秘籍
//			2	道士秘籍

			if (i == 0)
				return "战士秘籍";
			if (i == 1)
				return "法师秘籍";
			if (i == 2)
				return "道士秘籍";
			return null;
		}
	}
}