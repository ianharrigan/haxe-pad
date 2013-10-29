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
import xpath.value.XPathBoolean;
import xpath.EvaluationException;


/** Class implementing boolean functions from the XPath core function
 * library. For more information about the implementation of functions
 * in XPath, see [xpath.XPathFunction]. */
class BooleanLibrary {
    /** boolean() function from the XPath core function library. The
     * query must pass exactly one parameter which is converted to a
     * boolean by calling getXPathBoolean. Throws
     * [EvaluationException] if [parameters.length != 1]. */
    public static function boolean(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 1) {
            throw new EvaluationException("Incorrect parameter count");
        }

        return parameters[0].getXPathBoolean();
    }

    /** not() function from the XPath core function library. The query
     * must pass exactly one parameter which is converted to a boolean
     * by calling getXPathBoolean. The sense of the boolean is then
     * inverted and the result returned. Throws [EvaluationException]
     * if [parameters.length != 1]. */
    public static function not(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 1) {
            throw new EvaluationException("Incorrect parameter count");
        }

        return new XPathBoolean(!parameters[0].getBool());
    }

    /** true() function from the XPath core function library. The
     * query must pass no parameters. Throws [EvaluationException] if
     * [parameters.length != 0]. */
    public static function getTrue(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 0) {
            throw new EvaluationException("Incorrect parameter count");
        }

        return new XPathBoolean(true);
    }

    /** false() function from the XPath core function library. The
     * query must pass no parameters. Throws [EvaluationException] if
     * [parameters.length != 0]. */
    public static function getFalse(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 0) {
            throw new EvaluationException("Incorrect parameter count");
        }

        return new XPathBoolean(false);
    }
}
