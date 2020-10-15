"
!A term grammar subclass that generates terms

This is a subclass of ${class:name=LeibnizTermGrammar}$ that adds conversion of the parsed data to Leibniz terms for a given ${class:name=LbSignature}$ and optional additional variables as defined in rules (see ${class:name=LeibnizRuleParser}$). It returns an object from the ${class:name=LeibnizTerm}$ hierarchy corresponding to the input string, or a ${class:name=PP2Failure}$ object in case of failure.
"
Class {
	#name : #LeibnizTermParser,
	#superclass : #LeibnizTermGrammar,
	#instVars : [
		'signature',
		'extraVariables'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LeibnizTermParser class >> forSignature: aSignature [
	^ self forSignature: aSignature extraVariables: Dictionary new.

]

{ #category : #'instance creation' }
LeibnizTermParser class >> forSignature: aSignature extraVariables: aDictionary [
	| parser |
	parser := self newStartingAt: self startSymbol.
	parser setSignature: aSignature.
	parser setExtraVariables: aDictionary.
	^ parser
]

{ #category : #accessing }
LeibnizTermParser class >> ignoredNames [
	^ (super ignoredNames copyWith: #signature)
								 copyWith: #extraVariables
]

{ #category : #'error handling' }
LeibnizTermParser >> errorForOp: aSymbol withArity: anArity [
	| expr |
	anArity
		ifEmpty: [ expr := aSymbol asString ]
		ifNotEmpty: [ expr := aSymbol asString , '(' ,
										(', ' join: (anArity collect: [ :each | each asString ])) ,
										')' ].
	^ PP2Failure message: expr , ' not defined in signature'
]

{ #category : #accessing }
LeibnizTermParser >> extraVariables [
	^ extraVariables
]

{ #category : #productions }
LeibnizTermParser >> fpNumberTerm [
	^ super fpNumberTerm
		"Converting the string to a float requires some trickery:
		 - Pharo doesn't allow a dot followed by an exponent without any fractional part.
			Workaround: replace '.e' by '.0e'
		 - In Pharo, a number with an exponent but without a fractional part is an integer, not a float.
			Workaround: convert the converted string explicitly to a float."
		==> [ :value |
				(signature hasBuiltin: #fpNumbers)
					ifTrue: [ LeibnizFPNumberTerm value: (value copyReplaceAll: '.e' with: '.0e') asNumber asFloat
											 			  forSignature: signature ]
					ifFalse: [ PP2Failure message: 'Floating-point literals not allowd by signature' ] ]

]

{ #category : #productions }
LeibnizTermParser >> integerTerm [
	^ super integerTerm
		==> [ :value |
				(signature hasBuiltin: #integers)
					ifTrue: [ LeibnizIntegerTerm value: value asNumber forSignature: signature ]
					ifFalse: [ PP2Failure message: 'Integer literals not allowd by signature' ] ]
]

{ #category : #productions }
LeibnizTermParser >> nonInfixTerm [
	^ super nonInfixTerm
		==> [ :nodes | nodes second
							ifNil: [ nodes first ]
							ifNotNil: [ | symbol args |
											symbol := nodes second first.
											args := nodes second second.
											signature nonZeroArgTermNamed: symbol
														 withArgs: (args copyWithFirst: nodes first) ] ]

]

{ #category : #productions }
LeibnizTermParser >> prefixOpTerm [
	^ super prefixOpTerm
		==> [ :nodes |
				| symbol args |
				symbol := nodes first.
				args := (nodes at: 3) reject: [ :element | element = $,].
				signature nonZeroArgTermNamed: symbol
							 withArgs: args
							 onError: [ :opSymbol :arity |
											self errorForOp: opSymbol withArity: arity ] ]

]

{ #category : #productions }
LeibnizTermParser >> rationalNumberTerm [
	^ super rationalNumberTerm
		==> [ :value |
				(signature hasBuiltin: #rationalNumbers)
					ifTrue: [ LeibnizRationalNumberTerm value: (Fraction readFromString: value)
																  forSignature: signature ]
					ifFalse: [ PP2Failure message: 'Rational number literals not allowd by signature' ] ]
]

{ #category : #initialization }
LeibnizTermParser >> setExtraVariables: aDictionary [
	extraVariables := aDictionary
]

{ #category : #initialization }
LeibnizTermParser >> setSignature: aSignature [
	signature := aSignature.
	extraVariables := Dictionary new
]

{ #category : #accessing }
LeibnizTermParser >> signature [
	^ signature
]

{ #category : #productions }
LeibnizTermParser >> stringTerm [
	^ super stringTerm
		==> [ :value |
				(signature hasBuiltin: #strings)
					ifTrue: [ LeibnizStringTerm value: (value copyFrom: 2 to: value size - 1)
														 forSignature: signature ]
					ifFalse: [ PP2Failure message: 'String literals not allowd by signature' ] ]
]

{ #category : #productions }
LeibnizTermParser >> term [
	^ super term
		==> [ :nodes |
				nodes size = 1
					ifTrue: [ nodes first ]
					ifFalse: [ | opSymbol |
									opSymbol := ('_' , nodes first) asSymbol.
									(nodes allButFirst: 2)
										inject: nodes second
										into: [ :result :each |
													| args |
													args := { result . each }.
													signature nonZeroArgTermNamed: opSymbol
																 withArgs: args
																 onError: [ :symbol :arity |
																			 self errorForOp: symbol withArity: arity ] ] ] ]
]

{ #category : #productions }
LeibnizTermParser >> zeroArgTerm [
	^ super zeroArgTerm
		==> [ :name | signature zeroArgTermNamed: name asSymbol extraVariables: extraVariables
										onError: [ :symbol | self errorForOp: symbol withArity: #() ] ]
]
