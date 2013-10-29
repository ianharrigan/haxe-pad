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


/** [Tokenizer] which tokenizes according to the [Number] rule */
class NumberTokenizer extends TokenTokenizer {
    static var instance:NumberTokenizer;


    /** Gets the instance of [NumberTokenizer]. */
    public static function getInstance() {
        if (instance == null) {
            instance = new NumberTokenizer();
        }

        return instance;
    }

    function new() {
    }

    override public function tokenize(input:TokenizerInput) {
        var pos = input.position - 1;

        // check for digits
        var charCode;
        do {
            charCode = input.query.charCodeAt(++pos);
        } while (charCode > 47 && charCode < 58);

        // check for decimal point
        if (charCode != 46) {
            if (pos > input.position) {
                var value = Std.parseFloat(input.query.substr(input.position, pos - input.position));
                var result = [ cast(new NumberToken(value), Token) ];
                var characterLength = pos - input.position;
                characterLength += countWhitespace(input.query, pos);
                return input.getOutput(result, characterLength);
            } else {
                throw new ExpectedException([{ tokenName: "Number", position: input.position }]);
            }
        }

        // check for digits
        do {
            charCode = input.query.charCodeAt(++pos);
        } while (charCode > 47 && charCode < 58);

        if (pos > input.position + 1) {
            var value = Std.parseFloat(input.query.substr(input.position, pos - input.position));
            var result = [ cast(new NumberToken(value), Token) ];
            var characterLength = pos - input.position;
            characterLength += countWhitespace(input.query, pos);
            return input.getOutput(result, characterLength);
        } else {
            throw new ExpectedException([{ tokenName: "Number", position: input.position }]);
        }
    }
}
