Class {
	#name : #LeibnizTermParserTest,
	#superclass : #PPCompositeParserTest,
	#category : #'Leibniz-Tests'
}

{ #category : #'term construction' }
LeibnizTermParserTest >> fpNumberTerm: aFloat [
	^ LeibnizFPNumberTerm value: aFloat forSignature: parser signature
]

{ #category : #'term construction' }
LeibnizTermParserTest >> integerTerm: anInteger [
	^ LeibnizIntegerTerm value: anInteger forSignature: parser signature
]

{ #category : #accessing }
LeibnizTermParserTest >> parserClass [
	^ LeibnizTermParser
]

{ #category : #'term construction' }
LeibnizTermParserTest >> rationalNumberTerm: aFraction [
	^ LeibnizRationalNumberTerm value: aFraction forSignature: parser signature
]

{ #category : #running }
LeibnizTermParserTest >> setUp [
	| b sg |
	super setUp.

	b := LeibnizSortGraphBuilder new.
	b add: #A;
	  add: #B;
	  make: #B subsortOf: #A.
	sg := b sortGraph.

	b := LeibnizSignatureBuilder sortGraph: sg.
	b addVar: #aVar ofSort: #A.
	b addOp: #aZeroArgOp ofSort: #B.
	b addOp: #aOneArgOp withArgs: #(#A) ofSort: #A.
	b addOp: #aOneArgOp withArgs: #(#B) ofSort: #B.
	b addOp: #aTwoArgOp withArgs: #(#A #A) ofSort: #A.
	b addOp: #'[]' withArgs: #(#A #A) ofSort: #A.
	b addOp: #'^' withArgs: #(#A #A) ofSort: #A.
	b addOp: #'_' withArgs: #(#A #A) ofSort: #A.
	parser setSignature: b signature.

]

{ #category : #'term construction' }
LeibnizTermParserTest >> stringTerm: aString [
	^ LeibnizStringTerm value: aString forSignature: parser signature
]

{ #category : #testing }
LeibnizTermParserTest >> testNonInfixTerms [
	| t |
	t := (parser signature zeroArgTermNamed: #aZeroArgOp).

	self parse: 'aZeroArgOp[aZeroArgOp]' rule: #nonInfixTerm.
	self assert: result equals:
		(parser signature nonZeroArgTermNamed: #'[]' withArgs: { t . t }).

	self parse: 'aZeroArgOp^{aZeroArgOp}' rule: #nonInfixTerm.
	self assert: result equals:
		(parser signature nonZeroArgTermNamed: #'^' withArgs: { t . t }).

	self parse: 'aZeroArgOp_{aZeroArgOp}' rule: #nonInfixTerm.
	self assert: result equals:
		(parser signature nonZeroArgTermNamed: #'_' withArgs: { t . t }).

]

{ #category : #testing }
LeibnizTermParserTest >> testNumbers [
	#(#integer #atomic #simple #nonInfixTerm #term) do:
	[ :production |
		self parse: '0' rule: production.
		self assert: result equals: (self integerTerm: 0).
		self parse: '-0' rule: production.
		self assert: result equals: (self integerTerm: 0).
		self parse: '123' rule: production.
		self assert: result equals: (self integerTerm: 123).
		self parse: '-123' rule: production.
		self assert: result equals: (self integerTerm: -123). ].

	self fail: 'abc' rule: #integer.
	self fail: '0abc' rule: #integer.
	self fail: '2/3' rule: #integer.
	self fail: '-2/3' rule: #integer.
	self fail: '2.5' rule: #integer.
	self fail: '2e2' rule: #integer.
	self fail: '2.5e2' rule: #integer.

	#(#rationalNumber #atomic #simple #nonInfixTerm #term) do:
	[ :production |
		self parse: '2/3' rule: production.
		self assert: result equals: (self rationalNumberTerm: 2/3).
		self parse: '-2/3' rule: production.
		self assert: result equals: (self rationalNumberTerm: -2/3). ].

	self fail: '2/0' rule: #rationalNumber.
	self fail: 'abc' rule: #rationalNumber.
	self fail: '-2.5' rule: #rationalNumber.
	self fail: '-2.5e-1' rule: #rationalNumber.

	#(#fpNumber #atomic #simple #nonInfixTerm #term) do:
	[ :production |
		self parse: '2.5' rule: production.
		self assert: result equals: (self fpNumberTerm: 2.5).
		self parse: '-2.5' rule: production.
		self assert: result equals: (self fpNumberTerm: -2.5).
		self parse: '-2.5e2' rule: production.
		self assert: result equals: (self fpNumberTerm: -250.0).
		self parse: '2.e2' rule: production.
		self assert: result equals: (self fpNumberTerm: 200.0). ].

	self fail: '123' rule: #fpNumber.
	self fail: 'abc' rule: #fpNumber.

]

{ #category : #testing }
LeibnizTermParserTest >> testPrefixTerms [
	self parse: 'aOneArgOp(aZeroArgOp)' rule: #prefixOpTerm.
	self assert: result
		  equals: (parser signature nonZeroArgTermNamed: #aOneArgOp
											withArgs: { parser signature zeroArgTermNamed: #aZeroArgOp }).
	self assert: result sort equals: #B.

	self parse: 'aOneArgOp(aVar)' rule: #prefixOpTerm.
	self assert: result
		  equals: (parser signature nonZeroArgTermNamed: #aOneArgOp
											withArgs: { parser signature zeroArgTermNamed: #aVar }).
	self assert: result sort equals: #A.

	self parse: 'aTwoArgOp(aZeroArgOp, aZeroArgOp)' rule: #prefixOpTerm.
	self assert: result
		  equals: (parser signature nonZeroArgTermNamed: #aTwoArgOp
											withArgs: { (parser signature zeroArgTermNamed: #aZeroArgOp) .
															(parser signature zeroArgTermNamed: #aZeroArgOp) }).
	self assert: result sort equals: #A.

]

{ #category : #testing }
LeibnizTermParserTest >> testStrings [
	self parse: '"abc"' rule: #string.
	self assert: result equals: (self stringTerm: 'abc').
	self parse: '"123"' rule: #string.
	self assert: result equals: (self stringTerm: '123').
	self parse: '"äéα"' rule: #string.
	self assert: result equals: (self stringTerm: 'äéα').
	self parse: '""' rule: #string.
	self assert: result equals: (self stringTerm: '').

	self fail: 'abc' rule: #string.
	self fail: '123' rule: #string.

]

{ #category : #testing }
LeibnizTermParserTest >> testZeroArgTerms [
	self parse: 'aVar' rule: #zeroArgTerm.
	self assert: result equals: (parser signature zeroArgTermNamed: #aVar).
	self parse: 'aZeroArgOp' rule: #zeroArgTerm.
	self assert: result equals: (parser signature zeroArgTermNamed: #aZeroArgOp).

	self fail: '123' rule: #zeroArgTerm.
	self fail: '"abc"' rule: #zeroArgTerm.
	self fail: '3/4' rule: #zeroArgTerm.

]
