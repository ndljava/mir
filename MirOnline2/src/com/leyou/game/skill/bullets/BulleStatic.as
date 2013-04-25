package com.leyou.game.skill.bullets {
	import com.ace.gameData.table.TActsInfo;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.game.manager.TableManager;

	public class BulleStatic extends BulletModel {
		public function BulleStatic() {
			super();
		}

		override public function creat($targetId:int, $id:int, $isLoop:Boolean=true):void {
			$isLoop=false;
			super.creat($targetId, $id, $isLoop);
			var info:TActsInfo=TableManager.getInstance().getPnfActsInfo(TableManager.getInstance().getBulletInfo(id).imgId);
			DelayCallManager.getInstance().add(this, this.die, "die", (info.actInfo().interval + 1) * (info.actInfo().preFrame - info.actInfo().spaceFrame));
		}


	}
}