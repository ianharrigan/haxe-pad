package org.haxepad.managers;

import org.haxepad.util.FileDetails;
#if flash
import org.haxepad.util.FlashFileOpener;
import org.haxepad.util.FlashFileSaver;
#else
import org.haxepad.util.HaxeUIFileOpener;
import org.haxepad.util.HaxeUIFileSaver;
#end

#if air
import org.haxepad.util.HaxeUIFileOpener;
import org.haxepad.util.HaxeUIFileSaver;
#end

class FileSystemManager {
	public function new() {
		
	}

	public static function openFile(fn:FileDetails->Void):Void {
		#if flash
			#if air
				new HaxeUIFileOpener(fn);
			#else
				new FlashFileOpener(fn);
			#end
		#else
			new HaxeUIFileOpener(fn);
		#end
	}
	
	public static function saveFileAs(details:FileDetails, fn:FileDetails->Void):Void {
		#if flash
			#if air
				new HaxeUIFileSaver(details, fn);
			#else
				new FlashFileSaver(details, fn);
			#end
		#else
			new HaxeUIFileSaver(details, fn);
		#end
	}
}