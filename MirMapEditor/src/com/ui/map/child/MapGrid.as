package com.ui.map.child {
	import com.ui.map.MapPanel;
	import com.utils.MapUtil;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	import spark.events.GridEvent;
	import spark.primitives.Graphic;

	/**
	 *地图格子层
	 * @author Administrator
	 *
	 */
	public class MapGrid extends UIComponent{
		public static const GRIDE_SHOW_ONE:int = 1;
		public static const GRIDE_HIDE:int = 0;
		public static const GRIDE_SHOW_FOUR:int = 2;
		public static const GRIDE_SHOW_NINE:int = 3;
		public static const GRIDE_SHOW_SIX:int = 4;
		
		private var mapUI:UIComponent;
		private var _gridWidth:Number;
		private var _gridHeight:Number;
		public var l:Number;
		public var rowX:int;
		public var rowY:int;
		public var lie:int;
		private var lineXUIArr:Array;//存 横线
		private var lineYUIArr:Array;//存竖线
		public var ww:Number;//内菱形的宽
		public var hh:Number;//内菱形的高
		public function MapGrid(ui:UIComponent) {
			mapUI = ui;
			lineXUIArr = new Array();
			lineYUIArr = new Array();	
		}
		/*画格子*/
		public function drawGrid(w:int,h:int,flag:int):void
		{
			_gridWidth = w;
			_gridHeight = h;
			var mapL:Number;
			var startP:Point;
			var endP:Point;
			var endP1:Point;
			if(flag == MapPanel.outside_diamond||flag == MapPanel.inside_diamond)//内棱形
			{
				if(flag == MapPanel.outside_diamond)
				{
					l = Math.sqrt(Math.pow(1/2*this._gridWidth,2)+Math.pow(1/2*this._gridHeight,2));
					mapL = Math.sqrt(Math.pow(1/2*mapUI.width,2)+Math.pow(1/2*mapUI.height,2));
					rowX = Math.ceil(mapL/l);
					rowY = rowX;
					startP= new Point(0,mapUI.height*1/2);
					endP = new Point(mapUI.width/2,mapUI.height);
					endP1 = new Point(mapUI.width/2,0);
				}
				if(flag == MapPanel.inside_diamond)
				{
					l = Math.sqrt(Math.pow(1/2*this._gridWidth,2)+Math.pow(1/2*this._gridHeight,2));
					var hhh:Number = mapUI.height;
					if(mapUI.width/2>hhh)
					{
						ww = mapUI.width;
						hh = mapUI.width/2;
					}
					else
					{
						ww = hhh*2;
						hh = hhh;
					}
					mapL = Math.sqrt(Math.pow(1/2*ww,2)+Math.pow(1/2*hh,2));
					rowX = Math.ceil(mapL/l);
					rowY = rowX;
					startP= new Point(0,hh*1/2);
					endP = new Point(ww/2,hh);
					endP1 = new Point(ww/2,0);
				}
				for(var j:int = 0; j <=rowX;j++)
				{
					var _startP:Point = new Point();
					_startP.x = startP.x +j*1/2*_gridWidth;
					_startP.y = startP.y - j*1/2*_gridHeight;
					var _endP:Point = new Point();
					_endP.x = endP.x +j*1/2*_gridWidth;
					_endP.y = endP.y - j*1/2*_gridHeight;
					lineXUIArr[j] = drawLine(_startP,_endP);
					
					_startP.x = startP.x + j*1/2*_gridWidth;
					_startP.y = startP.y + j*1/2*_gridHeight;
					_endP.x = endP1.x + j*1/2*_gridWidth;
					_endP.y = endP1.y + j*1/2*_gridHeight;
					lineYUIArr[j] = drawLine(_startP,_endP);
				}
				
			}
			else if(flag == MapPanel.rect)//方形
			{
				rowX = Math.ceil(mapUI.width/_gridWidth);
				var i:int;
				var sP:Point = new Point(); 
				var eP:Point = new Point();
				for(i= 0 ; i < rowX;i++)
				{
					sP.x = i*_gridWidth;
					sP.y = 0;
					eP.x = i*_gridWidth;
					eP.y = mapUI.height;
					lineXUIArr[i] = drawLine(sP,eP);
				}
				rowY = Math.ceil(mapUI.height/_gridHeight);
				for(i = 0 ; i < rowY;i++)
				{
					sP.x = 0;
					sP.y = i*_gridHeight;
					eP.x =mapUI.width;
					eP.y = i*_gridHeight;
					lineYUIArr[i] = drawLine(sP,eP);
				}
			}
			this.mouseChildren = false;
			this.mouseEnabled = false;
			MapPanel.instance.gridUI = this;
		}
		/**
		 *是否显示格子 
		 * @param fla ,
		 * 
		 */		
		public function showLine(flag:int = 1):void
		{
			if(flag == 0)
				this.visible = false;
			else
			{
				this.visible = true;
				var i:int;
				if(MapPanel.instance.gridType == MapPanel.outside_diamond || MapPanel.inside_diamond)
				{
					for(i;i < lineXUIArr.length;i++)
					{
						if((i)%flag == 0)
						{
							(lineXUIArr[i] as UIComponent).visible = true;
							(lineYUIArr[i] as UIComponent).visible = true;
						}
						else 
						{
							(lineXUIArr[i] as UIComponent).visible = false;
							(lineYUIArr[i] as UIComponent).visible = false;
						}
					}
				}
				else if(MapPanel.instance.gridType == MapPanel.rect)
				{
					for(i = 0;i < lineXUIArr.length;i++)
					{
						if((i)%flag == 0)
							(lineXUIArr[i] as UIComponent).visible = true;
						else 
							(lineXUIArr[i] as UIComponent).visible = false;
					}
					for(i = 0 ; i<lineYUIArr.length;i++)
					{
						if((i)%flag == 0)
							(lineYUIArr[i] as UIComponent).visible = true;
						else 
							(lineYUIArr[i] as UIComponent).visible = false;
					}
				}
			}
		}

		/**
		 *画斜线 
		 * @param startP
		 * @param endP
		 * 
		 */		
		
		private function drawLine(startP:Point,endP:Point):UIComponent
		{
			var shap:Shape = new Shape();
			shap.graphics.lineStyle(.1,0xffffff);
			shap.graphics.moveTo(startP.x,startP.y);
			shap.graphics.lineTo(endP.x,endP.y);
			var ui:UIComponent = new UIComponent();
			ui.addChild(shap);
			this.addChild(ui);
			return ui;
		}
	}
}