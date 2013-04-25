package com.leyou.game.scene.child {
	import com.ace.tools.SpriteNoEvt;
	import com.ace.ui.img.child.Image;

	public class Item extends SpriteNoEvt {
		private var img:Image;

		public function Item() {
			this.init();
//			Tools.addFlag(0,0,this);
		}

		private function init():void {
			this.img=new Image("", null, true);
			this.addChild(this.img);
		}

		public function updateBmp(appr:int):void {
			this.img.updateBmp("dnItems/" + appr + ".png");
		}

		public function die():void {
			this.img.die();
			this.parent.removeChild(this);
		}
	}
}