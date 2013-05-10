package  com.ace.gameData.table {

	public class TActsInfo {
		public var id:int;
		public var actDic:Object;

		public function TActsInfo(info:XML) {
			this.id=info.@id;

			this.actDic={};
			for each (var render:XML in info.children()) {
				this.actDic[render.@name]=new TActInfo(render);
			}
		}
		
		//该动作的末尾帧
		public function actEndFrame(actName:String="defaultAct"):int {
			return (this.actInfo(actName).interval + 1) * (this.actInfo(actName).preFrame - this.actInfo(actName).spaceFrame);
		}

		public function actInfo(actName:String="defaultAct"):TActInfo {
			var info:TActInfo;
			info=(this.actDic[actName]) ? this.actDic[actName] : this.actDic["defaultAct"];
			return info;
		}
	}
}