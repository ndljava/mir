package com.leyou.ui.map {
	import com.ace.enum.PlayerEnum;
	import com.ace.game.scene.part.LivingModel;
	import com.ace.gameData.scene.MapInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.img.child.Image;
	import com.leyou.config.Core;
	import com.leyou.manager.UIManager;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class MapProxy extends Sprite {

		private var mapImg:Image;

		private var me:Sprite;
		private var otherArr:Vector.<Sprite>;
		private var roleSpr:Sprite;

		private var scaleMap:Point;

		private var hasMap:Boolean;

		private var mapType:String;

		public function MapProxy(type:String="map") {
			super();
			this.init(type);
		}

		private function init(type:String):void {
			this.mapImg=new Image();
			this.mapType=type;

			if (type == "small") {
				var mapMask:Shape=new Shape;
				mapMask.graphics.beginFill(0x00ff00);
				mapMask.graphics.drawCircle(0, 0, 70);
				mapMask.graphics.endFill();

				var mp:Sprite=new Sprite();
				mp.addChild(mapMask);

				mp.x=100;
				mp.y=120;

				this.addChild(mp);
				this.mapImg.mask=mp;
			}

			this.addChild(this.mapImg);

			this.otherArr=new Vector.<Sprite>();
			this.scaleMap=new Point();

			this.roleSpr=new Sprite();
			this.addChild(this.roleSpr);

			this.me=new Sprite();
			var mebd:Bitmap=new Bitmap(LibManager.getInstance().getImg("ui/map/self.png"));

			mebd.x=-16;
			mebd.y=-16;
			this.me.addChild(mebd);

			this.addChild(this.me);
		}

		public function updateImg():void {
			this.hasMap=LibManager.getInstance().chkData("scene/" + MapInfoManager.getInstance().id + "/map.jpg");
			if (!this.hasMap)
				return;

			this.scaleMap.x=this.scaleMap.y=1;
			this.mapImg.scaleX=this.mapImg.scaleY=1;
			this.mapImg.bitmapData=LibManager.getInstance().getImg("scene/" + MapInfoManager.getInstance().id + "/map.jpg");

			this.scaleMap.x=MapInfoManager.getInstance().mapW / this.mapImg.width;
			this.scaleMap.y=MapInfoManager.getInstance().mapH / this.mapImg.height;
		}

		public function reSize(scalePt:Point):void {
			var scaleXY:Number=Math.min(scalePt.x / this.mapImg.width, scalePt.y / this.mapImg.height);

			this.mapImg.scaleX=this.mapImg.scaleY=scaleXY;
			this.mapImg.x=20 + (scalePt.x - this.mapImg.width) / 2;
			this.mapImg.y=34 + (scalePt.y - this.mapImg.height) / 2;

			this.scaleMap.x=MapInfoManager.getInstance().mapW / this.mapImg.width;
			this.scaleMap.y=MapInfoManager.getInstance().mapH / this.mapImg.height;
		}

		/**
		 * 刷新小地图
		 *
		 */
		public function updataSmallPs():void {
			this.me.rotation=Core.me.infoB.currentDir * 45;

			var dx:Number=(Core.me.x / this.scaleMap.x);
			var dy:Number=(Core.me.y / this.scaleMap.y);

			if (-dx + 100 + this.mapImg.width > 170) {
				this.mapImg.x=-dx + 100;
				this.me.x=100;
			} else {
				this.mapImg.x=170 - this.mapImg.width;
				this.me.x=dx + this.mapImg.x;
			}

			if (-dy + 120 + this.mapImg.height > 190) {
				this.mapImg.y=-dy + 120;
				this.me.y=120;
			} else {
				this.mapImg.y=190 - this.mapImg.height;
				this.me.y=dy + this.mapImg.y;
			}

			//待定
			while (this.roleSpr.numChildren)
				this.roleSpr.removeChildAt(0);

			var otherVec:Vector.<LivingModel>=UIManager.getInstance().mirScene.Players;
			var img:Bitmap;
			var spr:Sprite;
			var live:LivingModel;

			for each (live in otherVec) {
				if (live.infoB.name == Core.me.infoB.name)
					continue;

				if (this.roleSpr.getChildByName(live.infoB.id + "_m")) {
					spr=this.roleSpr.getChildByName(live.infoB.id + "_m") as Sprite;
				} else {

					if (live.infoB.livingType == PlayerEnum.RACE_HUMAN)
						img=new Bitmap(LibManager.getInstance().getImg("ui/map/other.png"));
					else if (live.infoB.livingType == PlayerEnum.RACE_MONSTER)
						img=new Bitmap(LibManager.getInstance().getImg("ui/map/monster.png"));
					else if (live.infoB.livingType == PlayerEnum.RACE_NPC)
						img=new Bitmap(LibManager.getInstance().getImg("ui/map/npc.png"));

					spr=new Sprite();
					spr.addChild(img);
					spr.name=live.infoB.id + "_m";

					this.otherArr.push(spr);
					this.roleSpr.addChild(spr);
				}

				spr.x=live.x / this.scaleMap.x + this.mapImg.x;
				spr.y=live.y / this.scaleMap.y + this.mapImg.y;
			}
		}

		/**
		 * 刷新中地图
		 *
		 */
		public function updataMapPs():void {

			this.me.rotation=Core.me.infoB.currentDir * 45;

			this.me.x=this.mapImg.x + Math.floor(Core.me.x / this.scaleMap.x);
			this.me.y=this.mapImg.y + Math.floor(Core.me.y / this.scaleMap.y);

			//待定
			while (this.roleSpr.numChildren)
				this.roleSpr.removeChildAt(0);

			var otherVec:Vector.<LivingModel>=UIManager.getInstance().mirScene.Players;
			var img:Bitmap;
			var spr:Sprite;
			var live:LivingModel;
			for each (live in otherVec) {
				if (live.infoB.name == Core.me.infoB.name)
					continue;

				if (this.roleSpr.getChildByName(live.infoB.id + "_m")) {
					spr=this.roleSpr.getChildByName(live.infoB.id + "_m") as Sprite;
				} else {

					if (live.infoB.livingType == PlayerEnum.RACE_HUMAN)
						img=new Bitmap(LibManager.getInstance().getImg("ui/map/other.png"));
					else if (live.infoB.livingType == PlayerEnum.RACE_MONSTER)
						img=new Bitmap(LibManager.getInstance().getImg("ui/map/monster.png"));
					else if (live.infoB.livingType == PlayerEnum.RACE_NPC)
						img=new Bitmap(LibManager.getInstance().getImg("ui/map/npc.png"));

					spr=new Sprite();
					spr.addChild(img);
					spr.name=live.infoB.id + "_m";

					this.otherArr.push(spr);
					this.roleSpr.addChild(spr);
				}

				spr.x=live.x / this.scaleMap.x + this.mapImg.x;
				spr.y=live.y / this.scaleMap.y + this.mapImg.y;
			}
		}

		/**
		 * 添加玩家
		 * @param id
		 * @param pt 位置
		 * @param type
		 *
		 */
		public function addItem(id:int, pt:Point, type:int):void {
			var img:Bitmap;
			var spr:Sprite;

			if (type == PlayerEnum.RACE_HUMAN)
				img=new Bitmap(LibManager.getInstance().getImg("ui/map/other.png"));
			else if (type == PlayerEnum.RACE_MONSTER)
				img=new Bitmap(LibManager.getInstance().getImg("ui/map/monster.png"));
			else if (type == PlayerEnum.RACE_NPC)
				img=new Bitmap(LibManager.getInstance().getImg("ui/map/npc.png"));

			spr=new Sprite();
			spr.addChild(img);
			spr.name=id + "_m";

			this.otherArr.push(spr);
			this.roleSpr.addChild(spr);

			spr.x=pt.x / this.scaleMap.x + this.mapImg.x;
			spr.y=pt.y / this.scaleMap.y + this.mapImg.y;

		}

		/**
		 * 移除
		 * @param id
		 *
		 */
		public function dieItem(id:int):void {
			var spr:Sprite=this.roleSpr.getChildByName(id + "_m") as Sprite;
			this.otherArr.splice(this.otherArr.indexOf(spr), 1);
			this.roleSpr.removeChild(spr);
		}

		/**
		 * 更新位置
		 * @param id
		 * @param pt
		 *
		 */
		public function updatePs(id:int, pt:Point):void {
			var spr:Sprite=this.roleSpr.getChildByName(id + "_m") as Sprite;

			spr.x=pt.x / this.scaleMap.x + this.mapImg.x;
			spr.y=pt.y / this.scaleMap.y + this.mapImg.y;
		}

		public function get mapImg_X():int {
			return this.mapImg.x;
		}

		public function get mapImg_Y():int {
			return this.mapImg.y;
		}

		public function get mapImg_W():int {
			return this.mapImg.width;
		}

		public function get mapImg_H():int {
			return this.mapImg.height;
		}

		public function get scaleMapPt():Point {
			return this.scaleMap;
		}



	}
}
