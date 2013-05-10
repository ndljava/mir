package com.ui.map.child {
	import com.info.child.ObstacleInfo;
	import com.ui.map.MapPanel;
	import com.ui.panel.ObstacleAndAreaPanel;
	import com.utils.FileUtil;
	import com.utils.MapUtil;
	
	import fileName.FileName;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.charts.AreaChart;
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.utils.SHA256;

	/**
	 *障碍物层
	 * @author Administrator
	 *
	 */
	public class MapObstacle {
		public static const filename:String = "_obstcale";
		private static var _instance:MapObstacle;
		private var _panel:ObstacleAndAreaPanel;
		private var _brushIdx:int;
		private var _listIdx:int = -1;
		private var _main:UIComponent;
		private var _overUIArr:Array;
		private var _controlFlag:Boolean;
		private var _shiftFlag:Boolean;
		private var _uiArr:Object;
		private var _openFlag:Boolean;//打开时是否需画
		private var _areaFlag:Boolean;
		private var _obstacleInfor:Array;
		public function MapObstacle() {
		}
		private function initXml():void
		{
			_obstacleInfor = new Array(MapPanel.instance.rowYNum);
			for(var i:int = 0 ; i < _obstacleInfor.length;i++)
			{
				var ar:Array = new Array(MapPanel.instance.rowXNum);
				_obstacleInfor[i] = ar;
			}
		}
		public static function get instance():MapObstacle{
			if(null==_instance)
				_instance = new MapObstacle();
			return _instance;
		}
		/**
		 *清理数据 
		 * 
		 */		
		public function clearData():void
		{
			_obstacleInfor = null;
			if(_main != null)
			{
				while(_main.numChildren >0)
					_main.removeChildAt(_main.numChildren -1);
			}
			_uiArr = null;
			_panel = null;
			_listIdx = -1;
		}
		public function showPan($pan:ObstacleAndAreaPanel):void{
			if(!_panel)
			{
				_panel = $pan;
				_panel.obstacleListLickFun = onListItemClick;
				_panel.obstacleBtnVisibaleFun = showOrHideAreaPanel;
				addObstacleUI();
			}
			_panel.panelType(MirMapEditer.OBSTACLE);
			if(_obstacleInfor == null)
			{
				initXml();
			}
			if(_obstacleInfor!= null && _obstacleInfor.length >0)
				MapPanel.instance.addModeUI(MirMapEditer.OBSTACLE);
			if(_listIdx == -1)
				_listIdx = 1;
			_panel.setColorListItem(_listIdx);
			if(_main!= null)
				_main.visible = true;
		}
		/**
		 *添加障碍层 
		 * 
		 */		
		private function addObstacleUI():void
		{
//			var w:Number = MapPanel.instance.mapWidth;
//			var h:Number = MapPanel.instance.mapHeight;
//			var gridType:int = MapPanel.instance.gridType;
			_main = new UIComponent();
//			_main.graphics.beginFill(0xff0000,0);
//			if(gridType == 0)
//			{
//				_main.graphics.lineStyle(1,0xff0000);
//				_main.graphics.moveTo(w/2,0);
//				_main.graphics.lineTo(w,h/2);
//				_main.graphics.lineTo(w/2,w/2);
//				_main.graphics.lineTo(0,h/2);
//				_main.graphics.lineTo(w/2,0);
//			}
//			else if(gridType == 1)
//			{
//				_main.graphics.drawRect(0,0,w,h);
//			}
//			_main.graphics.endFill();
			_main.name = "obstacleUI";
			MapPanel.instance.obstacleUI = _main;
			_main.mouseChildren =false;
			_main.mouseEnabled =false;
		}
		/**
		 *点击区域选择 
		 * @param $idx
		 * 
		 */		
		private function onListItemClick($idx:int):void
		{
			_listIdx = $idx;
		}
		/**
		 *点击刷子选择 
		 * @param $idx
		 * 
		 */		
		public function brushClick($idx:int):void
		{
			_brushIdx = $idx;
		}
		/**
		 *鼠标移动 
		 * @param $p
		 * 
		 */		
		public function mouseMoveFun($p:Point):void
		{
			if(_listIdx == -1 || _listIdx == 0)
				return;
			removeColorUI(_overUIArr);
			var rowXNum:int = MapPanel.instance.rowXNum;
			var rowYNum:int = MapPanel.instance.rowYNum;
			var w:Number = MapPanel.instance.gridW;
			var h:Number = MapPanel.instance.gridH;
			var gridNum:int = _brushIdx+1;
			var xx:int = $p.x;
			var yy:int = $p.y;
			for(var i:int = 0;i <gridNum;i++)
			{
				xx = i+$p.x;
				if(xx > rowXNum)
					continue;
				for(var j:int = 0;j <gridNum;j++)
				{
					yy = j+$p.y;
					if(yy > rowYNum)
						continue;
					var point:Point = MapUtil.gridToGlobalPoint(new Point(xx,yy));
					var arr:Array = MapUtil.checkGridWH(point);
					var ui:Shape = MapUtil.gridGridEdge(arr[0],arr[1],MapUtil.getColorUnit(2),3);
					ui.x = point.x;
					ui.y = point.y;
					ui.name = xx+"@"+yy;
					if(_overUIArr == null)
						_overUIArr = new Array();
					_overUIArr.push(ui.name);
					_main.addChild(ui);
				}
			}
		}
		/**
		 *鼠标移动 删除一预览的格子 
		 * @param arr
		 * 
		 */		
		public function removeColorUI(arr:Array = null):void
		{
			if(arr == null)
				arr = _overUIArr;
			if(arr == null || arr.length == 0)
				return;
			for(var i:int =0 ;i <arr.length;i++)
			{
				var ui:Shape = _main.getChildByName(arr[i]) as Shape;
				if(ui != null)
					_main.removeChild(ui);
			}
			_overUIArr.length = 0;
		}
		/**
		 *鼠标按下 
		 * @param $p
		 * 
		 */		
		public function onDownMap($p:Point):void
		{
			if(_listIdx == -1)
			{
				Alert.show("请先选择区域颜色！！！");
				MapPanel.instance.onUpMap();
				return;
			}
			if(_listIdx == 0)
			{
				Alert.show("可行走区域不能编辑");
				MapPanel.instance.onUpMap();
				return;
			}
			onDownMoveMap($p);
		}
		/**
		 *按下移动鼠标 
		 * @param $p
		 * 
		 */	
		private var _preP:Point;
		public function onDownMoveMap($grid:Point):void
		{
			removeColorUI();
			if(_listIdx <=0)
				return;
			if(_preP && _preP.x  == $grid.x && _preP.y == $grid.y)
				return;
			_preP = $grid;
			var gridNum:int = _brushIdx+1;
			var xx:int = $grid.x;
			var yy:int = $grid.y;
			var rowXNum:int = MapPanel.instance.rowXNum;
			var rowYNum:int = MapPanel.instance.rowYNum;
			for(var i:int = 0;i <gridNum;i++)
			{
				xx = i+$grid.x;
				if(xx >= rowXNum)
					continue;
				for(var j:int = 0;j <gridNum;j++)
				{
					yy = j+$grid.y;
					if(yy >= rowYNum)
						continue;
					var id:int = checkUIArr(xx,yy);
					if(!_controlFlag)
					{
						if(_uiArr)//不为空
						{
							if(id == 0)
							{
//								if(xx>=rowXNum||yy>=rowYNum)
//									continue;
								addColorUI(new Point(xx,yy),_listIdx);
								changeXMLData(xx,yy,_listIdx);
							}
						}
						else if(_uiArr == null)
						{
							_uiArr = new Object();
							addColorUI(new Point(xx,yy),_listIdx);
							changeXMLData(xx,yy,_listIdx);
						}
					}
					else 
					{
						if(_uiArr == null)
							continue;
//						if(id == _listIdx)
//						{
							if(xx>=rowXNum||yy>=rowYNum)
								continue;
							deleteColorUI(xx,yy);
							changeXMLData(xx,yy,0);
//						}
					}
				}
			}
		}
		/**
		 *鼠标up 
		 * 
		 */		
		public function onMouseUp():void
		{
			_preP = null;
		}
		/**
		 * @param $p
		 * @param $colorId
		 * 
		 */	
		private function addColorUI($p:Point,$colorId:int):void
		{
			var point:Point = MapUtil.gridToGlobalPoint($p);
			var arr:Array = MapUtil.checkGridWH(point);
			var ui:Sprite = MapUtil.drawGrid(arr[0],arr[1],MapUtil.getColorUnit($colorId),.5);
			ui.x = point.x;
			ui.y = point.y;
			ui.name = $p.x+"_"+$p.y;
			if(_uiArr == null)
				_uiArr = new Object();
//			var data:ObstacleInfo = new ObstacleInfo();
//			data.xx=$p.x;
//			data.yy=$p.y;
//			data.id=$colorId;
//			_uiArr[colorUI.name] = data.id;
			_uiArr[ui.name] = $colorId;
			_main.addChild(ui);
		}
		/**
		 *检查格子是否已涂色 
		 * @param xx
		 * @param yy
		 * @return 
		 * 
		 */		
		private function checkUIArr(xx:int,yy:int):int
		{
			var id:int = 0;
			if(_uiArr != null)
			{
				if(xx+"_"+yy in _uiArr)
				{
					var ui:Sprite = _main.getChildByName(xx+"_"+yy) as Sprite;
					if(ui)
						id = _uiArr[xx+"_"+yy];
				}
			}
			return id;
		}
		/**
		 *删除颜色格子 
		 * @param xx
		 * @param yy
		 * 
		 */		
		private function deleteColorUI(xx:int,yy:int):void
		{
			var n:String = xx+"_"+yy;
			var ui:Sprite = _main.getChildByName(n) as Sprite;
			if(ui)
				_main.removeChild(ui);
			if(n in _uiArr)
				delete _uiArr[n];
		}
		/**
		 *更新数据 
		 * @param $x
		 * @param $y
		 * @return 
		 * 
		 */		
		private function changeXMLData($x:int,$y:int,$flag:int=0):void
		{
			if($x >=_obstacleInfor.length ||$y>=(_obstacleInfor[0] as Array).length)
				return;
			_obstacleInfor[$x][$y] = $flag;
		}
		/**
		 *control键是够按下 
		 * @param $f
		 * 
		 */		
		public function set controlFlag($f:Boolean):void
		{
			_controlFlag = $f;
		}
		public function set shiftFlag($f:Boolean):void
		{
			_shiftFlag = $f;
		}
		/**
		 *保存数据 
		 * 
		 */		
		public function saveFile():void
		{
			var fileName:String;
			var filePath:String = FileName.saveFilePath+MapPanel.instance.sceneName+"\\";
			if(_obstacleInfor == null)
				initXml();
			var arr:ByteArray = new ByteArray();
			arr = serverData();
			fileName = FileName.serverFileName+MapPanel.instance.sceneName+"_obstcale.map";
			FileUtil.saveFileData(filePath+fileName,arr);
			arr = clientData();
			fileName = FileName.clientFileName+MapPanel.instance.sceneName+"_obstcale.map";
			FileUtil.saveFileData(filePath+fileName,arr);
		}
		/**
		 *服务器数据 
		 * @return 
		 * 
		 */		
		private function serverData():ByteArray
		{
			var arr:ByteArray = new ByteArray();
			arr.endian = Endian.LITTLE_ENDIAN;
			arr.writeMultiByte("地地地","cn-gb");
			arr.position = 20;
//			arr.writeUTF("地地地地地地地地地地");//地图说明
			arr.writeShort(1);//版本号
			arr.writeShort(_obstacleInfor.length);//宽有多少格子
			arr.writeShort((_obstacleInfor[0] as Array).length);//高有多少格子
			for(var i:int = 0 ;i <_obstacleInfor.length;i++)
			{
				for(var j:int = 0 ; j < (_obstacleInfor[i] as Array).length;j++)
				{
					if(_obstacleInfor[i][j] == null)
						arr.writeByte(0);
					else arr.writeByte(_obstacleInfor[i][j]);
				}
			}
			return arr;
		}
		/**
		 *客户端数据 
		 * @return 
		 * 
		 */		
		private function clientData():ByteArray
		{
			var arr:ByteArray = new ByteArray();
			arr.writeInt(_obstacleInfor.length);//宽有多少格子
			arr.writeInt((_obstacleInfor[0] as Array).length);//高有多少格子
			for(var i:int = 0 ;i <_obstacleInfor.length;i++)
			{
				for(var j:int = 0 ; j < (_obstacleInfor[i] as Array).length;j++)
				{
					if(_obstacleInfor[i][j] == null)
						arr.writeByte(0);
					else arr.writeByte(_obstacleInfor[i][j]);
				}
			}
			return arr;
		}
		/**
		 *读取的数据
		 * @param $ba
		 * 
		 */		
		public function set obstacleDataXml($ba:ByteArray):void
		{
			var arr:ByteArray = $ba;
//			arr.position = 0;
//			arr.readUTF();
//			arr.readShort();
//			var xNum:int = arr.readShort();
//			var yNum:int = arr.readShort();
			var xNum:int = arr.readInt();
			var yNum:int = arr.readInt();
			initXml();
			for(var i:int = 0 ; i < xNum;i++)
			{
				for(var j:int = 0 ; j< yNum;j++)
				{
					_obstacleInfor[i][j] = arr.readByte();
				}
			}
			_openFlag = true;
		}
		/**
		 * 设置读取的数据 
		 * 
		 */		
		public function setObstacle($WS:int,$HS:int,$WEnd:int,$HEnd:int):void
		{
			if(_obstacleInfor == null)
				return;
			if($WEnd>_obstacleInfor.length)
				$WEnd = _obstacleInfor.length;
			if($HEnd>(_obstacleInfor[0] as Array).length)
				$HEnd = (_obstacleInfor[0] as Array).length;
			for(var i:int = $WS ; i < $WEnd;i++)
			{
				for(var j:int = $HS ; j <$HEnd;j++)
				{
					if(_obstacleInfor[i][j] != null && _obstacleInfor[i][j] != 0)
					{
						if(_uiArr != null && i+"_"+j in _uiArr)
							continue;
						else addColorUI(new Point(i,j),_obstacleInfor[i][j]);
					}
				}
			}
		}
		/**
		 * 显示 隐藏 区域面板
		 * 
		 */		
		private function showOrHideAreaPanel():void
		{
			if(_areaFlag == false)
				_areaFlag = true;
			else _areaFlag = false;
			MapPanel.instance.showOrHidePanel(MirMapEditer.AREA,!_areaFlag);
		}
	}
}