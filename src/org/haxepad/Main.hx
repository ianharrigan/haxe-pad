package org.haxepad;

import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import org.haxepad.managers.KeyboardManager;
import org.haxepad.util.MacroUtil;

class Main {
	public static function main() {
		MacroUtil.loadPluginDir("assets/plugins");
		MacroUtil.loadUserPlugins("assets/plugins/user-plugins.xml");
		
		Macros.addStyleSheet("styles/gradient/gradient.css");
		Macros.addStyleSheet("assets/css/icons.css");
		Macros.addStyleSheet("assets/css/styles.css");
		Toolkit.defaultTransition = "none";
		/*
		Toolkit.setTransitionForClass(Stack, "none");
		Toolkit.setTransitionForClass(Menu, "none");
		*/
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			KeyboardManager.init(root);
			
			root.addChild(new MainController().view);
		});
	}
}
