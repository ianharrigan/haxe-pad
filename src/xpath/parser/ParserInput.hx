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
import xpath.tokenizer.Token;


/** Class representing some input for parsing. */
class ParserInput {
    /** The count of tokens that have been consumed so far. */
    public var count (default, null):Int;

    var tokens:Array<Token>;


    /** Constructs a new [ParserInput] representing the specified
     * sequence of [tokens]. */
    public function new(tokens:Array<Token>) {
        this.tokens = tokens;
        count = 0;
    }

    /** Tests if there are any more [Token]s in the input. */
    public function hasNext() {
        return (count < tokens.length);
    }

    /** Returns the next input [Token]. */
    public function next() {
        return tokens[count++];
    }

    /** Steps back one [Token], reversing the effect of the last call
     * to [next]. Throws [ParseError] if attempting to step back past
     * the first [Token]. */
    public function back() {
        if (count > 0) {
            --count;
        } else {
            throw new ParseError();
        }
    }

    /** Resets [count], [hasNext] and [next] such that they restart
     * from the beginning of the token stream. */
    public function restart() {
        count = 0;
    }

    /** Gets a new [ParserInput] that begins at the current position
     * in the token stream. */
    public function descend() {
        return new ParserInput(tokens.slice(count));
    }

    /** Gets a [ParserOutput] representing the [result] of
     * successfully parsing [count] [Token]s from the input. */
    public function getOutput(count:Int, result:Expression) {
        var nextTokens = tokens.slice(count);
        if (nextTokens.length > 0) {
            var getNextInput = function() {
                return new ParserInput(nextTokens);
            };
            return new ParserOutput(result, getNextInput);
        } else {
            return new ParserOutput(result);
        }
    }
}
