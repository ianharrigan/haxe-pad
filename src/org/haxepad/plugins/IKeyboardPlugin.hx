package org.haxepad.plugins;

interface IKeyboardPlugin extends IPlugin {
	public var activationCtrlKey(default, default):Bool;
	public var activationKeyCode(default, default):Int;
	public var deactivationCtrlKey(default, default):Bool;
	public var deactivationKeyCode(default, default):Int;
}