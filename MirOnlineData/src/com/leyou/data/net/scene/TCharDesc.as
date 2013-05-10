package com.leyou.data.net.scene {
	import flash.utils.ByteArray;

	//人物外观
	public class TCharDesc {
		public var feature:int;
		public var status:uint;
		public var eff:Array
		public var fightEff:int;

		public function TCharDesc(br:ByteArray) {
			this.eff=[];

			this.feature=br.readInt();
			this.status=br.readUnsignedInt();
			this.eff.push(br.readInt());
			this.eff.push(br.readInt());
			this.fightEff=br.readInt();
		}

	}
}