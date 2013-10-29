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
import xpath.expression.PathStep;
import xpath.expression.FilterStep;
import xpath.expression.NameStep;
import xpath.expression.TypeStep;
import xpath.expression.PINameStep;
import xpath.expression.AxisStep;
import xpath.tokenizer.Token;
import xpath.Axis;
import xpath.NodeCategory;


class StepParser implements Parser {
    static var instance:StepParser;


    public static function getInstance() {
        if (instance == null) {
            instance = new StepParser();
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

        if (Std.is(token, AxisToken)) {
            var axis = cast(token, AxisToken).axis;
            if (!input.hasNext()) {
                throw new ParseError("Invalid token stream");
            }

            var nodeTestToken = input.next();
            if (!(Std.is(nodeTestToken, NameTestToken) ||
                    Std.is(nodeTestToken, TypeTestToken) ||
                    Std.is(nodeTestToken, PINameTestToken))) {
                throw new ParseError("Invalid token stream");
            }

            var nextStep;
            var output = NextStepParser.getInstance().parse(input.descend());
            if (output == null) {
                nextStep = null;
            } else {
                nextStep = cast(output.result, PathStep);
                input = output.getNextInput();
            }

            var nodeTest:PathStep;
            if (Std.is(nodeTestToken, NameTestToken)) {
                var name = cast(nodeTestToken, NameTestToken).name;
                nodeTest = new NameStep(name, nextStep);
            } else if (Std.is(nodeTestToken, TypeTestToken)) {
                var type = cast(nodeTestToken, TypeTestToken).type;

                // the test node() is effectively a no-op, so for
                // efficiency, exclude it from the parse tree
                if (type == NodeCategory.Node) {
                    nodeTest = nextStep;
                } else {
                    nodeTest = new TypeStep(type, nextStep);
                }
            } else if (Std.is(nodeTestToken, PINameTestToken)) {
                var name = cast(nodeTestToken, PINameTestToken).name;
                nodeTest = new PINameStep(name, nextStep);
            } else {
                throw new ParseError("Invalid token stream");
            }

            // the axis self:: is effectively a no-op, so for
            // efficiency exclude it from the parse tree
            var result:Expression;
            if (axis == Axis.Self) {
                result = nodeTest;
            } else {
                result = new AxisStep(axis, nodeTest);
            }

            return input.getOutput(input.count, result);
        } else {
            input.restart();
            var output = ExpressionParser.getInstance().parse(input);
            if (output == null) {
                return null;
            }

            var filterExpression = output.result;
            input = output.getNextInput();
            output = NextStepParser.getInstance().parse(input.descend());
            var nextStep;
            if (output == null) {
                nextStep = null;
            } else {
                nextStep = cast(output.result, PathStep);
                input = output.getNextInput();
            }
            var result = new FilterStep(filterExpression, nextStep);
            return input.getOutput(input.count, result);
        }

        return null;
    }
}
