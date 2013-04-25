package com.leyou.game.skill.bullets {
	import com.ace.game.utils.SceneUtil;

	import flash.geom.Point;

	public class BulletTarget extends BulletFly {
		private var targetPt:Point;

		public function BulletTarget(pt:Point) {
			this.targetPt=pt;
			super();

		}


		override public function onTick():void {
			this.x+=this.tickX;
			this.y+=this.tickY;

//			if (Point.distance(this.targetPt, new Point(this.x, this.y)) < 10) {
			if (Point.distance(this.targetPt, new Point(this.x, this.y)) < 20) {
				this.explode();
			}
		}
	}
}