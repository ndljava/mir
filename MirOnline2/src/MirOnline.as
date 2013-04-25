package {
	import com.ace.game.manager.DragManager;
	import com.ace.game.manager.TableManager;
	import com.ace.manager.CursorManager;
	import com.ace.manager.KeysManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ResizeManager;
	import com.ace.tools.FPS;
	import com.ace.ui.img.child.Image;
	import com.ace.utils.DebugUtil;
	import com.leyou.config.Core;
	import com.leyou.config.GameConfig;
	import com.leyou.data.bag.GridOrder;
	import com.leyou.manager.MenuManager;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.backpack.child.ItemTip;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;


	[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='32')]

	public class MirOnline extends Sprite {

		private var img:Image;
		
		public function MirOnline() {
			GameConfig.setup();
			KeysManager.setup(this.stage);
			DragManager.getInstance().setup(this.stage,new GridOrder());
			ResizeManager.getInstance().setup(this.stage);
 
			DebugUtil.addCopyright(this,"版本0.2.4");

			_enswf__edcn; 
			LibManager.startLoad(this, this.start);
			stage.frameRate=32;
		}
  
		private function start():void {
			//this.test();
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

			img=new Image("ui/login/icon_f_daos.png");
			this.addChild(img);
			
			this.stage.addEventListener(MouseEvent.CLICK,onClick);

		}
		
		private function onClick(e:MouseEvent):void
		{
			this.removeChild(img);
			this.addChild(img);
			img.updateBmp("ui/login/icon_m_daos.png");
			trace("ddd",img.bitmapData);
		}
		
	}
}
