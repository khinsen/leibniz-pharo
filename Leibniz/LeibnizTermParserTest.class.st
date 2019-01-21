Class {
	#name : #LeibnizTermParserTest,
	#superclass : #PPCompositeParserTest,
	#category : #'Leibniz-Tests'
}

{ #category : #'term construction' }
LeibnizTermParserTest >> integerTerm: anInteger [
	^ LeibnizIntegerTerm value: anInteger forSignature: nil
]

{ #category : #accessing }
LeibnizTermParserTest >> parserClass [
	^ LeibnizTermParser
]

{ #category : #testing }
LeibnizTermParserTest >> testNumbers [
	self parse: '0' rule: #integer.
	self assert: result equals: (self integerTerm: 0).
]
