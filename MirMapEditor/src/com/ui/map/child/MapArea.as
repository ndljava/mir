package com.ui.map.child {
	import com.info.child.AreaInfo;
	import com.info.child.children.AreaTreeInfo;
	import com.ui.map.MapPanel;
	import com.ui.panel.ObstacleAndAreaPanel;
	import com.utils.FileUtil;
	import com.utils.MapUtil;
	
	import fileName.FileName;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.charts.chartClasses.DataDescription;
	import mx.controls.Alert;
	import mx.core.UIComponent;

	/**
	 *区域层
	 * @author Administrator
	 *
	 */
	public class MapArea{
		public static const fileName:String = "_area";
		private static var _instance:MapArea;
		private var _panel:ObstacleAndAreaPanel;
		private var _idx:int = -1;
		private var _areaObject:Object;
		private var _areaXml:XML;
		private var _mian:UIComponent;
		private var _clickF:Boolean =true;
		private var _selectGridArr:Array;
		private var _saveFileName:String;
		private var _saveFilePath:String;
		private var _obstacleFlag:Boolean;
		public function MapArea() {
			_areaXml = <data/>;
		}
		public static function get instance():MapArea{
			if(!_instance)
				_instance = new MapArea();
			return _instance;
		}
		public function showPan($pan:ObstacleAndAreaPanel):void{
			if(!_panel)
			{
				_panel = $pan;
				_panel.areaListClickFun = choseAreaClick;
				_panel.areaBtnVisibaleFun = showOrHideObstaclePan;
				addAreaUI();
			}
			_panel.panelType(MirMapEditer.AREA);
			if(_idx == -1)
				_idx = 0;
			_panel.setColorListItem(_idx);
			choseAreaClick(_idx);
			if(_mian!= null)
				_mian.visible = true;
		}
		/**
		 * 添加区域层
		 * 
		 */		
		private function addAreaUI():void
		{
//			var w:Number = MapPanel.instance.mapWidth;
//			var h:Number = MapPanel.instance.mapHeight;
			_mian = new UIComponent();
//			if(MapPanel.instance.gridType == 0)
//			{
//				_mian.graphics.beginFill(0xff0000,0);
//				_mian.graphics.lineStyle(1,0xff0000);
//				_mian.graphics.moveTo(w/2,0);
//				_mian.graphics.lineTo(w,w/4);
//				_mian.graphics.lineTo(w/2,w/2);
//				_mian.graphics.lineTo(0,w/4);
//				_mian.graphics.lineTo(w/2,0);
//			}
//			else if(MapPanel.instance.gridType == 1)
//			{
//				_mian.graphics.drawRect(0,0,w,h);
//			}
//			_mian.graphics.endFill();
			_mian.name = "areaUI";
			MapPanel.instance.areaUI = _mian;
			_mian.mouseChildren =false;
			_mian.mouseEnabled =false;
		}
		/**
		 *清理数据 
		 * 
		 */		
		public function clearData():void
		{
			_areaXml = <data/>;
			if(_mian != null)
			{
				while(_mian.numChildren >0)
				{
					_mian.removeChildAt(_mian.numChildren-1);
				}
			}
			
			_obstacleFlag = false;
			_panel= null;
			_idx = -1;
//			addAreaUI();
		}
		/**
		 *选择区域的点击 
		 * @param $idx
		 * 
		 */		
		private function choseAreaClick($idx:int):void
		{
			while(this._mian.numChildren >0)
				this._mian.removeChildAt(_mian.numChildren-1);
			_idx = $idx;
			setGridSelect(_idx);
			if(_selectGridArr!= null && _selectGridArr.length>0)
			{
				var n:String = _selectGridArr[0];
				var aa:Array = n.split("*");
				MapPanel.instance.setMapScrollerToCenter(new Point(aa[0],aa[1]));
				MapPanel.instance.scrollerDrop();
				for(var i:int =0 ; i<_selectGridArr.length;i++)
				{
					aa = (_selectGridArr[i] as String).split("*");
					addGridUI(new Point(aa[0],aa[1]),aa[2]);
					addSelectUI(aa[0],aa[1],aa[2])
				}
			}
		}
		/**
		 *点击区域层 
		 * @param $p
		 * 
		 */		
		public function mapClick($p:Point):void
		{
			if(MapPanel.instance.btnIdx!= MirMapEditer.AREA)
				return;
			if(_idx == -1)
			{
				MapPanel.instance.onUpMap();
				Alert.show("请先选择区域颜色！！！");
				return;
			}
		
			if(cheakArea($p))
				return;
			addGridUI($p,_idx);
			var area:AreaInfo = new AreaInfo();
			area.id = _idx;
			area.pointX = $p.x.toString(2);
			area.pointY = $p.y.toString(2);
			_areaXml.appendChild(area.toXmlString(area));
			setGridSelect(_idx);
			for(var i:int = 0 ; i< _selectGridArr.length;i++)
			{
				var aa:Array = (_selectGridArr[i] as String).split("*");
				addSelectUI(aa[0],aa[1],aa[2]);
			}
		}
		/**
		 *添加颜色格子 
		 * @param $p
		 * 
		 */		
		private function addGridUI($p:Point,colorId:int):void
		{
			var n:String = $p.x+"_"+$p.y;
			var point:Point = MapUtil.gridToGlobalPoint($p);
			var arr:Array = MapUtil.checkGridWH(point);
			var ui:Sprite = MapUtil.drawGrid(arr[0],arr[1],MapUtil.getColorUnit(colorId),0.5);
			ui.x = point.x;
			ui.y = point.y;
			ui.name = n;
			_mian.addChild(ui);
		}
		/**
		 *检查是否已种植 
		 * @param $n
		 * @return 
		 * 
		 */		
		private function cheakArea($P:Point):Boolean
		{
			var f:Boolean;
			var ui:Sprite = _mian.getChildByName($P.x+"_"+$P.y) as Sprite;
			if(ui != null)
			{
				_mian.removeChild(ui);
				f = true;
			}
			if(f)
				deleteXmlData($P.x,$P.y);
			return f;
		}
		/**
		 *删除数据 
		 * @param $x
		 * @param $y
		 * 
		 */		
		private function deleteXmlData($x:int,$y:int):void
		{
			var num:int = _areaXml.child("data").length();
			for(var i:int = 0;i < num ;i ++)
			{
				var xx:int = parseInt(_areaXml.child("data")[i].@pointX,2);
				var yy:int = parseInt(_areaXml.child("data")[i].@pointY,2);
				if( xx== $x &&  yy== $y)
				{
					if(_areaXml.child("data")[i].@id == _idx)
						deleteSelectArr(xx+"*"+yy+"*"+_idx);
					delete _areaXml.child("data")[i];
					break;
				}
			}
		}
		/**
		 *删除选中的格子 
		 * @param $name
		 * 
		 */		
		private function deleteSelectArr($name:String):void
		{
			if(_selectGridArr == null || _selectGridArr.length <=0)
				return;
			for(var i:int =0; i < _selectGridArr.length;i++)
			{
				if(_selectGridArr[i] == $name)
				{
					_selectGridArr.splice(i,1);
					removeColorUI($name);
					break;
				}
			}
		}
		/**
		 *鼠标移动 
		 * @param p
		 * 
		 */
		public function mouseMoveFun($p:Point):void
		{
			if(_idx == -1)
				return;
			removeColorUI();
			var point:Point = MapUtil.gridToGlobalPoint($p);
			var arr:Array = MapUtil.checkGridWH(point);
			var ui:Shape = MapUtil.gridGridEdge(arr[0],arr[1],MapUtil.getColorUnit(2),3);
			ui.x = point.x;
			ui.y = point.y;
			ui.name = "_colorUI";
			_mian.addChild(ui);
		}
		/**
		 *删除 
		 * 
		 */		
		public function removeColorUI($name:String = "_colorUI"):void
		{
			var ui:Shape = _mian.getChildByName($name) as Shape;
			if(ui != null)
			{
				_mian.removeChild(ui);
			}
		}
		/**
		 *鼠标按下 
		 * @param $gird
		 * 
		 */	
		public function onDownMap($gird:Point):void
		{
			if(_idx == -1)
			{
				MapPanel.instance.onUpMap();
				Alert.show("请先选择区域颜色！！！");
				return;
			}
			onMoveMap($gird);
		}
		/**
		 *鼠标抬起 
		 * @param $grid
		 * 
		 */	
		public function onUpMap($grid:Point):void
		{
			onMoveMap($grid);
			if(mouseMoveGrid && mouseMoveGrid.length>0)
			{
				for(var i:int =0;i < mouseMoveGrid.length; i++)
				{
					var ui:Shape = _mian.getChildByName(mouseMoveGrid[i]) as Shape;
					if(ui != null)
					{
						_mian.removeChild(ui);
						var n:String = mouseMoveGrid[i];
						var idx:int = n.indexOf("@");
						var xx:int = int(n.substring(0,idx));
						var yy:int = int(n.substring(idx+1));
						removeSelectArr(xx+"*"+yy);
						mapClick(new Point(xx,yy)); 
					}
				}
				mouseMoveGrid.length= 0;
			}
//			mouseNoveGrid.length= 0;
			_preP = null;
		}
		/**
		 *鼠标按下时移动 
		 * @param $grid
		 * 
		 */
		private var mouseMoveGrid:Array;//鼠标按下时移动过的格子
		private var _preP:Point;
		public function onMoveMap($grid:Point):void
		{
			if(_preP &&(_preP.x  == $grid.x && _preP.y == $grid.y))
				return;
			_preP = $grid;
			if(checkGridArr($grid))
				return;
			var p:Point = MapUtil.gridToGlobalPoint($grid);
			var arr:Array = MapUtil.checkGridWH(p);
			var ui:Shape = MapUtil.gridGridEdge(arr[0],arr[1],MapUtil.getColorUnit(_idx));
			ui.x = p.x;
			ui.y = p.y;
			ui.name = $grid.x+"@"+$grid.y;
			if(mouseMoveGrid == null)
				mouseMoveGrid = new Array();
			mouseMoveGrid.push(ui.name);
			_mian.addChild(ui);
		}
		
		/**
		 *检查此格子是否已涂色 
		 * @param $p
		 * @return 
		 * 
		 */		
		private function checkGridArr($p:Point):Boolean
		{
			var f:Boolean;
			if(mouseMoveGrid == null || mouseMoveGrid.length == 0)
				return false;
			for(var i:int =0;i < mouseMoveGrid.length;i++)
			{
				if(mouseMoveGrid[i] == $p.x+"@"+$p.y)
				{
					return true;
					break;
				}	
			} 
			return false;
		}
		/**
		 *设置格子为选中状态
		 * 
		 */		
		private function setGridSelect($colorId:int):void
		{
			removeSelectArr();
			if(_selectGridArr && _selectGridArr.length >0)
				_selectGridArr.length = 0;
			var num:int = _areaXml.child("data").length();
			for(var i:int =0 ; i< num;i++)
			{
				var id:int = _areaXml.child("data")[i].@id;
				if( id == $colorId)
				{
					if(_selectGridArr == null)
						_selectGridArr = new Array();
					var xx:int = parseInt(_areaXml.child("data")[i].@pointX,2);
					var yy:int = parseInt(_areaXml.child("data")[i].@pointY,2);
					var n:String = xx+"*"+yy+"*"+id;
					_selectGridArr.push(n);
//					var p:Point = MapUtil.gridToGlobalPoint(new Point(xx,yy));
//					var arr:Array = MapUtil.checkGridWH(p);
//					var ui:Shape = MapUtil.gridGridEdge(arr[0],arr[1],MapUtil.getColorUnit(100));
//					ui.x = p.x;
//					ui.y = p.y;
//					ui.name = n;
//					_mian.addChild(ui);
				}
			}
		}
		private function addSelectUI(xx:int,yy:int,id:int):void
		{
			var p:Point = MapUtil.gridToGlobalPoint(new Point(xx,yy));
			var arr:Array = MapUtil.checkGridWH(p);
			var ui:Shape = MapUtil.gridGridEdge(arr[0],arr[1],MapUtil.getColorUnit(100));
			ui.x = p.x;
			ui.y = p.y;
			ui.name = xx+"*"+yy+"*"+id;
			_mian.addChild(ui);
		}
		/**
		 *删除选中的格子数 
		 * 
		 */		
		private function removeSelectArr($name:String = null):void
		{
			if(!_selectGridArr || _selectGridArr.length <=0)
				return;
			var i:int;
			for(i = 0; i < _selectGridArr.length;i++)
			{
				var n:String = _selectGridArr[i];
				if($name != null)
				{
					if(n == $name)
					{
						removeColorUI(n);
						break;
					}
				}
				else 
					removeColorUI(n);
			}
		}
		/**
		 *删除按钮点击 
		 * 
		 */		
		public function deleteClick():void
		{
			var num:int = _areaXml.child("data").length();
			for(var i:int = num-1; i>=0;i--)
			{
				var id:int = _areaXml.child("data")[i].@id;
				if( id == _idx)
				{
					var xx:int = parseInt(_areaXml.child("data")[i].@pointX,2);
					var yy:int = parseInt(_areaXml.child("data")[i].@pointY,2);
					cheakArea(new Point(xx,yy));
					var n:String = xx+"*"+yy+"*"+id;
					deleteSelectArr(n);
				}
			}
		}
		/**
		 *保存数据文件 
		 * 
		 */		
		public function saveFile():void
		{
			_saveFilePath =FileName.saveFilePath +MapPanel.instance.sceneName+"\\"+FileName.xmlFileName;
			_saveFileName = MapPanel.instance.sceneName+"_area";
			FileUtil.saveXmlFile(_saveFilePath,_saveFileName,_areaXml);
		}
		/**
		 *设置读取的数据 
		 * @param $xml
		 * 
		 */		
		public function set areaDataXml($xml:XML):void
		{
			_areaXml = $xml;
		}
		/**
		 *将读取的数据显示在面板上
		 * 
		 */		
		public function setArea():void
		{
			var num:int = _areaXml.child("data").length();
			for(var i:int = 0 ; i < num;i++)
			{
				var id:int = _areaXml.child("data")[i].@id;
				var xx:int = parseInt(_areaXml.child("data")[i].@pointX,2);
				var yy:int = parseInt(_areaXml.child("data")[i].@pointY,2);
				addGridUI(new Point(xx,yy),id);
			}
		}
		public function showOrHideObstaclePan():void
		{
			if(_obstacleFlag == false)
				_obstacleFlag = true;
			else _obstacleFlag = false;
			MapPanel.instance.showOrHidePanel(MirMapEditer.OBSTACLE,!_obstacleFlag);
			
		}
	}
}