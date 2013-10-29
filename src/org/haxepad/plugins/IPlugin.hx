package org.haxepad.plugins;

interface IPlugin {
	public var id(default, default):String;
	public var activationScript(default, default):String;
	public var deactivationScript(default, default):String;
	public function fromXML(xml:Xml):Void;
}