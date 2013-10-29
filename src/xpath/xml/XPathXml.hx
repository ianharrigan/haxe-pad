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
import xpath.Axis;
import xpath.XPathError;


/** Abstract class representing an XML node wrapped for use with
 * XPath. */
class XPathXml {
    /** Gets this node's parent, or [null] if this node has no
     * parent. */
    public function getParent():XPathXml {
        throw new XPathError("xpath.xml.XPathXml.getParent must be overridden");
        return null;
    }

    /** Gets the type of the wrapped XML node. */
    public function getType():XmlNodeType {
        throw new XPathError("xpath.xml.XPathXml.getType must be overridden");
        return null;
    }

    /** Gets the name of the node, or [null] if the type of this node
     * is not [Element] or [Attribute]. */
    public function getName():String {
        throw new XPathError("xpath.xml.XPathXml.getName must be overridden");
        return null;
    }

    /** Gets the value of the node:<ul>
     * <li>for [Text] nodes, the text represented by this node;</li>
     * <li>for [Attribute] nodes, the value assigned to the
     *  attribute.</li>
     * <li>for [ProcessingInstruction] nodes, the text contents of the
     *  processing instruction.</li>
     * <li>for all other nodes, [null].</li></ul> */
    public function getValue():String {
        throw new XPathError("xpath.xml.XPathXml.getValue must be overridden");
        return null;
    }

    /** Gets the string value of the node per XPath specification:<ul>
     * <li>For document and element nodes, the concatenation of the
     *  string values of all text node descendants in document
     *  order.</li>
     * <li>For processing instruction nodes, the part of the
     *  processing instruction following any target and any
     *  whitespace, not including the terminating [?>].</li>
     * <li>For text nodes, the character data.</li></ul> */
    public function getStringValue() {
        var type = getType();
        if (type == XmlNodeType.Root || type == XmlNodeType.Element) {
            var result = "";
            for (descendant in getDescendantIterator()) {
                if (descendant.getType() == XmlNodeType.Text) {
                    result += descendant.getValue();
                }
            }
            return result;
        } else if (type == XmlNodeType.ProcessingInstruction ||
                type == XmlNodeType.Text ||
                type == XmlNodeType.Attribute) {
            return getValue();
        } else {
            return "";
        }
    }

    /** Tests if this [XPathXml] represents the same node as the
     * [operand]. */
    public function is(operand:XPathXml):Bool {
        throw new XPathError("xpath.xml.XPathXml.is must be overridden");
        return false;
    }

    /** Gets an iterator over nodes in the specified axis, relative
     * to this node. */
    public function getAxisIterator(axis:Axis) {
        return switch (axis) {
            case Ancestor: getAncestorIterator();
            case AncestorOrSelf: getAncestorOrSelfIterator();
            case Attribute: getAttributeIterator();
            case Child: getChildIterator();
            case Descendant: getDescendantIterator();
            case DescendantOrSelf: getDescendantOrSelfIterator();
            case Following: getFollowingIterator();
            case FollowingSibling: getFollowingSiblingIterator();
            case Namespace: getNamespaceIterator();
            case Parent: getParentIterator();
            case Preceding: getPrecedingIterator();
            case PrecedingSibling: getPrecedingSiblingIterator();
            case Self: getSelfIterator();
        }
    }

    /** Gets an [Iterable] which produces iterators over nodes in the
     * specified axis, relative to this node. */
    public function getAxisIterable(axis:Axis) {
        var me = this;
        return {
            iterator: function() {
                return me.getAxisIterator(axis);
            }
        };
    }

    /** Gets an iterator over this node's ancestors. */
    public function getAncestorIterator():Iterator<XPathXml> {
        var nextNode = getParent();
        return {
            hasNext: function() {
                return nextNode != null;
            },
            next: function() {
                var result = nextNode;
                nextNode = nextNode.getParent();
                return result;
            }
        };
    }

    /** Gets an iterator over this node and its ancestors. */
    public function getAncestorOrSelfIterator():Iterator<XPathXml> {
        var nextNode = this;
        return {
            hasNext: function() {
                return nextNode != null;
            },
            next: function() {
                var result = nextNode;
                nextNode = nextNode.getParent();
                return result;
            }
        };
    }

    /** Gets an iterator over this node's attributes. */
    public function getAttributeIterator():Iterator<XPathXml> {
        throw new XPathError("xpath.xml.XPathXml.getAttributeIterator must be overridden");
        return null;
    }

    /** Gets an iterator over this node's children. */
    public function getChildIterator():Iterator<XPathXml> {
        throw new XPathError("xpath.xml.XPathXml.getChildIterator must be overridden");
        return null;
    }

    /** Gets an iterator over this node's descendants. */
    public function getDescendantIterator():Iterator<XPathXml> {
        var iterators = new List<Iterator<XPathXml>>();
        iterators.push(getChildIterator());

        var hasNext = function() {
            while (iterators.length > 0) {
                if (iterators.first().hasNext()) return true;
                else iterators.pop();
            }
            return false;
        };
        var next = function() {
            if (hasNext()) {
                var result = iterators.first().next();
                iterators.push(result.getChildIterator());
                return result;
            } else {
                return null;
            }
        };

        return {
            hasNext: hasNext,
            next: next
        };
    }

    /** Gets an iterator over this node and its descendants. */
    public function getDescendantOrSelfIterator():Iterator<XPathXml> {
        var iterators = new List<Iterator<XPathXml>>();
        iterators.push(getSelfIterator());

        var hasNext = function() {
            while (iterators.length > 0) {
                if (iterators.first().hasNext()) return true;
                else iterators.pop();
            }
            return false;
        };
        var next = function() {
            if (hasNext()) {
                var result = iterators.first().next();
                iterators.push(result.getChildIterator());
                return result;
            } else {
                return null;
            }
        };

        return {
           hasNext: hasNext,
            next: next
        };
    }

    /** Gets an iterator over nodes following this node in document
     * order. */

    public function getFollowingIterator():Iterator<XPathXml> {
        throw new XPathError("xpath.xml.XPathXml.getFollowingIterator must be overridden");
        return null;
    }

    /** Gets an iterator over siblings of this node which follow it in
     * document order. */
    public function getFollowingSiblingIterator():Iterator<XPathXml> {
        throw new XPathError("xpath.xml.XPathXml.getFollowingSiblingIterator must be overridden");
        return null;
    }

    /** Gets an iterator over the XML namespaces which are in scope
     * for this node. */

    public function getNamespaceIterator():Iterator<XPathXml> {
        throw new XPathError("xpath.xml.XPathXml.getNamespaceIterator must be overridden");
        return null;
    }

    /** Gets an iterator over the parent of this node. */
    public function getParentIterator():Iterator<XPathXml> {
        var node = getParent();
        return {
            hasNext: function() {
                return node != null;
            },
            next: function() {
                var result = node;
                node = null;
                return result;
            }
        };
    }

    /** Gets an iterator over nodes preceding this node in document
     * order. */
    public function getPrecedingIterator():Iterator<XPathXml> {
        throw new XPathError("xpath.xml.XPathXml.getPrecedingIterator must be overridden");
        return null;
    }

    /** Gets an iterator over siblings of this node which precede it
     * in document order. */

    public function getPrecedingSiblingIterator():Iterator<XPathXml> {
        throw new XPathError("xpath.xml.XPathXml.getPrecedingSiblingIterator must be overridden");
        return null;
    }

    /** Gets an iterator over this node. */
    public function getSelfIterator():Iterator<XPathXml> {
        var node = this;
        return {
            hasNext: function() {
                return node != null;
            },
            next: function() {
                var result = node;
                node = null;
                return result;
            }
        };
    }

    /** Gets an iterator over all nodes in the XML document containing
     * this node (including attributes) in document order. */
    public function getDocumentIterator():Iterator<XPathXml> {
        var document = this;
        while (document.getParent() != null) {
            document = document.getParent();
        }

        var nodes = document.getDescendantOrSelfIterator();
        var attributes:Iterator<XPathXml> = {
            hasNext: function() { return false; },
            next: function():XPathXml { return null; }
        };

        return {
            hasNext: function() {
                return attributes.hasNext() || nodes.hasNext();
            },
            next: function() {
                if (attributes.hasNext()) {
                    return attributes.next();
                } else if (nodes.hasNext()) {
                    var result = nodes.next();
                    attributes = result.getAttributeIterator();
                    return result;
                } else {
                    return null;
                }
            }
        };
    }
}
