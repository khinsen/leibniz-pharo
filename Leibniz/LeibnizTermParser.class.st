"
I am a parser for Leibniz terms.
"
Class {
	#name : #LeibnizTermParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'integer',
		'rationalNumber',
		'atomic',
		'string',
		'fpNumber',
		'parenthesized',
		'zeroArgTerm',
		'term',
		'simple',
		'identifier',
		'identifierCharacter',
		'signature',
		'fpIntegerPart',
		'fpFractionalPart',
		'fpExponentPart'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #accessing }
LeibnizTermParser class >> ignoredNames [
	^ super ignoredNames copyWith: #signature

]

{ #category : #'instance creation' }
LeibnizTermParser class >> signature: aSignature [
	^self new
			setSignature: aSignature;
			yourself

]

{ #category : #productions }
LeibnizTermParser >> atomic [
	^ rationalNumber / fpNumber / integer / string
]

{ #category : #productions }
LeibnizTermParser >> fpExponentPart [
	^ $e asParser , fpIntegerPart
]

{ #category : #productions }
LeibnizTermParser >> fpFractionalPart [
	^ $. asParser , #digit asParser plus optional

]

{ #category : #productions }
LeibnizTermParser >> fpIntegerPart [
	^ $- asParser optional , #digit asParser plus

]

{ #category : #productions }
LeibnizTermParser >> fpNumber [
	^ ((fpIntegerPart , fpFractionalPart , fpExponentPart optional)
			/ (fpIntegerPart , fpExponentPart))
		flatten trim
		"Converting the string to a float requires some trickery:
		 - Pharo doesn't allow a dot followed by an exponent without any fractional part.
			Workaround: replace '.e' by '.0e'
		 - In Pharo, a number with an exponent but without a fractional part is an integer, not a float.
			Workaround: convert the converted string explicitly to a float."
		==> [ :value |
				LeibnizFPNumberTerm value: (value copyReplaceAll: '.e' with: '.0e') asNumber asFloat
										 forSignature: signature ]

]

{ #category : #productions }
LeibnizTermParser >> identifier [
	^ (identifierCharacter , (identifierCharacter / #digit asParser / $. asParser) plus) flatten

]

{ #category : #productions }
LeibnizTermParser >> identifierCharacter [
	^ #letter asParser
]

{ #category : #productions }
LeibnizTermParser >> integer [
	^ ($- asParser optional , #digit asParser plus) flatten trim 
		==> [ :value | LeibnizIntegerTerm value: value asNumber forSignature: signature ]
]

{ #category : #productions }
LeibnizTermParser >> parenthesized [
	^ $( asParser , term, $) asParser trim
		==> [ :nodes | nodes at: 2 ]
]

{ #category : #productions }
LeibnizTermParser >> rationalNumber [
	^ ($- asParser optional , #digit asParser plus , $/ asParser , #digit asParser plus) flatten trim 
		==> [ :value | LeibnizRationalNumberTerm value: (Fraction readFromString: value)
															 forSignature: signature ]
]

{ #category : #initialization }
LeibnizTermParser >> setSignature: aSignature [
	signature := aSignature
]

{ #category : #productions }
LeibnizTermParser >> simple [
	^ atomic / parenthesized / zeroArgTerm
]

{ #category : #productions }
LeibnizTermParser >> simpleOperator [
	^ identifier flatten trim
		==> [ :name | signature zeroArgOpOrVarNamed: name asSymbol ]
]

{ #category : #accessing }
LeibnizTermParser >> start [
	^ term end
]

{ #category : #productions }
LeibnizTermParser >> string [
	^ ($" asParser , $" asParser negate plus , $" asParser) flatten trim 
		==> [ :value | LeibnizStringTerm value: (value copyFrom: 2 to: value size - 1)
													forSignature: signature ]
]

{ #category : #productions }
LeibnizTermParser >> term [
	^ simple
]
