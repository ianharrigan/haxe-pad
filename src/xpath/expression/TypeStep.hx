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


package xpath.expression;
import xpath.context.Context;
import xpath.xml.XmlNodeType;
import xpath.NodeCategory;


class TypeStep extends PathStep {
    var type:NodeCategory;


    public function new(type:NodeCategory, ?nextStep:PathStep) {
        super(typeStep, nextStep);
        this.type = type;
    }

    function typeStep(context:Context) {
        var node = context.node;
        var nodeType = context.node.getType();

        switch (type) {
            case NodeCategory.Node:
                if (nodeType == XmlNodeType.Element || nodeType == XmlNodeType.Attribute) {
                    return [node];
                }

            case NodeCategory.Text:
                if (nodeType == XmlNodeType.Text) {
                    return [node];
                }

            case NodeCategory.Comment:
                if (nodeType == XmlNodeType.Comment) {
                    return [node];
                }
        }

        return [];
    }
}
