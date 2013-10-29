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


package xpath.parser;
import xpath.parser.ParserInput;
import xpath.parser.ParserOutput;


/** The process of parsing an XPath query string is implemented in two
 * parts&mdash;a "tokenizer", implemented in [xpath.tokenizer], and a
 * parser, implemented in [xpath.parser].
 *
 * The tokenizer is in fact a scannerless recursive descent parser;
 * it is referred to as a "tokenizer" because although it is
 * implemented as a parser it does not directly build a parse tree.
 * Instead, its output is an [Array] of [Token]s which unambiguously
 * represent the query. Both structural and semantic information is
 * represented by [Token]s, such that a parse tree may be efficiently
 * constructed from the tokens in a sequential, context-free manner.
 *
 * Once tokenization is complete, the resulting [Array] of [Token]s
 * is passed to the parser, which uses the [Token]s to build a parse
 * tree (represented by the classes in [xpath.expression]). */
interface Parser {
    public function parse(input:ParserInput):ParserOutput;
}
