Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-05-20T15:40:40.653985+02:00'
]

{ #category : #generated }
LzParser2 class >> definitionComment [
"%unicode;
%glr;
%root ParseTree;
%prefix Lz;
%suffix Node;
%start TopLevelTerm;
%hierarchy LiteralTerm (IntegerLiteralTerm RationalNumberLiteralTerm FpNumberLiteralTerm StringLiteralTerm);
%hierarchy Term (PrefixOpTerm BracketOpTerm SuperscriptOpTerm SubscriptOpTerm VarTerm ArrayTerm LiteralTerm);
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
	: <varIdentifier> 'varName' {{}}
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
		at: 'lzTerm'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelTerm ]
]

{ #category : #accessing }
LzParser2 class >> obsolete [
	LeParser annotationParsers removeKey: 'lzTerm' ifAbsent: [  ].
	^ super obsolete
]

{ #category : #generated }
LzParser2 class >> reduceTable [
^#(
	#(27 1 #reduceActionForPrefixOpTerm1: 1345537 false) 
	#(28 1 #reduceActionForVarTerm1: 1474561 false) 
	#(35 1 #reduceActionForStringLiteralTerm1: 1889281 false) 
	#(36 1 #reduceActionForIntegerLiteralTerm1: 1935361 false) 
	#(37 1 #reduceActionForRationalNumberLiteralTerm1: 1983489 false) 
	#(38 1 #reduceActionForFpNumberLiteralTerm1: 2045953 false) 
	#(18 1 #liftFirstValue: 685057 false) 
	#(19 1 #reduceActionForTopLevelTerm1: 711681 false) 
	#(20 1 #liftFirstValue: 748546 false) 
	#(23 1 #liftFirstValue: 859137 false) 
	#(26 1 #liftFirstValue: 1258500 false) 
	#(26 1 #liftFirstValue: 1258501 false) 
	#(26 1 #liftFirstValue: 1258499 false) 
	#(26 1 #liftFirstValue: 1258497 false) 
	#(34 1 #liftFirstValue: 1776644 false) 
	#(34 1 #liftFirstValue: 1776641 false) 
	#(34 1 #liftFirstValue: 1776642 false) 
	#(34 1 #liftFirstValue: 1776643 false) 
	#(22 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 776193 false) 
	#(20 2 #reduceActionForTerm1: 748545 false) 
	#(26 3 #liftSecondValue: 1258498 false) 
	#(33 1 #liftFirstValue: 1734657 false) 
	#(33 1 #liftFirstValue: 1734658 false) 
	#(32 0 #reduceActionFor______comma__ArrayElement__element___1: 1668097 false) 
	#(29 3 #reduceActionForArrayTerm1: 1520641 false) 
	#(25 0 #reduceActionFor______comma__ArrayElement__element___1: 943105 false) 
	#(21 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 776193 false) 
	#(22 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 776194 false) 
	#(30 4 #reduceActionForArrayElements1: 1606657 false) 
	#(32 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 1668098 false) 
	#(27 5 #reduceActionForPrefixOpTerm2: 1345538 false) 
	#(25 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___2: 943106 false) 
	#(23 5 #reduceActionForNonInfixTerm2: 859138 false) 
	#(23 5 #reduceActionForNonInfixTerm4: 859140 false) 
	#(23 5 #reduceActionForNonInfixTerm3: 859139 false) 
	#(31 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 1668097 false) 
	#(24 2 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg__1: 943105 false)
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
LzParser2 class >> startingStateForTopLevelTerm [
	^ 2
]

{ #category : #generated }
LzParser2 class >> symbolNames [
	^ #('"("' '")"' '","' '"["' '"\("' '"]"' '"^("' '"{"' '"}"' '<whitespace>' '<opIdentifier>' '<varIdentifier>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' 'B e g i n' 'Start' 'TopLevelTerm' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'SimpleTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelTermNode #LzTopLevelTermNode #LzTopLevelTermNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzParseTreeNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 45 0 18 0 45 0 19 0 53 0 20 0 57 0 23 0 61 0 26 0 61 0 27 0 61 0 28 0 61 0 29 0 61 0 34 0 61 0 35 0 61 0 36 0 61 0 37 0 61 0 38] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 97 0 19 0 53 0 20 0 57 0 23 0 61 0 26 0 61 0 27 0 61 0 28 0 61 0 29 0 61 0 34 0 61 0 35 0 61 0 36 0 61 0 37 0 61 0 38] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 101 0 20 0 57 0 23 0 61 0 26 0 61 0 27 0 61 0 28 0 61 0 29 0 61 0 34 0 61 0 35 0 61 0 36 0 61 0 37 0 61 0 38] 
#[1 0 105 0 4 0 109 0 30] 
#[1 0 113 0 1 0 6 0 2 0 6 0 3 0 6 0 4 0 6 0 5 0 6 0 6 0 6 0 7 0 6 0 11 0 6 0 39] 
#[0 0 10 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 14 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 18 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 22 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 26 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 0 0 39] 
#[0 0 30 0 39] 
#[0 0 34 0 39] 
#[1 0 38 0 2 0 38 0 3 0 38 0 6 0 117 0 11 0 121 0 21 0 125 0 22 0 38 0 39] 
#[1 0 42 0 2 0 42 0 3 0 129 0 4 0 133 0 5 0 42 0 6 0 137 0 7 0 42 0 11 0 42 0 39] 
#[0 0 46 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 50 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 54 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 58 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 62 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 66 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 70 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 74 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 0 0 39] 
#[0 0 141 0 2] 
#[1 0 13 0 1 0 105 0 4 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 153 0 20 0 57 0 23 0 61 0 26 0 61 0 27 0 61 0 28 0 61 0 29 0 153 0 30 0 153 0 33 0 61 0 34 0 61 0 35 0 61 0 36 0 61 0 37 0 61 0 38] 
#[0 0 157 0 9] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 161 0 20 0 57 0 23 0 61 0 26 0 61 0 27 0 61 0 28 0 61 0 29 0 61 0 34 0 61 0 35 0 61 0 36 0 61 0 37 0 61 0 38] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 165 0 23 0 61 0 26 0 61 0 27 0 61 0 28 0 61 0 29 0 61 0 34 0 61 0 35 0 61 0 36 0 61 0 37 0 61 0 38] 
#[0 0 78 0 2 0 3 0 6 0 11 0 39] 
#[1 0 82 0 2 0 82 0 3 0 82 0 6 0 117 0 11 0 169 0 21 0 82 0 39] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 173 0 20 0 57 0 23 0 61 0 26 0 61 0 27 0 61 0 28 0 61 0 29 0 61 0 34 0 61 0 35 0 61 0 36 0 61 0 37 0 61 0 38] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 177 0 20 0 57 0 23 0 61 0 26 0 61 0 27 0 61 0 28 0 61 0 29 0 61 0 34 0 61 0 35 0 61 0 36 0 61 0 37 0 61 0 38] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 181 0 20 0 57 0 23 0 61 0 26 0 61 0 27 0 61 0 28 0 61 0 29 0 61 0 34 0 61 0 35 0 61 0 36 0 61 0 37 0 61 0 38] 
#[0 0 86 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[0 0 90 0 3 0 6] 
#[0 0 94 0 3 0 6] 
#[1 0 98 0 3 0 98 0 6 0 185 0 32] 
#[0 0 102 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[1 0 106 0 2 0 106 0 3 0 189 0 25] 
#[0 0 110 0 2 0 3 0 6 0 11 0 39] 
#[0 0 114 0 2 0 3 0 6 0 11 0 39] 
#[1 0 106 0 3 0 106 0 6 0 193 0 25] 
#[1 0 106 0 2 0 106 0 3 0 197 0 25] 
#[1 0 106 0 2 0 106 0 3 0 201 0 25] 
#[1 0 205 0 3 0 209 0 6 0 213 0 31] 
#[1 0 217 0 2 0 221 0 3 0 225 0 24] 
#[1 0 221 0 3 0 229 0 6 0 225 0 24] 
#[1 0 233 0 2 0 221 0 3 0 225 0 24] 
#[1 0 237 0 2 0 221 0 3 0 225 0 24] 
#[1 0 13 0 1 0 105 0 4 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 241 0 20 0 57 0 23 0 61 0 26 0 61 0 27 0 61 0 28 0 61 0 29 0 241 0 30 0 241 0 33 0 61 0 34 0 61 0 35 0 61 0 36 0 61 0 37 0 61 0 38] 
#[0 0 118 0 3 0 6 0 9] 
#[0 0 122 0 3 0 6] 
#[0 0 126 0 2 0 3 0 4 0 5 0 6 0 7 0 11 0 39] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 245 0 20 0 57 0 23 0 61 0 26 0 61 0 27 0 61 0 28 0 61 0 29 0 61 0 34 0 61 0 35 0 61 0 36 0 61 0 37 0 61 0 38] 
#[0 0 130 0 2 0 3 0 6] 
#[0 0 134 0 2 0 3 0 6 0 11 0 39] 
#[0 0 138 0 2 0 3 0 6 0 11 0 39] 
#[0 0 142 0 2 0 3 0 6 0 11 0 39] 
#[0 0 146 0 3 0 6] 
#[0 0 150 0 2 0 3 0 6]
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
LzParser2 >> reduceActionForTopLevelTerm1: nodes [
	| result |
	result := LzTopLevelTermNode new.
	result term: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForVarTerm1: nodes [
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
