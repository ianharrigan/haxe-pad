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


/** Class implementing the string data type used by XPath queries. */
class XPathString extends XPathNumber {
    var stringValue:String;


    /** Constructs a new [XPathString] with the specified [value],
     * which defaults to the empty string. */
    public function new(?value:String) {
        super();
        typeName = "string";
        if (value == null) {
            stringValue = "";
        } else {
            stringValue = value;
        }
    }

    /** Gets the boolean value of this [XPathString] as per the
     * [boolean()] function defined by the XPath specification. The
     * result is true if and only if the length of the [XPathString]
     * is non-zero. */
    override public function getBool() {
        return stringValue.length != 0;
    }

    /** Gets the numeric value of this [XPathString] as per the
     * [number()] function defined by the XPath specification. If the
     * value consists of optional whitespace, followed by an optional
     * minus sign, followed by a [Number] as defined in the XPath
     * grammar, followed by optional whitespace, then the value is
     * converted to the IEEE 754 number that is nearest (according to
     * the IEEE 754 round-to-nearest rule) to the mathematical value
     * represented by the value. Otherwise, the value is converted to
     * [NaN]. */
    override public function getFloat():Float {
        return stringToFloat(stringValue);
    }

    /** Gets the string value of this object. */
    override public function getString() {
        return stringValue;
    }

    /** Performs the equality operation as defined by the XPath
     * specification. */
    override public function equals(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            var nodes = cast(rightOperand, XPathNodeSet).getNodes();
            for (node in nodes) {
                if (getString() == node.getStringValue()) {
                    return new XPathBoolean(true);
                }
            }
            return new XPathBoolean(false);
        } else if (Std.is(rightOperand, XPathNumber)) {
            return new XPathBoolean(getString() == rightOperand.getString());
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
                if (getString() != node.getStringValue()) {
                    return new XPathBoolean(true);
                }
            }
            return new XPathBoolean(false);
        } else if (Std.is(rightOperand, XPathString)) {
            return new XPathBoolean(getString() != rightOperand.getString());
        } else {
            return super.notEqual(rightOperand);
        }
    }
}
