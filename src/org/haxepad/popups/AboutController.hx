package org.haxepad.popups;

import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Client;
import haxe.ui.toolkit.core.XMLController;

class AboutController extends XMLController {
	public function new() {
		super("ui/popups/about.xml");
		
		getComponentAs("dpi", Text).text = "DPI: " + Client.instance.dpi;
	}
	
}