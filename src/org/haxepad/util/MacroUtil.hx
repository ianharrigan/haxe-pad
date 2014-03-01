package org.haxepad.util;

import haxe.macro.Context;
import haxe.macro.Expr;

class MacroUtil {
	macro public static function loadUserPlugins(filename:String):Expr {
		var code:String = "function() {\n";
		
		if (sys.FileSystem.exists(filename)) {
			var contents:String = sys.io.File.getContent(filename);
			contents = StringTools.replace(contents, "\"", "'");
			code += "\torg.haxepad.managers.PluginManager.loadUserPlugins(Xml.parse(\"" + contents + "\"));\n";
		}
		
		code += "}()\n";
		return Context.parseInlineString(code, Context.currentPos());
	}
	
	macro public static function loadPluginDir(dir:String, recursive:Bool = true):Expr {
		var code:String = "function() {\n";
		
		if (sys.FileSystem.exists(dir) == true && sys.FileSystem.isDirectory(dir)) {
			var files:Array<String> = sys.FileSystem.readDirectory(dir);
			if (files != null) {
				for (file in files) {
					var fullPath:String = dir + "/" + file;
					if (!sys.FileSystem.isDirectory(fullPath)) {
						var contents:String = sys.io.File.getContent(fullPath);
						contents = StringTools.replace(contents, "\"", "'");
						code += "\torg.haxepad.managers.PluginManager.loadPluginFromXML(Xml.parse(\"" + contents + "\"));\n";
					} else {
						if (recursive == true) {
							code += "\tMacroUtil.loadPluginDir(\"" + fullPath + "\", true);\n";
						}
					}
				}
			}
		}
		
		code += "}()\n";
		//trace(code);
		return Context.parseInlineString(code, Context.currentPos());
	}
}