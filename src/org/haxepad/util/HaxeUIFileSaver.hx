package org.haxepad.util;

import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.PopupManager.PopupConfig;
import haxe.ui.toolkit.core.RootManager;
import org.haxepad.managers.PrefsManager;
import org.haxepad.popups.FileSelectionController;

class HaxeUIFileSaver {
	private var _fn:FileDetails->Void;
	
	public function new(details:FileDetails, fn:FileDetails->Void) {
		_fn = fn;

		var controller:FileSelectionController = new FileSelectionController(false);
		var config:PopupConfig = new PopupConfig();
		config.addButton(PopupButtonType.CONFIRM);
		config.addButton(PopupButtonType.CANCEL);
		config.styleName = "file-selection-popup";

		var popup:Popup = PopupManager.instance.showCustom(RootManager.instance.roots[0], controller.view, "Save File", config, function (e) {
			if (e == PopupButtonType.CONFIRM) {
				PrefsManager.lastDir = controller.currentDir;
				var selectedDetails = controller.selectedFile;
				if (FileSystemHelper.exists(selectedDetails.filePath)) {
					PopupManager.instance.showSimple(RootManager.instance.roots[0], "File exists, overwrite?", "Overwrite File", PopupButtonType.YES | PopupButtonType.NO, function(e) {
						if (e == PopupButtonType.YES) {
							FileSystemHelper.writeFile(selectedDetails.filePath, details.contents);
							details.name = selectedDetails.name;
							details.filePath = selectedDetails.filePath;
							if (_fn != null) {
								_fn(details);
							}
						}
					});
				} else {
					FileSystemHelper.writeFile(selectedDetails.filePath, details.contents);
					details.name = selectedDetails.name;
					details.filePath = selectedDetails.filePath;
					if (_fn != null) {
						_fn(details);
					}
				}
			}
		});
	}
}