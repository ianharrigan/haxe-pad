package org.haxepad.managers;

#if neko
import neko.vm.Thread;
#elseif cpp
import cpp.vm.Thread;
#end

import haxe.ui.dialogs.files.FileDetails;
import org.haxepad.plugins.PluginEvent;
import org.haxepad.util.FileInfo;
#if (!flash)
import sys.io.Process;
#end

class SystemManager {
	public function new() {
		
	}
	
	public static function exec(cmd:String, args:Array<String> = null):Int {
		#if (!flash)
		
		if (args == null) {
			args = [];
		}
		cmd = replaceStrings(cmd);
		
		var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_START);
		pluginEvent.data = "Running process: " + cmd;
		var argsCopy:Array<String> = new Array<String>();
		for (a in args) {
			a = replaceStrings(a);
			pluginEvent.data += " " + a;
			argsCopy.push(a);
		}
		EventManager.dispatchEvent(pluginEvent);

		var thread = Thread.create(doTest);
		thread.sendMessage(cmd);
		thread.sendMessage(argsCopy);
		
		return 0;
		
		var proc:Process = null;
		try {
			proc = new Process(cmd, argsCopy);
		} catch (e:Dynamic) {
			var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_STDERR);
			pluginEvent.data = e;
			EventManager.dispatchEvent(pluginEvent);
			return -1;
		}
		//var proc:Process = new Process("haxe", ["-cp", "C:/Temp/haxetest", "-main", "Main", "-swf", "C:/temp/haxetest/bob.swf"]);
		
		if (proc.stderr != null) {
			try {
				while (true) {
					var line:String = proc.stderr.readLine();
					/*
					var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_STDERR);
					pluginEvent.data = line;
					EventManager.dispatchEvent(pluginEvent);
					*/
					trace(line);
				}
			} catch (e:Dynamic) {
			}
		}
		if (proc.stdout != null) {
			try {
				while (true) {
					var line:String = proc.stdout.readLine();
					/*
					var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_STDOUT);
					pluginEvent.data = line;
					EventManager.dispatchEvent(pluginEvent);
					*/
					trace(line);
				}
			} catch (e:Dynamic) {
			}
		}
		
		/*
		var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_END);
		pluginEvent.data = "Done(" + proc.exitCode() + ")";
		EventManager.dispatchEvent(pluginEvent);
		*/
		
		trace("done!");
		
		return proc.exitCode();
		#else
		
		var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_STDOUT);
		pluginEvent.data = "Not supported";
		EventManager.dispatchEvent(pluginEvent);

		return -1;
		#end
	}
	
	private static function doTest():Void {
		trace("doTest");
		var cmd:String = Thread.readMessage(true);
		var argsCopy:Array<String> = Thread.readMessage(true);
		trace("cmd = " + cmd);
		trace("argsCopy = " + argsCopy);
		
		var proc:Process = null;
		try {
			proc = new Process(cmd, argsCopy);
		} catch (e:Dynamic) {
			/*
			var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_STDERR);
			pluginEvent.data = e;
			EventManager.dispatchEvent(pluginEvent);
			*/
			trace(e);
		}
		
		trace("running");
		Thread.create(outputStuff).sendMessage(proc.stderr);
		Thread.create(outputStuff).sendMessage(proc.stdout);
		
		/*
		if (proc.stderr != null) {
			try {
				while (true) {
					var line:String = proc.stderr.readLine();
					trace(line);
				}
			} catch (e:Dynamic) {
				trace(e);
			}
		}
		if (proc.stdout != null) {
			try {
				while (true) {
					var line:String = proc.stdout.readLine();
					trace(line);
				}
			} catch (e:Dynamic) {
				trace(e);
			}
		}
		*/
		
		/*
		var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_END);
		pluginEvent.data = "Done(" + proc.exitCode() + ")";
		EventManager.dispatchEvent(pluginEvent);
		*/
		
		trace("done!");
	}
	
	private static function outputStuff():Void {
		var thing = Thread.readMessage(true);
		
		if (thing != null) {
			try {
				while (true) {
					var line:String = thing.readLine();
					trace(line);
					var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.SYSTEM_COMMAND_STDOUT);
					pluginEvent.data = line;
					EventManager.dispatchEvent(pluginEvent);
				}
			} catch (e:Dynamic) {
				trace(e);
			}
		}
		
		trace("done outputting stuff");
	}
	
	private static function replaceStrings(s:String):String {
		for (varName in PrefsManager.getEnvironmentVarNames()) {
			var varValue = PrefsManager.getEnvironmentValue(varName);
			if (varValue != null) {
				s = StringTools.replace(s, "%" + varName + "%", varValue);
			}
		}
		
		var fileNameNoExt = "";
		if (DocumentManager.activeDocument.fileDetails.name != null) {
			fileNameNoExt = FileInfo.getNameNoExt(DocumentManager.activeDocument.fileDetails.name);
		}
		var fileDir = "";
		if (DocumentManager.activeDocument.fileDetails.filePath != null) {
			fileDir = FileInfo.getDir(DocumentManager.activeDocument.fileDetails.filePath);
		}
		
		#if !flash
		s = StringTools.replace(s, "%APP_PATH%", FileInfo.getDir(Sys.getCwd()));
		#end
		s = StringTools.replace(s, "%FILENAME_NOEXT%", fileNameNoExt);
		s = StringTools.replace(s, "%FILEDIR%", fileDir);
		return s;
	}
}