package com.leyou.data.tips {

	public class EquipTipsInfo {
		public function EquipTipsInfo() {
		}
		public var name:String;
//		public var sign:String;//签名暂时屏蔽掉
		public var limit:Array;
		public var type:String;
		public var durability:String;
		public var wight:int;
		public var properArr:Array;
		public var instruction1:String;
		public var instruction2:String;
		public var price:String;
		public var Looks:uint;
		public var numStr:String;

		public function clearMe():void {
			this.name="";
//			this.sign="";
			this.limit=[];
			this.type="";
			this.durability="";
			this.wight=0;
			this.properArr=[];
			this.instruction1="";
			this.instruction2="";
			this.price="";
			this.Looks=0;
			this.numStr="";
		}

	}
}