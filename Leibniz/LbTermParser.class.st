"
!A term grammar subclass that generates terms

This is a subclass of ${class:name=LbTermGrammar}$ that adds conversion of the parsed data to Leibniz terms for a given ${class:name=LbSignature}$ and optional additional variables as defined in rules (see ${class:name=LbRuleParser}$). It returns an object from the ${class:name=LbTerm}$ hierarchy corresponding to the input string, or a ${class:name=PP2Failure}$ object in case of failure.
"
Class {
	#name : 'LbTermParser',
	#superclass : 'LbTermGrammar',
	#instVars : [
		'signature',
		'extraVariables'
	],
	#category : 'Leibniz-3-Terms'
}

{ #category : 'accessing' }
LbTermParser class >> ignoredNames [
	^ (super ignoredNames copyWith: #signature)
								 copyWith: #extraVariables
]

{ #category : 'instance creation' }
LbTermParser class >> signature: aSignature [
	^ self signature: aSignature extraVariables: Dictionary new
]

{ #category : 'instance creation' }
LbTermParser class >> signature: aSignature extraVariables: aDictionary [
	| parser |
	parser := self newStartingAt: self startSymbol.
	parser signature: aSignature.
	parser extraVariables: aDictionary.
	^ parser
]

{ #category : 'error handling' }
LbTermParser >> errorForOp: anOpName withArity: anArity [
	^ PP2Failure message:
		(anOpName printStringForArity: anArity),
		' not defined in signature'
]

{ #category : 'accessing' }
LbTermParser >> extraVariables [
	^ extraVariables
]

{ #category : 'initialization' }
LbTermParser >> extraVariables: aDictionary [
	extraVariables := aDictionary
]

{ #category : 'productions' }
LbTermParser >> fpNumberTerm [
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

{ #category : 'productions' }
LbTermParser >> integerTerm [
	^ super integerTerm
		==> [ :value |
				(signature hasBuiltin: #integers)
					ifTrue: [ LbIntegerTerm value: value asNumber signature: signature ]
					ifFalse: [ PP2Failure message: 'Integer literals not allowd by signature' ] ]
]

{ #category : 'productions' }
LbTermParser >> nonInfixTerm [
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

{ #category : 'productions' }
LbTermParser >> prefixOpTerm [
	^ super prefixOpTerm
		==> [ :nodes |
				| symbol args |
				symbol := nodes first.
				args := (nodes at: 3) reject: [ :element | element = $,].
				signature
					nonZeroArgTermNamed: (LbPrefixOperatorName for: symbol)
					withArgs: args
					onError: [ :opSymbol :arity |
						self errorForOp: opSymbol withArity: arity ] ]
]

{ #category : 'productions' }
LbTermParser >> rationalNumberTerm [
	^ super rationalNumberTerm
		==> [ :value |
				(signature hasBuiltin: #rationalNumbers)
					ifTrue: [ LbRationalNumberTerm value: (Fraction readFromString: value)
																  signature: signature ]
					ifFalse: [ PP2Failure message: 'Rational number literals not allowd by signature' ] ]
]

{ #category : 'accessing' }
LbTermParser >> signature [
	^ signature
]

{ #category : 'initialization' }
LbTermParser >> signature: aSignature [
	signature := aSignature.
	extraVariables := Dictionary new
]

{ #category : 'productions' }
LbTermParser >> stringTerm [
	^ super stringTerm
		==> [ :value |
				(signature hasBuiltin: #strings)
					ifTrue: [ LbStringTerm value: (value copyFrom: 2 to: value size - 1)
														 signature: signature ]
					ifFalse: [ PP2Failure message: 'String literals not allowd by signature' ] ]
]

{ #category : 'productions' }
LbTermParser >> term [
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

{ #category : 'productions' }
LbTermParser >> zeroArgTerm [
	^ super zeroArgTerm
		==> [ :symbol |
				signature
					zeroArgTermNamed: (LbPrefixOperatorName for: symbol)
					extraVariables: extraVariables
					onError: [ :opName | self errorForOp: opName withArity: #() ] ]
]
