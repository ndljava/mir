package com.leyou.game {
	import com.leyou.manager.UIManager;

	public class DebugGame {

		//
		static public function test():void {
			trace("=====================调试信息====================");
			trace("玩家数量：" + UIManager.getInstance().mirScene.Players.length);
			trace("=====================调试信息====================");
		}
	}
}