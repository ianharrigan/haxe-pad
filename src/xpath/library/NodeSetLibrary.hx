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


package xpath.library;
import xpath.context.Context;
import xpath.value.XPathValue;
import xpath.value.XPathNumber;
import xpath.value.XPathString;
import xpath.value.XPathNodeSet;
import xpath.EvaluationException;


/** Class implementing node set functions from the XPath core function
 * library. For more information about the implementation of functions
 * in XPath, see [xpath.XPathFunction]. */
class NodeSetLibrary {
    /** last() function from the XPath core function library. The
     * query must pass no parameters. Returns an [XPathNumber] whose
     * value is equal to the context size. Throws
     * [EvaluationException] if [parameters.length != 0]. */
    public static function last(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length > 0) {
            throw new EvaluationException("Incorrect parameter count");
        }

        return new XPathNumber(context.size);
    }

    /** position() function from the XPath core function library. The
     * query must pass no parameters. Returns an [XPathNumber] whose
     * value is equal to the context position. Throws
     * [EvaluationException] if [parameters.length != 0]. */
    public static function position(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length > 0) {
            throw new EvaluationException("Incorrect parameter count");
        }

        return new XPathNumber(context.position);
    }

    /** count() function from the XPath core function library. The
     * query must pass exactly one parameter, which should be a node
     * set. Returns an [XPathNumber] whose value is the number of
     * nodes in the argument node set. Throws [EvaluationException] if
     * [parameters.length != 1], or if the parameter is not a node
     * set. */
    public static function count(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 1) {
            throw new EvaluationException("Incorrect parameter count");
        }

        if (!Std.is(parameters[0], XPathNodeSet)) {
            throw new EvaluationException("Parameter was a " +
                    parameters[0].typeName + ", but a node set was expected");
        }

        var nodeSet = cast(parameters[0], XPathNodeSet);
        var count = 0;
        for (node in nodeSet.getNodes()) {
            ++count;
        }

        return new XPathNumber(count);
    }

    /** local-name() function from the XPath core function library.
     * The query must pass one or no parameters. If a parameter is
     * passed, it must be a node set. If no parameter is passed, the
     * function executes as if a node set with the context node as its
     * only member were passed as a parameter. Throws
     * [EvaluationException] if [parameters.length > 1], or if the
     * parameter is not a node set. */
    public static function localName(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length > 1) {
            throw new EvaluationException("Incorrect parameter count");
        }

        var node;
        if (parameters[0] == null) {
            node = context.node;
        } else {
            if (!Std.is(parameters[0], XPathNodeSet)) {
                throw new EvaluationException("Parameter was a " +
                        parameters[0].typeName + ", but a node set was expected");
            }
            try {
                node = cast(parameters[0], XPathNodeSet).getFirstNodeDocumentOrder();
            } catch (exception:EvaluationException) {
                throw new EvaluationException("Called local-name on an empty node set");
            }
        }

        return new XPathString(node.getName());
    }

    /** name() function from the XPath core function library.
     * Currently this function is not fully implemented and behaves
     * exactly as local-name(). Throws [EvaluationException] if
     * parameters.length != 1, or if the parameter is not a
     * node set. */
    public static function nodeName(context:Context, parameters:Array<XPathValue>) {
        // FIXME #9 XML Namespace support
        return localName(context, parameters);
    }
}
