package com.ui.map.child {
	import com.event.MapEditerEvent;
	import com.info.child.DecorateInfo;
	import com.info.child.children.DecorateTreeInfo;
	import com.ui.map.MapPanel;
	import com.ui.panel.NewMapInfoPanel;
	import com.ui.panel.SceEffMonBoxPanel;
	import com.ui.panel.UnitSelectPanel;
	import com.utils.FileUtil;
	import com.utils.MapUtil;
	
	import fileName.FileName;
	
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.net.ObjectEncoding;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.dns.AAAARecord;
	import flash.system.System;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.ui.KeyboardType;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.UIComponent;

	public class MapScene extends UIComponent{
		System.useCodePage = true;//防止出现乱码
		private static var _instance:MapScene;
		private var _panel:SceEffMonBoxPanel;
		private var _rightPan:UnitSelectPanel;
		private var _initF:Boolean;
		private var _file:String = "pnfTable.xml";
		private var _xmlList:XMLList;
		private var _modeList:XML;//添加的模型
		private var _idx:int;//当前用户点击的列表中的索引
		private var _actionXmlList:XMLList;//动作表的数据
		private var _currentAction:XMLList;
		private var _selectMode:MovieClip;
		private var _mcArr:Object;
		private var _mcId:String;//当前的mcid
		private var _sceneMc:MovieClip;
		private var _clickMcName:String;
		private var _treeData:Object;
		private var _direction:int = 0;
		private var _saveFilePath:String;
		private var _saveFileName:String;
		private var _actionIdx:int;
		private var _curentActionName:String="";
		private var _actionIndex:int;
		private var _blend:int;
		public function MapScene() {
			_modeList = <data/>;
			_clickMcName = new String();
		}
		public static function get instance():MapScene {
			if (!_instance)
				_instance=new MapScene();
			return _instance;
		}
		public function showPan($pan:SceEffMonBoxPanel,$right:UnitSelectPanel):void {
			if(_panel== null)
			{
				_panel = $pan;
				_rightPan = $right;
				_rightPan.sceneListCLickFun = clickFileList;
				_rightPan.searchModeFun = searchMode;
				_panel.sceActionSelectFun = clickActionItem;
				_panel.sceneTreeClickFun= treeItemClick;
				addScenLayer();
			}
			_panel.panelType(MirMapEditer.SCENE);
			_rightPan.panelType(MirMapEditer.SCENE);
			readSceFile();
			setFileData();
			setTreeData();
			setPreMc();
			if(_xmlList != null)
				setActionData(_xmlList[_idx].@actId);
			if(_treeData)
				MapPanel.instance.addModeUI(MirMapEditer.SCENE);
			if(_idx != -1)
			{
				_rightPan.setList0SelectItem(_idx);
				clickFileList(_idx);
			}
			uiEvent(false);
		}
		/**
		 *往地图上放以前操作过的东西 
		 * 
		 */		
		public function setMc($xS:int,$yS:int,$xEnd:int,$yEnd:int):void
		{
			if(_treeData == null)
				return;
			for(var i:* in _treeData)
			{
				var d:DecorateTreeInfo = new DecorateTreeInfo();
				d = _treeData[i];
				if(!d)
					return;
				for(var j:int = 0 ; j < d.xx.length;j++)
				{
					var point:Point = new Point(parseInt(d.xx[j],2),parseInt(d.yy[j],2));
					var ui:UIComponent = this.getChildByName(point.x+"_"+point.y) as UIComponent;
					if(ui)
						continue;
					if(point.x >= $xS && point.x <= $xEnd && point.y >= $yS && point.y <= $yEnd)
					{
						_idx = getXmlListIdx(d.id);
						_mcId = _xmlList[_idx].@imgId;
						_direction = d.direction[j];
						mapClick(point,true);
					}
					
				}
			}
		}
		/**
		 *添加ui 
		 * 
		 */		
		private function addScenLayer():void
		{
			this.graphics.beginFill(0xffffff,0);
			this.graphics.lineStyle(1,0x000000);
			this.graphics.moveTo(this.width/2,0);
			this.graphics.lineTo(this.width,this.height/2);
			this.graphics.lineTo(this.width/2,this.height);
			this.graphics.lineTo(0,this.height/2);
			this.graphics.lineTo(this.width/2,0);
			this.graphics.endFill();
			MapPanel.instance.sceneUI = this;
		}
		/**
		 * 
		 * @param $id
		 * @return 
		 * 
		 */		
		private function getXmlListIdx($id:String):int
		{
			var idx:int;
			for(var i:int =0;i < _xmlList.length();i++)
			{
				if(_xmlList[i].@id == $id)
				{
					idx = i;
					break;
				}
			}
			return idx;
		}
		/**
		 *读取模型表的数据 
		 * 
		 */		
		public function readSceFile():void
		{
			if(!_initF)
			{
				var ba:ByteArray = FileUtil.readFile(FileName.readFilePath+FileName.readXmlPahtName+_file);
				ba.position = 0; 
				var xml:XML = new XML(ba.readMultiByte(ba.length,"utf-8"));
				_xmlList = xml.elements();
				_initF = true;
			}
		}
		/**
		 *将读取的模型表信息显示到面板上
		 * 
		 */		
		private function setFileData():void
		{
			_rightPan.setList(_xmlList);
		}
		/**
		 *用户点击了列表中的一条 后改变左板的信息  
		 * @param idx 点击的索引
		 * 
		 */			
		private function clickFileList(idx:int):void
		{
			_idx = idx;
			_mcId = _xmlList[_idx].@imgId;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
			loader.load(new URLRequest(FileName.readFilePath+FileName.sceneResFileName+_mcId+".swf"));
			
			function loadComplete(e:Event):void
			{
				_selectMode = new MovieClip();
				_selectMode = e.currentTarget.content as MovieClip;
				_direction = 0;//方向为北
				if(_actionXmlList != null)
					setActionData(_xmlList[idx].@actId);
				else 
				{
					readActionFile();
					setActionData(_xmlList[idx].@actId);
				}
				_blend = _xmlList[idx].@blend;
				setPreMc();
			}
		}
		/**
		 *设置预览 
		 * 
		 */		
		private function setPreMc():void
		{
			if(_selectMode == null)
				return;
			removePerMc();
			if(_blend == 1)
				_selectMode.blendMode = BlendMode.LIGHTEN;
			_selectMode.gotoAndStop(1);
//			_selectMode.x = 20;
			var ui:UIComponent = new UIComponent();
			ui.addChild(_selectMode);
//			ui.x = 10
			_panel.preGroup.addElement(ui);
			setMcDirection(_selectMode,_direction);
		}
		/**
		 *清楚预览 
		 * 
		 */		
		private function removePerMc():void
		{
			if(_panel.preGroup.numElements)
				_panel.preGroup.removeElementAt(0);
		}
		/**
		 *set动作选择的数据 
		 * @param idx
		 * 
		 */		
		private function setActionData(id:int):void
		{
			_currentAction = new XMLList();
			var _actionArr:ArrayCollection = new ArrayCollection();
			_actionIdx = -1;
			_curentActionName = "";
			for each(var key:XML in _actionXmlList)
			{
				var _id:int = key.@id;
				if(_id == id)
				{
					_actionIdx++;
					_currentAction[_actionIdx] = key;
					var str:String = key..@name;
					_actionArr.addItem(str);
				}
			}
			_panel.setActionData(_actionArr);
		}
		/**
		 *点击动作item 
		 * @param $idx
		 * 
		 */	
		private var _startF:int;//开始帧索引
		private var _frameLong:int;//帧的长度
		private function clickActionItem($idx:int=0):void
		{
			removeSelectMcEnterFrame();
			_actionIndex = $idx;
			_frameLong = _currentAction[$idx]..@preFrame;
			if(_direction<5)
			{
				_startF = _currentAction[$idx]..@startFrame;
				_startF+=_direction*_frameLong;
			}
			if(_direction==5)
			{
				_selectMode.scaleX=-1;
				_startF = _currentAction[$idx]..@startFrame;
				_startF+=3*_frameLong;
			}
			if(_direction == 6)
			{
				_selectMode.scaleX=-1;
				_startF = _currentAction[$idx]..@startFrame;
				_startF+=(2*_frameLong);
			}
			if(_direction == 7)
			{
				_selectMode.scaleX=-1;
				_startF = _currentAction[$idx]..@startFrame;
				_startF+=(1*_frameLong);
			}
			_curentActionName = _currentAction[$idx]..@name; 
			_selectMode.frameRate = _currentAction[$idx]..@interval;
			_selectMode.addEventListener(Event.ENTER_FRAME,modePlay,false,0,true);
			_selectMode.gotoAndPlay(_startF);
		}
		/**
		 *走针 
		 * @param e
		 * 
		 */		
		private function modePlay(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
//			setMcDirection(_selectMode,_direction);
			if(mc.currentFrame >=_startF+_frameLong)
				mc.gotoAndPlay(_startF);
		}
		/**
		 *取消侦听事件 
		 * 
		 */		
		private function removeSelectMcEnterFrame():void
		{
			if(_selectMode == null || _currentAction==null)
				return;
			_selectMode.removeEventListener(Event.ENTER_FRAME,modePlay,false);
		}
		/**
		 *设置tree数据 
		 * 
		 */		
		private function setTreeData():void
		{
			var xml:XML =  <data/>;
			var scenename:String = MapPanel.instance.sceneName;
			xml.@lable = MapPanel.instance.sceneName+"("+getModeNum()+")";
			if(_treeData == null)
				_treeData = new Object();
			for(var i:* in _treeData)
			{
				var str:String = "item"+i;
				var x:XML = <{str}/>;
				x.@lable = (_treeData[i] as DecorateTreeInfo).name + "("+(_treeData[i] as DecorateTreeInfo).xx.length+")";
				for(var j:int = 0 ; j < (_treeData[i] as DecorateTreeInfo).xx.length;j++)
				{
					var xx:XML = <items/>;
					xx.@lable = (_treeData[i] as DecorateTreeInfo).name +"("+(_treeData[i] as DecorateTreeInfo).id+")";
					xx.@xx = (_treeData[i] as DecorateTreeInfo).xx[j];
					xx.@yy = (_treeData[i] as DecorateTreeInfo).yy[j];
					x..j= xx;
				}
				xml..i = x;
			}
			if(xml == null)
				xml = new XML()
			if(_panel != null)
				_panel.setTreeData(xml);
		}
		/**
		 *返回当前已种植的模型的数量 
		 * @return 
		 * 
		 */		
		private function getModeNum():int
		{
			var i:int;
			for (var key:* in _treeData)
			{
				if(_treeData[key])
					i+=(_treeData[key] as DecorateTreeInfo).xx.length;
			}
			return i;
		}		
		/**
		 *点击树中的一项 
		 * @param $x
		 * @param $y
		 * 
		 */		
		public function treeItemClick($x:int,$y:int):void
		{
			MapPanel.instance.setMapScrollerToCenter(new Point($x,$y));
			setMapMcSelect($x+"_"+$y);
		}
		/**
		 *读动作表 
		 * 
		 */		
		private function readActionFile():void
		{
			if(_actionXmlList != null)
				return;
			var ba:ByteArray = FileUtil.readFile(FileName.readFilePath+FileName.readXmlPahtName+"actConfig.xml");
			ba.position = 0; 
			var xml:XML = new XML(ba.readMultiByte(ba.length,"utf-8"));
			_actionXmlList = xml.elements();
		}
		/**
		 *返回动作表的数据 
		 * @return 
		 * 
		 */		
		public function get actionFile():XMLList
		{
			readActionFile();
			return _actionXmlList;
		}
		/**
		 *点击 模型层 
		 * @param point 格子的坐标
		 * @param flag false 玩家点击 ,true 把读取的数据放在ui上 
		 * 
		 */			
		public function mapClick(point:Point,flag:Boolean = false):void
		{
			if(!flag&&_selectMode == null)
				return;
			var gridP:Point = point;
			if(!flag && cheakModeList(point.x,point.y)[0])
			{
				setMapMcSelect(point.x+"_"+point.y);
				return;
			}
			var uiPoint:Point = MapUtil.gridToCenter(gridP);
			var idx:int = _idx;
			var direction:int = _direction;
			var px:Number = _xmlList[idx].@px;
			var py:Number =  _xmlList[idx].@py;
			var blend:int = _xmlList[idx].@blend;
			var load:Loader = new Loader();
			load.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
			load.load(new URLRequest(FileName.readFilePath+FileName.sceneResFileName+_mcId+".swf"));	
			function loadComplete(e:Event):void
			{
				_sceneMc = e.currentTarget.content as MovieClip;
				_sceneMc.gotoAndStop(1);
//				_sceneMc.mouseChildren =false;
//				_sceneMc.mouseEnabled = false;
				if(blend == 1)
					_sceneMc.blendMode = BlendMode.LIGHTEN;
				if(_actionXmlList != null)
					setActionData(_xmlList[idx].@actId);
				else 
				{
					readActionFile();
					setActionData(_xmlList[idx].@actId);
				}
				setMcDirection(_sceneMc,direction);
				var ui:UIComponent = new UIComponent();
				if(direction>4)
					_sceneMc.x=px+_sceneMc.width;
				else _sceneMc.x = px;
				_sceneMc.y = py;
//				_sceneMc.name = gridP.x+"_"+gridP.y;
				ui.addChild(_sceneMc);
				ui.x = uiPoint.x;
				ui.y = uiPoint.y;
				ui.name = gridP.x+"_"+gridP.y;
				ui.addChild(MapUtil.drawCircle(4));
				addChild(ui);
//				ui.mouseChildren = false;
//				ui.mouseEnabled = false;
				ui.addEventListener(MouseEvent.CLICK,onClickMode);
				if(_clickMcName != null && _clickMcName == ui.name)
					setMapMcSelect(_clickMcName);
				if(!flag)
				{
					var sce:DecorateInfo = new DecorateInfo();
					sce.modelId = _xmlList[idx].@id;//模型中到地图上 存数据
					sce.direction = direction;
					sce.pointX = gridP.x.toString(2);
					sce.pointY = gridP.y.toString(2);
					sce.action = _curentActionName;
					_modeList.appendChild(sce.toXmlString(sce));
					treeData(sce);
					setTreeData();
				}
			}
		}
		private function error(evt:IOErrorEvent):void
		{
			Alert.show(evt.text);
		}
		private function treeData(sce:DecorateInfo):void
		{
			if(!checkSceId(sce.modelId))
			{
				if(_treeData== null)
					_treeData = new Object();
				var data:DecorateTreeInfo = new DecorateTreeInfo();
				data.id = sce.modelId;
				var idx:int = getXmlListIdx(data.id);
				data.name = _xmlList[idx].@name;
				data.direction.push(sce.direction);
				data.xx.push(sce.pointX);
				data.yy.push(sce.pointY);
				_treeData[data.id] = data;
			}
			else
			{
				(_treeData[sce.modelId] as DecorateTreeInfo).xx.push(sce.pointX);
				(_treeData[sce.modelId] as DecorateTreeInfo).yy.push(sce.pointY);
				(_treeData[sce.modelId] as DecorateTreeInfo).direction.push(sce.direction);
			}
		}
		private function checkSceId(id:String):Boolean
		{
			if(_treeData == null || _treeData.length == 0)
				return false;
			if(id in _treeData)
				return true;
			else return false;
		}
		/**
		 * 
		 * @param p
		 * 
		 */		
		private function removeUI(name:String):void
		{
			var idx:int = _clickMcName.indexOf("_");
			var xx:int = int(_clickMcName.substring(0,idx));
			var yy:int = int(_clickMcName.substring(idx+1))
			var ui:UIComponent = new UIComponent();
			ui = this.getChildByName(name) as UIComponent;
			this.removeChild(ui);
			_clickMcName = "";
			deleteUIData(xx,yy);
			deleteSaveData(xx,yy);
		}
		/**
		 *更新tree中的数据 
		 * @param xx
		 * @param yy
		 * 
		 */		
		private function deleteUIData(xx:int,yy:int):void
		{
			for(var key:* in _treeData)
			{
				var data:DecorateTreeInfo = _treeData[key];
				for(var i:int = 0;i<data.xx.length;i++)
				{
					if(data.xx[i] == xx.toString(2) && data.yy[i] == yy.toString(2))
					{
						(_treeData[key] as DecorateTreeInfo).xx.splice(i,1);
						(_treeData[key] as DecorateTreeInfo).yy.splice(i,1);
						break;
					}
				}
				if((_treeData[key] as DecorateTreeInfo).xx == null || (_treeData[key] as DecorateTreeInfo).xx.length == 0)
				{
					delete _treeData[key];
				}
			}
			setTreeData();
		}
		/**
		 *更新要存储的数据 
		 * @param xx
		 * @param yy
		 * 
		 */		
		private function deleteSaveData(xx:int,yy:int):void
		{	
			var arr:Array = cheakModeList(xx,yy);
			if(arr[0] == true)
			{
				delete _modeList.child("data")[arr[1]];
			}
		}
		/**
		 *检查坐标为 xx.yy的模型是否已经种植 
		 * @param xx
		 * @param yy
		 * @return 
		 * 
		 */		
		private function cheakModeList(xx:int,yy:int):Array
		{
			var f:Boolean;
			var idx:int = -1;
			var num:int = _modeList.child("data").length();
			for(var i:int = 0;i < num ;i ++)
			{
				if(_modeList.child("data")[i].@pointX == xx.toString(2) && _modeList.child("data")[i].@pointY == yy.toString(2))
				{
					f = true;
					idx = i;
					break;
				}
			}
			return [f,idx];
		}
		/**
		 *点击已经种到地图上的模型  
		 * 
		 */		
		private function onClickMode(e:MouseEvent):void
		{
//			var n:String = (e.currentTarget as UIComponent).name;
//			setMapMcSelect(n);
		}
		/**
		 *设置点击的mc为选中状态 
		 * @param $name
		 * 
		 */		
		private function setMapMcSelect($name:String):void
		{
			var mc:UIComponent = new UIComponent();
			if(_clickMcName != "")
			{
				mc = this.getChildByName(_clickMcName) as UIComponent;
				if(mc)
					mc.filters = null;
			}
			_clickMcName = $name;
			mc = this.getChildByName(_clickMcName) as UIComponent;
			if(mc)
				mc.filters = [MapUtil.glow];
		}
		private function onOver(e:MouseEvent):void
		{
			trace();
		}
		/**
		 * 
		 * 
		 */		
		public function deleteClick():void
		{
			if(_clickMcName!= null && _clickMcName!="")
				removeUI(_clickMcName);
		}
		/**
		 *左转按钮点击 
		 * 
		 */		
		public function leftClick():void
		{
//			八方向
//			0 无八方向
//			1 有八方向
//			2 三方向
			removeSelectMcEnterFrame();
			if(_xmlList[_idx].@direction ==0)//无八方向
			{
				Alert.show("此资源没有八方向");
			}
			else if(_xmlList[_idx].@direction ==1)
			{
				_direction --;
				if(_direction == -1)
					_direction = 7;
			}
			else if(_xmlList[_idx].@direction ==2)
			{
				_direction --;
				if(_direction == -1)
					_direction = 2;
			}
			else _direction --;
			if(_direction <= -1)
				_direction = 7;
			setMcDirection(_selectMode,_direction);
			clickActionItem(_actionIndex);
		}
		/**
		 *右转按钮点击 
		 * 
		 */		
		public function rightClick():void
		{
			removeSelectMcEnterFrame();
			if(_xmlList[_idx].@direction ==0)//无八方向
			{
				Alert.show("此资源没有八方向");
			}
			else if(_xmlList[_idx].@direction ==1)
			{
				_direction ++;
				if(_direction == 8)
					_direction = 0;
			}
			else if(_xmlList[_idx].@direction ==2)
			{
				_direction ++;
				if(_direction == 3)
					_direction = 0;
			}
			else _direction ++;
			if(_direction >= 8)
				_direction = 0;
			setMcDirection(_selectMode,_direction);
			clickActionItem(_actionIndex);
		}
		/**
		 *设置资源的方向走针 
		 * 
		 */		
		private function setMcDirection(mc:MovieClip,$dir:int):void
		{
			if(mc == null)
				return;
			var sta:int = _currentAction[_actionIndex]..@startFrame;
			var long:int = _currentAction[_actionIndex]..@preFrame;
			if($dir <5)
			{
				mc.scaleX=1;
				mc.x =0;
				mc.gotoAndStop(sta+long*($dir+1));
			}
			else
			{
				if($dir == 5)
					mc.gotoAndStop(sta+long*(1+3));
				if($dir == 6)
					mc.gotoAndStop(sta+long*(1+2));
				if($dir == 7)
					mc.gotoAndStop(sta+long*(1+1));
				mc.scaleX = -1;
				mc.x = mc.width;
			}
		}
		/**
		 *添加删除鼠标事件 
		 * @param $f
		 * 
		 */		
		public function uiEvent($f:Boolean):void
		{ 
			this.mouseEnabled = $f;
			this.mouseChildren = $f; 
		}
		/**
		 *外界取得模型表接口 
		 * @return 
		 * 
		 */		
		public function get modeList():XMLList
		{
			if(_xmlList == null)
				readSceFile();
			return _xmlList;
		}
		/**
		 *清理数据 
		 * 
		 */		
		public function clearData():void
		{
			_modeList = <data/>;
			_clickMcName = new String();
			if(this != null)
			{
				uiEvent(false);
				while(this.numChildren >0)
					this.removeChildAt(this.numChildren-1);
			}
			_curentActionName = "";
			if(_panel != null)
			{
				removePerMc();
				_panel = null;
			}
			if(_treeData != null)
			{
				_treeData = null;
				setTreeData();
			}
		}
		/**
		 *查找模型 
		 * @param $id
		 * 
		 */		
		private function searchMode($id:int):void
		{
			var idx:int = -1;
			var num:int = _xmlList.length();
			for(var i:int = 0 ; i<num;i++)
			{
				if(_xmlList[i]..@id == $id)
				{
					idx = i;
					break;
				}
			}
			if(idx != -1 && idx != _idx)
			{
				_idx = idx;
				_rightPan.setList0SelectItem(_idx);
				clickFileList(_idx);
			}
			else Alert.show("id:"+ $id+" 查找失败!!!");
		}
		/**
		 *保存数据 
		 * 
		 */		
		public function saveData():void
		{
			_saveFilePath = FileName.saveFilePath +MapPanel.instance.sceneName+"\\"+FileName.xmlFileName;
			_saveFileName = MapPanel.instance.sceneName;
			FileUtil.saveXmlFile(_saveFilePath,_saveFileName,_modeList);
		}
		/**
		 *设置读取到的数据 到面板上
		 * @param $xml
		 * 
		 */		
		public function set modeListData($xml:XML):void
		{
			_modeList = $xml;
			readSceFile();
			var sce:DecorateInfo = new DecorateInfo();
			var num:int = _modeList.child("data").length();
			for(var i:int = 0 ; i < num;i++)
			{
				sce.modelId = _modeList.child("data")[i].@modelId;
				sce.pointX = _modeList.child("data")[i].@pointX;
				sce.pointY = _modeList.child("data")[i].@pointY;
				sce.direction = _modeList.child("data")[i].@direction;
				treeData(sce);       
			}
		}
	}
}