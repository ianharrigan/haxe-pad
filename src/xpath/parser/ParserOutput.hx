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


package xpath.parser;
import xpath.expression.Expression;


/** Class representing the output from parsing. */
class ParserOutput {
    /** The [Expression] resulting from parsing. */
    public var result (default, null):Expression;

    var getNextInputCallback:Void -> ParserInput;


    /** Do not call this constructor directly. Instead, call
     * [getOutput] on the [ParserInput] that was parsed.
     *
     * Constructs a [ParserOutput] representing a [result]
     * [Expression]. [getNextInputCallback] should be a function that
     * returns a [ParserInput] for the next stage of parsing, or
     * [null] if parsing was completed. [getNextInputCallback] may be
     * called more than once, and must return a freshly constructed
     * [ParserInput] each time. */
    public function new(result2:Expression, ?getNextInputCallback:Void -> ParserInput) {
        this.result = result2;
        this.getNextInputCallback = getNextInputCallback;
    }

    /** Returns true if tokenization was completed. */
    public function isComplete():Bool {
        return getNextInputCallback == null;
    }

    /** Gets the [ParserInput] to be passed to the next stage of
     * parsing. Throws [ParseError] if parsing is already
     * complete. */
    public function getNextInput() {
        if (getNextInputCallback != null) {
            return getNextInputCallback();
        } else {
            throw new ParseError("Unexpected end of query");
        }
    }
}
