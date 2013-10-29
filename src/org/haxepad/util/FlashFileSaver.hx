package org.haxepad.util;

import flash.events.Event;

class FlashFileSaver {
	private var _fr:flash.net.FileReference;
	private var _details:FileDetails;
	private var _fn:FileDetails->Void;
	
	public function new(details:FileDetails, fn:FileDetails->Void) {
		_details = details;
		_fn = fn;
		_fr = new flash.net.FileReference();

		_fr.addEventListener(Event.CANCEL, _onCancel);
		_fr.addEventListener(Event.COMPLETE, _onComplete);
		_fr.save(details.contents, details.name);
	}
	
	public function dispose():Void {
		_fr.removeEventListener(Event.CANCEL, _onCancel);
		_fr.removeEventListener(Event.COMPLETE, _onComplete);
	}
	
	private function _onCancel(event:Event):Void {
		dispose();
	}
	
	private function _onComplete(event:Event):Void {
		dispose();
		_details.name = _fr.name;
		if (_fn != null) {
			_fn(_details);
		}
	}
}