package org.haxepad.plugins;

import org.haxepad.util.ScriptUtil;
import org.haxepad.util.XPathUtil;

class CommandPlugin extends Plugin implements ICommandPlugin {
	public var verbMap(default, default):Map<String, String>;
	
	public function new() {
		super();
		verbMap = new Map<String, String>();
	}
	
	public override function fromXML(xml:Xml):Void {
		super.fromXML(xml);

		var verbNodes = XPathUtil.getXPathNodes(xml, "/plugin/verb");
		for (verbNode in verbNodes) {
			var verbName:String = verbNode.get("name");
			var script:String = XPathUtil.getXPathValue(verbNode, "text()");
			verbMap.set(verbName, script);
		}
	}
	
	public function executeVerb(verb:String):Void {
		var script:String = verbMap.get(verb);
		if (script != null) {
			executeScript(script);
		}
	}
	
	private function executeScript(script:String):Void {
		var objects:Map<String, Dynamic> = new Map<String, Dynamic>();
		ScriptUtil.exec(script, id, objects);
	}
}