Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-05-19T15:59:00.413052+02:00'
]

{ #category : #generated }
LzParser2 class >> definitionComment [
"%unicode;

%glr;
%root ParseTree;
%prefix Lz;
%suffix Node;
%start Term;
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
	: Term
	;
Term
	: NonInfixTerm
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
VarTerm
	: <varIdentifier> 'name' {{}}
	;
PrefixOpTerm
	: <opIdentifier> 'name'
		(""("" 'leftParen' Term 'arg'
			("","" 'comma' Term 'arg')* "")"" 'rightParen')? {{}}
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
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTerm ]
]

{ #category : #accessing }
LzParser2 class >> obsolete [
	LeParser annotationParsers removeKey: 'lzTerm' ifAbsent: [  ].
	^ super obsolete
]

{ #category : #generated }
LzParser2 class >> reduceTable [
^#(
	#(25 1 #reduceActionForPrefixOpTerm1: 1250305 false) 
	#(24 1 #reduceActionForVarTerm1: 1207297 false) 
	#(32 1 #reduceActionForStringLiteralTerm1: 1745921 false) 
	#(33 1 #reduceActionForIntegerLiteralTerm1: 1792001 false) 
	#(34 1 #reduceActionForRationalNumberLiteralTerm1: 1840129 false) 
	#(35 1 #reduceActionForFpNumberLiteralTerm1: 1902593 false) 
	#(18 1 #liftFirstValue: 677889 false) 
	#(19 1 #liftFirstValue: 696321 false) 
	#(20 1 #liftFirstValue: 720897 false) 
	#(23 1 #liftFirstValue: 1120261 false) 
	#(23 1 #liftFirstValue: 1120260 false) 
	#(23 1 #liftFirstValue: 1120259 false) 
	#(23 1 #liftFirstValue: 1120257 false) 
	#(31 1 #liftFirstValue: 1633284 false) 
	#(31 1 #liftFirstValue: 1633281 false) 
	#(31 1 #liftFirstValue: 1633282 false) 
	#(31 1 #liftFirstValue: 1633283 false) 
	#(23 3 #liftSecondValue: 1120258 false) 
	#(30 1 #liftFirstValue: 1591297 false) 
	#(30 1 #liftFirstValue: 1591298 false) 
	#(29 0 #reduceActionFor______comma__ArrayElement__element___1: 1524737 false) 
	#(26 3 #reduceActionForArrayTerm1: 1377281 false) 
	#(22 0 #reduceActionFor______comma__ArrayElement__element___1: 804865 false) 
	#(27 4 #reduceActionForArrayElements1: 1463297 false) 
	#(29 2 #reduceActionFor______comma__ArrayElement__element___2: 1524738 false) 
	#(25 5 #reduceActionForPrefixOpTerm2: 1250306 false) 
	#(22 2 #reduceActionFor______comma__ArrayElement__element___2: 804866 false) 
	#(20 5 #reduceActionForNonInfixTerm2: 720898 false) 
	#(20 5 #reduceActionForNonInfixTerm4: 720900 false) 
	#(20 5 #reduceActionForNonInfixTerm3: 720899 false) 
	#(28 2 #reduceActionFor______comma__ArrayElement__element__1: 1524737 false) 
	#(21 2 #reduceActionFor______comma__ArrayElement__element__1: 804865 false)
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
LzParser2 class >> startingStateForTerm [
	^ 2
]

{ #category : #generated }
LzParser2 class >> symbolNames [
	^ #('"("' '")"' '","' '"["' '"\("' '"]"' '"^("' '"{"' '"}"' '<whitespace>' '<opIdentifier>' '<varIdentifier>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' 'B e g i n' 'Start' 'Term' 'NonInfixTerm' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'SimpleTerm' 'VarTerm' 'PrefixOpTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTermNode #LzTermNode #LzTermNode #LzTermNode #OrderedCollection #OrderedCollection #LzTermNode #LzVarTermNode #LzPrefixOpTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 45 0 18 0 45 0 19 0 45 0 20 0 57 0 23 0 57 0 24 0 57 0 25 0 57 0 26 0 57 0 31 0 57 0 32 0 57 0 33 0 57 0 34 0 57 0 35] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 93 0 19 0 93 0 20 0 57 0 23 0 57 0 24 0 57 0 25 0 57 0 26 0 57 0 31 0 57 0 32 0 57 0 33 0 57 0 34 0 57 0 35] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 97 0 19 0 97 0 20 0 57 0 23 0 57 0 24 0 57 0 25 0 57 0 26 0 57 0 31 0 57 0 32 0 57 0 33 0 57 0 34 0 57 0 35] 
#[1 0 101 0 4 0 105 0 27] 
#[1 0 109 0 1 0 6 0 2 0 6 0 3 0 6 0 4 0 6 0 5 0 6 0 6 0 6 0 7 0 6 0 36] 
#[0 0 10 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 14 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 18 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 22 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 26 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 0 0 36] 
#[0 0 30 0 36] 
#[0 0 34 0 2 0 3 0 6 0 36] 
#[1 0 38 0 2 0 38 0 3 0 113 0 4 0 117 0 5 0 38 0 6 0 121 0 7 0 38 0 36] 
#[0 0 42 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 46 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 50 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 54 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 58 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 62 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 66 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 70 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 0 0 36] 
#[0 0 125 0 2] 
#[1 0 13 0 1 0 101 0 4 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 137 0 19 0 137 0 20 0 57 0 23 0 57 0 24 0 57 0 25 0 57 0 26 0 137 0 27 0 137 0 30 0 57 0 31 0 57 0 32 0 57 0 33 0 57 0 34 0 57 0 35] 
#[0 0 141 0 9] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 145 0 19 0 145 0 20 0 57 0 23 0 57 0 24 0 57 0 25 0 57 0 26 0 57 0 31 0 57 0 32 0 57 0 33 0 57 0 34 0 57 0 35] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 149 0 19 0 149 0 20 0 57 0 23 0 57 0 24 0 57 0 25 0 57 0 26 0 57 0 31 0 57 0 32 0 57 0 33 0 57 0 34 0 57 0 35] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 153 0 19 0 153 0 20 0 57 0 23 0 57 0 24 0 57 0 25 0 57 0 26 0 57 0 31 0 57 0 32 0 57 0 33 0 57 0 34 0 57 0 35] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 157 0 19 0 157 0 20 0 57 0 23 0 57 0 24 0 57 0 25 0 57 0 26 0 57 0 31 0 57 0 32 0 57 0 33 0 57 0 34 0 57 0 35] 
#[0 0 74 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[0 0 78 0 3 0 6] 
#[0 0 82 0 3 0 6] 
#[1 0 86 0 3 0 86 0 6 0 161 0 29] 
#[0 0 90 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[1 0 94 0 2 0 94 0 3 0 165 0 22] 
#[1 0 94 0 3 0 94 0 6 0 169 0 22] 
#[1 0 94 0 2 0 94 0 3 0 173 0 22] 
#[1 0 94 0 2 0 94 0 3 0 177 0 22] 
#[1 0 181 0 3 0 185 0 6 0 189 0 28] 
#[1 0 193 0 2 0 197 0 3 0 201 0 21] 
#[1 0 197 0 3 0 205 0 6 0 201 0 21] 
#[1 0 209 0 2 0 197 0 3 0 201 0 21] 
#[1 0 213 0 2 0 197 0 3 0 201 0 21] 
#[1 0 13 0 1 0 101 0 4 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 217 0 19 0 217 0 20 0 57 0 23 0 57 0 24 0 57 0 25 0 57 0 26 0 217 0 27 0 217 0 30 0 57 0 31 0 57 0 32 0 57 0 33 0 57 0 34 0 57 0 35] 
#[0 0 98 0 3 0 6 0 9] 
#[0 0 102 0 3 0 6] 
#[0 0 106 0 2 0 3 0 4 0 5 0 6 0 7 0 36] 
#[1 0 13 0 1 0 17 0 8 0 21 0 11 0 25 0 12 0 29 0 13 0 33 0 14 0 37 0 15 0 41 0 16 0 221 0 19 0 221 0 20 0 57 0 23 0 57 0 24 0 57 0 25 0 57 0 26 0 57 0 31 0 57 0 32 0 57 0 33 0 57 0 34 0 57 0 35] 
#[0 0 110 0 2 0 3 0 6] 
#[0 0 114 0 2 0 3 0 6 0 36] 
#[0 0 118 0 2 0 3 0 6 0 36] 
#[0 0 122 0 2 0 3 0 6 0 36] 
#[0 0 126 0 3 0 6] 
#[0 0 130 0 2 0 3 0 6]
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
	result name: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForPrefixOpTerm2: nodes [
	| result |
	result := LzPrefixOpTermNode new.
	result name: (nodes at: 1).
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
LzParser2 >> reduceActionForVarTerm1: nodes [
	| result |
	result := LzVarTermNode new.
	result name: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor______comma__ArrayElement__element__1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
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
LzParser2 >> reduceActionFor______comma__ArrayElement__element___2: nodes [
	| result |
	result := nodes at: 1.
	self add: ((nodes at: 2) at: 1) to: (result at: 1).
	self add: ((nodes at: 2) at: 2) to: (result at: 2).
	^ result
]
