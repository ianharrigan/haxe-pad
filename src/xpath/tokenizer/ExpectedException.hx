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

package xpath.tokenizer;


/** Exception thrown if a given query or query fragment cannot be
 * tokenized because an expected [Token] was not found. */
class ExpectedException extends TokenizerException {
    /** Names of expected [Token]s and the character positions at
     * which they were expected. */
    public var expectedTokens (default, null):Iterable<{tokenName:String, position:Int}>;


    /** Constructs a new [ExpectedException] indicating that the
     * specified [tokenName]s were expected at the specified
     * [position]s */
    public function new(expectedTokens:Iterable<{tokenName:String, position:Int}>) {
        var array = Lambda.array(expectedTokens);
        if (array.length > 0) {
            haxe.ds.ArraySort.sort(array,
                    function(token1:{tokenName:String, position:Int}, token2:{tokenName:String, position:Int}) {
                        return token1.position - token2.position;
                    });

            var expectedToken = array.shift();
            var position = expectedToken.position;
            var message = "Expected " + expectedToken.tokenName;
            for (expectedToken in array) {
                message += ", or " + expectedToken.tokenName;
                if (expectedToken.position > position) {
                    message += " at character ";
                    message += Std.string(expectedToken.position);
                }
            }

            super(position, message);
        } else {
            throw new TokenizerError("Attempted to create an ExpectedException with an empty expected tokens list");
        }

        this.expectedTokens = expectedTokens;
    }
}
