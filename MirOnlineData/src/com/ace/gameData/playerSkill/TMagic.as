package com.ace.gameData.playerSkill {
	import com.ace.utils.ByteArrayUtil;
	
	import flash.utils.ByteArray;

	public class TMagic {
		public var wMagicId:int;
		public var sMagicName:String;
		public var btEffectType:int;
		public var btEffect:int;
		public var bt11:int;
		public var wSpell:int;
		public var wPower:int;
		public var trainLevel:Array;
		public var w02:int;
		public var maxTrain:Array;
		public var btTrainLv:int;
		public var btJob:int;
		public var wMagicIdx:int;
		public var dwDelayTime:int;
		public var btDefSpell:int;
		public var btDefPower:int;
		public var wMaxPower:int;
		public var btDefMaxPower:int;
		public var sDescr:String;

		public function TMagic(br:ByteArray) {
			
			ByteArrayUtil.amendmentPS(br,2);
			this.wMagicId=br.readShort();
			
//			ByteArrayUtil.amendmentPS(br,4);
			var len:uint=br.readUnsignedByte();
			this.sMagicName=br.readMultiByte(len,"gb2312");
			br.position+=12-len;
			this.btEffectType=br.readByte();
			this.btEffect=br.readByte();
			this.bt11=br.readByte();
			
			ByteArrayUtil.amendmentPS(br,2);
			this.wSpell=br.readShort();
			this.wPower=br.readShort();
			this.trainLevel=[br.readByte(),br.readByte(),br.readByte(),br.readByte()];
			
			ByteArrayUtil.amendmentPS(br,2);
			this.w02=br.readShort();
			this.maxTrain=[br.readInt(),br.readInt(),br.readInt(),br.readInt()];
			this.btTrainLv=br.readByte();
			this.btJob=br.readByte();				
			
			ByteArrayUtil.amendmentPS(br,2);
			this.wMagicIdx=br.readShort();
			
			ByteArrayUtil.amendmentPS(br,4);
			this.dwDelayTime=br.readUnsignedInt();	
			this.btDefSpell=br.readByte();
			this.btDefPower=br.readByte();	
			this.wMaxPower=br.readShort();
			
			ByteArrayUtil.amendmentPS(br,2);
			this.btDefMaxPower=br.readShort();
			this.sDescr=br.readUTFBytes(18);
				
				
			
		}
	}
}



/*
TMagic = record //技能类
	wMagicId: Word;//技能ID
	sMagicName: string[12];//技能名称
	btEffectType: Byte;//动作效果
	btEffect: Byte;//魔法效果
	bt11: Byte;//未使用 20080531
	wSpell: Word;//魔法消耗
	wPower: Word;//基本威力
	TrainLevel: array[0..3] of Byte;//技能等级
	w02: Word;//附加威力
	MaxTrain: array[0..3] of Integer;//各技能等级最高修炼点
	btTrainLv: Byte;//修炼等级
	btJob: Byte;//职业 0-战 1-法 2-道 3-刺客
	wMagicIdx: Word;//未使用 20080531
	dwDelayTime: LongWord;//技能延时
	btDefSpell: Byte;//升级魔法
	btDefPower: Byte;//升级威力
	wMaxPower: Word;//最大威力
	btDefMaxPower: Byte;//升级最大威力
	sDescr: string[18];//备注说明
	end;
pTMagic = ^TMagic;

*/