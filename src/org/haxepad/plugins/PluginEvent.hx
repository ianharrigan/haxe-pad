package org.haxepad.plugins;

import flash.events.Event;

class PluginEvent extends Event {
	public static inline var DOCUMENT_ADD:String = "document.add";
	public static inline var DOCUMENT_OPEN:String = "document.open";
	public static inline var DOCUMENT_CLOSE:String = "document.close";
	
	public function new(type:String) {
		super(type);
	}
}