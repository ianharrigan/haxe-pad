package org.haxepad.managers;
import flash.net.SharedObject;
import haxe.ui.toolkit.controls.Value;

class PrefsManager {
	private static inline var DEFAULT_SECTION:String = "HaxePadDefaults";
	
	private static inline var LAST_DIR:String = "lastDir";
	private static inline var ENV_VARS:String = "environmentVars";
	
	private static var settingsMap:Map<String, String> = [
		LAST_DIR => DEFAULT_SECTION,
		ENV_VARS => DEFAULT_SECTION
	];

	private static var envDefaults:Map<String, String> = [
		"FLASH_PLAYER" => "%APP_PATH%/FlashPlayerDebugger.exe"
	];
	
	public static var lastDir(get, set):String;
	private static function get_lastDir():String {
		return getPref(LAST_DIR, "", settingsMap.get(LAST_DIR));
	}
	private static function set_lastDir(value:String):String {
		setPref(LAST_DIR, value, settingsMap.get(LAST_DIR));
		return value;
	}

	public static var environmentVars(get, set):String;
	private static function get_environmentVars():String {
		var temp:String = ""; // building up env vars as you can enter "=" in the text input in the prefs(!!!)
		for (key in envDefaults.keys()) {
			var value = envDefaults.get(key);
			temp += key + "=" + value + ";";
		}
		return getPref(ENV_VARS, temp, settingsMap.get(ENV_VARS));
	}
	private static function set_environmentVars(value:String):String {
		setPref(ENV_VARS, value, settingsMap.get(ENV_VARS));
		return value;
	}
	
	public static function getEnvironmentVarNames():Array<String> {
		var v:Map<String, String> = new Map<String, String>();
		for (key in envDefaults.keys()) {
			v.set(key, "");
		}
		
		var arr = environmentVars.split(";");
		for (a in arr) {
			var p = a.split("=");
			v.set(StringTools.trim(p[0]), "");
		}
		
		var arr:Array<String> = new Array<String>();
		for (key in v.keys()) {
			arr.push(key);
		}
		return arr;
	}
	
	public static function getEnvironmentValue(name:String):String {
		if (name == null || name.length == 0) {
			return null;
		}

		var v = envDefaults.get(name);
		if (v == null) {
			return null;
		}

		var arr = environmentVars.split(";");
		for (a in arr) {
			var p = a.split("=");
			if (StringTools.trim(p[0]) == name) {
				v = StringTools.trim(p[1]);
				break;
			}
		}
		return v;
	}
	
	public static var flashPlayer(get, set):String;
	private static function get_flashPlayer():String {
		return getPref("flashPlayer", "%APP_PATH%/FlashPlayerDebugger.exe", "FlashSettings");
	}
	private static function set_flashPlayer(value:String):String {
		setPref("flashPlayer", value, "FlashSettings");
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
			if (value != null) {
				Reflect.setField(so.data, key, value);
			} else if (Reflect.hasField(so.data, key)) {
				Reflect.deleteField(so.data, key);
			}
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