package com.info.child {

	/**
	 *区域数据信息
	 * @author Administrator
	 *
	 */
	public class AreaInfo {
		public var id:int;//区域用途的标志吧
		public var pointX:String;
		public var pointY:String;
		public function AreaInfo() {
		}
		public function toXmlString($data:AreaInfo):XML
		{
			var xml:XML = <data/>;
			xml.@id = $data.id;
			xml.@pointX = $data.pointX;
			xml.@pointY = $data.pointY;
			return xml;
		}
	}
}