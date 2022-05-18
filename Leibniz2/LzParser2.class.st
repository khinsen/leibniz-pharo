Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-05-18T18:15:55.363613+02:00'
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
%hierarchy Term (VarTerm LiteralTerm);
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
	: VarTerm
	| LiteralTerm
	;
LiteralTerm
	: IntegerLiteralTerm
	| RationalNumberLiteralTerm
	| FpNumberLiteralTerm
	| StringLiteralTerm
	;
VarTerm
	: <varIdentifier> 'text' {{}}
		#{ LzASTVarTerm new
		#	name: (LzVarName for: id value) }
	;
StringLiteralTerm
	: <string> 'text' {{}}
		#{ LzASTStringLiteral new
		#	value: string value allButFirst allButLast }
	;
IntegerLiteralTerm
	: <integer> 'text' {{}}
		#{ LzASTIntegerLiteral new
		#	value: string value asNumber }
	;
RationalNumberLiteralTerm
	: <rationalNumber> 'text' {{}}
		#{ LzASTRationalLiteral new
		#	value: (Fraction readFromString: string value) }
	;
FpNumberLiteralTerm
	: <fpNumber> 'text' {{}}
		# Pharo doesn't allow a dot followed by an exponent without any fractional part.
		# Workaround: replace '.e' by '.0e'
		#{ LzASTFPLiteral new
		#	value: (string value copyReplaceAll: '.e' with: '.0e') asNumber asFloat }
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
	#(11 1 #reduceActionForVarTerm1: 771073 false) 
	#(12 1 #reduceActionForStringLiteralTerm1: 875521 false) 
	#(13 1 #reduceActionForIntegerLiteralTerm1: 1000449 false) 
	#(14 1 #reduceActionForRationalNumberLiteralTerm1: 1114113 false) 
	#(15 1 #reduceActionForFpNumberLiteralTerm1: 1261569 false) 
	#(8 1 #liftFirstValue: 605185 false) 
	#(9 1 #liftFirstValue: 623618 false) 
	#(9 1 #liftFirstValue: 623617 false) 
	#(10 1 #liftFirstValue: 658436 false) 
	#(10 1 #liftFirstValue: 658433 false) 
	#(10 1 #liftFirstValue: 658434 false) 
	#(10 1 #liftFirstValue: 658435 false)
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
	^ #('<whitespace>' '<varIdentifier>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' 'B e g i n' 'Start' 'Term' 'LiteralTerm' 'VarTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTermNode #LzTermNode #LzTermNode #LzLiteralTermNode #LzVarTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 13 0 2 0 17 0 3 0 21 0 4 0 25 0 5 0 29 0 6 0 33 0 8 0 33 0 9 0 33 0 10 0 33 0 11 0 33 0 12 0 33 0 13 0 33 0 14 0 33 0 15] 
#[1 0 13 0 2 0 17 0 3 0 21 0 4 0 25 0 5 0 29 0 6 0 65 0 9 0 65 0 10 0 65 0 11 0 65 0 12 0 65 0 13 0 65 0 14 0 65 0 15] 
#[0 0 6 0 16] 
#[0 0 10 0 16] 
#[0 0 14 0 16] 
#[0 0 18 0 16] 
#[0 0 22 0 16] 
#[0 0 0 0 16] 
#[0 0 26 0 16] 
#[0 0 30 0 16] 
#[0 0 34 0 16] 
#[0 0 38 0 16] 
#[0 0 42 0 16] 
#[0 0 46 0 16] 
#[0 0 50 0 16] 
#[0 0 0 0 16]
	).
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
	result text: (nodes at: 1).
	^ result
]
