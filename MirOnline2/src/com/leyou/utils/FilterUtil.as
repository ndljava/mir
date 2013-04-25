package com.leyou.utils {
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	public class FilterUtil {

		public static var enablefilter:ColorMatrixFilter=new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]);

		public static var greenGlowFilter:GlowFilter=new GlowFilter(0x0e8671);

		public function FilterUtil() {
		}

		/**
		 * 
		 * @param d
		 * @param _color
		 * @param _alpha
		 * @param _blurX
		 * @param _blurY
		 * @param _strength
		 * @return 
		 * 
		 */
		public static function showGlowFilter(d:DisplayObject,t:Number=3,_color:uint=0x0e8671,_alpha:int=1,_blurX:int=6,_blurY:int=6,_strength:int=6):TweenMax
		{
			return TweenMax.to(d,t,{glowFilter:{color:_color,alpha:_alpha,blurX:_blurX,blurY:_blurY,strength:_strength},repeat:-1,repeatDelay:3});
		}
	}
}
