package  com.ace.gameData.table{

	public class TLivingInfo {
		public var id:int;
		public var name:int;
		public var species:int;
		public var pnfId:int;

		public function TLivingInfo(info:XML) {
			this.id=info.@id;
			this.name=info.@name;
			this.species=info.@speces;
			this.pnfId=info.@pnfId;
		}
	}
}