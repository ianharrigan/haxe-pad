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
import xpath.Axis;


/** [Tokenizer] which tokenizes according to the [Axis] rule. */
class AxisTokenizer extends TokenTokenizer {
    static var instance:AxisTokenizer;
    var axisNames:Array<String>;
    var axisNameToAxis:Map<String, Axis>;


    /** Gets the instance of [AxisTokenizer]. */
    public static function getInstance() {
        if (instance == null) {
            instance = new AxisTokenizer();
        }

        return instance;
    }

    function new() {
        axisNameToAxis = new Map<String, Axis>();
        axisNameToAxis.set("ancestor", Ancestor);
        axisNameToAxis.set("ancestor-or-self", AncestorOrSelf);
        axisNameToAxis.set("attribute", Attribute);
        axisNameToAxis.set("child", Child);
        axisNameToAxis.set("descendant", Descendant);
        axisNameToAxis.set("descendant-or-self", DescendantOrSelf);
        axisNameToAxis.set("following", Following);
        axisNameToAxis.set("following-sibling", FollowingSibling);
        axisNameToAxis.set("namespace", Namespace);
        axisNameToAxis.set("parent", Parent);
        axisNameToAxis.set("preceding", Preceding);
        axisNameToAxis.set("preceding-sibling", PrecedingSibling);
        axisNameToAxis.set("self", Self);

        axisNames = new Array<String>();
        for (axisName in axisNameToAxis.keys()) {
            axisNames.push(axisName);
        }

        // sort names by length, longest first
        axisNames.sort(function(x:String, y:String) {
            return y.length - x.length;
        });
    }

    override public function tokenize(input:TokenizerInput) {
        var pos = input.position;

        var axis = null;
        for (axisName in axisNames) {
            if (input.query.substr(pos, axisName.length) == axisName) {
                pos += axisName.length;
                pos += countWhitespace(input.query, pos);

                if (input.query.substr(pos, 2) == "::") {
                    pos += 2;
                    axis = axisNameToAxis.get(axisName);
                } else {
                    pos = input.position;
                    axis = Child;
                }
                break;
            }
        }

        if (axis == null) {
            if (input.query.charAt(pos) == "@") {
                axis = Attribute;
                ++pos;
            } else {
                axis = Child;
            }
        }

        pos += countWhitespace(input.query, pos);

        var characterLength = pos - input.position;
        var result = [ cast(new AxisToken(axis), Token) ];

        return input.getOutput(result, characterLength);
    }
}
