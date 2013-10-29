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


/** Class implementing an environment which may be modified at runtime. */
class DynamicEnvironment extends BaseEnvironment {
    public function new() {
        super();
    }

    /** Defines a function with the specified name. */
    public function setFunction(name:String, f:XPathFunction):Void {
        functions.set(name, f);
    }

    /** Removes the function with the specified name. */
    public function removeFunction(name:String):Void {
        functions.remove(name);
    }

    /** Defines a variable with the specified name and value. */
    public function setVariable(name:String, value:XPathValue):Void {
        variables.set(name, value);
    }

    /** Removes the variable with the specified name. */
    public function removeVariable(name:String):Void {
        variables.remove(name);
    }
}
