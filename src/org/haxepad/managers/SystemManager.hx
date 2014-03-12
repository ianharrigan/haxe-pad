package org.haxepad.managers;

import org.haxepad.plugins.PluginEvent;
import org.haxepad.util.FileInfo;
#if (!flash)
import sys.io.Process;
#end

class SystemManager {
	public function new() {
		
	}
	
	public static function exec(cmd:String, args:Array<String> = null):Void {
		#if (!flash)
		
		if (args == null) {
			args = [];
		}
		
		if (cmd == "%PREF_FLASH_PLAYER%") {
			cmd = PrefsManager.getPref("flashPlayer");
		}
		
		var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_START);
		pluginEvent.data = "Running process: " + cmd;
		var fileNameNoExt = "";
		if (DocumentManager.activeDocument.fileDetails.name != null) {
			fileNameNoExt = FileInfo.getNameNoExt(DocumentManager.activeDocument.fileDetails.name);
		}
		var fileDir = "";
		if (DocumentManager.activeDocument.fileDetails.filePath != null) {
			fileDir = FileInfo.getDir(DocumentManager.activeDocument.fileDetails.filePath);
		}
		var argsCopy:Array<String> = new Array<String>();
		for (a in args) {
			a = StringTools.replace(a, "%FILENAME_NOEXT%", fileNameNoExt);
			a = StringTools.replace(a, "%FILEDIR%", fileDir);
			pluginEvent.data += " " + a;
			argsCopy.push(a);
		}
		EventManager.dispatchEvent(pluginEvent);

		var proc:Process = new Process(cmd, argsCopy);
		//var proc:Process = new Process("haxe", ["-cp", "C:/Temp/haxetest", "-main", "Main", "-swf", "C:/temp/haxetest/bob.swf"]);
		
		if (proc.stderr != null) {
			try {
				while (true) {
					var line:String = proc.stderr.readLine();
					var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_STDERR);
					pluginEvent.data = line;
					EventManager.dispatchEvent(pluginEvent);
				}
			} catch (e:Dynamic) {
			}
		}
		if (proc.stdout != null) {
			try {
				while (true) {
					var line:String = proc.stdout.readLine();
					var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_STDOUT);
					pluginEvent.data = line;
					EventManager.dispatchEvent(pluginEvent);
				}
			} catch (e:Dynamic) {
			}
		}
		
		var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_END);
		pluginEvent.data = "Done(" + proc.exitCode() + ")";
		EventManager.dispatchEvent(pluginEvent);
		
		#else
		
		var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_STDOUT);
		pluginEvent.data = "Not supported";
		EventManager.dispatchEvent(pluginEvent);
		
		#end
	}
}