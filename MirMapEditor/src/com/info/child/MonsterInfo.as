package com.info.child {

	/**
	 *怪物的数据
	 * @author Administrator
	 *
	 */
	public class MonsterInfo {
		public var monsterId:String;//怪物id
		public var direction:int;//方向
		public var pointX:String;
		public var pointY:String;
		public var pathId:int = -1;
		public function MonsterInfo() {
		}
		public function monsterInfoToXml($m:MonsterInfo):XML
		{
			var xml:XML = <data/>;
			xml.@monsterId = $m.monsterId;
			xml.@pointX = $m.pointX;
			xml.@pointY = $m.pointY;
			xml.@direction = $m.direction;
			xml.@pathId = $m.direction;
			return xml;	
		}

	}
}