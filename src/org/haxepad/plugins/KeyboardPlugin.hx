package org.haxepad.plugins;
import flash.ui.Keyboard;
import org.haxepad.util.XPathUtil;

class KeyboardPlugin extends Plugin implements IKeyboardPlugin {
	public var activationCtrlKey(default, default):Bool;
	public var activationKeyCode(default, default):UInt;
	public var deactivationCtrlKey(default, default):Bool;
	public var deactivationKeyCode(default, default):UInt;
	
	public function new() {
		super();
	}
	
	public override function fromXML(xml:Xml):Void {
		super.fromXML(xml);
		
		var keyCombo:String = XPathUtil.getXPathValue(xml, "/plugin/activation/keyCombination/text()");
		var keyArray:Array<String> = keyCombo.split("+");
		for (key in keyArray) {
			key = StringTools.trim(key);
			if (key.length > 0) {
				key = key.toUpperCase();
				switch (key) {
					case "CTRL":
						activationCtrlKey = true;
					default:
						activationKeyCode = getKeyCode(key);
				}
			}
		}
		
		var keyCombo:String = XPathUtil.getXPathValue(xml, "/plugin/deactivation/keyCombination/text()");
		var keyArray:Array<String> = keyCombo.split("+");
		for (key in keyArray) {
			key = StringTools.trim(key);
			if (key.length > 0) {
				key = key.toUpperCase();
				switch (key) {
					case "CTRL":
						deactivationCtrlKey = true;
					default:
						deactivationKeyCode = getKeyCode(key);
				}
			}
		}
	}
	
	private static function getKeyCode(s:String):Int {
		var code:Int = -1;
		switch (s) {
			case "TAB":
				code = Keyboard.TAB;
			default:
				code = -1;
		}
		return code;
	}
	
	public override function clone():IPlugin {
		var c:IKeyboardPlugin = cast(super.clone(), IKeyboardPlugin);
		c.activationCtrlKey = this.activationCtrlKey;
		c.activationKeyCode = this.activationKeyCode;
		c.deactivationCtrlKey = this.deactivationCtrlKey;
		c.deactivationKeyCode = this.deactivationKeyCode;
		return c;
	}
}