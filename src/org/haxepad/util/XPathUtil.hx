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
	
	public static function getXPathNodes(doc:Xml, xpathString:String):Array<Xml> {
		var xpath:xpath.XPath = new xpath.XPath(xpathString);
		var xml:XPathHxXml = XPathHxXml.wrapNode(doc);
		var r:Iterable<XPathXml> = xpath.selectNodes(xml);
		var a:Array<Xml> = new Array<Xml>();
		if (r != null) {
			for (item in r) {
				if (Std.is(item, XPathHxXml)) {
					a.push(cast(item, XPathHxXml).getWrappedXml());
				}
			}
		}
		return a;
	}
	
	public static function getXPathNode(doc:Xml, xpathString:String):Xml {
		var xpath:xpath.XPath = new xpath.XPath(xpathString);
		var xml:XPathHxXml = XPathHxXml.wrapNode(doc);
		var r:XPathXml = xpath.selectSingleNode(xml);
		if (r != null && Std.is(r, XPathHxXml)) {
			return cast(r, XPathHxXml).getWrappedXml();
		}
		return null;
	}
}