package org.haxepad.util;
import org.haxepad.script.Popups;
import org.haxepad.script.ObjectCache;
import org.haxepad.script.wrappers.DocumentManagerWrapper;

class ScriptUtil {
	public static function exec(script:String, id:String):Dynamic {
		if (script == null || id == null || id.length == 0) {
			return null;
		}
		
		var parser = new hscript.Parser();
		var program = parser.parseString(script);
		var interp = new hscript.Interp();

		var cache:ObjectCache = new ObjectCache(id);
		interp.variables.set("Cache", cache);

		var documentsWrapper:DocumentManagerWrapper = new DocumentManagerWrapper();
		interp.variables.set("Documents", documentsWrapper);
		
		var popupsWrapper:Popups = new Popups();
		interp.variables.set("Popups", popupsWrapper);
		
		return interp.execute(program);
	}
}