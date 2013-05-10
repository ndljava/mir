package com.ace.gameData.scene {
	import com.ace.astarII.MapInfoModel;
	import com.ace.enum.SceneEnum;

	import flash.utils.ByteArray;


	public class MapInfo extends MapInfoModel {
		public var id:String; //地图id，
		public var name:String; //地图名称
		public var mapW:Number; //地图-宽度
		public var mapH:Number; //地图-高度
		public var tileW:int; //格子-横向数
		public var tileH:int; //格子-竖向数
		public var bmpW:int; //地图块-横向数
		public var bmpH:int; //地图块-竖向数


		public function MapInfo() {
		}

		public function upData(br:ByteArray):void {
			var arr:Array;
			br.position=0;
			this.tileW=br.readInt();
			this.tileH=br.readInt();

			this.bmpW=Math.ceil((this.tileW * SceneEnum.TILE_WIDTH) / SceneEnum.BMPTILE_WIDTH);
			this.bmpH=Math.ceil((this.tileH * SceneEnum.TILE_HEIGHT) / SceneEnum.BMPTILE_HEIGHT);

			this.mapW=SceneEnum.TILE_WIDTH * this.tileW;
			this.mapH=SceneEnum.TILE_HEIGHT * this.tileH;


			this._tiles=new Vector.<Array>;
			for (var i:int=0; i < this.tileW; i++) {
				arr=[];
				for (var j:int=0; j < this.tileH; j++) {
					arr.push(br.readByte());
				}
				this._tiles.push(arr);
			}
		}

	}
}