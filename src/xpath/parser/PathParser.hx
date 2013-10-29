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
import xpath.expression.Expression;
import xpath.expression.PathStep;
import xpath.expression.TypeStep;
import xpath.expression.RootStep;
import xpath.NodeCategory;


class PathParser implements Parser {
    static var instance:PathParser;


    public static function getInstance() {
        if (instance == null) {
            instance = new PathParser();
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
        if (!Std.is(token, BeginPathToken)) {
            return null;
        }

        if (!input.hasNext()) {
            throw new ParseError("Invalid token stream");
        }

        token = input.next();
        var absolute = Std.is(token, StepDelimiterToken);
        if (!absolute) {
            input.back();
        }

        var firstStep:PathStep;
        var output = StepParser.getInstance().parse(input.descend());
        if (absolute && output == null) {
            // path of "/"
            firstStep = null;
        } else if (output.result == null) {
            if (absolute) {
                // path of "/."
                firstStep = null;
            } else {
                // path of "."
                firstStep = new TypeStep(NodeCategory.Node);
            }
            input = output.getNextInput();
        } else {
            firstStep = cast(output.result, PathStep);
            input = output.getNextInput();
        }

        if (!input.hasNext()) {
            throw new ParseError("Invalid token stream");
        }

        token = input.next();
        if (!Std.is(token, EndPathToken)) {
            throw new ParseError("Invalid token stream");
        }

        var result:Expression;
        if (absolute) {
            result = new RootStep(firstStep);
        } else {
            result = firstStep;
        }

        return input.getOutput(input.count, result);
    }
}
