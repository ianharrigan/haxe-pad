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


package xpath.parser;
import xpath.tokenizer.Token;
import xpath.expression.Negation;
import xpath.expression.Literal;
import xpath.expression.Number;
import xpath.expression.VariableReference;


class OperandParser implements Parser {
    static var instance:OperandParser;


    public static function getInstance() {
        if (instance == null) {
            instance = new OperandParser();
        }

        return instance;
    }

    function new() {
    }

    public function parse(input:ParserInput):ParserOutput {
        if (!input.hasNext()) {
            return null;
        }

        var token = input.next();

        if (Std.is(token, NegationOperatorToken)) {
            var output = parse(input);
            input = output.getNextInput();
            var result = new Negation(output.result);
            return input.getOutput(input.count, result);
        } else if (Std.is(token, LiteralToken)) {
            var result = new Literal(cast(token, LiteralToken).value);
            return input.getOutput(input.count, result);
        } else if (Std.is(token, NumberToken)) {
            var result = new Number(cast(token, NumberToken).value);
            return input.getOutput(input.count, result);
        } else if (Std.is(token, VariableReferenceToken)) {
            var result = new VariableReference(cast(token, VariableReferenceToken).name);
            return input.getOutput(input.count, result);
        } else {
            input.restart();
            var output = PathParser.getInstance().parse(input.descend());
            if (output == null) {
                output = GroupParser.getInstance().parse(input.descend());
            }
            if (output == null) {
                output = FunctionCallParser.getInstance().parse(input.descend());
            }
            return output;
        }
    }
}
