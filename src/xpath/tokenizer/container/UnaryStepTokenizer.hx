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


package xpath.tokenizer.container;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.util.Sequence;
import xpath.tokenizer.util.Disjunction;
import xpath.tokenizer.util.Repetition;
import xpath.tokenizer.container.NodeTestTokenizer;
import xpath.tokenizer.container.PredicateTokenizer;
import xpath.tokenizer.token.AxisTokenizer;
import xpath.tokenizer.token.AbbreviatedStepTokenizer;


/** [Tokenizer] which tokenizes according to the [UnaryStep]
 * rule. */
class UnaryStepTokenizer implements Tokenizer {
    static var instance:UnaryStepTokenizer;

    var tokenizer:Tokenizer;


    /** Gets the instance of [UnaryStepTokenizer]. */
    public static function getInstance() {
        if (instance == null) {
            instance = new UnaryStepTokenizer();
            instance.init();
        }

        return instance;
    }

    function new() {
    }

    function init() {
        tokenizer = new Disjunction([
            cast(new Sequence([
                cast(AxisTokenizer.getInstance(), Tokenizer),
                NodeTestTokenizer.getInstance(),
                new Repetition([
                    cast(PredicateTokenizer.getInstance(), Tokenizer)
                ])
            ]), Tokenizer),
            AbbreviatedStepTokenizer.getInstance()
        ]);
    }

    /** Tokenizes [input], which represents a partially tokenized
     * XPath query string. Returns the resulting [TokenizerOutput].
     *
     * Throws [TokenizerException] if the [input] cannot be
     * tokenized by this [Tokenizer]. */
    public function tokenize(input:TokenizerInput) {
        return tokenizer.tokenize(input);
    }
}
