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
import xpath.value.XPathNodeSet;
import xpath.value.XPathValue;
import xpath.xml.XPathXml;


class PathStep implements Expression {
    var step:Context -> Iterable<XPathXml>;
    var nextStep:PathStep;


    function new(step:Context -> Iterable<XPathXml>, ?nextStep:PathStep) {
        this.step = step;
        this.nextStep = nextStep;
    }

    public function evaluate(context:Context):XPathNodeSet {
        if (nextStep == null) {
            return new XPathNodeSet(step(context));
        } else {
            var me = this;
            var index = 0;
            var selected = Lambda.array(step(context));
            var nextNode = null;
            var nextStepNodes = new List<XPathXml>().iterator();
            var hasNext = function() {
                return nextNode != null;
            };
            var next = function() {
                var node = nextNode;
                while (!nextStepNodes.hasNext() && index < selected.length) {
                    var nextStepContext = new Context(selected[index], index + 1, selected.length, context.environment);
                    var nextStepResult = me.nextStep.evaluate(nextStepContext);
                    nextStepNodes = nextStepResult.getNodes().iterator();
                    ++index;
                }
                if (nextStepNodes.hasNext()) {
                    nextNode = nextStepNodes.next();
                } else {
                    nextNode = null;
                }
                return node;
            };
            next();
            var iterator = function() {
                return {
                    hasNext: hasNext,
                    next: next
                };
            }
            return new XPathNodeSet({iterator: iterator});
        }
    }
}
