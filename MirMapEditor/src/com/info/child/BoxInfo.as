package com.info.child {
	import flash.geom.Point;

	/**
	 *宝箱的数据信息
	 * @author Administrator
	 *
	 */
	public class BoxInfo {
		public var boxId:String;//宝箱的id
		public var pointX:String;
		public var pointY:String;
		public function BoxInfo() {
		}
		public function boxInfoToXml($box:BoxInfo):XML
		{
			var xml:XML = <data/>;
			xml.@boxId = $box.boxId;
			xml.@pointX= $box.pointX;
			xml.@pointY = $box.pointY;
			return xml;
			
		}
	}
}