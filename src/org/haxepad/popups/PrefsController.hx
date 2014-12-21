package org.haxepad.popups;

import flash.events.Event;
import haxe.ui.toolkit.core.XMLController;
import org.haxepad.managers.PrefsManager;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/ui/preferences/main.xml"))
class PrefsController extends XMLController {
	public function new() {
		lastDir.text = PrefsManager.lastDir;
		environmentVars.text = PrefsManager.environmentVars;
	}
	
	public function savePrefs():Void {
		PrefsManager.lastDir = lastDir.text;
		if (environmentVars.text.length == 0) {
			PrefsManager.environmentVars = null;
		} else {
			PrefsManager.environmentVars = environmentVars.text;
		}
	}
}