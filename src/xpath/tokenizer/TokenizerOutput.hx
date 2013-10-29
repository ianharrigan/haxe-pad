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


/** Class representing the output from tokenization. */
class TokenizerOutput {
    /** The [Array] of [Token]s resulting from tokenization. */
    public var result (default, null):Array<Token>;

    /** The number of characters which were tokenized. */
    public var characterLength (default, null):Int;

    var nextInput:TokenizerInput;


    /** Do not call this constructor directly. Instead, call
     * [getOutput] on the [TokenizerInput] that was tokenized.
     *
     * Constructs a [TokenizerOutput] representing a [result]
     * consisting of the specified sequence of tokens.
     * [characterLength] specifies the number of characters that were
     * successfully tokenized, and [nextInput] provides a
     * [TokenizerInput] representing the input for the next stage of
     * tokenization. If [nextInput] is [null], tokenization is
     * deemed to be complete. */
    public function new(result2:Array<Token>, characterLength:Int, nextInput:TokenizerInput) {
        this.result = result2;
        this.characterLength = characterLength;
        this.nextInput = nextInput;
    }

    /** Returns true if tokenization was completed. */
    public function isComplete():Bool {
        return nextInput == null;
    }

    /** Gets the [TokenizerInput] to be passed to the next stage of
     * tokenization. Throws [TokenizerException] if tokenization is
     * already complete. */
    public function getNextInput() {
        if (nextInput != null) {
            return nextInput;
        } else {
            throw new TokenizerException("Unexpected end of query");
        }
    }
}
