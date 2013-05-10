package com.leyou.data.tips {

	public class SkillTipsInfo {
		public function SkillTipsInfo() {
		}
		public var name:String;//技能名字
		public var limit:int;//等级限制
		public var skillLv:int;//技能等级
		public var proficiency:String;//熟练度
		public var instruction:String;//说明
		public var shortDer:String;//设置快捷键说明
		public var useMagic:int;//使用技能消耗魔法值
		public var needDru:int;
		public var Looks:int;//
		
		public function clearMe():void{
			this.name="";
			this.limit=0;
			this.skillLv=0;
			this.proficiency="";
			this.instruction="";
			this.Looks=0;//
			this.shortDer="";
			this.useMagic=0;
			this.needDru=0;
		}
	}
}