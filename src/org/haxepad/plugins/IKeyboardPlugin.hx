package org.haxepad.plugins;

interface IKeyboardPlugin extends IPlugin {
	public var activationCtrlKey(default, default):Bool;
	public var activationKeyCode(default, default):UInt;
	public var deactivationCtrlKey(default, default):Bool;
	public var deactivationKeyCode(default, default):UInt;
}