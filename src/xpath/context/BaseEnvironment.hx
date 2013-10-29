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

import xpath.value.XPathValue;
import xpath.EvaluationException;


/** Base implementation of Environment which may be extended by users.
 *
 * An environment provides a set of named variables and functions
 * which may be referenced from an XPath query. Variables should be of
 * the type [xpath.value.XPathValue] (or a derivative type). Functions
 * must match the signature defined by [xpath.XPathFunction].
 *
 * This class provides two private variables, [functions] and
 * [variables], which hash functions and variables by name. To add or
 * remove functions or variables, simply add them to or remove them
 * from the corresponding Hash (for example, in the constructor).
 *
 * For an example of an Environment implemented by extending
 * BaseEnvironment, see the source code for [CoreEnvironment]. */
class BaseEnvironment implements Environment {
    var functions:Map<String, XPathFunction>;
    var variables:Map<String, XPathValue>;

    function new() {
        functions = new Map<String, XPathFunction>();
        variables = new Map<String, XPathValue>();
    }

    /** Tests if a function with the specified name is provided by
     * this environment. */
    public function existsFunction(name:String) {
        return functions.get(name) != null;
    }

    /** Returns a reference to the function with the specified
     * name. */
    public function getFunction(name:String):XPathFunction {
        var f = functions.get(name);
        if (f == null) {
            throw new EvaluationException("evaluated a function which is not defined");
        } else {
            return f;
        }
    }

    /** Calls a function with the specified parameters and returns the
     * result. Throws EvaluationException if the function is not
     * defined. */
    public function callFunction(context:Context, name:String, ?parameters:Array<XPathValue>) {
        return getFunction(name)(context, parameters);
    }

    /** Tests if a variable with the specified name is provided by
     * this environment. */
    public function existsVariable(name:String) {
        return variables.get(name) != null;
    }

    /** Gets the value of the variable with the specified name.
     * Throws EvaluationException if the variable is not defined. */
    public function getVariable(name:String) {
        var value = variables.get(name);
        if (value == null) {
            throw new EvaluationException("evaluated a variable which is not defined");
        } else {
            return value;
        }
    }
}
