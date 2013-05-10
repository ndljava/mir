package com.ace.gameData.table {

	public class TSkillInfo {
		public var id:int;
		public var name:String;
		public var effectType:int;
		private var _effectId:int;
		public var spell:int;
		public var power:int;
		public var maxPower:int;
		public var defSpell:int;
		public var defPower:int;
		public var deMaxPower:int;
		public var job:int;
		public var needLv1:int;
		public var lv1Train:int;
		public var needLv2:int;
		public var lv2Train:int;
		public var needLv3:int;
		public var lv3Train:int;
		public var delay:int;
		public var descr:String;

		public function TSkillInfo(info:XML) {
			this.id=info.@id;
			this.name=info.@name;
			this.effectType=info.@effectType;
			this.effectId=info.@effectId;
			this.spell=info.@spell;
			this.power=info.@power;
			this.maxPower=info.@maxPower;
			this.defSpell=info.@defSpell;
			this.defPower=info.@defPower;
			this.deMaxPower=info.@deMaxPower;
			this.job=info.@job;
			this.needLv1=info.@needLv1;
			this.lv1Train=info.@lv1Train;
			this.needLv2=info.@needLv2;
			this.lv2Train=info.@lv2Train;
			this.needLv3=info.@needLv3;
			this.lv3Train=info.@lv3Train;
			this.delay=info.@delay;
			this.descr=info.@descr;
		}

		public function get effectId():int {
			return _effectId;
		}

		public function set effectId(value:int):void {
			_effectId=value;
		}

	}
}


/*

<skill id="12" name="刺杀剑术" effectType="0" effectId="13" spell="0" power="0" maxPower="0"
defSpell="0" defPower="0" deMaxPower="0" job="0" needLv1="25" lv1Train="150" needLv2="27"
lv2Train="200" needLv3="29" lv3Train="300" delay="0" descr=""/>

MagID 技能代号	MagName 技能名称	Effect Type效果类型（使用技能时角色的动作效果）	Effect 效果（技能产生的动画效果）
Spel l每次耗用魔法值	Power 基本威力	MaxPower最大威力	DefSpell 升级后增加的每次耗用魔法值	DefPower 升级后增加的威力
DefMaxPower升级后增加的最大威力	Job 职业（0-战士，1-法师，2-道士）	NeedL1 1级技能所需等级	L1Train 1级技能修炼所需经验
NeedL2 2级技能所需等级	L2Train 2级技能修炼所需经验	NeedL3 3级技能所需等级
L3Train 3级技能修炼所需经验	Delay 技能延迟时间	Descr 备注


*/