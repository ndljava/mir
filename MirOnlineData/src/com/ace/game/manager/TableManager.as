package com.ace.game.manager {
	import com.ace.gameData.table.TActInfo;
	import com.ace.gameData.table.TActsInfo;
	import com.ace.gameData.table.TBulletInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.gameData.table.TMapInfo;
	import com.ace.gameData.table.TMonSpeciesInfo;
	import com.ace.gameData.table.TPnfInfo;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	
	
	//单例类
	public class TableManager {
		private static var INSTANCE:TableManager;
		
		private var pnfDic:Object;
		private var skillDic:Object;
		private var bulletDic:Object;
		private var actDic:Object;
		private var livingDic:Object;
		private var speciesDic:Object;
		private var itemDic:Object;
		private var mapDic:Object;
		
		public function TableManager() {
			this.init();
		}
		
		public static function getInstance():TableManager {
			if (!INSTANCE)
				INSTANCE=new TableManager();
			
			return INSTANCE;
		}
		
		private function init():void {
			this.initMcConfig();
		}
		
		
		private function initMcConfig():void {
			this.pnfDic={};
			this.skillDic={};
			this.bulletDic={};
			this.actDic={};
			this.livingDic={};
			this.speciesDic={};
			this.itemDic={};
			this.mapDic={};
			
			var info:XML;
			var render:XML;
			//pnf动画
			info=LibManager.getInstance().getXML("config/table/pnfTable.xml");
			for each (render in info.children()) {
				if (this.pnfDic[render.@id] && TPnfInfo(this.pnfDic[render.@id]).actId != render.@actId) {
					trace("存在不同步内容：" + render.@id);
				}
				this.pnfDic[render.@id]=new TPnfInfo(render);
			}
			
			//技能
			info=LibManager.getInstance().getXML("config/table/skillTable.xml");
			for each (render in info.children()) {
				this.skillDic[render.@id]=new TSkillInfo(render);
			}
			
			//子弹
			info=LibManager.getInstance().getXML("config/table/bulletTable.xml");
			for each (render in info.children()) {
				this.bulletDic[render.@id]=new TBulletInfo(render);
			}
			
			//动作
			info=LibManager.getInstance().getXML("config/table/actTable.xml");
			for each (render in info.children()) {
				this.actDic[render.@id]=new TActsInfo(render);
			}
			
			//living
			info=LibManager.getInstance().getXML("config/table/livingTable.xml");
			for each (render in info.children()) {
				this.livingDic[render.@name]=new TLivingInfo(render);
			}
			
			//怪物种类
			info=LibManager.getInstance().getXML("config/table/monSpeciesTable.xml");
			for each (render in info.children()) {
				this.speciesDic[render.@species]=new TMonSpeciesInfo(render);
			}
			
			//道具表格
			info=LibManager.getInstance().getXML("config/table/itemTable.xml");
			for each (render in info.children()) {
				this.itemDic[render.@id]=new TItemInfo(render);
			}
			
			//道具表格
			info=LibManager.getInstance().getXML("config/table/mapTable.xml");
			for each (render in info.children()) {
				this.mapDic[render.@id]=new TMapInfo(render);
			}
			
			trace("配置解析over");
		}
		
		
		//=====================================获取===================================================================
		
		//获取动作组信息
		public function getActsInfo(actId:int):TActsInfo {
			return this.actDic[actId];
		}
		
		//获取动作信息
		private function getActInfo(actId:int, actName:String="defaultAct"):TActInfo {
			return this.getActsInfo(actId).actInfo(actName);
		}
		
		//获取pnf信息
		public function getPnfInfo(id:int):TPnfInfo {
			//			print("所用动作id："+PnfInfo(this.pnfDic[id]).actId);
			return this.pnfDic[id];
		}
		
		//获取pnf组信息
		public function getPnfActsInfo(pnfId:int):TActsInfo {
			return this.getActsInfo(this.getPnfInfo(pnfId).actId);
		}
		
		//获取pnf的指定动作信息
		public function getPnfActInfo(pnfId:int, actName:String="defaultAct"):TActInfo {
			return this.getActInfo(this.getPnfInfo(pnfId).actId, actName);
		}
		
		//获取技能信息
		public function getSkillInfo(id:int):TSkillInfo {
			return this.skillDic[id];
		}
		
		public function getSkillInfos(profession:int):Vector.<TSkillInfo> {
			var skills:Vector.<TSkillInfo>=new Vector.<TSkillInfo>;
			for(var key:* in this.skillDic){
				if((this.skillDic[key] as TSkillInfo).job==profession)
					skills.push(this.skillDic[key]);
			}
			return skills;
		}
		
		//获取子弹信息
		public function getBulletInfo(id:int):TBulletInfo {
			return this.bulletDic[id];
		}
		
		//获取精灵信息
		public function getLivingInfo(id:String):TLivingInfo {
			return this.livingDic[id] as TLivingInfo;
		}
		
		//获取怪物类型信息
		public function getSeciesInfo(id:int):TMonSpeciesInfo {
			return this.speciesDic[id] as TMonSpeciesInfo;
		}
		
		public function getSeciesInfoAct(id:int, actName:String):int {
			if (this.speciesDic[id]) {
				return TMonSpeciesInfo(this.speciesDic[id]).actPnf(actName);
			}
			return -1;
		}
		
		public function getItemInfo(id:int):TItemInfo {
			return this.itemDic[id];
		}
		
		public function getItemByName(name:String):TItemInfo {
			for each (var info:TItemInfo in this.itemDic) {
				if (name == info.name)
					return info;
			}
			return null;
		}
		
		public function getMapInfo(id:String):TMapInfo {
			return this.mapDic[id];
		}
	}
}