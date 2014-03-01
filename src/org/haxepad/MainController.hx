package org.haxepad;

import haxe.ui.toolkit.containers.TabView;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.MenuEvent;
import haxe.ui.toolkit.events.UIEvent;
import org.haxepad.managers.EventManager;
import org.haxepad.plugins.PluginEvent;
import org.haxepad.popups.AboutController;
import org.haxepad.managers.DocumentManager;
import org.haxepad.popups.FindController;
import org.haxepad.popups.FindReplaceController;
import org.haxepad.popups.PrefsController;

class MainController extends XMLController {

	public function new() {
		super("ui/main.xml");
		
		DocumentManager.documentTabs = getComponentAs("document-tabs", TabView);

		attachEvent("menu-file", MenuEvent.SELECT, function(e:MenuEvent) {
			switch (e.menuItem.id) {
				case "menu-file-new":
					DocumentManager.newDocument();
				case "menu-file-open":
					DocumentManager.openDocument();
				case "menu-file-save":
				case "menu-file-save-as":
					DocumentManager.saveActiveDocumentAs();
				default:
			}
		});

		attachEvent("menu-search", MenuEvent.SELECT, function(e:MenuEvent) {
			switch (e.menuItem.id) {
				case "menu-search-find":
					findPopup();
				case "menu-search-find-replace":
					findReplacePopup();
				default:
			}
		});
		
		attachEvent("menu-program", MenuEvent.SELECT, function(e:MenuEvent) {
			switch (e.menuItem.id) {
				case "menu-program-prefs":
					prefsPopup();
				default:
			}
		});
		
		attachEvent("menu-help", MenuEvent.SELECT, function(e:MenuEvent) {
			switch (e.menuItem.id) {
				case "menu-help-about":
					PopupManager.instance.showCustom(root, new AboutController().view, "About", PopupButtonType.OK);
				default:
			}
		});

		
		DocumentManager.documentTabs.addEventListener(UIEvent.GLYPH_CLICK, onTabGlyphClick);
		DocumentManager.documentTabs.addEventListener(UIEvent.CHANGE, onTabChange);
		DocumentManager.newDocument();
	}
	
	private function findPopup():Void {
		var controller:FindController = new FindController();
		var config:PopupConfig = new PopupConfig();
		config.addButton(PopupButtonType.OK);
		config.addButton(PopupButtonType.CANCEL);
		config.modal = false;
		PopupManager.instance.showCustom(root, controller.view, "Find", config);
	}
	
	private function findReplacePopup():Void {
		var controller:FindReplaceController = new FindReplaceController();
		var config:PopupConfig = new PopupConfig();
		config.addButton(PopupButtonType.OK);
		config.addButton(PopupButtonType.CANCEL);
		config.modal = false;
		PopupManager.instance.showCustom(root, controller.view, "Replace", config);
	}

	private function prefsPopup():Void {
		var controller:PrefsController = new PrefsController();
		var config:PopupConfig = new PopupConfig();
		config.addButton(PopupButtonType.OK);
		config.addButton(PopupButtonType.CANCEL);
		config.styleName = "prefs-popup";
		PopupManager.instance.showCustom(root, controller.view, "Settings", config);
	}
	
	private function onTabGlyphClick(event:UIEvent):Void {
		DocumentManager.closeDocument(event.data);
	}
	
	private function onTabChange(event:UIEvent):Void {
		var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.DOCUMENT_SWITCH);
		EventManager.dispatchEvent(pluginEvent);
	}
}