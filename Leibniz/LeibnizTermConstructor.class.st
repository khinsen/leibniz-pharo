Class {
	#name : #LeibnizTermConstructor,
	#superclass : #LeibnizTermParser,
	#instVars : [
		'signature'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #accessing }
LeibnizTermConstructor class >> ignoredNames [
	^ super ignoredNames copyWith: #signature

]

{ #category : #'error handling' }
LeibnizTermConstructor >> errorForOp: aSymbol withArity: anArity [
	| expr |
	anArity
		ifEmpty: [ expr := aSymbol asString ]
		ifNotEmpty: [ expr := aSymbol asString , '(' ,
										(', ' join: (anArity collect: [ :each | each asString ])) ,
										')' ].
	^ PP2Failure message: expr , ' not defined in signature'
]

{ #category : #productions }
LeibnizTermConstructor >> fpNumberTerm [
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
LeibnizTermConstructor >> integerTerm [
	^ super integerTerm
		==> [ :value |
				(signature hasBuiltin: #integers)
					ifTrue: [ LeibnizIntegerTerm value: value asNumber forSignature: signature ]
					ifFalse: [ PP2Failure message: 'Integer literals not allowd by signature' ] ]
]

{ #category : #productions }
LeibnizTermConstructor >> nonInfixTerm [
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
LeibnizTermConstructor >> prefixOpTerm [
	^ super prefixOpTerm
		==> [ :nodes |
				| symbol args |
				symbol := nodes first asSymbol.
				args := (nodes at: 3) reject: [ :element | element = $,].
				signature nonZeroArgTermNamed: symbol
							 withArgs: args
							 onError: [ :opSymbol :arity |
											self errorForOp: opSymbol withArity: arity ] ]

]

{ #category : #productions }
LeibnizTermConstructor >> rationalNumberTerm [
	^ super rationalNumberTerm
		==> [ :value |
				(signature hasBuiltin: #rationalNumbers)
					ifTrue: [ LeibnizRationalNumberTerm value: (Fraction readFromString: value)
																  forSignature: signature ]
					ifFalse: [ PP2Failure message: 'Rational number literals not allowd by signature' ] ]
]

{ #category : #initialization }
LeibnizTermConstructor >> setSignature: aSignature [
	signature := aSignature
]

{ #category : #accessing }
LeibnizTermConstructor >> signature [
	^ signature
]

{ #category : #productions }
LeibnizTermConstructor >> stringTerm [
	^ super stringTerm
		==> [ :value |
				(signature hasBuiltin: #strings)
					ifTrue: [ LeibnizStringTerm value: (value copyFrom: 2 to: value size - 1)
														 forSignature: signature ]
					ifFalse: [ PP2Failure message: 'String literals not allowd by signature' ] ]
]

{ #category : #productions }
LeibnizTermConstructor >> term [
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
LeibnizTermConstructor >> zeroArgTerm [
	^ super zeroArgTerm
		==> [ :name | signature zeroArgTermNamed: name asSymbol
										onError: [ :symbol | self errorForOp: symbol withArity: #() ] ]
]
