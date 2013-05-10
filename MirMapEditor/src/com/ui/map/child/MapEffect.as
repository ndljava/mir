package com.ui.map.child {
	import com.info.child.EffectInfo;
	import com.info.child.children.EffectTreeInfo;
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
	import flash.ui.Keyboard;
	import flash.ui.KeyboardType;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;

	/**
	 *地图特效层 
	 * @author Administrator
	 * 
	 */	
	public class MapEffect extends UIComponent{
		private static var _effDatafileName:String = "pnfTable.xml";
		private static var _instance:MapEffect;
		private var _panel:SceEffMonBoxPanel;
		private var _rightPan:UnitSelectPanel;
		private var _initFile:Boolean;
		private var _effDataXmlList:XMLList;
		private var _idx:int = -1;//list表里的当前选项
		private var _mcId:String;
		private var _selectMode:MovieClip;
		private var _treeData:Object;//为了树形式显示而存
		private var _effectList:XML;//已经种植的特效数据'
		private var _effectMc:MovieClip;
		private var _clickEffectName:String;
		private var _saveFilePath:String;
		private var _saveFileName:String;
		public static var fileName:String ="_effect";
		public function MapEffect() {
			_effectList = <data/>;
			_clickEffectName = "";
		}
		public static function get instance():MapEffect{
			if(!_instance)
				_instance = new MapEffect();
			return _instance;
		}
		/**
		 *清理数据 
		 * 
		 */		
		public function clearData():void
		{
			_effectList = <data/>;
			_clickEffectName = "";
			if(this != null)
			{
				uiEvent(false);
				while(this.numChildren >0)
					this.removeChildAt(this.numChildren-1);
			}
			_treeData = null;
			setTreeData();
			_panel = null;
			_idx = -1;
//			addEffectLayer();
		}
		public function showPan($pan:SceEffMonBoxPanel,$right:UnitSelectPanel):void
		{
			if(_panel == null)
			{
				_panel = $pan;
				_rightPan = $right;
				_rightPan.effectListClickFun = onClickListItem;
				_rightPan.searchEffectFun = searchEffect;
				_panel.effectTreeClickFun = treeItemClick;
				addEffectLayer();
			}
			_panel.panelType(MirMapEditer.EFFECT);
			_rightPan.panelType(MirMapEditer.EFFECT);
			readEffectFile();
			setTreeData();
			setPreMc();
			if(_treeData)
				MapPanel.instance.addModeUI(MirMapEditer.EFFECT);
			uiEvent(false);
		}
		/**
		 *右板的list 加载完成 
		 * 
		 */		
		public function rightListInit():void
		{
			setListData();
			if(_idx == -1)
				_idx = 0;
			_rightPan.setList3SelectItem(_idx);
			onClickListItem(_idx);
		}
		/**
		 *将读取的数据显示在面板上 
		 * 
		 */		
		public function setMc($xS:int,$yS:int,$xEnd:int,$yEnd:int):void
		{
			for(var i:* in _treeData)
			{
				if(_treeData[i])
				{
					var d:EffectTreeInfo = new EffectTreeInfo();
					d = _treeData[i];
					for(var j:int = 0 ; j < d.xx.length;j++)
					{
						var point:Point = new Point(parseInt(d.xx[j],2),parseInt(d.yy[j],2));
						var ui:UIComponent = this.getChildByName(point.x+"_"+point.y) as UIComponent;
						if(ui)
							continue;
						if(point.x >= $xS && point.x <= $xEnd && point.y >= $yS && point.y <= $yEnd)
						{
							_idx = getIdxById(d.id);
//							var modeIdx:int = 
							_mcId = _effDataXmlList[_idx].@imgId;
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
		private function addEffectLayer():void
		{
			this.graphics.beginFill(0xffffff,0);
			this.graphics.lineStyle(1,0x000000);
			this.graphics.moveTo(this.width/2,0);
			this.graphics.lineTo(this.width,this.height/2);
			this.graphics.lineTo(this.width/2,this.height);
			this.graphics.lineTo(0,this.height/2);
			this.graphics.lineTo(this.width/2,0);
			this.graphics.endFill();
			MapPanel.instance.effectUI = this;
		}
		/**
		 *读取特效表 
		 * 
		 */		
		private function readEffectFile():void
		{
			if(!_initFile)
			{
				var ba:ByteArray = FileUtil.readFile(FileName.readFilePath+FileName.readXmlPahtName+_effDatafileName);
				ba.position = 0; 
				var xml:XML = new XML(ba.readMultiByte(ba.length,"utf-8"));
				_effDataXmlList = xml.elements();
			}
		}
		/**
		 *将特效表的数据显示到右面板 
		 * 
		 */		
		public function setListData():void
		{
			if(!_initFile)
			{
				_rightPan.setList(_effDataXmlList);
				_initFile = true;
			}
		}
		/**
		 *点击特效表里的某一项 
		 * 
		 */		
		private function onClickListItem(idx:int):void
		{
			_idx = idx;
			_mcId = _effDataXmlList[idx].@imgId;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
			loader.load(new URLRequest(FileName.readFilePath +FileName.effectResFileName+_mcId+".swf"));
			function loadComplete(e:Event):void
			{
				_selectMode = new MovieClip();
				_selectMode = e.currentTarget.content as MovieClip;
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
			if(_panel.preGroup.numElements)
				_panel.preGroup.removeElementAt(0);
			var blend:int = _effDataXmlList[_idx].@blend;
			if(blend == 1)
				_selectMode.blendMode =BlendMode.LIGHTEN;
			_selectMode.x = 10;
			var ui:UIComponent = new UIComponent();
			ui.addChild(_selectMode);
			ui.x = 10
			_panel.preGroup.addElement(ui);
		}
		/**
		 *点击地图 
		 * 
		 */		
		public function mapClick(point:Point,flag:Boolean = false):void
		{
			if(!flag &&_selectMode == null)
				return;
			var gridP:Point = point;
			if(!flag &&cheakEffectList(point.x,point.y)[0])
			{
				setMcSeleted(point.x+"_"+point.y);
				return;
			}
			var mcId:String = _mcId;
			var idx:int = _idx;
			var uiPoint:Point = MapUtil.gridToCenter(gridP);
			var px:Number = _effDataXmlList[idx].@px;
			var py:Number =  _effDataXmlList[idx].@py;
			var load:Loader = new Loader();
			load.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
			load.load(new URLRequest(FileName.readFilePath+FileName.effectResFileName+mcId+".swf"));
			_effectMc = new MovieClip();
			
			function loadComplete(e:Event):void
			{
				_effectMc = e.currentTarget.content as MovieClip;
				var ui:UIComponent = new UIComponent();
				_effectMc.x = px;
				_effectMc.y = py;
				var bend:int = _effDataXmlList[idx].@blend;
				var blend:int = _effDataXmlList[idx].@blend;
				if(blend == 1)
					_effectMc.blendMode =BlendMode.LIGHTEN;
				ui.addChild(_effectMc);
				ui.x = uiPoint.x;
				ui.y = uiPoint.y;
				ui.name = gridP.x+"_"+gridP.y;
				ui.addChild(MapUtil.drawCircle(4));
				addChild(ui);
//				ui.mouseChildren = false;
//				ui.mouseEnabled =false;
//				ui.addEventListener(MouseEvent.CLICK,onClickEffect);
				if(_clickEffectName != null && _clickEffectName == ui.name)
					setMcSeleted(_clickEffectName);
				if(!flag)
				{
					var eff:EffectInfo = new EffectInfo();
					eff.effectId= _effDataXmlList[idx].@id;//模型中到地图上 存数据
					eff.pointX = gridP.x.toString(2);
					eff.pointY = gridP.y.toString(2);
					_effectList.appendChild(eff.effectInfoToXml(eff));
					treeData(eff);
					setTreeData();
				}
			}
		}
		private function error(evt:IOErrorEvent):void
		{
			Alert.show(evt.text);
		}
		/**
		 * 
		 * @param $eff
		 * 
		 */		
		private function treeData($eff:EffectInfo):void
		{
			if(!checkTreeEffectId($eff.effectId))
			{
				if(_treeData== null)
					_treeData = new Object();
				var data:EffectTreeInfo = new EffectTreeInfo();
				data.id = $eff.effectId;
				var idx:int = getIdxById(data.id);
				data.name = _effDataXmlList[idx].@name;
				data.xx.push($eff.pointX);
				data.yy.push($eff.pointY);
				_treeData[data.id] = data;
			}
			else
			{
				(_treeData[$eff.effectId] as EffectTreeInfo).xx.push($eff.pointX);
				(_treeData[$eff.effectId] as EffectTreeInfo).yy.push($eff.pointY);
			}
		}
		/**
		 * 
		 * @param $id
		 * @return 
		 * 
		 */		
		private function getIdxById($id:String):int
		{
			var idx:int;
			for(var i:int =0;i < _effDataXmlList.length();i++)
			{
				if(_effDataXmlList[i].@id == $id)
				{
					idx = i;
					break;
				}
			}
			return idx;
		}
		/**
		 *检查此格子是否已经种植特效 
		 * @param $x
		 * @return 
		 * 
		 */		
		private function cheakEffectList($x:int,$y:int):Array
		{
			var f:Boolean;//是否已经种植
			var idx:int = -1;//若已经种植 的索引
			var num:int = _effectList.child("data").length();
			for(var i:int = 0;i < num ;i ++)
			{
				if(_effectList.child("data")[i].@pointX == $x.toString(2) && _effectList.child("data")[i].@pointY == $y.toString(2))
				{
					f = true;
					idx = i;
					break;
				}
			}
			return [f,idx];
		}
		/**
		 *检查 
		 * @param id
		 * @return 
		 * 
		 */		
		private function checkTreeEffectId(id:String):Boolean
		{
			if(_treeData == null || _treeData.length == 0)
				return false;
			if(id in _treeData)
				return true;
			else return false;
		}
		/**
		 *显示树的数据 
		 * 
		 */		
		private function setTreeData():void
		{
			var xml:XML =  <data/>;
			xml.@lable = MapPanel.instance.sceneName+"("+getModeNum()+")";
			for(var i:* in _treeData)
			{
				var str:String = "item"+i;
				var x:XML = <{str}/>;
				x.@lable = (_treeData[i] as EffectTreeInfo).name + "("+(_treeData[i] as EffectTreeInfo).xx.length+")";
				for(var j:int = 0 ; j < (_treeData[i] as EffectTreeInfo).xx.length;j++)
				{
					var _xx:XML = <items/>;
					_xx.@lable = (_treeData[i] as EffectTreeInfo).name+"("+(_treeData[i] as EffectTreeInfo).id+")";
					_xx.@xx = (_treeData[i] as EffectTreeInfo).xx[j];
					_xx.@yy = (_treeData[i] as EffectTreeInfo).yy[j];
					x..j= _xx;
				}
				xml..i = x;
			}
			if(_panel != null)
				_panel.setTreeData(xml);
		}
		/**
		 *返回已种植的特效的数量 
		 * @return 
		 * 
		 */		
		private function getModeNum():int
		{
			return _effectList.child("data").length();
		}
		/**
		 *tree点击 
		 * @param $x
		 * @param $y
		 * 
		 */		
		public function treeItemClick($x:int,$y:int):void
		{
			setMcSeleted($x+"_"+$y);
			MapPanel.instance.setMapScrollerToCenter(new Point($x,$y));
		}
									  
		/**
		 *点击种植到地图上的特效 
		 * @param e
		 * 
		 */		
		private function onClickEffect(e:MouseEvent):void
		{
			if(MapPanel.instance.btnIdx != MirMapEditer.EFFECT)
				return;
			var n:String = (e.currentTarget as UIComponent).name;
			setMcSeleted(n);
			e.stopPropagation();
		}
		/**
		 *设置map上的mc为选中状态 
		 * @param $n 名字
		 * 
		 */		
		private function setMcSeleted($n:String):void
		{
			var ui:UIComponent = new UIComponent();
			if(_clickEffectName != "")
			{
				ui = this.getChildByName(_clickEffectName) as UIComponent
				if(ui)
					ui.filters = null;
			}
			_clickEffectName = $n;
			ui = this.getChildByName(_clickEffectName) as UIComponent;
			if(ui != null)
				ui.filters = [MapUtil.glow];
		}
		/**
		 *delete键 
		 * 
		 */		
		public function deleteClick():void
		{
			if(_clickEffectName!= null && _clickEffectName!="")
				removeEffect(_clickEffectName);
		}
		/**
		 *在地图上删除特效 
		 * @param name
		 * 
		 */		
		private function removeEffect(name:String):void
		{
			var idx:int = _clickEffectName.indexOf("_");
			var xx:int = int(_clickEffectName.substring(0,idx));
			var yy:int = int(_clickEffectName.substring(idx+1))
			var ui:UIComponent = new UIComponent();
			ui = this.getChildByName(name) as UIComponent;
			if(ui)
				this.removeChild(ui);
			_clickEffectName = "";
			deleteSaveData(xx,yy);
			deleteTreeData(xx,yy);
		}
		/**
		 *更新显示树的数据 
		 * @param $x
		 * @param $y
		 * 
		 */		
		private function deleteTreeData($x:int,$y:int):void
		{
			for(var key:* in _treeData)
			{
				var data:EffectTreeInfo = _treeData[key];
				for(var i:int = 0;i<data.xx.length;i++)
				{
					if(data.xx[i] == $x.toString(2) && data.yy[i] == $y.toString(2))
					{
						(_treeData[key] as EffectTreeInfo).xx.splice(i,1);
						(_treeData[key] as EffectTreeInfo).yy.splice(i,1);
						break;
					}
				}
				if((_treeData[key] as EffectTreeInfo).xx == null || (_treeData[key] as EffectTreeInfo).xx.length == 0)
				{
					delete _treeData[key];
				}
			}
			setTreeData();
		}
		/**
		 *更新要存储的文件的数据 
		 * @param $x
		 * @param $y
		 * 
		 */		
		private function deleteSaveData($x:int,$y:int):void
		{
			var arr:Array = cheakEffectList($x,$y);
			if(arr[0] == true)
			{
				delete _effectList.child("data")[arr[1]];
			}
		}
		/**
		 * 
		 * @param $f
		 * 
		 */		
		public function uiEvent($f:Boolean):void
		{
			this.mouseChildren = $f;
			this.mouseEnabled = $f;
		}
		/**
		 *特效查找 
		 * @param $id
		 * 
		 */		
		private function searchEffect($id:int):void
		{
			var idx:int = -1;
			var num:int = _effDataXmlList.length();
			for(var i:int = 0 ; i < num;i++)
			{
				if($id == _effDataXmlList[i]..@id)
				{
					idx = i;
					break;
				}
			}
			if(idx != -1 && idx != _idx)
			{
				_idx = idx;
				_rightPan.setList3SelectItem(_idx);
				onClickListItem(_idx);
			}
			else Alert.show("id: "+$id+" 查找失败");
		}
		/**
		 *保存文件 
		 * 
		 */		
		public function saveFileData():void
		{
			_saveFilePath = FileName.saveFilePath +MapPanel.instance.sceneName+"\\"+FileName.xmlFileName;
			_saveFileName = MapPanel.instance.sceneName+"_effect";
			var num:Number = getModeNum();
			var xml:XML = _effectList.copy();
			FileUtil.saveXmlFile(_saveFilePath,_saveFileName,xml);
		}
		/**
		 *设置读取的数据 
		 * @param $xml
		 * 
		 */		
		public function set effectListData($xml:XML):void
		{
			_effectList =$xml;
			readEffectFile();
			var eff:EffectInfo = new EffectInfo();
			var num:int = _effectList.child("data").length();
			for(var i:int = 0 ; i < num;i++)
			{
				eff.effectId = _effectList.child("data")[i].@effectId;
				eff.pointX = _effectList.child("data")[i].@pointX;
				eff.pointY = _effectList.child("data")[i].@pointY;
				treeData(eff);       
			}
		}
	}
}