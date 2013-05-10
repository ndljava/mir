package  com.ace.gameData.table {

	public class TPnfInfo {

		public var id:int;
		public var type:int;
		public var part:int;
		public var imgId:int;
		public var px:int;
		public var py:int;
		public var blend:Boolean;
		public var actId:int;

		public function TPnfInfo(info:XML) {

			this.id=info.@id;
			this.type=info.@type;
			this.part=info.@part;
			this.imgId=info.@imgId;
			this.px=info.@px;
			this.py=info.@py;
			this.blend=(info.@blend == "1") ? true : false;
			this.actId=info.@actId;
		}

	}
}

/*

<pnf id="1" type="2" part="9" name="攻杀" imgId="1" px="-22" py="-19" blend="1" actId="3"/>

*/