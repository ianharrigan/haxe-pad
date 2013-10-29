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
import xpath.value.XPathNumber;
import xpath.value.XPathString;
import xpath.EvaluationException;


/** Class implementing string functions from the XPath core function
 * library. For more information about the implementation of functions
 * in XPath, see [xpath.XPathFunction]. */
class StringLibrary {
    /** number() function from the XPath core function library. The
     * query must pass either one parameter or no parameters. If no
     * parameter is passed, then the function behaves as if an
     * [XPathNodeSet] containing only the context node were passed as
     * a parameter. The parameter is then converted to an
     * [XPathString] by calling [getXPathString]. Throws
     * [EvaluationException] if [parameters.length > 1]. */
    public static function string(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length > 1) {
            throw new EvaluationException("Incorrect parameter count");
        }

        if (parameters[0] == null) {
            return new XPathString(context.node.getStringValue());
        } else {
            return parameters[0].getXPathString();
        }
    }

    /** concat() function from the XPath core function library. The
     * query must pass two or more parameters, which are converted
     * into [XPathString]s by calling [getXPathString], and then
     * concatenated into a single [XPathString]. Throws
     * [EvaluationException] if [parameters.length < 2]. */
    public static function concat(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length < 2) {
            throw new EvaluationException("Incorrect parameter count");
        }

        var result = "";
        for (parameter in parameters) {
            result += parameter.getString();
        }
        return new XPathString(result);
    }

    /** starts-with() function from the XPath core function library.
     * The query must pass exactly two parameters, which are converted
     * into [XPathString]s by calling [getXPathString]. Determines if
     * the first string begins with the second string. Throws
     * [EvaluationException] if [parameters.length != 2]. */
    public static function startsWith(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 2) {
            throw new EvaluationException("Incorrect parameter count");
        }

        var string = parameters[0].getString();
        var substring = parameters[1].getString();
        return new XPathBoolean(string.substr(0, substring.length) == substring);
    }

    /** contains() function from the XPath core function library. The
     * query must pass exactly two parameters, which are converted
     * into [XPathString]s by calling [getXPathString]. Determines if
     * the first string contains the second string. Throws
     * [EvaluationException] if [parameters.length != 2]. */
    public static function contains(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 2) {
            throw new EvaluationException("Incorrect parameter count");
        }

        var string = parameters[0].getString();
        var substring = parameters[1].getString();
        return new XPathBoolean(string.indexOf(substring) >= 0);
    }

    /** substring-before() function from the XPath core function
     * library. The query must pass exactly two parameters, which are
     * converted into [XPathString]s by calling [getXPathString].
     * Throws [EvaluationException] if [parameters.length != 2]. */
    public static function substringBefore(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 2) {
            throw new EvaluationException("Incorrect parameter count");
        }

        var string = parameters[0].getString();
        var substring = parameters[1].getString();
        var i = string.indexOf(substring);
        if (i < 0) {
            return new XPathString("");
        } else {
            return new XPathString(string.substr(0, i));
        }
    }

    /** substring-after() function from the XPath core function
     * library. The query must pass exactly two parameters, which are
     * converted into [XPathString]s by calling [getXPathString].
     * Throws [EvaluationException] if [parameters.length != 2]. */
    public static function substringAfter(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 2) {
            throw new EvaluationException("Incorrect parameter count");
        }

        var string = parameters[0].getString();
        var substring = parameters[1].getString();
        var i = string.indexOf(substring) + substring.length;
        return new XPathString(string.substr(i));
    }

    /** substring() function from the XPath core function library. The
     * query must pass either two or three parameters. The first
     * parameter is converted to an [XPathString] by calling
     * [getXPathString]. The second and optional third parameters are
     * converted to [XPathNumber]s by calling [getXPathNumber].
     *
     * Returns an [XPathString] whose value is a substring of the
     * first parameter. The characters included are those with an
     * index greater than or equal to the numeric value of the
     * second parameter, and less than the sum of the second and
     * third parameters. If the third parameter is ommitted, then all
     * characters with an index greater than or equal to the second
     * parameter are included. The index of the first character is
     * [1].
     *
     * Throws [EvaluationException] unless two or three parameters are
     * passed. */
    public static function substring(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length < 2 || parameters.length > 3) {
            throw new EvaluationException("Incorrect parameter count");
        }

        var string = parameters[0].getString();

        // necessary to remember float values as well as integer values because
        // some platforms "round" NaN and +/-Infinity to 0
        var startFloat = parameters[1].getFloat();
        var start = Math.round(startFloat);

        if (parameters[2] == null) {
            if (Math.isNaN(start)) {
                return new XPathString("");
            } else if (start < 1) {
                return new XPathString(string);
            } else {
                return new XPathString(string.substr(start - 1));
            }
        } else {
            var lengthFloat = parameters[2].getFloat();
            var length = Math.round(lengthFloat);

            // this accounts for some odd cases where start and/or
            // length are NaN or infinity
            if (Math.isNaN(startFloat + lengthFloat)) {
                return new XPathString("");
            }

            if (!Math.isFinite(startFloat)) {
                return new XPathString("");
            }

            // String.substr returns an empty string if the specified
            // length is infinite, so we need to explicitly handle
            // that case here
            if (Math.isFinite(lengthFloat)) {
                // if the starting index is < 1, the effective length is
                // shorter
                if (start < 1) {
                    length += start - 1;
                    start = 1;
                }

                return new XPathString(string.substr(start - 1, length));
            } else if (lengthFloat > 0) {
                return new XPathString(string.substr(start - 1));
            } else {
                return new XPathString("");
            }
        }
    }

    /** string-length() function from the XPath core function library.
     * The query must pass either no parameters or one parameter. If
     * no parameters are passed, then the function behaves as if an
     * [XPathNodeSet] containing only the context node were passed.
     * The parameter is converted to an XPathString by calling
     * [getXPathString], and the number of characters in the resulting
     * string determined. Throws [EvaluationException] if
     * [parameters.length > 1]. */
    public static function stringLength(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length > 1) {
            throw new EvaluationException("Incorrect parameter count");
        }

        var string;
        if (parameters[0] == null) {
            string = context.node.getStringValue();
        } else {
            string = parameters[0].getString();
        }
        return new XPathNumber(string.length);
    }

    /** normalize-space() function from the XPath core function
     * library. The query must pass either no parameters or one
     * parameter. If no parameters are passed, then the function
     * behaves as if an [XPathNodeSet] containing only the context
     * node were passed. The parameter is converted to an
     * [XPathString] by calling [getXPathString]. The resulting string
     * is then whitespace-normalized by stripping leading and trailing
     * whitespace and replacing sequences of whitespace characters
     * with a single space. Throws [EvaluationException] if
     * [parameters.length > 1]. */
    public static function normalizeSpace(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length > 1) {
            throw new EvaluationException("Incorrect parameter count");
        }

        var string;
        if (parameters[0] == null) {
            string = context.node.getStringValue();
        } else {
            string = parameters[0].getString();
        }

        var buf = new StringBuf();
        var doneSpace:Bool = true;
        for (i in 0...string.length) {
            var c:String = string.charAt(i);
            if (c == " " || c == "\t" || c == "\n" || c == "\r") {
                if (!doneSpace) {
                    buf.add(" ");
                    doneSpace = true;
                }
            } else {
                doneSpace = false;
                buf.add(c);
            }
        }

        return new XPathString(StringTools.rtrim(buf.toString()));
    }

    /** translate() function from the XPath core function library. The
     * query must pass exactly three parameters which are converted to
     * [XPathString]s by calling [getXPathString]. Constructs a new
     * [XPathString] which is a copy of the first parameter, but with
     * characters that appear in the second parameter replaced by
     * those which appear in the corresponding position in the third
     * parameter. Characters which appear in the second parameter but
     * for which there is no corresponding replacement are removed.
     * Throws [EvaluationException] if [parameters.length != 3]. */
    public static function translate(context:Context, parameters:Array<XPathValue>) {
        if (parameters.length != 3) {
            throw new EvaluationException("Incorrect parameter count");
        }

        var string = parameters[0].getString();
        var fromChars = parameters[1].getString();
        var toChars = parameters[2].getString();

        var translations = new Map<String, String>();
        var i = fromChars.length;
        while (i > 0) {
            --i;
            translations.set(fromChars.charAt(i), toChars.charAt(i));
        }

        var buf = new StringBuf();
        for (i in 0...string.length) {
            var c = string.charAt(i);
            if (translations.exists(c)) {
                buf.add(translations.get(c));
            } else {
                buf.add(c);
            }
        }

        return new XPathString(buf.toString());
    }
}
