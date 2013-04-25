package com.leyou.net {
	import com.ace.tools.print;
	import com.leyou.net.protocol.Cmd_Other;
	import com.leyou.net.protocol.TDefaultMessage;
	import com.leyou.net.protocol.scene.CmdScene;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;

	public class NetGate {
		private var sk:Socket;
		private var msgLen:int;
		private var isReadHead:Boolean;
		private var heartTimer:Timer;
		private var callBackFun:Function;

		public var certification:uint=0; //与服务器保持唯一id


		private static var instance:NetGate;

		public static function getInstance():NetGate {
			if (!instance)
				instance=new NetGate();
			return instance;
		}

		public function NetGate() {
			ServerFunDic.setup();
			this.init();
		}


		private function init():void {
			this.sk=new Socket();
			this.sk.endian=Endian.LITTLE_ENDIAN;
			this.sk.addEventListener(Event.CONNECT, conned);
			this.sk.addEventListener(Event.CLOSE, disConn);
			this.sk.addEventListener(IOErrorEvent.IO_ERROR, onErr);
			this.sk.addEventListener(SecurityErrorEvent.SECURITY_ERROR, oSec);
			this.sk.addEventListener(ProgressEvent.SOCKET_DATA, onSkData);
			this.heartTimer=new Timer(3000);
			this.heartTimer.addEventListener(TimerEvent.TIMER, heartSend);
		}

		public function get connSate():Boolean {
			return sk.connected;
		}

		//连接服务器
		public function Connect(serverIp:String, port:int, fun:Function):void {
			print("----->开始连接");
			this.callBackFun=fun;
			this.closeConnect();
			this.sk.connect(serverIp, port);
		}

		//更改连接服务器
		public function changeConnect(serverIp:String, port:int, fun:Function):void {
			print("----->更换连接", sk.connected);
			this.callBackFun=fun;
			this.closeConnect();
			this.sk.connect(serverIp, port);
		}

		//关闭连接
		public function closeConnect():void {
			sk.connected && sk.close();
			print("----->主动关闭连接");
		}

		//向服务器发送message
		public function send(br:ByteArray):void {

		}

		public function SendString(str:String):void {
//			print('send lend:' + str.length);
//			print(str);
			this.sk.writeMultiByte(str, "cn-gb");
			this.sk.flush();
		}


		//成功连接
		private function conned(e:Event):void {
			print("----->成功连接");
			if (this.callBackFun != null) {
				this.callBackFun();
				this.callBackFun=null;
			}
		}

		//成功断开
		private function disConn(e:Event):void {
			print("----->与服务器断开连接");
		}

		//连接错误
		private function onErr(e:IOErrorEvent):void {
			print("----->连接失败！");
		}

		//安全策略
		private function oSec(e:SecurityErrorEvent):void {
			print("----->安全校验失败！");
		}

		//接受数据
		private function onSkData(e:ProgressEvent):void {
//			print("----->接受数据");
			this.readData();
		}

		//新的获取数据
		private function readData():void {
			var len:uint=this.sk.bytesAvailable;
			var readbuff:ByteArray=new ByteArray();
			readbuff.endian=Endian.LITTLE_ENDIAN;

			this.sk.readBytes(readbuff);
			readbuff.position=0;

			this.allCmd+=readbuff.readMultiByte(len, "cn-gb");
			this.readOneCmd();


//			while (this.preCmd.length > 26) {
			while (this.preCmd != "") {
				if (this.preCmd.indexOf("+") != -1) {
					Cmd_Other.readCmd(this.preCmd);
					this.resetPreCmd();
					this.readOneCmd();
					continue;
				}
				this.readCmd(this.preCmd);
				this.resetPreCmd();
				this.readOneCmd();
			}
			return;
		}

		private var allCmd:String="";
		private var preCmd:String="";

		private function resetPreCmd():void {
			this.preCmd="";
		}

		private function readOneCmd():void {
			var t_iPos:int=this.allCmd.indexOf('#');
			if (t_iPos < 0) {
				this.preCmd="";
			}
			var t_iEndPos:int=this.allCmd.indexOf('!');
			if (t_iEndPos < 0) {
				this.preCmd="";
			}
			this.preCmd=this.allCmd.substr(0, t_iEndPos + 1);
			this.allCmd=this.allCmd.substring(t_iEndPos + 1);
		}

		protected function readCmd(str:String):void {
			str=str.substr(1, str.length - 2);
			var t_stMsg:String=str.substr(0, 32);
			var t_stBody:String=str.substr(32, str.length - 32);
			var t_msg:TDefaultMessage=NetEncode.getInstance().DecodeMessage(t_stMsg);
			ServerFunDic.executeCmd(t_msg, t_stBody);
		}

		private var m_dwCheckGuaCount:int;

		private function heartSend(e:TimerEvent):void {
			CmdScene.cm_Heartbeat(m_dwCheckGuaCount);
			m_dwCheckGuaCount++;
		}

		public function startHeart():void {
			this.heartTimer.start();
		}

		public function die():void {
			this.closeConnect();
			this.sk.removeEventListener(Event.CONNECT, conned);
			this.sk.removeEventListener(Event.CLOSE, disConn);
			this.sk.removeEventListener(IOErrorEvent.IO_ERROR, onErr);
			this.sk.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, oSec);
			this.sk.removeEventListener(ProgressEvent.SOCKET_DATA, onSkData);
			this.heartTimer.removeEventListener(TimerEvent.TIMER, heartSend);
		}
	}
}
