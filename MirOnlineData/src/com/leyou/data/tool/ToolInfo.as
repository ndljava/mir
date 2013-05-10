package com.leyou.data.tool {
	import com.ace.gameData.player.MyInfoManager;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.leyou.data.tool.data.ShortCutGridInfo;
	
	import flash.net.SharedObject;

	public class ToolInfo {
		private var _toolInfo:Vector.<ShortCutGridInfo>;
		public function ToolInfo() {
			this._toolInfo=new Vector.<ShortCutGridInfo>;
		}
		public function updataInfo(idx:int,info:ShortCutGridInfo):void{
			this._toolInfo[idx]=info;
		}
		public function get toolInfo():Vector.<ShortCutGridInfo>{
			return this._toolInfo;
		}
	}
}