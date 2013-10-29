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
import xpath.expression.Expression;
import xpath.context.Context;
import xpath.context.Environment;
import xpath.context.CoreEnvironment;
import xpath.context.UnionEnvironment;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.container.XPathTokenizer;
import xpath.parser.ParserInput;
import xpath.parser.XPathParser;
import xpath.value.XPathNodeSet;
import xpath.xml.XPathXml;


/** Class implementing an XPath query.
 * 
 * This library may be extended to work with any set of XML classes
 * by extending [xpath.xml.XPathXml] to wrap your preferred
 * implementation. A wrapper for the standard Haxe [Xml] class is
 * provided in [xpath.xml.XPathHxXml]. To wrap an existing [Xml]
 * object for use with XPath: [
 * var xpathXml = XPathHxXml.wrapNode(xml);]
 *
 * In this implementation, the compilation and evaluation of XPath
 * queries are seperated into two steps. In this way, if a single
 * XPath query is to be evaluated more than once, only a single
 * compilation is required.
 *
 * To compile an XPath query, call the XPath constructor with the
 * query string as its argument:[
 * var xpath = new XPath("/a/b/c");]
 *
 * The resulting object may now be used to evaluate the query
 * relative to a wrapped XML node:[
 * var result = xpath.evaluate(xpathXml);]
 *
 * Convenience functions are also provided to obtain the result of the
 * query in a variety of forms:[
 * xpath.selectNode(xpathXml); // returns zero or one XPathXml nodes
 * xpath.selectNodes(xpathXml); // returns zero or more XPathXml nodes
 * xpath.evaluateAsString(xpathXml); // returns a String
 * xpath.evaluateAsFloat(xpathXml); // returns a Float
 * xpath.evaluateAsBool(xpathXml); // returns a Bool]
 *
 * All XPath queries execute in the context of an [Environment], which
 * provides a set of variables and functions that may be referenced
 * from the query. The default environment, [CoreEnvironment],
 * provides those functions defined in the XPath specification as the
 * XPath core function library, but provides no variables.
 *
 * Environment variables can be used to avoid the need for
 * dynamically generated queries and the resulting need for repeated
 * compilation. For example, the queries [a/b/c], [a/b/d] and [a/b/e]
 * can be replaced by the single query [a/b/[name()=$n]]. This single
 * query can then be compiled once, and executed three times in
 * different environments with the variable [n] set to ["c"], ["d"]
 * and ["e"] respectively.
 *
 * An environment may be provided to an XPath query both at compile
 * time (by passing the environment as an argument to the [XPath]
 * constructor), and at at evaluation time (by passing the environment
 * as an argument to [evaluate], [selectNodes], etc). The variables
 * and functions provided by the [CoreEnvironment] are always
 * available, unless they are overridden. If an environment is
 * provided at compile time, then the variables and functions
 * provided override those provided by the [CoreEnvironment]. If an
 * environment is provided at evaluation time, then the variables
 * and functions provided override both those provided by the
 * [CoreEnvironment] and those provided by any environment provided
 * at compile time.
 *
 * Users wishing to provide their own custom environments should see
 * the documentation for [xpath.context.DynamicEnvironment] and
 * [xpath.context.BaseEnvironment]. */
class XPath {
    var expression:Expression;

    var environment:Environment;


    /** Compiles an XPath query string into a parse tree, which may
     * then be used to efficiently execute the query. Throws
     * [xpath.tokenizer.TokenizerException] if the string is not a
     * valid XPath query. */
    public function new(xpathStr:String, ?environment:Environment) {
        if (environment == null) {
            this.environment = CoreEnvironment.getInstance();
        } else {
            this.environment = new UnionEnvironment(environment, CoreEnvironment.getInstance());
        }

        var tokenizerInput = new TokenizerInput(xpathStr);
        var tokenizerOutput = XPathTokenizer.getInstance().tokenize(tokenizerInput);
        if (tokenizerOutput.result == null) {
            throw new XPathError("Unknown tokenization failure");
        }

        var parserInput = new ParserInput(tokenizerOutput.result);
        var parserOutput = XPathParser.getInstance().parse(parserInput);
        if (parserOutput.result == null) {
            throw new XPathError("Unknown parser failure");
        }

        this.expression = parserOutput.result;
    }

    /** Evaluates the XPath query. Throws [EvaluationException] if
     * evaluation of the query fails. */
    public function evaluate(contextNode:XPathXml, ?environment:Environment) {
        if (environment == null) {
            environment = this.environment;
        } else {
            environment = new UnionEnvironment(environment, this.environment);
        }

        return expression.evaluate(new Context(contextNode, 1, 1, environment));
    }

    /** Evaluates the XPath query, returning the result as an
     * [Iterable] of [XPathXml] nodes. Throws [EvaluationException]
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
    public function selectNodes(contextNode:XPathXml, ?environment) {
        var result = evaluate(contextNode, environment);
        if (Std.is(result, XPathNodeSet)) {
            return cast(result, XPathNodeSet).getNodes();
        } else {
            throw new EvaluationException("Query evaluated to a " + result.typeName + ", but " +
                    "a node set was expected");
            return null;
        }
    }

    /** Evaluates the XPath query, returning the result as a single XML
     * node, or null if the query evaluates to an empty node set.
     * Throws [EvaluationException] if the query does not evaluate to
     * a node set, or if the query fails to evaluate for any reason. */
    public function selectNode(contextNode:XPathXml, ?environment) {
        var result = evaluate(contextNode, environment);
        if (Std.is(result, XPathNodeSet)) {
            var nodes = cast(result, XPathNodeSet).getNodes();
            for (node in nodes) {
                return node;
            }
            return null;
        } else {
            throw new EvaluationException("Query evaluated to a " + result.typeName + ", but " +
                    "a node set was expected");
            return null;
        }
    }

    /** Alias for selectNode. */
    public function selectSingleNode(contextNode:XPathXml, ?environment:Environment) {
        return selectNode(contextNode, environment);
    }

    /** Evaluates the XPath query, returning the result as a [String].
     * Throws [EvaluationException] if evaluation of the query
     * fails. */
    public function evaluateAsString(contextNode:XPathXml, ?environment:Environment) {
        return evaluate(contextNode, environment).getString();
    }

    /** Evaluates the XPath query, returning the result as a [Float].
     * Throws [EvaluationException] if evaluation of the query
     * fails. */
    public function evaluateAsFloat(contextNode:XPathXml, ?environment:Environment) {
        return evaluate(contextNode, environment).getFloat();
    }

    /** Evaluates the XPath query, returning the result as a [Bool].
     * Throws [EvaluationException] if evaluation of the query
     * fails. */
    public function evaluateAsBool(contextNode:XPathXml, ?environment:Environment) {
        return evaluate(contextNode, environment).getBool();
    }
}
