package org.haxepad.plugins;

interface ICommandPlugin extends IPlugin {
	public var verbMap(default, default):Map<String, String>;
	public function executeVerb(verb:String):Void;
}