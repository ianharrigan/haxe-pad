package org.haxepad.script;

import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.controls.popups.PopupContent;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.RootManager;
import org.haxepad.script.wrappers.ListPopupWrapper;

class Popups {
	public function new() {
		
	}
	
	public function messageBox(message:String, title:String = "Haxe Pad"):Popup {
		var p:Popup = PopupManager.instance.showSimple(message, title);
		return p;
	}
	
	public function showList(items:Dynamic, selectedIndex:Int = -1, title:String = "Haxe Pad", modal:Bool = true):ListPopupWrapper {
		var config:Dynamic = { modal: modal};
		var p:Popup = PopupManager.instance.showList(items, selectedIndex, title, config);
		var wrapper:ListPopupWrapper = new ListPopupWrapper(p);
		return wrapper;
	}
}