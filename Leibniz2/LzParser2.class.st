Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-05-17T17:58:45.607456+02:00'
]

{ #category : #generated }
LzParser2 class >> definitionComment [
"%unicode;

%glr;
%root AST2;
%prefix Lz;
%suffix Node;
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
	| IntegerLiteralTerm
	| RationalNumberLiteralTerm
	| FpNumberLiteralTerm
	| StringLiteralTerm
	;
VarTerm
	: <varIdentifier> 'id'
		{ LzASTVarTerm new
			name: (LzVarName for: id value) }
	;
StringLiteralTerm
	: <string> 'string'
		{ LzASTStringLiteral new
			value: string value allButFirst allButLast }
	;
IntegerLiteralTerm
	: <integer> 'string'
		{ LzASTIntegerLiteral new
			value: string value asNumber }
	;
RationalNumberLiteralTerm
	: <rationalNumber> 'string'
		{ LzASTRationalLiteral new
			value: (Fraction readFromString: string value) }
	;
FpNumberLiteralTerm
	: <fpNumber> 'string'
		# Pharo doesn't allow a dot followed by an exponent without any fractional part.
		# Workaround: replace '.e' by '.0e'
		{ LzASTFPLiteral new
			value: (string value copyReplaceAll: '.e' with: '.0e') asNumber asFloat }
	;"
]

{ #category : #generated }
LzParser2 class >> reduceTable [
^#(
	#(10 1 #reduceActionForVarTerm1: 570369 false) 
	#(11 1 #reduceActionForStringLiteralTerm1: 665601 false) 
	#(12 1 #reduceActionForIntegerLiteralTerm1: 785409 false) 
	#(13 1 #reduceActionForRationalNumberLiteralTerm1: 893953 false) 
	#(14 1 #reduceActionForFpNumberLiteralTerm1: 1036289 false) 
	#(8 1 #liftFirstValue: 435201 false) 
	#(9 1 #liftFirstValue: 453633 false) 
	#(9 1 #liftFirstValue: 453637 false) 
	#(9 1 #liftFirstValue: 453634 false) 
	#(9 1 #liftFirstValue: 453635 false) 
	#(9 1 #liftFirstValue: 453636 false)
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
LzParser2 class >> symbolNames [
	^ #('<whitespace>' '<varIdentifier>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' 'B e g i n' 'Start' 'Term' 'VarTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #Object #Object #Object #Object #Object #Object #Object #Object #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 9 0 2 0 13 0 3 0 17 0 4 0 21 0 5 0 25 0 6 0 29 0 8 0 29 0 9 0 29 0 10 0 29 0 11 0 29 0 12 0 29 0 13 0 29 0 14] 
#[0 0 6 0 15] 
#[0 0 10 0 15] 
#[0 0 14 0 15] 
#[0 0 18 0 15] 
#[0 0 22 0 15] 
#[0 0 0 0 15] 
#[0 0 26 0 15] 
#[0 0 30 0 15] 
#[0 0 34 0 15] 
#[0 0 38 0 15] 
#[0 0 42 0 15] 
#[0 0 46 0 15]
	).
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForFpNumberLiteralTerm1: nodes [
	^ LzASTFPLiteral new value: ((nodes at: 1) value copyReplaceAll: '.e' with: '.0e') asNumber asFloat
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForIntegerLiteralTerm1: nodes [
	^ LzASTIntegerLiteral new value: (nodes at: 1) value asNumber
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForRationalNumberLiteralTerm1: nodes [
	^ LzASTRationalLiteral new value: (Fraction readFromString: (nodes at: 1) value)
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForStringLiteralTerm1: nodes [
	^ LzASTStringLiteral new value: (nodes at: 1) value allButFirst allButLast
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForVarTerm1: nodes [
	^ LzASTVarTerm new name: (LzVarName for: (nodes at: 1) value)
]
