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
		'fpExponentPart',
		'prefixOpTerm'
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
	^ (identifierCharacter , (identifierCharacter / #digit asParser / $. asParser) plus)

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

{ #category : #grammar }
LeibnizTermParser >> prefixOpTerm [
	^ identifier , $( asParser ,
	 (term separatedBy: $, asParser trim) optional ,
	 $) asParser
	==> [ :nodes |
			| symbol args |
			symbol := (String streamContents:
							[ :s | nodes first flattenOn: s]) asSymbol.
			args := (nodes at: 3) reject: [ :element | element = $,].
			signature nonZeroArgTermNamed: symbol withArgs: args ]

]

{ #category : #productions }
LeibnizTermParser >> rationalNumber [
	^ ($- asParser optional , #digit asParser plus ,
			$/ asParser ,
			$0 asParser not , #digit asParser star) flatten trim 
		==> [ :value | LeibnizRationalNumberTerm value: (Fraction readFromString: value)
															 forSignature: signature ]
]

{ #category : #initialization }
LeibnizTermParser >> setSignature: aSignature [
	signature := aSignature
]

{ #category : #accessing }
LeibnizTermParser >> signature [
	^ signature
]

{ #category : #productions }
LeibnizTermParser >> simple [
	^ atomic / parenthesized / prefixOpTerm / zeroArgTerm
]

{ #category : #accessing }
LeibnizTermParser >> start [
	^ term end
]

{ #category : #productions }
LeibnizTermParser >> string [
	^ ($" asParser , $" asParser negate star , $" asParser) flatten trim 
		==> [ :value | LeibnizStringTerm value: (value copyFrom: 2 to: value size - 1)
													forSignature: signature ]
]

{ #category : #productions }
LeibnizTermParser >> term [
	^ simple
]

{ #category : #productions }
LeibnizTermParser >> zeroArgTerm [
	^ identifier flatten trim
		==> [ :name | signature zeroArgTermNamed: name asSymbol ]
]
