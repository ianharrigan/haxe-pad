package org.haxepad.managers;
import flash.net.SharedObject;

class PrefsManager {
	private static inline var DEFAULT_SECTION:String = "HaxePadDefaults";
	
	private static inline var LAST_DIR:String = "lastDir";
	
	private static var settingsMap:Map<String, String> = [
		LAST_DIR => DEFAULT_SECTION,
	];
	
	public static var lastDir(get, set):String;
	private static function get_lastDir():String {
		return getPref(LAST_DIR, "", settingsMap.get(LAST_DIR));
	}
	private static function set_lastDir(value:String):String {
		setPref(LAST_DIR, value, settingsMap.get(LAST_DIR));
		return value;
	}
	
	public static function getPref(key:String, defaultValue:String = null, section:String = DEFAULT_SECTION):String {
		var value:String = defaultValue;
		
		if (key == "flashPlayer") {
			return "C:/temp/haxetest/FlashPlayerDebugger.exe";
		}
		
		var so = SharedObject.getLocal(section);
		if (so != null && so.data != null) {
			if (Reflect.hasField(so.data, key)) {
				value = Reflect.field(so.data, key);
			}
		}
		
		return value;
	}
	
	public static function setPref(key:String, value:String, section:String = DEFAULT_SECTION):Void {
		var so = SharedObject.getLocal(section);
		if (so != null && so.data != null) {
			Reflect.setField(so.data, key, value);
			try {
				so.flush();
			} catch (e:Dynamic) {
				trace("Could not save pref: " + e);
			}
		}
	}
	
	public static function clearPref(key:String, section:String = DEFAULT_SECTION):Void {
		var so = SharedObject.getLocal(section);
		if (so != null && so.data != null) {
			if (Reflect.hasField(so.data, key)) {
				Reflect.deleteField(so.data, key);
				try {
					so.flush();
				} catch (e:Dynamic) {
					trace("Could not clear pref: " + e);
				}
			}
		}
	}
}