package com.info.child {

	/**
	 *npc巡逻的数据信息 
	 * @author Administrator
	 * 
	 */	
	public class PatrolInfo {
		public var id:int;//路径id
		public var idx:int;
		public var pointX:int = -1;
		public var pointY:int = -1;
		public function PatrolInfo() {
		}
		public function patrolToXML($patrol:PatrolInfo):XML
		{
			var xml:XML = <data/>;
			xml.@id = $patrol.id;
			xml.@idx = $patrol.idx;
			xml.@pointX = $patrol.pointX;
			xml.@pointY = $patrol.pointY;
			return xml;
		}
	}
}