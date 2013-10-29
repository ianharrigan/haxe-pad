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
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.TokenizerOutput;
import xpath.tokenizer.TokenizerError;


/** Abstract base class for [Tokenizer]s that tokenize according to
 * <i>token rules</i>. This class exists to provide the convenience
 * function [countWhitespace]. */
class TokenTokenizer implements Tokenizer {
    /** Abstract function; must be overridden by descendant classes.
     *
     * Tokenizes [input], which represents a partially tokenized
     * XPath query string. Returns the resulting [TokenizerOutput].
     *
     * Throws [TokenizerException] if the [input] cannot be
     * tokenized by this [Tokenizer]. */
    public function tokenize(input:TokenizerInput):TokenizerOutput {
        throw new TokenizerError("xpath.tokenizer.token.TokenTokenizer.tokenize() must " +
                "be overridden");
        return null;
    }

    /** Counts the number of sequential whitespace characters in
     * [query] beginning with the character indexed by [start]. */
    public function countWhitespace(query:String, start:Int) {
        var i = -1;
        var char;
        do {
            char = query.charAt(start + ++i);
        } while (char == "\x20" || char == "\x09" || char == "\x0d" || char == "\x0a");
        return i;
    }
}
