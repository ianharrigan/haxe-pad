package org.haxepad.script.wrappers;

import haxe.ui.toolkit.controls.popups.ListPopupContent;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.PopupManager;

class ListPopupWrapper {
	private var _popup:Popup;
	private var _content:ListPopupContent;
	
	public function new(popup:Popup) {
		_popup = popup;
		_content = cast(popup.content, ListPopupContent);
	}
	
	public function getListSize():Int {
		return _content.listSize;
	}
	
	public function setSelectedIndex(index:Int, raiseEvent:Bool):Void {
		if (raiseEvent == false) {
			_content.setSelectedIndexNoEvent(index);
		} else {
			_content.selectedIndex = index;
		}
	}
	
	public function getSelectedIndex():Int {
		return _content.selectedIndex;
	}
	
	public function close():Void {
		PopupManager.instance.hidePopup(_popup);
	}
}