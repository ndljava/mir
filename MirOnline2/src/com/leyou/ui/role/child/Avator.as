package com.leyou.ui.role.child {
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.table.TItemAvatarInfo;
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
			this.bodyImg.x=44;
			this.addChild(this.bodyImg);
			this.clothImg=new Image();
			this.addChild(this.clothImg);
			this.hatImg=new Image();
			this.addChild(this.hatImg);
			this.weaponImg=new Image();
			this.addChild(this.weaponImg);
		}

		public function updateBody(id:int):void {
			this._body=id;
			if (_body == 0) {
				this.bodyImg.updateBmp("itemAvatar/n.png");
			} else if(_body==1)
				this.bodyImg.updateBmp("itemAvatar/v.png");
		}

		public function updateWeapon(id:int):void {
			var info:TItemAvatarInfo=TableManager.getInstance().getItemAvatarInfo(id.toString());
			if(info==null){
				this.weaponImg.bitmapData=null;
				return;
			}
			this.weaponImg.x=info.px;
			this.weaponImg.y=info.py;
			this._weapon=id;
			if (_weapon > 0)
				this.weaponImg.updateBmp("itemAvatar/" + _weapon + ".png");
			else
				this.weaponImg.bitmapData=null;
		}

		public function updateCloth(id:int):void {
			var info:TItemAvatarInfo=TableManager.getInstance().getItemAvatarInfo(id.toString());
			if(info==null){
				this.clothImg.bitmapData=null;
				return;
			}
			this.clothImg.x=info.px;
			this.clothImg.y=info.py;
			this._cloth=id;
			if (_cloth > 0) {
				this.clothImg.updateBmp("itemAvatar/" + _cloth + ".png");
			} else
				this.clothImg.bitmapData=null;
		}

		public function updateHat(id:int):void {
			var info:TItemAvatarInfo=TableManager.getInstance().getItemAvatarInfo(id.toString());
			if(info==null){
				this.hatImg.bitmapData=null;
				return;
			}
			this.hatImg.x=info.px;
			this.hatImg.y=info.py;
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