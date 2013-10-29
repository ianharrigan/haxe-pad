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


/** [Tokenizer] which tokenizes according to the [Literal] rule. */
class LiteralTokenizer extends TokenTokenizer {
    static var instance:LiteralTokenizer;


    /** Gets the instance of [LiteralTokenizer]. */
    public static function getInstance() {
        if (instance == null) {
            instance = new LiteralTokenizer();
        }

        return instance;
    }

    function new() {
    }

    override public function tokenize(input:TokenizerInput) {
        var pos = input.position;

        var quote = input.query.charAt(pos);
        if (quote != "'" && quote != '"') {
            throw new ExpectedException([{ tokenName: "Literal", position: input.position }]);
        }

        var valueStartPos = pos + 1;
        var char;
        do {
            char = input.query.charAt(++pos);
        } while (char != quote && pos < input.query.length - 1);

        if (char == quote) {
            var value = input.query.substr(valueStartPos, pos - valueStartPos);
            ++pos;
            pos += countWhitespace(input.query, pos);

            var result = [ cast(new LiteralToken(value), Token) ];
            var characterLength = pos - input.position;
            return input.getOutput(result, characterLength);
        } else {
            throw new ExpectedException([{ tokenName: "Literal", position: input.position }]);
        }
    }
}
