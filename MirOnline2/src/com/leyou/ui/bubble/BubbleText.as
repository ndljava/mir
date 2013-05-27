package com.leyou.ui.bubble {
	import com.leyou.ui.bubble.child.Bubble;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;

	public class BubbleText extends Sprite {

		private var bubble:Vector.<Bubble>;
		private var bubbleLeft:Vector.<Bubble>;
		private var bubbleRight:Vector.<Bubble>;

		public function BubbleText() {
			this.init();
		}

		/**
		 * 冒泡
		 * @param flag  0:直线向上 1：左弯 2：右弯
		 * @param type 冒泡的类型
		 * @param url 图片的路径
		 * @param txt "+-"+数字
		 * @param color 数字的颜色
		 *
		 */
		public function setText(flag:int, type:String, url:String, txt:String, color:int):void {
			var bubble:Bubble=new Bubble();
			bubble.setStr(url, type, txt, color);
			this.addChild(bubble);
			if (flag == 0)
				this.bubble.push(bubble);
			else if (flag == 1)
				this.bubbleLeft.push(bubble);
			else
				this.bubbleRight.push(bubble);
			if (!this.hasEventListener(Event.ENTER_FRAME))
				this.addEventListener(Event.ENTER_FRAME, onFramGo);
		}

		private function init():void {
			this.bubble=new Vector.<Bubble>;
			this.bubbleLeft=new Vector.<Bubble>;
			this.bubbleRight=new Vector.<Bubble>;

			this.mouseChildren=false;
			this.mouseEnabled=false;
		}

		private function onFramGo(evt:Event):void {
			var i:int;
			for (i=0; i < this.bubble.length; i++) {
				this.bubble[i].scaleX+=0.015;
				this.bubble[i].scaleY+=0.015;
				this.bubble[i].y-=1.5;
				if (this.bubble[i].y <= -40) {
					this.removeChild(this.bubble[i]);
					this.bubble.splice(i, 1);
				}
			}

			for (i=0; i < this.bubbleLeft.length; i++) {
				this.bubbleLeft[i].scaleX+=0.015;
				this.bubbleLeft[i].scaleY+=0.015;
				this.bubbleLeft[i].y-=1.5;
				this.bubbleLeft[i].x=(this.bubbleLeft[i].y * this.bubbleLeft[i].y) / (-2 * 20);
				if (this.bubbleLeft[i].y <= -45) {
					this.removeChild(this.bubbleLeft[i]);
					this.bubbleLeft.splice(i, 1);
				}
			}

			for (i=0; i < this.bubbleRight.length; i++) {
				this.bubbleRight[i].scaleX+=0.015;
				this.bubbleRight[i].scaleY+=0.015;
				this.bubbleRight[i].y-=1.5;
				this.bubbleRight[i].x=(this.bubbleRight[i].y * this.bubbleRight[i].y - 400) / 40;
				if (this.bubbleRight[i].y <= -40) {
					this.removeChild(this.bubbleRight[i]);
					this.bubbleRight.splice(i, 1);
				}
			}
			if (this.bubble.length <= 0 && this.bubbleLeft.length <= 0 && this.bubbleRight.length <= 0)
				this.removeEventListener(Event.ENTER_FRAME, onFramGo);
		}




	}
}