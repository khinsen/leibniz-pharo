Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 14 0 149] 
#[ 0 42 0 157] 
#[ 0 42 0 161] 
#[ 0 42 0 165] 
#[ 0 82 0 173] 
#[ 0 90 0 173]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-05-23T12:05:37.425812+02:00'
]

{ #category : #generated }
LzParser2 class >> definitionComment [
"%unicode;
%glr;
%root ParseTree;
%prefix Lz;
%suffix Node;
%start TopLevelTerm TopLevelOp TopLevelSort;
%hierarchy LiteralTerm (IntegerLiteralTerm RationalNumberLiteralTerm FpNumberLiteralTerm StringLiteralTerm);
%hierarchy VarTerm (VarTermWithSort);
%hierarchy Term (PrefixOpTerm BracketOpTerm SuperscriptOpTerm SubscriptOpTerm VarTerm ArrayTerm LiteralTerm);
%hierarchy Op (PrefixOp InfixOp);
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
		at: 'lzTerm'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelTerm ].
]

{ #category : #accessing }
LzParser2 class >> obsolete [
	LeParser annotationParsers removeKey: 'lzSort' ifAbsent: [  ].
	LeParser annotationParsers removeKey: 'lzOp' ifAbsent: [  ].
	LeParser annotationParsers removeKey: 'lzTerm' ifAbsent: [  ].
	^ super obsolete
]

{ #category : #generated }
LzParser2 class >> reduceTable [
^#(
	#(22 1 #reduceActionForOp1: 899073 false) 
	#(31 1 #reduceActionForPrefixOpTerm1: 1738753 false) 
	#(32 1 #reduceActionForVarTerm2: 1867778 false) 
	#(39 1 #reduceActionForStringLiteralTerm1: 2357249 false) 
	#(40 1 #reduceActionForIntegerLiteralTerm1: 2403329 false) 
	#(41 1 #reduceActionForRationalNumberLiteralTerm1: 2451457 false) 
	#(42 1 #reduceActionForFpNumberLiteralTerm1: 2513921 false) 
	#(19 1 #liftFirstValue: 783361 false) 
	#(21 1 #reduceActionForTopLevelSort1: 866305 false) 
	#(29 1 #liftFirstValue: 1252353 false) 
	#(30 1 #liftFirstValue: 1651716 false) 
	#(30 1 #liftFirstValue: 1651717 false) 
	#(30 1 #liftFirstValue: 1651715 false) 
	#(30 1 #liftFirstValue: 1651713 false) 
	#(38 1 #liftFirstValue: 2244612 false) 
	#(38 1 #liftFirstValue: 2244609 false) 
	#(38 1 #liftFirstValue: 2244610 false) 
	#(38 1 #liftFirstValue: 2244611 false) 
	#(25 1 #reduceActionForTopLevelTerm1: 1104897 false) 
	#(26 1 #liftFirstValue: 1141762 false) 
	#(28 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 1169409 false) 
	#(26 2 #reduceActionForTerm1: 1141761 false) 
	#(30 3 #liftSecondValue: 1651714 false) 
	#(37 1 #liftFirstValue: 2202625 false) 
	#(37 1 #liftFirstValue: 2202626 false) 
	#(36 0 #reduceActionFor______comma__ArrayElement__element___1: 2136065 false) 
	#(33 3 #reduceActionForArrayTerm1: 1988609 false) 
	#(24 0 #reduceActionFor______comma__ArrayElement__element___1: 963585 false) 
	#(32 3 #reduceActionForVarTerm1: 1867777 false) 
	#(22 3 #reduceActionForOp3: 899075 false) 
	#(27 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 1169409 false) 
	#(28 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 1169410 false) 
	#(20 3 #reduceActionForTopLevelOp1: 809985 false) 
	#(34 4 #reduceActionForArrayElements1: 2074625 false) 
	#(36 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 2136066 false) 
	#(22 5 #reduceActionForOp2: 899074 false) 
	#(31 5 #reduceActionForPrefixOpTerm2: 1738754 false) 
	#(24 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 963586 false) 
	#(29 5 #reduceActionForNonInfixTerm2: 1252354 false) 
	#(29 5 #reduceActionForNonInfixTerm4: 1252356 false) 
	#(29 5 #reduceActionForNonInfixTerm3: 1252355 false) 
	#(35 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 2136065 false) 
	#(23 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 963585 false)
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
LzParser2 class >> startingStateForTopLevelOp [
	^ 3
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
LzParser2 class >> symbolNames [
	^ #('"("' '")"' '","' '":"' '"["' '"\("' '"]"' '"^("' '"{"' '"}"' '<whitespace>' '<opIdentifier>' '<varIdentifier>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' 'B e g i n' 'Start' 'TopLevelOp' 'TopLevelSort' 'Op' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'TopLevelTerm' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' 'SimpleTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelSortNode #LzTopLevelSortNode #LzTopLevelOpNode #LzTopLevelSortNode #LzOpNode #OrderedCollection #OrderedCollection #LzTopLevelTermNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzParseTreeNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 21 0 1 0 25 0 9 0 29 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 53 0 19 0 53 0 21 0 61 0 22 0 65 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[1 0 21 0 1 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 109 0 25 0 113 0 26 0 117 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[1 0 21 0 1 0 25 0 9 0 29 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 121 0 20 0 125 0 22 0 65 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[1 0 21 0 1 0 25 0 9 0 29 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 129 0 21 0 61 0 22 0 65 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[1 0 21 0 1 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 133 0 26 0 117 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[1 0 137 0 5 0 141 0 34] 
#[1 0 145 0 1 0 6 0 4 0 10 0 5 0 10 0 6 0 10 0 8 0 10 0 12 0 6 0 43] 
#[1 0 14 0 2 0 14 0 3 0 7 0 4 0 14 0 5 0 14 0 6 0 14 0 7 0 14 0 8 0 14 0 12 0 14 0 43] 
#[0 0 18 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 22 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 26 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 30 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 0 0 43] 
#[0 0 34 0 43] 
#[0 0 38 0 43] 
#[0 0 153 0 12] 
#[1 0 42 0 2 0 42 0 3 0 42 0 4 0 11 0 5 0 15 0 6 0 42 0 7 0 19 0 8 0 42 0 12 0 42 0 43] 
#[0 0 46 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 50 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 54 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 58 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 62 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 66 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 70 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 74 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[1 0 169 0 1 0 10 0 2 0 10 0 3 0 10 0 4 0 10 0 5 0 10 0 6 0 10 0 7 0 10 0 8 0 10 0 12 0 10 0 43] 
#[0 0 0 0 43] 
#[0 0 78 0 43] 
#[1 0 82 0 2 0 82 0 3 0 82 0 4 0 82 0 5 0 82 0 6 0 82 0 7 0 82 0 8 0 23 0 12 0 177 0 27 0 181 0 28 0 82 0 43] 
#[0 0 0 0 43] 
#[0 0 185 0 4] 
#[0 0 0 0 43] 
#[0 0 189 0 2] 
#[1 0 21 0 1 0 137 0 5 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 201 0 26 0 117 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 201 0 34 0 201 0 37 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[0 0 205 0 10] 
#[1 0 21 0 1 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 209 0 26 0 117 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[1 0 21 0 1 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 213 0 26 0 117 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[1 0 21 0 1 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 217 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[1 0 21 0 1 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 221 0 26 0 117 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[1 0 21 0 1 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 225 0 26 0 117 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[1 0 21 0 1 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 229 0 26 0 117 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[1 0 21 0 1 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 233 0 26 0 117 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[1 0 21 0 1 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 237 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[0 0 86 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[1 0 90 0 2 0 90 0 3 0 90 0 4 0 90 0 5 0 90 0 6 0 90 0 7 0 90 0 8 0 27 0 12 0 241 0 27 0 90 0 43] 
#[1 0 21 0 1 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 0 245 0 26 0 117 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[0 0 94 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 98 0 3 0 7] 
#[0 0 102 0 3 0 7] 
#[1 0 106 0 3 0 106 0 7 0 249 0 36] 
#[0 0 110 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[1 0 114 0 2 0 114 0 3 0 253 0 24] 
#[0 0 118 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 122 0 4 0 43] 
#[1 0 114 0 3 0 114 0 7 1 1 0 24] 
#[1 0 114 0 2 0 114 0 3 1 5 0 24] 
#[1 0 114 0 2 0 114 0 3 1 9 0 24] 
#[1 0 114 0 2 0 114 0 3 1 13 0 24] 
#[0 0 126 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 130 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 134 0 43] 
#[1 1 17 0 3 1 21 0 7 1 25 0 35] 
#[1 1 29 0 2 1 33 0 3 1 37 0 23] 
#[1 1 33 0 3 1 41 0 7 1 37 0 23] 
#[1 1 45 0 2 1 33 0 3 1 37 0 23] 
#[1 1 49 0 2 1 33 0 3 1 37 0 23] 
#[1 1 53 0 2 1 33 0 3 1 37 0 23] 
#[1 0 21 0 1 0 137 0 5 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 1 57 0 26 0 117 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 1 57 0 34 1 57 0 37 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[0 0 138 0 3 0 7 0 10] 
#[0 0 142 0 3 0 7] 
#[1 0 146 0 4 0 150 0 5 0 150 0 6 0 150 0 8 0 150 0 12 0 146 0 43] 
#[1 0 21 0 1 0 25 0 9 0 105 0 12 0 33 0 13 0 37 0 14 0 41 0 15 0 45 0 16 0 49 0 17 1 61 0 26 0 117 0 29 0 69 0 30 0 69 0 31 0 69 0 32 0 69 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42] 
#[0 0 154 0 2 0 3 0 7] 
#[0 0 158 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 162 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 166 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 150 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 12 0 43] 
#[0 0 170 0 3 0 7] 
#[0 0 174 0 2 0 3 0 7]
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
LzParser2 >> reduceActionForTopLevelOp1: nodes [
	| result |
	result := LzTopLevelOpNode new.
	result op: (nodes at: 1).
	result colon: (nodes at: 2).
	result sort: (nodes at: 3).
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
