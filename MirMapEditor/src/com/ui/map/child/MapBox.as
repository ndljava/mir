package com.ui.map.child
{
	import com.info.child.BoxInfo;
	import com.info.child.children.BoxTreeInfo;
	import com.ui.map.MapPanel;
	import com.ui.panel.SceEffMonBoxPanel;
	import com.ui.panel.UnitSelectPanel;
	import com.utils.FileUtil;
	import com.utils.MapUtil;
	
	import fileName.FileName;
	
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.UIComponent;

	/**
	 *宝箱 
	 * @author Administrator
	 * 
	 */	
	public class MapBox extends UIComponent
	{
		public static const fileName:String = "_box";
		
		private static var _instance:MapBox;
		private static var _boxDatafileName:String = "box.xml";
		
		private var _saveFileName:String;
		private var _saveFilePath:String;
		private var _panel:SceEffMonBoxPanel;
		private var _rightPan:UnitSelectPanel;
		private var _initFile:Boolean;
		private var _boxDataList:XMLList;
		private var _treeData:Object;
		private var _idx:int;
		private var _mcId:String;
		private var _modeXml:XML;
		private var _selectBox:MovieClip;
		private var _actionXml:XMLList;
		private var _boxMc:MovieClip;
		private var _boxList:XML;
		private var _selectBoxName:String;
		private var _modeId:int;
		private var _blend:int;
		public function MapBox(){
			_boxList = <data/>;
			_selectBoxName = "";
		}
		public static function get instance():MapBox
		{
			if(_instance == null)
				_instance = new MapBox();
			return _instance;
		}
		public function showPan($pan:SceEffMonBoxPanel,$rightP:UnitSelectPanel):void
		{
			if(_panel == null)
			{
				_panel = $pan;
				_panel.boxActionSelectFun = onActionItemClick;
				_panel.boxTreeClickFun = onTreeItemClick;
				_rightPan = $rightP;
				_rightPan.searchBoxFun = searchBox;
				addBoxLayer();
				_rightPan.boxListClickFun = onListItemClick;
				_saveFileName = MapPanel.instance.sceneName +"_box";
			}
			_rightPan.panelType(MirMapEditer.BOX);
			_panel.panelType(MirMapEditer.BOX);
			readBoxFile();
			setTreeData();
			setPreMc();
			if(_modeXml != null)
				setActionData(_modeXml..@actId);
			if(_treeData)
				MapPanel.instance.addModeUI(MirMapEditer.BOX);
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
			_rightPan.setList2SelectItem(_idx);
			onListItemClick(_idx);
		}
		/**
		 * 读取的数据显示在面板上
		 * 
		 */		
		public function setMc($xS:int,$yS:int,$xEnd:int,$yEnd:int):void
		{
			for(var i:* in _treeData)
			{
				if(_treeData[i])
				{
					var d:BoxTreeInfo = new BoxTreeInfo();
					d = _treeData[i];
					for(var j:int = 0 ; j < d.xx.length;j++)
					{
						var point:Point = new Point(parseInt(d.xx[j],2),parseInt(d.yy[j],2));
						var ui:UIComponent = this.getChildByName(point.x+"_"+point.y) as UIComponent;
						if(ui)
							continue;
						if(point.x >= $xS && point.x <= $xEnd && point.y >= $yS && point.y <= $yEnd)
						{
							_idx = getBoxIdxByBoxId(d.id);
							getModeXmlByModeId(_boxDataList[_idx].@modelId);
							_mcId = _modeXml.@imgId;
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
		private function addBoxLayer():void
		{
			this.graphics.beginFill(0xffffff,0);
			this.graphics.lineStyle(1,0x000000);
			this.graphics.moveTo(this.width/2,0);
			this.graphics.lineTo(this.width,this.height/2);
			this.graphics.lineTo(this.width/2,this.height);
			this.graphics.lineTo(0,this.height/2);
			this.graphics.lineTo(this.width/2,0);
			this.graphics.endFill();
			MapPanel.instance.boxUI = this;
		}
		/**
		 *清理数据 
		 * 
		 */		
		public function clearData():void
		{
			_boxList = <data/>;
			_selectBoxName = "";
			if(this != null)
			{
				uiEvent(false);
				while(this.numChildren >0)
				{
					this.removeChildAt(this.numChildren -1);
				}
			}
			_treeData = null;
			setTreeData();
			_panel = null;
		}
		/**
		 *读取宝箱表 
		 * 
		 */		
		private function readBoxFile():void
		{
			if(!_initFile)
			{
				var ba:ByteArray = FileUtil.readFile(FileName.readFilePath+FileName.readXmlPahtName+_boxDatafileName);
				ba.position = 0; 
				var xml:XML = new XML(ba.readMultiByte(ba.length,"utf-8"));
				_boxDataList = xml.elements();
			}
		}
		/**
		 *往右板里放数据 
		 * 
		 */		
		public function setListData():void
		{
			if(!_initFile)
			{
				_rightPan.setList(_boxDataList);
				_initFile = true;
			}
		}
		/**
		 *点击list的数据项 
		 * @param $idx
		 * 
		 */		
		public function onListItemClick($idx:int):void
		{
			_idx = $idx;
			_modeId = _boxDataList[$idx].@modelId;
			getModeXmlByModeId(_modeId);
			_mcId = _modeXml.@imgId;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
			loader.load(new URLRequest(FileName.readFilePath +FileName.boxResFileName+ _mcId+".swf"));
			
			function loadComplete(e:Event):void
			{
				_selectBox = new MovieClip();
				_selectBox = e.currentTarget.content as MovieClip;
				_selectBox.gotoAndStop(1);
				setActionData(_modeXml..@actId);
				_blend = _modeXml..@blend;
				setPreMc();
			}
		}
		private function error(evt:IOErrorEvent):void
		{
			Alert.show(evt.text);
		}
		/**
		 * 
		 * @param $modeId
		 * 
		 */		
		private function getModeXmlByModeId($modeId:int):void
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
		 *往tree 目录里放数据 
		 * 
		 */		
		private function setTreeData():void
		{
			if(_treeData == null)
				_treeData = new Object();
			var xml:XML =  <data/>;
			xml.@lable = _saveFileName+"("+getBoxNum()+")";
			for(var i:* in _treeData)
			{
				var str:String = "item"+i;
				var x:XML = <{str}/>;
				x.@lable = (_treeData[i] as BoxTreeInfo).name + "("+(_treeData[i] as BoxTreeInfo).xx.length+")";
				for(var j:int = 0 ; j < (_treeData[i] as BoxTreeInfo).xx.length;j++)
				{
					var _xx:XML = <items/>;
					_xx.@lable = (_treeData[i] as BoxTreeInfo).name + "("+(_treeData[i] as BoxTreeInfo).id+")";
					_xx.@xx = (_treeData[i] as BoxTreeInfo).xx[j];
					_xx.@yy = (_treeData[i] as BoxTreeInfo).yy[j];
					x..j= _xx;
				}
				xml..i = x;
			}
			if(_panel != null)
				_panel.setTreeData(xml);
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		private function getBoxNum():int
		{
			return _boxList.child("data").length()
		}
		/**
		 *点击tree 项 
		 * @param $x
		 * @param $y
		 * 
		 */		
		public function onTreeItemClick($x:int,$y:int):void
		{
			setMcSeleted($x.toString()+"_"+$y.toString());
			MapPanel.instance.setMapScrollerToCenter(new Point($x,$y));
		}
		/**
		 *设置预览 
		 * 
		 */		
		private function setPreMc():void
		{
			if(_panel.preGroup.numElements)
				_panel.preGroup.removeElementAt(0);
			if(_selectBox == null)
				return;
			if(_blend == 1)
				_selectBox.blendMode = BlendMode.LIGHTEN;
			_selectBox.gotoAndStop(1);
//			_selectBox.x = 10;
			var ui:UIComponent = new UIComponent();
			ui.addChild(_selectBox);
//			ui.x = 10
			_panel.preGroup.addElement(ui);
		}
		/**
		 *放动作的数据 
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
		 *动作点击 
		 */		
		private var _startF:int;
		private var _frameLong:int;
		private function onActionItemClick($idx:int):void
		{
			if(_selectBox == null || !_actionXml)
				return;
			_selectBox.removeEventListener(Event.ENTER_FRAME,modePlay);
			var idx:int = $idx;
			_startF = _actionXml[$idx]..@startFrame;
			_frameLong = _actionXml[$idx]..@preFrame;
			_selectBox.frameRate = _actionXml[$idx]..@interval
			_selectBox.addEventListener(Event.ENTER_FRAME,modePlay,false,0,true);
			_selectBox.gotoAndPlay(_startF);
			function modePlay(e:Event):void
			{
				var mc:MovieClip = e.currentTarget as MovieClip;
				if(mc.currentFrame >_startF+_frameLong)
					mc.gotoAndPlay(_startF);
			}
		}
		/**
		 *点击宝箱层 
		 * @param $p
		 * 
		 */			
		public function mapClick($p:Point,flag:Boolean = false):void
		{
			if(!flag &&_selectBox == null)
			{
				Alert.show("亲，请先在右板选择宝箱后再种植！");
				return;
			}
			if(!flag&&cheakBoxList($p.x,$p.y)[0])
			{
				setMcSeleted($p.x+"_"+$p.y);
//				Alert.show("亲，此格子已经种植怪物了，请先删除再种植！");
				return;
			}
			var idx:int = _idx;
			var uiPoint:Point = MapUtil.gridToCenter($p);
			var px:Number = _modeXml.@px;
			var py:Number = _modeXml.@py;
			var blend:int = _modeXml.@blend;
			var load:Loader = new Loader();
			load.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
			load.load(new URLRequest(FileName.readFilePath+FileName.boxResFileName+_mcId+".swf"));
			_boxMc = new MovieClip();
			function loadComplete(e:Event):void
			{
				_boxMc = e.currentTarget.content as MovieClip;
				_boxMc.gotoAndStop(1);
				if(blend == 1)
					_boxMc.blendMode = BlendMode.LIGHTEN;
				var txt:TextField = new TextField();
				txt.autoSize = TextFormatAlign.LEFT;
				txt.text = _boxDataList[idx].@name ;
				txt.y = _boxDataList[idx].@nameMove;
				txt.x = _boxMc.width/2-(_boxMc.width/2-txt.width/2);
				txt.mouseEnabled = false;
				_boxMc.addChild(txt);
				var ui:UIComponent = new UIComponent();
				_boxMc.x = px;
				_boxMc.y = py;
				ui.addChild(_boxMc);
				ui.x = uiPoint.x;
				ui.y = uiPoint.y;
				ui.name = $p.x.toString()+"_"+$p.y.toString();
				addChild(ui);
				ui.addChild(MapUtil.drawCircle(4));
				ui.mouseChildren = false;
				ui.mouseEnabled = false;
//				ui.addEventListener(MouseEvent.CLICK,onClickMapBox);
				if(_selectBoxName != null && _selectBoxName == ui.name)
					setMcSeleted(_selectBoxName);
				if(!flag)
				{
					var box:BoxInfo = new BoxInfo();
					box.boxId = _boxDataList[idx].@id;//模型中到地图上 存数据
					box.pointX = $p.x.toString(2);
					box.pointY = $p.y.toString(2);
					_boxList.appendChild(box.boxInfoToXml(box));
					treeData(box)
					setTreeData();
				}
			}
		}
		/**
		 *更新tree中的数据
		 * @param $box
		 * 
		 */		
		private function treeData($box:BoxInfo):void
		{
			if(!checkTreeBoxId($box.boxId))
			{
				if(_treeData== null)
					_treeData = new Object();
				var data:BoxTreeInfo = new BoxTreeInfo();
				data.id = $box.boxId;
				var boxIdx:int = getBoxIdxByBoxId(data.id);
				data.name = _boxDataList[boxIdx].@name;
				data.xx.push($box.pointX);
				data.yy.push($box.pointY);
				_treeData[data.id] = data;
			}
			else
			{
				(_treeData[$box.boxId] as BoxTreeInfo).xx.push($box.pointX);
				(_treeData[$box.boxId] as BoxTreeInfo).yy.push($box.pointY);
			}
		}
		/**
		 * 
		 * @param $id
		 * @return 
		 * 
		 */		
		private function getBoxIdxByBoxId($id:String):int
		{
			var idx:int;
			var num:int = _boxDataList.length();
			for(var i:int = 0 ; i < num;i++)
			{
				if(_boxDataList[i].@id == $id)
				{
					idx = i;
					break;
				}	
			}
			return idx;
		}
		/**
		 * 
		 * @param $x
		 * @param $y
		 * @return 
		 * 
		 */		
		private function cheakBoxList($x:int,$y:int):Array
		{
			var f:Boolean;//是否已经种植
			var idx:int = -1;//若已经种植 的索引
			var num:int = _boxList.child("data").length();
			for(var i:int = 0;i < num ;i ++)
			{
				if(_boxList.child("data")[i].@pointX == $x.toString(2) && _boxList.child("data")[i].@pointY == $y.toString(2))
				{
					f = true;
					idx = i;
					break;
				}
			}
			return [f,idx];
		}
		/**
		 * 
		 * @param $id
		 * @return 
		 * 
		 */		
		private function checkTreeBoxId($id:String):Boolean
		{
			if(_treeData == null)
				return false;
			else if($id in _treeData)
				return true;
			else return false;
		}
		/**
		 *点击地图上的宝箱
		 * @param evt
		 * 
		 */		
		private function onClickMapBox(evt:MouseEvent):void
		{
			if(MapPanel.instance.btnIdx != MirMapEditer.BOX)
				return;
			var n:String = (evt.currentTarget as UIComponent).name;
			setMcSeleted(n);
			evt.stopPropagation();
		}
		/**
		 *设置选中 
		 * @param $n
		 * 
		 */		
		private function setMcSeleted($n:String):void
		{
			var ui:UIComponent = new UIComponent();
			if(_selectBoxName != "")
			{
				ui = this.getChildByName(_selectBoxName) as UIComponent
				if(ui)
					ui.filters = null;
			}
			_selectBoxName = $n;
			ui = this.getChildByName(_selectBoxName) as UIComponent;
			if(ui != null)
				ui.filters = [MapUtil.glow];
		}
		/**
		 *delete键 
		 * 
		 */		
		public function deleteClick():void
		{
			if(_selectBoxName!= null && _selectBoxName!="")
				removeBox(_selectBoxName);
		}
		/**
		 *去掉 
		 * @param $n
		 * 
		 */		
		private function removeBox($n:String):void
		{
			var idx:int = _selectBoxName.indexOf("_");
			var xx:int = int(_selectBoxName.substring(0,idx));
			var yy:int = int(_selectBoxName.substring(idx+1))
			var ui:UIComponent = new UIComponent();
			ui = this.getChildByName($n) as UIComponent;
			this.removeChild(ui);
			_selectBoxName = "";
			deleteSaveData(xx,yy);
			deleteTreeData(xx,yy);
		}
		/**
		 *更新数据 
		 * @param $x
		 * @param $y
		 * 
		 */		
		private function deleteSaveData($x:int,$y:int):void
		{
			var arr:Array = cheakBoxList($x,$y);
			if(arr[0] == true)
			{
				delete _boxList.child("data")[arr[1]];
			}
		}
		/**
		 * 
		 * @param $x
		 * @param $y
		 * 
		 */		
		private function deleteTreeData($x:int,$y:int):void
		{
			for(var key:* in _treeData)
			{
				var data:BoxTreeInfo = _treeData[key];
				for(var i:int = 0;i<data.xx.length;i++)
				{
					if(data.xx[i] == $x.toString(2) && data.yy[i] == $y.toString(2))
					{
						(_treeData[key] as BoxTreeInfo).xx.splice(i,1);
						(_treeData[key] as BoxTreeInfo).yy.splice(i,1);
						break;
					}
				}
				if((_treeData[key] as BoxTreeInfo).xx == null || (_treeData[key] as BoxTreeInfo).xx.length == 0)
				{
					delete _treeData[key];
				}
			}
			setTreeData();
		}
		public function uiEvent($f:Boolean):void
		{
			this.mouseChildren = $f;
			this.mouseEnabled = $f;
		}
		/**
		 *查找 宝箱 
		 * @param $id
		 * 
		 */		
		private function searchBox($id:int):void
		{
			var idx:int = -1;
			var num:int = _boxDataList.length();
			for(var i:int = 0 ; i < num;i++)
			{
				if($id == _boxDataList[i]..@id)
				{
					idx = i;
					break;
				}
			}
			if(idx!= -1&& _idx!=idx)
			{
				_idx = idx;
				_rightPan.setList2SelectItem(_idx);
				onListItemClick(_idx);
			}
			else Alert.show("id:"+$id+" 查找失败！！！");
		}
		/**
		 *存数据 
		 * 
		 */		
		public function saveFile():void
		{
			_saveFilePath = FileName.saveFilePath +MapPanel.instance.sceneName+"\\"+FileName.xmlFileName;
			_saveFileName = MapPanel.instance.sceneName+"_box";
			FileUtil.saveXmlFile(_saveFilePath,_saveFileName,_boxList);
		}
		/**
		 *读取的数据 
		 * @param $xml
		 * 
		 */		
		public function set boxDataXml($xml:XML):void
		{
			_boxList = $xml;
			readBoxFile();
			var num:int = _boxList.child("data").length();
			for(var i:int = 0 ; i < num;i++)
			{
				var box:BoxInfo = new BoxInfo();
				box.boxId= _boxList.child("data")[i].@boxId;//模型中到地图上 存数据
				box.pointX = _boxList.child("data")[i].@pointX;
				box.pointY = _boxList.child("data")[i].@pointY
				treeData(box);       
			}
		}						
	}
}