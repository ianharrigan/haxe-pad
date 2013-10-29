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


package xpath.tokenizer;


/** [Token]s are used to unambiguously represent any XPath query. */
interface Token {
}

class ArgumentDelimiterToken implements Token {
    public function new() {
    }
}

class AxisToken implements Token {
    public var axis (default, null):xpath.Axis;


    public function new(axis:xpath.Axis) {
        this.axis = axis;
    }
}

class BeginExpressionToken implements Token {
    public function new() {
    }
}

class BeginFunctionCallToken implements Token {
    public var name (default, null):String;


    public function new(name:String) {
        this.name = name;
    }
}

class BeginGroupToken implements Token {
    public function new() {
    }
}

class BeginPathToken implements Token {
    public function new() {
    }
}

class BeginPredicateToken implements Token {
    public function new() {
    }
}

class BeginXPathToken implements Token {
    public function new() {
    }
}

class EndExpressionToken implements Token {
    public function new() {
    }
}

class EndFunctionCallToken implements Token {
    public function new() {
    }
}

class EndGroupToken implements Token {
    public function new() {
    }
}

class EndPathToken implements Token {
    public function new() {
    }
}

class EndPredicateToken implements Token {
    public function new() {
    }
}

class EndXPathToken implements Token {
    public function new() {
    }
}

class LiteralToken implements Token {
    public var value (default, null):String;


    public function new(value:String) {
        this.value = value;
    }
}

class NameTestToken implements Token {
    public var name (default, null):String;


    public function new(name:String) {
        this.name = name;
    }
}

class NegationOperatorToken implements Token {
    public function new() {
    }
}

class NumberToken implements Token {
    public var value (default, null):Float;


    public function new(value:Float) {
        this.value = value;
    }
}

class OperatorToken implements Token {
    public var operator (default, null):xpath.Operator;


    public function new(operator:xpath.Operator) {
        this.operator = operator;
    }

    // TODO: #8 move this somewhere more sensible
    public function getPrecedence():Int {
        return switch (operator) {
            case Or: 0;
            case And: 1;
            case Equal: 2;
            case NotEqual: 2;
            case LessThanOrEqual: 3;
            case LessThan: 3;
            case GreaterThanOrEqual: 3;
            case GreaterThan: 3;
            case Plus: 4;
            case Minus: 4;
            case Multiply: 5;
            case Divide: 5;
            case Modulo: 5;
            case Union: 6;
        }
    }
}

class PINameTestToken implements Token {
    public var name (default, null):String;


    public function new(?name:String) {
        this.name = name;
    }
}

class StepDelimiterToken implements Token {
    public function new() {
    }
}

class TypeTestToken implements Token {
    public var type (default, null):xpath.NodeCategory;


    public function new(type:xpath.NodeCategory) {
        this.type = type;
    }
}

class VariableReferenceToken implements Token {
    public var name (default, null):String;


    public function new(name:String) {
        this.name = name;
    }
}
