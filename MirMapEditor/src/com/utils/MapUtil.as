package com.utils
{
	import com.ui.map.MapPanel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;

	public class MapUtil
	{
		public static const COLOR_ZERO_RED:uint = 0xFF0000;
		public static const COLOR_ONE_YELLOW:uint = 0xFFFF00;
		public static const COLOR_TWO_BLUE:uint = 0x0000FF;
		public static const COLOR_THREE_GREEN:uint = 0x008000;
		
		public static const COLOR_FOUR_GRAY:uint = 0x808080;
		public static const COLOR_FIVE_ORANGE:uint = 0xFFA500;
		public static const COLOR_SIX_GOLD:uint = 0xFFD700;
		public static const COLOR_SEVEN_PURPLE:uint = 0x800080;
		
		public static const COLOR_EIGHT_TAN:uint = 0xD2B48C;
		public static const COLOR_NINE_DARKRED:uint = 0x8B0000;
		public static const COLOR_TEN_DARKBLUE:uint = 0x00008B;
		public static const COLOR_ELEVEN_INDIGO:uint = 0x4B0082;
		
		public static const COLOR_TWELVE_DARKORANGE:uint = 0xFF8C00;
		public static const COLOR_THIRTEEN_PINK:uint = 0xFFC0CB;
		public static const COLOR_FOURTEEN_DEEPPINK:uint = 0xFF1493;
		public static const COLOR_FIFTEEN_TOMATO:uint = 0xFF6347;
		public static const COLOR_BLACK:uint = 0x000000;
		public static const glow:GlowFilter = new GlowFilter(0xCC0000,0.5, 5, 5,10, 1,false,false);
		/**
		 *填充颜色的格子 
		 * @param w
		 * @param color
		 * @param r
		 * @return 
		 * 
		 */		
		public static function drawGrid(w:Number,h:Number,color:uint = 0xffffff,r:Number = 0):Sprite
		{
			var _shap:Sprite = new Sprite();
//			var ui:UIComponent = new UIComponent();
			_shap.graphics.beginFill(color,r);
//			_shap.graphics.lineStyle(0,color);
			if(MapPanel.instance.gridType == MapPanel.outside_diamond || MapPanel.instance.gridType == MapPanel.inside_diamond)//棱形
			{
				_shap.graphics.moveTo(0,0);
				_shap.graphics.lineTo(1/2*w,-1/2*h);
				_shap.graphics.lineTo(w,0);
				_shap.graphics.lineTo(1/2*w,1/2*h);
				_shap.graphics.lineTo(0,0);
			}
			else if(MapPanel.instance.gridType == 1)//方形
			{
				_shap.graphics.drawRect(0,0,w,h);
			}
			_shap.graphics.endFill();
//			ui.addChild(_shap);
			return _shap;
		}
		/**
		 * 只有边缘的格子
		 * @param w
		 * @param color
		 * @param r
		 * @return 
		 * 
		 */		
		public static function gridGridEdge(w:Number,h:Number,color:uint = 0xffffff,lineS:int = 1,r:Number = 0):Shape
		{
			var _shap:Shape = new Shape();
			_shap.graphics.lineStyle(r,color);
			if(MapPanel.instance.gridType == MapPanel.outside_diamond || MapPanel.instance.gridType == MapPanel.inside_diamond)//棱形
			{
				_shap.graphics.moveTo(0,0);
				_shap.graphics.lineTo(1/2*w,-1/2*h);
				_shap.graphics.lineTo(w,0);
				_shap.graphics.lineTo(1/2*w,1/2*h);
				_shap.graphics.lineTo(0,0);
			}
			else if(MapPanel.instance.gridType == 1)//方形
			{
				_shap.graphics.drawRect(0,0,w,h);
			}
			return _shap;
		}
		/*通过编号得到面板的title*/
		public static function getTitleByIdx($idx:int):String
		{
			var __title:String;
			switch($idx)
			{
				case MirMapEditer.SCENE:
					__title = "场景编辑";
					break;
				case MirMapEditer.EFFECT:
					__title = "特效编辑";
					break;
				case MirMapEditer.MONSTER:
					__title = "NPC/怪物编辑";
					break;
				case MirMapEditer.BOX:
					__title = "宝箱编辑";
					break;
				case MirMapEditer.AREA:
					__title = "区域编辑";
					break;
				case MirMapEditer.OBSTACLE:
					__title = "障碍编辑";
					break;
				case MirMapEditer.PATROL:
					__title = "巡逻编辑";
					break;
				case MirMapEditer.POINT:
					__title = "点编辑";
					break;
				default:
				{
					__title = "";
					break;
				}
			}
			return __title;
		}
		/*通过编号得到状态的信息*/
		public static function getStaTitleByIdx($idx:int):String
		{
			var __title:String;
			switch($idx)
			{
				case MirMapEditer.SCENE:
					__title = "已种场景";
					break;
				case MirMapEditer.EFFECT:
					__title = "已种特效";
					break;
				case MirMapEditer.MONSTER:
					__title = "已种怪物";
					break;
				case MirMapEditer.BOX:
					__title = "已种宝箱";
					break;
				case MirMapEditer.AREA:
					__title = "区域列表";
					break;
				case MirMapEditer.OBSTACLE:
					__title = "障碍列表";
					break;
				case MirMapEditer.PATROL:
					__title = "巡逻列表";
					break;
				case MirMapEditer.POINT:
					__title = "点列表";
					break;
				default:
				{
					__title = "";
					break;
				}
			}
			return __title;
		}
		static public function getStringByInt(i:int):String
		{
			var str:String = new String();
			if(i < 10)
				str = "000"+i;
			else if(i < 100)
				str = "00"+i;
			else if(i < 1000)
				str = "0"+i;
			return str;
		}
		static public function notMapAlert():void
		{
			Alert.show("亲，你还没有新建地图呢，请先新建地图")
		}
		/**
		 *切割地图 并保存
		 * @param _img
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		static public function cutMap($img:BitmapData,$w:int,$h:int,$path:String):Array
		{
			var arr:Array = new Array();
			var xNum:int = Math.ceil(Number($img.width)/$w);
			var yNum:int = Math.ceil(Number($img.height)/$h);
			for (var i:int=0; i < xNum; i++) {
				arr[i]=[];
				for (var j:int=0; j <yNum; j++) {
					var rect:Rectangle =new Rectangle($w * i, $h * j, $w, $h);
					var rectPoint:Point=new Point(0, 0);
					var bmd:BitmapData = new BitmapData($w,$h);
					bmd.copyPixels($img, rect, rectPoint);
//					arr[i][j]=bmd;
//					FileUtil.saveImg($path,arr[i][j],i+"_"+j+".png");
					FileUtil.saveImg($path,bmd,j+"_"+i+".jpg");
				}
			}
//			FileUtil.saveImg(MapPanel.saveFilePath+MapPanel.instance.sceneName+"\\",$img,MapPanel.instance.mapName+".jpg");
			return arr;
		}
		/**
		 *保存整张大图 
		 * 
		 */		
		static public function saveBigMap($img:BitmapData):void
		{
//			FileUtil.saveImg(MapPanel.saveFilePath+MapPanel.instance.sceneName+"\\",$img,MapPanel.instance.mapName+".png");
		}
		/**
		 *缩小地图 
		 * @param bmd
		 * @param per
		 * 
		 */		
		static public function scaleMap(bmd:BitmapData,per:Number):BitmapData
		{
//			var __btd:BitmapData = new BitmapData(bmd.width,bmd.height);
//			var rect:Rectangle =new Rectangle(0, 0, bmd.width,bmd.height);
//			var rectPoint:Point=new Point(0, 0);
//			__btd.copyPixels(bmd, rect, rectPoint);
			var __btd:BitmapData = bmd.clone();
			var __btd1:BitmapData = new BitmapData(bmd.width*per/100,bmd.height*per/100);
			__btd1.draw(__btd,new Matrix(per/100,0,0,per/100,0,0));
			return __btd1;
		}
		/**
		 *相对于零点的点坐标 转换成格子坐标 
		 * @param point
		 * @param flag 0 菱形 1方形
		 * @return 
		 * 
		 */		
		static public function localToGridePoint(point:Point,flag:int = 0):Point
		{
			var w:Number = MapPanel.instance.gridW;
			var h:Number = MapPanel.instance.gridH;
			var n:int;
			var m:int;
			if(flag == MapPanel.outside_diamond||flag == MapPanel.inside_diamond)
			{
				n= int(point.x/w - point.y/h);
				m= int(point.x/w + point.y/h);
			}
			else if(flag == MapPanel.rect)
			{
				n = int(Math.floor(point.x/w));
				m = int(Math.floor(point.y/h));
			}
			return new Point(n,m);
		}
		/**
		 *将格子坐标转换成 ui中的坐标 
		 * @param gridP
		 * @param flag
		 * @return 
		 * 
		 */		
		static public function gridToGlobalPoint(gridP:Point):Point
		{
			var flag:int = MapPanel.instance.gridType;
			var imgw:Number = MapPanel.instance.maplayerW;
			var imgh:Number = MapPanel.instance.maplayerH;
			var gridw:Number = MapPanel.instance.gridW;
			var gridh:Number = MapPanel.instance.gridH;
			var p:Point;
			var _p:Point;
			var __p:Point;
			if(flag == MapPanel.outside_diamond || flag == MapPanel.inside_diamond)
			{
				p = new Point(0,imgh/2);
				_p = new Point(p.x +gridP.x*gridw/2,p.y - gridP.x *gridh/2);
				__p = new Point(_p.x +gridP.y *gridw/2,_p.y+gridP.y*gridh/2);
			}
			else if(flag == MapPanel.rect)
			{
				__p = new Point(gridP.x*gridw,gridP.y*gridh);
			}
			return __p;
		}
		/**
		 *通过格子的坐标返回 格子的中心坐标 
		 * @param $p
		 * @return 
		 * 
		 */		
		static public function gridToCenter($p:Point):Point
		{
			var p:Point = gridToGlobalPoint($p);
			if(MapPanel.instance.gridType == MapPanel.outside_diamond || MapPanel.instance.gridType == MapPanel.inside_diamond)
				p.x = p.x + MapPanel.instance.gridW/2;
			else if(MapPanel.instance.gridType == 1)
			{
				p.x = p.x+MapPanel.instance.gridW/2;
				p.y = p.y+MapPanel.instance.gridH/2;
			}
			return p;
		}
		static public function adjustGridePoint(poind:Point,num:Number):Point
		{
			if(poind.x < poind.y && num < 0)
			{
				var _p:Point = new Point(poind.y,poind.x);
				poind = _p;
			}
			return poind;
		}
		/**
		 *返回颜色值 
		 * @param $idx
		 * @return 
		 * 
		 */		
		static public function getColorUnit($idx:int):uint
		{
			switch($idx)
			{
				case 2:
					return COLOR_ZERO_RED;
					break;
				case 0:
					return COLOR_ONE_YELLOW;
					break;
				case 1:
					return COLOR_TWO_BLUE;
					break;
				case 3:
					return COLOR_THREE_GREEN;
					break;
				case 4:
					return COLOR_FOUR_GRAY;
					break;
				case 5:
					return COLOR_FIVE_ORANGE;
					break;
				case 6:
					return COLOR_SIX_GOLD;
					break;
				case 7:
					return COLOR_SEVEN_PURPLE;
					break;
				case 8:
					return COLOR_EIGHT_TAN;
					break;
				case 9:
					return COLOR_NINE_DARKRED;
					break;
				case 10:
					return COLOR_TEN_DARKBLUE;
					break;
				case 11:
					return COLOR_ELEVEN_INDIGO;
					break;
				case 12:
					return COLOR_TWELVE_DARKORANGE;
					break;
				case 13:
					return COLOR_THIRTEEN_PINK;
					break;
				case 14:
					return COLOR_FOURTEEN_DEEPPINK;
					break;
				case 15:
					return COLOR_FIFTEEN_TOMATO;
					break;
				case 100:
					return COLOR_BLACK;
					break;
			}
			return 0;
		}
		/**
		 *花圆圈 
		 * @param $r
		 * @param $clolor
		 * 
		 */		
		public static function drawCircle($r:Number,$clolor:uint = 0xff0000):Shape
		{
			var _shap:Shape = new Shape();
			_shap.graphics.beginFill($clolor);
			_shap.graphics.drawCircle(0,0,$r);
			_shap.graphics.endFill();
			return _shap;
		}
		/**
		 *返回要画的格子的宽和高 
		 * @param $p
		 * @return 
		 * 
		 */		
		public static function checkGridWH($p:Point):Array
		{
			var arr:Array = new Array();
			var w:Number = MapPanel.instance.gridW;
			var h:Number = MapPanel.instance.gridH;
			if(MapPanel.instance.gridType == MapPanel.outside_diamond||MapPanel.inside_diamond)
			{
				arr.push(w);
				arr.push(h);
			}
			else if(MapPanel.instance.gridType == MapPanel.rect)
			{
				if($p.x + MapPanel.instance.gridW > MapPanel.instance.mapWidth)
					w = MapPanel.instance.gridW-($p.x + MapPanel.instance.gridW-MapPanel.instance.mapWidth);
				if($p.y+MapPanel.instance.gridH > MapPanel.instance.mapHeight)
					h = MapPanel.instance.gridH-($p.y+MapPanel.instance.gridH-MapPanel.instance.mapHeight);
				arr.push(w);
				arr.push(h);
			}
			return arr;
		}
		/**
		 *拼图并返回整图 
		 * @return 
		 * 
		 */		
		public static function jigsawImg($bmd:BitmapData,$data:Object):BitmapData
		{
			for(var key:String in $data)
			{
				var arr:Array = key.split("_");
				var xx:Number = arr[0];
				var yy:Number = arr[1];
				var bmd:BitmapData = $data[key];
				$bmd.copyPixels(bmd,new Rectangle(0,0,bmd.width,bmd.width),new Point(xx,yy));
			}
			return $bmd;
		}
	}
}