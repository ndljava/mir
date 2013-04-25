package com.leyou.utils {
	import com.ace.enum.ItemEnum;
	import com.leyou.net.MirProtocol;

	public class ItemUtil {

		public static var EQUIP_TYPE:Array=[5, 6, 10, 11, 15, 19, 20, 21, 22, 23, 24, 26, 28, 29, 30, 52, 53, 54, 62, 63, 64];
		public static var ITEM_TOOL:Array=[0, 1, 2, 3];

		public function ItemUtil() {
		}

		static public function getTakeOnPosition(smode:int):int {
			var result:int;
			switch (smode) {
				case 5:
				case 6:
					result=ItemEnum.U_WEAPON;
					break;
				case 10:
				case 11:
					result=ItemEnum.U_DRESS;
					break;
				case 15:
					result=ItemEnum.U_HELMET;
					break;
				case 16:
					result=ItemEnum.U_ZHULI;
					break;
				case 19:
				case 20:
				case 21:
					result=ItemEnum.U_NECKLACE;
					break;
				case 22:
				case 23:
					result=ItemEnum.U_RINGL;
					break;
				case 24:
				case 26:
					result=ItemEnum.U_ARMRINGL;
					break;
				case 30:
					result=ItemEnum.U_RIGHTHAND;
					break;
				case 25:
				case 2:
					result=ItemEnum.U_BUJUK;
					break;
				case 52:
				case 62:
					result=ItemEnum.U_BOOTS;
					break;
				case 53:
				case 63:
					result=ItemEnum.U_CHARM;
					break;
				case 54:
				case 64:
					result=ItemEnum.U_BELT;
					break;
				case 42:
				case 3:
				case 41:
					result=MirProtocol.X_RepairFir;
					break;
				case 29:
					result=ItemEnum.U_HORSE;
					break;
				case 7:
					result=ItemEnum.U_ITEM - 3;
					break;
			}
			return result;
		}

		public static function getTypeByPos(pos:int):int {
			var id:int;
			switch (pos) {
				case 5: //头盔
					id=ItemEnum.U_HELMET;
					break;
				case 1: //衣服
					id=ItemEnum.U_DRESS;
					break;
				case 2: //左手镯
					id=ItemEnum.U_ARMRINGL;
					break;
				case 3: //左手戒指
					id=ItemEnum.U_RINGL;
					break;
				case 10: //腰带
					id=ItemEnum.U_BELT;
					break;
				case 6: //项链
					id=ItemEnum.U_NECKLACE;
					break;
				case 9: //勋章 马牌
					id=ItemEnum.U_RIGHTHAND;
					break;
				case 7: //右手镯
					id=ItemEnum.U_ARMRINGR;
					break;
				case 8: //右手戒指
					id=ItemEnum.U_RINGR;
					break;
				case 12: //宝石
					id=ItemEnum.U_CHARM;
					break;
				case 11: //鞋子
					id=ItemEnum.U_BOOTS;
					break;
				case 0: //武器/物品
					id=ItemEnum.U_WEAPON;
					break;
				case 4: //护身符
					id=ItemEnum.U_BUJUK;
					break;
			}
			return id;
		}

		/**
		 * 返回货币的按4位
		 * @param str
		 * @return
		 *
		 */
		public static function getSplitMoneyTextTo4(mon:String):String {
			if (mon == null || mon == "" || mon == "0")
				return "0";

			var str:Array=[];
			for (var i:int=mon.length; i >= 0; i-=4) {
				str.push(mon.substr(i, 4));
			}

			if (4 +i > 0)
				str.push(mon.substring(0, 4 +i));

			str=str.reverse();

			return str.join(",").replace(/,$/,"");
		}



	}
}
