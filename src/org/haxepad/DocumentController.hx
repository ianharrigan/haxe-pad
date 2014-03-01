package org.haxepad;

import flash.events.Event;
import flash.events.KeyboardEvent;
import haxe.ui.dialogs.files.FileDetails;
import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.extended.Code;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.XMLController;
import org.haxepad.managers.PluginManager;
import org.haxepad.plugins.IPlugin;
import org.haxepad.plugins.IUserInterfacePlugin;
import org.haxepad.util.FileInfo;
import org.haxepad.util.XPathUtil;

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

		loadPlugins();
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
	
	private function loadPlugins():Void {
		var plugins:Array<IPlugin> = PluginManager.getUserPlugins(IUserInterfacePlugin);
		if (plugins != null && plugins.length > 0) {
			var vbox:VBox = getComponentAs("document-vbox", VBox);
			var hbox:HBox = getComponentAs("document-hbox", HBox);
			
			var rightCount:Int = 0;
			var leftCount:Int = 0;
			var topCount:Int = 0;
			var bottomCount:Int = 0;
			for (p in plugins) {
				var uip:IUserInterfacePlugin = cast(p, IUserInterfacePlugin);
				if (uip.location == "document") {
					uip.document = _editor;
					var position:String = XPathUtil.getXPathValue(uip.configXML, "/config/position/text()");
					if (position == null) {
						position = "right";
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
				if (uip.location == "document") {
					var position:String = XPathUtil.getXPathValue(uip.configXML, "/config/position/text()");
					if (position == null) {
						position = "right";
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