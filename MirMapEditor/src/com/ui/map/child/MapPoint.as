package com.ui.map.child {
	import com.info.child.PointInfo;
	import com.ui.map.MapPanel;
	import com.ui.panel.PointPanel;
	import com.utils.FileUtil;
	import com.utils.MapUtil;
	
	import fileName.FileName;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.factory.TruncationOptions;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.utils.object_proxy;

	/**
	 *地图点
	 * @author Administrator
	 *
	 */
	public class MapPoint {
		public static const fileName:String = "point";
		private static var _instance:MapPoint;
		private var _panel:PointPanel;
		private var _main:UIComponent;
		private var _pointData:Array;
		private var _pointIdArr:Array;
		private var _creatFlag:Boolean;
		private var _direactionIcon:BitmapData;
		private var _idx:int = -1;
		private var _pointXml:XML;
		public function MapPoint() {
			if(_direactionIcon == null)
				loadDirectionIcon(MirMapEditer.swfPath+"rec/dirIcon/"+0+".png");
		}
		public static function get instance():MapPoint{
			if(!_instance)
				_instance = new MapPoint();
			return _instance;
		}
		public function show($panel:PointPanel):void{
			if(_panel == null)
			{
				_panel = $panel;
				_panel.onBtnCreatClickFun = btnCreatClick;
				_panel.onBtnSaveClickFun = btnSaveClick;
				_panel.onBtnLeftClickFun = btnLeftClick;
				_panel.onBtnRightClickFun = btnRightClick;
				_panel.onListItemClickFun = listItemClick;
				addPointUI();
			}
			if(_idx == -1&&_pointData != null && _pointData.length>0)
				setListData();
		}
		/**
		 *添加点层 
		 * 
		 */		
		private function addPointUI():void{
			_main = new UIComponent();
			_main.name = "pointUI";
			MapPanel.instance.pointUI = _main;
			_main.mouseChildren =false;
			_main.mouseEnabled =false;
		}
		/**
		 *清理数据 
		 * 
		 */		
		public function clearData():void
		{
			removieDirUI();
			_pointXml = null;
			_pointData = null;
			_pointIdArr = null;
			_idx = -1;
			if(_panel)
			{
				setListData();
				setEditerData(-1);
			}
			
			_panel = null;
		}
		/**
		 *按钮创建点击 
		 * 
		 */		
		private function btnCreatClick():void{
			_creatFlag = true;
		}
		/**
		 *按钮保存点击 
		 * 
		 */		
		private function btnSaveClick():void{
			var xx:int = int(_panel.XInput.text);
			var yy:int = int(_panel.YInput.text);
			if((xx != (_pointData[_idx] as PointInfo).pointX || yy!= (_pointData[_idx] as PointInfo).pointY)&&checkPoint(new Point(xx,yy)))
			{
				Alert.show("坐标为（"+xx+","+yy+"）的点已经种植!!!");
				_panel.XInput.text = (_pointData[_idx] as PointInfo).pointX.toString();
				_panel.YInput.text = (_pointData[_idx] as PointInfo).pointY.toString();
				return;
			}
			removieDirUI(new Point((_pointData[_idx] as PointInfo).pointX,(_pointData[_idx] as PointInfo).pointY));
			(_pointData[_idx] as PointInfo).pointX = xx;
			(_pointData[_idx] as PointInfo).pointY =yy;
			var dir:int = int(_panel.angle.text)/45;
			addDirUI(new Point(xx,yy),dir);
			(_pointData[_idx] as PointInfo).direction = dir;
			(_pointData[_idx] as PointInfo).description = _panel.explain.text;
			setListData();
		}
		/**
		 *左转 
		 * 
		 */		
		private function btnLeftClick():void{
			if(_idx<0)
				return;
			if(int(_panel.angle.text)>0)
				_panel.angle.text = String(int(_panel.angle.text)-45);
			else
				_panel.angle.text = "315";
			btnTrun();
		}
		/**
		 *右转 
		 * 
		 */		
		private function btnRightClick():void{
			if(_idx<0)
				return;
			if(int(_panel.angle.text)<315)
				_panel.angle.text = String(int(_panel.angle.text)+45);
			else
				_panel.angle.text = "0";
			btnTrun();
		}
		/**
		 *旋转 
		 * 
		 */		
		private function btnTrun():void
		{
			var dir:int = int(_panel.angle.text)/45;
			var xx:int = (_pointData[_idx] as PointInfo).pointX;
			var yy:int = (_pointData[_idx] as PointInfo).pointY;
			var bm:Bitmap = this._main.getChildByName(xx+"_"+yy) as Bitmap;
			trunDir(bm,xx,yy,dir);
		}
		/**
		 *箭头转方向 
		 * @param $x
		 * @param $y
		 * @param dir
		 * 
		 */		
		private function trunDir($bm:Bitmap,$x:int,$y:int,$dir:int):void
		{
			if($bm == null)
				return;
			var uiPoint:Point = MapUtil.gridToCenter(new Point($x,$y));
			var ange:Number = 45*$dir;
			$bm.rotation = ange;
			if($dir == 0)
			{
				$bm.x = uiPoint.x - $bm.width/2;
				$bm.y = uiPoint.y-$bm.height/2;
			}
			else if($dir == 1)
			{
				$bm.x = uiPoint.x-$bm.width/8;
				$bm.y = uiPoint.y -$bm.height/2;
			}
			else if($dir == 2)
			{
				$bm.x = uiPoint.x+$bm.width/6;
				$bm.y = uiPoint.y-$bm.height/2;
			}
			else if($dir == 3)
			{
				$bm.x = uiPoint.x+$bm.width/2;
				$bm.y = uiPoint.y+$bm.height/8;
			}
			else if($dir == 4)
			{
				$bm.x = uiPoint.x+$bm.width/2;
				$bm.y = uiPoint.y+$bm.height/2;
			}
			else if($dir == 5)
			{
				$bm.x = uiPoint.x;
				$bm.y = uiPoint.y+$bm.height/2;
			}
			else if($dir == 6)
			{
				$bm.x = uiPoint.x-$bm.width/4;
				$bm.y = uiPoint.y+$bm.height/2;
			}
			else if($dir == 7)
			{
				$bm.x = uiPoint.x-$bm.width/2;
				$bm.y = uiPoint.y;
			}
		}
		/**
		 *地图点击 
		 * @param $gridP
		 * 
		 */		
		public function mapClick($gridP:Point):void{
			if(_creatFlag == false)
				return;
			if(checkPoint($gridP))
			{
				Alert.show("此格子已经种植点,不能重复种植！！！");
				return;
			}
			var info:PointInfo = new PointInfo();
			info.id = getPointId();
			info.pointX = $gridP.x;
			info.pointY = $gridP.y;
			info.sceneId = MapPanel.instance.sceneName;
			creatPoint(info);
			_creatFlag = false;
		}
		/**
		 *创建点 
		 * 
		 */		
		private function creatPoint($inf:PointInfo):void{
			removieDirUI();
			addDirUI(new Point($inf.pointX,$inf.pointY),$inf.direction);
			if(_pointData == null)
				_pointData= new Array();
			_pointData.push($inf);
			setListData();
			setListItemSelect(_pointData.length-1);
			_idx = _pointData.length-1;
			setEditerData(_idx);
		}
		/**
		 *检查该点是否已种植 
		 * @return 
		 * 
		 */		
		private function checkPoint($p:Point):Boolean
		{
			var f:Boolean;
			if(_pointData == null || _pointData.length == 0)
				f=false;
			else
			{
				for(var i:int = 0 ; i < _pointData.length;i++)
				{
					var d:PointInfo = _pointData[i];
					if(d.pointX == $p.x && d.pointY == $p.y)
					{
						f=true;
						break;
					}
				}
			}
			return f;
		}
		/**
		 *得到图标 
		 * @param $dir
		 * @return 
		 * 
		 */		
		private function getIcon():Bitmap
		{
			var bm:Bitmap = new Bitmap();
			var bmd:BitmapData = _direactionIcon.clone();
			bm.bitmapData = bmd;
			return bm;
		}
		/**
		 *创建的新点的id 
		 * @return 
		 * 
		 */		
		private function getPointId():String
		{
			var id:int = -1;
			var str:String;
			if(_pointIdArr == null||_pointIdArr.length==0)
			{
				_pointIdArr = new Array();
				id = 1;
			}
			else if(_pointIdArr.length == 1)
	 		{
				str = _pointIdArr[0];
				str = str.slice(-3);
				if(int(str)>1)
					id = 1;
				else id = 2;
			}
			else
			{
				_pointIdArr.sort(Array.NUMERIC||Array.CASEINSENSITIVE);
				str = _pointIdArr[0];
				str = str.slice(-3);
				if(int(str)>1)
					id = 1;
				for(var i:int=0;i < _pointIdArr.length-1;i++)
				{
					if(id!= -1)
						break;
					var per:int = int(_pointIdArr[i]);
					var curr:int = int(_pointIdArr[i+1]);
					str = _pointIdArr[i];
					str = str.slice(-3);
					if(per+1<curr)
					{
						id = int(str)+1;
						break;
					}
				}
				if(id == -1)
					id = _pointIdArr.length+1;
			}
			if(id<10)
				str = "00"+id;
			else if(id<100)
				str = "0"+id;
			_pointIdArr.push(MapPanel.instance.sceneName+str);
			return MapPanel.instance.sceneName+str;
		}
		/**
		 *设置list的数据 
		 * 
		 */		
		private function setListData():void
		{
			_panel.setListData(_pointData);
			_panel.setListItemSelect(_idx);
			
		}
		/**
		 *设置list item 选中状态 
		 * 
		 */		
		private function setListItemSelect($idx:int):void
		{
			_panel.setListItemSelect($idx);
			setEditerData($idx);
		}
		/**
		 *设置编辑的数据 
		 * @param $idx
		 * 
		 */		
		private function setEditerData($idx:int):void
		{
			if($idx!= -1)
			{
				var d:PointInfo = _pointData[$idx];
				_panel.XInput.text=d.pointX.toString();
				_panel.YInput.text=d.pointY.toString();
				_panel.explain.text=d.description;
				_panel.angle.text=String(d.direction*45);//添加角度
			}
			else
			{
				_panel.XInput.text="";
				_panel.YInput.text="";
				_panel.explain.text="";
				_panel.angle.text="";//添加角度
			}
		}
		/**
		 * 
		 * @param $p
		 * 
		 */		
		private function addDirUI($p:Point,$dir:int):void
		{
			var bm:Bitmap = getIcon();
			trunDir(bm,$p.x,$p.y,$dir);
			bm.name = $p.x+"_"+$p.y;
			this._main.addChild(bm);
		}
		
		/**
		 * 删除 箭头
		 * 
		 */		
		private function removieDirUI($p:Point=null):void
		{
			if(_main == null)
				return;
			while(this._main.numChildren >0)
				this._main.removeChildAt(this._main.numChildren-1);
		}
		/**
		 *listItem点击s 
		 * @param $idx
		 * 
		 */		
		private function listItemClick($idx:int):void
		{
			if(_idx != -1)
				removieDirUI(new Point((_pointData[_idx] as PointInfo).pointX,(_pointData[_idx] as PointInfo).pointY));
			_idx = $idx;
			setEditerData(_idx);
			var point:Point = new Point((_pointData[_idx] as PointInfo).pointX,(_pointData[_idx] as PointInfo).pointY);
			addDirUI(point,(_pointData[_idx] as PointInfo).direction);
			MapPanel.instance.setMapScrollerToCenter(point);
		}
		/**
		 *delete键点击 
		 * 
		 */		
		public function deleteClick():void
		{
			if(_idx != -1)
				deletePointInfor(_idx);
		}
		/**
		 *删除 
		 * @param $idx
		 * 
		 */		
		private function deletePointInfor($idx:int):void
		{
			if(_pointData == null || _pointData.length == 0)
				return;
			if($idx >= _pointData.length)
				return;
			var d:PointInfo = _pointData[$idx];
			removieDirUI(new Point(d.pointX,d.pointY));
			setEditerData(-1);
			_pointData.splice($idx,1);
			_idx = -1;
			setListData();
			for(var i:int =0 ;i< _pointIdArr.length;i++)
			{
				if(_pointIdArr[i] == d.id)
				{
					_pointIdArr.splice(i,1);
					break;
				}
			}
		}
		/**
		 *加载方向图标 
		 * 
		 */		
		private function loadDirectionIcon($url:String):void
		{
			var load:Loader = new Loader();
			load.contentLoaderInfo.addEventListener(Event.COMPLETE,loaded);
			load.load(new URLRequest($url));
			function loaded(evt:Event):void
			{
				var bmd:BitmapData = load.content["bitmapData"];
				_direactionIcon = bmd;
			}
		}
		/**
		 *读取点表 
		 * @param $path
		 * 
		 */		
		public function readData($path:String):void{
			var ba:ByteArray = FileUtil.readFile(FileName.pointFilePath+fileName+".xml");
			if(ba == null)
				return;
			ba.position = 0; 
			_pointXml = new XML(ba.readMultiByte(ba.length,"utf-8"));
			_pointData = new Array();
			var i:int;
			for(i = _pointXml.child("data").length()-1; i >=0 ;i--)
			{
				var sceneId:String = _pointXml.child("data")[i].@sceneId;
				var sceneName:String = MapPanel.instance.sceneName;
				if(sceneId ==sceneName )
				{
					if(_pointData == null)
						_pointData = new Array();
					var data:PointInfo = new PointInfo();
					data.id = _pointXml.child("data")[i]..@id;
					data.pointX = _pointXml.child("data")[i]..@pointX;
					data.pointY = _pointXml.child("data")[i]..@pointY;
					data.description = _pointXml.child("data")[i]..@description;
					data.direction = _pointXml.child("data")[i]..@direction;
					data.sceneId = _pointXml.child("data")[i]..@sceneId;
					_pointData.push(data);
					if(_pointIdArr == null)
						_pointIdArr = new Array();
					_pointIdArr.push(_pointXml.child("data")[i]..@id);
				}
			}
		}
		
		/**
		 *保存文件 
		 * 
		 */		
		public function saveFile():void{
			var i:int;
			if(_pointXml == null)
				_pointXml = <data/>;
			else
			{
				for(i = _pointXml.child("data").length()-1 ; i >=0 ;i--)
				{
					if(_pointXml.child("data")[i].@sceneId == MapPanel.instance.sceneName)
						delete _pointXml.child("data")[i];
				}
			}
			if(_pointData != null && _pointData.length >0)
			{
				for(i= 0;i< _pointData.length;i++)
				{
					var key:PointInfo = _pointData[i];
					var xml:XML = key.pointInfoToXml(key);
					_pointXml.appendChild(xml);
				}
			}
			var path:String = FileName.pointFilePath;
			FileUtil.saveXmlFile(path,fileName,_pointXml);
		}
	}
}