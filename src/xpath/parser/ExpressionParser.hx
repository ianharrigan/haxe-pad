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
import xpath.expression.Expression;
import xpath.expression.Operation;
import xpath.tokenizer.Token;
import xpath.Operator;


class ExpressionParser implements Parser {
    static var instance:ExpressionParser;


    public static function getInstance() {
        if (instance == null) {
            instance = new ExpressionParser();
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
        if (!Std.is(token, BeginExpressionToken)) {
            return null;
        }

        var results = new List<Expression>();
        var operatorStack = new List<Operator>();
        var precedenceStack = new List<Int>();

        var output = OperandParser.getInstance().parse(input.descend());
        if (output == null) {
            throw new ParseError("Invalid token stream");
        }
        results.push(output.result);
        input = output.getNextInput();

        var hasNext = input.hasNext();
        if (hasNext) {
            token = input.next();
        }

        while (hasNext && Std.is(token, OperatorToken)) {
            var newOperatorToken = cast(token, OperatorToken);
            var newOperator = newOperatorToken.operator;
            var newPrecedence = newOperatorToken.getPrecedence();

            output = OperandParser.getInstance().parse(input.descend());
            if (output == null) {
                throw new ParseError("Invalid token stream");
            }
            input = output.getNextInput();
            var newOperand = output.result;

            while (!precedenceStack.isEmpty() && newPrecedence <= precedenceStack.first()) {
                precedenceStack.pop();
                var rightOperand = results.pop();
                var leftOperand = results.pop();
                var operator = operatorStack.pop();

                results.push(new Operation(leftOperand, operator, rightOperand));
            }

            results.push(newOperand);
            operatorStack.push(newOperator);
            precedenceStack.push(newPrecedence);

            hasNext = input.hasNext();
            if (hasNext) {
                token = input.next();
            }
        }

        precedenceStack = null;
        if (!hasNext || !Std.is(token, EndExpressionToken)) {
            throw new ParseError("Invalid token stream");
        }

        while (!operatorStack.isEmpty()) {
            var rightOperand = results.pop();
            var leftOperand = results.pop();
            var operator = operatorStack.pop();

            results.push(new Operation(leftOperand, operator, rightOperand));
        }
        operatorStack = null;

        output = input.getOutput(input.count, results.pop());
        if (!results.isEmpty()) {
            throw new ParseError("Invalid token stream");
        }

        return output;
    }
}
