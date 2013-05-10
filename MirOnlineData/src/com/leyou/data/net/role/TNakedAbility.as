package com.leyou.data.net.role {
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class TNakedAbility {
		public var DC:uint;
		public var MC:uint;
		public var SC:uint;
		public var AC:uint;
		public var MAC:uint;
		public var HP:int;
		public var MP:int;
		public var Hit:uint;
		public var Speed:uint;
		public var X2:uint;

		public function TNakedAbility() {

		}

		public function readBr(br:ByteArray):void {
			this.DC=br.readUnsignedShort();
			this.MC=br.readUnsignedShort();
			this.SC=br.readUnsignedShort();
			this.AC=br.readUnsignedShort();
			this.MAC=br.readUnsignedShort();
			this.HP=br.readInt();
			this.MP=br.readInt();
			this.Hit=br.readUnsignedShort();
			this.Speed=br.readUnsignedShort();
			this.X2=br.readUnsignedShort();
		}

		public function writeBr():ByteArray {
			var br:ByteArray=new ByteArray();
			br.endian=Endian.LITTLE_ENDIAN;
			br.writeShort(this.DC);
			br.writeShort(this.MC);
			br.writeShort(this.SC);
			br.writeShort(this.AC);
			br.writeShort(this.MAC);
			br.writeInt(this.HP);
			br.writeInt(this.MP);
			br.writeShort(this.Hit);
			br.writeShort(this.Speed);
			br.writeShort(this.X2);
			br.writeByte(0);
			return br;
		}

		public function get length():int {
			return 24;
		}
		
		public function clearMe():void{
			this.DC=0;
			this.MC=0;
			this.SC=0;
			this.AC=0;
			this.MAC=0;
			this.HP=0;
			this.MP=0;
			this.Hit=0;
			this.Speed=0;
			this.X2=0;
		}
	}
}