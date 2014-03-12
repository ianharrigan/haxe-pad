package org.haxepad.script.wrappers;

import haxe.ui.dialogs.files.FileDetails;
import org.haxepad.DocumentController;

class DocumentControllerWrapper {
	private var _controller:DocumentController;
	public function new(controller:DocumentController) {
		_controller = controller;
	}
	
	public function getFileDetails():FileDetails {
		return _controller.fileDetails;
	}
}