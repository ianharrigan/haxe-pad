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


/** Base class for tokenizers which tokenize a fixed string into a
 * single [Token]. To use it, extend [FixedStringTokenizer] and call
 * [super()] with the following arguments:<ul>
 * <li>[token:Token]&mdash;the [Token] that should be output if
 *  the input string is successfully tokenized.</li>
 * <li>[string:String]&mdash;the input string that tokenizes into
 *  [token].</li>
 * <li>[tokenName:String]&mdash;a text name for the [token]. Used to
 *  report back to the user in the event of tokenization failure. */
class FixedStringTokenizer extends TokenTokenizer {
    var token:Token;
    var string:String;
    var tokenName:String;


    private function new(token:Token, string:String, tokenName:String) {
        this.token = token;
        this.string = string;
        this.tokenName = tokenName;
    }

    override public function tokenize(input:TokenizerInput) {
        if (input.query.substr(input.position, string.length) == string) {
            var result = [ token ];
            var characterLength = string.length;
            characterLength += countWhitespace(input.query, input.position + characterLength);
            return input.getOutput(result, characterLength);
        } else {
            throw new ExpectedException ([{ tokenName: tokenName, position: input.position }]);
        }
    }
}
