Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 14 0 189] 
#[ 0 42 0 197] 
#[ 0 42 0 201] 
#[ 0 42 0 205] 
#[ 0 82 0 213] 
#[ 0 90 0 213]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-05-24T16:57:47.119591+02:00'
]

{ #category : #generated }
LzParser2 class >> definitionComment [
"%unicode;
%glr;
%root ParseTree;
%prefix Lz;
%suffix Node;
%start TopLevelTerm TopLevelOp TopLevelSort TopLevelAxiom TopLevelRule TopLevelUseContext;
%hierarchy LiteralTerm (IntegerLiteralTerm RationalNumberLiteralTerm FpNumberLiteralTerm StringLiteralTerm);
%hierarchy VarTerm (VarTermWithSort);
%hierarchy Term (PrefixOpTerm BracketOpTerm SuperscriptOpTerm SubscriptOpTerm VarTerm ArrayTerm LiteralTerm);
%hierarchy Op (PrefixOp InfixOp);
%hierarchy TopLevelAxiom (TopLevelEqualityAxiom TopLevelSubsortAxiom);
%hierarchy TopLevelRule (TopLevelRewriteRule TopLevelFunctionRule);
<whitespace>
	: \s+
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
Start 
	: TopLevelSort
	;
TopLevelOp
	: Op 'op'  "":"" 'colon' Term 'sort' {{}}
	;
TopLevelSort
	: Op 'op' {{}}
	;
Op
	: <opIdentifier> 'opName'
		(""("" 'leftParen' Term 'arg'
			("","" 'comma' Term 'arg')* "")"" 'rightParen')? {{PrefixOp}}
	| NonInfixTerm 'arg' <opIdentifier> 'opName' NonInfixTerm 'arg' {{InfixOp}}
	;
TopLevelAxiom
	: Term 'left' ""="" 'equals' Term 'right' (""|"" Term 'condition')? {{TopLevelEqualityAxiom}}
	| Term 'subsort' ""⊆"" 'subsetOf' Term 'supersort' {{TopLevelSubsortAxiom}}
	;
TopLevelRule
	: Term 'pattern' ""⇒"" 'arrow' Term 'replacement' (""|"" Term 'condition')? {{TopLevelRewriteRule}}
	| Term 'pattern' ""→"" 'arrow' <string> 'code' ("":"" <opIdentifier> 'class')? (""|"" Term 'condition')? {{TopLevelFunctionRule}}
	;
TopLevelTerm
	: Term 'term' {{}}
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
	| ""("" Term "")""
	| ArrayTerm
	| PrefixOpTerm
	| VarTerm
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
	: ""["" 'leftBracket' ArrayElement 'element'
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
	: (""name"" ""="" | ""name="") <string> 'pageName'
		(""|"" ""forSorts"" ""="" YesNoFlag 'sortFlag')? {{}}
	;
YesNoFlag
	: ""yes""
	| ""no""
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
]

{ #category : #accessing }
LzParser2 class >> obsolete [
	{ 'lzSort'. 'lzOp'. 'lzAxiom'.  'lzRule'. 'lzTerm'. 'lzUseContext' } do: [ :each |
		LeParser annotationParsers removeKey: each  ifAbsent: [  ] ].
	^ super obsolete
]

{ #category : #generated }
LzParser2 class >> reduceTable [
^#(
	#(32 1 #reduceActionForOp1: 1088513 false) 
	#(43 1 #reduceActionForPrefixOpTerm1: 2359297 false) 
	#(44 1 #reduceActionForVarTerm2: 2488322 false) 
	#(51 1 #reduceActionForStringLiteralTerm1: 2977793 false) 
	#(52 1 #reduceActionForIntegerLiteralTerm1: 3023873 false) 
	#(53 1 #reduceActionForRationalNumberLiteralTerm1: 3072001 false) 
	#(54 1 #reduceActionForFpNumberLiteralTerm1: 3134465 false) 
	#(29 1 #liftFirstValue: 972801 false) 
	#(31 1 #reduceActionForTopLevelSort1: 1055745 false) 
	#(41 1 #liftFirstValue: 1872897 false) 
	#(42 1 #liftFirstValue: 2272260 false) 
	#(42 1 #liftFirstValue: 2272261 false) 
	#(42 1 #liftFirstValue: 2272259 false) 
	#(42 1 #liftFirstValue: 2272257 false) 
	#(50 1 #liftFirstValue: 2865156 false) 
	#(50 1 #liftFirstValue: 2865153 false) 
	#(50 1 #liftFirstValue: 2865154 false) 
	#(50 1 #liftFirstValue: 2865155 false) 
	#(37 1 #reduceActionForTopLevelTerm1: 1725441 false) 
	#(38 1 #liftFirstValue: 1762306 false) 
	#(40 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 1789953 false) 
	#(38 2 #reduceActionForTerm1: 1762305 false) 
	#(55 2 #reduceActionForTopLevelUseContext3: 3184643 false) 
	#(42 3 #liftSecondValue: 2272258 false) 
	#(49 1 #liftFirstValue: 2823169 false) 
	#(49 1 #liftFirstValue: 2823170 false) 
	#(48 0 #reduceActionFor______comma__ArrayElement__element___1: 2756609 false) 
	#(45 3 #reduceActionForArrayTerm1: 2609153 false) 
	#(34 0 #reduceActionFor______comma__ArrayElement__element___1: 1153025 false) 
	#(44 3 #reduceActionForVarTerm1: 2488321 false) 
	#(32 3 #reduceActionForOp3: 1088515 false) 
	#(39 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 1789953 false) 
	#(40 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 1789954 false) 
	#(30 3 #reduceActionForTopLevelOp1: 999425 false) 
	#(35 3 #reduceActionForTopLevelAxiom1: 1294337 false) 
	#(35 3 #reduceActionForTopLevelAxiom3: 1294339 false) 
	#(36 3 #reduceActionForTopLevelRule3: 1481731 false) 
	#(36 3 #reduceActionForTopLevelRule1: 1481729 false) 
	#(55 3 #reduceActionForTopLevelUseContext1: 3184641 false) 
	#(46 4 #reduceActionForArrayElements1: 2695169 false) 
	#(48 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 2756610 false) 
	#(32 5 #reduceActionForOp2: 1088514 false) 
	#(43 5 #reduceActionForPrefixOpTerm2: 2359298 false) 
	#(34 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 1153026 false) 
	#(41 5 #reduceActionForNonInfixTerm2: 1872898 false) 
	#(41 5 #reduceActionForNonInfixTerm4: 1872900 false) 
	#(41 5 #reduceActionForNonInfixTerm3: 1872899 false) 
	#(35 5 #reduceActionForTopLevelAxiom2: 1294338 false) 
	#(36 5 #reduceActionForTopLevelRule5: 1481733 false) 
	#(36 5 #reduceActionForTopLevelRule4: 1481732 false) 
	#(36 5 #reduceActionForTopLevelRule2: 1481730 false) 
	#(47 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 2756609 false) 
	#(33 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 1153025 false) 
	#(56 1 #liftFirstValue: 3306498 false) 
	#(56 1 #liftFirstValue: 3306497 false) 
	#(55 6 #reduceActionForTopLevelUseContext4: 3184644 false) 
	#(36 7 #reduceActionForTopLevelRule6: 1481734 false) 
	#(55 7 #reduceActionForTopLevelUseContext2: 3184642 false)
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
LzParser2 class >> startingStateForTopLevelTerm [
	^ 2
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelUseContext [
	^ 7
]

{ #category : #generated }
LzParser2 class >> symbolNames [
	^ #('"("' '")"' '","' '":"' '"="' '"["' '"\("' '"]"' '"^("' '"forSorts"' '"name"' '"name="' '"no"' '"yes"' '"{"' '"|"' '"}"' '"→"' '"⇒"' '"⊆"' '<whitespace>' '<opIdentifier>' '<varIdentifier>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' 'B e g i n' 'Start' 'TopLevelOp' 'TopLevelSort' 'Op' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'TopLevelAxiom' 'TopLevelRule' 'TopLevelTerm' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' 'SimpleTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' 'YesNoFlag' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelSortNode #LzTopLevelSortNode #LzTopLevelOpNode #LzTopLevelSortNode #LzOpNode #OrderedCollection #OrderedCollection #LzTopLevelAxiomNode #LzTopLevelRuleNode #LzTopLevelTermNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzParseTreeNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #SmaCCToken #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 65 0 29 0 65 0 31 0 73 0 32 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 121 0 37 0 125 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 133 0 30 0 137 0 32 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 141 0 31 0 73 0 32 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 145 0 35 0 149 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 153 0 36 0 157 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 161 0 11 0 165 0 12 0 169 0 55] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 173 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 177 0 6 0 181 0 46] 
#[1 0 185 0 1 0 6 0 4 0 10 0 6 0 10 0 7 0 10 0 9 0 10 0 22 0 6 0 57] 
#[1 0 14 0 2 0 14 0 3 0 7 0 4 0 14 0 5 0 14 0 6 0 14 0 7 0 14 0 8 0 14 0 9 0 14 0 16 0 14 0 18 0 14 0 19 0 14 0 20 0 14 0 22 0 14 0 57] 
#[0 0 18 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 22 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 26 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 30 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 0 0 57] 
#[0 0 34 0 57] 
#[0 0 38 0 57] 
#[0 0 193 0 22] 
#[1 0 42 0 2 0 42 0 3 0 42 0 4 0 42 0 5 0 11 0 6 0 15 0 7 0 42 0 8 0 19 0 9 0 42 0 16 0 42 0 18 0 42 0 19 0 42 0 20 0 42 0 22 0 42 0 57] 
#[0 0 46 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 50 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 54 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 58 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 62 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 66 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 70 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 74 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[1 0 209 0 1 0 10 0 2 0 10 0 3 0 10 0 4 0 10 0 5 0 10 0 6 0 10 0 7 0 10 0 8 0 10 0 9 0 10 0 16 0 10 0 18 0 10 0 19 0 10 0 20 0 10 0 22 0 10 0 57] 
#[0 0 0 0 57] 
#[0 0 78 0 57] 
#[1 0 82 0 2 0 82 0 3 0 82 0 4 0 82 0 5 0 82 0 6 0 82 0 7 0 82 0 8 0 82 0 9 0 82 0 16 0 82 0 18 0 82 0 19 0 82 0 20 0 23 0 22 0 217 0 39 0 221 0 40 0 82 0 57] 
#[0 0 0 0 57] 
#[0 0 225 0 4] 
#[0 0 0 0 57] 
#[0 0 0 0 57] 
#[1 0 229 0 5 0 233 0 20] 
#[0 0 0 0 57] 
#[1 0 237 0 18 0 241 0 19] 
#[0 0 245 0 5] 
#[0 0 249 0 24] 
#[0 0 0 0 57] 
#[0 0 253 0 2] 
#[1 0 33 0 1 0 177 0 6 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 9 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 1 9 0 46 1 9 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[0 1 13 0 17] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 17 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 21 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 25 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 29 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 33 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 37 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 41 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 45 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[0 0 86 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[1 0 90 0 2 0 90 0 3 0 90 0 4 0 90 0 5 0 90 0 6 0 90 0 7 0 90 0 8 0 90 0 9 0 90 0 16 0 90 0 18 0 90 0 19 0 90 0 20 0 27 0 22 1 49 0 39 0 90 0 57] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 53 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 57 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 61 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[0 1 65 0 24] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 69 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[0 1 73 0 24] 
#[1 1 77 0 16 0 94 0 57] 
#[0 0 98 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 102 0 3 0 8] 
#[0 0 106 0 3 0 8] 
#[1 0 110 0 3 0 110 0 8 1 81 0 48] 
#[0 0 114 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[1 0 118 0 2 0 118 0 3 1 85 0 34] 
#[0 0 122 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 126 0 4 0 57] 
#[1 0 118 0 3 0 118 0 8 1 89 0 34] 
#[1 0 118 0 2 0 118 0 3 1 93 0 34] 
#[1 0 118 0 2 0 118 0 3 1 97 0 34] 
#[1 0 118 0 2 0 118 0 3 1 101 0 34] 
#[0 0 130 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 134 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 138 0 57] 
#[1 1 105 0 16 0 142 0 57] 
#[0 0 146 0 57] 
#[1 1 109 0 4 1 113 0 16 0 150 0 57] 
#[1 1 117 0 16 0 154 0 57] 
#[1 1 121 0 16 0 158 0 57] 
#[0 1 125 0 10] 
#[1 1 129 0 3 1 133 0 8 1 137 0 47] 
#[1 1 141 0 2 1 145 0 3 1 149 0 33] 
#[1 1 145 0 3 1 153 0 8 1 149 0 33] 
#[1 1 157 0 2 1 145 0 3 1 149 0 33] 
#[1 1 161 0 2 1 145 0 3 1 149 0 33] 
#[1 1 165 0 2 1 145 0 3 1 149 0 33] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 169 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[0 1 173 0 22] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 177 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 181 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[0 1 185 0 10] 
#[0 1 189 0 5] 
#[1 0 33 0 1 0 177 0 6 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 193 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 1 193 0 46 1 193 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[0 0 162 0 3 0 8 0 17] 
#[0 0 166 0 3 0 8] 
#[1 0 170 0 4 0 174 0 6 0 174 0 7 0 174 0 9 0 174 0 22 0 170 0 57] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 197 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[0 0 178 0 2 0 3 0 8] 
#[0 0 182 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 186 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 190 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 174 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 57] 
#[0 0 194 0 57] 
#[1 1 201 0 16 0 198 0 57] 
#[0 0 202 0 57] 
#[0 0 206 0 57] 
#[0 1 205 0 5] 
#[0 1 217 0 13 0 14 0 56] 
#[0 0 210 0 3 0 8] 
#[0 0 214 0 2 0 3 0 8] 
#[1 0 33 0 1 0 37 0 15 0 117 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 221 0 38 0 129 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54] 
#[0 1 225 0 13 0 14 0 56] 
#[0 0 218 0 57] 
#[0 0 222 0 57] 
#[0 0 226 0 57] 
#[0 0 230 0 57] 
#[0 0 234 0 57]
	).
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForArrayElements1: nodes [
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
	result left: (nodes at: 1).
	result equals: (nodes at: 2).
	result right: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom2: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result left: (nodes at: 1).
	result equals: (nodes at: 2).
	result right: (nodes at: 3).
	result condition: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom3: nodes [
	| result |
	result := LzTopLevelSubsortAxiomNode new.
	result subsort: (nodes at: 1).
	result subsetOf: (nodes at: 2).
	result supersort: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelOp1: nodes [
	| result |
	result := LzTopLevelOpNode new.
	result op: (nodes at: 1).
	result colon: (nodes at: 2).
	result sort: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule1: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result pattern: (nodes at: 1).
	result arrow: (nodes at: 2).
	result replacement: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule2: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result pattern: (nodes at: 1).
	result arrow: (nodes at: 2).
	result replacement: (nodes at: 3).
	result condition: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule3: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result pattern: (nodes at: 1).
	result arrow: (nodes at: 2).
	result code: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule4: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result pattern: (nodes at: 1).
	result arrow: (nodes at: 2).
	result code: (nodes at: 3).
	result condition: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule5: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result pattern: (nodes at: 1).
	result arrow: (nodes at: 2).
	result code: (nodes at: 3).
	result _class: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule6: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result pattern: (nodes at: 1).
	result arrow: (nodes at: 2).
	result code: (nodes at: 3).
	result _class: (nodes at: 5).
	result condition: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSort1: nodes [
	| result |
	result := LzTopLevelSortNode new.
	result op: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelTerm1: nodes [
	| result |
	result := LzTopLevelTermNode new.
	result term: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext1: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext2: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 3).
	result sortFlag: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext3: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext4: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 2).
	result sortFlag: (nodes at: 6).
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
LzParser2 >> reduceActionFor______comma__ArrayElement__element___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
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

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: nodes [
	| result |
	result := nodes at: 1.
	self add: ((nodes at: 2) at: 1) to: (result at: 1).
	self add: ((nodes at: 2) at: 2) to: (result at: 2).
	^ result
]
