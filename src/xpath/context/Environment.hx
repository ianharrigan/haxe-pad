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


/** An Environment provides a set of function definitions and
 * variables which may be referenced by an XPath query. Users should
 * not implement Environment directly but should either extend
 * BaseEnvironment, or construct an Environment dynamically using
 * DynamicEnvironment. */
interface Environment {
    /** Tests if a function with the specified name is provided by
     * this environment. */
    public function existsFunction(name:String):Bool;

    /** Returns a reference to the function with the specified
     * name. */
    public function getFunction(name:String):XPathFunction;

    /** Calls a function with the specified parameters and returns the
     * result. */
    public function callFunction(context:Context, name:String, ?parameters:Array<XPathValue>):XPathValue;

    /** Tests if a variable with the specified name is provided by
     * this environment. */
    public function existsVariable(name:String):Bool;

    /** Gets the value of the variable with the specified name. */
    public function getVariable(name:String):XPathValue;
}
