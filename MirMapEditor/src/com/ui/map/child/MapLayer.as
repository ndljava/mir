package com.ui.map.child
{
	import com.ui.map.MapPanel;
	import com.utils.FileUtil;
	import com.utils.ImgLoader;
	import com.utils.MapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.dns.AAAARecord;
	import flash.utils.ByteArray;
	
	import mx.charts.AreaChart;
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.graphics.codec.JPEGEncoder;
	
	import org.osmf.elements.ImageLoader;
	import org.osmf.media.LoadableElementBase;

	public class MapLayer extends UIComponent
	{
		//图片读取器
		private var _imageLoader:ImgLoader;
		
		private var _image:Bitmap;
		public var maplayerW:Number;
		public var maplayerH:Number;
		public var imgBMD:BitmapData;
		private var _flag:int =-1;
		private var _url:String;
		private var _imgObj:Object;
		private var _mapUI:UIComponent;
		private var _loadUI:Object;//加载过的图片
		private var _loadingUI:Object;
//		private var _loadArr:Array;
		public function MapLayer()
		{
			_loadUI = new Object();
			_loadingUI = new Object();
			imgBMD = null;
			_mapUI = new UIComponent();
//			_loadArr = new Array();
		}
		/**
		 * 
		 * @param $w
		 * @param $h
		 * 
		 */		
		public function setMapUIWH($w:Number,$h:Number):void
		{
			_mapUI.width = $w;
			_mapUI.height = $h;
		}
		//读取地图图片
		public function load(src:String,flag:int = 0):void{
			_flag = flag;
			_imageLoader = new ImgLoader();
			_imageLoader.load(src);
			_imageLoader.addEventListener(Event.COMPLETE,loadSuccess);
		}
		//读取成功
		public function loadSuccess(evet:Event):void{
			
			imgBMD = _imageLoader.data;
			_image = new Bitmap(imgBMD);
			_mapUI.width = _image.width;
			_mapUI.height = _image.height;
			if(MapPanel.instance.gridType == MapPanel.outside_diamond)//外棱形
			{
				this.width = _mapUI.width+2*_mapUI.height;
				this.height = _mapUI.height+1/2*_mapUI.width;
				this._mapUI.x = _mapUI.height;
				this._mapUI.y = 1/4*_mapUI.width;
				maplayerW = this.width;
				maplayerH = this.height;
				_imageLoader.removeEventListener(Event.COMPLETE,loadSuccess);
				drawDiaMond();
			}
			else if(MapPanel.instance.gridType == MapPanel.rect)//方形
			{
				this.width = _mapUI.width;
				this.height = _mapUI.height;
				maplayerW = this.width;
				maplayerH = this.height;
				drawRectF();
			}
			else if(MapPanel.instance.gridType == MapPanel.inside_diamond)//内菱形
			{
				this.width = _mapUI.width;
				this.height = _mapUI.height;
				maplayerW = this.width;
				maplayerH = this.height;
				drawDiaMond();
			}
			this.name = "mapLayer";
			this._mapUI.addChild(_image);
			this.addChild(_mapUI);
			if(_flag == 0)
				MapPanel.instance.imgUI = this;
			else MapPanel.instance.changeMapUI = this;
		}
		/**
		 *画菱形 
		 * 
		 */		
		private function drawDiaMond():void
		{
			this.graphics.beginFill(0xff0000,0);
			this.graphics.lineStyle(1,0xFF0000);
			this.graphics.moveTo(this.width/2,0);
			this.graphics.lineTo(this.width,this.height/2);
			this.graphics.lineTo(this.width/2,this.height);
			this.graphics.lineTo(0,this.height/2);
			this.graphics.lineTo(this.width/2,0);
			this.graphics.endFill();
		}
		/**
		 *画方形 
		 * 
		 */		
		private function drawRectF():void
		{
			this.graphics.beginFill(0xff0000,0);
			this.graphics.drawRect(0,0,this.width,this.height);
		}
		public function get mapWidth():Number
		{
			return _mapUI.width;
		}
		public function get mapHeight():Number
		{
			return _mapUI.height;
		}
		public function get mapLayerWidth():Number
		{
			return this.width;
		}
		public function get maplayerHeiht():Number
		{
			return this.height;
		}
		/**
		 *读取散图 
		 * 
		 */		
		public function readImags(url:String):void
		{
			_url = url;
			var file:File = new File(url);
			if(!file.exists)
			{
				Alert.show(url+" 不存在");
				return;
			}
				
			file.addEventListener(FileListEvent.DIRECTORY_LISTING, onListGet);
			file.getDirectoryListingAsync();
			
		}
		/**
		 * 图片文件列表
		 * @param evt
		 * 
		 */	
		private var long:int;
		private function onListGet(evt:FileListEvent):void
		{
			var fileList:Array = evt.files;
			if(fileList && fileList.length >0)
			{
				if(_mapUI.width == 0 && _mapUI.height == 0)
				{
					setMapHW(fileList);
					var size:int = MapPanel.instance.cutSize;
					_mapUI.width = (xNum+1)*size;
					_mapUI.height = (yNum +1)*size;
				}
				readEnd();
				MapPanel.instance.scrollerDrop();
			}
		}
		/**
		 *读散图片 
		 * @param $name
		 * 
		 */	
		private var flag:int;
		private function loadImg($name:String):void
		{
			var arr:Array = $name.split(".");
			if(arr[1] != "png" && arr[1] != "jpg")
				return;
			var n:Array = (arr[0] as String).split("_");
			var xx:int = n[0];
			var yy:int = n[1];
			var load:Loader = new Loader()
			load.contentLoaderInfo.addEventListener(Event.COMPLETE,imgLoaded);
			load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadError);
			load.load(new URLRequest(_url+"\\"+$name));
		}
		private function imgLoaded(evt:Event):void
		{
			long++;
			var bm:Bitmap = new Bitmap();
			bm =  evt.currentTarget.content;
			var str:String = bm.loaderInfo.url;
			var arr:Array = str.split("/");
			var n:String = arr[arr.length-1];
			var nn:Array = n.split(".");
			var nnn:Array = (nn[0] as String).split("_")
			var xx:int = nnn[0];
			var yy:int = nnn[1];
			bm.y = MapPanel.instance.cutSize*xx;
			bm.x = MapPanel.instance.cutSize*yy;
			bm.loaderInfo.loader.removeEventListener(Event.COMPLETE,imgLoaded);
			if(n in _loadUI)
			{
				return;
			}
			_loadUI[n] = n;
			_mapUI.addChild(bm);
			var bmd:BitmapData = bm.bitmapData.clone();
			MapPanel.instance.miniMapAddMap(bmd,bm.x,bm.y);
		}
		private function loadError(evt:IOErrorEvent):void
		{
			Alert.show(evt.text);
		}
		/**
		 *数据读取完毕
		 * 
		 */		
		private function readEnd():void
		{
			this.addChild(_mapUI);
			if(MapPanel.instance.gridType == MapPanel.outside_diamond)
			{
				this.width = _mapUI.width+2*_mapUI.height;
				this.height = _mapUI.height+1/2*_mapUI.width;
				this._mapUI.x = _mapUI.height;
				this._mapUI.y = 1/4*_mapUI.width;
				maplayerW = this.width;
				maplayerH = this.height;
				drawDiaMond();
			}
			else if(MapPanel.instance.gridType == MapPanel.rect)
			{
				_mapUI.x = 0;
				_mapUI.y = 0;
				this.width = _mapUI.width;
				this.height = _mapUI.height;
				maplayerW = this.width;
				maplayerH = this.height;
				drawRectF();
			}
			else if(MapPanel.instance.gridType == MapPanel.inside_diamond)
			{
				_mapUI.x = 0;
				_mapUI.y = 0;
				this.width = _mapUI.width;
				this.height = _mapUI.height;
				maplayerW = this.width;
				maplayerH = this.height;
				drawDiaMond();
			}
			MapPanel.instance.imgUI = this;
		}
		/**
		 *加载图片 
		 * @param $startX 横坐标的起始格子坐标
		 * @param $endX   横坐标的终了格子坐标
		 * @param $startY  纵坐标的起始格子坐标
		 * @param $endY 纵坐标的终了格子坐标
		 * 
		 */	
		private var _loadXNum:int;
		private var _loadYNum:int;
		public function loadRange($startX:int,$endX:int,$startY:int,$endY:int):void
		{
			if(_loadXNum >0 || _loadYNum > 0)
				return;
			_loadXNum=$endX-$startX;
			_loadYNum =$endY-$startY;
			for(var i:int = $startX;i<=$endX;i++)
			{
				_loadXNum--;
				for(var j:int =$startY;j<=$endY;j++)
				{
					_loadYNum--;
					if(j+"_"+i+".jpg" in _loadUI)
						continue;
					loadImg(j+"_"+i+".jpg");
				}
			}
		}
		/**
		 * 
		 * 
		 */	
		private var xNum:int;
		private var yNum:int;
		public function setMapHW(arr:Array):void
		{
			for(var i:int = 0 ; i < arr.length;i++)
			{
				var ar:Array = arr[i].name.split(".");
				if(ar[1] != "png" && ar[1] != "jpg")
					continue;
				var name:Array = (ar[0] as String).split("_");
				var xx:int = name[0];
				var yy:int = name[1];
				if(xNum < yy)
					xNum = yy;
				if(yNum < xx)
					yNum  = xx;
			}
		}
	}
}