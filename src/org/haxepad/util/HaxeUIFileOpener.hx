package org.haxepad.util;

import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.PopupManager.PopupConfig;
import haxe.ui.toolkit.core.RootManager;
import org.haxepad.managers.PrefsManager;
import org.haxepad.popups.FileSelectionController;

class HaxeUIFileOpener {
	private var _fn:FileDetails->Void;
	
	public function new(fn:FileDetails->Void) {
		_fn = fn;

		var controller:FileSelectionController = new FileSelectionController();
		var config:PopupConfig = new PopupConfig();
		config.addButton(PopupButtonType.CONFIRM);
		config.addButton(PopupButtonType.CANCEL);
		config.styleName = "file-selection-popup";
		var popup:Popup = PopupManager.instance.showCustom(RootManager.instance.roots[0], controller.view, "Open File", config, function (e) {
			if (e == PopupButtonType.CONFIRM) {
				PrefsManager.lastDir = controller.currentDir;
				var details = controller.selectedFile;
				if (_fn != null) {
					_fn(details);
				}
			}
		});
	}
}