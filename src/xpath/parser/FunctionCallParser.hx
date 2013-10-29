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
import xpath.expression.FunctionCall;
import xpath.tokenizer.Token;


class FunctionCallParser implements Parser {
    static var instance:FunctionCallParser;


    public static function getInstance() {
        if (instance == null) {
            instance = new FunctionCallParser();
        }

        return instance;
    }

    function new() {
    }

    public function parse(input:ParserInput) {
        if (!input.hasNext()) {
            return null;
        }

        var token = input.next();
        if (!Std.is(token, BeginFunctionCallToken)) {
            return null;
        }

        var beginFunctionCallToken = cast(token, BeginFunctionCallToken);
        var name = beginFunctionCallToken.name;

        var arguments = new List<Expression>();
        var output = ExpressionParser.getInstance().parse(input.descend());
        var hasNext;
        if (output != null) {
            arguments.add(output.result);
            input = output.getNextInput();

            hasNext = input.hasNext();
            if (hasNext) {
                token = input.next();
            }

            while (hasNext && Std.is(token, ArgumentDelimiterToken)) {
                output = ExpressionParser.getInstance().parse(input.descend());
                arguments.add(output.result);
                input = output.getNextInput();

                hasNext = input.hasNext();
                if (hasNext) {
                    token = input.next();
                }
            }

            if (!hasNext) {
                input.back();
            }
        }

        if (!input.hasNext()) {
            throw new ParseError("Invalid token stream");
        }

        token = input.next();
        if (!Std.is(token, EndFunctionCallToken)) {
            throw new ParseError("Invalid token stream");
        }

        var result = new FunctionCall(name, arguments);
        return input.getOutput(input.count, result);
    }
}
