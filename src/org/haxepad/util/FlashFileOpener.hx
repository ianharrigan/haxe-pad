package org.haxepad.util;

import flash.events.Event;
import flash.utils.ByteArray;

class FlashFileOpener {
	private var _fr:flash.net.FileReference;
	private var _fn:FileDetails->Void;
	
	public function new(fn:FileDetails->Void) {
		_fn = fn;
		_fr = new flash.net.FileReference();
		
		_fr.addEventListener(Event.SELECT, _onSelect);
		_fr.addEventListener(Event.CANCEL, _onCancel);
		_fr.addEventListener(Event.COMPLETE, _onComplete);
		_fr.browse();
	}
	
	public function dispose():Void {
		_fr.removeEventListener(Event.SELECT, _onSelect);
		_fr.removeEventListener(Event.CANCEL, _onCancel);
		_fr.removeEventListener(Event.COMPLETE, _onComplete);
	}
	
	private function _onSelect(event:Event):Void {
		_fr.load();
	}
	
	private function _onCancel(event:Event):Void {
		dispose();
	}
	
	private function _onComplete(event:Event):Void {
		var ba:ByteArray = cast(_fr.data, ByteArray);
		var details:FileDetails = new FileDetails();
		details.name = _fr.name;
		details.contents = ba.toString();
		details.contents = StringTools.replace(details.contents, "\r", "");
		details.type = _fr.type;
		details.size = _fr.size;
		dispose();
		if (_fn != null) {
			_fn(details);
		}
	}
}