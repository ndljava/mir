package  com.ace.gameData.table {

	public class TMonSpeciesInfo {
		public var species:int;
		public var type:int;
		public var actDic:Object;

		public function TMonSpeciesInfo(info:XML) {
			this.species=info.@species;
			this.type=info.@type;
			this.actDic={};
			for each (var render:XML in info.children()) {
				this.actDic[render.@name]=int(render.@pnfId)
			}
		}

		public function actPnf(actName:String):int {
			if(this.actDic[actName]){
				return this.actDic[actName];
			}
			return -1;
		}


		public function actInfo(actName:String="defaultAct"):TActInfo {
			var info:TActInfo;
			info=(this.actDic[actName]) ? this.actDic[actName] : this.actDic["defaultAct"];
			return info;
		}
	}
}