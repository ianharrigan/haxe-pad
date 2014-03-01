package org.haxepad.plugins;

import haxe.ui.toolkit.core.Component;

interface IUserInterfacePlugin extends IPlugin {
	public var location(default, default):String;
	public var ui(default, default):Xml;
	public var component(default, default):Component;
	public var eventMap(default, default):Map<String, String>;
}