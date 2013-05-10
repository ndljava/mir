package com.leyou.data.net.scene {
	import flash.utils.ByteArray;

	public class TMessageBodyW {
		public var Param1:int;
		public var Param2:int;
		public var Tag1:int;
		public var Tag2:int;

		public function TMessageBodyW(br:ByteArray) {
			this.Param1=br.readUnsignedShort();
			this.Param2=br.readUnsignedShort();
			this.Tag1=br.readUnsignedShort();
			this.Tag2=br.readUnsignedShort();
		}
	}
}