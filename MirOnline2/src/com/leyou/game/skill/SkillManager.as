package com.leyou.game.skill {

	public class SkillManager {
		
		//持续buff字典（人物身上的、地图上的火）   
		
		
		
		
		public function SkillManager() {
		}
		
		
		//删除buff（人死亡时）
		public function delBuff(id:int):void{
			
		}
	}
}


/*


人物、怪物、地面
	添加释放技能特效（info）、添加持续buff(info)
	
人、地面上的buff处理
	超出屏幕范围后，移除buff，但是字典内的不能移除，等再次进入视野时，再添加特效（有可能是服务器通知的）
子弹
	onTick(修改坐标路径);

*/