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
import xpath.value.XPathNodeSet;
import xpath.EvaluationException;


/** Class implementing number functions from the XPath core function
 * library. For more information about the implementation of functions
 * in XPath, see [xpath.XPathFunction]. */
class NumberLibrary {
    /** number() function from the XPath core function library. The
     * query must pass either one parameter or no parameters. If no
     * parameter is passed, then the function behaves as if an
     * [XPathNodeSet] containing only the context node were passed as
     * a parameter. The parameter is then converted to an
     * [XPathNumber] by calling [getXPathNumber]. Throws
     * [EvaluationException] if [parameters.length > 1]. */
    public static function number(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length > 1) {
            throw new EvaluationException("Incorrect parameter count");
        }

        if (parameters[0] == null) {
            return new XPathNumber(Std.parseFloat(context.node.getStringValue()));
        } else {
            return parameters[0].getXPathNumber();
        }
    }

    /** sum() function from the XPath core function library. The query
     * must pass exactly one parameter which should be an
     * [XPathNodeSet]. Each node within the nodeset is converted into
     * an [XPathNumber] by calling [getXPathNumber], and the sum of
     * all converted values is calculated. Throws
     * [EvaluationException] if [parameters.length != 1]. */
    public static function sum(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 1) {
            throw new EvaluationException("Incorrect parameter count");
        }

        if (!Std.is(parameters[0], XPathNodeSet)) {
            throw new EvaluationException("Parameter was a " +
                    parameters[0].typeName + ", but a node set was expected");
        }

        var result = 0.0;
        var nodes = cast(parameters[0], XPathNodeSet).getNodes();

        for (node in nodes) {
            result += Std.parseFloat(node.getStringValue());
        }

        return new XPathNumber(result);
    }

    /** floor() function from the XPath core function library. The
     * query must pass exactly one parameter, which is converted to an
     * [XPathNumber] by calling [getXPathNumber]. The largest (closest
     * to positive infinity) number that is not greater than the
     * converted parameter and that is an integer is calculated.
     * Throws [EvaluationException] if [parameters.length != 1]. */
    public static function floor(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 1) {
            throw new EvaluationException("Incorrect parameter count");
        }

        var number = parameters[0].getFloat();
        return new XPathNumber(Math.floor(number));
    }

    /** ceiling() function from the XPath core function library. The
     * query must pass exactly one parameter, which is converted to an
     * [XPathNumber] by calling [getXPathNumber]. The smallest
     * (closest to negative infinity) number that is not less than the
     * converted parameter and that is an integer is calculated.
     * Throws [EvaluationException] if [parameters.length != 1]. */
    public static function ceiling(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 1) {
            throw new EvaluationException("Incorrect parameter count");
        }

        var number = parameters[0].getFloat();
        return new XPathNumber(Math.ceil(number));
    }

    /** round() function from the XPath core function library. The
     * query must pass exactly one parameter, which is converted to an
     * [XPathNumber] by calling [getXPathNumber]. The number that is
     * closest to the converted parameter and that is an integer is
     * calculated. If there are two such numbers, then the result is
     * that which is closest to positive infinity. If the parameter is
     * [NaN], then [NaN] is returned. If the parameter is positive or
     * negative infinity, or positive or negative zero, the parameter
     * is returned. If the parameter is less than zero, but greater
     * than or equal to [-0.5], then negative zero is returned.
     * Throws [EvaluationException] if [parameters.length != 1]. */
    public static function round(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 1) {
            throw new EvaluationException("Incorrect parameter count");
        }

        var number = parameters[0].getFloat();
        return new XPathNumber(Math.round(number));
    }
}
