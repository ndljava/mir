package com.leyou.ui {
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.scrollBar.event.ScrollBarEvent;
	import com.ace.ui.slider.children.HSlider;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Mp3Player extends AutoWindow {
		private var mp3Url:TextInput;
		private var playBtn:NormalButton;
		private var pauseBtn:NormalButton;
		private var goOnBtn:NormalButton;
		private var volumeSlider:HSlider;
		private var mute:CheckBox;

		public function Mp3Player() {
			super(LibManager.getInstance().getXML("config/player.xml"));
			this.init();
			this.show();
		}

		private function init():void {

			this.mp3Url=this.getUIbyID("mp3Url") as TextInput;
			this.playBtn=this.getUIbyID("playBtn") as NormalButton;
			this.pauseBtn=this.getUIbyID("pauseBtn") as NormalButton;
			this.goOnBtn=this.getUIbyID("goOnBtn") as NormalButton;
			this.mute=this.getUIbyID("mute") as CheckBox;
			this.volumeSlider=this.getUIbyID("volumeSlider") as HSlider;

			this.playBtn.addEventListener(MouseEvent.CLICK, onCLick);
			this.pauseBtn.addEventListener(MouseEvent.CLICK, onCLick);
			this.goOnBtn.addEventListener(MouseEvent.CLICK, onCLick);
			this.mute.addEventListener(MouseEvent.CLICK, onCLick);
			this.volumeSlider.addEventListener(ScrollBarEvent.Progress_Update, onChange);
		}

		private function onChange(evt:Event):void {
			SoundManager.getInstance().musicVolume=this.volumeSlider.progress;
		}

		private function onCLick(evt:MouseEvent):void {
			switch (evt.target.name) {
					case "playBtn":
						if (this.mp3Url.text == "")
							return;
						SoundManager.getInstance().playMusic(this.mp3Url.text);
						break;
					case "pauseBtn":
						SoundManager.getInstance().musicStop();
						break;
					case "goOnBtn":
						SoundManager.getInstance().musicRestart();
						break;
					case "mute":
						SoundManager.getInstance().musicVolume=this.mute.isOn ? 0 : 1;
						break;
				}

		}
	}
}
