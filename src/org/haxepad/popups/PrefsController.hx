package org.haxepad.popups;

import flash.events.Event;
import haxe.ui.toolkit.core.XMLController;
import org.haxepad.managers.PrefsManager;

class PrefsController extends XMLController {
	public function new() {
		super("ui/preferences/main.xml");
		
		attachEvent("prefs-accordion", Event.CHANGE, function(e) { // TODO: need to work out a better way of doing this, the problem is that the accordion controls dont exist until the page is opened
			refereshNamedComponents();
			if (getComponent("lastDir") != null) {
				getComponent("lastDir").text = PrefsManager.lastDir;
			}
		});
	}
}