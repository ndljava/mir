package com.leyou.data.tips {

	public class ItemTipsInfo {
		public function ItemTipsInfo() {
		}
		public var type:String;//道具的类型
		public var name:String;//名字
		public var limit:Array;//限制
		public var weight:int;//重量
		public var proper:Array;
		public var instruct1:String;//说明1
		public var instruct2:String;//说明2
		public var price:String;//价钱
		public var Looks:uint;
		public var numStr:String;//数量
		
		public function clearMe():void{
			this.type="";
			this.name="";
			this.limit=[];
			this.weight=0;
			this.proper=[];
			this.instruct1="";
			this.instruct2="";
			this.price="";
			this.Looks=0;
			this.numStr="";
		}
	}
}