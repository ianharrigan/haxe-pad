package org.haxepad;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.containers.TabView;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.Spacer;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.MenuEvent;
import haxe.ui.toolkit.events.UIEvent;
import org.haxepad.managers.EventManager;
import org.haxepad.managers.PluginManager;
import org.haxepad.plugins.ICommandPlugin;
import org.haxepad.plugins.IPlugin;
import org.haxepad.plugins.IUserInterfacePlugin;
import org.haxepad.plugins.PluginEvent;
import org.haxepad.popups.AboutController;
import org.haxepad.managers.DocumentManager;
import org.haxepad.popups.FindController;
import org.haxepad.popups.FindReplaceController;
import org.haxepad.popups.PrefsController;
import org.haxepad.util.XPathUtil;

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
					showCustomPopup(new AboutController().view, "About", PopupButton.OK);
				default:
			}
		});

		attachEvent("toolbar-new", UIEvent.CLICK, function(e) {
			DocumentManager.newDocument();
		});
		
		attachEvent("toolbar-open", UIEvent.CLICK, function(e) {
			DocumentManager.openDocument();
		});

		attachEvent("toolbar-save", UIEvent.CLICK, function(e) {
			DocumentManager.saveActiveDocumentAs();
		});
		
		attachEvent("toolbar-find", UIEvent.CLICK, function(e) {
			findPopup();
		});

		attachEvent("toolbar-find-replace", UIEvent.CLICK, function(e) {
			findReplacePopup();
		});
		
		attachEvent("toolbar-settings", UIEvent.CLICK, function(e) {
			prefsPopup();
		});
		
		DocumentManager.documentTabs.addEventListener(UIEvent.GLYPH_CLICK, onTabGlyphClick);
		DocumentManager.documentTabs.addEventListener(UIEvent.CHANGE, onTabChange);
		DocumentManager.newDocument();
		
		loadCommandPlugins();
		loadUIPlugins();
	}
	
	private function findPopup():Void {
		var controller:FindController = new FindController();
		var config:Dynamic = { };
		config.buttons = [PopupButton.OK, PopupButton.CANCEL];
		config.modal = false;
		showCustomPopup(controller.view, "Find", config);
	}
	
	private function findReplacePopup():Void {
		var controller:FindReplaceController = new FindReplaceController();
		var config:Dynamic = { };
		config.buttons = [PopupButton.OK, PopupButton.CANCEL];
		config.modal = false;
		showCustomPopup(controller.view, "Replace", config);
	}

	private function prefsPopup():Void {
		var controller:PrefsController = new PrefsController();
		var config:Dynamic = { };
		config.buttons = [PopupButton.OK, PopupButton.CANCEL];
		config.styleName = "prefs-popup";
		config.width = 400;
		showCustomPopup(controller.view, "Settings", config);
	}
	
	private function onTabGlyphClick(event:UIEvent):Void {
		DocumentManager.closeDocument(event.data);
	}
	
	private function onTabChange(event:UIEvent):Void {
		var pluginEvent:PluginEvent = new PluginEvent(PluginEvent.DOCUMENT_SWITCH);
		EventManager.dispatchEvent(pluginEvent);
	}
	
	private function onCommandToolClick(event:UIEvent):Void {
		var data:Array<String> = event.component.userData.split(":");
		var p:ICommandPlugin = cast PluginManager.findPluginInstance(data[0]);
		if (p != null) {
			p.executeVerb(data[1]);
		}
	}
	
	private function loadCommandPlugins():Void {
		var toolbar:HBox = getComponentAs("toolbar", HBox);
		var insertPos:Int = toolbar.indexOfChild(toolbar.findChild("toolbar-find-replace")) + 1;
		var plugins:Array<IPlugin> = PluginManager.getUserPlugins(ICommandPlugin);
		if (plugins != null && plugins.length > 0) {
			for (p in plugins) {
				var cip:ICommandPlugin = cast(p, ICommandPlugin);
				var icons = XPathUtil.getXPathNodes(cip.configXML, "/config/icon");
				if (icons != null && icons.length > 0) {
					var spacer:Spacer = new Spacer();
					spacer.width = 5;
					toolbar.addChildAt(spacer, insertPos);
					insertPos++;
					
					for (i in icons) {
						var verb = i.get("verb");
						var icon = XPathUtil.getXPathValue(i, "text()");

						var button:Button = new Button();
						button.userData = p.id + ":" + verb;
						button.icon = icon;
						button.addEventListener(UIEvent.CLICK, onCommandToolClick);
						toolbar.addChildAt(button, insertPos);
						insertPos++;
					}
				}
			}
		}
	}
	
	private function loadUIPlugins():Void {
		var plugins:Array<IPlugin> = PluginManager.getUserPlugins(IUserInterfacePlugin);
		if (plugins != null && plugins.length > 0) {
			var vbox:VBox = getComponentAs("main-vbox", VBox);
			var hbox:HBox = getComponentAs("main-hbox", HBox);
			
			var rightCount:Int = 0;
			var leftCount:Int = 0;
			var topCount:Int = 0;
			var bottomCount:Int = 0;
			for (p in plugins) {
				var uip:IUserInterfacePlugin = cast(p, IUserInterfacePlugin);
				if (uip.location == "main") {
					var position:String = XPathUtil.getXPathValue(uip.configXML, "/config/position/text()");
					if (position == null) {
						position = "left";
					}
					var c:Component = uip.component;
					switch (position) {
						case "right":
							if (c.percentHeight > 0) {
								rightCount++;
							}
						case "left":
							if (c.percentHeight > 0) {
								leftCount++;
							}
						case "top":
							if (c.percentWidth > 0) {
								topCount++;	
							}
						case "bottom":
							if (c.percentWidth > 0) {
								bottomCount++;
							}
					}
				}
			}

			var vboxRight:VBox = null;
			var vboxLeft:VBox = null;
			
			for (p in plugins) {
				var uip:IUserInterfacePlugin = cast(p, IUserInterfacePlugin);
				if (uip.location == "main") {
					var position:String = XPathUtil.getXPathValue(uip.configXML, "/config/position/text()");
					if (position == null) {
						position = "left";
					}
					var c:Component = uip.component;
					switch (position) {
						case "right":
							if (vboxRight == null) {
								vboxRight = new VBox();
								vboxRight.percentHeight = 100;
								hbox.addChildAt(vboxRight, hbox.numChildren);
							}
							if (c.percentHeight > 0) {
								c.percentHeight = c.percentHeight / rightCount;
							}
							vboxRight.addChild(c);
						case "left":
							if (vboxLeft == null) {
								vboxLeft = new VBox();
								vboxLeft.percentHeight = 100;
								hbox.addChildAt(vboxLeft, 0);
							}
							if (c.percentHeight > 0) {
								c.percentHeight = c.percentHeight / leftCount;
							}
							vboxLeft.addChild(c);
						case "top":
							vbox.addChildAt(c, 0);
						case "bottom":
							vbox.addChildAt(c, vbox.numChildren);
					}
				}
			}
		}
	}
}