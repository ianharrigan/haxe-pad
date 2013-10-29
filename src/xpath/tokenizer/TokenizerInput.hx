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


/** Class representing some input for tokenization. */
class TokenizerInput {
    /** The XPath query string. */
    public var query (default, null):String;

    /** The tokenization position within the XPath query string. */
    public var position (default, null):Int;


    /** Constructs a new [TokenizerInput] representing the specified
     * [query] at the specified [position]. If [position] is
     * ommitted, it defaults to [0] (the beginning of the query
     * string). */
    public function new(query:String, ?position:Int) {
        if (position == null) {
            position = 0;
        }

        this.query = query;
        this.position = position;
    }

    /** Gets a [TokenizerOutput] representing the [result] of
     * tokenization on this [TokenizerInput].
     *
     * [characterLength] specifies the number of characters that
     * were successfully tokenized. If it is specified, the
     * [TokenizerOutput] will contain a [TokenizerInput] to be
     * passed onto the next stage of tokenization. If it is
     * ommitted, tokenization is deemed to be completed. */
    public function getOutput(result:Array<Token>, ?characterLength:Int) {
        var nextInput = null;
        if (characterLength == null) {
            characterLength = query.length - position;
        } else {
            nextInput = new TokenizerInput(query, position + characterLength);
        }

        return new TokenizerOutput(result, characterLength, nextInput);
    }
}
