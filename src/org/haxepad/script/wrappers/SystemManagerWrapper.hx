package org.haxepad.script.wrappers;
import org.haxepad.managers.SystemManager;

class SystemManagerWrapper {
	public function new() {
	}
	
	public function exec(cmd:String):Void {
		var arr:Array<String> = cmd.split(" ");
		var args:Array<String> = new Array<String>();
		cmd = arr[0];
		for (x in 1...arr.length) {
			args.push(arr[x]);
		}
		SystemManager.exec(cmd, args);
	}
}