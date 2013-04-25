package com.leyou.game.skill.bullets {
	import com.ace.ICommon.ILoaderCallBack;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.table.TActInfo;
	import com.ace.gameData.table.TPnfInfo;
	import com.ace.loaderSync.SyncLoader;
	import com.ace.loaderSync.child.BackObj;
	import com.ace.manager.LibManager;
	import com.ace.movie.SwfBmpMovie;
	import com.ace.tools.SpriteNoEvt;
	import com.ace.utils.DebugUtil;
	
	import flash.display.BlendMode;
	import flash.geom.Point;

	public class BulletModel extends SpriteNoEvt implements ILoaderCallBack {
		static public const SYNC_LOADER:SyncLoader=new SyncLoader();

		public var id:int; //子弹ID
		public var targetId:int; //目标ID
		public var isLoop:Boolean;

		public var ui:SwfBmpMovie;

		public function BulletModel() {
			this.ui=new SwfBmpMovie();
			this.addChild(this.ui);
//			DebugUtil.addFlag(0, 0, this);
		}

		public function creat($targetId:int, $id:int, $isLoop:Boolean=true):void {
			this.targetId=$targetId;
			this.id=$id;
			this.isLoop=$isLoop;
			this.loadMagic();
		}

		protected function loadMagic():void {
			var info:TPnfInfo=TableManager.getInstance().getPnfInfo(TableManager.getInstance().getBulletInfo(this.id).imgId);
			var _info:BackObj=new BackObj();
			_info.owner=this;
			_info.param["id"]=this.id;
			SYNC_LOADER.addLoader("magic/" + info.imgId + ".pnf", _info);
		}

		public function callBackFun(obj:Object):void {
			var info:TPnfInfo=TableManager.getInstance().getPnfInfo(TableManager.getInstance().getBulletInfo(this.id).imgId);
			var actInfo:TActInfo=TableManager.getInstance().getActsInfo(info.actId).actInfo();
			this.ui.blendMode=info.blend ? BlendMode.ADD : BlendMode.NORMAL;
			this.ui.updataArr(LibManager.getInstance().getSwfBmdArr("magic/" + info.imgId + ".pnf"), new Point(info.px, info.py)); //中心坐标
			this.ui.updataAct(actInfo.startFrame, actInfo.endFrame, actInfo.interval, isLoop);
		}

		public function die():void {
			SYNC_LOADER.delLoaderII(this);
			this.ui.die();
			this.parent && this.parent.removeChild(this);
		}
	}
}