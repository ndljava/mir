package com.ace.gameData.player {

	public class MyInfoManager {
		private static var INSTANCE:PlayerInfo; //非自己

		public function MyInfoManager() {
		}

		public static function getInstance():PlayerInfo {
			if (!INSTANCE)
				INSTANCE=new PlayerInfo(null);

			return INSTANCE;
		}

	}
}