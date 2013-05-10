package com.ui.map.child {
	import com.info.child.MonsterInfo;
	import com.info.child.children.MonsterTreeInfo;
	import com.ui.map.MapPanel;
	import com.ui.panel.SceEffMonBoxPanel;
	import com.ui.panel.UnitSelectPanel;
	import com.utils.FileUtil;
	import com.utils.MapUtil;
	
	import fileName.FileName;
	
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.UIComponent;

	/**
	 *地图怪物层 
	 * @author Administrator
	 * 
	 */
	public class MapMonster extends UIComponent{
		
		public static const fileName:String = "_monster";
		private static var _instance:MapMonster;
		private static var _monsterDatafileName:String = "monster.xml";
		
		private  var _saveFileName:String;
		private  var _saveFilePath:String;
		private var _panel:SceEffMonBoxPanel;
		private var _rightPan:UnitSelectPanel;
		private var _initList:Boolean;
		private var _monsterDataXmlList:XMLList;
		private var _treeData:Object;
		private var _monsterList:XML;
		private var _idx:int = -1;
		private var _mcId:String;
		private var _selectMonster:MovieClip;
		private var _monsterMc:MovieClip;
		private var _direction:int = 0;
		private var _pathId:int =-1;
		private var _selectMonsterName:String = "";
		private var _modeXml:XML;//读取的模型的一条当前需要的信息
		private var _wayArr:ArrayCollection;//存储巡逻id
		private var _randomDirFlag:Boolean;
		private var _actionXml:XMLList;
		private var _actionIdx:int;//当前动作的索引
		private var _modeId:int;
		public function MapMonster() {
			_monsterList =  <data/>;
		}
		public static function get instance():MapMonster
		{
			if(!_instance)
				_instance = new MapMonster();
			return _instance;
		}
		public function showPan($pan:SceEffMonBoxPanel,$rightPan:UnitSelectPanel):void
		{
			if(_panel == null)
			{
				_panel = $pan;
				_panel.monsterTreeClickFun = onTreeItemClick;
				_panel.monsterWatSelectFun = onWayItemClick;
				_panel.onMonsterRandomDirClickFun = onRandomDirClick;
				_panel.monsterActionSelectFun = onActionItemClick;
				_rightPan = $rightPan;
				_rightPan.monsterListClickFun = onClicklistItem;
				_rightPan.searchMonsterFun = serchMonster;
				addMonsterLayer();
				_saveFileName = MapPanel.instance.sceneName+"_monster";
			}
			_rightPan.panelType(MirMapEditer.MONSTER);
			_panel.panelType(MirMapEditer.MONSTER);
			readMonsterFile();
			setTreeData();
			setPreMc();
			setPathData();
			if(_modeXml != null)
				setActionData(_modeXml..@actId);
			if(_treeData)
				MapPanel.instance.addModeUI(MirMapEditer.MONSTER);
			uiEvent(false);
		}
		/**
		 * 
		 * 
		 */		
		public function rightListInit():void
		{
			setListData();
			if(_idx != 0)
				_idx = 0;
			_rightPan.setList1SelectItem(_idx);
			onClicklistItem(_idx);
		}
		/**
		 *往地图上放以前操作过的东西  
		 * 
		 */		
		public function setMc($xS:int,$yS:int,$xEnd:int,$yEnd:int):void
		{
			for(var i:* in _treeData)
			{
				if(_treeData[i])
				{
					var d:MonsterTreeInfo = new MonsterTreeInfo();
					d = _treeData[i];
					for(var j:int = 0 ; j < d.xx.length;j++)
					{
						var point:Point = new Point(parseInt(d.xx[j],2),parseInt(d.yy[j],2));
						var ui:UIComponent = this.getChildByName(point.x +"_"+point.y) as UIComponent;
						if(ui)
							continue;
						if(point.x >= $xS && point.x <= $xEnd && point.y >= $yS && point.y <= $yEnd)
						{
							var arr:Array = getModeIdByMonsterId(d.id);
							_idx = arr[1];
							var modeId:int = arr[0];
							_modeId = arr[0];
							_mcId = getMcIdByModeId(modeId);
							_direction = d.direction[j];
							mapClick(point,true);
						}
					}
				}
			}
		}
		/**
		 *添加 特效层 
		 * 
		 */		
		private function addMonsterLayer():void
		{
			this.graphics.beginFill(0xffffff,0);
			this.graphics.lineStyle(1,0x000000);
			this.graphics.moveTo(this.width/2,0);
			this.graphics.lineTo(this.width,this.height/2);
			this.graphics.lineTo(this.width/2,this.height);
			this.graphics.lineTo(0,this.height/2);
			this.graphics.lineTo(this.width/2,0);
			this.graphics.endFill();
			MapPanel.instance.monsterUI = this;
		}
		/**
		 *清理数据 
		 * 
		 */		
		public function clearData():void
		{
			_monsterList =  <data/>;
			if(this != null)
			{
				uiEvent(false);
				while(this.numChildren >0)
					this.removeChildAt(this.numChildren -1);
			}
			if(_treeData != null)
			{
				_treeData = null;
				setTreeData();
			}
			_panel = null;
		}
		/**
		 *读取怪物表的数据 
		 * 
		 */		
		private function readMonsterFile():void
		{
			if(!_initList)
			{
				var ba:ByteArray = FileUtil.readFile(FileName.readFilePath+FileName.readXmlPahtName+_monsterDatafileName);
				ba.position = 0; 
				var xml:XML = new XML(ba.readMultiByte(ba.length,"utf-8"));
				_monsterDataXmlList = xml.elements();
			}
		}
		/**
		 *将怪物表的里数据放到list里显示 
		 * 
		 */		
		public function setListData():void
		{
			if(!_initList)
			{
				_rightPan.setList(_monsterDataXmlList);
				_initList = true;
			}
		}
		/**
		 * 
		 * @param $modeId
		 * 
		 */		
		private function getModeXml($modeId:int):void
		{
			var mode:XMLList = MapScene.instance.modeList;
			for each(var key: * in mode)
			{
				if(key.@id == $modeId)
				{
					_modeXml = key;
					break;
				}
			}
		}
		/**
		 *点击 右边的列表项
		 * @return 
		 * 
		 */		
		public function onClicklistItem($idx:int):void
		{
			_idx = $idx;
			_modeId = _monsterDataXmlList[$idx].@modelId;
			getModeXml(_modeId);
			_mcId = _modeXml.@imgId;
//			_mcId = _monsterDataXmlList[$idx].@imgId;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
			loader.load(new URLRequest(FileName.readFilePath +FileName.monsterResFileName+ _mcId+".swf"));
			function loadComplete(e:Event):void
			{
				_selectMonster = new MovieClip();
				_selectMonster = e.currentTarget.content as MovieClip;
				_direction = 0;
				_pathId = -1;
				_randomDirFlag = false;
				_panel.setRandomDirSelect(false);
				_randomDirFlag = false;
				setActionData(_modeXml..@actId);
				setPreMc();
			}
		}
		private function error(evt:IOErrorEvent):void
		{
			Alert.show(evt.text);
		}
		/**
		 *放预览容器里放预览怪物 
		 * 
		 */		
		private function setPreMc():void
		{
			if(_panel.preGroup.numElements)
				_panel.preGroup.removeElementAt(0);
			if(_selectMonster == null)
				return;
			if(_modeXml..@blend == 1)
				_selectMonster.blendMode = BlendMode.LIGHTEN;
			_selectMonster.gotoAndStop(1);
			_selectMonster.x= 0;
			_selectMonster.y = 0;
			var ui:UIComponent = new UIComponent();
			ui.addChild(_selectMonster);
//			ui.x = 20;
			_panel.preGroup.addElement(ui);
		}
		/**
		 *往树形控件添加显示数据 
		 * 
		 */		
		private function setTreeData():void
		{
			var xml:XML =  <data/>;
			xml.@lable = _saveFileName+"("+getModeNum()+")";
			for(var i:* in _treeData)
			{
				var str:String = "item"+i;
				var x:XML = <{str}/>;
				x.@lable = (_treeData[i] as MonsterTreeInfo).name + "("+(_treeData[i] as MonsterTreeInfo).xx.length+")";
				for(var j:int = 0 ; j < (_treeData[i] as MonsterTreeInfo).xx.length;j++)
				{
					var _xx:XML = <items/>;
					_xx.@lable = 
						(_treeData[i] as MonsterTreeInfo).name+
						"("+(_treeData[i] as MonsterTreeInfo).id+")("+
						(_treeData[i] as MonsterTreeInfo).title+")";
					_xx.@xx = (_treeData[i] as MonsterTreeInfo).xx[j];
					_xx.@yy = (_treeData[i] as MonsterTreeInfo).yy[j];
					x..j= _xx;
				}
				xml..i = x;
			}
			if(_panel != null)
				_panel.setTreeData(xml);
		}
		private function getModeNum():int
		{
			return _monsterList.child("data").length();
		}
		/**
		 *点击树的item 
		 * @param $x
		 * @param $y
		 * 
		 */		
		public function onTreeItemClick($x:int,$y:int):void
		{
			MapPanel.instance.setMapScrollerToCenter(new Point($x,$y));
			setMcSeleted($x.toString()+"_"+$y.toString());
		}
		/**
		 *点击怪物层  
		 * @param $p 格子坐标
		 * 
		 */			
		public function mapClick($p:Point,flag:Boolean = false):void
		{
			if(!flag &&_selectMonster == null)
			{
				Alert.show("亲，请先在右板选择怪物后再种植！");
				return;
			}
			if(!flag && cheakMonsterList($p.x,$p.y)[0])
			{
				setMcSeleted($p.x+"_"+$p.y);
//				Alert.show("亲，此格子已经种植怪物了，请先删除再种植！");
				return;
			}
			var idx:int = _idx;
			
			var direction:int = getDirection();
			var uiPoint:Point = MapUtil.gridToCenter($p);
			var gridP:Point = new Point($p.x,$p.y);
			var px:Number = _modeXml.@px;
			var py:Number =  _modeXml.@py;
			var modeXml:XML = _modeXml;
			var mcId:String =_mcId;
			var modeId:int = _modeId;
			var load:Loader = new Loader();
			load.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
			load.load(new URLRequest(FileName.readFilePath+FileName.monsterResFileName+mcId+".swf"));
			_monsterMc = new MovieClip();
			function loadComplete(e:Event):void
			{
				_monsterMc = e.currentTarget.content as MovieClip;
				_monsterMc.gotoAndStop(1);
				if(modeXml..@blend == 1)
					_monsterMc.blendMode = BlendMode.LIGHTEN;
				getModeXml(modeId);
				setActionData(modeXml..@actId);
				setMcDirection(_monsterMc,direction);
				var ui:UIComponent = new UIComponent();
				ui.addChild(_monsterMc);
				var txt:TextField = new TextField();
				txt.multiline = true;
				txt.autoSize = TextFormatAlign.LEFT;
				txt.text = _monsterDataXmlList[idx].@title+"\n"+_monsterDataXmlList[idx].@name + "["+_monsterDataXmlList[idx].@lv+"级]";
				txt.y = _monsterDataXmlList[idx].@nameMove;
				txt.x = _monsterMc.width/2-(_monsterMc.width/2-txt.width/2);
				txt.name = "_name";
//				txt.mouseEnabled = false;
				_monsterMc.addChild(txt);
				if(direction >4)
				{
					_monsterMc.x = px+_monsterMc.width;
					txt.scaleX=-1;
				}
				else
					_monsterMc.x = px;
				_monsterMc.y = py;
				ui.x = uiPoint.x;
				ui.y = uiPoint.y;
				ui.name = gridP.x.toString()+"_"+gridP.y.toString();
				addChild(ui);
				ui.addChild(MapUtil.drawCircle(4));
//				ui.mouseChildren = false;
//				ui.mouseEnabled = false;
//				ui.addEventListener(MouseEvent.CLICK,onClickMapMonster);
				if(_selectMonsterName != null && _selectMonsterName == ui.name)
					setMcSeleted(_selectMonsterName);
				if(!flag)
				{
					var monster:MonsterInfo = new MonsterInfo();
					monster.monsterId= _monsterDataXmlList[idx].@index;//模型中到地图上 存数据
					monster.pointX = $p.x.toString(2);
					monster.pointY = $p.y.toString(2);
					monster.direction = direction;
					monster.pathId = _pathId;
					_monsterList.appendChild(monster.monsterInfoToXml(monster));
					treeData(monster);
					setTreeData();
				}
			}
		}
		/**
		 * 
		 * @param $monster
		 * 
		 */		
		private function treeData($monster:MonsterInfo):void
		{
			if(!checkTreeMonsterId($monster.monsterId))
			{
				if(_treeData== null)
					_treeData = new Object();
				var data:MonsterTreeInfo = new MonsterTreeInfo();
				data.id = $monster.monsterId;
				var arr:Array = getModeIdByMonsterId(data.id);
				var modeId:int = arr[0];
//				var mcId:int = getMcIdByModeId(modeId);
				data.name = _monsterDataXmlList[arr[1]].@name;
				data.title = _monsterDataXmlList[arr[1]].@title;
				data.xx.push($monster.pointX);
				data.yy.push($monster.pointY);
				data.direction.push($monster.direction);
				_treeData[data.id] = data;
			}
			else
			{
				(_treeData[$monster.monsterId] as MonsterTreeInfo).xx.push($monster.pointX);
				(_treeData[$monster.monsterId] as MonsterTreeInfo).yy.push($monster.pointY);
				(_treeData[$monster.monsterId] as MonsterTreeInfo).direction.push($monster.direction);
			}
		}
		/**
		 * 
		 * @param $id 通过怪物的id得到怪物的序列号
		 * @return 
		 * 
		 */		
		private function getModeIdByMonsterId($id:String):Array
		{
			var modeId:int;
			var index:int;
			var i:int;
			for(i=0;i < _monsterDataXmlList.length();i++)
			{
				if(_monsterDataXmlList[i].@index == $id)
				{
					modeId = _monsterDataXmlList[i].@modelId;
					index = i;
					break;
				}
			}
			return [modeId,index];
		}
		/**
		 * 
		 * @param $idx 通过怪物的模型id 返回怪物的资源的id
		 * @return 
		 * 
		 */		
		private function getMcIdByModeId($modeId:int):String
		{
			getModeXml($modeId);
			var id:String = _modeXml.@imgId;
			return id;
		}
		/**
		 *检查此格子是否已经种植 
		 * @param $x
		 * @param $y
		 * @return 
		 * 
		 */		
		private function cheakMonsterList($x:int,$y:int):Array
		{
			var f:Boolean;//是否已经种植
			var idx:int = -1;//若已经种植 的索引
			var num:int = _monsterList.child("data").length();
			for(var i:int = 0;i < num ;i ++)
			{
				if(_monsterList.child("data")[i].@pointX == $x.toString(2) && _monsterList.child("data")[i].@pointY == $y.toString(2))
				{
					f = true;
					idx = i;
					break;
				}
			}
			return [f,idx];
		}
		/**
		 *检查是否已种植此id的怪 
		 * @param id
		 * @return 
		 * 
		 */		
		private function checkTreeMonsterId(id:String):Boolean
		{
			if(_treeData == null || _treeData.length == 0)
				return false;
			if(id in _treeData)
				return true;
			else return false;
		}
				
		/**
		 *点击怪物层上的怪物  
		 * @param evt
		 * 
		 */		
		private function onClickMapMonster(evt:MouseEvent):void
		{
			if(MapPanel.instance.btnIdx != MirMapEditer.MONSTER)
				return;
			var n:String = (evt.currentTarget as UIComponent).name;
			setMcSeleted(n);
		}
		/**
		 *设置 地图上的怪物为选中状态 
		 * @param $n
		 * 
		 */		
		private function setMcSeleted($n:String):void
		{
			var ui:UIComponent = new UIComponent();
			if(_selectMonsterName != "")
			{
				ui = this.getChildByName(_selectMonsterName) as UIComponent
				if(ui)
					ui.filters = null;
			}
			_selectMonsterName = $n;
			ui = this.getChildByName(_selectMonsterName) as UIComponent;
			if(ui != null)
				ui.filters = [MapUtil.glow];
		}
		/**
		 *delete键 
		 * 
		 */		
		public function deleteClick():void
		{
			if(_selectMonsterName!= null &&_selectMonsterName!="")
				removeMonster(_selectMonsterName);
		}
		/**
		 *删除 monster 
		 * @param $n
		 * 
		 */		
		private function removeMonster($n:String):void
		{
			var idx:int = _selectMonsterName.indexOf("_");
			var xx:int = int(_selectMonsterName.substring(0,idx));
			var yy:int = int(_selectMonsterName.substring(idx+1))
			var ui:UIComponent = new UIComponent();
			ui = this.getChildByName($n) as UIComponent;
			if(ui)
				this.removeChild(ui);
			_selectMonsterName = "";
			deleteSaveData(xx,yy);
			deleteTreeData(xx,yy);
		}
		/**
		 * 
		 * 
		 */		
		private function deleteSaveData($x:int,$y:int):void
		{
			var arr:Array = cheakMonsterList($x,$y);
			if(arr[0] == true)
			{
				delete _monsterList.child("data")[arr[1]];
			}
		}
		/**
		 * 
		 * @param $x
		 * @param $y
		 * 
		 */		
		public function deleteTreeData($x:int,$y:int):void
		{
			for(var key:* in _treeData)
			{
				var data:MonsterTreeInfo = _treeData[key];
				for(var i:int = 0;i<data.xx.length;i++)
				{
					if(data.xx[i] == $x.toString(2) && data.yy[i] == $y.toString(2))
					{
						(_treeData[key] as MonsterTreeInfo).xx.splice(i,1);
						(_treeData[key] as MonsterTreeInfo).yy.splice(i,1);
						break;
					}
				}
				if((_treeData[key] as MonsterTreeInfo).xx == null || (_treeData[key] as MonsterTreeInfo).xx.length == 0)
					delete _treeData[key];
			}
			setTreeData();
		}
		/**
		 *点击寻路路径 
		 * @param $idx
		 * 
		 */		
		private function onWayItemClick($idx:int):void
		{
			if(_wayArr == null && _wayArr.length == 0)
				return;
			_pathId = _wayArr[$idx];
		}
		/**
		 *点击随机方向 
		 * 
		 */		
		private function onRandomDirClick():void
		{
			if(_modeXml.@direction ==0)//无八方向
			{
				Alert.show("此资源没有八方向");
				_panel.setRandomDirSelect(false);
				return;
			}
			if(_randomDirFlag == false)
				_randomDirFlag = true;
			else
				_randomDirFlag = false;
		}
		/**
		 *获得随机的方向 
		 * @return 
		 * 
		 */		
		private function getDirection():int
		{
			var direction:int;
			if(!_randomDirFlag)
				direction = _direction;
			else
			{
				direction = int(Math.random()*7);
				if(direction <0)
					direction = 0;
				if(direction >7)
					direction == 7;
			}
			return direction;
		}
		/**
		 *方向的提醒 
		 * 
		 */		
		private function directionAlert():Boolean
		{
			if(_randomDirFlag == true)
			{
				Alert.show("请取消随机方向后再来操作！");
				return false;
			}
			return true;
		}
		/**
		 *左转按钮 
		 * 
		 */		
		public function leftClick():void
		{
			if(!directionAlert())
				return;
			removeSelectMcEnterFrame();
//			八方向
			//			0 无八方向
			//			1 有八方向
			//			2 三方向
			if(_modeXml.@direction ==0)//无八方向
			{
				Alert.show("此资源没有八方向");
				return;
			}
			else if(_modeXml.@direction ==1)
			{
				_direction --;
				if(_direction == -1)
					_direction = 7;
			}
			else if(_modeXml.@direction ==2)
			{
				_direction --;
				if(_direction == -1)
					_direction = 2;
			}
			else _direction --;
			if(_direction <= -1)
				_direction = 7;
			setMcDirection(_selectMonster,_direction);
			onActionItemClick(_actionIdx);
		}
		/**
		 *右转按钮 
		 * 
		 */		
		public function rightClick():void
		{
			if(!directionAlert())
				return ;
			removeSelectMcEnterFrame();
			if(_modeXml.@direction ==0)//无八方向
			{
				Alert.show("此资源没有八方向");
				return;
			}
			else if(_modeXml.@direction ==1)
			{
				_direction ++;
				if(_direction == 8)
					_direction = 0;
			}
			else if(_modeXml.@direction ==2)
			{
				_direction ++;
				if(_direction == 3)
					_direction = 0;
			}
			else
			_direction ++;
			if(_direction >= 8)
				_direction = 0;
			setMcDirection(_selectMonster,_direction);
			onActionItemClick(_actionIdx);
		}
		/**
		 *控制mc转方向 
		 * @param $mc
		 * 
		 */		
		private function setMcDirection($mc:MovieClip,$dir:int):void
		{
			if($mc == null)
				return;
			var sta:int = _actionXml[_actionIdx]..@startFrame;
			var long:int = _actionXml[_actionIdx]..@preFrame;
			if($dir <5)
			{
				$mc.x= 0;
				if($mc.scaleX==-1)
					$mc.scaleX=-($mc.scaleX);
				$mc.gotoAndStop(sta+long*($dir+1));
				$mc.x= 0;
			}
			else 
			{
				if($dir == 5)
				{
					$mc.gotoAndStop(sta+long*(1+3));
//					$mc.scaleX = -1;
//					$mc.x+=$mc.width;
				}	
				if($dir == 6)
				{
					$mc.gotoAndStop(sta+long*(1+2));
//					$mc.scaleX = -1;
//					$mc.x+=$mc.width;
				}
				if($dir == 7)
				{
					$mc.gotoAndStop(sta+long*(1+1));
//					$mc.scaleX = -1;
//					$mc.x+=$mc.width;
				}
				$mc.scaleX = -1;
				$mc.x=$mc.width;
			}
		}
		/**
		 *设置动作的数据 
		 * @param $id
		 * 
		 */		
		private function setActionData($id:int):void
		{
			if(_actionXml == null)
				_actionXml = new XMLList();
			var xml:XMLList = MapScene.instance.actionFile;
			var i:int = -1;
			var _actionArr:ArrayCollection = new ArrayCollection();
			for each(var key:* in  xml)
			{
				if(key.@id == $id)
				{
					i++;
					_actionXml[i] = key;
					var str:String = key..@name;
					_actionArr.addItem(str);
				}
			}
			_panel.setActionData(_actionArr);
		}
		/**
		 *点击动作的item操作 
		 * 
		 */
		private var _startF:int;
		private var _frameLong:int;
		private function onActionItemClick($idx:int):void
		{
			removeSelectMcEnterFrame();
			_actionIdx = $idx;
			_frameLong = _actionXml[$idx]..@preFrame;
			if(_direction<5)
			{
				_startF = _actionXml[$idx]..@startFrame;
				_startF+=_direction*_frameLong;
			}
			if(_direction==5)
			{
				_selectMonster.scaleX=-1;
				_startF = _actionXml[$idx]..@startFrame;
				_startF+=3*_frameLong;
			}
			if(_direction == 6)
			{
				_selectMonster.scaleX=-1;
				_startF = _actionXml[$idx]..@startFrame;
				_startF+=(2*_frameLong);
			}
			if(_direction == 7)
			{
				_selectMonster.scaleX=-1;
				_startF = _actionXml[$idx]..@startFrame;
				_startF+=(1*_frameLong);
			}
			_selectMonster.frameRate = _actionXml[$idx]..@interval;
			_selectMonster.gotoAndPlay(_startF);
			_selectMonster.addEventListener(Event.ENTER_FRAME,modePlay,false,0,true);
		}
		private function modePlay(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			if(mc.currentFrame >_startF+_frameLong)
				mc.gotoAndPlay(_startF);
		}
		private function removeSelectMcEnterFrame():void
		{
			if(_selectMonster == null || !_actionXml)
				return;
			_selectMonster.removeEventListener(Event.ENTER_FRAME,modePlay);
		}
		/**
		 *设置路径的 数据
		 * 
		 */		
		private function setPathData():void
		{
			var data:Array = MapPatrol.instance.lineArr;
			_wayArr = new ArrayCollection();
			for(var i:int = 0 ;i < data.length;i++)
			{
				_wayArr.addItem("路径"+data[i]);
			}
			_panel.setWaydata(_wayArr);
		}
		/**
		 *鼠标事件 
		 * @param $f
		 * 
		 */		
		public function uiEvent($f:Boolean):void
		{
			this.mouseChildren  =$f;
			this.mouseEnabled = $f;
		}
		/**
		 *查找 
		 * @param $id
		 * 
		 */		
		private function serchMonster($id:int):void
		{
			var idx:int = -1;
			var num:int = _monsterDataXmlList.length();
			for(var i:int = 0 ; i< num;i++)
			{
				if(_monsterDataXmlList[i]..@index == $id)
				{
					idx = i;
					break;
				}
			}
			if(idx != -1 && idx != _idx)
			{
				_idx=idx;
				_rightPan.setList1SelectItem(_idx);
				onClicklistItem(_idx);
			}
			else Alert.show("您找的id：" + $id+"不存在!！！！");
		}
		/**
		 *存数据 
		 * 
		 */		
		public function saveFile():void
		{
			_saveFilePath = FileName.saveFilePath +MapPanel.instance.sceneName+"\\"+FileName.xmlFileName;
			_saveFileName = MapPanel.instance.sceneName+"_monster";
			var num:Number = getModeNum();
			var xml:XML = _monsterList.copy();
//			for(var i:int;i < num;i++)
//			{
//				var xx:int = xml.child("data")[i].@pointX;
//				var yy:int = xml.child("data")[i].@pointY;
//				var _x:String = xx.toString(2);
//				var _y:String = yy.toString(2);
//				xml.child("data")[i].@pointX = _x;
//				xml.child("data")[i].@pointY = _y;
//			}
			FileUtil.saveXmlFile(_saveFilePath,_saveFileName,xml);
		}
		/**
		 *读取的数据 
		 * @param $xml
		 * 
		 */		
		public function set monsterListData($xml:XML):void
		{
			_monsterList = $xml;
			readMonsterFile();
			
			var num:int = _monsterList.child("data").length();
			for(var i:int = 0 ; i < num;i++)
			{
				var monster:MonsterInfo = new MonsterInfo();
				monster.monsterId= _monsterList.child("data")[i].@monsterId;//模型中到地图上 存数据
				monster.pointX = _monsterList.child("data")[i].@pointX;
				monster.pointY = _monsterList.child("data")[i].@pointY
				monster.direction = _monsterList.child("data")[i].@direction;
				monster.pathId = _monsterList.child("data")[i].@pathId;
				treeData(monster);       
			}
		}
	
	}
}