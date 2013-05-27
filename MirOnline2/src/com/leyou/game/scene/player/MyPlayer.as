package com.leyou.game.scene.player {
	import com.ace.astarII.child.INode;
	import com.ace.enum.PlayerEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.game.scene.part.LivingModel;
	import com.ace.game.scene.player.MyPlayerModel;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.player.PlayerInfo;
	import com.ace.gameData.scene.MapInfoManager;
	import com.ace.gameData.table.TActInfo;
	import com.ace.gameData.table.TActsInfo;
	import com.ace.gameData.table.TPnfInfo;
	import com.ace.gameData.table.TTransInfo;
	import com.ace.utils.DebugUtil;
	import com.leyou.config.Core;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.ServerFunDic;
	import com.leyou.net.protocol.Cmd_Role;
	import com.leyou.net.protocol.Cmd_Stall;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.net.protocol.Cmd_backPack;
	import com.leyou.net.protocol.scene.CmdScene;

	import flash.geom.Point;

	public class MyPlayer extends MyPlayerModel {

		public function MyPlayer($info:PlayerInfo=null) {
			super($info);
		}

		override protected function onTick():void {
			super.onTick();
			UIManager.getInstance().mirScene.setMapPs(this.x, this.y);
		}


		private var _cacheCmdWalk:Boolean; //地图传送：是否缓冲了延迟发送“行走”协议  要走之前=true，协议回来=false
		private var cmdAct:String;
		private var cmdPs:Point=new Point();
		private var cmdDir:int;

		public function get cacheCmdWalk():Boolean {
			return _cacheCmdWalk;
		}

		public function set cacheCmdWalk(value:Boolean):void {
			_cacheCmdWalk=value;
		}

		public function sendCacheCmdWalk():void {
			if (this.cacheCmdWalk) {
				this.cmd_moveTo(this.cmdAct, this.cmdPs.x, this.cmdPs.y, this.cmdDir);
			}
		}

		public function checkTrans(id:String):Boolean {
			//如果有传送点，传送，然后加载完毕后，在发送传送协议
			var info:TTransInfo=TableManager.getInstance().getTransInfo(id);
			if (info) {
				this.cacheCmdWalk=true;
				UIManager.getInstance().mirScene.gotoMap(info.toId, info.toPs);
				return true;
			}
			return false;
		}

		override public function moveTo(node:INode, act:String, slow:Boolean=false):void {
			if (act == PlayerEnum.ACT_WALK && UIManager.getInstance().mirScene.checkPlayer(new Point(node.x, node.y))) { //防止穿人
				this.playDefaultAct();
				return;
			}
			this.cmdAct=act;
			this.cmdPs.x=node.x;
			this.cmdPs.y=node.y;
			this.cmdDir=this.info.currentDir;

			if (this.checkTrans(MapInfoManager.getInstance().id + "-" + node.x + ":" + node.y)) {
				return;
			}
			this.info.preTile=this.nowTilePt();
			super.moveTo(node, act, slow);
			if (this.info.moveLocked) //野蛮冲撞，服务端过来协议，修改为true，此次截止
				return;
			this.cmd_moveTo(act, node.x, node.y, this.info.currentDir);
		}

		private function cmd_moveTo(act:String, tx:int, ty:int, dir:int):void {
//			trace("要走的位置：" + tx + "--" + ty)
			if (act == PlayerEnum.ACT_RUN) {
				CmdScene.cm_SendRun(tx, ty, dir);
			} else if (act == PlayerEnum.ACT_WALK) {
				CmdScene.cm_SendWalk(tx, ty, dir);
			} else {
				CmdScene.cm_SendRide(tx, ty, dir);
			}
		}

		public function clearPrePt():void {
			this.info.preTile.x=this.info.preTile.y=-1;
		}

		override protected function onMoveOver():void {
			if (!Core.bugTest) {
				UIManager.getInstance().smallMapWnd.updataPs();
				UIManager.getInstance().mapWnd.updataPs();
			}
			UIManager.getInstance().mirScene.pickUpItem(this.nowTilePt());
			super.onMoveOver();
		}

		override protected function _findPath(pt:Point, $pathArr:Vector.<INode>=null):void {
			/*trace("寻路找目标：" + this.nowTilePt());
			if (!this.nowTilePt().equals(new Point(this._info.nextTile.x, this._info.nextTile.y))) {
				trace("got");
			}*/

			$pathArr=MapInfoManager.getInstance().findPath(this.nowTilePt().x, this.nowTilePt().y, pt.x, pt.y);
			if (this.info.hasAttackTarget()) {
				$pathArr.pop();
			}
			this.info.targetTile.x=this.info.targetTile.y=-1;
			//			if (arr.length) {
			super._findPath(pt, $pathArr);
			//			}else{//人物播放站立}
		}

		override protected function actAttack(pt:Point, dir:int=0, skillId:int=0):void {
			if (this.infoB.isAttacking) ///强制攻击时加的
				return;
			if (skillId == 0) {
				skillId=this.getSoldierSkill();
			}
			super.actAttack(pt, dir, skillId);
			if (this._info.moveLocked)
				return;
			if (skillId == 0) {
				CmdScene.cm_Attack(MirProtocol.CM_HIT, this.nowTilePt().x, this.nowTilePt().y, dir);
			} else if (skillId == PlayerEnum.SKILL_FIRHIT) {
				CmdScene.cm_Attack(MirProtocol.CM_FIREHIT, this.nowTilePt().x, this.nowTilePt().y, dir);
			} else if (skillId == PlayerEnum.SKILL_LONGHIT) {
				CmdScene.cm_Attack(MirProtocol.CM_LONGHIT, this.nowTilePt().x, this.nowTilePt().y, dir);
			} else if (skillId == PlayerEnum.SKILL_POWERHIT) {
				CmdScene.cm_Attack(MirProtocol.CM_POWERHIT, this.nowTilePt().x, this.nowTilePt().y, dir);
			} else if (skillId == PlayerEnum.SKILL_WIDEHIT) {
				CmdScene.cm_Attack(MirProtocol.CM_WIDEHIT, this.nowTilePt().x, this.nowTilePt().y, dir);
			}
		}

		//战士挂-获得技能id  delphi //普通攻击 qzq
		private function getSoldierSkill():int {
			if (this.info.race != PlayerEnum.PRO_SOLDIER)
				return 0;
			var skillId:int=0;
			if (this.info.canLongHit && this.canCiSha(this.info.currentDir)) {
				skillId=PlayerEnum.SKILL_LONGHIT;
			}
			if (this.info.canWideHit) {
				skillId=PlayerEnum.SKILL_WIDEHIT;
			}
			if (this.info.canPowerHit) {
				this.info.closePwR();
				skillId=PlayerEnum.SKILL_POWERHIT;
			}
			if (this.info.canFireHit) {
				this.info.closeFire();
				skillId=PlayerEnum.SKILL_FIRHIT;

				/*var t:int=getTimer();
				if (getTimer() - this.info.lastSkillTime >= 20000) {
				this.info.lastSkillTime=t;
				skillId=PlayerEnum.SKILL_FIRHIT;
				}*/
			}
			return skillId;
		}

		//使用技能
		override public function useMagic(pt:Point, magicId:int, player:LivingModel):Boolean {
			if (this.info.isMoveing || this.info.moveLocked || this.info.isOnMount || this.info.isSpelling)
				return false;
			//如果cd时间满足
			if (!this.magicCDIsOver(magicId)) {
				return false;
			}
			UIManager.getInstance().skillWnd.checkUseItem(magicId);
			return super.useMagic(pt, magicId, player);
		}

		//=======================================

		override protected function getCmd():Boolean {
			if (this._info.isMoveing)
				return true;
			if (ServerFunDic.getCmd(this.id))
				return true;
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

		override protected function actDie():void {
			Cmd_backPack.cm_queryBagItems();
//			UIManager.getInstance().roleWnd.up
			super.actDie();
		}

		override public function die():void {
			DebugUtil.throwError("不该死亡");
		}

		//==============协议===================================================
		override protected function onClickStallPlayer(id:int):void {
			Cmd_Stall.cm_clickhuman(id);
		}

		override protected function lookPlayer(id:int, ps:Point, isHead:Boolean=false):void {
			if (isHead && !Core.bugTest) {
				UIManager.getInstance().otherRoleHeadWnd.updataInfo(id);
				return;
			}
			Cmd_Role.cm_queryUserState(id, ps);
		}

		override protected function onClickNpc(id:int):void {
			Cmd_Task.cm_clickNpc(id);
		}

		override protected function onActSpell(v1:int, v2:int, magicId:int, v3:int):void {
			CmdScene.cm_spell(v1, v2, magicId, v3);
		}

		override protected function onTurn():void {
			CmdScene.cm_turn(this.nowTilePt().x, this.nowTilePt().y, this.info.currentDir);
		}

		override protected function sysNotic(str:String):void {
			UIManager.getInstance().noticeMidDownUproll.setNoticeStr(str, SystemNoticeEnum.IMG_WARN);
		}

	}
}


