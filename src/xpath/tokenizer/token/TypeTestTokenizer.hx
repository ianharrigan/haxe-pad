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
import xpath.NodeCategory;


/** [Tokenizer] which tokenizes according to the [NodeCategory] rule. */
class TypeTestTokenizer extends TokenTokenizer {
    static var instance:TypeTestTokenizer;

    var typeNames:Array<String>;
    var typeTestNameToTypeTest:Map<String, NodeCategory>;


    /** Gets the instance of [TypeTestTokenizer]. */
    public static function getInstance() {
        if (instance == null) {
            instance = new TypeTestTokenizer();
        }

        return instance;
    }

    function new() {
        typeTestNameToTypeTest = new Map<String, NodeCategory>();
        typeTestNameToTypeTest.set("comment", Comment);
        typeTestNameToTypeTest.set("text", Text);
        typeTestNameToTypeTest.set("node", Node);

        typeNames = new Array<String>();
        for (typeName in typeTestNameToTypeTest.keys()) {
            typeNames.push(typeName);
        }

        // sort type names by length, longest first
        typeNames.sort(function(x:String, y:String) {
            return y.length - x.length;
        });
    }

    override public function tokenize(input:TokenizerInput) {
        var pos = input.position;

        for (typeName in typeNames) {
            if (input.query.substr(pos, typeName.length) == typeName) {
                pos += typeName.length;
                pos += countWhitespace(input.query, pos);

                if (input.query.charAt(pos) != "(") {
                    throw new ExpectedException([{ tokenName: "NodeCategory", position: input.position }]);
                }

                ++pos;
                pos += countWhitespace(input.query, pos);

                if (input.query.charAt(pos) != ")") {
                    throw new ExpectedException([{ tokenName: "NodeCategory", position: input.position }]);
                }

                ++pos;
                pos += countWhitespace(input.query, pos);

                var type:NodeCategory = typeTestNameToTypeTest.get(typeName);
                var result = [ cast(new TypeTestToken(type), Token) ];
                var characterLength = pos - input.position;
                return input.getOutput(result, characterLength);
            }
        }

        throw new ExpectedException([ { tokenName: "NodeCategory", position: input.position } ]);
    }
}
