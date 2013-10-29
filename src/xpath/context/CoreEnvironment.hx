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
import xpath.library.BooleanLibrary;
import xpath.library.NumberLibrary;
import xpath.library.StringLibrary;
import xpath.library.NodeSetLibrary;


/** Singleton implementing the core environment which is available to
 * all XPath queries. The core environment consists of those functions
 * defined by the XPath specification as the core function library,
 * and no variables. */
class CoreEnvironment extends BaseEnvironment {
    static var instance:CoreEnvironment;


    /** Gets the core environment instance. */
    public static function getInstance() {
        if (instance == null) {
            instance = new CoreEnvironment();
            instance.init();
        }

        return instance;
    }

    function new() {
        super();
    }

    function init():Void {
        functions.set("last", NodeSetLibrary.last);
        functions.set("position", NodeSetLibrary.position);
        functions.set("count", NodeSetLibrary.count);
        functions.set("local-name", NodeSetLibrary.localName);
        functions.set("name", NodeSetLibrary.nodeName);

        functions.set("string", StringLibrary.string);
        functions.set("concat", StringLibrary.concat);
        functions.set("starts-with", StringLibrary.startsWith);
        functions.set("contains", StringLibrary.contains);
        functions.set("substring-before", StringLibrary.substringBefore);
        functions.set("substring-after", StringLibrary.substringAfter);
        functions.set("substring", StringLibrary.substring);
        functions.set("string-length", StringLibrary.stringLength);
        functions.set("normalize-space", StringLibrary.normalizeSpace);
        functions.set("translate", StringLibrary.translate);

        functions.set("boolean", BooleanLibrary.boolean);
        functions.set("true", BooleanLibrary.getTrue);
        functions.set("false", BooleanLibrary.getFalse);

        functions.set("number", NumberLibrary.number);
        functions.set("sum", NumberLibrary.sum);
        functions.set("floor", NumberLibrary.floor);
        functions.set("ceiling", NumberLibrary.ceiling);
        functions.set("round", NumberLibrary.round);
    }
}
