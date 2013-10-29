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
import xpath.XPathException;


/** Exception thrown if a given query or query fragment cannot be
 * tokenized */
class TokenizerException extends XPathException {
    /** Character position at which tokenization failed. */
    public var position (default, null):Null<Int>;


    /** Constructs a new [TokenizerException], optionally including
     * the character [position] at which tokenization failed and/or
     * a [message] describing the problem. */
    public function new(?position:Null<Int>, ?message:String) {
        super(message);
        this.position = position;
    }

    /** Gets a string representation of the [TokenizerException]. */
    override public function toString() {
        var string = "";
        if (position != null) {
            string = "character " + Std.string(position) + ": ";
        }
        if (message != null && message != "") {
            string += message;
        } else {
            string += "TokenizerException";
        }
        return string;
    }
}
