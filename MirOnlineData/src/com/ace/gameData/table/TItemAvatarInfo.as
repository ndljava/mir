package com.ace.gameData.table {

	public class TItemAvatarInfo {
		public var id:uint;
		public var px:int;
		public var py:int;

		public function TItemAvatarInfo(info:XML) {
			this.id=info.@id;
			this.px=info.@px;
			this.py=info.@py;
		}
	}
}