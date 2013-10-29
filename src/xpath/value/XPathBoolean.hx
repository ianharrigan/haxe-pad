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


/** Class implementing the boolean data type used by XPath queries. */
class XPathBoolean extends XPathValue {
    var booleanValue:Bool;


    /** Constructs a new [XPathBoolean] with the specified [value],
     * which defaults to [false]. */

    public function new(?value:Bool) {
        super();
        typeName = "boolean";
        if (value == null) {
            booleanValue = false;
        } else {
            booleanValue = value;
        }
    }

    /** Gets the boolean value of this [XPathBoolean]. */
    override public function getBool() {
        return booleanValue;
    }

    /** Gets the numeric value of this [XPathBoolean] as per the
     * [number()] function defined by the XPath specification. If the
     * boolean is [true], it is converted to [1]; otherwise it is
     * converted to [0]. */
    override public function getFloat() {
        if (booleanValue) {
            return 1.0;
        } else {
            return 0.0;
        }
    }

    /** Gets the string value of this [XPathBoolean] as per the
     * [string()] function defined by the XPath specification. If the
     * boolean is [true], it is converted to the string ["true"];
     * otherwise it is converted to the string ["false"]. */
    override public function getString() {
        if (booleanValue) {
            return "true";
        } else {
            return "false";
        }
    }

    /** Performs the equality operation as defined by the XPath
     * specification. */
    override public function equals(rightOperand:XPathValue) {
        return new XPathBoolean(getBool() == rightOperand.getBool());
    }

    /** Performs the inequality operation as defined by the XPath
    * specification. */
    override public function notEqual(rightOperand:XPathValue) {
        return new XPathBoolean(getBool() != rightOperand.getBool());
    }

    /** Performs the less-than-or-equal operation as defined by the
     * XPath specification. */
    override public function lessThanOrEqual(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            return new XPathBoolean(!getBool() || rightOperand.getBool());
        } else {
            return new XPathBoolean(getFloat() <= rightOperand.getFloat());
        }
    }

    /** Performs the greater-than-or-equal operation as defined by the
     * XPath specification. */
    override public function greaterThanOrEqual(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            return new XPathBoolean(getBool() || !rightOperand.getBool());
        } else {
            return new XPathBoolean(getFloat() >= rightOperand.getFloat());
        }
    }

    /** Performs the less-than operation as defined by the XPath
     * specification. */
    override public function lessThan(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            return new XPathBoolean(!getBool() && rightOperand.getBool());
        } else {
            return new XPathBoolean(getFloat() < rightOperand.getFloat());
        }
    }

    /** Performs the greater-than operation as defined by the XPath
     * specification. */
    override public function greaterThan(rightOperand:XPathValue) {
        if (Std.is(rightOperand, XPathNodeSet)) {
            return new XPathBoolean(getBool() && !rightOperand.getBool());
        } else {
            return new XPathBoolean(getFloat() > rightOperand.getFloat());
        }
    }
}
