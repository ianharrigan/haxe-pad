package org.haxepad.util;

#if air
import flash.events.Event;
import flash.filesystem.File;
import flash.utils.ByteArray;
import flash.filesystem.FileStream; // need to change UInts to Ints in FileStream.hx
import flash.filesystem.FileMode;
#end

class FileSystemHelper {
	public function new() {
		
	}
	
	public static function readDirectory(path:String):Array<String> {
		#if flash
			#if air
				var arr:Array<String> = new Array<String>();
				var file:File = new File(path);
				for (f in file.getDirectoryListing()) {
					arr.push(f.name);
				}
				return arr;
			#else
				return new Array<String>();
			#end
		#else
			return sys.FileSystem.readDirectory(path);
		#end
	}
	
	public static function isDirectory(path:String):Bool {
		if (exists(path) == false) {
			return false;
		}
		
		#if flash
			#if air
				var file:File = new File(path);
				return file.isDirectory;
			#else
				return false;
			#end
		#else
			return sys.FileSystem.isDirectory(path);
		#end
	}
	
	public static function getCwd():String {
		#if flash
			#if air
				return File.applicationDirectory.nativePath;
			#else
				return null;
			#end
		#else
			return Sys.getCwd();
		#end
	}
	
	public static function normalizePath(s:String):String {
		s = StringTools.replace(s, "\\", "/");
		s = StringTools.replace(s, "//", "/");
		return s;
	}
	
	public static function exists(path:String):Bool {
		#if flash
			#if air
				var file:File = new File(path);
				return file.exists;
			#else
				return false;
			#end
		#else
			return sys.FileSystem.exists(path);
		#end
	}
	
	public static function writeFile(filePath:String, content:String):Void {
		#if flash
			#if air
				var file:File = new File(filePath);
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.WRITE);
				stream.writeUTFBytes(content);
				stream.close();
			#end
		#else
			sys.io.File.saveContent(filePath, content);
		#end
	}
	
	public static function getFileDetails(filePath:String, readContents:Bool = true):FileDetails {
		filePath = normalizePath(filePath);
		if (isDirectory(filePath) == true || exists(filePath) == false) {
			var partialDetails:FileDetails = new FileDetails();
			partialDetails.filePath = filePath;
			var n:Int = filePath.lastIndexOf("/");
			if (n != -1) {
				partialDetails.name = filePath.substring(n + 1, filePath.length);
			} else {
				partialDetails.name = filePath;
			}
			return partialDetails;
		}
		
		#if flash
			#if air
				var file:File = new File(filePath);
				var details:FileDetails = new FileDetails();
				details.name = file.name;
				details.type = file.type;
				details.size = file.size;
				details.filePath = normalizePath(file.nativePath);
				if (readContents == true) {
					var stream:FileStream = new FileStream();
					stream.open(file, FileMode.READ);
					details.contents = stream.readUTFBytes(stream.bytesAvailable);
					stream.close();
					details.contents = StringTools.replace(details.contents, "\r", "");
				}
				return details;
			#else
				return null;
			#end
		#else
			var details:FileDetails = new FileDetails();
			details.filePath = filePath;
			var n:Int = filePath.lastIndexOf("/");
			if (n != -1) {
				details.name = filePath.substring(n + 1, filePath.length);
			} else {
				details.name = filePath;
			}
			if (readContents == true) {
				details.contents = sys.io.File.getContent(filePath);
				details.contents = StringTools.replace(details.contents, "\r", "");
				details.contents = StringTools.replace(details.contents, "\t", "    ");
			}
			return details;
		#end
	}
}