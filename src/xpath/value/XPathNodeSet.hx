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


package xpath.value;
import xpath.xml.XPathXml;
import xpath.EvaluationException;
import xpath.XPathError;


/** Class implementing the node set data type used by XPath
 * queries.
 *
 * <b>Important</b>: Note that [XPathNodeSet]s are evaluated lazily
 * and only remain valid so long as neither the XML tree, nor the
 * environment in which the XPath was executed, are modified. If a
 * result needs to be preserved across such changes, copy the
 * resulting nodes immediately, for example:[
 * var nodes = Lambda.array(xpathNodeSet.getNodes());] */
class XPathNodeSet extends XPathString {
    var nodes:Iterable<XPathXml>;


    /** Constructs a new [XPathNodeSet] containing the specified
     * [nodes]. */
    public function new(?nodes:Iterable<XPathXml>) {
        super();
        typeName = "node set";
        if (nodes == null) {
            this.nodes = new Array<XPathXml>();
        } else {
            this.nodes = nodes;
        }
    }

    /** Gets the boolean value of this [XPathNodeSet] as per the
     * [boolean()] function defined by the XPath specification. The
     * node set is [true] if and only if it is non-empty. */
    override public function getBool() {
        return nodes.iterator().hasNext();
    }

    /** Gets the numeric value of this XPathNodeSet as per the
     * [number()] function defined by the XPath specification. The
     * [XPathNodeSet] is first converted to a string by calling
     * [getString()]. The conversion is then the same as specified
     * by [XPathString.getFloat()]. */
    override public function getFloat() {
        return getXPathString().getFloat();
    }

    /** Gets the string value of this [XPathNodeSet] as per the
     * [string()] function defined by the XPath specification. The
     * node set is converted by returning the string value of the
     * node in the node set that is first in document order. If the
     * node set is empty, an empty string is returned. */
    override public function getString() {
        if (nodes.iterator().hasNext()) {
            return getFirstNodeDocumentOrder().getStringValue();
        } else {
            return "";
        }
    }

    /** Gets an iterable of the nodes contained by this node set. */
    public function getNodes() {
        return nodes;
    }

    /** Gets an array of the nodes contained by this node set in
     * document order. */
    public function getNodesDocumentOrder() {
        var result = new List<XPathXml>();

        var nodesIterator = nodes.iterator();
        if (nodesIterator.hasNext()) {
            for (node1 in nodesIterator.next().getDocumentIterator()) {
                for (node2 in nodes) {
                    if (node1.is(node2)) result.add(node1);
                }
            }
        }

        return result;
    }

    /** Gets the node contained by this node set that is first in
     * document order. Throws [EvaluationException] if the node set is
     * empty. */
    public function getFirstNodeDocumentOrder() {
        var nodesIterator = nodes.iterator();
        if (nodesIterator.hasNext()) {
            for (node1 in nodesIterator.next().getDocumentIterator()) {
                for (node2 in nodes) {
                    if (node1.is(node2)) return node1;
                }
            }
        } else {
            throw new EvaluationException("Attempted to get first node of an empty node set");
        }

        throw new XPathError(); // should be impossible to reach this line
    }

    /** Performs the equality operation as defined by the XPath
     * specification. */
    override public function equals(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var rightNodes = cast(rightOperand, XPathNodeSet).getNodes();
            for (leftNode in nodes) {
                var leftString:String = leftNode.getStringValue();
                for (rightNode in rightNodes) {
                    if (leftString == rightNode.getStringValue()) {
                        return new XPathBoolean(true);
                    }
                }
            }
            return new XPathBoolean(false);
        } else {
            return rightOperand.equals(this);
        }
    }

    /** Performs the inequality operation as defined by the XPath
     * specification. */
    override public function notEqual(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var rightNodes = cast(rightOperand, XPathNodeSet).getNodes();
            for (leftNode in nodes) {
                var leftString:String = leftNode.getStringValue();
                for (rightNode in rightNodes) {
                    if (leftString != rightNode.getStringValue()) {
                        return new XPathBoolean(true);
                    }
                }
            }
            return new XPathBoolean(false);
        } else {
            return rightOperand.notEqual(this);
        }
    }

    /** Performs the less-than-or-equal operation as defined by the
     * XPath specification. */
    override public function lessThanOrEqual(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var rightNodes = cast(rightOperand, XPathNodeSet).getNodes();
            for (leftNode in nodes) {
                var leftString = leftNode.getStringValue();
                var leftValue = stringToFloat(leftString);
                for (rightNode in rightNodes) {
                    var rightString = rightNode.getStringValue();
                    var rightValue = stringToFloat(rightString);
                    if (leftValue <= rightValue) {
                        return new XPathBoolean(true);
                    }
                }
            }
            return new XPathBoolean(false);
        } else {
            for (node in nodes) {
                var nodeString = node.getStringValue();
                var nodeValue = stringToFloat(nodeString);
                if (nodeValue <= rightOperand.getFloat()) {
                    return new XPathBoolean(true);
                }
            }
            return new XPathBoolean(false);
        }
    }

    /** Performs the greater-than-or-equal operation as defined by the
     * XPath specification. */
    override public function greaterThanOrEqual(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var rightNodes = cast(rightOperand, XPathNodeSet).getNodes();
            for (leftNode in nodes) {
                var leftString = leftNode.getStringValue();
                var leftValue:Float = stringToFloat(leftString);
                for (rightNode in rightNodes) {
                    var rightString:String = rightNode.getStringValue();
                    var rightValue:Float = stringToFloat(rightString);
                    if (leftValue >= rightValue) {
                        return new XPathBoolean(true);
                    }
                }
            }
            return new XPathBoolean(false);
        } else {
            for (node in nodes) {
                var nodeString:String = node.getStringValue();
                var nodeValue:Float = stringToFloat(nodeString);
                if (nodeValue >= rightOperand.getFloat()) {
                    return new XPathBoolean(true);
                }
            }
            return new XPathBoolean(false);
        }
    }

    /** Performs the less-than operation as defined by the XPath specification. */
    override public function lessThan(rightOperand:XPathValue):XPathBoolean {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var rightNodes = cast(rightOperand, XPathNodeSet).getNodes();
            for (leftNode in nodes) {
                var leftString = leftNode.getStringValue();
                var leftValue = stringToFloat(leftString);
                for (rightNode in rightNodes) {
                    var rightString = rightNode.getStringValue();
                    var rightValue = stringToFloat(rightString);
                    if (leftValue < rightValue) {
                        return new XPathBoolean(true);
                    }
                }
            }
            return new XPathBoolean(false);
        } else {
            for (node in nodes) {
                var nodeString = node.getStringValue();
                var nodeValue = stringToFloat(nodeString);
                if (nodeValue < rightOperand.getFloat()) {
                    return new XPathBoolean(true);
                }
            }
            return new XPathBoolean(false);
        }
    }

    /** Performs the greater-than operation as defined by the XPath
     * specification. */
    override public function greaterThan(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var rightNodes = cast(rightOperand, XPathNodeSet).getNodes();
            for (leftNode in nodes) {
                var leftString = leftNode.getStringValue();
                var leftValue = stringToFloat(leftString);
                for (rightNode in rightNodes) {
                    var rightString = rightNode.getStringValue();
                    var rightValue = stringToFloat(rightString);
                    if (leftValue > rightValue) {
                        return new XPathBoolean(true);
                    }
                }
            }
            return new XPathBoolean(false);
        } else {
            for (node in nodes) {
                var nodeString = node.getStringValue();
                var nodeValue = stringToFloat(nodeString);
                if (nodeValue > rightOperand.getFloat()) {
                    return new XPathBoolean(true);
                }
            }
            return new XPathBoolean(false);
        }
    }

    /** Performs the union operation as defined by the XPath
     * specification. Throws [EvaluationException] if
     * [rightOperand] is not an [XPathNodeSet]. */
    override public function union(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var nodes = new List<XPathXml>();
            for (node in getNodes()) {
                nodes.add(node);
            }
            for (node in cast(rightOperand, XPathNodeSet).getNodes()) {
                nodes.add(node);
            }
            return new XPathNodeSet(nodes);
        } else {
            return super.union(rightOperand);
        }
    }
}
