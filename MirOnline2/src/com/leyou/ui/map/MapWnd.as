package com.leyou.ui.map {
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.scene.MapInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.print;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.leyou.config.Core;
	import com.leyou.manager.UIManager;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MapWnd extends AutoWindow {

		private var psLbl:Label;
		private var hasMap:Boolean;

		private var scalePt:Point=new Point(600, 480);
		private var scaleMap:Point=new Point(0, 0);

		private var mapContent:MapProxy;

		public function MapWnd() {
			super(LibManager.getInstance().getXML("config/ui/MapWnd.xml"));
			this.init();
		}

		private function init():void {
			this.psLbl=this.getUIbyID("psLbl") as Label;
			this.mapContent=new MapProxy();

			this.addChild(this.mapContent);

			this.mapContent.mouseEnabled=true;
			this.mapContent.addEventListener(MouseEvent.CLICK, onClick);
			this.mapContent.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		public function updataImg():void {
			this.hasMap=LibManager.getInstance().chkData("scene/" + MapInfoManager.getInstance().id + "/map.jpg");
			if (!this.hasMap)
				return;

			this.mapContent.updateImg();
			this.mapContent.reSize(scalePt);
			//更新小地图
			UIManager.getInstance().smallMapWnd.updateImg();
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			if (!this.hasMap)
				return;
			super.show(toTop, toCenter);

			updataPs();
		}

		private function onMouseMove(evt:MouseEvent):void {
			if (evt.localX < this.mapContent.mapImg_X || evt.localY < this.mapContent.mapImg_Y || evt.localX > (this.mapContent.mapImg_X + this.mapContent.mapImg_W) || evt.localY > (this.mapContent.mapImg_Y + this.mapContent.mapImg_H)) {
				//				print("单击出界了！！");
				return;
			}

			var sx:Number=(evt.localX - this.mapContent.mapImg_X) * this.mapContent.scaleMapPt.x;
			var sy:Number=(evt.localY - this.mapContent.mapImg_Y) * this.mapContent.scaleMapPt.y;

			var pt:Point=SceneUtil.screenToTile(sx, sy);
			this.psLbl.text="X:" + pt.x + " Y:" + pt.y;
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

		/**
		 * 更新全部列表
		 *
		 */
		public function updataPs():void {
			this.mapContent.updataMapPs();
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

	}
}
