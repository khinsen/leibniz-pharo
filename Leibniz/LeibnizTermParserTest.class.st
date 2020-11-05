Class {
	#name : #LeibnizTermParserTest,
	#superclass : #LeibnizParserTest,
	#category : #'Leibniz-3-Terms'
}

{ #category : #accessing }
LeibnizTermParserTest >> parserClass [
	^ LbTermParser
]

{ #category : #testing }
LeibnizTermParserTest >> testFpNumberTerms [
	#(#fpNumberTerm #literalTerm #simpleTerm #nonInfixTerm #term) do:
	[ :production |
		self parse: '2.5' rule: production.
		self assert: result equals: (self fpNumberTerm: 2.5).
		self parse: '-2.5' rule: production.
		self assert: result equals: (self fpNumberTerm: -2.5).
		self parse: '-2.5e2' rule: production.
		self assert: result equals: (self fpNumberTerm: -250.0).
		self parse: '2.e2' rule: production.
		self assert: result equals: (self fpNumberTerm: 200.0). ].

	self fail: '123' rule: #fpNumberTerm.
	self fail: 'abc' rule: #fpNumberTerm.

]

{ #category : #testing }
LeibnizTermParserTest >> testInfixTerms [
	| t |
	t := (parser signature zeroArgTermNamed: #aZeroArgOp).

	self parse: 'aZeroArgOp infixOp1 aZeroArgOp' rule: #term.
	self assert: result equals:
		(parser signature nonZeroArgTermNamed: #'_infixOp1' withArgs: { t . t }).

	self parse: 'aZeroArgOp infixOp2 aZeroArgOp' rule: #term.
	self assert: result equals:
		(parser signature nonZeroArgTermNamed: #'_infixOp2' withArgs: { t . t }).

	self parse: 'aZeroArgOp infixOp2 aZeroArgOp infixOp2 aZeroArgOp' rule: #term.
	self assert: result equals:
		(parser signature nonZeroArgTermNamed: #'_infixOp2'
								withArgs: { (parser signature nonZeroArgTermNamed: #'_infixOp2'
																		withArgs: { t . t }) . t }).

	self fail: 'aZeroArgOp infixOp1 aZeroArgOp infixOp2 aZeroArgOp' rule: #term.

]

{ #category : #testing }
LeibnizTermParserTest >> testNonInfixTerms [
	| t |
	t := (parser signature zeroArgTermNamed: #aZeroArgOp).

	self parse: 'aZeroArgOp[aZeroArgOp]' rule: #nonInfixTerm.
	self assert: result equals:
		(parser signature nonZeroArgTermNamed: #'[]' withArgs: { t . t }).

	self parse: 'aZeroArgOp[aZeroArgOp, aZeroArgOp]' rule: #nonInfixTerm.
	self assert: result equals:
		(parser signature nonZeroArgTermNamed: #'[]' withArgs: { t . t . t }).

	self parse: 'aZeroArgOp^{aZeroArgOp}' rule: #nonInfixTerm.
	self assert: result equals:
		(parser signature nonZeroArgTermNamed: #'^' withArgs: { t . t }).

	self parse: 'aZeroArgOp^{aZeroArgOp, aZeroArgOp}' rule: #nonInfixTerm.
	self assert: result equals:
		(parser signature nonZeroArgTermNamed: #'^' withArgs: { t . t . t }).

	self parse: 'aZeroArgOp_{aZeroArgOp}' rule: #nonInfixTerm.
	self assert: result equals:
		(parser signature nonZeroArgTermNamed: #'_' withArgs: { t . t }).

	self parse: 'aZeroArgOp_{aZeroArgOp, aZeroArgOp}' rule: #nonInfixTerm.
	self assert: result equals:
		(parser signature nonZeroArgTermNamed: #'_' withArgs: { t . t . t }).

]

{ #category : #testing }
LeibnizTermParserTest >> testPrecedenceRules [
	| context |
	context := LeibnizBuiltins new contextNamed: #integers.
	self assert: (context parseTerm: '2 + 3 + 4')
		  equals: (context parseTerm: '(2 + 3) + 4').
	self deny: (context parseTerm: '2 + 3 + 4')
		  equals: (context parseTerm: '2 + (3 + 4)').
	self assert: (context parseTerm: '2 + 3 + 4 + 5 + 6')
		  equals: (context parseTerm: '(((2 + 3) + 4) + 5) + 6').
	self assert: (context parseTerm: '2 + 3 - 4') isPetit2Failure.
]

{ #category : #testing }
LeibnizTermParserTest >> testPrefixTerms [
	self fail: 'aZeroArgTerm()' rule: #prefixOpTerm.

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

	self fail: 'aOneArgOp(aVar, aVar)' rule: #prefixOpTerm.
	self fail: 'aTwoArgOp(aZeroArgOp)' rule: #prefixOpTerm.


]

{ #category : #testing }
LeibnizTermParserTest >> testRationalNumberTerms [
	#(#rationalNumberTerm #literalTerm #simpleTerm #nonInfixTerm #term) do:
	[ :production |
		self parse: '2/3' rule: production.
		self assert: result equals: (self rationalNumberTerm: 2/3).
		self parse: '-2/3' rule: production.
		self assert: result equals: (self rationalNumberTerm: -2/3). ].

	self fail: '2/0' rule: #rationalNumberTerm.
	self fail: 'abc' rule: #rationalNumberTerm.
	self fail: '-2.5' rule: #rationalNumberTerm.
	self fail: '-2.5e-1' rule: #rationalNumberTerm.

]

{ #category : #testing }
LeibnizTermParserTest >> testTruthTerms [
	self parse: 'true' rule: #zeroArgTerm.
	self assert: result equals: (parser signature zeroArgTermNamed: #true ).
	self parse: 'false' rule: #zeroArgTerm.
	self assert: result equals: (parser signature zeroArgTermNamed: #false ).

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
