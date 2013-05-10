package com.info.child {
	import flash.geom.Point;

	/**
	 *点的数据信息
	 * @author Administrator
	 *
	 */
	public class PointInfo {
		public var id:String;//点id 当前场景ID+3位顺序标号
		public var pointX:int;
		public var pointY:int;
		public var direction:int;
		public var sceneId:String;
		public var description:String="";
		public function PointInfo() {
		}
		public function pointInfoToXml($point:PointInfo):XML
		{
			var xml:XML = <data/>;
			xml.@id = $point.id;
			xml.@pointX = $point.pointX;
			xml.@pointY = $point.pointY;
			xml.@direction = $point.direction;
			xml.@sceneId = $point.sceneId;
			xml.@description = $point.description;
			return xml;
				
		}
	}
}