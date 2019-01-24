"
I am a parser for Leibniz terms.
"
Class {
	#name : #LeibnizTermParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'zeroArgTerm',
		'term',
		'identifier',
		'identifierCharacter',
		'signature',
		'fpIntegerPart',
		'fpFractionalPart',
		'fpExponentPart',
		'prefixOpTerm',
		'nonInfixTerm',
		'simpleTerm',
		'atomicTerm',
		'parenthesizedTerm',
		'rationalNumberTerm',
		'fpNumberTerm',
		'integerTerm',
		'stringTerm'
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
LeibnizTermParser >> atomicTerm [
	^ rationalNumberTerm / fpNumberTerm / integerTerm / stringTerm
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
LeibnizTermParser >> fpNumberTerm [
	^ ((fpIntegerPart , fpFractionalPart , fpExponentPart optional)
			/ (fpIntegerPart , fpExponentPart))
		flatten
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
	^ identifierCharacter , (identifierCharacter / #digit asParser / $. asParser) plus

]

{ #category : #productions }
LeibnizTermParser >> identifierCharacter [
	"TODO"
	^ #letter asParser
]

{ #category : #productions }
LeibnizTermParser >> integerTerm [
	^ ($- asParser optional , #digit asParser plus) flatten 
		==> [ :value | LeibnizIntegerTerm value: value asNumber forSignature: signature ]
]

{ #category : #productions }
LeibnizTermParser >> nonInfixTerm [
	^ simpleTerm ,
		((self suffixBetween: $[ asParser and: $] asParser withSymbol: #'[]')
		 / (self suffixBetween: '^{' asParser and: $} asParser withSymbol: #'^')
		 / (self suffixBetween: '_{' asParser and: $} asParser withSymbol: #'_')) optional
		==> [ :nodes | nodes second
							ifNil: [ nodes first ]
							ifNotNil: [ | symbol args |
											symbol := nodes second first.
											args := nodes second second.
											signature nonZeroArgTermNamed: symbol
														 withArgs: (args copyWithFirst: nodes first) ] ]

]

{ #category : #productions }
LeibnizTermParser >> parenthesizedTerm [
	^ $( asParser , term, $) asParser
		==> [ :nodes | nodes at: 2 ]
]

{ #category : #grammar }
LeibnizTermParser >> prefixOpTerm [
	^ identifier , $( asParser ,
	 (term separatedBy: $, asParser trim) ,
	 $) asParser
	==> [ :nodes |
			| symbol args |
			symbol := (String streamContents:
							[ :s | nodes first flattenOn: s]) asSymbol.
			args := (nodes at: 3) reject: [ :element | element = $,].
			signature nonZeroArgTermNamed: symbol withArgs: args ]

]

{ #category : #productions }
LeibnizTermParser >> rationalNumberTerm [
	^ ($- asParser optional , #digit asParser plus ,
			$/ asParser ,
			$0 asParser not , #digit asParser star) flatten 
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
LeibnizTermParser >> simpleTerm [
	^ atomicTerm / parenthesizedTerm / prefixOpTerm / zeroArgTerm
]

{ #category : #accessing }
LeibnizTermParser >> start [
	^ term end
]

{ #category : #productions }
LeibnizTermParser >> stringTerm [
	^ ($" asParser , $" asParser negate star , $" asParser) flatten 
		==> [ :value | LeibnizStringTerm value: (value copyFrom: 2 to: value size - 1)
													forSignature: signature ]
]

{ #category : #productions }
LeibnizTermParser >> suffixBetween: leftDelimiter and: rightDelimiter withSymbol: opSymbol [
	^ leftDelimiter , (term separatedBy: $, asParser trim) , rightDelimiter
		==> [ :nodes | { opSymbol . (nodes second reject: [ :element | element = $,]) } ]
]

{ #category : #productions }
LeibnizTermParser >> term [
	^ nonInfixTerm
]

{ #category : #productions }
LeibnizTermParser >> zeroArgTerm [
	^ identifier flatten
		==> [ :name | signature zeroArgTermNamed: name asSymbol ]
]
