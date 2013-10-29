package org.haxepad.script.wrappers;
import org.haxepad.managers.DocumentManager;

class DocumentManagerWrapper {
	public function new() {
		
	}
	
	public function listDocuments():Array<Dynamic> {
		return DocumentManager.listDocuments();
	}
	
	public function getActiveIndex():Int {
		return DocumentManager.activeDocumentIndex;
	}
	
	public function setActiveIndex(value:Int):Void {
		DocumentManager.activeDocumentIndex = value;
	}
	
	public function getDocumentCount():Int {
		return DocumentManager.documentCount;
	}
}