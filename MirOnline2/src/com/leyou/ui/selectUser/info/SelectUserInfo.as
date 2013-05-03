package com.leyou.ui.selectUser.info {
	import com.ace.gameData.player.PlayerInfo;

	public class SelectUserInfo {
		public var account:String;
		public var name:String;
		private var _sex:int;
		private var _race:int;
		public var level:int;
		public var hair:int;

//		public var dir:int;
		public function SelectUserInfo() {
		}

		public function get race():int
		{
			return _race;
		}

		public function set race(value:int):void
		{
			_race = value;
		}

		public function get sex():int
		{
			return _sex;
		}

		public function set sex(value:int):void
		{
			_sex = value;
		}

		public function copy(info:SelectUserInfo):void {
			this.name=info.name;
			this.sex=info.sex;
			this.race=info.race;
			this.level=info.level;
			this.hair=info.hair;
		}
	}
}