package com.leyou.ui {
	import com.ace.enum.FontEnum;
	import com.ace.manager.CursorManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.movie.SwfBmpMovie;
	import com.ace.tools.ByteMovieClip;
	import com.ace.tools.NTSC;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.LinkButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.button.event.ButtonEvent;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.ui.window.children.AlertWindow;
	import com.ace.ui.window.children.ConfirmInputWindow;
	import com.ace.ui.window.children.ConfirmWindow;
	import com.ace.utils.LoadUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;

	public class UiTester extends AutoWindow {

		private var mybtn:NormalButton;
		private var alertBtn:NormalButton;
		private var okBtn:LinkButton;
		private var inputBtn:NormalButton;
		private var input:TextInput;
		private var originalRbtn:RadioButton;
		private var custonRbtn:RadioButton;
		private var playBgmCbox:CheckBox;
		private var mc:SwfBmpMovie;

		//combobox  arr.push({str: childData[i], val: i});
		public function UiTester():void {
			super(LibManager.getInstance().getXML("config/ui/testUI.xml"));
			this.show();
			this.allowDrag=true;
			this.init();
		}

		//加载到舞台上时
		override protected function initModel():void {
			super.initModel();
			if (!LibManager.getInstance().chkData("lib/modelUI/test.uif"))
				return;

			var mf:ByteMovieClip=new ByteMovieClip(LibManager.getInstance().getBinary("lib/modelUI/test.uif"));
			this.addToPane(mf);
		}

		private function init():void {
			//			return;
			//嵌入式字体
			var lab:Label=new Label("123aa", LibManager.getInstance().getEmbedFormat(FontEnum.YUANYOU), TextFormatAlign.LEFT, true);
			lab.x=488;
			lab.y=318;
			this.addToPane(lab);

			//嵌入式字体--按钮
			var btn:NormalButton=new NormalButton("1225", 90, 22, LibManager.getInstance().getEmbedFormat(FontEnum.YUANYOU), true);
			btn.x=488;
			btn.y=lab.y + lab.height + 20;
			btn.name="embedFontBtn";
			this.addToPane(btn);
			btn.addEventListener(MouseEvent.CLICK, onCLick);




			//播放BGM声音
			SoundManager.getInstance().playMusic("sound/jd.mp3", 999);


			this.mybtn=this.getUIbyID("mybtn") as NormalButton;
			this.alertBtn=this.getUIbyID("alertBtn") as NormalButton;
			this.okBtn=this.getUIbyID("okBtn") as LinkButton;
			this.inputBtn=this.getUIbyID("inputBtn") as NormalButton;
			this.input=this.getUIbyID("myInput") as TextInput;
			this.originalRbtn=this.getUIbyID("originalRbtn") as RadioButton;
			this.custonRbtn=this.getUIbyID("custonRbtn") as RadioButton;
			this.playBgmCbox=this.getUIbyID("playBgmCbox") as CheckBox;


			this.mybtn.addEventFn(MouseEvent.CLICK, onCLick);
			this.alertBtn.addEventListener(MouseEvent.CLICK, onCLick);
			this.okBtn.addEventListener(MouseEvent.CLICK, onCLick);
			this.inputBtn.addEventListener(MouseEvent.CLICK, onCLick);
			this.playBgmCbox.addEventListener(MouseEvent.CLICK, onCLick);
			this.originalRbtn.addEventListener(ButtonEvent.Switch_Change, onCLick);

			LoadUtil.testSol();
		}

		private function onCLick(evt:Event):void {
			switch (evt.target.name) {
				case "mybtn":
					new NTSC(2012, 4, 28);
					break;
				case "alertBtn":
					AlertWindow.showWin("我们的类型属于第三种，在这一种，又可分为两种类型。一类是完全的客户端回合制RPG网页版，包括魔幻大陆等很多之前的回合制都是这种模式；一类是把以前武林英雄这种RPG，把没有多人同屏显示做成了同屏多人显示，把战斗文字播报做成了图形化自动战斗。从效果来看");
					break;
				case "okBtn":
					ConfirmWindow.showWin("们的类型属于第三种，在这一种，又可分为两种类型。一类是完全的客户端回合制RPG网页版，包括魔幻大陆等");
					break;
				case "inputBtn":
					ConfirmInputWindow.showWin("的类型属于第三种，在这一种，又可分为两种");
					break;
				case "playBgmCbox":
					if (this.playBgmCbox.isOn)
						SoundManager.getInstance().musicVolume=1;
					else
						SoundManager.getInstance().musicVolume=0;
					break;
				case "originalRbtn":
				case "custonRbtn":
					if (this.originalRbtn.isOn)
						CursorManager.getInstance().resetSystemCursor();
					else
						CursorManager.getInstance().resetGameCursor();
					break;
				case "embedFontBtn":
					this.removeChild(this.mc);
					LibManager.getInstance().releaseLib("mapAssets/player/boy/1.sif");
					LibManager.getInstance().releaseLib("mapAssets/player/boy/2.sif");
					//					var br:ByteArray=LibManager.getInstance().getBinary("lib/flex_skins.lib");
					//					print(br.length);
					//					LibManager.getInstance().clearLib();
					break;
			}

		}

	}
}
