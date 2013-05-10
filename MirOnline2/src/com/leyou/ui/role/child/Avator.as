package com.leyou.ui.role.child {
	import com.ace.ui.img.child.Image;

	import flash.display.Sprite;
	import flash.media.Video;

	public class Avator extends Sprite {
		//itemAvatar图片的路径
		private var bodyImg:Image;
		private var weaponImg:Image;
		private var clothImg:Image;
		private var hatImg:Image;

		private var _body:int;
		private var _weapon:int;
		private var _cloth:int;
		private var _hat:int;

		public function Avator():void {
			this.bodyImg=new Image();
			this.bodyImg.x=28;
			this.bodyImg.y=42;
			this.addChild(this.bodyImg);
			this.weaponImg=new Image();
			this.addChild(this.weaponImg);
			this.clothImg=new Image();
			this.addChild(this.clothImg);
			this.hatImg=new Image();
			this.hatImg.x=66;
			this.hatImg.y=32;
			this.addChild(this.hatImg);
		}

		public function updateBody(id:int):void {
			this._body=id;
			if (_body == 0) {
				this.bodyImg.updateBmp("itemAvatar/n.png");
			} else if(_body==1)
				this.bodyImg.updateBmp("itemAvatar/v.png");
		}

		public function updateWeapon(id:int):void {
			this._weapon=id;
			if (_weapon > 0)
				this.weaponImg.updateBmp("itemAvatar/" + _weapon + ".png");
			else
				this.weaponImg.bitmapData=null;
		}

		public function updateCloth(id:int):void {
			this._cloth=id;
			if (_cloth > 0) {
				this.clothImg.updateBmp("itemAvatar/" + _cloth + ".png");
			} else
				this.clothImg.bitmapData=null;
		}

		public function updateHat(id:int):void {
			this._hat=id;
			if (_hat > 0) {
				this.hatImg.updateBmp("itemAvatar/" + _hat + ".png");
			} else
				this.hatImg.bitmapData=null;
		}

		public function get bodyId():int {
			return this._body;
		}

		public function get weaponId():int {
			return this._weapon;
		}

		public function get clothId():int {
			return this._cloth;
		}

		public function get hatId():int {
			return this._hat;
		}
	}
}