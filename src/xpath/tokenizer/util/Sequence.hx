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


/** Tokenizer which tokenizes according to a sequence of rules, e.g.
 * [A B C].*/
class Sequence implements Tokenizer {
    private var tokenizers:Iterable<Tokenizer>;


    /** Constructs a new [Sequence] that tokenizes according to
     * the sequence of rules tokenized by [tokenizers]. */
    public function new(tokenizers:Iterable<Tokenizer>) {
        this.tokenizers = tokenizers;
    }

    /** Tokenizes [input], which represents a partially tokenized
     * XPath query string. Returns the resulting [TokenizerOutput].
     *
     * Throws [TokenizerException] if the [input] cannot be
     * tokenized by this [Tokenizer]. */
    public function tokenize(input:TokenizerInput) {
        var iterator = tokenizers.iterator();
        var output = iterator.next().tokenize(input);
        var result = output.result;
        var characterLength = output.characterLength;
        while (iterator.hasNext()) {
            output = iterator.next().tokenize(output.getNextInput());
            result = result.concat(output.result);
            characterLength += output.characterLength;
        }

        return input.getOutput(result, characterLength);
    }
}
