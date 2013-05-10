package com.leyou.game.scene.player {
	import com.ace.game.manager.TableManager;
	import com.ace.game.scene.part.LivingModel;
	import com.ace.game.scene.player.OtherPlayerModel;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.table.TActInfo;
	import com.ace.gameData.table.TActsInfo;
	import com.ace.gameData.table.TPnfInfo;
	import com.leyou.game.skill.bullets.BulletManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.ServerFunDic;

	public class Living extends OtherPlayerModel {
		public function Living($info:LivingInfo=null) {
			super($info);
		}

		override public function updataHealth(hp:int, maxHp:int):void {
			super.updataHealth(hp, maxHp);
			if (UIManager.getInstance().teamWnd.getPlayInTeam(this.infoB.name)) {
				UIManager.getInstance().teamWnd.updateTeamInfo();
			}
		}

		//=======================================
		override protected function getCmd():Boolean {
			if (this._info.isMoveing)
				return true;

			if (ServerFunDic.getCmd(this.id))
				return true;
			//如果下一个不是野蛮冲撞引起的后退
			/*if (ServerFunDic.nextCacheCmd(this.id) != MirProtocol.SM_BACKSTEP && ServerFunDic.nextCacheCmd(this.id) != MirProtocol.SM_RUSH) {
				this.resetRush(); //有时候可能走不到此处，比如被受伤打断，受伤cd完毕后，又触发缓冲，然后就没没有下文了
			}*/
			return false;
		}

		override protected function getPnfInfo(id:int):TPnfInfo {
			var info:TPnfInfo;
			info=TableManager.getInstance().getPnfInfo(id);
			return info;
		}

		override protected function getSkillPnfId(skillId:int):int {
			return TableManager.getInstance().getSkillInfo(skillId).effectId;
		}

		override protected function getActsInfo(id:int):TActsInfo {
			return TableManager.getInstance().getActsInfo(id);
		}

		//子类负责实现
		override protected function getActInfo(id:int, actName:String):TActInfo {
			var info:TActInfo;
			info=TableManager.getInstance().getPnfActInfo(id, actName);
			return info;
		}

		override protected function shootBullet(id:int):void {
			BulletManager.getInstance().addBullet(this.infoB.id, this.infoB.attackTargetID, UIManager.getInstance().mirScene.getPlayer(this.infoB.attackTargetID).nowTilePt().x, UIManager.getInstance().mirScene.getPlayer(this.infoB.attackTargetID).nowTilePt().y, 0, id);
			super.shootBullet(id);
		}

	}
}