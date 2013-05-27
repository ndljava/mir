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
	import com.leyou.ui.tips.TipsEquipsEmpty;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SmallMapWnd extends AutoSprite {
		private var nameLbl:Label;
		private var modelLbl:Label;
		private var MBtn:ImgButton;

		private var mapContent:MapProxy;

		private var tips:TipsEquipsEmpty;

		public function SmallMapWnd() {
			super(LibManager.getInstance().getXML("config/ui/SmallMapWnd.xml"));
			this.mouseChildren=true;
			this.mouseEnabled=true;
			this.init();
		}

		private function init():void {
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.modelLbl=this.getUIbyID("modelLbl") as Label;
			this.MBtn=this.getUIbyID("MBtn") as ImgButton;

			this.mapContent=new MapProxy("small");
			this.addChild(this.mapContent);

			this.MBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.mapContent.addEventListener(MouseEvent.CLICK, onClick);
			
			this.modelLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.modelLbl.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.modelLbl.mouseEnabled=true;
			
			this.tips=new TipsEquipsEmpty();
			this.addChild(this.tips);
			this.tips.visible=false;
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

			Core.me.onSceneClick(null, pt);
			this.mapContent.updatePathArr();
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

		private function onMouseOver(e:MouseEvent):void {
			var ltxt:String=Label(e.target).text;

			if (ltxt == "战斗") {
				this.tips.showString("<font color='#00ff00'>杀人不增加pk值\n死亡不掉落物品</font>");
			} else if (ltxt == "安全") {
				this.tips.showString("<font color='#00ff00'>禁止pk</font>");
			} else if (ltxt == "攻城区域") {
				this.tips.showString("<font color='#00ff00'>杀人不增加pk值\n</font><font color='#ff0000'>死亡掉落物品</font>");
			} else if (ltxt == "普通") {
				this.tips.showString("<font color='#ff0000'>杀人增加pk值\n死亡掉落物品</font>");
			}

			this.tips.x=this.mouseX;
			this.tips.y=this.mouseY;
			this.tips.visible=true;
		}

		private function onMouseOut(e:MouseEvent):void {
			this.tips.visible=false;
		}

		public function updateModel(i:int):void {
			this.modelLbl.text="";

			if (i == 0) {
				this.modelLbl.text="普通";
				return;
			}

			var _i:String=i.toString(2);
			var str:String="";
			switch (int(_i.substr(_i.length - 2))) {
				case 1:
					str="战斗";
					break
				case 2:
					str="安全";
					break
				case 3:
					str="攻城区域";
					break
				case 10:
					str="安全";
					break
			}

			this.modelLbl.text=str;
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
