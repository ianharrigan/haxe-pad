/* Haxe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS 
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

package xpath.xml;
import xpath.XPathException;
import xpath.XPathError;


/** Class wrapping the Haxe [Xml] class for XPath. */
class XPathHxXml extends XPathXml {
    var hxXml:Xml;

    var attributeParent:Xml;
    var attributeName:String;


    function new() {
    }

    /** Constructs a new [XPathHxXml] wrapping the specified Haxe [Xml]
     * node. Throws [XPathException] if [hxXml] is the XML document
     * type declaration, which isn't recognised as a node by XPath.
     *
     * Note that XPath treats sequential [PCData] and [CData] nodes as
     * a single [Text] node, whereas Haxe XPath treats them as
     * seperate nodes. Therefore, wrapping any [PCData] or [CData]
     * node which is part of a series will result in an [XPathHxXml]
     * representing the series as a whole. */
    public static function wrapNode(hxXml:Xml) {
        if (hxXml == null) {
            throw new XPathException("Can't wrap null for XPath");
        } else if (hxXml.nodeType == Xml.DocType) {
            throw new XPathException("Can't wrap XML document type declaration for XPath");
        } else {
            if (isTextNode(hxXml)) {
#if flash8
                var flashToHxXml:Dynamic->Xml = untyped Xml.convert;
                var flashXml:Dynamic = untyped hxXml.__x;
                while (flashXml.previousSibling.nodeType == 3 /*TEXT_NODE*/) {
                    flashXml = flashXml.previousSibling;
                }
                hxXml = flashToHxXml(flashXml);

#else
                if (hxXml.parent != null) {
                    var textStart = null;
                    for (sibling in hxXml.parent) {
                        if (isTextNode(sibling)) {
                            if (textStart == null) textStart = sibling;
                            if (sibling == hxXml) break;
                        } else {
                            textStart = null;
                        }
                    }
                    if (textStart != null) hxXml = textStart;
                }
#end
            }

            var node = new XPathHxXml();
            node.hxXml = hxXml;
            return node;
        }
    }

    /** Constructs a new [XPathHxXml] wrapping the specified attribute
     * of the specified Haxe [Xml] node. Throws [XPathException] if
     * the specified attribute does not exist. */
    public static function wrapAttribute(attributeParent:Xml, attributeName:String) {
        if (attributeParent != null &&
                attributeParent.nodeType == Xml.Element &&
                attributeParent.exists(attributeName)) {
            var node = new XPathHxXml();
            node.attributeParent = attributeParent;
            node.attributeName = attributeName;
            return node;
        } else {
            throw new XPathException("Can't wrap attribute that doesn't exist");
        }
    }

    /** Gets this node's parent, or [null] if this node has no
     * parent. */
    override public function getParent():XPathXml {
        return if (attributeName == null) {
            if (hxXml.parent == null) {
                null;
            } else {
                fastWrapNode(hxXml.parent);
            }
        } else {
            fastWrapNode(attributeParent);
        }
    }

    /** Gets the type of the wrapped XML node. */
    override public function getType():XmlNodeType {
        return if (attributeName == null) {
            switch (hxXml.nodeType) {
                case Xml.CData: XmlNodeType.Text;
                case Xml.Comment: XmlNodeType.Comment;
                case Xml.Document: XmlNodeType.Root;
                case Xml.Element: XmlNodeType.Element;
                case Xml.PCData: XmlNodeType.Text;
                case Xml.ProcessingInstruction: XmlNodeType.ProcessingInstruction;
                default: throw new XPathError();
            }
        } else {
            XmlNodeType.Attribute;
        }
    }

    /** Gets the name of the node, or [null] if the type of this node
     * is not [Element] or [Attribute]. */
    override public function getName():String {
        return if (attributeName == null) {
            if (hxXml.nodeType == Xml.Element) {
                hxXml.nodeName;
            } else {
                null;
            }
        } else {
            attributeName;
        }
    }

    /** Gets the value of the node:<ul>
     * <li>for [Text] nodes, the text represented by this node;</li>
     * <li>for [Attribute] nodes, the value assigned to the
     *  attribute.</li>
     * <li>for [ProcessingInstruction] nodes, the text contents of the
     *  processing instruction.</li>
     * <li>for all other nodes, [null].</li></ul> */
    override public function getValue():String {
        return if (attributeName == null) {
            switch (hxXml.nodeType) {
                case Xml.CData: getTextNodeValue();
                case Xml.PCData: getTextNodeValue();
                case Xml.ProcessingInstruction: hxXml.nodeValue;
                default: null;
            }
        } else {
            pcDecode(attributeParent.get(attributeName));
        }
    }

    /** Tests if this [XPathXml] represents the same node as the
     * [operand]. */
    override public function is(operand:XPathXml):Bool {
        return Std.is(operand, XPathHxXml) &&
                hxXml == cast(operand, XPathHxXml).hxXml &&
                attributeName == cast(operand, XPathHxXml).attributeName;
    }

    /** Gets an iterator over this node's attributes. */
    override public function getAttributeIterator():Iterator<XPathXml> {
        if (hxXml == null || hxXml.nodeType != Xml.Element) {
            return new List<XPathXml>().iterator();
        }

        var iterator = hxXml.attributes();
        var me = this;
        return {
            hasNext: function() {
                return iterator.hasNext();
            },
            next: function():XPathXml {
                if (iterator.hasNext()) {
                    return wrapAttribute(me.hxXml, iterator.next());
                } else {
                    return null;
                }
            }
        };
    }

    /** Gets an iterator over this node's children. */
    override public function getChildIterator():Iterator<XPathXml> {
        if (hxXml == null) {
            return new List<XPathXml>().iterator();
        }

        if (!isContainerNode(hxXml)) {
            return new List<XPathXml>().iterator();
        }

        var iterator = hxXml.iterator();
        var nextNode = null;
        var inText = false;

        var hasNext = function() {
            return nextNode != null;
        };
        var next = function():XPathXml {
            var result = if (nextNode == null) null;
            else fastWrapNode(nextNode);

            if (inText) {
                inText = false;
                while (isTextNode(nextNode)) {
                    if (iterator.hasNext()) {
                        nextNode = iterator.next();
                    } else {
                        nextNode = null;
                        break;
                    }
                }
            } else {
                if (iterator.hasNext()) {
                    nextNode = iterator.next();
                    inText = isTextNode(nextNode);
                } else nextNode = null;
            }

            return result;
        };
        next();

        return {
            hasNext: hasNext,
            next: next
        };
    }

    /** Gets an iterator over nodes following this node in document
     * order. */
    override public function getFollowingIterator():Iterator<XPathXml> {
        if (hxXml == null) {
            return new List<XPathXml>().iterator();
        }

        var nextNode = hxXml;
        var inText = false;

#if flash8
        var flashToHxXml:Dynamic->Xml = untyped Xml.convert;

#else
        var iterators = new List<Iterator<Xml>>();
        if (isContainerNode(hxXml)) iterators.add(hxXml.iterator());
        while (nextNode.parent != null) {
            var iterator = nextNode.parent.iterator();
            while (iterator.next() != nextNode) {}
            iterators.add(iterator);
            nextNode = nextNode.parent;
        }
#end

        var hasNext = function() {
            return nextNode != null;
        };
        var next = function():XPathXml {
            var result = if (nextNode == null) null;
            else fastWrapNode(nextNode);

#if flash8
            var flashXml:Dynamic = untyped nextNode.__x;
#end

            if (inText) {
                while (isTextNode(nextNode)) {
#if flash8
                    flashXml = untyped nextNode.__x;
                    if (flashXml.nextSibling == null) {
                        nextNode = null;
                        break;
                    } else {
                        nextNode = flashToHxXml(flashXml.nextSibling);
                    }

#else
                    if (iterators.first().hasNext()) {
                        nextNode = iterators.first().next();
                    } else {
                        nextNode = null;
                        break;
                    }
#end
                }
                inText = false;
            } else {
#if flash8
                if (hasChildNodes(nextNode)) {
                    nextNode = nextNode.firstChild();
                } else {
                    if (flashXml.nextSibling == null) {
                        nextNode = null;
                    } else {
                        nextNode = flashToHxXml(flashXml.nextSibling);
                        inText = isTextNode(nextNode);
                    }
                }

#else
                if (iterators.length > 0 && iterators.first().hasNext()) {
                    nextNode = iterators.first().next();
                    inText = isTextNode(nextNode);
                } else {
                    nextNode = null;
                }
#end
            }

            if (nextNode == null) {
#if flash8
                while (flashXml != null && flashXml.nextSibling == null) {
                    flashXml = flashXml.parentNode;
                }
                if (flashXml != null && flashXml.nextSibling != null) {
                    nextNode = flashToHxXml(flashXml.nextSibling);
                    inText = isTextNode(nextNode);
                }

#else
                while (iterators.length > 0 && !iterators.first().hasNext()) {
                    iterators.pop();
                }
                if (iterators.length > 0) {
                    nextNode = iterators.first().next();
                    inText = isTextNode(nextNode);
                }
#end
            }

#if !flash8
            if (nextNode != null && nextNode.nodeType == Xml.Element) {
                iterators.push(nextNode.iterator());
            }
#end

            return result;
        };

        next();
        return {
            hasNext: hasNext,
            next: next
        };
    }

    /** Gets an iterator over siblings of this node which follow it in
     * document order. */

    override public function getFollowingSiblingIterator():Iterator<XPathXml> {
        if (hxXml == null) {
            return new List<XPathXml>().iterator();
        }

        if (hxXml.parent == null) {
            return new List<XPathXml>().iterator();
        }

        var nextNode = hxXml;
        var inText = false;

#if flash8
        var flashToHxXml:Dynamic->Xml = untyped Xml.convert;

#else
        var iterator = hxXml.parent.iterator();
        while (iterator.next() != hxXml) {}
#end

        var hasNext = function() {
            return nextNode != null;
        };
        var next = function():XPathXml {
            var result = fastWrapNode(nextNode);
            if (inText) {
                do {
#if flash8
                    var flashXml = untyped nextNode.__x.nextSibling;
                    if (flashXml == null) {
                        nextNode = null;
                        inText = false;
                    } else {
                        nextNode = flashToHxXml(flashXml);
                        inText = isTextNode(nextNode);
                    }

#else
                    if (iterator.hasNext()) {
                        nextNode = iterator.next();
                        inText = isTextNode(nextNode);
                    } else {
                        nextNode = null;
                        inText = false;
                    }
#end
                } while (inText);
            } else {
#if flash8
                var flashXml = untyped nextNode.__x.nextSibling;
                if (flashXml == null) {
                    nextNode = null;
                } else {
                    nextNode = flashToHxXml(flashXml);
                    inText = isTextNode(nextNode);
                }

#else
                if (iterator.hasNext()) {
                    nextNode = iterator.next();
                    inText = isTextNode(nextNode);
                } else {
                    nextNode = null;
                }
#end
            }
            return result;
        };

        next();
        return {
            hasNext: hasNext,
            next: next
        };
    }

    /** Gets an iterator over the XML namespaces which are in scope
     * for this node. */
    override public function getNamespaceIterator():Iterator<XPathXml> {
        return new List<XPathXml>().iterator();
    }

    /** Gets an iterator over nodes preceding this node in document
     * order. */

    override public function getPrecedingIterator() {
#if flash8
        if (hxXml == null) {
            return new List<XPathXml>().iterator();
        }
        var flashToHxXml:Dynamic->Xml = untyped Xml.convert;
        var flashXml:Dynamic = untyped hxXml.__x;
        var nextNode:Xml = null;

        var hasNext = function () {
            return nextNode != null;
        };
        var next = function () :XPathXml {
            var result = fastWrapNode(nextNode);
            if (flashXml != null) {
                if (flashXml.previousSibling == null) {
                    flashXml = flashXml.parentNode;
                } else {
                    flashXml = flashXml.previousSibling;
                    if (flashXml.nodeType == 3 /*TEXT_NODE*/) {
                        while (flashXml.previousSibling.nodeType == 3) {
                            flashXml = flashXml.previousSibling;
                        }
                    } else {
                        while (flashXml.lastChild != null) {
                            flashXml = flashXml.lastChild;
                        }
                    }
                }
                if (flashXml == null) {
                    nextNode = null;
                } else {
                    nextNode = flashToHxXml(flashXml);
                }
            }
            return result;
        };
        next();

#else
        var stack = new List<XPathXml>();
        if (hxXml == null) {
            return stack.iterator();
        }

        var parent = hxXml;
        var hasNext = function() {
            do {
                if (stack.length > 0) return true;
                var pivot = parent;
                parent = parent.parent;
                if (parent != null) {
                    stack.push(fastWrapNode(parent));
                    var inText = false;
                    for (sibling in parent) {
                        if (sibling == pivot) break;
                        if (isContainerNode(sibling)) {
                            var wrappedContainer = fastWrapNode(sibling);
                            stack.push(wrappedContainer);
                            for (wrappedDescendant in wrappedContainer.getDescendantIterator()) {
                                stack.push(wrappedDescendant);
                            }
                            inText = false;
                        } else if (!inText || !isTextNode(sibling)) {
                            stack.push(fastWrapNode(sibling));
                            inText = isTextNode(sibling);
                        }
                    }
                }
            } while (parent != null);
            return false;
        };
        var next = function() {
            if (hasNext()) {
                return stack.pop();
            } else {
                return null;
            }
        };
#end

        return {
            hasNext: hasNext,
            next: next
        };
    }

    /** Gets an iterator over siblings of this node which precede it
     * in document order. */
    override public function getPrecedingSiblingIterator():Iterator<XPathXml> {
#if flash8
        if (hxXml == null) {
            return new List<XPathXml>().iterator();
        }

        var flashToHxXml:Dynamic->Xml = untyped Xml.convert;
        var flashXml:Dynamic = untyped hxXml.__x;

        var hasNext = function () {
            return flashXml != null && flashXml.previousSibling != null;
        };
        var next = function () :XPathXml {
            if (hasNext()) {
                flashXml = flashXml.previousSibling;
                if (flashXml.nodeType == 3 /*TEXT_NODE*/) {
                    while (flashXml.previousSibling != null &&
                            flashXml.previousSibling.nodeType == 3 /*TEXT_NODE*/) {
                        flashXml = flashXml.previousSibling;
                    }
                }
                return fastWrapNode(flashToHxXml(flashXml));
            } else {
                return null;
            }
        };

        return {
            hasNext: hasNext,
            next: next
        };

#else
        var stack = new List<XPathXml>();
        if (hxXml != null && hxXml.parent != null) {
            var inText = false;
            for (sibling in hxXml.parent) {
                if (sibling == hxXml) {
                    break;
                } else if (!inText || !isTextNode(sibling)) {
                    stack.push(fastWrapNode(sibling));
                    inText = isTextNode(sibling);
                }
            }
        }
        return stack.iterator();
#end
    }

    /** Returns the wrapped XML node. */
    public function getWrappedXml():Xml {
        if (hxXml == null) {
            throw new XPathException("Can't unwrap attribute node into Haxe Xml");
        } else {
            return hxXml;
        }
    }

    /* Helper function to return the value of a Text node. This is
     * needed because XPath treats a sequence of CData and/or PCData
     * sections as a single node, whereas Haxe Xml treats them as
     * seperate nodes. */
    function getTextNodeValue() {
        var result = "";

#if flash8
        var flashXml:Dynamic = untyped hxXml.__x;
        while (flashXml != null && flashXml.nodeType == 3 /*TEXT_NODE*/) {
            result += pcDecode(flashXml.nodeValue);
            flashXml = flashXml.nextSibling;
        }

#else
        var siblings;
        var parentHxXml = hxXml.parent;
        if (parentHxXml == null) {
            siblings = [hxXml].iterator();
        } else {
            siblings = parentHxXml.iterator();
        }

        var sibling = siblings.next();
        while (sibling != hxXml) {
            sibling = siblings.next();
        }

        while (sibling != null) {
            if (sibling.nodeType == Xml.CData) {
                result += sibling.nodeValue;
            } else if (sibling.nodeType == Xml.PCData) {
                result += pcDecode(sibling.nodeValue);
            } else {
                break;
            }

            if (siblings.hasNext()) {
                sibling = siblings.next();
            } else {
                sibling = null;
            }
        }
#end

        return result;
    }

    /* Helper function for wrapping Haxe Xml nodes. This function is
     * faster than the publicly accessible function wrapNode, but
     * returns incorrect results when wrapping CData or PCData nodes
     * that are not the first in a series. */
    static function fastWrapNode(hxXml:Xml):XPathHxXml {
        var node = new XPathHxXml();
        node.hxXml = hxXml;
        return node;
    }

    /* Helper function to decode PCData sections. This is quite
     * simplistic and only supports character references and the
     * standard XML entity references (lt, gt, amp, apos and quot). */
    static function pcDecode(pcData:String) {
        var i = 0, j = 0;
        var result = "";
        while (j < pcData.length) {
            if (pcData.charAt(j) == "&") {
                result += pcData.substr(i, j - i);
                i = ++j;
                while (j < pcData.length && pcData.charAt(j) != ";") {
                    ++j;
                }
                if (j == pcData.length) {
                    break;
                }
                result += refDecode(pcData.substr(i, j - i));
                i = j + 1;
            }
            ++j;
        }
        result += pcData.substr(i);
        return result;
    }

    /* Helper function to decode character/entity references. The only
     * entity references supported are the ones built into XML (lt,
     * gt, amp, apos and quot). */
    static function refDecode(ref:String) {
        if (ref.charAt(0) == "#") {
            if (ref.charAt(1) == "x") {
                return String.fromCharCode(Std.parseInt("0" + ref.substr(1)));
            } else {
#if flash8
                var i=1;
                while (ref.charAt(i) == "0" && i < (ref.length-1)) {
                    ++i;
                }
                return String.fromCharCode(Std.parseInt(ref.substr(i)));
#else
                return String.fromCharCode(Std.parseInt(ref.substr(1)));
#end
            }
        } else {
            switch (ref) {
                case "lt": return "<";
                case "gt": return ">";
                case "amp": return "&";
                case "apos": return "'";
                case "quot": return '"';
                default: return "&" + ref + ";";
            }
        }
    }

    /* Helper function to test if a given Haxe Xml node is text. */
    static function isTextNode(hxXml:Xml) {
        return hxXml.nodeType == Xml.CData || hxXml.nodeType == Xml.PCData;
    }

    /* Helper function to test if a given Haxe Xml node is a document
     * root or element node. */
    static function isContainerNode(hxXml:Xml) {
        return hxXml.nodeType == Xml.Element || hxXml.nodeType == Xml.Document;
    }

    /* Helper function to test if a given Haxe Xml node has
     * children. */
    static function hasChildNodes(hxXml:Xml) {
        return (hxXml.nodeType == Xml.Element || hxXml.nodeType == Xml.Document) && hxXml.firstChild() != null;
    }
}
