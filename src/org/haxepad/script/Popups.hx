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
		var p:Popup = PopupManager.instance.showSimple(RootManager.instance.roots[0], message, title);
		return p;
	}
	
	public function showList(items:Dynamic, title:String = "Haxe Pad", selectedIndex:Int = -1, modal:Bool = true):ListPopupWrapper {
		var p:Popup = PopupManager.instance.showList(RootManager.instance.roots[0], items, title, selectedIndex, modal);
		var wrapper:ListPopupWrapper = new ListPopupWrapper(p);
		return wrapper;
	}
}