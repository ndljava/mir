package com.event
{
	import flash.events.Event;
	
	public class MapEditerEvent extends Event
	{
		public static const NEWMAPINFO_SUBMITE:String = "NEWMAPINFO_SUBMITE";
		public static const READ_FILE_SUCCESS:String = "READ_FILE_SUCCESS";
		public static const CHANGEMAPINFO_SUBMITE:String = "CHANGEMAPINFO_SUBMITE";
		public static const OPENMAPINFO_SUBMITE:String = "OPENMAPINFO_SUBMITE";
		private var _data:Object;
		public function MapEditerEvent(type:String, data:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data
		}
		public function get data():Object{
			return _data;
		}
	}
}