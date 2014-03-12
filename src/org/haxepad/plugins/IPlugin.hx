package org.haxepad.plugins;

interface IPlugin {
	public var id(default, default):String;
	public var name(default, default):String;
	public var configXML(default, default):Xml;
	public var activationScript(default, default):String;
	public var deactivationScript(default, default):String;
	public function fromXML(xml:Xml):Void;
	public function init():Void;
	public var excludePlatforms(default, default):String;
	
	public function clone():IPlugin;
}