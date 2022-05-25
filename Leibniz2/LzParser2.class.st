Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 10 0 193] 
#[ 0 38 0 197] 
#[ 0 42 0 209] 
#[ 0 42 0 213] 
#[ 0 42 0 217] 
#[ 0 94 0 197]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-05-25T11:10:35.985895+02:00'
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
	: TopLevelTerm
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
	#(44 1 #reduceActionForPrefixOpTerm1: 2458625 false) 
	#(45 1 #reduceActionForVarTerm2: 2587650 false) 
	#(52 1 #reduceActionForStringLiteralTerm1: 3077121 false) 
	#(53 1 #reduceActionForIntegerLiteralTerm1: 3123201 false) 
	#(54 1 #reduceActionForRationalNumberLiteralTerm1: 3171329 false) 
	#(55 1 #reduceActionForFpNumberLiteralTerm1: 3233793 false) 
	#(29 1 #liftFirstValue: 991233 false) 
	#(37 1 #reduceActionForTopLevelTerm1: 1743873 false) 
	#(38 1 #liftFirstValue: 1780738 false) 
	#(41 1 #liftFirstValue: 1891329 false) 
	#(42 1 #liftFirstValue: 2290690 false) 
	#(42 1 #liftFirstValue: 2290692 false) 
	#(42 1 #liftFirstValue: 2290693 false) 
	#(42 1 #liftFirstValue: 2290691 false) 
	#(42 1 #liftFirstValue: 2290689 false) 
	#(51 1 #liftFirstValue: 2964484 false) 
	#(51 1 #liftFirstValue: 2964481 false) 
	#(51 1 #liftFirstValue: 2964482 false) 
	#(51 1 #liftFirstValue: 2964483 false) 
	#(32 1 #reduceActionForOp1: 1106945 false) 
	#(31 1 #reduceActionForTopLevelSort1: 1074177 false) 
	#(40 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 1808385 false) 
	#(38 2 #reduceActionForTerm1: 1780737 false) 
	#(56 2 #reduceActionForTopLevelUseContext3: 3283971 false) 
	#(43 3 #reduceActionForParenthesizedTerm1: 2382849 false) 
	#(50 1 #liftFirstValue: 2922497 false) 
	#(50 1 #liftFirstValue: 2922498 false) 
	#(49 0 #reduceActionFor______comma__ArrayElement__element___1: 2855937 false) 
	#(46 3 #reduceActionForArrayTerm1: 2708481 false) 
	#(34 0 #reduceActionFor______comma__ArrayElement__element___1: 1171457 false) 
	#(45 3 #reduceActionForVarTerm1: 2587649 false) 
	#(39 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 1808385 false) 
	#(40 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 1808386 false) 
	#(30 3 #reduceActionForTopLevelOp1: 1017857 false) 
	#(32 3 #reduceActionForOp3: 1106947 false) 
	#(35 3 #reduceActionForTopLevelAxiom1: 1312769 false) 
	#(35 3 #reduceActionForTopLevelAxiom3: 1312771 false) 
	#(36 3 #reduceActionForTopLevelRule3: 1500163 false) 
	#(36 3 #reduceActionForTopLevelRule1: 1500161 false) 
	#(56 3 #reduceActionForTopLevelUseContext1: 3283969 false) 
	#(47 4 #reduceActionForArrayElements1: 2794497 false) 
	#(49 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 2855938 false) 
	#(44 5 #reduceActionForPrefixOpTerm2: 2458626 false) 
	#(34 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 1171458 false) 
	#(41 5 #reduceActionForNonInfixTerm2: 1891330 false) 
	#(41 5 #reduceActionForNonInfixTerm4: 1891332 false) 
	#(41 5 #reduceActionForNonInfixTerm3: 1891331 false) 
	#(32 5 #reduceActionForOp2: 1106946 false) 
	#(35 5 #reduceActionForTopLevelAxiom2: 1312770 false) 
	#(36 5 #reduceActionForTopLevelRule5: 1500165 false) 
	#(36 5 #reduceActionForTopLevelRule4: 1500164 false) 
	#(36 5 #reduceActionForTopLevelRule2: 1500162 false) 
	#(48 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 2855937 false) 
	#(33 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 1171457 false) 
	#(57 1 #liftFirstValue: 3405826 false) 
	#(57 1 #liftFirstValue: 3405825 false) 
	#(56 6 #reduceActionForTopLevelUseContext4: 3283972 false) 
	#(36 7 #reduceActionForTopLevelRule6: 1500166 false) 
	#(56 7 #reduceActionForTopLevelUseContext2: 3283970 false)
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
	^ #('"("' '")"' '","' '":"' '"="' '"["' '"\("' '"]"' '"^("' '"forSorts"' '"name"' '"name="' '"no"' '"yes"' '"{"' '"|"' '"}"' '"→"' '"⇒"' '"⊆"' '<whitespace>' '<opIdentifier>' '<varIdentifier>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' 'B e g i n' 'Start' 'TopLevelOp' 'TopLevelSort' 'Op' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'TopLevelAxiom' 'TopLevelRule' 'TopLevelTerm' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' 'SimpleTerm' 'ParenthesizedTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' 'YesNoFlag' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelTermNode #LzTopLevelTermNode #LzTopLevelOpNode #LzTopLevelSortNode #LzOpNode #OrderedCollection #OrderedCollection #LzTopLevelAxiomNode #LzTopLevelRuleNode #LzTopLevelTermNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzTermNode #LzTermNode #LzParenthesizedTermNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #SmaCCToken #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 65 0 29 0 65 0 37 0 73 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 121 0 37 0 73 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 125 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 129 0 30 0 133 0 32 0 137 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 125 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 141 0 31 0 145 0 32 0 137 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 149 0 35 0 153 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 157 0 36 0 161 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 165 0 11 0 169 0 12 0 173 0 56] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 0 177 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 181 0 6 0 185 0 47] 
#[1 0 189 0 1 0 6 0 2 0 6 0 3 0 6 0 4 0 6 0 5 0 6 0 6 0 6 0 7 0 6 0 8 0 6 0 9 0 6 0 16 0 6 0 18 0 6 0 19 0 6 0 20 0 6 0 22 0 6 0 58] 
#[1 0 10 0 2 0 10 0 3 0 7 0 4 0 10 0 5 0 10 0 6 0 10 0 7 0 10 0 8 0 10 0 9 0 10 0 16 0 10 0 18 0 10 0 19 0 10 0 20 0 10 0 22 0 10 0 58] 
#[0 0 14 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 18 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 22 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 26 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 0 0 58] 
#[0 0 30 0 58] 
#[0 0 34 0 58] 
#[1 0 38 0 2 0 38 0 3 0 38 0 4 0 38 0 5 0 38 0 6 0 38 0 7 0 38 0 8 0 38 0 9 0 38 0 16 0 38 0 18 0 38 0 19 0 38 0 20 0 11 0 22 0 201 0 39 0 205 0 40 0 38 0 58] 
#[1 0 42 0 2 0 42 0 3 0 42 0 4 0 42 0 5 0 15 0 6 0 19 0 7 0 42 0 8 0 23 0 9 0 42 0 16 0 42 0 18 0 42 0 19 0 42 0 20 0 42 0 22 0 42 0 58] 
#[0 0 46 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 50 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 54 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 58 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 62 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 66 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 70 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 74 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 78 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 0 0 58] 
#[1 0 221 0 1 0 82 0 4 0 6 0 6 0 6 0 7 0 6 0 9 0 6 0 22 0 82 0 58] 
#[0 0 0 0 58] 
#[0 0 225 0 4] 
#[0 0 229 0 22] 
#[0 0 0 0 58] 
#[0 0 86 0 58] 
#[0 0 0 0 58] 
#[1 0 233 0 5 0 237 0 20] 
#[0 0 0 0 58] 
#[1 0 241 0 18 0 245 0 19] 
#[0 0 249 0 5] 
#[0 0 253 0 24] 
#[0 0 0 0 58] 
#[0 1 1 0 2] 
#[1 0 33 0 1 0 181 0 6 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 13 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 1 13 0 47 1 13 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[0 1 17 0 17] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 21 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 25 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 29 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[0 0 90 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[1 0 94 0 2 0 94 0 3 0 94 0 4 0 94 0 5 0 94 0 6 0 94 0 7 0 94 0 8 0 94 0 9 0 94 0 16 0 94 0 18 0 94 0 19 0 94 0 20 0 27 0 22 1 33 0 39 0 94 0 58] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 37 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 41 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 45 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 49 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 53 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 57 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 61 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 65 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[0 1 69 0 24] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 73 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[0 1 77 0 24] 
#[1 1 81 0 16 0 98 0 58] 
#[0 0 102 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 106 0 3 0 8] 
#[0 0 110 0 3 0 8] 
#[1 0 114 0 3 0 114 0 8 1 85 0 49] 
#[0 0 118 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[1 0 122 0 2 0 122 0 3 1 89 0 34] 
#[0 0 126 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 130 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 134 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[1 0 122 0 3 0 122 0 8 1 93 0 34] 
#[1 0 122 0 2 0 122 0 3 1 97 0 34] 
#[1 0 122 0 2 0 122 0 3 1 101 0 34] 
#[1 0 122 0 2 0 122 0 3 1 105 0 34] 
#[0 0 138 0 58] 
#[0 0 142 0 4 0 58] 
#[1 1 109 0 16 0 146 0 58] 
#[0 0 150 0 58] 
#[1 1 113 0 4 1 117 0 16 0 154 0 58] 
#[1 1 121 0 16 0 158 0 58] 
#[1 1 125 0 16 0 162 0 58] 
#[0 1 129 0 10] 
#[1 1 133 0 3 1 137 0 8 1 141 0 48] 
#[1 1 145 0 2 1 149 0 3 1 153 0 33] 
#[1 1 149 0 3 1 157 0 8 1 153 0 33] 
#[1 1 161 0 2 1 149 0 3 1 153 0 33] 
#[1 1 165 0 2 1 149 0 3 1 153 0 33] 
#[1 1 169 0 2 1 149 0 3 1 153 0 33] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 173 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[0 1 177 0 22] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 181 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 185 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[0 1 189 0 10] 
#[0 1 193 0 5] 
#[1 0 33 0 1 0 181 0 6 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 197 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 1 197 0 47 1 197 0 50 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[0 0 166 0 3 0 8 0 17] 
#[0 0 170 0 3 0 8] 
#[0 0 174 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 201 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[0 0 178 0 2 0 3 0 8] 
#[0 0 182 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 186 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[0 0 190 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 16 0 18 0 19 0 20 0 22 0 58] 
#[1 0 194 0 4 0 174 0 6 0 174 0 7 0 174 0 9 0 174 0 22 0 194 0 58] 
#[0 0 198 0 58] 
#[1 1 205 0 16 0 202 0 58] 
#[0 0 206 0 58] 
#[0 0 210 0 58] 
#[0 1 209 0 5] 
#[0 1 221 0 13 0 14 0 57] 
#[0 0 214 0 3 0 8] 
#[0 0 218 0 2 0 3 0 8] 
#[1 0 33 0 1 0 37 0 15 0 41 0 22 0 45 0 23 0 49 0 24 0 53 0 25 0 57 0 26 0 61 0 27 1 225 0 38 0 77 0 41 0 81 0 42 0 81 0 43 0 81 0 44 0 81 0 45 0 81 0 46 0 81 0 51 0 81 0 52 0 81 0 53 0 81 0 54 0 81 0 55] 
#[0 1 229 0 13 0 14 0 57] 
#[0 0 222 0 58] 
#[0 0 226 0 58] 
#[0 0 230 0 58] 
#[0 0 234 0 58] 
#[0 0 238 0 58]
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
