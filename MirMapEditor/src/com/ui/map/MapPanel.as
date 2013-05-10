package com.ui.map {
	import com.event.MapEditerEvent;
	import com.ui.map.child.MapArea;
	import com.ui.map.child.MapBox;
	import com.ui.map.child.MapEffect;
	import com.ui.map.child.MapGrid;
	import com.ui.map.child.MapLayer;
	import com.ui.map.child.MapMonster;
	import com.ui.map.child.MapObstacle;
	import com.ui.map.child.MapPatrol;
	import com.ui.map.child.MapPoint;
	import com.ui.map.child.MapScene;
	import com.ui.map.child.MiniMap;
	import com.ui.panel.ChangeMapPanel;
	import com.ui.panel.NewMapInfoPanel;
	import com.ui.panel.ObstacleAndAreaPanel;
	import com.ui.panel.PatrolPanel;
	import com.ui.panel.PointPanel;
	import com.ui.panel.SceEffMonBoxPanel;
	import com.utils.FileUtil;
	import com.utils.MapUtil;
	
	import fileName.FileName;
	
	import flash.debugger.enterDebugger;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MorphShape;
	import flash.display.Stage;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.events.DamageEvent;
	import flashx.textLayout.events.ScrollEventDirection;
	import flashx.textLayout.factory.TruncationOptions;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.HeaderEvent;
	
	import spark.globalization.MatchingCollator;

	/**
	 *地图
	 * @author Administrator
	 *
	 */
	public class MapPanel {
		public static const outside_diamond:int = 0;
		public static const rect:int = 1;
		public static const inside_diamond:int = 2;
		public static const typeCut:int= 0 ;//切格子 
		public static const typeGrid:int = 1;//非切格子
		private var _main:MirMapEditer;
		public var openMapPath:String;
		public var cutSize:int;//切割地图的size
		public var gridType:int = -1;//格子的类型  0 菱形，1方形
		public var gridW:Number;//格子的宽
		public var gridH:Number;//格子的高
		public var readType:int;//地图的读取类型 : 0 读散图 ;1 读整图
		
		public var scalePersent:int;//地图缩小的比例
		public var btnIdx:int = -1;//当前的按钮idx
		public var imgPath:String;//地图的路径
		public var sceneName:String;//场景的名字
		public var openSceneName:String;//要打开的场景的名字
		public var openMapName:String;//
		public var mapLayer:MapLayer;//地图层
		public var mapGrid:MapGrid;//格子层
		public var changePath:String;//更换地图的文件路径
		public var changeMapName:String;//更换地图名字
		public var changeMapScale:int;//更换地图的缩小比例
		public var creatFlag:Boolean;//地图是否已经加载进来
		public var mapName:String;//加载进来的地图的名字
		
		private static var _instance:MapPanel;
		
		private var _scenUI:UIComponent;//模型层
		private var _effectUI:UIComponent;//特效层
		private var _monsterUI:UIComponent;//怪物层
		private var _boxUI:UIComponent;//宝箱层
		private var _areaUI:UIComponent;//区域层
		private var _obstacleUI:UIComponent;//障碍层
		private var _patrolUI:UIComponent;//巡逻层
		private var _pointUI:UIComponent;//点层
		private var _mapW:Number;
		private var _mapH:Number;
		private var _rowXNum:int;
		private var _rowYNum:int;
		private var _miniMap:MiniMap;
		private var _smallmapFlag:Boolean = true;
		public function MapPanel() {
		}
		public static function get instance():MapPanel{
			if(_instance == null)
				_instance = new MapPanel();
			return _instance;
		}
		public function set mian($mian:MirMapEditer):void{
			_main = $mian;
		}
		/*主面板上的按钮点击*/
		public function btnClick($idx:int):void{
			if(!creatFlag){
				MapUtil.notMapAlert();
				return;
			}
			if(btnIdx == $idx)
				return;
			switch($idx){
				case MirMapEditer.SCENE:
					setSceEffMonBoxPanTitle($idx);
					if (btnIdx == MirMapEditer.EFFECT || $idx == MirMapEditer.MONSTER || $idx == MirMapEditer.BOX)
						setSceEffMonBoxPanTitle($idx);
					else{
						this._main.rightPan.visible = true;
						sceEffMonBoxPan();
						setSceEffMonBoxPanTitle($idx);
					}
					MapScene.instance.showPan(this._main.sceEffMonBoxPan,this._main.rightPan);
					if(_scenUI)
						changeMapUIIdex(_scenUI);
					break;
				case MirMapEditer.EFFECT:
					setSceEffMonBoxPanTitle($idx);
					if (btnIdx == MirMapEditer.SCENE || $idx == MirMapEditer.MONSTER || $idx == MirMapEditer.BOX)
						setSceEffMonBoxPanTitle($idx);
					else{
						this._main.rightPan.visible = true;
						sceEffMonBoxPan();
						setSceEffMonBoxPanTitle($idx);
					}
					MapEffect.instance.showPan(this._main.sceEffMonBoxPan,this._main.rightPan);
					if(_effectUI)
						changeMapUIIdex(_effectUI);
					break;
				case MirMapEditer.MONSTER:
					setSceEffMonBoxPanTitle($idx);
					if (btnIdx == MirMapEditer.SCENE || $idx == MirMapEditer.EFFECT || $idx == MirMapEditer.BOX)
						setSceEffMonBoxPanTitle($idx);
					else{
						this._main.rightPan.visible = true;
						sceEffMonBoxPan();
						setSceEffMonBoxPanTitle($idx);
					}
					MapMonster.instance.showPan(this._main.sceEffMonBoxPan,this._main.rightPan);
					if(_monsterUI)
						changeMapUIIdex(_monsterUI);
					break;
				case MirMapEditer.BOX:
					setSceEffMonBoxPanTitle($idx);
					if (btnIdx == MirMapEditer.SCENE || $idx == MirMapEditer.EFFECT || $idx == MirMapEditer.MONSTER)
						setSceEffMonBoxPanTitle($idx);
					else{
						this._main.rightPan.visible = true;
						sceEffMonBoxPan();
						setSceEffMonBoxPanTitle($idx);
					}
					MapBox.instance.showPan(this._main.sceEffMonBoxPan,this._main.rightPan);
					if(_boxUI)
						changeMapUIIdex(_boxUI);
					break;
				case MirMapEditer.AREA:
					this._main.rightPan.visible = false;
					if(btnIdx == MirMapEditer.OBSTACLE)
						setObsAreaPanTitle($idx);
					else
					{
						obstacleAreaPan();
						setObsAreaPanTitle($idx);
					}
					MapArea.instance.showPan(this._main.obsAndAreaPan);
					if(_areaUI)
						changeMapUIIdex(_areaUI);
					break;
				case MirMapEditer.OBSTACLE:
					this._main.rightPan.visible = false;
					if(btnIdx == MirMapEditer.AREA)
						setObsAreaPanTitle($idx);
					else
					{
						obstacleAreaPan();
						setObsAreaPanTitle($idx);
					}
					MapObstacle.instance.showPan(this._main.obsAndAreaPan);
					break;
				case MirMapEditer.PATROL:
					this._main.rightPan.visible = false;
					this._main.patrolPan.visible=true;
					this._main.obsAndAreaPan.visible=false;
					this._main.pointPan.visible=false;
					this._main.sceEffMonBoxPan.visible=false;
					MapPatrol.instance.showPan(this._main.patrolPan);
					if(_patrolUI)
						changeMapUIIdex(_patrolUI);
					break;
				case MirMapEditer.POINT:
					this._main.rightPan.visible = false;
					this._main.patrolPan.visible=false;
					this._main.obsAndAreaPan.visible=false;
					this._main.pointPan.visible=true;
					this._main.sceEffMonBoxPan.visible=false;
					MapPoint.instance.show(this._main.pointPan);
					if(_pointUI)
						changeMapUIIdex(_pointUI);
					break;
				case -1:
					this._main.rightPan.visible = false;
					this._main.patrolPan.visible=false;
					this._main.obsAndAreaPan.visible=false;
					this._main.pointPan.visible=false;
					this._main.sceEffMonBoxPan.visible=false;
			}
			if($idx !=  MirMapEditer.PATROL)
				MapPatrol.instance.hidePatrol();
			if(btnIdx == MirMapEditer.SCENE && $idx != MirMapEditer.SCENE)
				MapScene.instance.uiEvent(false);
			if(btnIdx == MirMapEditer.EFFECT && $idx != MirMapEditer.EFFECT)
				MapEffect.instance.uiEvent(false);
			if(btnIdx == MirMapEditer.MONSTER && $idx != MirMapEditer.MONSTER)
				MapMonster.instance.uiEvent(false);
			if(btnIdx == MirMapEditer.BOX && $idx != MirMapEditer.BOX)
				MapBox.instance.uiEvent(false);
			if(btnIdx == MirMapEditer.AREA && $idx != MirMapEditer.AREA && _areaUI!= null)
				_areaUI.visible = false;
			btnIdx = $idx;
		}
		/*显示 场景 特效 怪物 宝箱面板*/
		private function sceEffMonBoxPan():void
		{
			this._main.patrolPan.visible=false;
			this._main.obsAndAreaPan.visible=false;
			this._main.pointPan.visible=false;
			this._main.sceEffMonBoxPan.visible=true;
		}
		/*set 显示 场景 特效 怪物 宝箱面板的title*/
		private function setSceEffMonBoxPanTitle($table:int):void {
			this._main.sceEffMonBoxPan.panTitle=MapUtil.getTitleByIdx($table);
			this._main.sceEffMonBoxPan.panStaTitle = MapUtil.getStaTitleByIdx($table);
		}
		
		/*显示 障碍物 区域面板*/
		private function obstacleAreaPan():void
		{
			this._main.patrolPan.visible=false;
			this._main.obsAndAreaPan.visible=true;
			this._main.pointPan.visible=false;
			this._main.sceEffMonBoxPan.visible=false;
		}
		/*set 障碍物 区域面板的title*/
		private function setObsAreaPanTitle($table:int):void
		{
			this._main.obsAndAreaPan.panTitle=MapUtil.getTitleByIdx($table);
			this._main.obsAndAreaPan.panStaTitle=MapUtil.getStaTitleByIdx($table);
		}
		/*显示创建新的场景面板*/
		public function showNewPanInfo():void
		{
			_main.showNewPanInfo();
		}
		/**
		 *打开 打开地图面板 
		 * 
		 */		
		public function showOpenMapInfo():void
		{
			_main.showOpenMapInfo();
		}
		/**
		 *将ui放在地图的最高层级
		 * @param ui
		 * 
		 */		
		private function changeMapUIIdex(ui:UIComponent):void
		{
			if(_main.mapContain.numElements >0 )
			{
				ui.visible = true;
				var idx:int = _main.mapContain.getElementIndex(ui);
				if(idx != -1)
					this._main.mapContain.setElementIndex(ui,this._main.mapContain.numElements -1);
			}
		}
		/**
		 * 加载地图*
		 * @param e
		 * 
		 */		
		public function createNewMap(e:Event = null):void
		{
			mapLayer = new MapLayer();
			if(!_main.newFlag)
				mapLayer.setMapUIWH(_mapW,_mapH);
			if(readType == 0)//散图
			{
				mapLayer.readImags(imgPath);
				var i:int = imgPath.lastIndexOf("\\",imgPath.length);
				if(openMapName != null)
				mapName = openMapName;
			}
			else if(readType == 1)//整图
			{
				mapLayer.load(imgPath);
				var index:int = imgPath.indexOf(".");
				var idx:int =  imgPath.lastIndexOf("\\",imgPath.length);
				mapName = imgPath.slice(idx+1,index);
				trace(mapName);
			}
		}
		/**
		 *打开地图 
		 * 
		 */		
		public function openNewMap(e:Event):void
		{
			var path:String;
			if(openSceneName !=null&& openSceneName!= "")
				path = FileName.saveFilePath+openSceneName+"\\"+openSceneName+".txt";
			else if(openMapPath !=null&&openMapPath!="")
			{
				path = openMapPath;
				openSceneName = openMapPath.slice(openMapPath.lastIndexOf("\\",openMapPath.length)+1);
				openSceneName =openSceneName.split(".")[0];
			}
			var ba:ByteArray = FileUtil.readFile(path);
			if(ba == null)
				return;
			var str:String = ba.readMultiByte(ba.length,"utf-8");
			var arr:Array = str.split(",");
//			str+="gridType:"+gridType+",";
//			str+="sceneName:"+sceneName+",";
//			str+="mapName:"+mapName+",";
//			str+="cutSize:"+cutSize;
//			str+="gridW:"+gridW;
//			str+="gridH:"+gridH;
//			str+="mapWidth:"+mapLayer.mapWidth+",";
//			str+="mapHeight:"+mapLayer.mapHeight+",";
//			str+="mapGrideX:"+rowXNum+",";
//			str+="mapGrideY:"+rowYNum+",";
			var name:Array = (arr[1] as String).split(":");
			if(name[1] != openSceneName)
			{
				Alert.show("读取文件的场景名字跟输入的场景名字不一致");
				return;
			}
			name = (arr[1] as String).split(":");
			sceneName = openSceneName;
			name = (arr[2] as String).split(":");
			openMapName = name[1];
//			imgPath = FileName.saveFilePath+openSceneName+"\\"+FileName.mapCutFileName;
			name = (arr[0] as String).split(":");
			gridType = name[1];
			name = (arr[3] as String).split(":");
			cutSize = name[1];
			name = (arr[4] as String).split(":");
			gridW = name[1];
			name = (arr[5] as String).split(":");
			gridH = name[1];
			name = (arr[6] as String).split(":");
			_mapW = name[1];
			name = (arr[7] as String).split(":");
			_mapH = name[1];
			name = (arr[8] as String).split(":");
			_rowXNum =name[1];
			name = (arr[9] as String).split(":");
			_rowYNum =name[1];
			name = (arr[10] as String).split("'");
			imgPath = (name[1] as String).substr(0,(name[1] as String).length);
			readType = 0;
			createNewMap();
		}
		/**
		 *将地图放在主界面上 
		 * @param ui
		 * 
		 */		
		public function set imgUI(ui:UIComponent):void
		{
			clearData();
			if(this._main.mapContain.numElements >0)
			{
				this._main.mapContain.removeAllElements();
			}
			this._main.mapContain.addElementAt(mapLayer,0);
			this._main.imgSize.text = mapLayer.maplayerW +"X"+mapLayer.maplayerH;
			maplayAddEvent();
			createGridLayer(gridW,gridH,gridType);
			creatFlag = true;
			btnClick(-1);
			MapPoint.instance.readData(FileName.pointFilePath);
			var path:String = FileName.saveFilePath +sceneName+"\\"+FileName.xmlFileName;
			if(!_main.newFlag)
			{
				readData(path);//读取xml表
				path = FileName.saveFilePath +sceneName+"\\"+FileName.clientFileName;
				readData(path);
			}
			else
			{
				if(readType == 1)
					cutMap(cutSize,cutSize);
				scaleMap(scalePersent);
				saveConfigFile();
			}
			_miniMap = new MiniMap(_main.miniMap,mapWidth,mapHeight);
			if(readType ==1)
				_miniMap.wholeMap = mapLayer.imgBMD
			else _miniMap.loadSamllMap();
			if(_main.stage)
			{
				_main.stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown);
				_main.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUP);
			}
		}
		/**
		 *读取之前存过的数据  
		 * @param path
		 * 
		 */		
		private function readData(path:String):void
		{
			var file:File = new File(path);
			if(!file.exists)
			{
				Alert.show(path+"不存在");
				return;
			}	
			file.addEventListener(FileListEvent.DIRECTORY_LISTING, onListGet);
			file.getDirectoryListingAsync();
			var fileList:Array;
			function onListGet(evt:FileListEvent):void
			{
				fileList = evt.files;
				var i:int;
				var arr:Array;
				var fileName:String;
				for(i = 0 ; i<fileList.length;i++)
				{
					fileName = fileList[i].name as String
					arr =(fileList[i].name as String).split(".");
					if(arr[1] != "xml" && arr[1] != "map")
						continue;
					var ba:ByteArray = new ByteArray();
					ba = FileUtil.readFile(path+"\\"+fileName);
					ba.position = 0;
					if(arr[0] == sceneName+MapObstacle.filename)
						MapObstacle.instance.obstacleDataXml = ba;
					else
					{
						var xml:XML = new XML(ba.readMultiByte(ba.length,"utf-8"));
						if(xml.child("data").length()<=0)
							continue;
						if(arr[0]==sceneName)
							MapScene.instance.modeListData = xml;
						else if(arr[0] == sceneName+MapEffect.fileName)
							MapEffect.instance.effectListData = xml;
						else if(arr[0] == sceneName+MapMonster.fileName)
							MapMonster.instance.monsterListData = xml;
						else if(arr[0] == sceneName + MapBox.fileName)
							MapBox.instance.boxDataXml = xml;
						else if(arr[0] == sceneName+MapArea.fileName)
							MapArea.instance.areaDataXml=xml;
						else if(arr[0] == sceneName+MapPatrol.fileName)
							MapPatrol.instance.lineDataXml = xml;
					}
				}
				btnClick(-1);//数据读取完之后刷新当前层面板
			}
		}
		/**
		 *添加鼠标事件
		 * 
		 */		
		private function maplayAddEvent():void
		{
			mapLayer.addEventListener(MouseEvent.MOUSE_OVER,onOverMap);
			mapLayer.addEventListener(MouseEvent.MOUSE_OUT,onOutMap);
			mapLayer.addEventListener(MouseEvent.MOUSE_DOWN,onDownMap);
			mapLayer.addEventListener(MouseEvent.MOUSE_UP,onUpMap);
			mapLayer.addEventListener(MouseEvent.CLICK,onClickMap);
		}
		/**
		 *取消事件 
		 * 
		 */		
		private function maplayRemoveEvent():void
		{
			mapLayer.removeEventListener(MouseEvent.MOUSE_OVER,onOverMap);
			mapLayer.removeEventListener(MouseEvent.MOUSE_OUT,onOutMap);
			mapLayer.removeEventListener(MouseEvent.MOUSE_DOWN,onDownMap);
			mapLayer.removeEventListener(MouseEvent.MOUSE_UP,onUpMap);
			mapLayer.removeEventListener(MouseEvent.CLICK,onClickMap);
		}
		/**
		 *地图的宽 
		 * @return 
		 * 
		 */		
		public function get mapWidth():Number
		{
			if(_mapW > 0)
				return _mapW;
			else return mapLayer.mapWidth;
		}
		public function get mapHeight():Number
		{
			if(_mapH > 0)
				return _mapH;
			else return mapLayer.mapHeight;
		}
		public function get maplayerW():Number
		{
			
			return mapLayer.maplayerW;
		}
		public function get maplayerH():Number
		{
			if(gridType == inside_diamond)
				return mapGrid.hh;
			else return mapLayer.maplayerH;
		}
		public function get rowXNum():int
		{
			if(mapGrid.rowX == 0)
				return _rowXNum;
			else return mapGrid.rowX;
		}
		public function get rowYNum():int
		{
			if(mapGrid.rowY == 0)
				return _rowYNum;
			else
				return mapGrid.rowY;
		}
		/**
		 *切割地图  并保存
		 * 
		 */		
		private function cutMap(w:int,h:int):void
		{
			var path:String = FileName.saveFilePath+sceneName+"\\"+FileName.mapCutFileName+"\\";
			MapUtil.cutMap(mapLayer.imgBMD,w,h,path);
		}
		/**
		 *缩小地图  并保存
		 * @param per 
		 * 
		 */			
		private function scaleMap(per:int):void
		{
			if(readType != 1)
				return;
			var scaleMapData:BitmapData = MapUtil.scaleMap(mapLayer.imgBMD,per);
			var path:String = FileName.saveFilePath+sceneName+"\\";
			FileUtil.saveImg(path,scaleMapData,mapName+".jpg");
		}
		/**
		 *创建格子层 
		 * @param w
		 * 
		 */		
		private function createGridLayer(w:int,h:int,flag:int):void
		{
			mapGrid = new MapGrid(mapLayer);
			mapGrid.drawGrid(w,h,flag);
		}
		/**
		 *显示格子 
		 * @param ui
		 * 
		 */		
		public function set gridUI(ui:UIComponent):void
		{
//			this._main.mapContain.addElement(mapGrid);
			mapLayer.addChild(mapGrid);
			mapGrid.x = 0;
			mapGrid.y = 0;
		}
		/**
		 *鼠标移入
		 * @param e
		 * 
		 */		
		public function onOverMap(e:MouseEvent):void
		{
			gridPoint();
			mapLayer.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			
		}
		/**
		 * 鼠标移出地图
		 * @param e
		 * 
		 */		
		private function onOutMap(e:MouseEvent):void
		{
			mapLayer.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			if(btnIdx == MirMapEditer.AREA)
				MapArea.instance.removeColorUI();
			else if(btnIdx == MirMapEditer.OBSTACLE)
				MapObstacle.instance.removeColorUI();
		}
		/**
		 *鼠标移动的监听 
		 * @param e
		 * 
		 */		
		private function onMouseMove(e:MouseEvent):void
		{
			var p:Point = gridPoint();
			if(p == null)
				return;
			if(p.x>=rowXNum||p.y>=rowYNum)
				return;
			setGridePoint(p);
			if(btnIdx == MirMapEditer.AREA)
				MapArea.instance.mouseMoveFun(p);
			if(btnIdx == MirMapEditer.OBSTACLE)
				MapObstacle.instance.mouseMoveFun(p);
		}
		/**
		 * 鼠标Down
		 * @param evt
		 * 
		 */		
		private function onDownMap(evt:MouseEvent):void
		{
			if(shiftFlag)
				return;
			mapLayer.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			mapLayer.addEventListener(MouseEvent.MOUSE_MOVE,onDownMove);
			var p:Point = gridPoint();
			if(p == null)
				return;
			if(p.x>=rowXNum||p.y>=rowYNum)
				return;
			if(btnIdx == MirMapEditer.AREA)
				MapArea.instance.onDownMap(p);
			if(btnIdx == MirMapEditer.OBSTACLE)
				MapObstacle.instance.onDownMap(p);
		}
		/**
		 * 鼠标Up
		 * @param evt
		 * 
		 */		
		public function onUpMap(evt:MouseEvent = null):void
		{
			if(mapLayer == null)
				return;
			mapLayer.removeEventListener(MouseEvent.MOUSE_MOVE,onDownMove);
			mapLayer.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			if(shiftFlag)
				return;
			var p:Point = gridPoint();
			if(p == null)
				return;
			if(btnIdx == MirMapEditer.AREA)
				MapArea.instance.onUpMap(p);
			else if(btnIdx == MirMapEditer.OBSTACLE)
				MapObstacle.instance.onMouseUp();
		}
		/**
		 * 鼠标按下移动
		 * @param e
		 * 
		 */	
		private function onDownMove(e:MouseEvent):void
		{
			if(shiftFlag)
				return;
			var p:Point = gridPoint();
			if(p == null)
				return;
			if(p.x>=rowXNum||p.y>=rowYNum)
				return;
			if(btnIdx == MirMapEditer.AREA)
				MapArea.instance.onMoveMap(p);
			if(btnIdx == MirMapEditer.OBSTACLE)
				MapObstacle.instance.onDownMoveMap(p);
		}
		/**
		 *点击地图 
		 * @param e
		 * 
		 */		
		private function onClickMap(e:MouseEvent):void
		{
			if(shiftFlag)
				return;
			var p:Point = gridPoint();
			if(p == null)
				return;
			if(p.x>=rowXNum||p.y>=rowYNum)
				return;
			switch(btnIdx)
			{
				case MirMapEditer.SCENE:
					MapScene.instance.mapClick(p);
					break;
				case MirMapEditer.EFFECT:
					MapEffect.instance.mapClick(p);
					break;
				case MirMapEditer.MONSTER:
					MapMonster.instance.mapClick(p);
					break;
				case MirMapEditer.BOX:
					MapBox.instance.mapClick(p);
					break;
				case MirMapEditer.AREA:
//					MapArea.instance.mapClick(gridPoint());
					break;
				case MirMapEditer.OBSTACLE:
					break;
				case MirMapEditer.PATROL:
					MapPatrol.instance.mapClick(p);
					break;
				case MirMapEditer.POINT:
					MapPoint.instance.mapClick(p);
					break;
			}
		}
		/**
		 *坐标转换
		 * @param e
		 * 
		 */		
		public function gridPoint():Point
		{
			if(!mapLayer.stage)
				return null;
			var p:Point = new Point(mapLayer.stage.mouseX,mapLayer.stage.mouseY);
			var point:Point = this.mapLayer.globalToLocal(p);
			var grideP:Point = changeToGrid(point);
			return grideP;
		}
		public function changeToGrid($p:Point):Point
		{
			var grideP:Point = new Point();
			if(gridType == outside_diamond ||gridType == inside_diamond)
			{
				var y:Number = Math.abs($p.y - maplayerH /2);
				if(y/$p.x > 0.5)
					return null;
				y = $p.y - maplayerH /2;
				var x:Number =  $p.x;
				grideP = MapUtil.localToGridePoint(new Point(x,y));
			}
			else if(gridType == rect)
				grideP = MapUtil.localToGridePoint($p,1);
			return grideP;
		}
		/**
		 *设置鼠标所在的格子的坐标在界面上显示出来
		 * @param point
		 * 
		 */		
		public function setGridePoint(point:Point):void
		{
			this._main.gridId.text = point.x.toString()+" X "+ point.y.toString();
			var p:Point = MapUtil.gridToGlobalPoint(point);
			this._main.xy.text = p.x + "_"+p.y;
		}
		/**
		 *保存地图文件 
		 * 
		 */		
		public function saveFile():void
		{
			if(creatFlag == false)
			{
				MapUtil.notMapAlert();
				return;
			}
			MapScene.instance.saveData();
			MapEffect.instance.saveFileData();
			MapMonster.instance.saveFile();
			MapBox.instance.saveFile();
			MapArea.instance.saveFile();
			MapObstacle.instance.saveFile();
			MapPatrol.instance.saveFile();
			MapPoint.instance.saveFile();
			if(_miniMap)
				_miniMap.saveSamllImg();
			Alert.show("存储数据操作完成");
		}
		/**
		 *保存场景属性文件 
		 * 
		 */		
		private function saveConfigFile():void
		{
			var str:String = new String();
			str+="gridType:"+gridType+",";
			str+="sceneName:"+sceneName+",";
			str+="mapName:"+mapName+",";
			str+="cutSize:"+cutSize+",";
			str+="gridW:"+gridW+",";
			str+="gridH:"+gridH+",";
			str+="mapWidth:"+mapLayer.mapWidth+",";
			str+="mapHeight:"+mapLayer.mapHeight+",";
			str+="mapGrideX:"+rowXNum+",";
			str+="mapGrideY:"+rowYNum+",";
			if(readType==0)
				str+="imgPath:"+"'"+imgPath+"'";
			else str+="imgPath:"+"'"+FileName.saveFilePath+sceneName+"\\"+FileName.mapCutFileName+"'";
			FileUtil.saveFile(FileName.saveFilePath+sceneName+"\\"+sceneName+".txt",str);
		}
		/**
		 *菜单中 格子显示的状态 
		 * 
		 */		
		public function gridStatus(f:int):void
		{
			mapGrid.showLine(f);
		}
		/**
		 *添加模型层 
		 * @param ui
		 * 
		 */		
		public function set sceneUI(ui:UIComponent):void
		{
			_scenUI = ui;
			this._main.mapContain.addElement(ui);
		}
		/**
		 *特效层 
		 * @param ui
		 * 
		 */		
		public function set effectUI(ui:UIComponent):void
		{
			_effectUI = ui;
			this._main.mapContain.addElement(ui);
		}
		/**
		 *宝箱层 
		 * @param ui
		 * 
		 */		
		public function set boxUI(ui:UIComponent):void
		{
			_boxUI = ui;
			this._main.mapContain.addElement(ui);
		}
		/**
		 *怪物层 
		 * @param ui
		 * 
		 */		
		public function set monsterUI(ui:UIComponent):void
		{
			_monsterUI = ui;
			this._main.mapContain.addElement(ui);
		}
		/**
		 *区域层 
		 * @param ui
		 * 
		 */		
		public function set areaUI(ui:UIComponent):void
		{
			_areaUI = ui;
			this._main.mapContain.addElement(ui);
		}
		/**
		 *障碍层 
		 * @param ui
		 * 
		 */		
		public function set obstacleUI(ui:UIComponent):void
		{
			_obstacleUI = ui;
			this._main.mapContain.addElement(ui);
		}
		/**
		 *巡逻层 
		 * @param ui
		 * 
		 */		
		public function set patrolUI(ui:UIComponent):void
		{
			_patrolUI = ui;
			this._main.mapContain.addElement(ui);
		}
		/**
		 *点层 
		 * @param ui
		 * 
		 */		
		public function set pointUI(ui:UIComponent):void
		{
			_pointUI = ui;
			this._main.mapContain.addElement(ui);
		}
		/**
		 *键盘按下事件 
		 * 
		 */
		private var _ctrlFalg:Boolean;
		private var _nFlag:Boolean;
		private var _oFlag:Boolean;
		private var _sFlag:Boolean;
		private var _zFlag:Boolean;
		private var _shftFlag:Boolean;
		private var _numFlag:int = -1;
		public function onkeyBoardDown(evt:KeyboardEvent):void
		{
			switch(evt.keyCode)
			{
				case Keyboard.DELETE:
					onKeyBoardDelete();
					evt.updateAfterEvent();
					break;
				case Keyboard.CONTROL:
					onKeyBoardControl(true);
					_ctrlFalg = true;
					evt.updateAfterEvent();
					break;
				case Keyboard.N:
					_nFlag = true;
					evt.updateAfterEvent();
					checkCtrl();
					break;
				case Keyboard.O:
					_oFlag = true;
					evt.updateAfterEvent();
					checkCtrl();
					break;
				case Keyboard.S:
					_sFlag = true;
					evt.updateAfterEvent();
					checkCtrl();
					break;
				case Keyboard.Z:
					_zFlag = true;
					evt.updateAfterEvent();
					checkCtrl();
					break;
				case Keyboard.NUMBER_1:
				case Keyboard.NUMPAD_1:
					_numFlag = 1
					evt.updateAfterEvent();
					checkCtrl();
					break;
				case Keyboard.NUMBER_2:
				case Keyboard.NUMPAD_2:
					_numFlag =2
					evt.updateAfterEvent();
					checkCtrl();
					break;
				case Keyboard.NUMBER_3:
				case Keyboard.NUMPAD_3:
					_numFlag = 3;
					evt.updateAfterEvent();
					checkCtrl();
					break;
				case Keyboard.NUMBER_4:
				case Keyboard.NUMPAD_4:
					_numFlag = 4;
					evt.updateAfterEvent();
					checkCtrl();
					break;
				case Keyboard.NUMBER_5:
				case Keyboard.NUMPAD_5:
					_numFlag = 5;
					evt.updateAfterEvent();
					checkCtrl();
					break;
				case Keyboard.NUMBER_6:
				case Keyboard.NUMPAD_6:
					_numFlag = 6
					evt.updateAfterEvent();
					checkCtrl();
					break;
				case Keyboard.NUMBER_7:
				case Keyboard.NUMPAD_7:
					_numFlag = 7;
					evt.updateAfterEvent();
					checkCtrl();
					break;
				case Keyboard.NUMBER_8:
				case Keyboard.NUMPAD_8:
					_numFlag = 8;
					evt.updateAfterEvent();
					checkCtrl();
					break;
				case Keyboard.SHIFT:
					onkeyBoardShift(true);
					break;
			}
		}
		/**
		 * 键盘up事件
		 * @param evt
		 * 
		 */		
		public function onkeyBoardUp(evt:KeyboardEvent):void
		{
			switch(evt.keyCode)
			{
				case Keyboard.CONTROL:
					_ctrlFalg = false;
					onKeyBoardControl(false);
					break;
				case Keyboard.N:
					_nFlag = false;
					evt.updateAfterEvent();
					break;
				case Keyboard.O:
					_oFlag = false;
					evt.updateAfterEvent();
					break;
				case Keyboard.S:
					_sFlag = false;
					evt.updateAfterEvent();
					break;
				case Keyboard.Z:
					_zFlag = false;
					evt.updateAfterEvent();
					break;
				case Keyboard.NUMBER_1:
				case Keyboard.NUMPAD_1:
					_numFlag = -1;
					evt.updateAfterEvent();
					break;
				case Keyboard.NUMBER_2:
				case Keyboard.NUMPAD_2:
					_numFlag =-1
					evt.updateAfterEvent();
					break;
				case Keyboard.NUMBER_3:
				case Keyboard.NUMPAD_3:
					_numFlag = -1;
					evt.updateAfterEvent();
					break;
				case Keyboard.NUMBER_4:
				case Keyboard.NUMPAD_4:
					_numFlag = -1;
					evt.updateAfterEvent();
					break;
				case Keyboard.NUMBER_5:
				case Keyboard.NUMPAD_5:
					_numFlag = -1;
					evt.updateAfterEvent();
					break;
				case Keyboard.NUMBER_6:
				case Keyboard.NUMPAD_6:
					_numFlag = -1;
					evt.updateAfterEvent();
					break;
				case Keyboard.NUMBER_7:
				case Keyboard.NUMPAD_7:
					_numFlag = -1;
					evt.updateAfterEvent();
					break;
				case Keyboard.NUMBER_8:
				case Keyboard.NUMPAD_8:
					_numFlag = -1;
					evt.updateAfterEvent();
					break;
				case Keyboard.SHIFT:
					onkeyBoardShift(false);
					break;
			}
		}
		/**
		 *delete按键 
		 * 
		 */		
		private function onKeyBoardDelete():void
		{
			if(btnIdx == MirMapEditer.AREA)
				MapArea.instance.deleteClick();
			if(btnIdx == MirMapEditer.PATROL)
				MapPatrol.instance.deleteClick();
			if(btnIdx == MirMapEditer.POINT)
				MapPoint.instance.deleteClick();
			if(btnIdx == MirMapEditer.SCENE)
				MapScene.instance.deleteClick();
			if(btnIdx == MirMapEditer.EFFECT)
				MapEffect.instance.deleteClick();
			if(btnIdx == MirMapEditer.BOX)
				MapBox.instance.deleteClick();
			if(btnIdx == MirMapEditer.MONSTER)
				MapMonster.instance.deleteClick();
		}
		/**
		 *control键 
		 * 
		 */		
		private function onKeyBoardControl($f:Boolean):void
		{
			if(btnIdx == MirMapEditer.OBSTACLE)
				MapObstacle.instance.controlFlag = $f;
		}
		/**
		 *shift键 
		 * @param $f true：down false:up
		 * 
		 */		
		private function onkeyBoardShift($f:Boolean):void
		{
			shiftFlag = $f;
			if(btnIdx == MirMapEditer.OBSTACLE)
				MapObstacle.instance.shiftFlag = $f;
		}
		/**
		 *set ctrl键 
		 * 
		 */		
		private function checkCtrl(evt:Event = null):void
		{
			if(_ctrlFalg && _oFlag)//打开地图
			{
				_main.showOpenMapInfo();
				_ctrlFalg = false;
				_oFlag = false;
			}
			else if(_ctrlFalg && _nFlag)//新建地图
			{
				_main.showNewPanInfo();
				_ctrlFalg = false;
				_nFlag = false;
			}	
			else if(_ctrlFalg && _sFlag)//保存数据
			{
				saveFile();
				_ctrlFalg = false;
				_sFlag = false;
			}
			else if(_ctrlFalg && _numFlag != -1)//
			{
				btnClick(_numFlag-1);
				_numFlag = -1;
			}
		}
		public function set shiftFlag($f:Boolean):void
		{
			_shftFlag = $f;
		}
		public function get shiftFlag():Boolean
		{
			return _shftFlag;
		}
		/**
		 *清理数据 
		 * 
		 */		
		private function clearData():void
		{
			MapScene.instance.clearData();
			_scenUI = null;
			MapEffect.instance.clearData();
			_effectUI = null;
			MapMonster.instance.clearData();
			_monsterUI = null;
			MapBox.instance.clearData();
			_boxUI = null;
			MapArea.instance.clearData();
			_areaUI = null;
			MapObstacle.instance.clearData();
			_obstacleUI = null;
			MapPatrol.instance.clearData();
			_patrolUI = null;
			MapPoint.instance.clearData();
			_pointUI = null;
			openSceneName = null;
			openMapPath= null;
			_miniMap = null;
			openMapName = null;
			if(_main.newFlag)
			{
				_mapW = 0;
				_mapH = 0;
				_rowXNum = 0;
				_rowYNum = 0;
			}
		}
		/**
		 * 更换地图的菜单点击
		 * 
		 */		
		public function changeMapMenuClick():void
		{
			_main.changeMapMenuClick();
		}
		/**
		 *更换地图 
		 * 
		 */	
		private var changeMapLayer:MapLayer;
		public function changeMap(e:Event):void
		{
			var index:int = changePath.indexOf(".");
			var idx:int =  changePath.lastIndexOf("\\",changePath.length);
			changeMapName = changePath.slice(idx+1,index);
			if(changeMapName != mapName)
			{
				Alert.show("底图的名字与原底图不一致！！！！！");
				return;
			}
			changeMapLayer = new MapLayer();
			changeMapLayer.load(changePath,1);
		}
		/**
		 *更换的地图加载成功 
		 * @param ui
		 * 
		 */		
		public function set changeMapUI(ui:UIComponent):void
		{
			if((ui as MapLayer).mapWidth != mapWidth || (ui as MapLayer).mapHeight != mapHeight)
			{
				Alert.show("底图的宽高与原底图不一致!!!!");
				changeMapLayer  = null;
				return;
			}
			else 
			{
				maplayRemoveEvent();
				_main.mapContain.removeElement(mapLayer);
				mapLayer = changeMapLayer;
				_main.mapContain.addElementAt(mapLayer,0);
				maplayAddEvent();
				cutMap(cutSize,cutSize);
				MapUtil.saveBigMap(mapLayer.imgBMD);
				readType = 1;
				scalePersent = changeMapScale;
				scaleMap(scalePersent);
				saveConfigFile();
			}
		}
		/**
		 *设置滚动条的位置 显示到容器的中心位置
		 * @param $grid 要显示到中心的格子坐标
		 * 
		 */		
		public function setMapScrollerToCenter($grid:Point):void
		{
			var groupW:Number = _main.mapContain.width;
			var groupH:Number = _main.mapContain.height;
			if(mapWidth <= groupW && mapHeight <= groupH)
				return;
			var point:Point = MapUtil.gridToGlobalPoint($grid);
			var w:Number = groupW*(groupW/mapWidth);
			var h:Number = groupH*(groupH/mapHeight);
			if(point.x-groupW/2 <0)
				_main.mapContain.horizontalScrollPosition = 0;
			else _main.mapContain.horizontalScrollPosition = point.x-groupW/2;
			if(point.y-groupH/2 <0)
				_main.mapContain.verticalScrollPosition = 0;
			else _main.mapContain.verticalScrollPosition = point.y-groupH/2;
			miniMapMovieWindow();
		}
		/**
		 *设置滚动条的位置 
		 * @param $grid
		 * @param $flag
		 * 
		 */		
		public function setScrollerPostion($grid:Point,$flag:Boolean = true):void
		{
			var groupW:Number = _main.mapContain.width;
			var groupH:Number = _main.mapContain.height;
			if(mapWidth <= groupW && mapHeight <= groupH)
				return;
			var w:Number = groupW*(groupW/mapWidth);
			var h:Number = groupH*(groupH/mapHeight);
			if($grid.x<0)
				_main.mapContain.horizontalScrollPosition = 0;
			else _main.mapContain.horizontalScrollPosition = $grid.x;
			if($grid.y<0)
				_main.mapContain.verticalScrollPosition = 0;
			else _main.mapContain.verticalScrollPosition = $grid.y;
			scrollerDrop($flag);
		}
		/**
		 *设置 小地图的窗口位置 
		 * 
		 */		
		private function miniMapMovieWindow():void
		{
			if(_miniMap)
				_miniMap.movieWindow(mapContainWPosition,mapContainHPostion);
		}
		public function get mapContainWPosition():Number
		{
			return _main.mapContain.horizontalScrollPosition;
		}
		public function get mapContainHPostion():Number
		{
			return _main.mapContain.verticalScrollPosition;
		}
		/**
		 *滚动条拖动  
		 * @param $flag
		 * 
		 */		
		public function scrollerDrop($flag:Boolean = true):void
		{
			if(readType == 1)
				return;
			if(mapLayer == null)
				return;
			var wS:Number = _main.mapContain.horizontalScrollPosition
			var hS:Number = _main.mapContain.verticalScrollPosition;
			var startXNum:int;
			var startYnum:int;
			var endXNum:int;
			var endYNum:int;
			var arr:Array;
			if(gridType == outside_diamond)//菱形
			{
				var xx:Number = (mapLayer.width-mapLayer.mapWidth)/2;
				var yy:Number = (mapLayer.height-mapLayer.mapHeight)/2;
				if(((wS+_main.mapContain.width) >= xx && (wS+_main.mapContain.width) <= mapLayer.mapWidth+xx+xx)&&
					((hS+ _main.mapContain.height)>= yy && (hS+ _main.mapContain.height)<=mapLayer.mapHeight+yy+yy))
				{
					startXNum = Math.floor((wS-xx)/cutSize);
					if(startXNum <0)
						startXNum = 0;
					endXNum = Math.ceil(_main.mapContain.width/cutSize)+startXNum;
					startYnum = Math.floor((hS-yy)/cutSize);
					if(startYnum <0)
						startYnum = 0;
					endYNum = Math.ceil(_main.mapContain.height/cutSize)+startYnum;
				}
			}
			else if(gridType == rect||gridType == inside_diamond)//方形
			{
				arr = xNumyNum(wS,hS,cutSize,cutSize,typeCut);
				startXNum = arr[0];
				startYnum = arr[1];
				endXNum = arr[2];
				endYNum = arr[3];
			}
			var xMax:int = Math.ceil(mapWidth/cutSize);
			if(endXNum >=xMax)
				endXNum = xMax-1;
			var ymax:int = Math.ceil(mapHeight/cutSize);
			if(endYNum>=ymax)
				endYNum = ymax-1;
			mapLayer.loadRange(startXNum,endXNum,startYnum,endYNum);
			addModeUI(btnIdx);
			if($flag)
				miniMapMovieWindow();
		}
		/**
		 * 局部加载
		 * @param $wS
		 * @param $hS
		 * 
		 */		
		public function addModeUI($idx:int,$arr:Array = null):void
		{
			var wS:Number = _main.mapContain.horizontalScrollPosition
			var hS:Number = _main.mapContain.verticalScrollPosition;
			if($idx != -1)
			{
				if($arr == null)
				$arr = xNumyNum(wS,hS,gridW,gridH,typeGrid);
				if($idx == MirMapEditer.OBSTACLE)
					MapObstacle.instance.setObstacle($arr[0],$arr[1],$arr[2],$arr[3]);
				if($idx == MirMapEditer.SCENE)
					MapScene.instance.setMc($arr[0],$arr[1],$arr[2],$arr[3]);
				if($idx == MirMapEditer.EFFECT)
					MapEffect.instance.setMc($arr[0],$arr[1],$arr[2],$arr[3]);
				if($idx == MirMapEditer.MONSTER)
					MapMonster.instance.setMc($arr[0],$arr[1],$arr[2],$arr[3]);
				if($idx == MirMapEditer.BOX)
					MapBox.instance.setMc($arr[0],$arr[1],$arr[2],$arr[3]);
			}
		}
		/**
		 *得到加载的格子的x y 开始num结束Num 
		 * @param $wS
		 * @param $hS
		 * @param $Xw
		 * @param $Yh
		 * @return 
		 * 
		 */		
		public function xNumyNum($wS:Number,$hS:Number,$Xw:Number,$Yh:Number,flag:int):Array
		{
			var startXNum:int;
			var startYNum:int;
			var endXNum:int;
			var endYNum:int;
			if((flag == typeGrid && gridType == rect)||(flag == typeCut&&(gridType == rect||gridType == inside_diamond)))//方形格子
			{
				startXNum = Math.floor($wS/$Xw);
				startYNum = Math.floor($hS/$Yh);
				endXNum = Math.ceil(_main.mapContain.width/$Xw)+startXNum;
				endYNum = Math.ceil(_main.mapContain.height/$Yh)+startYNum;
			}
			if(flag == typeGrid&&( gridType == outside_diamond||gridType == inside_diamond))//菱形格子
			{
				var xx:Number;
				var yy:Number;
				var hh:Number;
				if( gridType == outside_diamond)
				{
					xx = (mapLayer.width-mapLayer.mapWidth)/2;
					yy = (mapLayer.height-mapLayer.mapHeight)/2;
					hh = maplayerH;
				}
				else 
				{
					hh = mapGrid.hh;
					xx =0;
					yy =0;
				}
				if((($wS+_main.mapContain.width) >= xx && ($wS+_main.mapContain.width) <= mapLayer.mapWidth+xx+xx)&&
					(($hS+ _main.mapContain.height)>= yy && ($hS+ _main.mapContain.height)<=mapLayer.mapHeight+yy+yy))
				{
					var scrollerSP:Point = new Point($wS,$hS+_main.mapContain.height);
					var scrollerEP:Point = new Point($wS+_main.mapContain.width,$hS);
					var sP:Point = new Point(scrollerSP.x-_main.mapContain.height,scrollerSP.y-_main.mapContain.height/2);
					var eP:Point = new Point(scrollerEP.x+_main.mapContain.height,scrollerEP.y+_main.mapContain.height/2);
					if(sP.x < 0)
						sP.x = 0;
					if(eP.x > mapLayer.width)
						eP.x = mapLayer.width;
					
					var xxx:Number =  sP.x;
					var yyy:Number = Math.abs(sP.y - hh /2);
					if(yyy*2 > xxx)
						yyy = xxx/2;
					var sGP:Point = MapUtil.localToGridePoint(new Point(xxx,yyy));
					sGP = MapUtil.adjustGridePoint(sGP,sP.y - hh /2);
					
					yyy = Math.abs(eP.y - hh /2);
					xxx =  eP.x;
					if(yyy*2 > xxx)
						yyy = xxx/2;
					var eGP:Point = MapUtil.localToGridePoint(new Point(xxx,yyy));
					eGP = MapUtil.adjustGridePoint(eGP,eP.y - hh /2);
					
					startXNum = sGP.x;
					if(startXNum <0)
						startXNum = 0;
					endXNum = sGP.x+eGP.x;
					if(endXNum > rowXNum)
						endXNum = rowXNum;
					startYNum = sGP.y;
					if(startYNum <0)
						startYNum = 0;
					endYNum = sGP.y+eGP.y;
					if(endYNum > rowYNum)
						endYNum = rowYNum
				}
				else if(_main.mapContain.width >mapLayer.mapWidth || _main.mapContain.height<mapLayer.mapHeight)
				{
					startXNum = 0;
					startYNum = 0;
					endXNum = rowXNum;
					endYNum = rowYNum;
				}
			}
			return [startXNum,startYNum,endXNum,endYNum];
		}
		//地图容器的宽 
		public function get containerW():Number
		{                                                                              
			return _main.mapContain.width;
		}
		//地图容器的高
		public function get containerH():Number
		{
			return _main.mapContain.height;
		}
		/**
		 *层次显示的控制 菜单栏用
		 * @param $idx
		 * 
		 */		
		public function layerEffectShowContrl($idx:int):void
		{
			if($idx == MirMapEditer.EFFECT)//显示格子层
			{
				btnClick($idx);
				hideOtherlayerExceptEffect(true);
			}
			else if($idx == -1)//除了格子层之外的其他层
			{
				this.btnClick(-1);
				hideOtherlayerExceptEffect(false);
			}
		}
		/**
		 * 
		 * @param $flag
		 * 
		 */		
		private function hideOtherlayerExceptEffect($flag:Boolean):void
		{
			if(_scenUI)
				_scenUI.visible = !$flag;
			if(_boxUI)
				_boxUI.visible =!$flag;
			if(_monsterUI)
				_monsterUI.visible = !$flag;
			if(_areaUI)
				_areaUI.visible =!$flag;
			if(_obstacleUI)
				_obstacleUI.visible = !$flag;
			if(_patrolUI)
				_patrolUI.visible =!$flag;
			if(_effectUI)
				_effectUI.visible = $flag;
		}
		/**
		 * 
		 * @param $idx
		 * @param $f
		 * 
		 */		
		public function showOrHidePanel($idx:int,$f:Boolean):void
		{
			if($idx == MirMapEditer.OBSTACLE&&_obstacleUI)
				_obstacleUI.visible = $f;
			else if($idx == MirMapEditer.AREA&&_areaUI)
				_areaUI.visible = $f;
		}
		/**
		 *向小地图添加图片 
		 * @param $bmd
		 * @param $xx
		 * @param $yy
		 * 
		 */		
		public function miniMapAddMap($bmd:BitmapData,$xx:Number,$yy:Number):void
		{
			if(_miniMap == null)
			{
				_miniMap = new MiniMap(_main.miniMap,mapWidth,mapHeight);
				_miniMap.loadSamllMap();
			}
			_miniMap.addMap($bmd,$xx,$yy);
		}
		/**
		 *显示或者隐藏小地图 
		 * 
		 */		
		public function showOrhideSamllmap():void
		{
			if(_smallmapFlag)
				_smallmapFlag = false;
			else _smallmapFlag = true;
			_main.miniMap.visible = _smallmapFlag;
		}
		/**
		 *舞台鼠标按下 
		 */		
		private var _perPoint:Point;
		private function onStageMouseDown(evt:MouseEvent):void
		{
			if(_main.mapContain.width>=maplayerW &&_main.mapContain.height>=maplayerH)
				return;
			if(mapLayer&&shiftFlag)
			{
				mapLayer.mouseChildren = false;
				mapLayer.mouseEnabled = false;
				_perPoint = new Point(_main.mapContain.mouseX,_main.mapContain.mouseY);
				_main.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMovie);
			}
		}
		/**
		 *舞台鼠标抬起 
		 * @param evt
		 * 
		 */		
		private function onStageMouseUP(evt:MouseEvent):void
		{
			if(!shiftFlag&&btnIdx != MirMapEditer.AREA)
					MapPanel.instance.onUpMap();	
			if(mapLayer)
			{
				_main.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMovie);
				mapLayer.mouseChildren = true;
				mapLayer.mouseEnabled = true;
				_perPoint null;
			}
		}
		/**
		 *舞台鼠标按下移动 
		 * @param evt
		 * 
		 */		
		private function onStageMouseMovie(evt:MouseEvent):void
		{
			if(shiftFlag)
			{
				if(mapLayer)
				{
					var point:Point = new Point(_main.mapContain.mouseX,_main.mapContain.mouseY);
					if(_perPoint.x != point.x)
					{
						_main.mapContain.horizontalScrollPosition += -point.x+_perPoint.x;
						if(_main.mapContain.horizontalScrollPosition<0)
							_main.mapContain.horizontalScrollPosition = 0;
						if(_main.mapContain.horizontalScrollPosition>mapLayer.width-containerW)
							_main.mapContain.horizontalScrollPosition = mapLayer.width-containerW;
						scrollerDrop();
					}
					if(_perPoint.y!= point.y)
					{
						_main.mapContain.verticalScrollPosition+= -point.y+_perPoint.y;
						if(_main.mapContain.verticalScrollPosition<0)
							_main.mapContain.verticalScrollPosition=0;
						if(_main.mapContain.verticalScrollPosition>mapLayer.height-containerH)
							_main.mapContain.verticalScrollPosition=mapLayer.height-containerH; 
						scrollerDrop();
					}
//					scrollerDrop();
					_perPoint = point;
				}
			}
		}
	}
}