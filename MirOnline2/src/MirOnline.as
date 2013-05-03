package {
	import com.ace.game.manager.DragManager;
	import com.ace.game.manager.TableManager;
	import com.ace.manager.CursorManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.FPS;
	import com.ace.utils.DebugUtil;
	import com.leyou.config.Core;
	import com.leyou.config.GameConfig;
	import com.leyou.data.bag.GridOrder;
	import com.leyou.manager.MenuManager;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.backpack.child.ItemTip;
	
	import flash.display.Sprite;


	[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='32')]

	public class MirOnline extends Sprite {

		public function MirOnline() {
			GameConfig.setup();
			DragManager.getInstance().setup(this.stage, new GridOrder());
			DebugUtil.addCopyright(this, "版本0.2.4");

			_enswf__edcn;
			LibManager.startLoad(this, this.start);
			stage.frameRate=32;
		}

		private function start():void {
//			this.test();
//			return;
			TableManager.getInstance();
			UIManager.getInstance();
			!Core.bugTest && ItemTip.getInstance().setup(this.stage);
			MenuManager.getInstance().setup(LayerManager.getInstance().menuLayer);
			//调试
			this.addChild(new FPS());
			CursorManager.getInstance().resetGameCursor();
		}

		//====================================================test================================================
		private function test():void {

		}

	}
}
