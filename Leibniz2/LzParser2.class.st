Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 46 0 249] 
#[ 0 50 1 5] 
#[ 0 50 1 9] 
#[ 0 50 1 13] 
#[ 0 18 1 57] 
#[ 0 110 0 249]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-05-27T17:58:33.6629+02:00'
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
%hierarchy Term (PrefixOpTerm BracketOpTerm SuperscriptOpTerm SubscriptOpTerm ParenthesizedTerm VarTerm ArrayTerm LiteralTerm);
%hierarchy Op (PrefixOp InfixOp);
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
	: TopLevelTerm
	;
TopLevelOp
	: (Var 'var' "","" 'comma')* Op 'op'  "":"" 'colon' Term 'sort' {{}}
	;
TopLevelSort
	: (Var 'var' "","" 'comma')* Op 'op' {{TopLevelSort}}
	| (Var 'var' "","" 'comma')* Term 'subsort' ""⊆"" 'subsetOf' Term 'supersort' {{TopLevelSubsort}}
	;
TopLevelAxiom
	: (Var 'var' "","" 'comma')* Term 'left' ""="" 'equals' Term 'right' (""|"" Term 'condition')? {{TopLevelEqualityAxiom}}
	;
TopLevelRule
	: (Var 'var' "","" 'comma')* Term 'pattern' ""⇒"" 'arrow' Term 'replacement' (""|"" Term 'condition')? {{TopLevelRewriteRule}}
	| (Var 'var' "","" 'comma')* Term 'pattern' ""→"" 'arrow' <string> 'code' ("":"" <opIdentifier> 'class')? (""|"" Term 'condition')? {{TopLevelFunctionRule}}
	;
TopLevelTerm
	: (Var 'var' "","" 'comma')* Term 'term' {{}}
	;
Op
	: <opIdentifier> 'opName'
		(""("" 'leftParen' Term 'arg'
			("","" 'comma' Term 'arg')* "")"" 'rightParen')? {{PrefixOp}}
	| NonInfixTerm 'arg' <opIdentifier> 'opName' NonInfixTerm 'arg' {{InfixOp}}
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
	#(32 0 #reduceActionFor_Var__var_______comma___1: 959489 false) 
	#(29 1 #liftFirstValue: 918529 false) 
	#(47 1 #reduceActionForPrefixOpTerm1: 2641921 false) 
	#(48 1 #reduceActionForVarTerm2: 2770946 false) 
	#(55 1 #reduceActionForStringLiteralTerm1: 3260417 false) 
	#(56 1 #reduceActionForIntegerLiteralTerm1: 3306497 false) 
	#(57 1 #reduceActionForRationalNumberLiteralTerm1: 3354625 false) 
	#(58 1 #reduceActionForFpNumberLiteralTerm1: 3417089 false) 
	#(32 2 #reduceActionFor_Var__var_______comma___2: 959490 false) 
	#(36 2 #reduceActionForTopLevelTerm1: 1626113 false) 
	#(41 1 #liftFirstValue: 1964034 false) 
	#(44 1 #liftFirstValue: 2074625 false) 
	#(45 1 #liftFirstValue: 2473986 false) 
	#(45 1 #liftFirstValue: 2473988 false) 
	#(45 1 #liftFirstValue: 2473989 false) 
	#(45 1 #liftFirstValue: 2473987 false) 
	#(45 1 #liftFirstValue: 2473985 false) 
	#(54 1 #liftFirstValue: 3147780 false) 
	#(54 1 #liftFirstValue: 3147777 false) 
	#(54 1 #liftFirstValue: 3147778 false) 
	#(54 1 #liftFirstValue: 3147779 false) 
	#(37 1 #reduceActionForOp1: 1688577 false) 
	#(33 2 #reduceActionForTopLevelSort1: 1027073 false) 
	#(59 2 #reduceActionForTopLevelUseContext3: 3467267 false) 
	#(31 2 #reduceActionFor_Var__var_______comma__1: 959489 false) 
	#(43 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 1991681 false) 
	#(41 2 #reduceActionForTerm1: 1964033 false) 
	#(59 3 #reduceActionForTopLevelUseContext1: 3467265 false) 
	#(46 3 #reduceActionForParenthesizedTerm1: 2566145 false) 
	#(53 1 #liftFirstValue: 3105793 false) 
	#(53 1 #liftFirstValue: 3105794 false) 
	#(52 0 #reduceActionFor_Var__var_______comma___1: 3039233 false) 
	#(49 3 #reduceActionForArrayTerm1: 2891777 false) 
	#(39 0 #reduceActionFor_Var__var_______comma___1: 1753089 false) 
	#(40 3 #reduceActionForVar1: 1894401 false) 
	#(48 3 #reduceActionForVarTerm1: 2770945 false) 
	#(42 2 #reduceActionFor_Var__var_______comma__1: 1991681 false) 
	#(43 2 #reduceActionFor_Var__var_______comma___2: 1991682 false) 
	#(30 4 #reduceActionForTopLevelOp1: 945153 false) 
	#(37 3 #reduceActionForOp3: 1688579 false) 
	#(33 4 #reduceActionForTopLevelSort2: 1027074 false) 
	#(34 4 #reduceActionForTopLevelAxiom1: 1195009 false) 
	#(35 4 #reduceActionForTopLevelRule3: 1331203 false) 
	#(35 4 #reduceActionForTopLevelRule1: 1331201 false) 
	#(50 4 #reduceActionForArrayElements1: 2977793 false) 
	#(52 2 #reduceActionFor_Var__var_______comma___2: 3039234 false) 
	#(47 5 #reduceActionForPrefixOpTerm2: 2641922 false) 
	#(39 2 #reduceActionFor_Var__var_______comma___2: 1753090 false) 
	#(44 5 #reduceActionForNonInfixTerm2: 2074626 false) 
	#(44 5 #reduceActionForNonInfixTerm4: 2074628 false) 
	#(44 5 #reduceActionForNonInfixTerm3: 2074627 false) 
	#(37 5 #reduceActionForOp2: 1688578 false) 
	#(34 6 #reduceActionForTopLevelAxiom2: 1195010 false) 
	#(35 6 #reduceActionForTopLevelRule5: 1331205 false) 
	#(35 6 #reduceActionForTopLevelRule4: 1331204 false) 
	#(35 6 #reduceActionForTopLevelRule2: 1331202 false) 
	#(60 1 #liftFirstValue: 3589122 false) 
	#(60 1 #liftFirstValue: 3589121 false) 
	#(59 6 #reduceActionForTopLevelUseContext4: 3467268 false) 
	#(51 2 #reduceActionFor_Var__var_______comma__1: 3039233 false) 
	#(38 2 #reduceActionFor_Var__var_______comma__1: 1753089 false) 
	#(59 7 #reduceActionForTopLevelUseContext2: 3467266 false) 
	#(35 8 #reduceActionForTopLevelRule6: 1331206 false)
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
	^ #('"("' '")"' '","' '":"' '"="' '"["' '"\("' '"]"' '"^("' '"forSorts"' '"name"' '"name="' '"no"' '"yes"' '"{"' '"|"' '"}"' '"→"' '"⇒"' '"⊆"' '<whitespace>' '<opIdentifier>' '<varIdentifier>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' 'B e g i n' 'Start' 'TopLevelOp' '(Var ''var'' "," ''comma'')' '(Var ''var'' "," ''comma'')*' 'TopLevelSort' 'TopLevelAxiom' 'TopLevelRule' 'TopLevelTerm' 'Op' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'Var' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' 'SimpleTerm' 'ParenthesizedTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' 'YesNoFlag' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelTermNode #LzTopLevelTermNode #LzTopLevelOpNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzTopLevelEqualityAxiomNode #LzTopLevelRuleNode #LzTopLevelTermNode #LzOpNode #OrderedCollection #OrderedCollection #LzVarNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzTermNode #LzTermNode #LzParenthesizedTermNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #SmaCCToken #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 6 0 1 0 6 0 15 0 6 0 22 0 6 0 23 0 6 0 24 0 6 0 25 0 6 0 26 0 6 0 27 0 33 0 29 0 37 0 32 0 33 0 36] 
#[1 0 6 0 1 0 6 0 15 0 6 0 22 0 6 0 23 0 6 0 24 0 6 0 25 0 6 0 26 0 6 0 27 0 37 0 32 0 45 0 36] 
#[1 0 6 0 1 0 6 0 15 0 6 0 22 0 6 0 23 0 6 0 24 0 6 0 25 0 6 0 26 0 6 0 27 0 49 0 30 0 53 0 32] 
#[1 0 6 0 1 0 6 0 15 0 6 0 22 0 6 0 23 0 6 0 24 0 6 0 25 0 6 0 26 0 6 0 27 0 57 0 32 0 61 0 33] 
#[1 0 6 0 1 0 6 0 15 0 6 0 22 0 6 0 23 0 6 0 24 0 6 0 25 0 6 0 26 0 6 0 27 0 65 0 32 0 69 0 34] 
#[1 0 6 0 1 0 6 0 15 0 6 0 22 0 6 0 23 0 6 0 24 0 6 0 25 0 6 0 26 0 6 0 27 0 73 0 32 0 77 0 35] 
#[1 0 81 0 11 0 85 0 12 0 89 0 59] 
#[0 0 0 0 61] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 105 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 0 125 0 31 0 129 0 40 0 133 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 0 10 0 61] 
#[0 0 0 0 61] 
#[0 0 0 0 61] 
#[1 0 93 0 1 0 97 0 15 0 181 0 22 0 105 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 0 125 0 31 0 185 0 37 0 129 0 40 0 189 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[1 0 93 0 1 0 97 0 15 0 181 0 22 0 105 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 0 125 0 31 0 193 0 37 0 129 0 40 0 197 0 41 0 201 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 0 0 0 61] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 105 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 0 125 0 31 0 129 0 40 0 205 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 0 0 0 61] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 105 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 0 125 0 31 0 129 0 40 0 209 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 0 0 0 61] 
#[0 0 213 0 5] 
#[0 0 217 0 24] 
#[0 0 0 0 61] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 0 225 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[1 0 229 0 6 0 233 0 50] 
#[1 0 237 0 1 0 14 0 2 0 14 0 3 0 14 0 4 0 14 0 5 0 14 0 6 0 14 0 7 0 14 0 8 0 14 0 9 0 14 0 16 0 14 0 18 0 14 0 19 0 14 0 20 0 14 0 22 0 14 0 61] 
#[1 0 241 0 4 0 18 0 5 0 18 0 6 0 18 0 7 0 18 0 9 0 18 0 18 0 18 0 19 0 18 0 20 0 18 0 22 0 18 0 61] 
#[0 0 22 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 26 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 30 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 34 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 38 0 1 0 15 0 22 0 23 0 24 0 25 0 26 0 27] 
#[0 0 245 0 3] 
#[0 0 42 0 61] 
#[1 0 46 0 2 0 46 0 3 0 46 0 4 0 46 0 5 0 46 0 6 0 46 0 7 0 46 0 8 0 46 0 9 0 46 0 16 0 46 0 18 0 46 0 19 0 46 0 20 0 7 0 22 0 253 0 42 1 1 0 43 0 46 0 61] 
#[1 0 50 0 2 0 50 0 3 0 50 0 4 0 50 0 5 0 11 0 6 0 15 0 7 0 50 0 8 0 19 0 9 0 50 0 16 0 50 0 18 0 50 0 19 0 50 0 20 0 50 0 22 0 50 0 61] 
#[0 0 54 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 58 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 62 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 66 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 70 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 74 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 78 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 82 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 86 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[1 1 17 0 1 0 90 0 4 0 14 0 6 0 14 0 7 0 14 0 9 0 14 0 20 0 14 0 22 0 90 0 61] 
#[0 1 21 0 4] 
#[0 1 25 0 22] 
#[0 0 94 0 61] 
#[0 1 29 0 20] 
#[1 0 46 0 20 1 33 0 22 0 253 0 42 1 1 0 43] 
#[0 1 37 0 5] 
#[1 1 41 0 18 1 45 0 19] 
#[0 1 49 0 24] 
#[1 1 53 0 16 0 98 0 61] 
#[1 0 18 0 2 0 18 0 3 0 23 0 4 0 18 0 5 0 18 0 6 0 18 0 7 0 18 0 8 0 18 0 9 0 18 0 16 0 18 0 18 0 18 0 19 0 18 0 20 0 18 0 22 0 18 0 61] 
#[0 1 61 0 2] 
#[1 0 93 0 1 0 229 0 6 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 73 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 1 73 0 50 1 73 0 53 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 1 77 0 17] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 81 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 85 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 0 102 0 1 0 15 0 22 0 23 0 24 0 25 0 26 0 27] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 89 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 0 106 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[1 0 110 0 2 0 110 0 3 0 110 0 4 0 110 0 5 0 110 0 6 0 110 0 7 0 110 0 8 0 110 0 9 0 110 0 16 0 110 0 18 0 110 0 19 0 110 0 20 0 27 0 22 1 93 0 42 0 110 0 61] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 97 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 101 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 105 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 109 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 113 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 117 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 121 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 125 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 129 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 1 133 0 24] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 137 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[1 1 141 0 16 0 114 0 61] 
#[0 1 145 0 10] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 149 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 0 118 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 122 0 3 0 8] 
#[0 0 126 0 3 0 8] 
#[1 0 130 0 3 0 130 0 8 1 153 0 52] 
#[0 0 134 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[1 0 138 0 2 0 138 0 3 1 157 0 39] 
#[1 0 142 0 3 0 146 0 5 0 146 0 6 0 146 0 7 0 146 0 9 0 146 0 18 0 146 0 19 0 146 0 20 0 146 0 22 0 146 0 61] 
#[0 0 150 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 154 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[1 0 138 0 3 0 138 0 8 1 161 0 39] 
#[1 0 138 0 2 0 138 0 3 1 165 0 39] 
#[1 0 138 0 2 0 138 0 3 1 169 0 39] 
#[1 0 138 0 2 0 138 0 3 1 173 0 39] 
#[0 0 158 0 61] 
#[0 0 162 0 4] 
#[0 0 166 0 61] 
#[1 0 150 0 20 0 150 0 22 0 162 0 61] 
#[1 1 177 0 16 0 170 0 61] 
#[1 1 181 0 4 1 185 0 16 0 174 0 61] 
#[1 1 189 0 16 0 178 0 61] 
#[0 1 193 0 10] 
#[0 1 197 0 5] 
#[0 0 146 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[1 1 201 0 3 1 205 0 8 1 209 0 51] 
#[1 1 213 0 2 1 217 0 3 1 221 0 38] 
#[1 1 217 0 3 1 225 0 8 1 221 0 38] 
#[1 1 229 0 2 1 217 0 3 1 221 0 38] 
#[1 1 233 0 2 1 217 0 3 1 221 0 38] 
#[1 1 237 0 2 1 217 0 3 1 221 0 38] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 241 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 1 245 0 22] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 249 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 1 253 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 2 1 0 5] 
#[0 2 13 0 13 0 14 0 60] 
#[1 0 93 0 1 0 229 0 6 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 2 17 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 2 17 0 50 2 17 0 53 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 0 182 0 3 0 8 0 17] 
#[0 0 186 0 3 0 8] 
#[0 0 190 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 2 21 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 0 194 0 2 0 3 0 8] 
#[0 0 198 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 202 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[0 0 206 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 61] 
#[1 0 210 0 4 0 190 0 6 0 190 0 7 0 190 0 9 0 190 0 20 0 190 0 22 0 210 0 61] 
#[0 0 214 0 61] 
#[1 2 25 0 16 0 218 0 61] 
#[0 0 222 0 61] 
#[0 0 226 0 61] 
#[0 2 29 0 13 0 14 0 60] 
#[0 0 230 0 61] 
#[0 0 234 0 61] 
#[0 0 238 0 61] 
#[0 0 242 0 3 0 8] 
#[0 0 246 0 2 0 3 0 8] 
#[1 0 93 0 1 0 97 0 15 0 101 0 22 0 221 0 23 0 109 0 24 0 113 0 25 0 117 0 26 0 121 0 27 2 33 0 41 0 137 0 44 0 141 0 45 0 141 0 46 0 141 0 47 0 141 0 48 0 141 0 49 0 141 0 54 0 141 0 55 0 141 0 56 0 141 0 57 0 141 0 58] 
#[0 0 250 0 61] 
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
	result code: (nodes at: 4).
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
	result code: (nodes at: 4).
	result condition: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule5: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result code: (nodes at: 4).
	result _class: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule6: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result code: (nodes at: 4).
	result _class: (nodes at: 6).
	result condition: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSort1: nodes [
	| result |
	result := LzTopLevelSortNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result op: (nodes at: 2).
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
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelTerm1: nodes [
	| result |
	result := LzTopLevelTermNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result term: (nodes at: 2).
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
