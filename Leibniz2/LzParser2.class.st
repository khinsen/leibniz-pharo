Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 70 1 37] 
#[ 0 74 1 49] 
#[ 0 74 1 53] 
#[ 0 74 1 57] 
#[ 0 66 1 113] 
#[ 0 58 1 125] 
#[ 0 134 1 37] 
#[ 0 174 0 178]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-06-20T11:47:03.407145+02:00'
]

{ #category : #generated }
LzParser2 class >> definitionComment [
"%unicode;
%glr;
%root ParseTree;
%prefix Lz;
%suffix Node;
%start TopLevelTerm TopLevelOp TopLevelSort TopLevelAxiom TopLevelRule TopLevelUseContext TopLevelSpecialTerms;
%hierarchy LiteralTerm (IntegerLiteralTerm RationalNumberLiteralTerm FpNumberLiteralTerm StringLiteralTerm);
%hierarchy VarTerm (VarTermWithSort);
%hierarchy Term (PrefixOpTerm BracketOpTerm SuperscriptOpTerm SubscriptOpTerm ParenthesizedTerm VarTerm ArrayTerm LiteralTerm);
%hierarchy Op (PrefixOp InfixOp BracketOp SuperscriptOp SubscriptOp);
%hierarchy TopLevelRule (TopLevelRewriteRule TopLevelFunctionRule);
<whitespace>
	: \s+
	;
<string>
	: \"" [^""]* \""
	;
<integer>
	: \-? \d+
	;
<rationalNumber>
	: \-?  \d+ \/ [1-9] \d*
	;
<fpNumber>
	: (<integer> \. \d* (e <integer>)?) | (<integer> e <integer>)
	;
<identifierCharacter>
	: <isLzIdentifierCharacter>
	;
<opIdentifier>
	: <identifierCharacter> (\d | \. | <identifierCharacter>)*
	;
<varIdentifier>
	: <opIdentifier> \_+
	;
Start 
	: TopLevelTerm
	;
Option
	: "","" 'comma' <opIdentifier> 'key' ""="" LiteralTerm 'value' {{Option}}
	;
TopLevelOp
	: (Var 'var' "","" 'comma')* Op 'op'  "":"" 'colon' Term 'sort' (Option 'option')* {{}}
	;
TopLevelSort
	: (Var 'var' "","" 'comma')* Op 'op' (Option 'option')* {{TopLevelSort}}
	| (Var 'var' "","" 'comma')* Term 'subsort' ""⊆"" 'subsetOf' Term 'supersort' (Option 'option')* {{TopLevelSubsort}}
	;
TopLevelAxiom
	: (Var 'var' "","" 'comma')* Term 'left' ""="" 'equals' Term 'right' (""|"" Term 'condition')? (Option 'option')*  {{TopLevelEqualityAxiom}}
	;
TopLevelRule
	: (Var 'var' "","" 'comma')* Term 'pattern' ""⇒"" 'arrow' Term 'replacement' (""|"" Term 'condition')? (Option 'option')* {{TopLevelRewriteRule}}
	| (Var 'var' "","" 'comma')* Term 'pattern' ""⇒"" 'arrow' ""Pharo:"" 'pharo' <string> 'code' (""|"" Term 'condition')? (Option 'option')* {{TopLevelFunctionRule}}
	;
TopLevelTerm
	: (Var 'var' "","" 'comma')* Term 'term' (Option 'option')* {{}}
	;
Op
	: <opIdentifier> 'opName'
		(""("" 'leftParen' Term 'arg'
			("","" 'comma' Term 'arg')* "")"" 'rightParen')? {{PrefixOp}}
	| NonInfixTerm 'arg' <opIdentifier> 'opName' NonInfixTerm 'arg' {{InfixOp}}
	| SimpleTerm 'arg'
		""["" 'opName'  Term 'arg'
			("","" 'comma' Term 'arg')*
		""]"" 'rightBracket' {{BracketOp}}
	| SimpleTerm 'arg'
		""^("" 'opName'  Term 'arg'
			("","" 'comma' Term 'arg')*
		"")"" 'rightParen' {{SuperscriptOp}}
	| SimpleTerm 'arg'
		""\("" 'opName'  Term 'arg'
			("","" 'comma' Term 'arg')*
		"")"" 'rightParen' {{SubscriptOp}}
	;
Var
	: <varIdentifier> 'varName' "":"" 'colon' Term 'sort' {{Var}}
	;
Term
	: NonInfixTerm 'arg' (<opIdentifier> 'opName' NonInfixTerm 'arg')+ {{InfixOpTerm}}
	| NonInfixTerm
	;
NonInfixTerm
	: SimpleTerm
	| SimpleTerm 'arg'
		""["" 'leftBracket'  Term 'arg'
			("","" 'comma' Term 'arg')*
		""]"" 'rightBracket' {{BracketOpTerm}}
	| SimpleTerm 'arg'
		""^("" 'leftParen'  Term 'arg'
			("","" 'comma' Term 'arg')*
		"")"" 'rightParen' {{SuperscriptOpTerm}}
	| SimpleTerm 'arg'
		""\("" 'leftParen'  Term 'arg'
			("","" 'comma' Term 'arg')*
		"")"" 'rightParen' {{SubscriptOpTerm}}
	;
SimpleTerm
	: LiteralTerm
	| ParenthesizedTerm
	| ArrayTerm
	| PrefixOpTerm
	| VarTerm
	;
ParenthesizedTerm
	: ""("" 'leftParen' Term 'term' "")"" 'rightParen' {{}}
	;
PrefixOpTerm
	: <opIdentifier> 'opName'
		(""("" 'leftParen' Term 'arg'
			("","" 'comma' Term 'arg')* "")"" 'rightParen')? {{}}
	;
VarTerm
	: <varIdentifier> 'varName' "":"" 'colon' Term 'sort' {{VarTermWithSort}}
	| <varIdentifier> 'varName' {{}}
	;
ArrayTerm
	: ""{"" 'leftBrace' ArrayElements 'arrayElements' ""}"" 'rightBrace' {{}}
	;
ArrayElements
	: ""["" 'leftBracket' (ArrayElement 'element')?
		("","" 'comma' ArrayElement 'element')* ""]"" 'rightBracket' {{}}
	;
ArrayElement
	: Term
	| ArrayElements
	;
LiteralTerm
	: IntegerLiteralTerm
	| RationalNumberLiteralTerm
	| FpNumberLiteralTerm
	| StringLiteralTerm
	;
StringLiteralTerm
	: <string> 'text' {{}}
	;
IntegerLiteralTerm
	: <integer> 'text' {{}}
	;
RationalNumberLiteralTerm
	: <rationalNumber> 'text' {{}}
	;
FpNumberLiteralTerm
	: <fpNumber> 'text' {{}}
	;
TopLevelUseContext 
	: (""name"" ""="" | ""name="") <string> 'pageName' (Option 'option')*  {{}}
	;
YesNoFlag
	: ""yes""
	| ""no""
	;
TopLevelSpecialTerms
	: SpecialTerm 'specialTerm' ("","" 'comma' SpecialTerm 'specialTerm')* (Option 'option')* {{}}
	;
SpecialTerm
	: ""integers""
	| ""rationalNumbers""
	| ""floatingPointNumbers""
	| ""strings""
	| ""arrays""
	;"
]

{ #category : #initializing }
LzParser2 class >> initialize [
	LeParser annotationParsers
		at: 'lzSort'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelSort ].
	LeParser annotationParsers
		at: 'lzOp'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelOp ].
	LeParser annotationParsers
		at: 'lzAxiom'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelAxiom ].
	LeParser annotationParsers
		at: 'lzRule'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelRule ].
	LeParser annotationParsers
		at: 'lzTerm'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelTerm ].
	LeParser annotationParsers
		at: 'lzUseContext'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelUseContext ].
	LeParser annotationParsers
		at: 'lzSpecialTerms'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelSpecialTerms ].
]

{ #category : #accessing }
LzParser2 class >> obsolete [
	{ 'lzSort'. 'lzOp'. 'lzAxiom'.  'lzRule'. 'lzTerm'.
		'lzUseContext'. 'lzSpecialTerms' }
		do: [ :each |
			LeParser annotationParsers removeKey: each  ifAbsent: [  ] ].
	^ super obsolete
]

{ #category : #generated }
LzParser2 class >> reduceTable [
^#(
	#(37 0 #reduceActionFor_Var__var_______comma___1: 1100801 false) 
	#(33 1 #liftFirstValue: 976897 false) 
	#(71 1 #liftFirstValue: 4328453 false) 
	#(71 1 #liftFirstValue: 4328451 false) 
	#(71 1 #liftFirstValue: 4328449 false) 
	#(71 1 #liftFirstValue: 4328450 false) 
	#(71 1 #liftFirstValue: 4328452 false) 
	#(70 0 #reduceActionFor_Var__var_______comma___1: 4258817 false) 
	#(62 1 #reduceActionForStringLiteralTerm1: 3873793 false) 
	#(63 1 #reduceActionForIntegerLiteralTerm1: 3919873 false) 
	#(64 1 #reduceActionForRationalNumberLiteralTerm1: 3968001 false) 
	#(65 1 #reduceActionForFpNumberLiteralTerm1: 4030465 false) 
	#(54 1 #reduceActionForPrefixOpTerm1: 3252225 false) 
	#(55 1 #reduceActionForVarTerm2: 3381250 false) 
	#(37 2 #reduceActionFor_Var__var_______comma___2: 1100802 false) 
	#(39 0 #reduceActionFor_Option__option___1: 1160193 false) 
	#(48 1 #liftFirstValue: 2574338 false) 
	#(51 1 #liftFirstValue: 2684929 false) 
	#(52 1 #liftFirstValue: 3084290 false) 
	#(52 1 #liftFirstValue: 3084292 false) 
	#(52 1 #liftFirstValue: 3084293 false) 
	#(52 1 #liftFirstValue: 3084291 false) 
	#(52 1 #liftFirstValue: 3084289 false) 
	#(61 1 #liftFirstValue: 3761156 false) 
	#(61 1 #liftFirstValue: 3761153 false) 
	#(61 1 #liftFirstValue: 3761154 false) 
	#(61 1 #liftFirstValue: 3761155 false) 
	#(44 1 #reduceActionForOp1: 1953793 false) 
	#(59 0 #reduceActionFor_Var__var_______comma___1: 3652609 false) 
	#(36 2 #reduceActionFor_Var__var_______comma__1: 1100801 false) 
	#(43 3 #reduceActionForTopLevelTerm1: 1871873 false) 
	#(50 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 2601985 false) 
	#(48 2 #reduceActionForTerm1: 2574337 false) 
	#(40 3 #reduceActionForTopLevelSort1: 1187841 false) 
	#(66 3 #reduceActionForTopLevelUseContext2: 4080642 false) 
	#(68 3 #reduceActionForTopLevelSpecialTerms1: 4207617 false) 
	#(70 2 #reduceActionFor_Var__var_______comma___2: 4258818 false) 
	#(53 3 #reduceActionForParenthesizedTerm1: 3176449 false) 
	#(60 1 #liftFirstValue: 3719169 false) 
	#(60 1 #liftFirstValue: 3719170 false) 
	#(56 3 #reduceActionForArrayTerm1: 3502081 false) 
	#(46 0 #reduceActionFor_Var__var_______comma___1: 2018305 false) 
	#(55 3 #reduceActionForVarTerm1: 3381249 false) 
	#(47 3 #reduceActionForVar1: 2504705 false) 
	#(38 1 #liftFirstValue: 1160193 false) 
	#(39 2 #reduceActionFor_Option__option___2: 1160194 false) 
	#(49 2 #reduceActionFor_Var__var_______comma__1: 2601985 false) 
	#(50 2 #reduceActionFor_Var__var_______comma___2: 2601986 false) 
	#(44 3 #reduceActionForOp3: 1953795 false) 
	#(66 4 #reduceActionForTopLevelUseContext1: 4080641 false) 
	#(69 2 #reduceActionFor_Var__var_______comma__1: 4258817 false) 
	#(57 3 #reduceActionForArrayElements1: 3588097 false) 
	#(59 2 #reduceActionFor_Var__var_______comma___2: 3652610 false) 
	#(35 5 #reduceActionForTopLevelOp1: 1086465 false) 
	#(40 5 #reduceActionForTopLevelSort2: 1187842 false) 
	#(41 5 #reduceActionForTopLevelAxiom1: 1394689 false) 
	#(42 5 #reduceActionForTopLevelRule1: 1551361 false) 
	#(58 2 #reduceActionFor_Var__var_______comma__1: 3652609 false) 
	#(57 4 #reduceActionForArrayElements2: 3588098 false) 
	#(54 5 #reduceActionForPrefixOpTerm2: 3252226 false) 
	#(46 2 #reduceActionFor_Var__var_______comma___2: 2018306 false) 
	#(51 5 #reduceActionForNonInfixTerm2: 2684930 false) 
	#(51 5 #reduceActionForNonInfixTerm4: 2684932 false) 
	#(51 5 #reduceActionForNonInfixTerm3: 2684931 false) 
	#(44 5 #reduceActionForOp2: 1953794 false) 
	#(44 5 #reduceActionForOp4: 1953796 false) 
	#(44 5 #reduceActionForOp6: 1953798 false) 
	#(44 5 #reduceActionForOp5: 1953797 false) 
	#(42 6 #reduceActionForTopLevelRule3: 1551363 false) 
	#(45 2 #reduceActionFor_Var__var_______comma__1: 2018305 false) 
	#(34 4 #reduceActionForOption1: 1003521 false) 
	#(41 7 #reduceActionForTopLevelAxiom2: 1394690 false) 
	#(42 7 #reduceActionForTopLevelRule2: 1551362 false) 
	#(42 8 #reduceActionForTopLevelRule4: 1551364 false)
	).
]

{ #category : #generated }
LzParser2 class >> scannerClass [
	^LzScanner
]

{ #category : #generated }
LzParser2 class >> startingStateForStart [
	^ 1
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelAxiom [
	^ 5
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelOp [
	^ 3
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelRule [
	^ 6
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelSort [
	^ 4
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelSpecialTerms [
	^ 8
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelTerm [
	^ 2
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelUseContext [
	^ 7
]

{ #category : #generated }
LzParser2 class >> symbolNames [
	^ #('"("' '")"' '","' '":"' '"="' '"Pharo:"' '"["' '"\("' '"]"' '"^("' '"arrays"' '"floatingPointNumbers"' '"integers"' '"name"' '"name="' '"no"' '"rationalNumbers"' '"strings"' '"yes"' '"{"' '"|"' '"}"' '"⇒"' '"⊆"' '<whitespace>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' '<opIdentifier>' '<varIdentifier>' 'B e g i n' 'Start' 'Option' 'TopLevelOp' '(Var ''var'' "," ''comma'')' '(Var ''var'' "," ''comma'')*' '(Option ''option'')' '(Option ''option'')*' 'TopLevelSort' 'TopLevelAxiom' 'TopLevelRule' 'TopLevelTerm' 'Op' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'Var' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' 'SimpleTerm' 'ParenthesizedTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' 'YesNoFlag' 'TopLevelSpecialTerms' '("," ''comma'' SpecialTerm ''specialTerm'')' '("," ''comma'' SpecialTerm ''specialTerm'')*' 'SpecialTerm' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelTermNode #LzTopLevelTermNode #LzOptionNode #LzTopLevelOpNode #OrderedCollection #OrderedCollection #LzOptionNode #OrderedCollection #LzParseTreeNode #LzTopLevelEqualityAxiomNode #LzTopLevelRuleNode #LzTopLevelTermNode #LzOpNode #OrderedCollection #OrderedCollection #LzVarNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzTermNode #LzTermNode #LzParenthesizedTermNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #SmaCCToken #LzTopLevelSpecialTermsNode #OrderedCollection #OrderedCollection #SmaCCToken #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 37 0 33 0 41 0 37 0 37 0 43] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 41 0 37 0 49 0 43] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 53 0 35 0 57 0 37] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 61 0 37 0 65 0 40] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 69 0 37 0 73 0 41] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 77 0 37 0 81 0 42] 
#[1 0 85 0 14 0 89 0 15 0 93 0 66] 
#[1 0 121 0 11 0 121 0 12 0 121 0 13 0 121 0 17 0 121 0 18 0 117 0 68 0 121 0 71] 
#[0 0 0 0 72] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 36 0 161 0 47 0 165 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[0 0 10 0 72] 
#[0 0 0 0 72] 
#[0 0 0 0 72] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 213 0 30 0 153 0 31 0 157 0 36 0 217 0 44 0 161 0 47 0 221 0 51 0 225 0 52 0 225 0 53 0 225 0 54 0 225 0 55 0 225 0 56 0 225 0 61 0 225 0 62 0 225 0 63 0 225 0 64 0 225 0 65] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 213 0 30 0 153 0 31 0 157 0 36 0 229 0 44 0 161 0 47 0 233 0 48 0 237 0 51 0 225 0 52 0 225 0 53 0 225 0 54 0 225 0 55 0 225 0 56 0 225 0 61 0 225 0 62 0 225 0 63 0 225 0 64 0 225 0 65] 
#[0 0 0 0 72] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 36 0 161 0 47 0 241 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[0 0 0 0 72] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 36 0 161 0 47 0 245 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[0 0 0 0 72] 
#[0 0 249 0 5] 
#[0 0 253 0 26] 
#[0 0 0 0 72] 
#[0 0 14 0 3 0 72] 
#[0 0 18 0 3 0 72] 
#[0 0 22 0 3 0 72] 
#[0 0 26 0 3 0 72] 
#[0 0 30 0 3 0 72] 
#[0 0 0 0 72] 
#[1 0 34 0 3 1 1 0 70 0 34 0 72] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 9 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 1 13 0 7 1 17 0 57] 
#[0 0 38 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 42 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 46 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 50 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[1 1 21 0 1 0 54 0 2 0 54 0 3 0 54 0 4 0 54 0 5 0 54 0 7 0 54 0 8 0 54 0 9 0 54 0 10 0 54 0 21 0 54 0 23 0 54 0 24 0 54 0 30 0 54 0 72] 
#[1 0 58 0 3 1 25 0 4 0 58 0 5 0 58 0 7 0 58 0 8 0 58 0 10 0 58 0 23 0 58 0 24 0 58 0 30 0 58 0 72] 
#[0 0 62 0 1 0 20 0 26 0 27 0 28 0 29 0 30 0 31] 
#[0 1 29 0 3] 
#[1 0 66 0 3 1 33 0 39 0 66 0 72] 
#[1 0 70 0 2 0 70 0 3 0 70 0 4 0 70 0 5 0 70 0 7 0 70 0 8 0 70 0 9 0 70 0 10 0 70 0 21 0 70 0 23 0 70 0 24 0 7 0 30 1 41 0 49 1 45 0 50 0 70 0 72] 
#[1 0 74 0 2 0 74 0 3 0 74 0 4 0 74 0 5 0 11 0 7 0 15 0 8 0 74 0 9 0 19 0 10 0 74 0 21 0 74 0 23 0 74 0 24 0 74 0 30 0 74 0 72] 
#[0 0 78 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 82 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 86 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 90 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 94 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 98 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 102 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 106 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 110 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[1 1 61 0 1 0 114 0 3 0 114 0 4 0 54 0 7 0 54 0 8 0 54 0 10 0 54 0 24 0 54 0 30 0 114 0 72] 
#[0 1 65 0 4] 
#[0 1 69 0 30] 
#[1 1 73 0 7 1 77 0 8 1 81 0 10 0 74 0 24 0 74 0 30] 
#[1 0 66 0 3 1 85 0 39 0 66 0 72] 
#[0 1 89 0 24] 
#[1 0 70 0 24 1 93 0 30 1 41 0 49 1 45 0 50] 
#[0 1 97 0 5] 
#[0 1 101 0 23] 
#[0 1 105 0 26] 
#[1 0 66 0 3 1 109 0 39 0 66 0 72] 
#[1 0 23 0 3 1 117 0 39 1 121 0 69 0 66 0 72] 
#[1 0 58 0 2 0 58 0 3 0 27 0 4 0 58 0 5 0 58 0 7 0 58 0 8 0 58 0 9 0 58 0 10 0 58 0 21 0 58 0 23 0 58 0 24 0 58 0 30 0 58 0 72] 
#[0 1 129 0 2] 
#[1 0 125 0 1 0 118 0 3 1 13 0 7 0 118 0 9 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 145 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 1 145 0 57 1 141 0 59 1 145 0 60 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[0 1 149 0 22] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 153 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 157 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[0 0 122 0 1 0 20 0 26 0 27 0 28 0 29 0 30 0 31] 
#[1 1 161 0 3 1 169 0 34 1 169 0 38 0 126 0 72] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 173 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[0 0 130 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[1 0 134 0 2 0 134 0 3 0 134 0 4 0 134 0 5 0 134 0 7 0 134 0 8 0 134 0 9 0 134 0 10 0 134 0 21 0 134 0 23 0 134 0 24 0 31 0 30 1 177 0 49 0 134 0 72] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 181 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 185 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 189 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 193 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 197 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 201 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 205 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 209 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 213 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 1 161 0 3 1 169 0 34 1 169 0 38 0 138 0 72] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 217 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 221 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 225 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 0 125 0 1 1 229 0 6 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 233 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 0 66 0 3 1 237 0 39 0 66 0 72] 
#[1 1 161 0 3 1 169 0 34 1 169 0 38 0 142 0 72] 
#[0 1 241 0 11 0 12 0 13 0 17 0 18 0 71] 
#[1 1 161 0 3 1 169 0 34 1 169 0 38 0 146 0 72] 
#[0 0 150 0 3 0 72] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 1 245 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[0 0 154 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 158 0 3 0 9] 
#[0 0 162 0 3 0 9] 
#[1 1 249 0 3 1 253 0 9 2 1 0 58] 
#[1 0 118 0 3 0 118 0 9 2 5 0 59] 
#[0 0 166 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[1 0 170 0 2 0 170 0 3 2 9 0 46] 
#[1 0 35 0 3 0 174 0 5 0 174 0 7 0 174 0 8 0 174 0 10 0 174 0 23 0 174 0 24 0 174 0 30 0 174 0 72] 
#[0 2 13 0 30] 
#[0 0 182 0 3 0 72] 
#[0 0 186 0 3 0 72] 
#[0 0 190 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 194 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[1 0 170 0 3 0 170 0 9 2 17 0 46] 
#[1 0 170 0 2 0 170 0 3 2 21 0 46] 
#[1 0 170 0 2 0 170 0 3 2 25 0 46] 
#[1 0 170 0 2 0 170 0 3 2 29 0 46] 
#[1 0 66 0 3 2 33 0 39 0 66 0 72] 
#[0 0 198 0 4] 
#[1 0 170 0 3 0 170 0 9 2 37 0 46] 
#[1 0 170 0 2 0 170 0 3 2 41 0 46] 
#[1 0 170 0 2 0 170 0 3 2 45 0 46] 
#[1 0 66 0 3 2 49 0 39 0 66 0 72] 
#[1 0 198 0 3 0 190 0 24 0 190 0 30 0 198 0 72] 
#[1 0 66 0 3 2 53 0 21 2 57 0 39 0 66 0 72] 
#[0 2 61 0 26] 
#[1 0 66 0 3 2 65 0 21 2 69 0 39 0 66 0 72] 
#[1 1 161 0 3 1 169 0 34 1 169 0 38 0 202 0 72] 
#[0 0 206 0 3 0 72] 
#[0 0 174 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[1 0 125 0 1 1 13 0 7 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 2 73 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 2 73 0 57 2 73 0 60 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[0 0 210 0 3 0 9 0 22] 
#[0 0 214 0 3 0 9] 
#[1 1 249 0 3 2 77 0 9 2 1 0 58] 
#[1 2 81 0 2 2 85 0 3 2 89 0 45] 
#[0 2 93 0 5] 
#[1 2 85 0 3 2 97 0 9 2 89 0 45] 
#[1 2 101 0 2 2 85 0 3 2 89 0 45] 
#[1 2 105 0 2 2 85 0 3 2 89 0 45] 
#[1 2 109 0 2 2 85 0 3 2 89 0 45] 
#[1 1 161 0 3 1 169 0 34 1 169 0 38 0 218 0 72] 
#[1 2 85 0 3 2 113 0 9 2 89 0 45] 
#[1 2 117 0 2 2 85 0 3 2 89 0 45] 
#[1 2 121 0 2 2 85 0 3 2 89 0 45] 
#[1 1 161 0 3 1 169 0 34 1 169 0 38 0 222 0 72] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 2 125 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 1 161 0 3 1 169 0 34 1 169 0 38 0 226 0 72] 
#[1 0 66 0 3 2 129 0 21 2 133 0 39 0 66 0 72] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 2 137 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 1 161 0 3 1 169 0 34 1 169 0 38 0 230 0 72] 
#[0 0 234 0 3 0 9] 
#[0 0 238 0 3 0 9 0 22] 
#[0 0 242 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 2 141 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[0 0 246 0 2 0 3 0 9] 
#[1 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 2 145 0 61 2 145 0 62 2 145 0 63 2 145 0 64 2 145 0 65] 
#[0 0 250 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 0 254 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[0 1 2 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 72] 
#[1 1 6 0 3 1 6 0 4 0 242 0 7 0 242 0 8 0 242 0 10 0 242 0 24 0 242 0 30 1 6 0 72] 
#[1 1 10 0 3 1 10 0 4 0 250 0 24 0 250 0 30 1 10 0 72] 
#[1 1 14 0 3 1 14 0 4 0 254 0 24 0 254 0 30 1 14 0 72] 
#[1 1 18 0 3 1 18 0 4 1 2 0 24 1 2 0 30 1 18 0 72] 
#[1 0 66 0 3 2 149 0 39 0 66 0 72] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 5 0 31 2 153 0 48 0 169 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 56 0 173 0 61 0 173 0 62 0 173 0 63 0 173 0 64 0 173 0 65] 
#[1 1 161 0 3 1 169 0 34 1 169 0 38 1 22 0 72] 
#[1 0 66 0 3 2 157 0 39 0 66 0 72] 
#[0 1 26 0 2 0 3 0 9] 
#[0 1 30 0 3 0 72] 
#[1 1 161 0 3 1 169 0 34 1 169 0 38 1 34 0 72] 
#[1 0 66 0 3 2 161 0 39 0 66 0 72] 
#[1 1 161 0 3 1 169 0 34 1 169 0 38 1 38 0 72] 
#[1 1 161 0 3 1 169 0 34 1 169 0 38 1 42 0 72]
	).
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForArrayElements1: nodes [
	| result |
	result := LzArrayElementsNode new.
	result leftBracket: (nodes at: 1).
	result addTokens: ((nodes at: 2) at: 1) to: result commas.
	result addNodes: ((nodes at: 2) at: 2) to: result elements.
	result rightBracket: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForArrayElements2: nodes [
	| result |
	result := LzArrayElementsNode new.
	result leftBracket: (nodes at: 1).
	result addNode: (nodes at: 2) to: result elements.
	result addTokens: ((nodes at: 3) at: 1) to: result commas.
	result addNodes: ((nodes at: 3) at: 2) to: result elements.
	result rightBracket: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForArrayTerm1: nodes [
	| result |
	result := LzArrayTermNode new.
	result leftBrace: (nodes at: 1).
	result arrayElements: (nodes at: 2).
	result rightBrace: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForFpNumberLiteralTerm1: nodes [
	| result |
	result := LzFpNumberLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForIntegerLiteralTerm1: nodes [
	| result |
	result := LzIntegerLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForNonInfixTerm2: nodes [
	| result |
	result := LzBracketOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result leftBracket: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightBracket: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForNonInfixTerm3: nodes [
	| result |
	result := LzSuperscriptOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForNonInfixTerm4: nodes [
	| result |
	result := LzSubscriptOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp1: nodes [
	| result |
	result := LzPrefixOpNode new.
	result opName: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp2: nodes [
	| result |
	result := LzPrefixOpNode new.
	result opName: (nodes at: 1).
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp3: nodes [
	| result |
	result := LzInfixOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp4: nodes [
	| result |
	result := LzBracketOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightBracket: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp5: nodes [
	| result |
	result := LzSuperscriptOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp6: nodes [
	| result |
	result := LzSubscriptOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOption1: nodes [
	| result |
	result := LzOptionNode new.
	result comma: (nodes at: 1).
	result key: (nodes at: 2).
	result value: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForParenthesizedTerm1: nodes [
	| result |
	result := LzParenthesizedTermNode new.
	result leftParen: (nodes at: 1).
	result term: (nodes at: 2).
	result rightParen: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForPrefixOpTerm1: nodes [
	| result |
	result := LzPrefixOpTermNode new.
	result opName: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForPrefixOpTerm2: nodes [
	| result |
	result := LzPrefixOpTermNode new.
	result opName: (nodes at: 1).
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForRationalNumberLiteralTerm1: nodes [
	| result |
	result := LzRationalNumberLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForStringLiteralTerm1: nodes [
	| result |
	result := LzStringLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTerm1: nodes [
	| result |
	result := LzInfixOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result addTokens: ((nodes at: 2) at: 1) to: result opNames.
	result addNodes: ((nodes at: 2) at: 2) to: result args.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom1: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result left: (nodes at: 2).
	result equals: (nodes at: 3).
	result right: (nodes at: 4).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom2: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result left: (nodes at: 2).
	result equals: (nodes at: 3).
	result right: (nodes at: 4).
	result condition: (nodes at: 6).
	result addNodes: (nodes at: 7) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelOp1: nodes [
	| result |
	result := LzTopLevelOpNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result op: (nodes at: 2).
	result colon: (nodes at: 3).
	result sort: (nodes at: 4).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule1: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result replacement: (nodes at: 4).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule2: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result replacement: (nodes at: 4).
	result condition: (nodes at: 6).
	result addNodes: (nodes at: 7) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule3: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result pharo: (nodes at: 4).
	result code: (nodes at: 5).
	result addNodes: (nodes at: 6) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule4: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result pharo: (nodes at: 4).
	result code: (nodes at: 5).
	result condition: (nodes at: 7).
	result addNodes: (nodes at: 8) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSort1: nodes [
	| result |
	result := LzTopLevelSortNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result op: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSort2: nodes [
	| result |
	result := LzTopLevelSubsortNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result subsort: (nodes at: 2).
	result subsetOf: (nodes at: 3).
	result supersort: (nodes at: 4).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSpecialTerms1: nodes [
	| result |
	result := LzTopLevelSpecialTermsNode new.
	result addToken: (nodes at: 1) to: result specialTerms.
	result addTokens: ((nodes at: 2) at: 1) to: result commas.
	result addTokens: ((nodes at: 2) at: 2) to: result specialTerms.
	result addNodes: (nodes at: 3) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelTerm1: nodes [
	| result |
	result := LzTopLevelTermNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result term: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext1: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 3).
	result addNodes: (nodes at: 4) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext2: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForVar1: nodes [
	| result |
	result := LzVarNode new.
	result varName: (nodes at: 1).
	result colon: (nodes at: 2).
	result sort: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForVarTerm1: nodes [
	| result |
	result := LzVarTermWithSortNode new.
	result varName: (nodes at: 1).
	result colon: (nodes at: 2).
	result sort: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForVarTerm2: nodes [
	| result |
	result := LzVarTermNode new.
	result varName: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Option__option___1: nodes [
	| result |
	result := OrderedCollection new: 2.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Option__option___2: nodes [
	| result |
	result := nodes at: 1.
	self add: (nodes at: 2) to: result.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Var__var_______comma__1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Var__var_______comma___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Var__var_______comma___2: nodes [
	| result |
	result := nodes at: 1.
	self add: ((nodes at: 2) at: 1) to: (result at: 1).
	self add: ((nodes at: 2) at: 2) to: (result at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	self add: ((nodes at: 1) at: 1) to: (result at: 1).
	self add: ((nodes at: 1) at: 2) to: (result at: 2).
	^ result
]
