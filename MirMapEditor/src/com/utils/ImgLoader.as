package com.utils
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	public class ImgLoader extends EventDispatcher
	{
		public var url:String;
		public var loader:Loader;
		public var data:BitmapData;
		public function ImgLoader($url:String = null)
		{
//			load($url);
		}
		/*/加载*/
		public function load($url:String):void
		{
			url = $url;
			loader = new Loader();
			loader.load(new URLRequest(url));
			addEvent();
		}
		//开始侦听
		private function addEvent():void{
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressFun);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeFun);
		}
		
		//结束侦听
		private function delEvent():void{
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,progressFun);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,completeFun);
		}
		private function progressFun(e:ProgressEvent):void{
			
		}
		private function completeFun(e:Event):void{
			data = loader.content["bitmapData"];
			dispatchEvent(e);
			delEvent();
		}
		//清除
		public function clear():void{
			loader.unload();
			loader = null;
			data = null;
		}
			
	}
}