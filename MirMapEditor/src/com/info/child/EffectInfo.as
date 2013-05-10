package com.info.child {
	import flash.geom.Point;

	/**
	 *特效的数据信息
	 * @author Administrator
	 *
	 */
	public class EffectInfo {
		public var effectId:String;//特效的id
		public var pointX:String;//特效的格子 x坐标
		public var pointY:String;//特效的格子y坐标
		public function EffectInfo() {
		}
		
		public function effectInfoToXml(eff:EffectInfo):XML
		{
			var xml:XML = <data/>;
			xml.@effectId = eff.effectId;
			xml.@pointX = eff.pointX;
			xml.@pointY = eff.pointY;
			return xml;	
		}
	}
}