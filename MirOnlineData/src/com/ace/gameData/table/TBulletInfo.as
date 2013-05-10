package com.ace.gameData.table {

	public class TBulletInfo {
		public var id:int;
		public var type:int;
		public var imgId:int;
		public var isRotation:Boolean;
		public var follow:int;
		public var px:int;
		public var py:int;
		public var carrier:int;
		public var lastTime:int;
		public var track:int;
		public var speed:int;
		public var crash:Boolean;
		public var bombImg:int;

		public function TBulletInfo(info:XML) {
			this.id=info.@id;
			this.type=info.@type;
			this.imgId=info.@imgId;
			this.isRotation=(info.@isRotation == "1") ? true : false;
			this.follow=info.@follow;
			this.px=info.@px;
			this.py=info.@py;
			this.carrier=info.@carrier;
			this.lastTime=info.@lastTime;
			this.track=info.@track;
			this.speed=info.@speed;
			this.crash=(info.@crash == "1") ? true : false;
			this.bombImg=info.@bombImg;
		}
	}
}


/*
<!-- id="" name="" 类型="1静止的/2直线飞/3抛物线/4火枪的" 子弹img="" 是否旋转="0/1" 跟随="1鼠标/2发送者/3接受者" 偏移=""  载体="1场景/2发送者/3接受者" 持续时间="buff时候用(载体为2)" 轨迹="1/原地/2直线/3抛物线/" 速度="" 是否碰撞="0/1" 爆炸img="" -->
*/