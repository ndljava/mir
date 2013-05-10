package com.info.child
{
	import flash.geom.Point;
	import flash.utils.ByteArray;

	/**
	 *装饰的数据信息 
	 * @author Administrator
	 * 
	 */	
	public class DecorateInfo
	{
		public var modelId:String;//模型的id
		public var pointX:String;//格子的x
		public var pointY:String;//格子的
		public var direction:int;//方向
		public var action:String;//动作
		public function DecorateInfo()
		{
		}
		public  function toXmlString(dec:DecorateInfo):XML
		{
			var xml:XML = <data/>;
			xml.@modelId = dec.modelId;
			xml.@pointX = dec.pointX;
			xml.@pointY = dec.pointY;
			xml.@action = dec.action;
			xml.@direction = dec.direction;
			return xml;		
		}
	}
}
