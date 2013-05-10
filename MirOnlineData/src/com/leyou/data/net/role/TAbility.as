package com.leyou.data.net.role {

	import com.ace.gameData.player.PlayerBasicInfo;
	import com.ace.gameData.player.PlayerExtendInfo;

	import flash.utils.ByteArray;

	public class TAbility {
		public var Level:int; //
		public var AC:int; //防御
		public var MAC:int; //魔防
		public var DC:int; //攻击力
		public var MC:int; //魔法
		public var SC:int; //道术
		public var HP:int; //21亿血
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


		public var gameGold:uint;
		public var gameCoin:uint;
		public var pkValue:int;
		public var creditValue:int;

		public function TAbility(br:ByteArray) {
			this.Level=br.readUnsignedShort();

			this.AC=br.readInt();
			this.MAC=br.readInt();
			this.DC=br.readInt();
			this.MC=br.readInt();
			this.SC=br.readInt();
			this.HP=br.readInt();
			this.MP=br.readInt();
			this.MaxHP=br.readInt();
			this.MaxMP=br.readInt();
			this.Exp=br.readUnsignedInt();
			this.MaxExp=br.readUnsignedInt();

			this.Weight=br.readUnsignedShort();
			this.MaxWeight=br.readUnsignedShort();
			this.WearWeight=br.readUnsignedShort();
			this.MaxWearWeight=br.readUnsignedShort();
			this.HandWeight=br.readUnsignedShort();
			this.MaxHandWeight=br.readUnsignedShort();
			this.Alcohol=br.readUnsignedShort();
			this.MaxAlcohol=br.readUnsignedShort();
			this.WineDrinkValue=br.readUnsignedShort();
			this.MedicineValue=br.readUnsignedShort();
			this.MaxMedicineValue=br.readUnsignedShort();
		}

		public function copyTo(info:PlayerBasicInfo):void {
			info.Level=this.Level;

			info.AC=this.AC
			info.MAC=this.MAC;
			info.DC=this.DC;
			info.MC=this.MC;
			info.SC=this.SC;
			info.HP=this.HP;
			info.MP=this.MP;
			info.MaxHP=this.MaxHP;
			info.MaxMP=this.MaxMP;
			info.Exp=this.Exp;
			info.MaxExp=this.MaxExp;

			info.Weight=this.Weight;
			info.MaxWeight=this.MaxWeight;
			info.WearWeight=this.WearWeight;
			info.MaxWearWeight=this.MaxWearWeight;
			info.HandWeight=this.HandWeight;
			info.MaxHandWeight=this.MaxHandWeight;
			info.Alcohol=this.Alcohol;
			info.MaxAlcohol=this.MaxAlcohol;
			info.WineDrinkValue=this.WineDrinkValue;
			info.MedicineValue=this.MedicineValue;
			info.MaxMedicineValue=this.MaxMedicineValue;
		}

	}
}