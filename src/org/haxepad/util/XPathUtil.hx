package org.haxepad.util;

import xpath.xml.XPathHxXml;
import xpath.xml.XPathXml;
import xpath.XPath;

class XPathUtil {
	public static function getXPathValue(doc:Xml, xpathString:String):String {
		var value:String = null;
		var xpath:xpath.XPath = new xpath.XPath(xpathString);
		var xml:XPathHxXml = XPathHxXml.wrapNode(doc);
		var r:XPathXml = xpath.selectNode(xml);
		if (r != null) {
			value = r.getValue();
		}
		return value;
	}
}