package com.leyou.ui.chat.child {
	import com.ace.enum.FontEnum;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.img.child.Image;
	import com.leyou.enum.ChatEnum;
	import com.leyou.manager.UIManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class FaceWnd extends Sprite {
		private var imgArr:Vector.<Sprite>;
		private var _sta:Boolean;

		public function FaceWnd() {
			this.mouseChildren=true;
			this.init();
		}

		private function init():void {
			this.imgArr=new Vector.<Sprite>;
			var bmp:Image;
			var sp:Sprite;
			for (var i:int=0; i < 40; i++) {
				bmp=new Image();
				sp=new Sprite();
				var url:String="ui/chat/face/" + ChatEnum.imgKeyArr[i] + ".png";
				bmp.updateBmp(url);
				sp.addChild(bmp);
				sp.x=i % 10 * (20+5)+5;
				sp.y=Math.floor(i / 10) * (20+5)+5;
				sp.name=ChatEnum.imgKeyArr[i];
				this.addChild(sp);
				this.imgArr.push(sp);
				sp.useHandCursor=true;
				sp.addEventListener(MouseEvent.CLICK, onImgClick);
			}
			var bg:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.STYLE_NAME_DIC["PanelBgOut"]));
			bg.scale9Grid=FontEnum.RECTANGLE_DIC["PanelBgOut"];
			bg.setSize(this.width+10,this.height+10);
			bg.alpha=.8;
			this.addChildAt(bg,0);
		}

		private function onImgClick(evt:MouseEvent):void {
			var str:String=evt.currentTarget.name;
			UIManager.getInstance().chatWnd.addFaceSign("\\" + str);
			this.visible=false;
		}

		public function get face():Vector.<Sprite> {
			return this.imgArr;
		}
	}
}