Class {
	#name : #LeibnizTermParserTest,
	#superclass : #PPCompositeParserTest,
	#category : #'Leibniz-Tests'
}

{ #category : #'term construction' }
LeibnizTermParserTest >> fpNumberTerm: aFloat [
	^ LeibnizFPNumberTerm value: aFloat forSignature: nil
]

{ #category : #'term construction' }
LeibnizTermParserTest >> integerTerm: anInteger [
	^ LeibnizIntegerTerm value: anInteger forSignature: nil
]

{ #category : #accessing }
LeibnizTermParserTest >> parserClass [
	^ LeibnizTermParser
]

{ #category : #'term construction' }
LeibnizTermParserTest >> rationalNumberTerm: aFraction [
	^ LeibnizRationalNumberTerm value: aFraction forSignature: nil
]

{ #category : #'term construction' }
LeibnizTermParserTest >> stringTerm: aString [
	^ LeibnizStringTerm value: aString forSignature: nil
]

{ #category : #testing }
LeibnizTermParserTest >> testNumbers [
	#(#integer #atomic #simple #term) do:
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

	#(#rationalNumber #atomic #simple #term) do:
	[ :production |
		self parse: '2/3' rule: production.
		self assert: result equals: (self rationalNumberTerm: 2/3).
		self parse: '-2/3' rule: production.
		self assert: result equals: (self rationalNumberTerm: -2/3). ].

	self fail: '2/0' rule: #rationalNumber.
	self fail: 'abc' rule: #rationalNumber.
	self fail: '-2.5' rule: #rationalNumber.
	self fail: '-2.5e-1' rule: #rationalNumber.

	#(#fpNumber #atomic #simple #term) do:
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
