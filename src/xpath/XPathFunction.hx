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


package xpath;
import xpath.context.Context;
import xpath.value.XPathValue;


/** A function which may be called from within an XPath query. A function call within
 * XPath is an expression, and all XPath expressions are influenced by some context
 * (see xpath.context.Context). This context is passed to the function as
 * the first argument.
 *
 * XPath functions accept a variable number of dynamically typed parameters, and return
 * a single dynamically typed result. XPath data types are implemented by XPathValue
 * and its subclasses. The parameters passed by the query are therefore passed on to
 * the XPathFunction as an Array of XPathValue, and the XPathFunction returns an
 * XPathValue (which may be null).
 * 
 * A function which for some reason fails to evaluate (for example incorrect parameter
 * count) should throw [xpath.EvaluationException]. */
typedef XPathFunction = Context -> Array<XPathValue> -> XPathValue
