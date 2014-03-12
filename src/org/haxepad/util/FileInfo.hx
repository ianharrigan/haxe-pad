package org.haxepad.util;
import haxe.ui.dialogs.files.FileSystemHelper;

class FileInfo {
	private static var _styles:Map<String, String> = [
		".xml" => "icon-xml",
	];
	
	private static var _syntax:Map<String, String> = [
		".hx" => "haxe",
		".xml" => "xml",
		".css" => "css",
	];
	
	public function new() {
	}
	
	public static function getStyle(fileName:String):String {
		var s:String = "icon-default";
		var ext:String = getExtension(fileName);
		if (ext != null) {
			var t:String = _styles.get(ext);
			if (t != null) {
				s = t;
			}
		}
		return s;
	}
	
	public static function getSyntax(fileName:String):String {
		var s:String = "";
		var ext:String = getExtension(fileName);
		if (ext != null) {
			var t:String = _syntax.get(ext);
			if (t != null) {
				s = t;
			}
		}
		return s;
	}
	
	public static function getExtension(fileName:String):String {
		var ext:String = null;
		var n:Int = fileName.lastIndexOf(".");
		if (n != -1) {
			ext = fileName.substring(n, fileName.length);
		}
		return ext;
	}
	
	public static function getNameNoExt(fileName:String):String {
		var name:String = null;
		var n:Int = fileName.lastIndexOf(".");
		if (n != -1) {
			name = fileName.substring(0, n);
		}
		return name;
	}
	
	public static function getDir(filePath:String):String {
		filePath = FileSystemHelper.normalizePath(filePath);
		var n:Int = filePath.lastIndexOf("/");
		if (n != -1) {
			filePath = filePath.substring(0, n);
		}
		return filePath;
	}
}