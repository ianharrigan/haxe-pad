package org.haxepad;

import haxe.ui.toolkit.containers.Accordion;
import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.controls.Menu;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.style.DefaultStyles;
import haxe.ui.toolkit.style.StyleManager;
import haxe.ui.toolkit.themes.GradientTheme;
import org.haxepad.managers.KeyboardManager;
import org.haxepad.managers.PluginManager;
import org.haxepad.managers.SystemManager;
import org.haxepad.plugins.IUserInterfacePlugin;
import org.haxepad.util.MacroUtil;

class Main {
	public static function main() {
		MacroUtil.loadPluginDir("assets/plugins");
		
		//Macros.addStyleSheet("styles/gradient/gradient.css");
		//StyleManager.instance.addStyles(new DefaultStyles());
		
		Toolkit.theme = new GradientTheme();
		
		Macros.addStyleSheet("assets/css/icons.css");
		Macros.addStyleSheet("assets/css/styles.css");
		Toolkit.defaultTransition = "none";
		Toolkit.setTransitionForClass(Accordion, "slide");
		Toolkit.setTransitionForClass(Stack, "none");
		Toolkit.setTransitionForClass(Menu, "none");
		Toolkit.setTransitionForClass(Popup, "slide");
		/*
		Toolkit.setTransitionForClass(Stack, "none");
		Toolkit.setTransitionForClass(Menu, "none");
		*/
		
		//SystemManager.exec("dir", []);
		//return;
		
		Toolkit.init();
		//return;
		Toolkit.openFullscreen(function(root:Root) {
			KeyboardManager.init(root);
			MacroUtil.loadUserPlugins("assets/plugins/user-plugins.xml");
			
			root.addChild(new MainController().view);
		});
	}
}
