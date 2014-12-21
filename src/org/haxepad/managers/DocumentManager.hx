package org.haxepad.managers;

import flash.events.Event;
import haxe.ui.dialogs.files.FileDetails;
import haxe.ui.dialogs.files.FileDialogs;
import haxe.ui.dialogs.files.FileSystemHelper;
import haxe.ui.dialogs.files.FileType;
import haxe.ui.toolkit.containers.TabView;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.Controller;
import org.haxepad.DocumentController;
import org.haxepad.plugins.PluginEvent;
import org.haxepad.util.FileInfo;

class DocumentManager {
	private static var _documentControllers:Array<DocumentController> = new Array<DocumentController>();
	public static var documentTabs(default, default):TabView;

	public static var activeDocumentIndex(get, set):Int;
	public static var activeDocument(get, null):DocumentController;
	public static var documentCount(get, null):Int;
	
	private static function get_activeDocumentIndex():Int {
		return documentTabs.selectedIndex;
	}

	private static function set_activeDocumentIndex(value:Int):Int {
		documentTabs.selectedIndex = value;
		return value;
	}
	
	private static function get_activeDocument():DocumentController {
		return _documentControllers[activeDocumentIndex];
	}
	
	private static function get_documentCount():Int {
		return _documentControllers.length;
	}
	
	public static function newDocument():Void {
		var details:FileDetails = new FileDetails();
		details.name = "Untitled.txt";
		details.contents = "";
		addDocument(details);
	}
	
	public static function openDocument():Void {
		FileDialogs.openFile({dir: PrefsManager.lastDir, readContents: true}, function(details:FileDetails) {
			if (details != null) {
				#if !flash
					PrefsManager.lastDir = StringTools.replace(details.filePath, details.name, "");
				#end
				addDocument(details);
				
				var event:PluginEvent = new PluginEvent(PluginEvent.DOCUMENT_OPEN);
				EventManager.dispatchEvent(event);
			}
		});
	}
	
	public static function addDocument(details:FileDetails):Void {
		var controller:DocumentController = new DocumentController(details);
		_documentControllers.push(controller);
		cast(controller.view, Component).text = details.name;
		var styleName:String = FileInfo.getStyle(details.name);
		documentTabs.addChild(controller.view);
		documentTabs.selectedIndex = documentTabs.pageCount - 1;
		
		var event:PluginEvent = new PluginEvent(PluginEvent.DOCUMENT_ADD);
		EventManager.dispatchEvent(event);
	}
	
	public static function closeDocument(index:Int):Void {
		documentTabs.removeTab(index);
		_documentControllers.remove(_documentControllers[index]);
		if (documentTabs.pageCount == 0) {
			newDocument();
		}
		
		var event:PluginEvent = new PluginEvent(PluginEvent.DOCUMENT_CLOSE);
		EventManager.dispatchEvent(event);
	}
	
	public static function saveDocument(index:Int):Void {
		var controller:DocumentController = _documentControllers[index];
		
		var details:FileDetails = controller.fileDetails;
		if (details.filePath == null) {
			saveDocumentAs(index);
		} else {
			#if flash
			details.contents = StringTools.replace(controller.fileDetails.contents, "\r", "\r\n");
			#else
			details.contents = StringTools.replace(controller.fileDetails.contents, "\n", "\r\n");
			#end
			
			#if flash
				#if air
					FileSystemHelper.writeFile(details.filePath, details.contents);
					controller.dirty = false;
				#else
					saveDocumentAs(index);
				#end
			#else
				FileSystemHelper.writeFile(details.filePath, details.contents);
				controller.dirty = false;
			#end
		}
	}
	
	public static function saveDocumentAs(index:Int):Void {
		var controller:DocumentController = _documentControllers[index];

		var details:FileDetails = new FileDetails();
		details.name = controller.fileDetails.name;
		if (controller.fileDetails.contents != null) {
			#if flash
			details.contents = StringTools.replace(controller.fileDetails.contents, "\r", "\r\n");
			#else
			details.contents = StringTools.replace(controller.fileDetails.contents, "\n", "\r\n");
			#end
		}

		FileDialogs.saveFileAs({}, details, function(details:FileDetails) {
			PrefsManager.lastDir = StringTools.replace(details.filePath, details.name, "");
			documentTabs.setTabText(index, details.name);
			controller.dirty = false;
		});
	}
	
	public static function saveActiveDocumentAs():Void {
		saveDocumentAs(documentTabs.selectedIndex);
	}

	public static function saveActiveDocument():Void {
		saveDocument(documentTabs.selectedIndex);
	}
	
	public static function listDocuments():Array<Dynamic> {
		var array:Array<Dynamic> = new Array<Dynamic>();
		for (controller in _documentControllers) {
			var o = {
				text: controller.fileDetails.name,
				icon: FileType.getIcon(controller.fileDetails.name)
			}
			array.push(o);
		}
		
		return array;
	}
	
	public static function findTabFromDocument(doc:DocumentController):Button {
		var index:Int = Lambda.indexOf(_documentControllers, doc);
		return documentTabs.getTabButton(index);
	}
}