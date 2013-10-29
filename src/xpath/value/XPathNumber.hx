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


/** Class implementing the number data type used by XPath queries. */
class XPathNumber extends XPathBoolean {
    var numberValue:Float;


    /** Constructs a new [XPathNumber] with the specified [value],
     * which defaults to 0. */
    public function new(?value:Float) {
        super();
        typeName = "number";
        if (value == null) {
            numberValue = 0;
        } else {
            numberValue = value;
        }
    }

    /** Gets the boolean value of this [XPathNumber] as per the
     * [boolean()] function defined by the XPath specification. The
     * value is [true] if and only if it is neither [+0], nor [-0],
     * nor [NaN]. */
    override public function getBool() {
        return (numberValue != 0 && !Math.isNaN(numberValue));
    }

    /** Gets the numeric value of this [XPathNumber]. */
    override public function getFloat() {
        return numberValue;
    }

    /** Gets the string value of this [XPathNumber] as per the [
     * [string()] function defined by the XPath specification:<ul>
     * <li>[NaN] is converted to the string ["NaN"].</li>
     * <li>[+0] is converted to the string ["0"].</li>
     * <li>[-0] is converted to the string ["-0"].</li>
     * <li>[+infinity] is converted to the string ["Infinity"].</li>
     * <li>[-infinity] is converted to the string ["-Infinity"].</li>
     * <li>If the value is an integer, the value is represented in
     *  decimal form as a [Number] (as defined by the XPath grammar)
     *  with no decimal point and no leading zeros, preceded by a
     *  minus sign if the value is negative;</li>
     * <li>otherwise, the value is represented in decimal form as a
     *  [Number] (as defined by the XPath grammar) including a decimal
     *  point with at least one digit before the decimal point and at
     *  least one digit after the decimal point, preceded by a minus
     *  sign if the value is negative; there will be no leading zeros
     *  before the decimal point apart possibly from the one required
     *  digit immediately before the decimal point; beyond the
     *  required digit after the decimal point there will be as many,
     *  but only as many, more digits as are needed to uniquely
     *  distinguish the value from all other IEEE 754 numeric
     *  values.</li></ul> */
    override public function getString() {
        var string = Std.string(numberValue);

        var eIndex = string.indexOf("e");
        if (eIndex > -1) {
            var digits = string.charAt(0) + string.substr(2, eIndex - 2);
            if (string.charAt(eIndex + 1) == "-") {
                var exponent:Int = Std.parseInt(string.substr(eIndex + 2));
                string = "0.";
                for (i in 1...exponent) {
                    string += "0";
                }
                string += digits;
            } else {
                var exponent:Int = Std.parseInt(string.substr(eIndex + 1));
                if (digits.length <= exponent + 1) {
                    string = digits;
                    while (string.length <= exponent) {
                        string += "0";
                    }
                } else {
                    string = digits.substr(0, exponent + 1) + "." + digits.substr(exponent + 1);
                }
            }
        }

        return string;
    }

    /** Performs the equality operation as defined by the XPath
     * specification. */
    override public function equals(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var nodes = cast(rightOperand, XPathNodeSet).getNodes();
            for (node in nodes) {
                var nodeValue = stringToFloat(node.getStringValue());
                if (getFloat() == nodeValue) {
                    return new XPathBoolean(true);
                }
            }
            return new XPathBoolean(false);
        } else if (Std.is(rightOperand, XPathNumber)) {
            return new XPathBoolean(getFloat() == rightOperand.getFloat());
        } else {
            return super.equals(rightOperand);
        }
    }

    /** Performs the inequality operation as defined by the XPath
     * specification. */
    override public function notEqual(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var nodes = cast(rightOperand, XPathNodeSet).getNodes();
            for (node in nodes) {
                var nodeValue = stringToFloat(node.getStringValue());
                if (getFloat() != nodeValue) {
                    return new XPathBoolean(true);
                }
            }
            return new XPathBoolean(false);
        } else if (Std.is(rightOperand, XPathNumber)) {
            return new XPathBoolean(getFloat() != rightOperand.getFloat());
        } else {
            return super.notEqual(rightOperand);
        }
    }

    /** Performs the less-than-or-equal operation as defined by the
     * XPath specification. */
    override public function lessThanOrEqual(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var nodes = cast(rightOperand, XPathNodeSet).getNodes();
            for (node in nodes) {
                var nodeValue = stringToFloat(node.getStringValue());
                if (getFloat() <= nodeValue) {
                    return new XPathBoolean(true);
                }
            }
            return new XPathBoolean(false);
        } else {
            return new XPathBoolean(getFloat() <= rightOperand.getFloat());
        }
    }

    /** Performs the greater-than-or-equal operation as defined by
     * the XPath specification. */
    override public function greaterThanOrEqual(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var nodes = cast(rightOperand, XPathNodeSet).getNodes();
            for (node in nodes) {
                var nodeValue = stringToFloat(node.getStringValue());
                if (getFloat() >= nodeValue) {
                    return new XPathBoolean(true);
                }
            }
            return new XPathBoolean(false);
        } else {
            return new XPathBoolean(getFloat() >= rightOperand.getFloat());
        }
    }

    /** Performs the less-than operation as defined by the XPath
     * specification. */
    override public function lessThan(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var nodes = cast(rightOperand, XPathNodeSet).getNodes();
            for (node in nodes) {
                var nodeValue = stringToFloat(node.getStringValue());
                if (getFloat() < nodeValue) {
                    return new XPathBoolean(true);
                }
            }
            return new XPathBoolean(false);
        } else {
            return new XPathBoolean(getFloat() < rightOperand.getFloat());
        }
    }

    /** Performs the greater-than operation as defined by the XPath
     * specification. */
    override public function greaterThan(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var nodes = cast(rightOperand, XPathNodeSet).getNodes();
            for (node in nodes) {
                var nodeValue = stringToFloat(node.getStringValue());
                if (getFloat() > nodeValue) {
                    return new XPathBoolean(true);
                }
            }
            return new XPathBoolean(false);
        } else {
            return new XPathBoolean(getFloat() > rightOperand.getFloat());
        }
    }
}
