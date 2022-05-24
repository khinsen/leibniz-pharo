Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 14 0 201] 
#[ 0 42 0 209] 
#[ 0 42 0 213] 
#[ 0 42 0 217] 
#[ 0 82 0 225] 
#[ 0 102 0 225]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-05-24T16:19:58.371468+02:00'
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
	: Item 'item' (""|"" 'bar' Item 'item')* ""|"" 'bar'? {{}}
	;
Item
	: PageReference
	| SortFlag
	;
PageReference
	: ""name"" 'name' ""="" 'equals' <string> 'value' {{}}
	;
SortFlag
	: ""forSorts"" 'name' ""="" 'equals' YesNoFlag 'yesno' {{}}
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
	#(31 1 #reduceActionForOp1: 1088513 false) 
	#(42 1 #reduceActionForPrefixOpTerm1: 2359297 false) 
	#(43 1 #reduceActionForVarTerm2: 2488322 false) 
	#(50 1 #reduceActionForStringLiteralTerm1: 2977793 false) 
	#(51 1 #reduceActionForIntegerLiteralTerm1: 3023873 false) 
	#(52 1 #reduceActionForRationalNumberLiteralTerm1: 3072001 false) 
	#(53 1 #reduceActionForFpNumberLiteralTerm1: 3134465 false) 
	#(28 1 #liftFirstValue: 972801 false) 
	#(30 1 #reduceActionForTopLevelSort1: 1055745 false) 
	#(40 1 #liftFirstValue: 1872897 false) 
	#(41 1 #liftFirstValue: 2272260 false) 
	#(41 1 #liftFirstValue: 2272261 false) 
	#(41 1 #liftFirstValue: 2272259 false) 
	#(41 1 #liftFirstValue: 2272257 false) 
	#(49 1 #liftFirstValue: 2865156 false) 
	#(49 1 #liftFirstValue: 2865153 false) 
	#(49 1 #liftFirstValue: 2865154 false) 
	#(49 1 #liftFirstValue: 2865155 false) 
	#(36 1 #reduceActionForTopLevelTerm1: 1725441 false) 
	#(37 1 #liftFirstValue: 1762306 false) 
	#(56 0 #reduceActionFor______bar__Item__item___1: 3220481 false) 
	#(57 1 #liftFirstValue: 3265537 false) 
	#(57 1 #liftFirstValue: 3265538 false) 
	#(39 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 1789953 false) 
	#(37 2 #reduceActionForTerm1: 1762305 false) 
	#(54 2 #reduceActionForTopLevelUseContext1: 3184641 false) 
	#(41 3 #liftSecondValue: 2272258 false) 
	#(48 1 #liftFirstValue: 2823169 false) 
	#(48 1 #liftFirstValue: 2823170 false) 
	#(47 0 #reduceActionFor______bar__Item__item___1: 2756609 false) 
	#(44 3 #reduceActionForArrayTerm1: 2609153 false) 
	#(33 0 #reduceActionFor______bar__Item__item___1: 1153025 false) 
	#(43 3 #reduceActionForVarTerm1: 2488321 false) 
	#(31 3 #reduceActionForOp3: 1088515 false) 
	#(38 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 1789953 false) 
	#(39 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 1789954 false) 
	#(29 3 #reduceActionForTopLevelOp1: 999425 false) 
	#(34 3 #reduceActionForTopLevelAxiom1: 1294337 false) 
	#(34 3 #reduceActionForTopLevelAxiom3: 1294339 false) 
	#(35 3 #reduceActionForTopLevelRule3: 1481731 false) 
	#(35 3 #reduceActionForTopLevelRule1: 1481729 false) 
	#(60 1 #liftFirstValue: 3444738 false) 
	#(60 1 #liftFirstValue: 3444737 false) 
	#(59 3 #reduceActionForSortFlag1: 3374081 false) 
	#(58 3 #reduceActionForPageReference1: 3303425 false) 
	#(54 3 #reduceActionForTopLevelUseContext2: 3184642 false) 
	#(56 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 3220482 false) 
	#(55 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 3220481 false) 
	#(45 4 #reduceActionForArrayElements1: 2695169 false) 
	#(47 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 2756610 false) 
	#(31 5 #reduceActionForOp2: 1088514 false) 
	#(42 5 #reduceActionForPrefixOpTerm2: 2359298 false) 
	#(33 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 1153026 false) 
	#(40 5 #reduceActionForNonInfixTerm2: 1872898 false) 
	#(40 5 #reduceActionForNonInfixTerm4: 1872900 false) 
	#(40 5 #reduceActionForNonInfixTerm3: 1872899 false) 
	#(34 5 #reduceActionForTopLevelAxiom2: 1294338 false) 
	#(35 5 #reduceActionForTopLevelRule5: 1481733 false) 
	#(35 5 #reduceActionForTopLevelRule4: 1481732 false) 
	#(35 5 #reduceActionForTopLevelRule2: 1481730 false) 
	#(46 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 2756609 false) 
	#(32 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 1153025 false) 
	#(35 7 #reduceActionForTopLevelRule6: 1481734 false)
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
	^ #('"("' '")"' '","' '":"' '"="' '"["' '"\("' '"]"' '"^("' '"forSorts"' '"name"' '"no"' '"yes"' '"{"' '"|"' '"}"' '"→"' '"⇒"' '"⊆"' '<whitespace>' '<opIdentifier>' '<varIdentifier>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' 'B e g i n' 'Start' 'TopLevelOp' 'TopLevelSort' 'Op' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'TopLevelAxiom' 'TopLevelRule' 'TopLevelTerm' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' 'SimpleTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' '("|" ''bar'' Item ''item'')' '("|" ''bar'' Item ''item'')*' 'Item' 'PageReference' 'SortFlag' 'YesNoFlag' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelSortNode #LzTopLevelSortNode #LzTopLevelOpNode #LzTopLevelSortNode #LzOpNode #OrderedCollection #OrderedCollection #LzTopLevelAxiomNode #LzTopLevelRuleNode #LzTopLevelTermNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzParseTreeNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzPageReferenceNode #LzSortFlagNode #SmaCCToken #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 33 0 1 0 37 0 14 0 41 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 0 65 0 28 0 65 0 30 0 73 0 31 0 77 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 0 121 0 36 0 125 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 41 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 0 133 0 29 0 137 0 31 0 77 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 41 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 0 141 0 30 0 73 0 31 0 77 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 0 145 0 34 0 149 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 0 153 0 35 0 157 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 161 0 10 0 165 0 11 0 169 0 54 0 173 0 57 0 173 0 58 0 173 0 59] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 0 185 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 189 0 6 0 193 0 45] 
#[1 0 197 0 1 0 6 0 4 0 10 0 6 0 10 0 7 0 10 0 9 0 10 0 21 0 6 0 61] 
#[1 0 14 0 2 0 14 0 3 0 7 0 4 0 14 0 5 0 14 0 6 0 14 0 7 0 14 0 8 0 14 0 9 0 14 0 15 0 14 0 17 0 14 0 18 0 14 0 19 0 14 0 21 0 14 0 61] 
#[0 0 18 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 22 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 26 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 30 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 0 0 61] 
#[0 0 34 0 61] 
#[0 0 38 0 61] 
#[0 0 205 0 21] 
#[1 0 42 0 2 0 42 0 3 0 42 0 4 0 42 0 5 0 11 0 6 0 15 0 7 0 42 0 8 0 19 0 9 0 42 0 15 0 42 0 17 0 42 0 18 0 42 0 19 0 42 0 21 0 42 0 61] 
#[0 0 46 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 50 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 54 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 58 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 62 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 66 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 70 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 74 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[1 0 221 0 1 0 10 0 2 0 10 0 3 0 10 0 4 0 10 0 5 0 10 0 6 0 10 0 7 0 10 0 8 0 10 0 9 0 10 0 15 0 10 0 17 0 10 0 18 0 10 0 19 0 10 0 21 0 10 0 61] 
#[0 0 0 0 61] 
#[0 0 78 0 61] 
#[1 0 82 0 2 0 82 0 3 0 82 0 4 0 82 0 5 0 82 0 6 0 82 0 7 0 82 0 8 0 82 0 9 0 82 0 15 0 82 0 17 0 82 0 18 0 82 0 19 0 23 0 21 0 229 0 38 0 233 0 39 0 82 0 61] 
#[0 0 0 0 61] 
#[0 0 237 0 4] 
#[0 0 0 0 61] 
#[0 0 0 0 61] 
#[1 0 241 0 5 0 245 0 19] 
#[0 0 0 0 61] 
#[1 0 249 0 17 0 253 0 18] 
#[0 1 1 0 5] 
#[0 1 5 0 5] 
#[0 0 0 0 61] 
#[1 0 86 0 15 1 9 0 56 0 86 0 61] 
#[0 0 90 0 15 0 61] 
#[0 0 94 0 15 0 61] 
#[0 1 13 0 2] 
#[1 0 33 0 1 0 189 0 6 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 25 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 1 25 0 45 1 25 0 48 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[0 1 29 0 16] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 33 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 37 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 41 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 45 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 49 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 53 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 57 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 61 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[0 0 98 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[1 0 102 0 2 0 102 0 3 0 102 0 4 0 102 0 5 0 102 0 6 0 102 0 7 0 102 0 8 0 102 0 9 0 102 0 15 0 102 0 17 0 102 0 18 0 102 0 19 0 27 0 21 1 65 0 38 0 102 0 61] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 69 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 73 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 77 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[0 1 81 0 23] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 85 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[0 1 97 0 12 0 13 0 60] 
#[0 1 101 0 23] 
#[1 1 105 0 15 1 109 0 55 0 106 0 61] 
#[0 0 110 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 114 0 3 0 8] 
#[0 0 118 0 3 0 8] 
#[1 0 122 0 3 0 122 0 8 1 113 0 47] 
#[0 0 126 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[1 0 130 0 2 0 130 0 3 1 117 0 33] 
#[0 0 134 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 138 0 4 0 61] 
#[1 0 130 0 3 0 130 0 8 1 121 0 33] 
#[1 0 130 0 2 0 130 0 3 1 125 0 33] 
#[1 0 130 0 2 0 130 0 3 1 129 0 33] 
#[1 0 130 0 2 0 130 0 3 1 133 0 33] 
#[0 0 142 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 146 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 150 0 61] 
#[1 1 137 0 15 0 154 0 61] 
#[0 0 158 0 61] 
#[1 1 141 0 4 1 145 0 15 0 162 0 61] 
#[1 1 149 0 15 0 166 0 61] 
#[0 0 170 0 15 0 61] 
#[0 0 174 0 15 0 61] 
#[0 0 178 0 15 0 61] 
#[0 0 182 0 15 0 61] 
#[1 0 161 0 10 0 165 0 11 1 153 0 57 1 153 0 58 1 153 0 59 0 186 0 61] 
#[0 0 190 0 15 0 61] 
#[1 1 157 0 3 1 161 0 8 1 165 0 46] 
#[1 1 169 0 2 1 173 0 3 1 177 0 32] 
#[1 1 173 0 3 1 181 0 8 1 177 0 32] 
#[1 1 185 0 2 1 173 0 3 1 177 0 32] 
#[1 1 189 0 2 1 173 0 3 1 177 0 32] 
#[1 1 193 0 2 1 173 0 3 1 177 0 32] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 197 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[0 1 201 0 21] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 205 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 209 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[0 0 194 0 15 0 61] 
#[1 0 33 0 1 0 189 0 6 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 213 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 1 213 0 45 1 213 0 48 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[0 0 198 0 3 0 8 0 16] 
#[0 0 202 0 3 0 8] 
#[1 0 206 0 4 0 210 0 6 0 210 0 7 0 210 0 9 0 210 0 21 0 206 0 61] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 217 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[0 0 214 0 2 0 3 0 8] 
#[0 0 218 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 222 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 226 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 210 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 15 0 17 0 18 0 19 0 21 0 61] 
#[0 0 230 0 61] 
#[1 1 221 0 15 0 234 0 61] 
#[0 0 238 0 61] 
#[0 0 242 0 61] 
#[0 0 246 0 3 0 8] 
#[0 0 250 0 2 0 3 0 8] 
#[1 0 33 0 1 0 37 0 14 0 117 0 21 0 45 0 22 0 49 0 23 0 53 0 24 0 57 0 25 0 61 0 26 1 225 0 37 0 129 0 40 0 81 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 49 0 81 0 50 0 81 0 51 0 81 0 52 0 81 0 53] 
#[0 0 254 0 61]
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
LzParser2 >> reduceActionForPageReference1: nodes [
	| result |
	result := LzPageReferenceNode new.
	result name: (nodes at: 1).
	result equals: (nodes at: 2).
	result value: (nodes at: 3).
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
LzParser2 >> reduceActionForSortFlag1: nodes [
	| result |
	result := LzSortFlagNode new.
	result name: (nodes at: 1).
	result equals: (nodes at: 2).
	result yesno: (nodes at: 3).
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
	result addNode: (nodes at: 1) to: result items.
	result addTokens: ((nodes at: 2) at: 1) to: result bars.
	result addNodes: ((nodes at: 2) at: 2) to: result items.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext2: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result addNode: (nodes at: 1) to: result items.
	result addTokens: ((nodes at: 2) at: 1) to: result bars.
	result addNodes: ((nodes at: 2) at: 2) to: result items.
	result addToken: (nodes at: 3) to: result bars.
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
LzParser2 >> reduceActionFor______bar__Item__item___1: nodes [
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
