package com.leyou.game.skill.bullets {
	import com.ace.ICommon.ITick;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.TickEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.game.scene.part.LivingModel;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.table.TActsInfo;
	import com.ace.gameData.table.TBulletInfo;
	import com.ace.gameData.table.TPnfInfo;
	import com.ace.loaderSync.child.BackObj;
	import com.ace.manager.LibManager;
	import com.ace.manager.LoopManager;
	import com.leyou.manager.UIManager;

	import flash.geom.Point;

	public class BulletFly extends BulletModel implements ITick {
		private var bombId:int;

		public function BulletFly() {
			super();
		}

		override public function creat($targetId:int, $id:int, $isLoop:Boolean=true):void {
			$isLoop=true;
			this.bombId=TableManager.getInstance().getBulletInfo($id).bombImg;
			super.creat($targetId, $id, $isLoop);
			DelayCallManager.getInstance().add(this, this.die, "die", 2 * 24);
			LoopManager.getInstance().addITick(this);
			return;


			var info:TActsInfo=TableManager.getInstance().getPnfActsInfo(TableManager.getInstance().getBulletInfo(id).imgId);
			DelayCallManager.getInstance().add(this, this.die, "die",(info.actInfo().interval + 1) * (info.actInfo().preFrame - info.actInfo().spaceFrame));
		}

		override protected function loadMagic():void {
			super.loadMagic();
			if (this.bombId != 0) {
				var pnfInfo:TPnfInfo=TableManager.getInstance().getPnfInfo(this.bombId);
				var _info:BackObj=new BackObj();
				_info.owner=this;
				_info.param["id"]=this.bombId;
				SYNC_LOADER.addLoader("magic/" + pnfInfo.imgId + ".pnf", _info);
			}
		}

		override public function callBackFun(obj:Object):void {
			//如果是炸弹的
			if (this.bombId != 0 && obj["id"] == this.bombId) {
				//忽略，不做操作
			} else {
				super.callBackFun(obj);
			}
		}

		public function get tickPriority():int {
			return TickEnum.ONE;
		}

		protected var tickX:Number=0;
		protected var tickY:Number=0;
		private var tmpLivngModel:LivingModel;

		public function onTick():void {
			this.x+=this.tickX;
			this.y+=this.tickY;
			//如果碰到障碍，则爆炸
			if (this.targetId != 0) {
				tmpLivngModel=UIManager.getInstance().mirScene.getPlayer(this.targetId);
				if (tmpLivngModel && tmpLivngModel.nowTilePt().equals(SceneUtil.screenToTile(this.x, this.y + 50))) {
					TableManager.getInstance().getBulletInfo(this.id).crash && this.explode();
				}
			}
		}

		//爆炸
		protected function explode():void {
			DelayCallManager.getInstance().del(this.die);
			LoopManager.getInstance().removeITick(this);

			if (TableManager.getInstance().getBulletInfo(this.id).bombImg == 0) {
				this.die();
				return;
			}

			var pnfInfo:TPnfInfo=TableManager.getInstance().getPnfInfo(TableManager.getInstance().getBulletInfo(this.id).bombImg);

			//如果爆炸动画已经加载完毕
			if (LibManager.getInstance().chkData("magic/" + pnfInfo.imgId + ".pnf")) {
				this.rotation=0;

				var info:TActsInfo=TableManager.getInstance().getPnfActsInfo(TableManager.getInstance().getBulletInfo(this.id).bombImg);
				this.ui.updataArr(LibManager.getInstance().getSwfBmdArr("magic/" + pnfInfo.imgId + ".pnf"), new Point(pnfInfo.px, pnfInfo.py)); //中心坐标
				this.ui.updataAct(info.actInfo().startFrame, info.actInfo().endFrame, info.actInfo().interval, false);
				DelayCallManager.getInstance().add(this, this.die, "die", (info.actInfo().interval + 1) * (info.actInfo().preFrame - info.actInfo().spaceFrame));
			} else {
				die();
			}

		}

		override public function set rotation(value:Number):void {
			super.rotation=value;
			var info:TBulletInfo=TableManager.getInstance().getBulletInfo(this.id);
			this.tickX=Math.cos(this.rotation * Math.PI / 180) * info.speed;
			this.tickY=Math.sin(this.rotation * Math.PI / 180) * info.speed;
		}

		override public function die():void {
			LoopManager.getInstance().removeITick(this);
			super.die();
		}
	}
}