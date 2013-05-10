package com.ace.gameData.table {
	import flash.geom.Point;
	
	public class TTransInfo {
		public var fromId:String;
		public var fromPs:Point;
		public var toId:String;
		public var toPs:Point;
		
		public function TTransInfo(info:XML) {
			this.fromId=info.@fromId;
			this.fromPs=new Point();
			this.fromPs.x=String(info.@fromPs).split(",")[0];
			this.fromPs.y=String(info.@fromPs).split(",")[1];
			this.toId=info.@toId;
			this.toPs=new Point();
			this.toPs.x=String(info.@toPs).split(",")[0];
			this.toPs.y=String(info.@toPs).split(",")[1];
		}
		
		public function get id():String {
			return this.fromId + "-" + this.fromPs.x + ":" + this.fromPs.y;
		}
	}
}