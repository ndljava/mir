package com.leyou.ui.smallMap {
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.game.scene.part.LivingModel;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.scene.MapInfo;
	import com.ace.gameData.scene.MapInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.print;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.config.Core;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.map.MapProxy;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SmallMapWnd extends AutoSprite {
		private var nameLbl:Label;
		private var MBtn:ImgButton;

		private var mapContent:MapProxy;

		public function SmallMapWnd() {
			super(LibManager.getInstance().getXML("config/ui/SmallMapWnd.xml"));
			this.mouseChildren=true;
			this.mouseEnabled=true;
			this.init();
		}

		private function init():void {
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.MBtn=this.getUIbyID("MBtn") as ImgButton;

			this.mapContent=new MapProxy("small");
			this.addChild(this.mapContent);
			
			this.MBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.mapContent.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.currentTarget.name) {
				case "MBtn":
					UIManager.getInstance().mapWnd.open();
					break;
			}
			evt.stopPropagation();
		}
		
		private function onClick(evt:MouseEvent):void {
			if (evt.localX < this.mapContent.mapImg_X || evt.localY < this.mapContent.mapImg_Y || evt.localX > (this.mapContent.mapImg_X + this.mapContent.mapImg_W) || evt.localY > (this.mapContent.mapImg_Y + this.mapContent.mapImg_H)) {
				//				print("单击出界了！！");
				return;
			}
			
			var sx:Number=(evt.localX - this.mapContent.mapImg_X) * this.mapContent.scaleMapPt.x;
			var sy:Number=(evt.localY - this.mapContent.mapImg_Y) * this.mapContent.scaleMapPt.y;
			
			var pt:Point=SceneUtil.screenToTile(sx, sy);
			if (!MapInfoManager.getInstance().walkable(pt.x, pt.y)) {
				print("该点是阻挡点了");
				return;
			}
			
			Core.me.findPath(pt);
		}

		public function updateImg():void {
			this.mapContent.updateImg();
		}

		/**
		 * 更新全部 
		 * 
		 */		
		public function updataPs():void {
			this.nameLbl.text=TableManager.getInstance().getMapInfo(MapInfoManager.getInstance().id).name + " " + Core.me.nowTilePt().x + ":" + Core.me.nowTilePt().y;
			this.mapContent.updataSmallPs();
		}
		
		public function addItem(id:int, pt:Point, type:int):void {
			this.mapContent.addItem(id, pt, type);
		}
		
		public function dieItem(id:int):void {
			this.mapContent.dieItem(id);
		}
		
		public function updatePs(id:int, pt:Point):void {
			this.mapContent.updatePs(id, pt);
		}

		public function resize():void {
			this.x=UIEnum.WIDTH - 188;
		}
	}
}
