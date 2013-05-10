package com.ace.gameData.player {

	public class PlayerBasicInfo {
		public var Level:int; //
		public var AC:int; //防御
		public var MAC:int; //魔防
		public var DC:int; //攻击力
		public var MC:int; //魔法
		public var SC:int; //道术
		public var HP:int=999; //21亿血
		public var MP:int; //21亿魔法
		public var MaxHP:int; //21亿血
		public var MaxMP:int; //21亿魔法
		public var Exp:uint; //
		public var MaxExp:uint; //
		public var Weight:int; //
		public var MaxWeight:int; // 背包      20100628无忧
		public var WearWeight:int; //
		public var MaxWearWeight:int; //负重  20100628无忧
		public var HandWeight:int; //
		public var MaxHandWeight:int; //腕力  20100628无忧
		public var Alcohol:int; //酒量 20080622
		public var MaxAlcohol:int; //酒量上限 20080622
		public var WineDrinkValue:int; //醉酒度 20080623
		public var MedicineValue:int; //当前药力值 20080623
		public var MaxMedicineValue:int; //药力值上限 20080623


		public var gameGold:uint; //元宝
		public var gameCoin:uint; //金币
		public var gameScore:uint; //分数
		public var pkValue:int;//pk值
		public var creditValue:int;//信用值
		public var contribution:int;//贡献度(行会)

		public function PlayerBasicInfo() {

		}
	}
}