Class {
	#name : #LbDependentSignatureParser,
	#superclass : #LbDependentSignatureGrammar,
	#instVars : [
		'extraVariables',
		'signature'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #accessing }
LbDependentSignatureParser class >> signature: aSignature extraVariables: aDictionary [
	| parser |
	parser := self newStartingAt: self startSymbol.
	parser signature: aSignature.
	parser extraVariables: aDictionary.
	^ parser
]

{ #category : #productions }
LbDependentSignatureParser >> bracketOp [
	^ super bracketOp
		==> [ :nodes |
				| args |
				args := OrderedCollection with: nodes first.
				args addAll: (nodes third reject: [ :element | element = $,]).
				{ LbBracketOperatorName new. args asArray } ]
]

{ #category : #'error handling' }
LbDependentSignatureParser >> errorForOp: anOpName withArity: anArity [
	^ PP2Failure message:
		(anOpName printStringForArity: anArity),
		' not defined in signature'
]

{ #category : #accessing }
LbDependentSignatureParser >> extraVariables [
	^ extraVariables
]

{ #category : #accessing }
LbDependentSignatureParser >> extraVariables: aDictionary [
	extraVariables := aDictionary
]

{ #category : #accessing }
LbDependentSignatureParser >> forAllClause [
	^ super forAllClause ==> [ :nodes |
		nodes second asSymbol asLbOperatorName -> (signature sortNamed: nodes fourth asSymbol) ]
]

{ #category : #productions }
LbDependentSignatureParser >> fpNumberTerm [
	^ super fpNumberTerm
		"Converting the string to a float requires some trickery:
		 - Pharo doesn't allow a dot followed by an exponent without any fractional part.
			Workaround: replace '.e' by '.0e'
		 - In Pharo, a number with an exponent but without a fractional part is an integer, not a float.
			Workaround: convert the converted string explicitly to a float."
		==> [ :value |
				(signature hasBuiltin: #fpNumbers)
					ifTrue: [ LbFPNumberTerm value: (value copyReplaceAll: '.e' with: '.0e') asNumber asFloat
											 			  signature: signature ]
					ifFalse: [ PP2Failure message: 'Floating-point literals not allowd by signature' ] ]

]

{ #category : #accessing }
LbDependentSignatureParser >> ignoredNames [
	^ (super ignoredNames
		copyWith: #signature)
		copyWith: #extraVariables
]

{ #category : #productions }
LbDependentSignatureParser >> infixOp [
	^ super infixOp
		==> [ :nodes | { LbInfixOperatorName for: nodes second. { nodes first. nodes third } } ]

]

{ #category : #productions }
LbDependentSignatureParser >> integerTerm [
	^ super integerTerm
		==> [ :value |
				(signature hasBuiltin: #integers)
					ifTrue: [ LbIntegerTerm value: value asNumber signature: signature ]
					ifFalse: [ PP2Failure message: 'Integer literals not allowd by signature' ] ]
]

{ #category : #productions }
LbDependentSignatureParser >> nonInfixTerm [
	^ super nonInfixTerm
		==> [ :nodes |
				nodes second
					ifNil: [ nodes first ]
					ifNotNil: [ | symbol args |
								symbol := nodes second first.
								args := nodes second second.
								signature
									nonZeroArgTermNamed: (LbOperatorName fromInternalSymbol: symbol)
									withArgs: (args copyWithFirst: nodes first) ] ]
]

{ #category : #productions }
LbDependentSignatureParser >> op [
	^ super op ==> [ :nodes |
		{ nodes second. nodes fourth first } ]
]

{ #category : #productions }
LbDependentSignatureParser >> opEnd [
	^ op end
]

{ #category : #productions }
LbDependentSignatureParser >> prefixOp [
	^ super prefixOp ==> [ :nodes |
		{
			LbPrefixOperatorName for: nodes first.
			nodes third reject: [ :element | element = $,]
		} ]
]

{ #category : #productions }
LbDependentSignatureParser >> prefixOpTerm [
	^ super prefixOpTerm ==> [ :nodes |
		| symbol args |
		symbol := nodes first.
		args := (nodes at: 3) reject: [ :element | element = $,].
		signature
			nonZeroArgTermNamed: (LbPrefixOperatorName for: symbol)
			withArgs: args
			onError: [ :opSymbol :arity |
				self errorForOp: opSymbol withArity: arity ] ]
]

{ #category : #productions }
LbDependentSignatureParser >> rationalNumberTerm [
	^ super rationalNumberTerm
		==> [ :value |
				(signature hasBuiltin: #rationalNumbers)
					ifTrue: [ LbRationalNumberTerm value: (Fraction readFromString: value)
																  signature: signature ]
					ifFalse: [ PP2Failure message: 'Rational number literals not allowd by signature' ] ]
]

{ #category : #accessing }
LbDependentSignatureParser >> signature [
	^ signature
]

{ #category : #accessing }
LbDependentSignatureParser >> signature: aSignature [
	signature := aSignature.
	extraVariables := Dictionary new
]

{ #category : #productions }
LbDependentSignatureParser >> sort [
	^ super sort
		==> [ :id | { id } ]

]

{ #category : #productions }
LbDependentSignatureParser >> stringTerm [
	^ super stringTerm
		==> [ :value |
				(signature hasBuiltin: #strings)
					ifTrue: [ LbStringTerm value: (value copyFrom: 2 to: value size - 1)
														 signature: signature ]
					ifFalse: [ PP2Failure message: 'String literals not allowd by signature' ] ]
]

{ #category : #productions }
LbDependentSignatureParser >> subscriptOp [
	^ super subscriptOp
		==> [ :nodes |
				| args |
				args := OrderedCollection with: nodes first.
				args addAll: (nodes fourth reject: [ :element | element = $,]).
				{ LbSubscriptOperatorName new. args asArray } ]
]

{ #category : #productions }
LbDependentSignatureParser >> superscriptOp [
	^ super superscriptOp
		==> [ :nodes |
				| args |
				args := OrderedCollection with: nodes first.
				args addAll: (nodes fourth reject: [ :element | element = $,]).
				{ LbSuperscriptOperatorName new. args asArray } ]
]

{ #category : #productions }
LbDependentSignatureParser >> term [
	^ super term
		==> [ :nodes |
				nodes size = 1
					ifTrue: [ nodes first ]
					ifFalse: [
						| opSymbol |
						opSymbol := nodes first asSymbol.
						(nodes allButFirst: 2)
							inject: nodes second
							into: [ :result :each |
								| args |
								args := { result . each }.
								signature
									nonZeroArgTermNamed: (LbInfixOperatorName for: opSymbol)
									withArgs: args
									onError: [ :opName :arity |
										self errorForOp: opName withArity: arity ] ] ] ]
]

{ #category : #productions }
LbDependentSignatureParser >> var [
	^ super var
		==> [ :nodes | { nodes first. nodes third } ]

]

{ #category : #accessing }
LbDependentSignatureParser >> varEnd [
	^ var end
]

{ #category : #productions }
LbDependentSignatureParser >> zeroArgOp [
	^ super zeroArgOp
		==> [ :idString | { LbPrefixOperatorName for: idString. #() } ]
]

{ #category : #productions }
LbDependentSignatureParser >> zeroArgTerm [
	^ super zeroArgTerm
		==> [ :symbol |
				signature
					zeroArgTermNamed: (LbPrefixOperatorName for: symbol)
					extraVariables: extraVariables
					onError: [ :opName | self errorForOp: opName withArity: #() ] ]
]
