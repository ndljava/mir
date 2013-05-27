package com.leyou.ui.buff {
	import com.leyou.data.net.buff.TBuff;
	import com.leyou.ui.buff.child.BuffItem;
	
	import flash.display.Sprite;

	public class Buff extends Sprite {
		private var buffList:Vector.<BuffItem>; //buf队列

		public function Buff() {
			this.mouseEnabled=false;
			this.init();
		}

		private function init():void {
			this.x=10;
			this.y=120;
			this.buffList=new Vector.<BuffItem>;
		}

		//添加buf
		public function addBuff(info:TBuff):void {
			if (this.checkBuff(info))
				return;
			if (this.buffList.length >= 16)
				return;
			var buff:BuffItem=new BuffItem();
			buff.time=info.nTime / 1000;
			buff.iconIdx=info.nImgIndex;
			buff.tipsStr=info.str;
			buff.timeStart();
			this.buffList.push(buff);
			buff.timeOutFun=this.deleteBuff;

			if (this.buffList.length < 9) {
				buff.x=(this.buffList.length - 1) * 32;
			} else {
				buff.x=(this.buffList.length - 9) * 32;
				buff.y=36;
			}
			this.addChild(buff);
		}

		private function deleteBuff(buff:BuffItem):void {
			var i:int=this.buffList.indexOf(buff);
			if (i != -1) {
				this.removeChild(this.buffList[i]);
				this.buffList[i].clearMe();
				this.buffList.splice(i, 1);
			}
			for (i=0; i < this.buffList.length; i++) {
				if (i < 8) {
					buffList[i].x=i * 32;
					buffList[i].y=0;
				} else {
					buffList[i].x=(i - 8) * 32;
					buffList[i].y=36;
				}
			}
		}

		private function checkBuff(info:TBuff):Boolean {
			for (var i:int=0; i < this.buffList.length; i++) {
//				if (this.buffList[i].iconIdx == info.nImgIndex &&
//					this.buffList[i].time == int(info.nTime/1000)&&
//					this.buffList[i].tipsStr==info.str) {
				if(this.buffList[i].iconIdx == info.nImgIndex){
					this.buffList[i].tipsStr=info.str;
					this.buffList[i].timeStop();
//					this.buffList[i].time=10;
					this.buffList[i].time=info.nTime / 1000;
					this.buffList[i].timeStart();
					return true;
					break;
				}
			}
			return false;
		}

	}
}