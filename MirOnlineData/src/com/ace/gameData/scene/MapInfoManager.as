package com.ace.gameData.scene {

	public class MapInfoManager {
		private static var INSTANCE:MapInfo;

		public function MapInfoManager() {
		}

		public static function getInstance():MapInfo {
			if (!INSTANCE)
				INSTANCE=new MapInfo();

			return INSTANCE;
		}
		
	}
}