package com.leyou.net {
	import com.ace.utils.FileUtil;
	import com.leyou.net.protocol.TDefaultMessage;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * ...
	 * @author ...
	 */
	public class NetEncode {

		public static const n4CEEF4:uint=0x408D4D;
		public static const n4CEEF8:uint=0x0C08BA52E;
		public static const w4CEF00:uint=0x8D34;
		public static const n4CEEFC:uint=0x408D97;
		public static const BUFFERSIZE:uint=10000;

		private var DecodeBitMasks:Array=[0x2A, 0xE7, 0x18, 0x6F, 0x63, 0x9D, 0x48, 0xEA, 0x39, 0xCD, 0x38, 0xB8, 0xA0, 0xAB, 0xE0, 0x10, 0x35, 0x99, 0x37, 0x09, 0xC0, 0x69, 0xB2, 0xA4, 0x67, 0x88, 0x50, 0x34, 0x7F, 0xFC, 0x0B, 0xBE, 0x0C, 0x44, 0x59, 0xB6, 0x5B, 0x9C, 0x65, 0xD6, 0x94, 0xEB, 0xC4, 0x3B, 0x03, 0x3C, 0xC9, 0x3E, 0x6B, 0x9A, 0xD4, 0xF6, 0xC3, 0x4D, 0x11, 0x24, 0xAA, 0xFF, 0x4A, 0xED, 0x95, 0x93, 0xD9, 0x46, 0x5F, 0x96, 0x87, 0x30, 0xBA, 0xCA, 0xCB, 0xFA, 0x8A, 0x1A, 0x68, 0x5C, 0xAC, 0x07, 0x40, 0x60, 0x29, 0x70, 0x57, 0x53, 0x41, 0x12, 0xDE, 0x1D, 0x64, 0x14, 0x97, 0x72, 0xFB, 0x8D, 0x2B, 0x08, 0xCF, 0xF4, 0x3A, 0x00, 0xC5, 0x91, 0x56, 0xA9, 0x9E, 0x71, 0xBC, 0xA3, 0xAF, 0xA6, 0x55, 0xDA, 0x79, 0xBB, 0x33, 0xA5, 0x25, 0x15, 0x7D, 0xEE, 0xC1, 0x2C, 0xC7, 0xD0, 0x19, 0xD8, 0x5A, 0xE8, 0x85, 0xFD, 0x2F, 0x6A, 0x78, 0x45, 0xDB, 0xB5, 0xF5, 0x1E, 0x04, 0x75, 0xB0, 0x7A, 0x20, 0xF2, 0xDF, 0xD3, 0x83, 0xF3, 0x54, 0x90, 0xA2, 0xC6, 0x0F, 0x80, 0x36, 0x4E, 0xC8, 0x01, 0x82, 0x76, 0xA1, 0x2E, 0x84, 0x86, 0x0E, 0x47, 0x8F, 0xE1, 0xF9, 0x7C, 0xC2, 0x74, 0xDC, 0x26, 0x22, 0xCE, 0x2D, 0x4F, 0xBF, 0x0D, 0x73, 0x27, 0x21, 0xB3, 0x98, 0x1F, 0x89, 0xEC, 0xFE, 0x52, 0x0A, 0x8C, 0x9F, 0xA8, 0xE5, 0xE6, 0x06, 0x8B, 0xCC, 0xF7, 0x5E, 0xE3, 0x7B, 0xD2, 0x05, 0x49, 0x13, 0xE9, 0x66, 0xB7, 0xAD, 0xB4, 0xF8, 0xA7, 0x1C, 0xF1, 0x02, 0x7E, 0x6E, 0x17, 0x62, 0x4C, 0x77, 0x8E, 0xDD, 0xF0, 0x43, 0x28, 0x6D, 0x61, 0xB9, 0xD7, 0xBD, 0x3D, 0x9B, 0x92, 0x16, 0xEF, 0x51, 0x23, 0xE2, 0xB1, 0x81, 0x31, 0x32, 0x58, 0xD1, 0x5D, 0xD5, 0x6C, 0x4B, 0xE4, 0xAE, 0x42, 0x1B, 0x3F];
		private var EncodeBitMasks:Array=[0x8C, 0x87, 0x0D, 0x85, 0xD4, 0x64, 0x63, 0xE5, 0xBA, 0x7E, 0xB8, 0x68, 0x9D, 0x9F, 0xF5, 0xBC, 0xA0, 0xE3, 0x3A, 0x22, 0x19, 0x21, 0x39, 0x78, 0xEE, 0x27, 0x36, 0x15, 0x74, 0xC7, 0x97, 0xC9, 0xCE, 0xE2, 0x7B, 0x4C, 0x98, 0xA1, 0xC2, 0x59, 0x41, 0xC0, 0x1E, 0x2E, 0x95, 0xEB, 0xDE, 0x69, 0x1D, 0x5B, 0x53, 0xDA, 0xF4, 0x0A, 0x4F, 0xBB, 0xB7, 0x24, 0x33, 0x0F, 0xC8, 0x84, 0x29, 0x89, 0x3C, 0x1C, 0x08, 0x49, 0xC6, 0xFE, 0xCC, 0x23, 0x3E, 0xE1, 0x4E, 0x8B, 0x13, 0xE7, 0x1A, 0x5D, 0xCF, 0xB1, 0x47, 0x8F, 0xD8, 0x72, 0x4B, 0x93, 0x6E, 0x73, 0x4D, 0x94, 0xDD, 0x82, 0x14, 0xA7, 0x03, 0xF9, 0xF1, 0xC5, 0x8D, 0x79, 0x2A, 0xC4, 0xDC, 0x60, 0x5F, 0xD7, 0x62, 0xB5, 0xE9, 0xB3, 0xB6, 0x12, 0xA8, 0x32, 0xD9, 0xC3, 0x6A, 0x75, 0x4A, 0xA2, 0x0C, 0x26, 0x91, 0x5A, 0xAD, 0x6D, 0x44, 0x10, 0xB4, 0x46, 0x1B, 0x66, 0x81, 0x20, 0xFD, 0x7F, 0x88, 0x25, 0x9C, 0x71, 0xD3, 0xE6, 0x80, 0xE4, 0xFA, 0x42, 0x9B, 0x37, 0x01, 0xFC, 0xDB, 0x45, 0x6B, 0xFB, 0x56, 0xF0, 0xAF, 0x9A, 0xBF, 0xAB, 0xD6, 0xCD, 0x02, 0xF2, 0x7C, 0xAA, 0xB2, 0x92, 0xFF, 0x57, 0x2F, 0x86, 0xA6, 0x7D, 0x35, 0x17, 0x34, 0xD5, 0x0E, 0x65, 0x09, 0x05, 0x28, 0xCA, 0x48, 0x31, 0x8E, 0x2D, 0xDF, 0x52, 0xF6, 0x1F, 0xA4, 0x50, 0x76, 0x40, 0x18, 0x04, 0x8A, 0x16, 0x2B, 0xAE, 0x43, 0x3F, 0xD0, 0xCB, 0x6C, 0x55, 0x54, 0x96, 0x99, 0x30, 0x67, 0x5E, 0x2C, 0xAC, 0xE0, 0x7A, 0xE8, 0x58, 0x90, 0xBE, 0xA5, 0x6F, 0xB0, 0x70, 0xEC, 0x61, 0x5C, 0x06, 0x3B, 0x77, 0xC1, 0x07, 0xEA, 0xA9, 0xF8, 0x11, 0xBD, 0xF3, 0x00, 0xED, 0x83, 0xEF, 0x3D, 0xA3, 0x51, 0x9E, 0x38, 0xF7, 0x0B, 0xB9, 0xD2, 0xD1];

		private var EncBuf:ByteArray=new ByteArray;

		private var SourceBuf:ByteArray=new ByteArray;

		private var code:uint=100;

		private var m_tDefaultMsg:TDefaultMessage=new TDefaultMessage;

		private var m_StrArray:Array=new Array(BUFFERSIZE);

		// BUFFERSIZE = 10000; //缓冲定义

		private static var instance:NetEncode;

		public static function getInstance():NetEncode {
			if (!instance)
				instance=new NetEncode();
			return instance;
		}

		public function NetEncode() {
			EncBuf.endian=Endian.LITTLE_ENDIAN;
			SourceBuf.endian=Endian.LITTLE_ENDIAN;

		}

		//procedure Decode6BitBuf (sSource:PChar;pBuf:PChar;nSrcLen,nBufLen:Integer);



		private function Decode6BitBuf(sSource:Array, pBuf:ByteArray, nSrcLen:uint, nBufLen:uint):uint {
			//const
			//Masks: array[2..6] of byte = ($FC, $F8, $F0, $E0, $C0);
			//($FE, $FC, $F8, $F0, $E0, $C0, $80, $00);
			//var
			//I,{nLen,}nBitPos,nMadeBit,nBufPos:Integer;
			//btCh,btTmp,btByte:Byte;
			//begin
			//nBitPos:= 2;
			//nMadeBit:= 0;
			//nBufPos:= 0;
			// btTmp:= 0;
			const Masks:Array=[0, 0, 0xFC, 0xF8, 0xF0, 0xE0, 0xC0];
			var i:uint=0;
			var nLen:uint=sSource.length;
			var nBitPos:uint=2;
			var nMadeBit:uint=0;
			var nBufPos:uint=0;
			var btTmp:uint=0;
			var btCh:uint=0;
			var btByte:int;
			var t_testarray:Array=new Array(35);
			for (i=0; i < 35; ++i) {
				t_testarray[i]=254;

			}



			for (i=0; i < nSrcLen; ++i) {
				//var t_nValue:int = sSource.readByte();

				if ((sSource[i] - 0x3C) >= 0) {
					// btCh := Byte(sSource[I]) - $3C
					btCh=sSource[i] - 0x3C;
				} else {
					nBufPos=0;
					break;
				} //end if

				// if nBufPos >= nBufLen then break;
				if (nBufPos >= nBufLen) {
					break;
				} //end if
				//
				//if (nMadeBit + 6) >= 8 then begin
				//btByte := Byte(btTmp or ((btCh and $3F) shr (6- nBitPos)));
				if ((nMadeBit + 6) >= 8) {
					btByte=(btTmp | ((btCh & 0x3F) >> (6 - nBitPos)));
					//pBuf[nBufPos] := Char(btByte);
					//Inc(nBufPos);
					//nMadeBit := 0;
					pBuf.position=nBufPos;
					pBuf.writeByte(btByte);
					t_testarray[nBufPos]=btByte;
					nBufPos++;

					nMadeBit=0;
					//if nBitPos < 6 then Inc (nBitPos, 2)
					//else begin
					//nBitPos := 2;
					//continue;
					//end;
					if (nBitPos < 6) {
						nBitPos+=2;
					} else {
						nBitPos=2;
						continue;
					} //end if
				} //end if
				//btTmp:= Byte (Byte(btCh shl nBitPos) and Masks[nBitPos]);   // #### ##--
				//Inc(nMadeBit, 8 - nBitPos);
				btTmp=(btCh << nBitPos) & Masks[nBitPos];
				nMadeBit=nMadeBit + (8 - nBitPos);

			} //end for
			pBuf.position=nBufPos;
			pBuf.writeByte(0);
			return nBufPos;
		} //end function

		private function Encode6BitBuf(pSrc:ByteArray, pDest:ByteArray, nSrcLen:uint, nDestLen:uint):uint {
			var i:uint=0;
			var nRestCount:uint=0;
			var btRest:uint=0;
			var nDestPos:uint=0;
			pSrc.position=0;
			for (i=0; i < nSrcLen; i++) {
				if (nDestPos >= nDestLen) {
					break;
				}
				var btCh:uint=pSrc.readUnsignedByte();
				var btMade:uint=(btRest | (btCh >> (2 + nRestCount))) & 0x3F;
				btRest=((btCh << (8 - (2 + nRestCount))) >> 2) & 0x3F;
				nRestCount+=2;
				if (nRestCount < 6) {
					//pDest[nDestPos] := Char(btMade + $3C);
					//Inc(nDestPos);
					pDest.position=nDestPos;
					pDest.writeByte(btMade + 0x3C);
					nDestPos++;
				} else {
					if (nDestPos < nDestLen - 1) {
						//pDest[nDestPos] := Char(btMade + $3C);
						//pDest[nDestPos + 1] := Char(btRest + $3C);
						//Inc(nDestPos, 2);
						pDest.position=nDestPos;
						pDest.writeByte(btMade + 0x3C);
						pDest.writeByte(btRest + 0x3C);
						nDestPos+=2;
					} else {
						//pDest[nDestPos] := Char(btMade + $3C);
						//Inc(nDestPos);
						pDest.position=nDestPos;
						pDest.writeByte(btMade + 0x3C);
						nDestPos++;
					} //end if
					//nRestCount := 0;
					//btRest := 0;
					nRestCount=0;
					btRest=0;

				} //end if

			} //end for

			//if nRestCount > 0 then begin
			//pDest[nDestPos] := Char(btRest + $3C);
			//Inc(nDestPos);
			//end;
			if (nRestCount > 0) {
				pDest.position=nDestPos;
				pDest.writeByte(btRest + 0x3C);
				nDestPos++;
			}
			//pDest[nDestPos] := #0;
			pDest.position=nDestPos;
			pDest.writeByte(0);

			return nDestPos;

		}

		public function GetSendText(_nMode:uint, _strSend:String):String {

			if (_nMode == 2) {
				var t_nCode:int=code % 10;
				_strSend='#' + t_nCode + _strSend + '!';

			} else {
				_strSend='#' + code + _strSend + '!';
			}

			code++;
			if (code >= 110) {
				code=101;
			}

			return _strSend;
		}

		public function EncodeMessage(sMsg:TDefaultMessage):String {
			//var
			//EncBuf, TempBuf: array[0..BUFFERSIZE - 1] of Char;
			//temp: char;
			//begin
			//sMsg.Ident := sMsg.Ident + sMsg.nSessionID ;
			//Move(sMsg, TempBuf, SizeOf(TDefaultMessage));
			//Encode6BitBuf(@TempBuf, @EncBuf, SizeOf(TDefaultMessage), SizeOf(EncBuf));
			//Result := StrPas(EncBuf);
			//temp := Result[1];
			//result[1] := Result[2];
			//Result[2] := temp;
			sMsg.Ident=sMsg.Ident + sMsg.nSessionID;
			var TempBuf:ByteArray=sMsg.GetByteArray();
			var t_nLen:uint=Encode6BitBuf(TempBuf, EncBuf, 24, BUFFERSIZE);

			EncBuf.position=0;
			var t_str:String=EncBuf.readMultiByte(t_nLen, "cn-gb");

			var t_array:Array=StrToArray(t_str);
			var temp:int=t_array[1];
			t_array[1]=t_array[0];
			t_array[0]=temp;
			t_str=ArrayToStr(t_array, t_str.length);

			return t_str;
		} //end function

		public function EncodeBuffer(br:ByteArray, bufsize:int):String {
			var TempBuf:ByteArray;
			var t_str:String;
			if (bufsize < BUFFERSIZE) {
				TempBuf=br;
//				EncBuf.clear();
				var t_nLen:uint=Encode6BitBuf(TempBuf, EncBuf, bufsize, BUFFERSIZE);
				EncBuf.position=0;
				t_str=EncBuf.readMultiByte(t_nLen, "utf8");

			} else {
				t_str="";
			}
//			t_str='<L<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
			return t_str;
//			var
//			EncBuf, TempBuf: array[0..BUFFERSIZE - 1] of Char;
//			begin
//			try
//				EnterCriticalSection(CSEncode);
//				if bufsize < BUFFERSIZE then begin
//				Move(Buf^, TempBuf, bufsize);
//				Encode6BitBuf(@TempBuf, @EncBuf, bufsize, SizeOf(EncBuf));
//				Result := StrPas(EncBuf);
//				end else Result := '';
//				finally
//				LeaveCriticalSection(CSEncode);
//				end;
		}

		//function  EncodeString (str: string): string;/
		public function EncodeString(str:String):String {
			//var
			//EncBuf:array[0..BUFFERSIZE - 1] of Char;
			//begin
			//Encode6BitBuf(PChar(str), @EncBuf, Length(str), SizeOf(EncBuf));
			//Result:=StrPas(EncBuf);
			var t_byteArray:ByteArray=new ByteArray;
			var t_OutArray:ByteArray=new ByteArray;
			t_byteArray.endian=Endian.LITTLE_ENDIAN;
			t_OutArray.endian=Endian.LITTLE_ENDIAN;
			t_byteArray.writeMultiByte(str, "cn-gb");
			//t_byteArray.writeByte(0);
			var t_nLen:uint=Encode6BitBuf(t_byteArray, t_OutArray, t_byteArray.position, BUFFERSIZE);

			t_OutArray.position=0;
			var t_str:String=t_OutArray.readMultiByte(t_nLen, "cn-gb");

			return t_str;

		} //end funciton

		//function DecodeMessage(Str: string): TDefaultMessage;

		public function StrToArray(str:String):Array {
			//var t_array:Array = new Array(100);
			m_StrArray.position=0;
			for (var i:int=0; i < str.length; ++i) {
				m_StrArray[i]=str.charCodeAt(i);
			}

			return m_StrArray;

		}

		public function ArrayToStr(_array:Array, _nLen:uint):String {
			var t_str:String='';
			var t_str1:String='';
			for (var i:int=0; i < _nLen; ++i) {
				//trace(String.fromCharCode(_array[i]);
				//t_+str += );
				t_str+=String.fromCharCode(_array[i]);
					//t_str1 += t_str;
			}

			return t_str;

		}

		public function DecodeString(str:String):String {
			SourceBuf.position=0;
			SourceBuf.writeMultiByte(str, "utf8");
			EncBuf.position=0;
			SourceBuf.position=0;
			var t_array:Array=StrToArray(str);
			var t_nLen:int=Decode6BitBuf(t_array, EncBuf, str.length, BUFFERSIZE);
			EncBuf.position=0;
			var t_str:String=EncBuf.readMultiByte(t_nLen, "utf8");
			return t_str;
		}

		public function DecodeBuffer(_str:String):ByteArray {
			var t_array:Array=StrToArray(_str);
			EncBuf.position=0;
			var t_nDestLen:int=Decode6BitBuf(t_array, EncBuf, _str.length, BUFFERSIZE);
			EncBuf.position=0;
			return EncBuf;
		}

		public function DecodeMessage(str:String):TDefaultMessage {
			//var
			//EncBuf: array[0..BUFFERSIZE - 1] of Char;
			//Msg: TDefaultMessage;
			//temp: char;
			//str1: string;
			//begin 
			//temp := str[1];
			//str[1] := str[2];
			//str[2] := temp;
			//Decode6BitBuf(PChar(Str), @EncBuf, Length(Str), SizeOf(EncBuf));
			//Move(EncBuf, Msg, SizeOf(TDefaultMessage));
			//Msg.Ident := Msg.Ident - Msg.nSessionID ;
			//Result := Msg;

			var temp:int;
			var str1:String;
			//temp = str.charAt[1];
			//str.charAt[0] = str.charAt[1];
			//str.charAt[1] = temp;


			var t_array:Array=StrToArray(str);
			temp=t_array[0];
			t_array[0]=t_array[1];
			t_array[1]=temp;
			str=ArrayToStr(t_array, str.length);

			//var t_byteArray:ByteArray = new ByteArray;
			//t_byteArray.endian = Endian.LITTLE_ENDIAN;
			//t_byteArray.writeMultiByte(str, "cb-gb");
			EncBuf.position=0;
			//t_byteArray.position = 0;
			var t_nDestLen:int=Decode6BitBuf(t_array, EncBuf, str.length, BUFFERSIZE);
			EncBuf.position=0;
			m_tDefaultMsg=new TDefaultMessage();
			m_tDefaultMsg.ReadByteArray(EncBuf);
			if (m_tDefaultMsg.Ident > m_tDefaultMsg.nSessionID)
				m_tDefaultMsg.Ident=m_tDefaultMsg.Ident - m_tDefaultMsg.nSessionID;

			EncBuf.position=0;

			return m_tDefaultMsg;

		}

		//比如 0x12345678,会得到高位：0x1234
		public function HiWord(L:int):uint {
			var t_result:int=L >> 16;
			return t_result;
		}

		//比如 0x12345678,会得到低位：0x5678
		public function LowWord(L:int):uint {
			var t_result:int=L & 0xffff;
			return t_result;

		}

		//比如 0x1234 会得到低位0x34
		public function LowByte(L:int):uint {
			var t_result:int=L & 0xff;
			return t_result;
		}

		public function MakeLong(_nx:int, _ny:int):int {
			var t_int:int=_nx | _ny << 16;

			return t_int;

		}


		public function HiByte(L:int):uint {
			var t_result:int=L >> 8;
			return t_result;
		}
	} //end class

} //end package