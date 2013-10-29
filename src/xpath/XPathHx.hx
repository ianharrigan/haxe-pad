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


package xpath;
import xpath.context.Environment;
import xpath.xml.XPathHxXml;


/** Convenience class wrapping XPath for the standard Haxe [Xml]
 * class. */
class XPathHx {
    var xpath:XPath;


    /** Compiles an XPath query string into a parse tree, which may
     * then be used to efficiently execute the query. Throws
     * [xpath.tokenizer.TokenizerException] if the string is not a
     * valid XPath query. */
    public function new(xpathStr:String, ?environment:Environment) {
        this.xpath = new XPath(xpathStr, environment);
    }

    /** Evaluates the XPath query, returning the result as an
     * [Iterable] of [Xml] nodes. Throws [EvaluationException]
     * if the query does not evaluate to a node set, or if evaluation
     * fails for any other reason.
     *
     * <b>Important</b>: The results of this call are evaluated lazily
     * and the resulting [Iterable] remains valid only so long as
     * neither the XML tree, nor the environment in which the XPath
     * was executed, are modified. If it is necessary to preserve
     * results across such changes, copy the results immediately,
     * for example:[
     * var nodes = Lambda.array(xpath.selectNodes(...));] */
    public function selectNodes(contextNode:Xml, ?environment):Iterable<Xml> {
        var wrappedContextNode = XPathHxXml.wrapNode(contextNode);
        var xpathXmlNodes = xpath.selectNodes(wrappedContextNode);

        return {
            iterator: function() {
                var iterator = xpathXmlNodes.iterator();
                return {
                    hasNext: iterator.hasNext,
                    next: function() {
                        return cast(iterator.next(), XPathHxXml).getWrappedXml();
                    }
                };
            }
        };
    }

    /** Evaluates the XPath query, returning the result as a single XML
     * node, or null if the query evaluates to an empty node set.
     * Throws [EvaluationException] if the query does not evaluate to
     * a node set, or if the query fails to evaluate for any reason. */
    public function selectNode(contextNode:Xml, ?environment):Xml {
        var wrappedContextNode = XPathHxXml.wrapNode(contextNode);
        var result = xpath.selectNode(wrappedContextNode, environment);
        return cast(result, XPathHxXml).getWrappedXml();
    }

    /** Alias for selectNode. */
    public function selectSingleNode(contextNode:Xml, ?environment:Environment) {
        return selectNode(contextNode, environment);
    }

    /** Evaluates the XPath query, returning the result as a [String].
     * Throws [EvaluationException] if evaluation of the query
     * fails. */
    public function evaluateAsString(contextNode:Xml, ?environment:Environment) {
        var wrappedContextNode = XPathHxXml.wrapNode(contextNode);
        return xpath.evaluateAsString(wrappedContextNode, environment);
    }

    /** Evaluates the XPath query, returning the result as a [Float].
     * Throws [EvaluationException] if evaluation of the query
     * fails. */
    public function evaluateAsFloat(contextNode:Xml, ?environment:Environment) {
        var wrappedContextNode = XPathHxXml.wrapNode(contextNode);
        return xpath.evaluateAsFloat(wrappedContextNode, environment);
    }

    /** Evaluates the XPath query, returning the result as a [Bool].
     * Throws [EvaluationException] if evaluation of the query
     * fails. */
    public function evaluateAsBool(contextNode:Xml, ?environment:Environment) {
        var wrappedContextNode = XPathHxXml.wrapNode(contextNode);
        return xpath.evaluateAsBool(wrappedContextNode, environment);
    }
}
