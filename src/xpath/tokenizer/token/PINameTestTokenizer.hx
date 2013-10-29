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


/** [Tokenizer] which tokenizes according to the [PINameTest]
 * rule. */
class PINameTestTokenizer extends TokenTokenizer {
    static var instance:PINameTestTokenizer;


    public static function getInstance() {
        if (instance == null) {
            instance = new PINameTestTokenizer();
        }

        return instance;
    }

    function new() {
    }

    override public function tokenize(input:TokenizerInput) {
        var pos = input.position;

        if (input.query.substr(pos, 22) != "processing-instruction") {
            throw new ExpectedException([{ tokenName: "PINameTest", position: input.position }]);
        }

        pos += 22;
        pos += countWhitespace(input.query, pos);

        if (input.query.charAt(pos) != "(") {
            throw new ExpectedException([{ tokenName: "PINameTest", position: input.position }]);
        }

        ++pos;
        pos += countWhitespace(input.query, pos);

        var name;
        var quote = input.query.charAt(pos);
        if (quote == "'" || quote == '"') {
            var nameStartPos = pos + 1;

            var char;
            do {
                char = input.query.charAt(++pos);
            } while (char != quote && pos < input.query.length - 1);

            if (char == quote) {
                name = input.query.substr(
                    nameStartPos, pos - nameStartPos
                );
            } else {
                throw new ExpectedException([{ tokenName: "PINameTest", position: input.position }]);
            }

            ++pos;
            pos += countWhitespace(input.query, pos);
        } else {
            name = null; // any processing instruction
        }

        if (input.query.charAt(pos) == ")") {
            ++pos;
            pos += countWhitespace(input.query, pos);

            var result = [ cast(new PINameTestToken(name), Token) ];
            var characterLength = pos - input.position;
            return input.getOutput(result, characterLength);
        } else {
            throw new ExpectedException([ { tokenName: "PINameTest", position: input.position } ]);
        }
    }
}
