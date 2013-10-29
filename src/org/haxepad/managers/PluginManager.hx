package org.haxepad.managers;

import org.haxepad.plugins.IPlugin;
import org.haxepad.plugins.KeyboardPlugin;
import org.haxepad.util.XPathUtil;

class PluginManager {
	private static var _plugins:Array<IPlugin> = new Array<IPlugin>();
	
	public static function loadPluginFromXML(xml:Xml):IPlugin {
		var p:IPlugin = null;
		var type:String = XPathUtil.getXPathValue(xml, "/plugin/type/text()");
		if (type != null) {
			switch (type) {
				case "keyboard":
					p = new KeyboardPlugin();
				default:
			}
		}
		
		if (p != null) {
			p.fromXML(xml);
			registerPlugin(p);
		}
		
		return p;
	}
	
	public static function registerPlugin(plugin:IPlugin):Void {
		_plugins.push(plugin);
	}
	
	public static function getPlugins(type:Dynamic):Array<IPlugin> { 
		var array:Array<IPlugin> = new Array<IPlugin>();
		for (p in _plugins) {
			if (Std.is(p, type)) {
				array.push(p);
			}
		}
		return array;
	}
}