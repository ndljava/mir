package com.leyou.net.protocol {
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * ...
	 * @author ...
	 */
	public class TDefaultMessage {
		//TDefaultMessage = record
		//Recog: Integer;//识别码
		//Ident: Word;
		//Param: Integer; //21亿血         
		//Tag: Integer;   //21亿血
		//Series: Integer; //21亿血
		//nSessionID: Integer;//客户端会话ID 20081210
		//end;
		public var Recog:int;
		public var Ident:uint;
		public var Param:int;
		public var Tag:int;
		public var Series:int;
		public var nSessionID:int;

		public var nExValue:int;
		private var m_ByteArrar:ByteArray=new ByteArray;

		public function TDefaultMessage() {
			m_ByteArrar.endian=Endian.LITTLE_ENDIAN;

		}

		//function MakeDefaultMsg(wIdent: Word; nRecog, wParam, wTag, wSeries: Integer; wSessionID: Integer): TDefaultMessage;
		public function MakeDefaultMsg(wIdent:int, nRecog:int, wParam:int, wTag:int, wSeries:int, wSessionID:int):void {
			//Result.Recog := nRecog;
			//Result.Ident := wIdent;
			//Result.Param := wParam;
			//Result.Tag := wTag;
			//Result.Series := wSeries;
			//Result.nSessionID := wSessionID;//20081210
			Recog=nRecog;
			Ident=wIdent;
			Param=wParam;
			Tag=wTag;
			Series=wSeries;
			nSessionID=wSessionID;
		}

		public function GetByteArray():ByteArray {
			m_ByteArrar.clear();
			m_ByteArrar.writeInt(Recog);
			//m_ByteArrar.writeInt(Ident);
			m_ByteArrar.writeShort(Ident);
			m_ByteArrar.writeShort(nExValue);
			m_ByteArrar.writeInt(Param);
			m_ByteArrar.writeInt(Tag);
			m_ByteArrar.writeInt(Series);
			m_ByteArrar.writeInt(nSessionID);

			return m_ByteArrar;
		}

		public function ReadByteArray(_array:ByteArray):void {
			Recog=_array.readInt();
			Ident=_array.readUnsignedShort();
			nExValue=_array.readShort();
			Param=_array.readInt();
			Tag=_array.readInt();
			Series=_array.readInt();
			nSessionID=_array.readInt();

		}

	}

}