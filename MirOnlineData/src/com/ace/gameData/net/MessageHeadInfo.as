package com.ace.gameData.net {
	import flash.utils.ByteArray;

	public class MessageHeadInfo {
		static public const HEAD_LENGTH:int=4; //头长

		public var isRead:Boolean;
		public var length:uint; //
		public var cmdType:uint;
		public var cmd:uint;


		public function MessageHeadInfo() {

		}

		public function readBr(br:ByteArray):void {
			this.length=br.readUnsignedShort() - HEAD_LENGTH;
			this.cmdType=br.readUnsignedByte();
			this.cmd=br.readUnsignedByte();
			this.isRead=true;
		}

		public function reset():void {
			this.isRead=false;
		}
	}
}