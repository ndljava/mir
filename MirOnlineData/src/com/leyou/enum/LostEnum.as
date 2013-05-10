package com.leyou.enum {
	import flash.utils.Dictionary;

	/**
	["922"]=50,
	["928"]=50,
	["934"]=50,
	["1839"]=75,
	["843"]=100,
	["476"]=100,
	["473"]=100,
	["1261"]=258,
	["1490"]=258,
	["1868"]=258,
	 * @author Administrator
	 *
	 */
	public class LostEnum {

		private static var ItemDic:Dictionary=new Dictionary(true);

		public function LostEnum() {
		}

		public static function getItemDicByID(id:int):int {
			if (ItemDic["922"] == null) {
				ItemDic["922"]=50;
				ItemDic["928"]=50;
				ItemDic["934"]=50;
				ItemDic["1839"]=75;
				ItemDic["843"]=100;
				ItemDic["476"]=100;
				ItemDic["473"]=100;
				ItemDic["1261"]=258;
				ItemDic["1490"]=258;
				ItemDic["1868"]=258;
			}
			
			return ItemDic["" + id];
		}

	}
}
