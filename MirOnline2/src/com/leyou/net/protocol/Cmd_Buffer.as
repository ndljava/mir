package com.leyou.net.protocol {
	import com.leyou.data.net.buff.TBuff;
	import com.leyou.manager.UIManager;

	public class Cmd_Buffer {
		//buffer
		static public function sm_buff(td:TDefaultMessage, body:String):void {
			var buffer:TBuff=new TBuff();
			buffer.nImgIndex=td.Param;
			buffer.nTime=td.Tag*1000;
			buffer.str=body;
			UIManager.getInstance().buf.addBuff(buffer);
		}

	}
}