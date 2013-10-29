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


/** [Tokenizer] which tokenizes according to the [DeepStepDelimiter]
 * rule. */
class DeepStepDelimiterTokenizer extends TokenTokenizer {
    static var instance:DeepStepDelimiterTokenizer;


    /** Gets the instance of [DeepStepDelimiterTokenizer]. */
    public static function getInstance() {
        if (instance == null) {
            instance = new DeepStepDelimiterTokenizer();
        }

        return instance;
    }

    function new() {
    }

    override public function tokenize(input:TokenizerInput) {
        if (input.query.substr(input.position, 2) == "//") {
            var result = [
                cast(new StepDelimiterToken(), Token),
                new AxisToken(DescendantOrSelf),
                new TypeTestToken(Node),
                new StepDelimiterToken()
            ];
            var characterLength = 2 + countWhitespace(input.query, input.position + 2);
            return input.getOutput(result, characterLength);
        } else {
            throw new ExpectedException([{ tokenName: "DeepStepDelimiter", position: input.position }]);
        }
    }
}
