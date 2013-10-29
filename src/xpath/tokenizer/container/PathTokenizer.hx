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
import xpath.tokenizer.container.StepDelimitersTokenizer;
import xpath.tokenizer.container.StepTokenizer;
import xpath.tokenizer.container.UnaryStepTokenizer;
import xpath.tokenizer.token.BeginPathTokenizer;
import xpath.tokenizer.token.EndPathTokenizer;


/** [Tokenizer] which tokenizes according to the [Path] rule. */
class PathTokenizer implements Tokenizer {
    static var instance:PathTokenizer;

    var tokenizer:Tokenizer;


    /** Gets the instance of [PathTokenizer]. */
    public static function getInstance() {
        if (instance == null) {
            instance = new PathTokenizer();
            instance.init();
        }

        return instance;
    }

    function new() {
    }

    function init() {
        tokenizer = new Sequence([
            cast(BeginPathTokenizer.getInstance(), Tokenizer),
            new Disjunction([
                cast(StepDelimitersTokenizer.getInstance(), Tokenizer),
                new Sequence([
                    cast(new Disjunction([
                        cast(new Sequence([
                            cast(StepDelimitersTokenizer.getInstance(), Tokenizer),
                            UnaryStepTokenizer.getInstance()
                        ]), Tokenizer), StepTokenizer.getInstance()
                    ]), Tokenizer),
                    new Repetition([
                        cast(StepDelimitersTokenizer.getInstance(), Tokenizer),
                        UnaryStepTokenizer.getInstance()
                    ])
                ])
            ]), EndPathTokenizer.getInstance()
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
