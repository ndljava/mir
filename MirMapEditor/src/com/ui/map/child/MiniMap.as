package com.ui.map.child
{
	import com.ui.map.MapPanel;
	import com.utils.FileUtil;
	import com.utils.MapUtil;
	
	import fileName.FileName;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	
	import flashx.textLayout.formats.WhiteSpaceCollapse;
	
	import mx.core.UIComponent;
	import mx.events.Request;
	
	import spark.components.Group;
	import spark.effects.Scale;
	import spark.utils.MultiDPIBitmapSource;

	public class MiniMap
	{
		private var _mapW:Number;//地图实际宽
		private var _mapH:Number;//实际高
		private var _main:Group;
		private var _mapScale:Number;//地图的缩放比例
		private var _mapSp:UIComponent;//放地图的ui
		private var _miniWindow:UIComponent;//窗口ui
		private var _scaleW:Number;//地图缩放后的宽
		private var _scaleH:Number;//地图缩放后的高
		private var _gridType:int;//地图的格子类型
		private var _sp:Sprite;
		public var _bmdData:Object;//存散图
		private var _samllBmd:BitmapData;//拼成的整张小地图
		public function MiniMap($group:Group,$w:Number,$h:Number)
		{
			_gridType = MapPanel.instance.gridType;
			_main = $group;
			while(_main.numElements>0)
				_main.removeAllElements();
			_mapW = $w;
			_mapH = $h;
			var xScale:Number = Math.ceil($group.width/$w*100);
			var yScale:Number = Math.ceil($group.height/$h*100);
			_mapScale = xScale>yScale?yScale:xScale;
			if(_mapScale==0)
				_mapScale = 1;
			if(_sp)
			{
				while(_sp.numChildren>0)
					_sp.removeChildAt(_sp.numChildren-1);
			}
			else 
				_sp = new Sprite();
			_sp.graphics.lineStyle(1,0xff0000);
			_sp.graphics.beginFill(0xffffff,.3);
			_scaleW = $w*Number(_mapScale)/100;
			_scaleH = $h*Number(_mapScale)/100
			_sp.graphics.drawRect(0,0,_scaleW,_scaleH);
			_sp.graphics.endFill();
			_mapSp = new UIComponent();
			_mapSp.addChild(_sp);
			_main.addElementAt(_mapSp,0);
			_miniWindow = null;
			_bmdData = null;
			addWindow();
			_samllBmd = new BitmapData(_scaleW,_scaleH);
		}
		/**
		 *添加窗口 
		 * 
		 */		
		private function addWindow():void
		{
			var w:Number = MapPanel.instance.containerW;
			var h:Number = MapPanel.instance.containerH;
			var ww:Number = w*Number(_mapScale)/100;
			var hh:Number = h*Number(_mapScale)/100;
			if(ww>_scaleW)
				ww=_scaleW;
			if(hh>_scaleH)
				hh = _scaleH;
			_miniWindow = new UIComponent();
			_miniWindow.name = "miniWinDow";
			_miniWindow.width = ww;
			_miniWindow.height = hh;
			_miniWindow.graphics.beginFill(0xffffff,0);
			_miniWindow.graphics.lineStyle(1,0xff0000);
			_miniWindow.graphics.drawRect(0,0,ww,hh);
			_miniWindow.graphics.endFill();
			_miniWindow.mouseChildren = false;
			_miniWindow.mouseEnabled = false;
			_main.addElement(_miniWindow);
			_sp.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			if(_main.stage)
				_main.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			_sp.addEventListener(MouseEvent.CLICK,onClickMiniMap);
		}
		/**
		 *整张图加载 
		 * @param bmd
		 * 
		 */		
		public function set wholeMap(bmd:BitmapData):void
		{
			var bmd:BitmapData = MapUtil.scaleMap(bmd,_mapScale);
			var bm:Bitmap = new Bitmap(bmd);
			_mapSp.addChild(bm);
			_main.addElementAt(_mapSp,0);
		}
		/**
		 *小地图 
		 * 
		 */		
		public function loadSamllMap():void
		{
			var load:Loader = new Loader();
			load.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaded);
			load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
			load.load(new URLRequest(FileName.saveFilePath+MapPanel.instance.sceneName+"\\smallMap.png"));
			function onLoaded(evt:Event):void
			{
				_samllBmd = load.content["bitmapData"];
				var bm:Bitmap = new Bitmap(_samllBmd);
				_sp.addChildAt(bm,0);
				load.removeEventListener(Event.COMPLETE,onLoaded);
				load.removeEventListener(IOErrorEvent.IO_ERROR,error);
			}
			function error(evt:IOErrorEvent):void
			{
				load.removeEventListener(Event.COMPLETE,onLoaded);
				load.removeEventListener(IOErrorEvent.IO_ERROR,error);
			}
		}
		/**
		 *添加散图 
		 * @param $bmd
		 * @param $x
		 * @param $y
		 * 
		 */		
		public function addMap($bmd:BitmapData,$x:Number,$y:Number):void
		{
			var bmd:BitmapData = MapUtil.scaleMap($bmd,_mapScale);
			var bm:Bitmap = new Bitmap(bmd);
			bm.x = $x*_mapScale/100;
			bm.y = $y*_mapScale/100;
			if(_bmdData == null)
				_bmdData = new Object();
			_bmdData[bm.x+"_"+bm.y]=bmd;
			_mapSp.addChild(bm);
		}
		/**
		 *窗口移动 
		 * @param $x
		 * @param $y
		 * 
		 */		
		public function movieWindow($x:Number,$y:Number):void
		{
			var xx:Number = $x;
			var yy:Number = $y;
			if(_gridType == 0)
			{
				var maplw:Number = MapPanel.instance.maplayerW;
				var maplh:Number = MapPanel.instance.maplayerH;
				if($x < _mapH)
					xx = 0;
				else if($x+MapPanel.instance.containerW > _mapH+_mapW)
					xx = _mapH+_mapW;
				else
					xx = $x-_mapH;
				if($y<_mapW/4)
					yy=0;
				else if($y+MapPanel.instance.containerH > maplh-(maplh-_mapH)/2)
					yy=maplh-(maplh-_mapH)/2;
				else
					yy=$y-_mapW/4;
			}
			var xxx:Number = xx*Number(_mapScale)/100;
			var yyy:Number = yy*Number(_mapScale)/100;
			if(xxx +_miniWindow.width>_scaleW)
				xxx = _scaleW - _miniWindow.width;
			if(yyy+_miniWindow.height>_scaleH)
				yyy = _scaleH-_miniWindow.height;
			_miniWindow.x = xxx;
			_miniWindow.y = yyy;
		}
		/**
		 *鼠标按下 
		 * @param evt
		 * 
		 */		
		private function onMouseDown(evt:MouseEvent):void
		{
			if(_main.stage)
			{
				_main.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
				evt.stopPropagation();
			}
				
		}
		/**
		 *鼠标抬起 
		 * @param evt
		 * 
		 */		
		public function onMouseUp(evt:MouseEvent=null):void
		{
			_miniWindow.stopDrag();
			_main.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			if(evt)
				evt.stopPropagation();
			_main.stopDrag();
		}
		/**
		 *鼠标移动 
		 * @param evt
		 * 
		 */		
		private function onMouseMove(evt:MouseEvent = null):void
		{
			if(evt)
				evt.stopPropagation();
			var mouseXY:Point = new Point(_sp.stage.mouseX,_sp.stage.mouseY);
			if(MapPanel.instance.shiftFlag)
			{
				_miniWindow.stopDrag();
				_main.startDrag(false,new Rectangle(0,0,Math.floor(_main.stage.width - _sp.width),Math.floor(_main.stage.height - _sp.height)));
				return;
			}
			_main.stopDrag();
			var p:Point = _sp.globalToLocal(mouseXY);
			if(p.x<0)
				_miniWindow.x = 0;
			else if(p.x> _scaleW-_miniWindow.width)
				_miniWindow.x = _scaleW -_miniWindow.width;
			else _miniWindow.x = p.x;
			if(p.y <0)
				_miniWindow.y = 0;
			else if(p.y>_scaleH-_miniWindow.height)
				_miniWindow.y = _scaleH-_miniWindow.height;
			else _miniWindow.y = p.y-_miniWindow.height/2;
			_miniWindow.startDrag(false,new Rectangle(0,0,_sp.width-_miniWindow.width,_sp.height-_miniWindow.height));
			bigWindowMove();
		}
		/**
		 *移动大的窗口 
		 * 
		 */		
		private function bigWindowMove():void
		{
			var gridP:Point = new Point();
			gridP.x = _miniWindow.x/(_mapScale/100);
			gridP.y = _miniWindow.y/(_mapScale/100);
			if(_gridType == 0)
			{
				gridP.x =gridP.x+_mapH;
				gridP.y=gridP.y+_mapW/4;
			}
			MapPanel.instance.setScrollerPostion(gridP,false);
		}
		/**
		 * 
		 * @param evt
		 * 
		 */		
		private function onClickMiniMap(evt:MouseEvent):void
		{
			onMouseMove();
			_miniWindow.stopDrag();
		}
		/**
		 *保存加载的小地图 
		 * 
		 */		
		public function saveSamllImg():void
		{
			_samllBmd=MapUtil.jigsawImg(_samllBmd,_bmdData);
			_bmdData = null;
			while(_sp.numChildren>0)
				_sp.removeChildAt(_sp.numChildren-1);
			var bm:Bitmap = new Bitmap(_samllBmd);
			_sp.addChildAt(bm,0);
			FileUtil.saveImg(FileName.saveFilePath+MapPanel.instance.sceneName+"\\",_samllBmd,"smallMap.png");
		}
	}
}