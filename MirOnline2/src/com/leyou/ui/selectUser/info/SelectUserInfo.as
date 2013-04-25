package com.leyou.ui.selectUser.info {
	

	public class SelectUserInfo {
		public var account:String;
		public var name:String;
		public var sex:int;
		public var race:int;
		public var level:int;
		public var hair:int;
//		public var dir:int;
		public function SelectUserInfo() {
		}
		public function updateInfoExceptAccount(info:SelectUserInfo):void{
			this.name=info.name;
			this.sex=info.sex;
			this.race=info.race;
			this.level=info.level;
			this.hair=info.hair;
		}
	}
}