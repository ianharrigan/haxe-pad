package org.haxepad.managers;

import flash.events.KeyboardEvent;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Screen;
import org.haxepad.plugins.IKeyboardPlugin;
import org.haxepad.plugins.IPlugin;
import org.haxepad.util.ScriptUtil;

class KeyboardManager {
	private static var _root:Root;
	public static var root(get, null):Root;
	private static function get_root():Root {
		return _root;
	}
	
	private static var _oldFocus:Dynamic;
	
	public static function init(root:Root):Void {
		_root = root;
		_root.sprite.stage.tabChildren = false;
		_root.sprite.stage.stageFocusRect = false;
		
		
		Screen.instance.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 1000);
		Screen.instance.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 1000);
	}
	
	// TODO: method needs to be cleared, not correct way to go about things
	private static function onKeyDown(event:KeyboardEvent):Void {
		var plugins:Array<IPlugin> = PluginManager.getUserPlugins(IKeyboardPlugin);
		if (plugins != null && plugins.length > 0) {
			for (p in plugins) {
				var kp:IKeyboardPlugin = cast(p, IKeyboardPlugin);
				if (kp.activationCtrlKey == event.ctrlKey && kp.activationKeyCode == event.keyCode) {
					event.stopPropagation();
					event.stopImmediatePropagation();
					#if flash
					event.preventDefault();
					if (event.ctrlKey && _oldFocus == null) {
						_oldFocus = _root.sprite.stage.focus;
						_root.sprite.stage.focus = _root.sprite;
					}
					#end
					
					ScriptUtil.exec(kp.activationScript, kp.id);
				}
			}
		}
		
	}
	
	// TODO: method needs to be cleared, not correct way to go about things
	private static function onKeyUp(event:KeyboardEvent):Void {
		var ctrlKey:Bool = event.ctrlKey;
		
		if (event.keyCode == 17) {
			ctrlKey = true;
			if (_oldFocus != null) {
				_root.sprite.stage.focus = _oldFocus;
				_oldFocus = null;
			}
			
			var plugins:Array<IPlugin> = PluginManager.getUserPlugins(IKeyboardPlugin);
			if (plugins != null && plugins.length > 0) {
				for (p in plugins) {
					var kp:IKeyboardPlugin = cast(p, IKeyboardPlugin);
					if (kp.deactivationCtrlKey == ctrlKey) {
						ScriptUtil.exec(kp.deactivationScript, kp.id);
					}
				}
			}
		}
	}
	
	//private static function isKeyMatch
}