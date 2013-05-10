package com.ace.enum {
	import flash.geom.Point;

	public class PlayerEnum {

		//mc资源类型
		public static const MCTYPE_HUMAN:int=1;
		public static const MCTYPE_EFFECT:int=2;
		public static const MCTYPE_BUFF:int=3;
		//性别
		public static const SEX_BOY:int=0;
		public static const SEX_GIRL:int=1;
		//职业
		public static const PRO_SOLDIER:int=0;
		public static const PRO_MASTER:int=1;
		public static const PRO_TAOIST:int=2;
		//种族
		public static const RACE_HUMAN:int=1;
		public static const RACE_NPC:int=2;
		public static const RACE_MONSTER:int=3;

		//速度：人物移动速度 越小越快
		public static const SPEED_WALK:Number=550;
//		public static const SPEED_RUN:Number=450;
//		public static const SPEED_RIDE:Number=520;

		public static const MOVE_WALK:int=1; //走
		public static const MOVE_RUN:int=2; //跑
		public static const MOVE_RIDE:int=3; //骑马

		//avatar：部位
		public static const AVT_SUIT:uint=1;
		public static const AVT_WEAPON:uint=2;
		public static const AVT_HAIR:uint=3;
		public static const AVT_EFFECT:uint=4;
		public static const AVT_MOUNT_HAIR:uint=5;
		public static const AVT_MOUNT_SUIT:uint=6;
		public static const AVT_MOUNT:uint=7;
		public static const AVT_BUFF:uint=8;
		public static const AVT_SKILLEFFECT:uint=9;



		public static const URL_SUIT:String="player/suit/";
		public static const URL_WEAPON:String="player/weapon/";
		public static const URL_HAIR:String="player/hair/";
		public static const URL_EFFECT:String="player/effect/";
		public static const URL_MOUNT_HAIR:String="player/mount_hair/";
		public static const URL_MOUNT_SUIT:String="player/mount_suit/";
		public static const URL_MOUNT:String="player/mount/";
		public static const URL_MAGIC:String="magic/";
		public static const URL_MONSTER:String="monster/";
		public static const URL_NPC:String="npc/";

		//部位的文件路径
		public static const AVT_DEFAULT:Array=[999, 999, 999, 999, 999, 999, 999];
		public static const AVT_URL:Array=[URL_SUIT, URL_WEAPON, URL_HAIR, URL_EFFECT, URL_MOUNT_HAIR, URL_MOUNT_SUIT, URL_MOUNT, URL_MAGIC, URL_MAGIC];
//		public static const AVT_PS:Array=[new Point(-22, -19), new Point(-22, -19), new Point(-22, -19), new Point(-22, -19), new Point(-20, -14), new Point(-20, -14), new Point(-20, -14)];

		/*
		1							0
		1						7		1
		1					6	 			2
		1						5		3
		1							4
		*/
		//方向：	8方向 从北开始，顺时针
		public static const DIR_N:int=0;
		public static const DIR_EN:int=1;
		public static const DIR_E:int=2;
		public static const DIR_ES:int=3;
		public static const DIR_S:int=4;
		public static const DIR_WS:int=5;
		public static const DIR_W:int=6;
		public static const DIR_WN:int=7;

		//各个方向时人物部位的排序
		public static const AVT_SORT:Array=[ //
			[AVT_MOUNT, AVT_WEAPON, AVT_SUIT, AVT_MOUNT_SUIT, AVT_HAIR, AVT_MOUNT_HAIR, AVT_EFFECT, AVT_BUFF, AVT_SKILLEFFECT], //0
			[AVT_MOUNT, AVT_SUIT, AVT_MOUNT_SUIT, AVT_WEAPON, AVT_HAIR, AVT_MOUNT_HAIR, AVT_EFFECT, AVT_BUFF, AVT_SKILLEFFECT], //1     
			[AVT_MOUNT, AVT_SUIT, AVT_MOUNT_SUIT, AVT_WEAPON, AVT_HAIR, AVT_MOUNT_HAIR, AVT_EFFECT, AVT_BUFF, AVT_SKILLEFFECT], //2     
			[AVT_MOUNT, AVT_SUIT, AVT_MOUNT_SUIT, AVT_WEAPON, AVT_EFFECT, AVT_HAIR, AVT_MOUNT_HAIR, AVT_BUFF, AVT_SKILLEFFECT], //3     
			[AVT_MOUNT, AVT_SUIT, AVT_MOUNT_SUIT, AVT_EFFECT, AVT_HAIR, AVT_WEAPON, AVT_MOUNT_HAIR, AVT_BUFF, AVT_SKILLEFFECT], //4     
			[AVT_MOUNT, AVT_SUIT, AVT_MOUNT_SUIT, AVT_WEAPON, AVT_HAIR, AVT_MOUNT_HAIR, AVT_EFFECT, AVT_BUFF, AVT_SKILLEFFECT], //5    xxxxxxxxxxxxxx 
			[AVT_MOUNT, AVT_SUIT, AVT_MOUNT_SUIT, AVT_WEAPON, AVT_HAIR, AVT_MOUNT_HAIR, AVT_EFFECT, AVT_BUFF, AVT_SKILLEFFECT], //6    xxxxxxxxxxxxxx 
			[AVT_MOUNT, AVT_SUIT, AVT_MOUNT_SUIT, AVT_WEAPON, AVT_HAIR, AVT_MOUNT_HAIR, AVT_EFFECT, AVT_BUFF, AVT_SKILLEFFECT]]; //7   xxxxxxxxxxxxxx  

		//动作：	<!-- 共包括静止、走、跑、一般攻击、双手攻击、强行攻击、施展魔法、挖肉、被攻击、死亡共1 -->          换成数字
		public static const ACT_BORN:String="born";
		public static const ACT_STAND:String="stand";
		public static const ACT_WALK:String="walk";
		public static const ACT_RUN:String="run";
		public static const ACT_RIDE:String="ride";
		public static const ACT_ATTACK:String="attack";
		public static const ACT_ATTACK2:String="attack2";
		public static const ACT_ATTACK3:String="attack3";
		public static const ACT_ATTACK4:String="attack4";
		public static const ACT_DIG:String="dig";
		public static const ACT_HIT:String="hit";
		public static const ACT_DEAD:String="dead";
//		public static const ACT_DEAD_EFFECT:String="deadEffect";

		public static const defaultAvatar:Array=[1, 1, 1, 1];

		//技能
		public static const SKILL_POWERHIT:int=7; //攻杀（被动）
		public static const SKILL_LONGHIT:int=12; //刺杀
		public static const SKILL_WIDEHIT:int=25; //半月
		public static const SKILL_FIRHIT:int=26; //烈火
		public static const skill_xxxxx:int=27; //野蛮冲撞
//		public static const skill_xxxxx:int=1;


		//冷却时间
		public static const CD_ACTHIT_ME:int=9; //受伤cd-me
		public static const CD_ACTHIT_OTHER:int=30; //受伤cd-other
		public static const CD_ACTATTACK:int=15; //攻击cd
		public static const CD_ACTATTACKII:int=75; //攻击cd
		public static const CD_ACTSPELL:int=48; //技能cd
		public static const CD_ACTSPELLII:int=88; //技能cd













	}
}