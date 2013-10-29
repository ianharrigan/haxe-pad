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
import xpath.xml.XPathXml;
import xpath.EvaluationException;


class FilterStep extends PathStep {
    var expression:Expression;


    public function new(expression:Expression, ?nextStep:PathStep) {
        super(filterStep, nextStep);
        this.expression = expression;
    }

    function filterStep(context:Context):Iterable<XPathXml> {
        var result = expression.evaluate(context);
        if (Std.is(result, XPathNodeSet)) {
            return (cast(result, XPathNodeSet).getNodes());
        } else {
            throw new EvaluationException("Filter expression evaluated to a " +
                    result.typeName + ", but a node set was expected");
        }
    }
}
