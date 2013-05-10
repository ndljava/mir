package com.ace.gameData.table {

	public class TMapInfo {
		public var id:String;
		public var name:String;
		
		public function TMapInfo(info:XML) {
			this.id=info.@id;
			this.name=info.@name;
		}
	}
}