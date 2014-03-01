package org.haxepad;

import flash.events.Event;
import flash.events.KeyboardEvent;
import haxe.ui.dialogs.files.FileDetails;
import haxe.ui.toolkit.controls.extended.Code;
import haxe.ui.toolkit.core.XMLController;
import org.haxepad.util.FileInfo;

class DocumentController extends XMLController {
	private var _editor:Code;
	private var _fileDetails:FileDetails;

	public function new(fileDetails:FileDetails) {
		super("ui/document.xml");
		 _editor = getComponentAs("document-content", Code);
		 _editor.syntax = FileInfo.getSyntax(fileDetails.name);
		this.fileDetails = fileDetails;
		
		_editor.addEventListener(Event.ADDED_TO_STAGE, function(e) {
			_editor.focus();
		});
	}
	
	public var fileDetails(get, set):FileDetails;
	
	private function get_fileDetails():FileDetails {
		_fileDetails.contents = _editor.text;
		return _fileDetails;
	}
	
	private function set_fileDetails(value:FileDetails):FileDetails {
		_fileDetails = value;
		_editor.text = _fileDetails.contents;
		return value;
	}
}