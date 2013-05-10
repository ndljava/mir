package com.leyou.data.net.scene {
	import flash.utils.ByteArray;
	
	public class TMessageBodyWL {
		public var Param1:int;
		public var Param2:int;
		public var Tag1:int;
		public var Tag2:int;
		
		public function TMessageBodyWL(br:ByteArray) {
			this.Param1=br.readUnsignedInt();
			this.Param2=br.readUnsignedInt();
			this.Tag1=br.readUnsignedInt();
			this.Tag2=br.readUnsignedInt();
		}
	}
}