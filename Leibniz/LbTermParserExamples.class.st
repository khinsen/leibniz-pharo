Class {
	#name : #LbTermParserExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-3-Terms'
}

{ #category : #utility }
LbTermParserExamples >> assertParseFailure: aString rule: aSymbol [
	| parser context result |
	parser := self parserForRule: aSymbol.
	context := PP2Context new.
	result := parser parse: aString withContext: context.
	self assert: (result isPetit2Failure or: [context atEnd not ])
]

{ #category : #example }
LbTermParserExamples >> identifiers [
	<gtExample>
	^ #('⇒⇒' '?⇒?' '|+|' '→|→')
		collect: [ :each |
			| result |
			result := self parse: each rule: #identifier.
			self assert: result equals: each.
			result ]
]

{ #category : #example }
LbTermParserExamples >> integerParseFailures [
	<gtExample>
	| inputs |
	inputs := #('abc' '0abc' '2/3' '-2/3' '2.5' '2e2' '2.5e2').
	inputs do: [ :each |
		self assertParseFailure: each rule: #integerTerm ].
	^ inputs
]

{ #category : #utility }
LbTermParserExamples >> integerTerm: anInteger [
	^ LbIntegerTerm value: anInteger forSignature: self signature
]

{ #category : #example }
LbTermParserExamples >> integerTerms [
	<gtExample>
	| rules |
	rules := #(#integerTerm #literalTerm #simpleTerm #nonInfixTerm #term).
	^ (Dictionary
			with: '0' -> (self integerTerm: 0)
			with: '-0' -> (self integerTerm: 0)
			with: '123' -> (self integerTerm: 123)
			with: '-123' -> (self integerTerm: -123))
		associations collect: [ :each |
			| result |
			rules do: [ :eachRule |
				result := self parse: each key rule: eachRule.
				self assert: result equals: each value ].
			result ]
]

{ #category : #utility }
LbTermParserExamples >> parse: aString rule: aSymbol [
	^ (self parserForRule: aSymbol)
		parse: aString
]

{ #category : #utility }
LbTermParserExamples >> parse: aString rule: aSymbol assertEquals: aValue [
	self assert: (self parse: aString rule: aSymbol)
		 equals: aValue
]

{ #category : #example }
LbTermParserExamples >> parser [
	<gtExample>
	^ LbTermParser forSignature: self signature
]

{ #category : #utility }
LbTermParserExamples >> parserForRule: aSymbol [
	| parser |
	parser := LbTermParser newStartingAt: aSymbol.
	parser setSignature: self signature.
	parser setExtraVariables: Dictionary new.
	^ parser
]

{ #category : #example }
LbTermParserExamples >> reservedIdentifierFailures [
	<gtExample>
	| inputs |
	inputs := #('⇒' '→' '∀' '|').
	inputs do: [ :each |
		self assertParseFailure: each rule: #identifier ].
	^ inputs
]

{ #category : #example }
LbTermParserExamples >> signature [
	<gtExample>
	| sortGraph |
	sortGraph := LbSortGraphBuilder new
		parseAndAdd: 'A';
		parseAndAdd: 'B ⊆ A';
		parseAndAdd: 'boolean';
		sortGraph.
	^ (LbSignatureBuilder sortGraph: sortGraph)
		addBuiltin: #integers;
		addBuiltin: #rationalNumbers;
		addBuiltin: #fpNumbers;
		addBuiltin: #strings;
		parseAndAddVar: 'aVar:A';
		parseAndAddOp: 'aZeroArgOp : B';
		parseAndAddOp: 'aOneArgOp(A) : A';
		parseAndAddOp: 'aOneArgOp(B) : B';
		parseAndAddOp: 'aTwoArgOp(A, A) : A';
		parseAndAddOp: 'A[A] : A';
		parseAndAddOp: 'A^{A} : A';
		parseAndAddOp: 'A^{A,A} : A';
		parseAndAddOp: 'A_{A} : A';
		parseAndAddOp: 'A_{A,A} : A';
		parseAndAddOp: 'A infixOp1 A : A';
		parseAndAddOp: 'A infixOp2 A : A';
		parseAndAddOp: 'true : boolean';
		parseAndAddOp: 'false : boolean';
		signature
]

{ #category : #example }
LbTermParserExamples >> stringParseFailures [
	<gtExample>
	| inputs |
	inputs := #('abc' '123').
	inputs do: [ :each |
		self assertParseFailure: each rule: #stringTerm ].
	^ inputs
]

{ #category : #utility }
LbTermParserExamples >> stringTerm: aString [
	^ LbStringTerm value: aString forSignature: self signature
]

{ #category : #example }
LbTermParserExamples >> stringTerms [
	<gtExample>
	^ (Dictionary
			with: '"abc"' -> (self stringTerm: 'abc')
			with: '"123"' -> (self stringTerm: '123')
			with: '"äéα"' -> (self stringTerm: 'äéα')
			with: '""' -> (self stringTerm: ''))
		associations collect: [ :each |
			| result |
			result := self parse: each key rule: #stringTerm.
			self assert: result equals: each value.
			result ]
]

{ #category : #utility }
LbTermParserExamples >> zeroArgTerm: aSymbol [
	^ self signature zeroArgTermNamed: (LbPrefixOperatorName for: aSymbol)
]

{ #category : #example }
LbTermParserExamples >> zeroArgTerms [
	<gtExample>
	^ (Dictionary
			with: 'true' -> (self zeroArgTerm: #true)
			with: 'false' -> (self zeroArgTerm: #false)
			with: 'aZeroArgOp' -> (self zeroArgTerm: #aZeroArgOp)
			with: 'aVar' -> (self zeroArgTerm: #aVar)
			)
		associations collect: [ :each |
			| result |
			result := self parse: each key rule: #zeroArgTerm.
			self assert: result equals: each value.
			result ]
]
