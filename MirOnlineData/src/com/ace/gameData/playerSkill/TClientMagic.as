package com.ace.gameData.playerSkill {
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.utils.ByteArrayUtil;

	import flash.utils.ByteArray;

	public class TClientMagic {
		public var key:int;
		public var level:int;
		public var curTrain:int;
		public var def:TMagic;
		public var nTick:int;


		public var isLearn:Boolean;
		public var skillId:int;

		public function TClientMagic(br:ByteArray, id:int=-1) {
			if (id == -1) {
				this.read(br);
			} else {
				this.isLearn=false;
				this.skillId=id;
			}
		}

		public function read(br:ByteArray):void {
			this.isLearn=true;
			this.key=br.readByte();
			this.level=br.readByte();

			ByteArrayUtil.amendmentPS(br, 4);
			this.curTrain=br.readInt();
			this.def=new TMagic(br);
			this.nTick=br.readInt();
		}
	}
}
/*
//技能快捷键数据信息
TClientMagic = record //84
Key: Char;
Level: Byte;
CurTrain: Integer;
Def: TMagic;
nTick: integer;
end;
*/