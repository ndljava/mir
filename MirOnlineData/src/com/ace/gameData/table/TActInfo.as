package  com.ace.gameData.table {

	public class TActInfo {
		//帧频，间隔时间
		//动作开始帧
		//动作结束帧
		//动作的帧频

		public var startFrame:int;
		public var endFrame:int;
		public var preFrame:int;
		public var spaceFrame:int;
		public var interval:int;
		public var noDir:Boolean;

		public function TActInfo(info:XML) {
			this.startFrame=info.@startFrame;
			this.endFrame=info.@endFrame;
			this.preFrame=info.@preFrame;
			this.spaceFrame=info.@spaceFrame;
			this.interval=info.@interval;
			this.noDir=(info.@noDir == "1") ? true : false;
			if(this.noDir)
				this.endFrame=this.startFrame+this.preFrame-this.spaceFrame;
		}
	}
}

/*

加载信息格式：
加载id、加载部位类型

图片格式：swf序列帧的，或者自定义格式
自定义格式
图片数量，图片偏移x、y，图片宽、高、图片数据；
播放信息格式：
//帧频(间隔帧)、每个动作的开始、结束帧
<id="11001" speed="">
<act="stand" startFrame="" endFrame="" preFrame="" spaceFrame=""/>
<act="walk" startFrame="" endFrame=""/>
<act="run" startFrame="" endFrame=""/>
……
</id>

实时加载接口类
函数：加载完毕(部位参数)

首先定义个“part”类
变量：part的图片数据，part的播放参数数据
函数：播放指定的动作

再定义人物“Model”类
变量：部位数组
函数：初始化要加载的内容，加载完毕接口

*/