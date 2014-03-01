package org.haxepad.plugins;

import haxe.ui.toolkit.core.Controller;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.util.Identifier;
import org.haxepad.managers.EventManager;
import org.haxepad.script.wrappers.ComponentWrapper;
import org.haxepad.util.ScriptUtil;
import org.haxepad.util.XPathUtil;

import haxe.ui.toolkit.core.Component;

class UserInterfacePlugin extends Plugin implements IUserInterfacePlugin {
	public var location(default, default):String;
	public var ui(default, default):Xml;
	public var component(default, default):Component;
	public var eventMap(default, default):Map<String, String>;
	
	private var _uid:String;
	private var _controller:Controller;
	
	public function new() {
		super();
		eventMap = new Map<String, String>();
	}
	
	public override function fromXML(xml:Xml):Void {
		super.fromXML(xml);
		
		location = XPathUtil.getXPathValue(xml, "/plugin/location/text()");
		ui = Xml.parse(XPathUtil.getXPathNode(xml, "/plugin/ui").firstElement().toString());
		
		var eventNodes = XPathUtil.getXPathNodes(xml, "/plugin/event");
		for (eventNode in eventNodes) {
			var eventTypes:String = eventNode.get("type");
			var eventTypesArr:Array<String> = eventTypes.split(",");
			for (eventType in eventTypesArr) {
				eventType = StringTools.trim(eventType);
				var script:String = XPathUtil.getXPathValue(eventNode, "text()");
				eventMap.set(eventType, script);
			}
		}

	}
	
	public override function init():Void {
		super.init();
		_uid = Identifier.createObjectId(this);
		component = Toolkit.processXml(ui);
		
		for (eventType in eventMap.keys()) {
			EventManager.addEventListener(eventType, onPluginEvent);
		}
	}
	
	private function onPluginEvent(event:PluginEvent):Void {
		var script:String = eventMap.get(event.type);
		
		var objects:Map<String, Dynamic> = new Map<String, Dynamic>();		
		if (_controller == null) {
			_controller = new Controller(component);
		}
		objects.set("controller", _controller);
		objects.set("view", _controller.view);
		for (c in _controller.namedComponents) {
			var d:Dynamic = _controller.getComponentAs(c.id, Type.getClass(c));
			objects.set(c.id, new ComponentWrapper(d));
		}
		
		ScriptUtil.exec(script, _uid, objects);
	}
	
	public override function clone():IPlugin {
		var c:IUserInterfacePlugin = cast(super.clone(), IUserInterfacePlugin);
		c.location = this.location;
		c.ui = this.ui;
		c.component = this.component;
		c.eventMap = this.eventMap;
		return c;
	}
}