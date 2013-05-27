package com.leyou.ui.bubble.child {
	import com.ace.ui.img.child.Image;
	import com.leyou.enum.BubbleEnum;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Bubble extends Sprite {
		private var img:Image;
		private var typeImg:Image;
		private var imgArr:Array;

		public function Bubble() {
			super();
			this.init();
		}

		private function init():void {
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.img=new Image();
			this.typeImg=new Image();
			this.imgArr=new Array();
		}

		public function setStr(url:String, type:String, str:String, c:int):void {
			if (url == "")
				this.img.visible=false;
			else {
				this.img.updateBmp(url);
				this.addChild(this.img);
			}
			this.typeImg.updateBmp("ui/num/" + type + ".png");
			this.addChild(this.typeImg);
			if (img.visible == true)
				this.typeImg.x=this.img.x + this.img.width;
			else
				this.typeImg.x=0;
			var strArr:Array=str.split("");
			var i:int;
			for (i=0; i < strArr.length; i++) {
				var img:Image=this.getNum(c, strArr[i]);
				if (img != null) {
					this.addChild(img);
					this.imgArr.push(img);
				}
			}
			for (i=0; i < this.imgArr.length; i++) {
				if (i == 0)
					this.imgArr[i].x=this.typeImg.x + this.typeImg.width;
				else
					this.imgArr[i].x=this.imgArr[i - 1].x + 8;
			}
		}

		private function getNum(c:int, str:String):Image {
			if (str == "")
				return null;
			if (c == BubbleEnum.CLOLOR_BLUE)
				return new Image("ui/num/B" + str + ".png");
			if (c == BubbleEnum.CLOLOR_GREEN)
				return new Image("ui/num/G" + str + ".png");
			if (c == BubbleEnum.CLOLOR_RED)
				return new Image("ui/num/R" + str + ".png");
			return null;
		}


	}
}