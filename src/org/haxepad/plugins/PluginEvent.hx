package org.haxepad.plugins;

import flash.events.Event;

class PluginEvent extends Event {
	public static inline var DOCUMENT_ADD:String = "document.add";
	public static inline var DOCUMENT_OPEN:String = "document.open";
	public static inline var DOCUMENT_CLOSE:String = "document.close";
	public static inline var DOCUMENT_SWITCH:String = "document.switch";
	
	public static inline var SYSTEM_COMMAND_START:String = "command.start";
	public static inline var SYSTEM_COMMAND_END:String = "command.end";
	public static inline var SYSTEM_COMMAND_STDERR:String = "command.stderr";
	public static inline var SYSTEM_COMMAND_STDOUT:String = "command.stdout";
	
	public var data(default, default):Dynamic;
	
	public function new(type:String) {
		super(type);
	}
}