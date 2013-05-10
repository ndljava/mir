package com.info.child {

	/**
	 *障碍物数据信息
	 * @author Administrator
	 *
	 */
	public class ObstacleInfo {
		public var id:int;//区域的格子坐标
		public var xx:int ;
		public var yy:int;
		public function ObstacleInfo() {
		}
//		public function obstacleToXML($o:ObstacleInfo):XML
//		{
//			var xml:XML = <data/>;
//			xml.@id = $o.id;
//			xml.@pointX = $o.pointX;
//			xml.@pointY = $o.pointY;
//			return xml;
//		}
	}
}