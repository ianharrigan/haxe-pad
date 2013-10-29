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
import xpath.XPathError;
import xpath.EvaluationException;


/** Abstract class for data types used within XPath queries. */
class XPathValue {
    /** Name of the data type */
    public var typeName (default, null):String;


    function new() {
    }

    /** Gets the boolean value of this object as per the [boolean()]
     * function defined by the XPath specification. */
    public function getBool():Bool {
        throw new XPathError("XPathValue.getBool() must be overridden");
        return false;
    }

    /** Gets the numeric value of this object as per the [number()]
     * function defined by the XPath specification. */
    public function getFloat():Float {
        throw new XPathError("XPathValue.getFloat() must be overridden");
        return 0;
    }

    /** Gets the string value of this object as per the [string()]
     * function defined by the XPath specification. */
    public function getString():String {
        throw new XPathError("XPathValue.getString() must be overridden");
        return "";
    }

    /** Performs the equality operation as defined by the XPath
     * specification. */
    public function equals(rightOperand:XPathValue):XPathBoolean {
        throw new XPathError("XPathValue.equals() must be overridden");
        return null;
    }

    /** Performs the inequality operation as defined by the XPath
     * specification. */
    public function notEqual(rightOperand:XPathValue):XPathBoolean {
        throw new XPathError("XPathValue.notEqual() must be overridden");
        return null;
    }

    /** Performs the less-than-or-equal operation as defined by the
     * XPath specification. */
    public function lessThanOrEqual(rightOperand:XPathValue):XPathBoolean {
        throw new XPathError("XPathValue.lessThanOrEqual() must be overridden");
        return null;
    }

    /** Performs the greater-than-or-equal operation as defined by the
     * XPath specification. */
    public function greaterThanOrEqual(rightOperand:XPathValue):XPathBoolean {
        throw new XPathError("XPathValue.greaterThanOrEqual() must be overridden");
        return null;
    }

    /** Performs the less-than operation as defined by the XPath
     * specification. */
    public function lessThan(rightOperand:XPathValue):XPathBoolean {
        throw new XPathError("XPathValue.lessThan() must be overridden");
        return null;
    }

    /** Performs the greater-than operation as defined by the XPath
     * specification. */
    public function greaterThan(rightOperand:XPathValue):XPathBoolean {
        throw new XPathError("XPathValue.greaterThan() must be overridden");
        return null;
    }

    /** Converts this object to an [XPathBoolean] according to the
     * definition of the [boolean()] function in the XPath
     * specification. */
    public function getXPathBoolean() {
        return new XPathBoolean(this.getBool());
    }

    /** Converts this object to an [XPathNumber] according to the
     * definition of the [number()] function in the XPath
     * specification. */
    public function getXPathNumber() {
        return new XPathNumber(this.getFloat());
    }

    /** Converts this object to an [XPathString] according to the
     * definition of the [string()] function in the XPath
     * specification. */
    public function getXPathString() {
        return new XPathString(this.getString());
    }

    /** Performs the boolean and operation as defined by the XPath
     * specification. */
    public function and(rightOperand:XPathValue) {
        return new XPathBoolean(this.getBool() && rightOperand.getBool());
    }

    /** Performs the boolean or operation as defined by the XPath
     * specification. */
    public function or(rightOperand:XPathValue) {
        return new XPathBoolean(this.getBool() || rightOperand.getBool());
    }

    /** Performs the addition operation as defined by the XPath
     * specification. */
    public function plus(rightOperand:XPathValue) {
        return new XPathNumber(this.getFloat() + rightOperand.getFloat());
    }

    /** Performs the subtraction operation as defined by the XPath
     * specification. */
    public function minus(rightOperand:XPathValue) {
        return new XPathNumber(this.getFloat() - rightOperand.getFloat());
    }

    /** Peforms the multiplication operation as defined by the XPath
     * specification. */
    public function multiply(rightOperand:XPathValue) {
        return new XPathNumber(this.getFloat() * rightOperand.getFloat());
    }

    /** Performs the division operation as defined by the XPath
     * specification. */
    public function divide(rightOperand:XPathValue) {
        return new XPathNumber(this.getFloat() / rightOperand.getFloat());
    }

    /** Performs the modulo operation as defined by the XPath
     * specification. */
    public function modulo(rightOperand:XPathValue) {
        return new XPathNumber(this.getFloat() % rightOperand.getFloat());
    }

    /** Performs the union operation as defined by the XPath
     * specification. Throws [EvaluationException] if either
     * operand is not an [XPathNodeSet]. */
    public function union(rightOperand:XPathValue):XPathNodeSet {
        throw new EvaluationException("can't compute union of " + this.typeName +
                " and " + rightOperand.typeName);
        return null;
    }

    /* Converts a String to a Float as specified by the XPath number()
     * function. */
    function stringToFloat(string:String) {
#if flash8
        var trimmed = StringTools.trim(string);
        if (trimmed.length == 0) return Math.NaN;
        var negative = false;
        if (trimmed.charAt(0) == "-") {
            negative = true;
            trimmed = StringTools.trim(trimmed.substr(1));
        }
        var split = trimmed.split(".");
        if (split.length > 2) return Math.NaN;
        for (side in split) {
            var i = 0;
            while (i < side.length) {
                if (side.charCodeAt(i) < 48 || side.charCodeAt(i) > 57) {
                    return Math.NaN;
                }
                ++i;
            }
        }
        if (negative) return -Std.parseFloat(trimmed);
        else return Std.parseFloat(trimmed);

#else
        var rx = ~/^\s*((-)\s*)?([0-9]+(\.[0-9]*)?|\.[0-9]+)\s*$/;
        if (rx.match(string)) {
            var signString;
            if (rx.matched(2) == "" || rx.matched(2) == null) {
                return Std.parseFloat(rx.matched(3));
            } else {
                return -Std.parseFloat(rx.matched(3));
            }
        } else {
            return Math.NaN;
        }
#end
    }

}
