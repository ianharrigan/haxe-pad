package org.haxepad.script;

class ObjectCache {
	private static var _caches:Map < String, Map<String, Dynamic> > = new Map < String, Map<String, Dynamic> > ();
	
	private var _id:String;
	
	public function new(id:String) {
		_id = id;
	}
	
	public function setValue(key:String, value:Dynamic):Void {
		var map:Map<String, Dynamic> = _caches.get(_id);
		if (map == null) {
			map = new Map<String, Dynamic>();
			_caches.set(_id, map);
		}
		map.set(key, value);
	}
	
	public function getValue(key):Dynamic {
		var map:Map<String, Dynamic> = _caches.get(_id);
		if (map == null) {
			return null;
		}
		return map.get(key);
	}
	
	public function clearValue(key):Void {
		var map:Map<String, Dynamic> = _caches.get(_id);
		if (map != null) {
			map.remove(key);
		}
	}
}