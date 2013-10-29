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


package xpath.tokenizer.token;
import xpath.tokenizer.token.TokenTokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.Token;
import xpath.tokenizer.ExpectedException;
import xpath.Operator;


/** [Tokenizer] which tokenizes according to the [Operator] rule. */
class OperatorTokenizer extends TokenTokenizer {
    static var instance:OperatorTokenizer;

    var operatorSymbols:Array<String>;
    var operatorSymbolToOperator:Map<String, Operator>;


    public static function getInstance() {
        if (instance == null) {
            instance = new OperatorTokenizer();
        }

        return instance;
    }

    /** Gets the instance of [OperatorTokenizer]. */
    function new() {
        operatorSymbolToOperator = new Map<String, Operator>();
        operatorSymbolToOperator.set("and", And);
        operatorSymbolToOperator.set("mod", Modulo);
        operatorSymbolToOperator.set("div", Divide);
        operatorSymbolToOperator.set("or", Or);
        operatorSymbolToOperator.set("!=", NotEqual);
        operatorSymbolToOperator.set("<=", LessThanOrEqual);
        operatorSymbolToOperator.set(">=", GreaterThanOrEqual);
        operatorSymbolToOperator.set("=", Equal);
        operatorSymbolToOperator.set("|", Union);
        operatorSymbolToOperator.set("+", Plus);
        operatorSymbolToOperator.set("-", Minus);
        operatorSymbolToOperator.set("<", LessThan);
        operatorSymbolToOperator.set(">", GreaterThan);
        operatorSymbolToOperator.set("*", Multiply);

        operatorSymbols = new Array<String>();
        for (operatorSymbol in operatorSymbolToOperator.keys()) {
            operatorSymbols.push(operatorSymbol);
        }

        // sort symbols by length, longest first
        operatorSymbols.sort(function(x:String, y:String) {
            return y.length - x.length;
        });
    }

    override public function tokenize(input:TokenizerInput) {
        var pos = input.position;

        // check for operator symbol
        for (operatorSymbol in operatorSymbols) {
            if (input.query.substr(pos, operatorSymbol.length) == operatorSymbol) {
                pos += operatorSymbol.length;
                var operator = operatorSymbolToOperator.get(operatorSymbol);
                var result = [ cast(new OperatorToken(operator), Token) ];
                var characterLength = pos - input.position;
                characterLength += countWhitespace(input.query, pos);
                return input.getOutput(result, characterLength);
            }
        }

        throw new ExpectedException([{ tokenName: "Operator", position: input.position }]);
    }
}
