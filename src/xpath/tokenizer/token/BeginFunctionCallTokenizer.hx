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


/** [Tokenizer] which tokenizes according to the [BeginFunctionCall]
 * rule. */
class BeginFunctionCallTokenizer extends TokenTokenizer {
    static var instance:BeginFunctionCallTokenizer;


    /** Gets the instance of [BeginFunctionCall]. */
    public static function getInstance() {
        if (instance == null) {
            instance = new BeginFunctionCallTokenizer();
        }

        return instance;
    }

    function new() {
    }

    override public function tokenize(input:TokenizerInput) {
        var pos = input.position;

        // check for NCName
        var charCode = input.query.charCodeAt(pos);
        if ((charCode < 65 || charCode > 90) &&
                (charCode < 97 || charCode > 122) &&
                charCode < 128 && charCode != 95) {
            throw new ExpectedException([{
                tokenName: "BeginFunctionCall",
                position: input.position
            }]);
        }

        do {
            charCode = input.query.charCodeAt(++pos);
        } while ((charCode > 47 && charCode < 58) ||
                (charCode > 64 && charCode < 91) ||
                (charCode > 96 && charCode < 123) ||
                charCode > 127 || charCode == 46 ||
                charCode == 45 || charCode == 95);

        // check for colon
        if (charCode == 58) {
            // check for NCName
            charCode = input.query.charCodeAt(++pos);
            if ((charCode < 65 || charCode > 90) &&
                    (charCode < 97 || charCode > 122) &&
                    charCode < 128 && charCode != 95) {
                throw new ExpectedException([{
                    tokenName: "BeginFunctionCall",
                    position: input.position
                }]);
            }

            do {
                charCode = input.query.charCodeAt(++pos);
            } while ((charCode > 47 && charCode < 58) ||
                    (charCode > 64 && charCode < 91) ||
                    (charCode > 96 && charCode < 123) ||
                    charCode > 127 || charCode == 46 ||
                    charCode == 45 || charCode == 95);
        }

        var name = input.query.substr(input.position, pos - input.position);
        pos += countWhitespace(input.query, pos);

        // check name
        switch (name) {
            // comment(), text(), node() and processing-instruction() must not parse as functions
            case "comment", "text", "node", "processing-instruction":
                throw new ExpectedException([{ tokenName: "BeginFunctionCall", position: input.position }]);

            default:
        }

        // check for open parenthesis
        if (input.query.charAt(pos) != "(") {
            throw new ExpectedException([{ tokenName: "BeginFunctionCall", position: input.position }]);
        }

        ++pos;
        pos += countWhitespace(input.query, pos);

        var result = [ cast(new BeginFunctionCallToken(name), Token) ];
        var characterLength = pos - input.position;
        return input.getOutput(result, characterLength);
    }
}
