package com.utils
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.ReturnKeyLabel;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.graphics.codec.JPEGEncoder;

	public class FileUtil
	{
		System.useCodePage = true;//防止出现乱码
		public static function readFile($name:String):ByteArray{                      
			var fl:File = File.desktopDirectory.resolvePath($name);
			var fs:FileStream = new FileStream();
			try
			{
				fs.open(fl,FileMode.READ);
				var ba:ByteArray=new ByteArray(); 
				fs.readBytes(ba);
				fs.close();
			}
			catch(e:Error)
			{
				Alert.show($name +"读取错误");
			}
//			var ba:ByteArray=new ByteArray(); 
//			fs.readBytes(ba);
//			fs.close();
			if(ba == null)
			{
				Alert.show($name +"读取错误");
			}
			return ba;
		}
		/**
		 *创建文件 图片类型
		 * @param fileName
		 * @param path
		 * 
		 */		
		static public function saveImg(path:String,bmd:BitmapData,name:String):void{
			var jpgEncod:JPEGEncoder = new JPEGEncoder(80);
			var imgBityArr:ByteArray =jpgEncod.encode(bmd);
			
			var fl:File = File.desktopDirectory.resolvePath(path+name);
			var fs:FileStream = new FileStream();
			
			fs.open(fl,FileMode.WRITE);
			fs.writeBytes(imgBityArr);
			fs.close();
		}
		/**
		 *保存 xml类型文件s 
		 * @param path 路径
		 * @param fileName 文件名 （不用加类型后缀）
		 * @param xml 数据
		 * 
		 */		
		static public function saveXmlFile(path:String,fileName:String,xml:XML):void
		{
			var str:String = xml.toXMLString();
			var file:File = new File(path+fileName+".xml");
			var stream:FileStream = new FileStream();
			stream.open(file,FileMode.WRITE);
			stream.writeUTFBytes(str);
			stream.close();
		}
		/**
		 *保存文件 
		 * @param name 需要加类型后缀名
		 * @param str
		 * 
		 */		
		static public function saveFile(name:String,str:String):void
		{
			var file:File = new File(name);
			var stream:FileStream = new FileStream();
			stream.open(file,FileMode.WRITE);
			stream.writeUTFBytes(str);
			stream.close();
		}
		/**
		 * 保存二进制文件
		 * @param name
		 * @param arr
		 * 
		 */		
		static public function saveFileData(name:String,arr:ByteArray):void
		{
			var file:File = new File(name);
			var stream:FileStream = new FileStream();
			stream.open(file,FileMode.WRITE);
			arr.position = 0;
			stream.writeBytes(arr);
			stream.close();
		}
	}
}