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


package xpath.tokenizer;


/** Interface for XPath tokenizers.
 *
 * The process of compiling an XPath from its query string is
 * implemented in two parts&mdash;a "tokenizer", implemented in
 * [xpath.tokenizer], and a parser, implemented in [xpath.parser].
 *
 * The tokenizer is in fact a scannerless recursive descent parser;
 * it is referred to as a "tokenizer" because it does not directly
 * build a parse tree. Instead, to ensure that the eventual parse
 * tree is as simple as possible, it constructs a sequence of
 * [Token]s which unambiguously represent the query. Both
 * structural and semantic information is represented by [Token]s,
 * such that a parse tree may be efficiently constructed from the
 * tokens in a sequential, context-free manner.
 *
 * <h2>Grammar</h2>
 * The grammar below intentionally does not match that specified
 * in the XPath specification due to implementation details
 * described above. However, this grammar is equivalent in that
 * any string that is valid according to the official XPath
 * grammar is also valid according to this grammar, and any
 * string that is invalid according to the official XPath grammar
 * is also invalid according to this grammar.
 *
 * The tokenizer consists of a number of classes implementing the
 * interface xpath.tokenizer.Tokenizer, each of which corresponds
 * to a single rule in the EBNF grammar below. To simplify the
 * implementation, the grammar distinguishes between <i>container
 * rules</i> and <i>token rules</i>.
 *
 * The grammar is notated in a similar EBNF language to that used
 * in W3C specifications:<ul>
 * <li>Rules have capitalised camel-case names corresponding
 *  directly to the names of the classes implementing those
 *  rules.</li>
 * <li><i>Token rules</i> consist of a sequence of literal strings
 *  and/or whitespace.</li>
 * <li><i>Container rules</i> consist of a sequence of other rules.
 *  Sequences of rules are implemented by the class
 *  [xpath.tokenizer.util.Sequence].</li>
 * <li>Rules, literals and other groups may be grouped by
 *  parentheses [( )].
 * <li>The asterisk [*] means that the preceding rule, literal or
 *  group repeats zero or more times. Repeating sequences of rules
 *  are implemented by the class
 *  [xpath.tokenizer.util.Repetition].</li>
 * <li>The query [?] means that the preceding rule, literal or group
 *  is optional. Optional sequences of rules are implemented by the
 *  class [xpath.tokenizer.util.Optional].</li>
 * <li>The pipe [|] means that exactly one of two or more alternative
 *  rules, literals or groups may be matched; [A | B | C] means
 *  <i>one</i> of the rules A, B or C.<br />
 *  The pipe binds tightly, so [A | B C] is equivalent to
 *  [( A | B ) C].<br />
 *  If two or more of the alternatives match, the alternative that
 *  matches the longest string of characters is chosen. If two or
 *  more alternatives match the same number of characters, the
 *  alternative listed first is preferred.<br />
 *  Disjunctions of rules are implemented by the class
 *  [xpath.tokenizer.util.Disjunction].</li>
 * </ul>
 *
 * <h3>Container rules</h3>
 * Container rules reference other rules, but do not reference
 * literal strings. Classes implementing container rules are
 * located in [xpath.tokenizer.container].
 *
 * [
 * XPath            = BeginXPath Expression EndXPath
 * 
 * Expression       = BeginExpression Operand ( Operator Operand )*
 *                    EndExpression
 * 
 * Operand          = Group | Literal | Number | FunctionCall
 *                  | VariableReference | UnaryOperand | Path
 * 
 * UnaryOperand     = NegationOperator NegationOperator* ( UnaryPath | Group
 *                  | Literal | Number | FunctionCall | VariableReference )
 * 
 * Path             = BeginPath
 *                    ( StepDelimiters
 *                    | ( StepDelimiters UnaryStep | Step )
 *                      ( StepDelimiters UnaryStep )*
 *                    ) EndPath
 * 
 * UnaryPath        = BeginPath
 *                    ( StepDelimiters
 *                    | StepDelimiters? UnaryStep ( StepDelimiters UnaryStep )*
 *                    ) EndPath
 * 
 * StepDelimiters   = StepDelimiter | DeepStepDelimiter
 * 
 * Step             = ( Axis NodeTest | FilterExpression ) Predicate*
 *                  | AbbreviatedStep
 * 
 * UnaryStep        = Axis NodeTest Predicate*
 *                  | AbbreviatedStep
 * 
 * FilterExpression = BeginExpression NegationOperator* FilterOperand
 *                    EndExpression
 * 
 * FilterOperand    = Group | Literal | Number | FunctionCall
 *                  | VariableReference
 * 
 * NodeTest         = NameTest | NodeCategory | PITypeTest
 * 
 * Predicate        = BeginPredicate Expression EndPredicate
 * 
 * Group            = BeginGroup Expression EndGroup
 * 
 * FunctionCall     = BeginFunctionCall FunctionArguments? EndFunctionCall
 * 
 * FunctionArguments= Expression ( ArgumentDelimiter Expression )*]
 *
 * <h3>Token rules</h3>
 * <i>Token rules</i> do not reference other EBNF rules, but do
 * reference literal strings. Except for a few special cases (see
 * below), each <i>token rule</i> corresponds directly to a token in
 * the output of the tokenizer; for example, a successful match of
 * the rule [BeginGroup] results in the production of a
 * [Token.BeginGroup].
 *
 * <ul><li>[S] indicates optional whitespace.</li>
 * <li>[^] indicates beginning of string.</li>
 * <li>[$] indicates end of string.</li></ul>
 *
 * [
 * BeginXPath          = ^ S
 * 
 * EndXPath            = $
 * 
 * BeginExpression     = ''
 * 
 * Operator            = ( "and" | "mod" | "div" | "or" | "!=" | "<=" | ">="
 *                       | "=" | "|" | "+" | "-" | "<" | ">" | "*"
 *                       ) S
 * 
 * EndExpression       = ''
 * 
 * BeginPath           = ''
 * 
 * EndPath             = ''
 * 
 * Literal             = ( '"' [^"]* '"' S
 *                       | "'" [^']* "'" ) S
 * 
 * Number              = ( [0-9]+ ( "." [0-9]* )?
 *                       | "." [0-9]+ ) S
 * 
 * VariableReference   = "$" NCName ( ":" NCName )? S
 * 
 * BeginPath           = ''
 * 
 * StepDelimiter       = '/'
 * 
 * DeepStepDelimiter   = '//'
 * 
 * EndPath             = ''
 * 
 * AbbreviatedStep     = ( '.' | '..' ) S
 * 
 * Axis                = ( ( "ancestor" | "ancestor-or-self" | "attribute"
 *                         | "child" | "descendant" | "descendant-or-self"
 *                         | "following" | "following-sibling" | "namespace"
 *                         | "parent" | "preceding" | "preceding-sibling"
 *                         | "self"
 *                         ) S "::"
 *                       | "@"? ) S
 * 
 * NameTest            = ( "*" | NCName ( ":" ( "*" | NCName ) )? ) S
 * 
 * NodeCategory            = ( "comment" | "text" | "node" ) S "(" S ")" S
 * 
 * PINameTest          = "processing-instruction" S "(" S
 *                       ( '"' [^"]* '"' | "'" [^']* "'" ) S ")" S
 * 
 * BeginPredicate      = '[' S
 * 
 * EndPredicate        = ']' S
 * 
 * BeginGroup          = '(' S
 * 
 * EndGroup            = ')' S
 * 
 * BeginFunctionCall   = NCName ( ':' NCName )? S '(' S
 * 
 * EndFunctionCall     = ')' S
 * 
 * ArgumentDelimiter   = ',' S]
 *
 * <h3>Special cases</h3>
 * A match of the rule [DeepStepDelimiter] results in the production of
 * a token sequence corresponding to [/descendant-or-self::node()/].
 *
 * A match of the rule [AbbreviatedStep] results in a token sequence
 * dependant on the string matched:<ul>
 * <li>A match of [.] results in the token sequence corresponding to
 *  [self::node()].</li>
 * <li>A match of [..] results in the token sequence corresponding to
 *  [parent::node()].</li></ul> */
interface Tokenizer {
    /** Tokenizes [input], which represents a partially tokenized
     * XPath query string. Returns the resulting [TokenizerOutput].
     *
     * Throws [TokenizerException] if the [input] cannot be
     * tokenized by this [Tokenizer]. */
    public function tokenize(input:TokenizerInput):TokenizerOutput;
}
