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


package xpath.context;
import xpath.xml.XPathXml;
import xpath.value.XPathValue;


/** Class implementing an evaluation context as defined by the XPath
 * specification. Evaluation context consists of: <ul>
 * <li>the context node,
 * <li>the context position,
 * <li>the context size,
 * <li>the environment, which provides a set of variable and function
 *  definitions. </ul> */
class Context {
    /** The context node. */
    public var node (default, null):XPathXml;

    /** The context position. */
    public var position (default, null):Int;

    /** The context size. */
    public var size (default, null):Int;

    /** The environment. */
    public var environment (default, null):Environment;


    /** Constructs a new Context. */
    public function new(node:XPathXml, position:Int, size:Int, environment:Environment) {
        this.node = node;
        this.position = position;
        this.size = size;
        this.environment = environment;
    }

    /** Calls a function with the specified parameters and returns the
     * result. */
    public function callFunction(name:String, ?parameters:Array<XPathValue>) {
        if (parameters == null) {
            parameters = new Array<XPathValue>();
        }

        return environment.callFunction(this, name, parameters);
    }

    /** Gets the value of the variable with the specified name. */
    public function getVariable(name:String) {
        return environment.getVariable(name);
    }
}
