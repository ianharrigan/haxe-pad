package org.haxepad.popups;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.popups.PopupContent;
import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.core.PopupManager.PopupButtonType;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.data.ArrayDataSource;
import org.haxepad.managers.PrefsManager;
import org.haxepad.util.FileDetails;
import org.haxepad.util.FileSystemHelper;
import org.haxepad.util.FileType;

class FileSelectionController extends XMLController {
	private var _currentDir:String;
	private var _contentsList:ListView;
	private var _path:HBox;
	private var _filename:TextInput;
	private var _readContents:Bool;
	
	public function new(readContents:Bool = true) {
		super("ui/popups/file-selection.xml");
		
		_readContents = readContents;
		_path = getComponentAs("path", HBox);
		_contentsList = getComponentAs("contents", ListView);
		_contentsList.addEventListener(Event.CHANGE, _onListChange);
		_contentsList.addEventListener(MouseEvent.DOUBLE_CLICK, _onListDblClick);
		_filename = getComponentAs("filename", TextInput);
		
		loadDirContents();
	}
	
	private function loadDirContents(path:String = null):Void {
		_contentsList.dataSource.removeAll();
		if (path == null) {
			path = PrefsManager.lastDir;
			if (path == null || path.length == 0) {
				path = FileSystemHelper.getCwd();
			}
		}
		path = FileSystemHelper.normalizePath(path);
		_currentDir = path;
		var contents:Array<String> = FileSystemHelper.readDirectory(path);
		for (item in contents) {
			if (FileSystemHelper.isDirectory(path + "/" + item) == true) {
				_contentsList.dataSource.add( { text: item, icon: "img/icons/folder-horizontal.png" } );
			}
		}
		
		for (item in contents) {
			if (FileSystemHelper.isDirectory(path + "/" + item) == false) {
				_contentsList.dataSource.add( { text: item, icon: getFileIcon(item) } );
			}
		}
		
		_filename.text = "";
		refreshPathControls(_currentDir);
	}
	
	private function refreshPathControls(path:String):Void {
		_path.removeAllChildren();
		var arr:Array<String> = path.split("/");
		for (a in arr) {
			var button:Button = new Button();
			button.text = a;
			button.addEventListener(MouseEvent.CLICK, buildPathClickFunction(_path.numChildren));
			_path.addChild(button);
		}
	}
	
	private function _onListChange(event:Event):Void {
		var dir:String = _currentDir;
		if (StringTools.endsWith(dir, "/") == false && StringTools.endsWith(dir, "\\") == false) {
			dir += "/";
		}
		var newDir:String = FileSystemHelper.normalizePath(dir + _contentsList.selectedItems[0].text);
		if (FileSystemHelper.isDirectory(newDir) == false) {
			_filename.text =  _contentsList.selectedItems[0].text;
		}
	}
	
	private function _onListDblClick(event:MouseEvent):Void {
		var dir:String = _currentDir;
		if (StringTools.endsWith(dir, "/") == false && StringTools.endsWith(dir, "\\") == false) {
			dir += "/";
		}
		var newDir:String = FileSystemHelper.normalizePath(dir + _contentsList.selectedItems[0].text);
		if (FileSystemHelper.isDirectory(newDir) == true) {
			loadDirContents(newDir);
		} else {
			this.popup.clickButton(PopupButtonType.CONFIRM);
		}
	}
	
	private function buildPathClickFunction(index:Int) {
		return function(event:MouseEvent) { pathClick(index); };
	}
	
	private function pathClick(index:Int):Void {
		var newPath:String = "";
		var n:Int = 0;
		for (child in _path.children) {
			newPath += cast(child, Button).text + "/";
			n++;
			if (n == index + 1) {
				break;
			}
		}
		loadDirContents(newPath);
	}
	
	private function getFileIcon(fileName:String):String {
		return FileType.getIcon(fileName);
	}
	
	public var selectedFile(get, null):FileDetails;
	private function get_selectedFile():FileDetails {
		var details:FileDetails = null;
		var filePath:String = FileSystemHelper.normalizePath(_currentDir + "/" + _filename.text);
		if (filePath != null) {
			details = FileSystemHelper.getFileDetails(filePath, _readContents);
		}
		return details;
	}
	
	public var currentDir(get, null):String;
	private function get_currentDir():String {
		return _currentDir;
	}
}