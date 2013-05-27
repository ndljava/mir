package com.leyou.game.scene {
	import com.ace.enum.KeysEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.game.core.SceneCore;
	import com.ace.game.scene.SceneModel;
	import com.ace.game.scene.part.LivingModel;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.player.PlayerInfo;
	import com.ace.manager.KeysManager;
	import com.ace.manager.LayerManager;
	import com.ace.reuse.ReuseDic;
	import com.leyou.config.Core;
	import com.leyou.game.scene.child.Item;
	import com.leyou.game.scene.player.Living;
	import com.leyou.game.scene.player.MyPlayer;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_backPack;

	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	public class MirScene extends SceneModel {
		protected var itemObj:Vector.<Item>=new Vector.<Item>;

		public function MirScene() {
			super();
		}

		override protected function init():void {
			super.init();
			this.reuseDic=new ReuseDic(Living, 200);
			!Core.bugTest && this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyUp);
			KeysManager.getInstance().addKeyFun(KeysEnum.SPACE, this.test); //测试
			//			LayerManager.getInstance().mainLayer.visible=false;
		}

		private function test():void {
			LayerManager.getInstance().mainLayer.visible=!LayerManager.getInstance().mainLayer.visible;
		}

		private function onKeyUp(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
//				case KeysEnum.KEY0:
				case KeysEnum.KEY1:
				case KeysEnum.KEY2:
				case KeysEnum.KEY3:
				case KeysEnum.KEY4:
				case KeysEnum.KEY5:
				case KeysEnum.KEY6:
				case KeysEnum.KEY7:
//				case KeysEnum.KEY8:
//				case KeysEnum.KEY9:
				case KeysEnum.Q:
				case KeysEnum.W:
				case KeysEnum.E:
					UIManager.getInstance().toolsWnd.onShortcutDown(evt.keyCode - 48);
					break;
			}
		}

		//切换地图时的操作
		private function onGotoMap():void {
			!Core.bugTest && UIManager.getInstance().addLoadingWnd();
			LayerManager.getInstance().windowLayer.hideAllWnd();
		}

		//传送到x地图
		override public function gotoMap($mapName:String, pt:Point):void {
			this.onGotoMap();
			super.gotoMap($mapName, pt);
		}

		override protected function _gotoMap(br:ByteArray, bmd:BitmapData):void {
//			UIManager.getInstance().hideLoadingWnd();
			Core.me && Core.me.sendCacheCmdWalk();
			super._gotoMap(br, bmd);
			!Core.bugTest && UIManager.getInstance().mapWnd.updataImg();
			if (Core.me) {
				Core.me.flyTo(this.nextPs.x, this.nextPs.y);
				this.setMapPs(this.nextPs.x * SceneEnum.TILE_WIDTH, this.nextPs.y * SceneEnum.TILE_HEIGHT);
			}
		}

		public function useMagic(magicId:int):Boolean {
			var pt:Point=SceneUtil.screenToTile(this.stage.mouseX - this.x, this.stage.mouseY - this.y);
			return Core.me.useMagic(pt, magicId, this.overPlayer);
		}

		public function getOtherPlayers():Vector.<LivingModel> {
			var arr:Vector.<LivingModel>=new Vector.<LivingModel>;
			for (var i:int=0; i < this.playerArr.length; i++) {
				if (this.playerArr[i].infoB.livingType == PlayerEnum.RACE_HUMAN) {
					arr.push(this.playerArr[i]);
				}
			}
			return arr;
		}

		//通过名字获取玩家 
		public function getPlayerByName(name:String):LivingModel {
			for (var i:int=0; i < this.playerArr.length; i++) {
				if (this.playerArr[i].infoB.livingType == PlayerEnum.RACE_HUMAN && this.playerArr[i].infoB.name == name) {
					return this.playerArr[i];
				}
			}
			return null;
		}

		public function checkPlayer(pt:Point):Boolean {
			for each (var living:LivingModel in this.playerArr) {
				if (pt.equals(living.nowTilePt()))
					return true;
			}
			return false;
		}

		public function get Players():Vector.<LivingModel> {
			return this.playerArr;
		}

		public function addMe(info:PlayerInfo):void {
			if (!Core.me) {
				Core.me=new MyPlayer(info);
				SceneCore.me=Core.me;
				this.selectPlayer=Core.me;
				this.sortLayer.addChild(Core.me);
				this.addPlayer(info.id, Core.me);
			}
			Core.me.flyTo(this.nextPs.x, this.nextPs.y);
			this.setMapPs(this.selectPlayer.x, this.selectPlayer.y);
			!Core.bugTest && UIManager.getInstance().roleHeadWnd.updataInfo(info);
			!Core.bugTest && UIManager.getInstance().smallMapWnd.updataPs();
		}

		public function addOtherLiving(info:LivingInfo, nameStr:String):Living {
			if (this.playerObj[info.id]) {
				if (info.type != 50)
					Living(this.playerObj[info.id]).changeDir(info.currentDir); //原地改变方向
				nameStr && Living(this.playerObj[info.id]).setName(nameStr); //刷怪添加名字

				return this.playerObj[info.id] as Living;
			}
			//			print("添加living:" + info.name + "--" + info.featureInfo.appr);
			var living:Living;
			switch (info.type) {
				case 0:
				case 100:
					info.livingType=PlayerEnum.RACE_HUMAN;
					break;
				case 50:
					info.currentDir=(info.currentDir) % 3;
					info.livingType=PlayerEnum.RACE_NPC;
//					MapInfoManager.getInstance().updataTile(info.nextTile.x, info.nextTile.y, NodeEnum.NODE_BLOCK);//设置npc为障碍点
					break;
				default:
					info.livingType=PlayerEnum.RACE_MONSTER;
					break;
			}
			living=new Living(new LivingInfo(info));
			living.statusChanged(info.status);
			this.sortLayer.addChild(living);
			this.addPlayer(info.id, living);
			living.flyTo(info.nextTile.x, info.nextTile.y);
			this.mapSort(living);
			//根据类型，创建不同的玩家、npc、怪物
			//传过去信息后，复制给自己的info
			//然后存放到场景的living字典内
			return living;
		}

		private function newLiving():LivingModel {
			return new LivingModel();
		}


		private function testMon():void {
		/*var f:FeatureInfo=new FeatureInfo();
		f.feature=3276841;

		var info:LivingInfo=new LivingInfo();
		info.id=111;
		info.name="僵尸|25/255";
		info.currentDir=0;
		info.nextTile.x=540;
		info.nextTile.y=150;
		info.race=0; //职业

		info.sex=0;
		info.type=-1; //种族

		info.featureInfo=f;
		info.featureInfo.appr=10;

		this.addOtherLiving(info);*/
		}

		public function addItem(id:int, px:int, py:int, appr:int):void {
			if (this.hasItemII(id))
				return;
			var item:Item=new Item(id);
			item.updateBmp(appr);
			item.x=SceneUtil.tileXToScreenX(px);
			item.y=SceneUtil.tileYToScreenY(py);
			this.noEvLayer.addChild(item);
			this.itemObj.push(item);
		}

		public function removeItem(id:int):void {
			var item:Item=this.getItem(id);
			if (!item)
				return;
			this.noEvLayer.removeChild(item);
			this.itemObj.splice(this.itemObj.indexOf(item), 1);
		}

		public function hasItem(pt:Point):Boolean {
			for each (var item:Item in this.itemObj) {
				if (pt.equals(SceneUtil.screenToTile(item.x, item.y))) {
					return true;
				}
			}
			return false;
		}

		public function pickUpItem(pt:Point):void {
			for each (var item:Item in this.itemObj) {
				if (pt.equals(SceneUtil.screenToTile(item.x, item.y))) {
					Cmd_backPack.cm_pickup(pt.x, pt.y); //如果有道具拾起来
				}
			}
		}

		private function hasItemII(id:int):Boolean {
			for each (var item:Item in this.itemObj) {
				if (id == item.id) {
					return true;
				}
			}
			return false;
		}

		public function getItem(id:int):Item {
			for each (var item:Item in this.itemObj) {
				if (id == item.id) {
					return item;
				}
			}
			return null;
		}

		override protected function reset():void {
			super.reset();
			var item:Item
			for (var id:String in this.itemObj) {
				item=this.itemObj[id];
				delete this.itemObj[id];
				if (id.indexOf("_") == -1) {
					item.die();
				}
			}
			while (this.itemObj.length) {
				this.itemObj.shift();
			}
		}
	}
}