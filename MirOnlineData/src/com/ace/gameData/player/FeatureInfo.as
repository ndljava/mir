package com.ace.gameData.player {



	public class FeatureInfo {
		public var suit:int;
		public var weapon:int;
		public var hair:int;
		public var effect:int;
		public var mount_hair:int;
		public var mount_suit:int;
		public var mount:int;
		public var appr:int;

		public function equal(info:FeatureInfo):Boolean {
			if (this.suit != info.suit)
				return false;
			if (this.weapon != info.weapon)
				return false;
			if (this.hair != info.hair)
				return false;
			if (this.effect != info.effect)
				return false;
			if (this.mount_hair != info.mount_hair)
				return false;
			if (this.mount_suit != info.mount_suit)
				return false;
			if (this.mount != info.mount)
				return false;
			if (this.appr != info.appr)
				return false;
			return true;
		}
	}
}


