package com.leyou.game.skill.bullets {
	import com.ace.game.manager.TableManager;
	import com.ace.game.scene.part.LivingModel;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.table.TActInfo;
	import com.ace.gameData.table.TActsInfo;
	import com.ace.gameData.table.TBulletInfo;
	import com.ace.gameData.table.TPnfInfo;
	import com.ace.manager.LibManager;
	import com.ace.utils.DebugUtil;
	import com.leyou.config.Core;
	import com.leyou.enum.SkillEnum;
	import com.leyou.manager.UIManager;

	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class BulletManager {

		private static var instance:BulletManager;

		public function BulletManager() {
		}

		public static function getInstance():BulletManager {
			if (!instance)
				instance=new BulletManager();
			return instance;
		}


		private var passSkill:Array=[6, 20, 22, 19, 29, 15, 14, 16, 28, 36, 43]; //抗拒火环|火墙|地狱雷光|瞬间转移|魔法盾|困魔咒|隐身术

		//释放者，接受者、鼠标格子、子弹类型、特效
		public function addBullet(playerId:int, targetId:int, tx:int, ty:int, type:int, bulletId:int):void {
			if (this.passSkill.indexOf(bulletId) != -1)
				return;
			var sp:LivingModel=UIManager.getInstance().mirScene.getPlayer(playerId); //发送者
			var rp:LivingModel=UIManager.getInstance().mirScene.getPlayer(targetId); //接受者
			var info:TBulletInfo=TableManager.getInstance().getBulletInfo(bulletId);
			var bullet:BulletModel;
			var pt:Point=SceneUtil.tileToScreen(tx, ty);
//			DebugUtil.addFlag(pt.x,pt.y,UIManager.getInstance().mirScene);
			switch (info.type) {
				case SkillEnum.TYPE_STATIC:
					bullet=new BulleStatic();
					break;
				case SkillEnum.TYPE_LINE:
					bullet=new BulletFly();
					break;
				case SkillEnum.TYPE_TARGET:
					bullet=new BulletTarget(pt);
					break;
			}

			bullet.creat(targetId, bulletId); //创建初始化

			//设置坐标
			if (info.follow == SkillEnum.FOLLOW_MOUSE) {
				bullet.x=pt.x + info.px;
				bullet.y=pt.y + info.py;
			} else if (info.follow == SkillEnum.FOLLOW_SENDER) {
				bullet.x=sp.x + info.px;
				bullet.y=sp.y + info.py;
			} else if (info.follow == SkillEnum.FOLLOW_RECEIVER) {
				if (!rp)
					return;
				bullet.x=rp.x + info.px;
				bullet.y=rp.y + info.py;
			}

			//添加到容器
			if (info.carrier == SkillEnum.CARRIER_SCENE) {
				UIManager.getInstance().mirScene.addChild(bullet);
			} else if (info.carrier == SkillEnum.CARRIER_SENDER) {
				sp.addChild(bullet);
			} else if (info.carrier == SkillEnum.CARRIER_RECEIVER) {
				bullet.x=bullet.y=0;
				rp.addChild(bullet);
			}

			//是否旋转
			if (info.isRotation) {
				if (rp && bullet is BulletFly) {
					pt.y-=50;
				}
				bullet.rotation=Math.atan2(pt.y - bullet.y, pt.x - bullet.x) * 180 / Math.PI;
			}
		}

		private var dic:Dictionary=new Dictionary();

		public function addBuff(id:int, type:int, tx:int, ty:int):void {
			type+=300;
			var buff:BulletBuff=new BulletBuff();
			buff.x=SceneUtil.tileXToScreenX(tx);
			buff.y=SceneUtil.tileYToScreenY(ty);
			buff.creat(0, type);
			UIManager.getInstance().mirScene.addChildAt(buff, 1);
			this.dic[id]=buff;
		}

		//添加倒刺之类的特效
		public function addxxx(type:int, tx:int, ty:int):void {
			trace("添加效果类型：" + type);
		}

		public function delBuff(id:int):void {
			var buff:BulletBuff=this.dic[id];
			buff.die();
		}

		public function xxx():void {

		}


	}
}