package com.leyou.enum {
	import mx.messaging.AbstractConsumer;

	public class TipsEnum {
		public function TipsEnum() {
		}
		public static const COLOR_YELLOW:String="#ffea00";
		public static const COLOR_RED:String="#ee2211";
		public static const COLOR_WHITE:String="#ffffff";
		public static const COLOR_GREEN:String="#00c957";
		public static const COLOR_GOLD:String="#f3e3a1";
		public static const COLOR_DIRT:String="#978243";
		public static const COLOR_BLUE:String="#87ceeb";
		public static const COLOR_PINK:String="#FF00FF";
		public static const COLOR_ORANGE:String="#DAA520";
		
		public static const TYPE_TIPS_ITEM:int=0;
		public static const TYPE_TIPS_EQUIP:int=1;
		private static var _skill:Object;
//		召唤神兽     护身符护身符(大)
//		困魔咒
//		神圣战甲术
//		幽灵盾
//		集体隐身术
//		隐身术
//		召唤骷髅
//		灵魂火符
//		施毒术

		public static function get skill():Object{
			if(_skill==null){
				_skill=new Object();
				setSkill("召唤神兽",["护身符","护身符(大)"],5);
				setSkill("困魔咒",["护身符","护身符(大)"],1);
				setSkill("神圣战甲术",["护身符","护身符(大)"],1);
				setSkill("幽灵盾",["护身符","护身符(大)"],1);
				setSkill("集体隐身术",["护身符","护身符(大)"],1);
				setSkill("隐身术",["护身符","护身符(大)"],1);
				setSkill("召唤骷髅",["护身符","护身符(大)"],1);
				setSkill("灵魂火符",["护身符","护身符(大)"],1);
				setSkill("施毒术",["灰色药粉(少量)","灰色药粉(中量)","灰色药粉(大量)","黄色药粉(少量)","黄色药粉(中量)","黄色药粉(大量)"],1);
			}
			return _skill;
		}
		private static function setSkill(name:String,useItem:Array,num:int):void{
			_skill[name]=new Object;
			_skill[name].item=useItem;
			_skill[name].num=num;
		}
	}
}