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
LbTermParserExamples >> fpNumberParseFailures [
	<gtExample>
	| inputs |
	inputs := #('.5' '2.e' '2.f1' '2.0g2' '1.5d1' '123' 'abc').
	inputs do: [ :each |
		self assertParseFailure: each rule: #fpNumberTerm ].
	^ inputs
]

{ #category : #utility }
LbTermParserExamples >> fpNumberTerm: aFloat [
	^ LbFPNumberTerm value: aFloat forSignature: self signature
]

{ #category : #example }
LbTermParserExamples >> fpNumberTerms [
	<gtExample>
	^ {
		'2.5' -> (self fpNumberTerm: 2.5).
		'-2.5' -> (self fpNumberTerm: -2.5).
		'2.5e2' -> (self fpNumberTerm: 250.0).
		'2.e2' -> (self fpNumberTerm: 200.0).
	} collect: [ :each |
		| result |
		result := self parse: each key rule: #fpNumberTerm.
		self assert: result equals: each value.
		result ]
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

{ #category : #utility }
LbTermParserExamples >> infixOpTerm: aSymbol withArgs: anArray [
	^ self signature nonZeroArgTermNamed: (LbInfixOperatorName for: aSymbol) withArgs: anArray
]

{ #category : #example }
LbTermParserExamples >> infixOpTerms [
	<gtExample>
	| t |
	t := self zeroArgTerm: #aZeroArgOp.
	^ {
		'aZeroArgOp infixOp1 aZeroArgOp'
				-> (self
						infixOpTerm: #infixOp1
						withArgs:{t. t}).
		'aZeroArgOp infixOp2 aZeroArgOp'
				-> (self
						infixOpTerm: #infixOp2
						withArgs:{t. t}).
		'aZeroArgOp infixOp2 aZeroArgOp infixOp2 aZeroArgOp'
				-> (self
						infixOpTerm: #infixOp2
						withArgs: {self
										infixOpTerm: #infixOp2
										withArgs: {t. t}.
									t})
		}
	collect: [ :each | 
		| result |
		result := self parse: each key rule: #term.
		self assert: result equals: each value.
		result ]
]

{ #category : #example }
LbTermParserExamples >> infixTermParseFailures [
	<gtExample>
	| inputs |
	inputs := #('aZeroArgOp infixOp1 aZeroArgOp infixOp2 aZeroArgOp').
	inputs do: [ :each |
		self assertParseFailure: each rule: #term ].
	^ inputs
]

{ #category : #example }
LbTermParserExamples >> integerLiteralTerms [
	<gtExample>
	| rules |
	rules := #(#integerTerm #literalTerm #simpleTerm #nonInfixTerm #term).
	^ {
		'0' -> (self integerTerm: 0).
		'-0' -> (self integerTerm: 0).
		'123' -> (self integerTerm: 123).
		'-123' -> (self integerTerm: -123)
 	}
 	collect: [ :each |
		| result |
		rules do: [ :eachRule |
			result := self parse: each key rule: eachRule.
			self assert: result equals: each value ].
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
LbTermParserExamples >> nonInfixTerms [
	<gtExample>
	| t |
	t := self zeroArgTerm: #aZeroArgOp.
	^ {
		'aZeroArgOp[aZeroArgOp]'
				-> (self
						specialOpTerm: #'[]'
						withArgs:{t. t}).
		'aZeroArgOp[aZeroArgOp, aZeroArgOp]'
				-> (self
						specialOpTerm: #'[]'
						withArgs:{t. t. t}).
		'aZeroArgOp^{aZeroArgOp}'
				-> (self
						specialOpTerm: #'^'
						withArgs:{t. t}).
		'aZeroArgOp^{aZeroArgOp, aZeroArgOp}'
				-> (self
						specialOpTerm: #'^'
						withArgs:{t. t. t}).
		'aZeroArgOp_{aZeroArgOp}'
				-> (self
						specialOpTerm: #'_'
						withArgs:{t. t}).
		'aZeroArgOp_{aZeroArgOp, aZeroArgOp}'
				-> (self
						specialOpTerm: #'_'
						withArgs:{t. t. t}).
		}
	collect: [ :each | 
		| result |
		result := self parse: each key rule: #nonInfixTerm.
		self assert: result equals: each value.
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
LbTermParserExamples >> precedenceRuleExamples [
	<gtExample>
	^ {
		#('2 + 3 + 4'
		  '(2 + 3) + 4').
		#('2 + 3 + 4 + 5 + 6'
		  '(((2 + 3) + 4) + 5) + 6')
	} collect: [ :each |
		| t1 t2 |
		t1 := self parse: each first rule: #term.
		t2 := self parse: each second rule: #term.
		self assert: t1 equals: t2.
		t1 ]
]

{ #category : #utility }
LbTermParserExamples >> prefixOpTerm: aSymbol withArgs: anArray [
	^ self signature nonZeroArgTermNamed: (LbPrefixOperatorName for: aSymbol) withArgs: anArray
]

{ #category : #example }
LbTermParserExamples >> prefixOpTerms [
	<gtExample>
	| t v |
	t := self zeroArgTerm: #aZeroArgOp.
	v := self zeroArgTerm: #aVar.
	^ {
		'aOneArgOp(aZeroArgOp)'
			-> (self prefixOpTerm: #aOneArgOp withArgs: {t}).
		'aOneArgOp(aVar)'
			-> (self prefixOpTerm: #aOneArgOp withArgs: {v}).
		'aTwoArgOp(aZeroArgOp, aZeroArgOp)'
			-> (self
					prefixOpTerm: #aTwoArgOp
					withArgs: {t. t})
	}
	collect: [ :each | 
		| result |
		result := self parse: each key rule: #prefixOpTerm.
		self assert: result equals: each value.
		result ]
]

{ #category : #example }
LbTermParserExamples >> prefixTermParseFailures [
	<gtExample>
	| inputs |
	inputs := #('aZeroArgOp()' 'aOneArgOp(aVar, aVar)' 'aTwoArgOp(aZeroArgOp)').
	inputs do: [ :each |
		self assertParseFailure: each rule: #prefixOpTerm ].
	^ inputs
]

{ #category : #example }
LbTermParserExamples >> rationalNumberParseFailures [
	<gtExample>
	| inputs |
	inputs := #('2/0' 'abc' '2.5' '-2.5' '-2.5e-1').
	inputs do: [ :each |
		self assertParseFailure: each rule: #rationalNumberTerm ].
	^ inputs
]

{ #category : #utility }
LbTermParserExamples >> rationalNumberTerm: aRational [
	^ LbRationalNumberTerm value: aRational forSignature: self signature
]

{ #category : #example }
LbTermParserExamples >> rationalNumberTerms [
	<gtExample>
	^ {
		'2/3' -> (self rationalNumberTerm: 2/3).
		'-2/3' -> (self rationalNumberTerm: -2/3)
	} collect: [ :each |
		| result |
		result := self parse: each key rule: #rationalNumberTerm.
		self assert: result equals: each value.
		result ]
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
		addSortGraph: (LbBuiltinSortGraphs rationalNumberSortGraph);
		addSortGraph: (LbBuiltinSortGraphs fpNumberSortGraph);
		addSortGraph: (LbBuiltinSortGraphs stringSortGraph);
		parseAndAdd: 'A';
		parseAndAdd: 'B ⊆ A';
		parseAndAdd: 'boolean';
		sortGraph.
	^ (LbSignatureBuilder sortGraph: sortGraph)
		addSignature: (LbBuiltinSignatures rationalNumberSignature) includeVars: false;
		addSignature: (LbBuiltinSignatures fpNumberSignature) includeVars: false;
		addSignature: (LbBuiltinSignatures stringSignature) includeVars: false;
		parseAndAddVar: 'aVar:A';
		parseAndAddOp: 'aZeroArgOp : B';
		parseAndAddOp: 'aOneArgOp(A) : A';
		parseAndAddOp: 'aOneArgOp(B) : B';
		parseAndAddOp: 'aTwoArgOp(A, A) : A';
		parseAndAddOp: 'A[A] : A';
		parseAndAddOp: 'A[A,A] : A';
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

{ #category : #utility }
LbTermParserExamples >> specialOpTerm: aSymbol withArgs: anArray [
	^ self signature nonZeroArgTermNamed: (LbOperatorName fromInternalSymbol: aSymbol) withArgs: anArray
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
	^ {
		'"abc"' -> (self stringTerm: 'abc').
		'"123"' -> (self stringTerm: '123').
		'"äéα"' -> (self stringTerm: 'äéα').
		'""' -> (self stringTerm: '')
	} collect: [ :each |
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
LbTermParserExamples >> zeroArgTermParseFailures [
	<gtExample>
	| inputs |
	inputs := #('123' '"abc"' '2/3').
	inputs do: [ :each |
		self assertParseFailure: each rule: #zeroArgTerm ].
	^ inputs
]

{ #category : #example }
LbTermParserExamples >> zeroArgTerms [
	<gtExample>
	^ {
		'true' -> (self zeroArgTerm: #true).
		'false' -> (self zeroArgTerm: #false).
		'aZeroArgOp' -> (self zeroArgTerm: #aZeroArgOp).
		'aVar' -> (self zeroArgTerm: #aVar)
	} collect: [ :each |
		| result |
		result := self parse: each key rule: #zeroArgTerm.
		self assert: result equals: each value.
		result ]
]
