package com.ui.map.child
{
	import com.info.child.PatrolInfo;
	import com.info.child.children.PatrolTreeInfo;
	import com.ui.map.MapPanel;
	import com.ui.panel.PatrolPanel;
	import com.utils.FileUtil;
	import com.utils.MapUtil;
	
	import fileName.FileName;
	
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.net.dns.AAAARecord;
	import flash.utils.flash_proxy;
	
	import mx.charts.PieChart;
	import mx.controls.Alert;
	import mx.core.UIComponent;

	/**
	 *npc巡逻 
	 * @author Administrator
	 * 
	 */	
	public class MapPatrol
	{
		public static const fileName:String= "_line";
		private static var _instance:MapPatrol;
		private var _panel:PatrolPanel;
		private var _main:UIComponent;
		private var _creatPathFlag:Boolean;
		private var _creatPointFlag:Boolean;
		private var _pathIdx:int = -1;
		private var _patrolInfor:Array;
		private var _pointIdx:int = -1;
		private var _clickFlag:int = -1;
		private var _pathIdFlag:int = -1;
		private var _selectPoint:Point;
		private var _lineXml:XML;
		public function MapPatrol(){
		}
		public static function get instance():MapPatrol{
			if(!_instance)
				_instance = new MapPatrol();
			return _instance;
		}
		/**
		 *清楚数据 
		 * 
		 */		
		public function clearData():void
		{
			if(_main != null)
			{
				while(_main.numChildren > 0)
				{
					_main.removeChildAt(_main.numChildren -1);
				}
			}
			_creatPathFlag = false;
			_creatPointFlag = false;
			_pathIdx = -1;
			if(_patrolInfor != null && _patrolInfor.length >0)
				_patrolInfor.length = 0;
			if(_panel != null)
			{
				setPathData(_pathIdx);
				setPointData();
				_panel.setPathCreatbtnSta(true);
				_panel = null;
			}
			_pointIdx=-1;
			_clickFlag=-1;
			_pathIdFlag=-1;
			_selectPoint = null;
//			addLineLayer();
		}
		/**
		 *显示巡逻信息 
		 * @param $panel
		 * 
		 */		
		public function showPan($panel:PatrolPanel):void
		{
			if(_panel == null)
			{
				_panel = $panel;
				_panel.pathListItemClickFun = pathListItemClick;
				_panel.pointListItemClickFun = pointListItemClick;
				addLineLayer();
			}
			if(_lineXml != null && _lineXml.child("data").length()>0)
			{
//				setPatrol();
				setPathData(_pathIdx);
				setPointData();
				_lineXml = null;
			}
		}
		/**
		 *添加巡逻层 
		 * 
		 */		
		private function addLineLayer():void
		{
			var w:Number = MapPanel.instance.mapWidth;
			var h:Number = MapPanel.instance.mapHeight;
			var gridType:int = MapPanel.instance.gridType;
			_main = new UIComponent();
			_main.graphics.beginFill(0xfffff,0);
			if(gridType == 0)
			{
				_main.graphics.lineStyle(1,0xffffff);
				_main.graphics.moveTo(w/2,0);
				_main.graphics.lineTo(w,w/4);
				_main.graphics.lineTo(w/2,w/2);
				_main.graphics.lineTo(0,w/4);
				_main.graphics.lineTo(w/2,0);
			}
			else if(gridType == 1)
			{
				_main.graphics.drawRect(0,0,w,h);
			}
			_main.graphics.endFill();
			_main.name = "patrolUI";
			MapPanel.instance.patrolUI = _main;
			_main.mouseChildren =false;
			_main.mouseEnabled =false;
		}
		/**
		 * 添加路径的数据
		 * 
		 */		
		public function btnPathCreatClick():void{
			if(_patrolInfor == null)
				_patrolInfor = new Array();
			_pathIdFlag++;
			var infor:PatrolTreeInfo = new PatrolTreeInfo();
			infor.idd= _pathIdFlag;
			infor.xx = new Array();
			infor.yy = new Array();
			_patrolInfor.push(infor);
			setPathData(_patrolInfor.length-1);
			pathListItemClick(_patrolInfor.length-1);
		}
		private function setPathData($idx:int):void
		{
			_panel.setList1Data(_patrolInfor);
			_panel.setPathListSelect($idx);
		}
		/**
		 *点击点创建按钮 
		 * 
		 */		
		public function btnPointCreatClick():void {
			if(_pathIdx < 0)
				return;
			_creatPointFlag =true;
			_panel.setPathCreatbtnSta(false);
		}
		/**
		 *点击结束按钮 
		 * 
		 */		
		public function btnPointEndClick():void{
			_creatPointFlag = false;
			_panel.setPathCreatbtnSta(true);
		}
		/**
		 *首尾循环按钮点击 
		 * 
		 */		
		public function endCycleClick():void
		{
			if(_creatPointFlag == false)
			{
				if(_pathIdx >=0 && (_patrolInfor[_pathIdx] as PatrolTreeInfo).pathFlag == 0)
				{
					(_patrolInfor[_pathIdx] as PatrolTreeInfo).pathFlag = 1;
					addLine(_pathIdx);
//					Alert.show("路径"+(_patrolInfor[_pathIdx] as PatrolTreeInfo).id +"首尾循环设置成功");
				}
				else if(_pathIdx >=0 && (_patrolInfor[_pathIdx] as PatrolTreeInfo).pathFlag == 1)
				{
					(_patrolInfor[_pathIdx] as PatrolTreeInfo).pathFlag = 0;
					addLine(_pathIdx);
//					Alert.show("路径"+(_patrolInfor[_pathIdx] as PatrolTreeInfo).id +"原路返回设置成功");
				}
			}
		}
		/**
		 *路径list点击 
		 * @param $idx
		 * 
		 */		
		private function pathListItemClick($idx:int):void{
			_clickFlag = 0;
			deleteLine(_pathIdx.toString());
			_pathIdx = $idx;
			addLine(_pathIdx);
			setPointData();
//			_creatPointFlag = false;
			
		}
		/**
		 *点的list点击 
		 * @param $idx
		 * 
		 */		
		private function pointListItemClick($idx:int):void
		{
			_clickFlag = 1;
			_pointIdx = $idx;
			var p:Point = new Point((_patrolInfor[_pathIdx] as PatrolTreeInfo).xx[$idx],(_patrolInfor[_pathIdx] as PatrolTreeInfo).yy[$idx]);
			addSelectPoint(p);
			MapPanel.instance.setMapScrollerToCenter(p);
		}
		/**
		 *设置点的选中 
		 * @param $p
		 * 
		 */		
		private function addSelectPoint($p:Point):void
		{
			deleteSelectPoint();
			_selectPoint = $p;
			var shap:Shape = new Shape();
			shap.graphics.beginFill(0x000000);
			shap.graphics.lineStyle(1,0x000000);
			var p:Point = MapUtil.gridToCenter($p);
			shap.graphics.drawCircle(p.x,p.y,2);
			shap.graphics.endFill();
			shap.name = _selectPoint.x+"!"+_selectPoint.y;
			_main.addChild(shap);
		}
		/**
		 * 删除已经选择的点
		 * 
		 */		
		private function deleteSelectPoint():void
		{
			if(_selectPoint == null)
				return;
			var shap:Shape = _main.getChildByName(_selectPoint.x+"!"+_selectPoint.y) as Shape;
			if(shap)
			{
				_main.removeChild(shap);
				_selectPoint = null;
			}
		}
		/**
		 *点击巡逻层 
		 * @param $grid
		 * 
		 */		
		public function mapClick($grid:Point):void
		{
			if( _pathIdx == -1)
			{
				return;
			}
			if(!_creatPointFlag)
			{
//				Alert.show("请点击结束按钮后再创建！！！！")
				return;
			}
			if(checkPoint($grid))
				return;
			addPoint($grid);
			addLine(_pathIdx);
		}
		/**
		 *检查点击的点 
		 * @param $p
		 * @return 
		 * 
		 */		
		private function checkPoint($p:Point):Boolean
		{
			var f:Boolean = false;
			if(_patrolInfor)
			{
				var inf:PatrolTreeInfo = _patrolInfor[_pathIdx];
				if(inf&&inf.xx.length >=1)
				{
					if(inf.xx[inf.xx.length-1] == $p.x && inf.yy[inf.yy.length-1] == $p.y)
						f = true;
				}
			}
			return f;
		}
		/**
		 *添加点的数据 
		 * @param $grid
		 * 
		 */		
		private function addPoint($grid:Point):void
		{
			(_patrolInfor[_pathIdx] as PatrolTreeInfo).xx.push($grid.x);
			(_patrolInfor[_pathIdx] as PatrolTreeInfo).yy.push($grid.y);
			setPathData(_pathIdx);
			setPointData();
		}
		/**
		 *设置点的数据 
		 * 
		 */		
		private function setPointData():void
		{
			deleteSelectPoint();
			if(_pathIdx == -1)
				_panel.setPointData(new PatrolTreeInfo());
			else
				_panel.setPointData(_patrolInfor[_pathIdx] as PatrolTreeInfo);
			_pointIdx = -1;
			_panel.setPointListSelect(_pointIdx);
		}
		/**
		 *添加路径的线 
		 * 
		 */		
		private function addLine(idx:int):void
		{
			var info:PatrolTreeInfo = _patrolInfor[idx] as PatrolTreeInfo;
			var _shap:Shape = new Shape();
			deleteLine(idx.toString());
			_shap.graphics.lineStyle(1,0xff0000);
			_shap.name = idx.toString();
			var p:Point;
			for(var i:int = 0 ; i< info.xx.length;i++)
			{
				p = new Point(info.xx[i],info.yy[i]);
				p = MapUtil.gridToCenter(p);
				if(i == 0)
					_shap.graphics.moveTo(p.x,p.y);
				else 
					_shap.graphics.lineTo(p.x,p.y);
			}
			if(info.pathFlag)
			{
				p = new Point(info.xx[0],info.yy[0]);
				p = MapUtil.gridToCenter(p);
				_shap.graphics.lineTo(p.x,p.y);
			}
			this._main.addChild(_shap);
		}
		/**
		 *删除路径的线 
		 * @param $name
		 * 
		 */		
		private function deleteLine($name:String):void
		{
			var _shap:Shape = _main.getChildByName($name) as Shape;
			if(_shap)
				_main.removeChild(_shap);
		}
		/**
		 *点击delete键 
		 * 
		 */		
		public function deleteClick():void
		{
			if(_clickFlag == 0)//删除路径
			{
				if(_pathIdx == -1)
					return;
				deleltePath();
			}
			else if(_clickFlag == 1)//删除点
			{
				if(_pointIdx == -1 && _patrolInfor.length == 1)
				{
					deleltePath();
					return;
				}
				if(_pointIdx == -1 || _pathIdx == -1)
					return;
				deleltePoint();
			}
		}
		/**
		 *删除路径 
		 * 
		 */		
		private function deleltePath():void
		{
			deleteLine(_pathIdx.toString());
			_patrolInfor.splice(_pathIdx,1);
			_pathIdx = -1;
			setPathData(_pathIdx);
			setPointData();
		}
		/**
		 *删除点 
		 * 
		 */		
		private function deleltePoint():void
		{
			(_patrolInfor[_pathIdx] as PatrolTreeInfo).xx.splice(_pointIdx,1);
			(_patrolInfor[_pathIdx] as PatrolTreeInfo).yy.splice(_pointIdx,1);
			setPathData(_pathIdx);
			setPointData();
			addLine(_pathIdx);
		}
		/**
		 *返回所有已创建的路径 
		 * @return 
		 * 
		 */		
		public function get lineArr():Array
		{
			var arr:Array = new Array();
			if(_patrolInfor == null)
				return arr;
			for(var i:int = 0 ; i < _patrolInfor.length;i++)
			{
				arr.push((_patrolInfor[i] as PatrolTreeInfo).idd);
			}
			return arr;
		}
		/**
		 *隐藏 
		 * 
		 */		
		public function hidePatrol():void
		{
			if(_main)
				_main.visible = false;
		}
		/**
		 *保存文件 
		 * 
		 */		
		public function saveFile():void
		{
			var saveFileName:String = MapPanel.instance.sceneName+"_line";
			var savefilePath:String = FileName.saveFilePath +MapPanel.instance.sceneName+"\\"+FileName.xmlFileName;
			if(_patrolInfor == null)
				_patrolInfor = new Array();
			var xml:XML =  <data/>;
			for(var i:int = 0 ; i < _patrolInfor.length;i++)
			{
				var d:PatrolTreeInfo = _patrolInfor[i];
				var str:String = "data";
				var x:XML = <{str}/>;
				x.@id = d.idd;
				x.@pathFlag = d.pathFlag;
				var p:String = new String();
				for(var j:int = 0 ; j < d.xx.length;j++)
				{
					var point:String = new String();
					if(j == d.xx.length-1)
						str = d.xx[j].toString(2)+"_"+d.yy[j].toString(2);
					else 
						str = d.xx[j].toString(2)+"_"+d.yy[j].toString(2)+",";
					p+=str;
				}
				x.@point = p;
				xml..i = x;
			}
			FileUtil.saveXmlFile(savefilePath,saveFileName,xml);
		}
		/**
		 *读取数据 
		 * @param $xml
		 * 
		 */		
		public function set lineDataXml($xml:XML):void
		{
			_lineXml = $xml;
			_patrolInfor = new Array();
			var num:int = _lineXml.child("data").length();
			for(var i:int = 0 ; i< num;i++)
			{
				var d:PatrolTreeInfo = new PatrolTreeInfo();
				d.idd = _lineXml.child("data")[i].@id;
				d.pathFlag = _lineXml.child("data")[i].@pathFlag;
				var line:String = _lineXml.child("data")[i].@point;
				var p:Array = new Array();
				p = line.split(",");
				for(var j:int = 0;j < p.length;j++)
				{
					var idx:int= (p[j] as String).indexOf("_");
					var xx:int = parseInt((p[j] as String).substring(0,idx),2);
					var yy:int = parseInt((p[j] as String).substring(idx+1),2);
					d.xx.push(xx);
					d.yy.push(yy);
				}
				_patrolInfor.push(d);
				if(d.idd > _pathIdFlag)
					_pathIdFlag = d.idd;
			}
		}
		/**
		 *设置读取的数据
		 * 
		 */		
//		private function setPatrol():void
//		{
//			for(var i:int = 0 ; i < _patrolInfor.length;i++)
//			{
//				addLine(i);
//			}
//		}
	}
}