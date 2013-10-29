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
import xpath.tokenizer.util.Sequence;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.TokenizerException;
import xpath.tokenizer.Token;


/** Tokenizer which tokenizes according to a sequence of rules which
 * may repeat zero or more times, e.g. [(A B C)*]. */
class Repetition extends Sequence {
    /** Constructs a new [Repetition] that tokenizes according to
     * the sequence of rules tokenized by [tokenizers]. */
    public function new(tokenizers:Iterable<Tokenizer>) {
        super(tokenizers);
    }

    override public function tokenize(input:TokenizerInput) {
        var workingInput = input;
        var result = new Array<Token>();
        var characterLength:Null<Int> = 0;

        var done = false;
        while (!done) {
            try {
                var output = super.tokenize(workingInput);
                result = result.concat(output.result);
                characterLength += output.characterLength;
                if (output.isComplete()) {
                    characterLength = null;
                    done = true;
                } else {
                    workingInput = output.getNextInput();
                }
            } catch (exception:TokenizerException) {
                done = true;
            }
        }

        return input.getOutput(result, characterLength);
    }
}
