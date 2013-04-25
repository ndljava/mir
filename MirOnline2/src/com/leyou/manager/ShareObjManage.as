package com.leyou.manager {
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	public class ShareObjManage {
		private var _shareObj:SharedObject;
		private static var _instance:ShareObjManage;

		public function ShareObjManage() {
		}

		static public function getInstance():ShareObjManage {
			if (!_instance)
				_instance=new ShareObjManage();
			return _instance;
		}

		public function saveFile(name:String, data:Object):void {
			this._shareObj=SharedObject.getLocal(name);
			this._shareObj.clear();
			this._shareObj.data[name]=data;
			try {
				var sta:String=this._shareObj.flush();
//				trace(sta);
			} catch (error:Error) {
				trace("Error...Could not write SharedObject to disk\n");
			}
		}

		public function readFile(name:String):Object {
 			this._shareObj=SharedObject.getLocal(name);
			return this._shareObj.data[name];
		}
	}
}