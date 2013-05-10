package com.ace.ui.window.children {
	import flash.geom.Point;
	
	public class WindInfo {
		
		public var title:String;
		public var content:String;
		public var okBtnName:String="确认";
		public var cancelBtnName:String="取消";
		
		public var isModal:Boolean;
		public var showClose:Boolean;
		public var allowDrag:Boolean=true;
		
		public var ps:Point;
		public var okFun:Function;
		public var cancelFun:Function;
		
		public function WindInfo() {
		}
		
		
		static public function getAlertInfo($content:String, okFun:Function=null):WindInfo {
			var info:WindInfo=new WindInfo();
			info.title="警告框";
			info.content=$content;
			info.okFun=okFun;
			return info;
		}
		
		static public function getConfirmInfo($content:String, okFun:Function=null, cancelFun:Function=null):WindInfo {
			var info:WindInfo=new WindInfo();
			info.title="确认框";
			info.content=$content;
			info.okFun=okFun;
			info.cancelFun=cancelFun;
			return info;
		}
		
		static public function getInputInfo($content:String, okFun:Function=null, cancelFun:Function=null):WindInfo {
			var info:WindInfo=new WindInfo();
			info.title="输入框";
			info.content=$content;
			info.okFun=okFun;
			info.cancelFun=cancelFun;
			return info;
		}
	}
}