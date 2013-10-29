package org.haxepad.plugins;
import org.haxepad.util.XPathUtil;

class Plugin implements IPlugin {
	public var id(default, default):String;
	public var activationScript(default, default):String;
	public var deactivationScript(default, default):String;
	
	public function new() {
		
	}
	
	public function fromXML(xml:Xml):Void {
		id = XPathUtil.getXPathValue(xml, "/plugin/id/text()");
		activationScript = XPathUtil.getXPathValue(xml, "/plugin/activation/script/text()");
		deactivationScript = XPathUtil.getXPathValue(xml, "/plugin/deactivation/script/text()");
	}
}