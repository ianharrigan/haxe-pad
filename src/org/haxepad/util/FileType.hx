package org.haxepad.util;

class FileType {
	private static var _icons:Map<String, String> = [
		".exe" => "img/icons/application-blue.png",
		".png" => "img/icons/image.png",
		".jpg" => "img/icons/image.png",
		".jpeg" => "img/icons/image.png",
		".bmp" => "img/icons/image.png",
		".ico" => "img/icons/document-image.png",
		".css" => "img/icons/document-block.png",
		".txt" => "img/icons/document-text.png",
		".pdf" => "img/icons/document-pdf.png",
		".xls" => "img/icons/document-excel.png",
		".html" => "img/icons/document-code.png",
		".htm" => "img/icons/document-code.png",
		".xml" => "img/icons/document-code.png",
	];
	
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
	
	public static function getIcon(fileName:String):String {
		var s:String = "img/icons/document.png";
		var ext:String = getExtension(fileName);
		if (ext != null) {
			var t:String = _icons.get(ext);
			if (t != null) {
				s = t;
			}
		}
		return s;
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
}