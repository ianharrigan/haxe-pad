package org.haxepad.managers;

import org.haxepad.plugins.IPlugin;
import org.haxepad.plugins.KeyboardPlugin;
import org.haxepad.plugins.UserInterfacePlugin;
import org.haxepad.util.XPathUtil;

class PluginManager {
	private static var _plugins:Array<IPlugin> = new Array<IPlugin>();
	private static var _userPlugins:Array<IPlugin> = new Array<IPlugin>();
	
	public static function loadPluginFromXML(xml:Xml):IPlugin {
		var p:IPlugin = null;
		var type:String = XPathUtil.getXPathValue(xml, "/plugin/type/text()");
		if (type != null) {
			switch (type) {
				case "keyboard":
					p = new KeyboardPlugin();
				case "ui":
					p = new UserInterfacePlugin();
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
	
	public static function loadUserPlugins(xml:Xml):Void {
		var plugins:Array<Xml> = XPathUtil.getXPathNodes(xml, "/plugins/plugin");
		for (p in plugins) {
			var id:String = XPathUtil.getXPathValue(p, "id/text()");
			var config:Xml = XPathUtil.getXPathNode(p, "config");
			addUserPlugin(id, config);
		}
	}
	
	public static function addUserPlugin(id:String, configXML:Xml = null):Void {
		for (p in _plugins) {
			if (p.id == id) {
				var c:IPlugin = p.clone();
				if (configXML != null) {
					c.configXML = Xml.parse(configXML.toString());
				}
				//c.init();
				_userPlugins.push(c);
			}
		}
	}
	
	public static function getUserPlugins(type:Dynamic):Array<IPlugin> { 
		var array:Array<IPlugin> = new Array<IPlugin>();
		for (p in _userPlugins) {
			if (Std.is(p, type)) {
				var c:IPlugin = p.clone();
				c.init();
				array.push(c);
			}
		}
		return array;
	}
	
	public static function findUserPlugin(id:String):IPlugin {
		for (p in _userPlugins) {
			if (p.id == id) {
				return p;
			}
		}
		return null;
	}
}