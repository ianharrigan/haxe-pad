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
import xpath.expression.PathStep;
import xpath.expression.PredicateStep;
import xpath.tokenizer.Token;


class NextStepParser implements Parser {
    static var instance:NextStepParser;


    public static function getInstance() {
        if (instance == null) {
            instance = new NextStepParser();
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

        if (Std.is(token, StepDelimiterToken)) {
            var output = StepParser.getInstance().parse(input.descend());
            if (output == null) {
                return input.getOutput(input.count, null);
            } else {
                return output;
            }
        } else if (Std.is(token, BeginPredicateToken)) {
            var output = ExpressionParser.getInstance().parse(input.descend());
            if (output == null) {
                throw new ParseError("Invalid token stream");
            }

            var predicateExpression = output.result;
            input = output.getNextInput();

            if (!input.hasNext()) {
                throw new ParseError("Invalid token stream");
            }

            token = input.next();
            if (!Std.is(token, EndPredicateToken)) {
                throw new ParseError("Invalid token stream");
            }

            var nextStep;
            output = parse(input.descend());
            if (output == null) {
                nextStep = null;
            } else {
                nextStep = cast(output.result, PathStep);
                input = output.getNextInput();
            }

            var result = new PredicateStep(predicateExpression, nextStep);
            return input.getOutput(input.count, result);
        } else {
            return null;
        }
    }
}
