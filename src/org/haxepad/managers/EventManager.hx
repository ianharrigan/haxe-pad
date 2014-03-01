package org.haxepad.managers;

import flash.events.Event;
import flash.events.EventDispatcher;

class EventManager {
	private static var _dispatcher:EventDispatcher = new EventDispatcher();
	public function new() {
		
	}

	public static function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	public static function dispatchEvent(event:Event):Bool {
		return _dispatcher.dispatchEvent(event);
	}
	
	public static function hasEventListener(type:String):Bool {
		return _dispatcher.hasEventListener(type);
	}
	
	public static function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		_dispatcher.removeEventListener(type, listener, useCapture);
	}
	
	public static function willTrigger(type:String):Bool {
		return _dispatcher.willTrigger(type);
	}
}