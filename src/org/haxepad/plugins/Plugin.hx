package org.haxepad.plugins;
import org.haxepad.util.XPathUtil;

class Plugin implements IPlugin {
	public var id(default, default):String;
	public var name(default, default):String;
	public var configXML(default, default):Xml;
	public var activationScript(default, default):String;
	public var deactivationScript(default, default):String;
	
	public function new() {
		
	}
	
	public function init():Void {
		
	}
	
	public function fromXML(xml:Xml):Void {
		id = XPathUtil.getXPathValue(xml, "/plugin/id/text()");
		name = XPathUtil.getXPathValue(xml, "/plugin/name/text()");
		activationScript = XPathUtil.getXPathValue(xml, "/plugin/activation/script/text()");
		deactivationScript = XPathUtil.getXPathValue(xml, "/plugin/deactivation/script/text()");
	}
	
	public function clone():IPlugin {
		var c:IPlugin = Type.createInstance(Type.getClass(this), []);
		c.id = this.id;
		c.name = this.name;
		c.configXML = this.configXML;
		c.activationScript = this.activationScript;
		c.deactivationScript = this.deactivationScript;
		return c;
	}
}