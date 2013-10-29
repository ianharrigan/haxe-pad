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


package xpath.tokenizer.util;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.TokenizerOutput;
import xpath.tokenizer.ExpectedException;
import xpath.tokenizer.TokenizerError;


/** [Tokenizer] which tokenizes a string in a manner corresponding to
 * EBNF disjunctions, e.g. [A | B | C].
 *
 * Only one rule is ever successful. If two or more rules match, the
 * rule that matches the longest string of characters is chosen. If
 * two or more rules match the same number of characters, the rule
 * listed first is preferred. */
class Disjunction implements Tokenizer {
    var tokenizers:Iterable<Tokenizer>;


    /** Constructs a new [Disjunction] which tokenizes the
     * disjunction of [tokenizers]. */
    public function new(tokenizers:Iterable<Tokenizer>) {
        if (tokenizers.iterator().hasNext()) {
            this.tokenizers = tokenizers;
        } else {
            throw new TokenizerError("Attempted to create an empty disjunction");
        }
    }

    /** Tokenizes [input], which represents a partially tokenized
     * XPath query string. Returns the resulting [TokenizerOutput].
     *
     * Throws [TokenizerException] if the [input] cannot be
     * tokenized by this [Tokenizer]. */
    public function tokenize(input:TokenizerInput) {
        var expectedTokens = new List<{tokenName:String, position:Int}>();
        var output:TokenizerOutput = null;

        for (tokenizer in tokenizers) {
            try {
                var tmpOutput = tokenizer.tokenize(input);
                if (output == null || tmpOutput.characterLength > output.characterLength) {
                    output = tmpOutput;
                }
            } catch (exception:ExpectedException) {
                for (expectedToken in exception.expectedTokens) {
                    expectedTokens.push(expectedToken);
                }
            }
        }

        if (output == null) {
            throw new ExpectedException(expectedTokens);
        } else {
            return output;
        }
    }
}
