"
!A parser for the Leibniz term syntax

The overall goal of the Leibniz term syntax is to resemble both traditional mathematical notation and common programming languages while at the same time leaving a lot of freedom to context authors for designing suitable notation for their needs. The link to mathematical notation is mainly made by the liberal use of the mathematical symbols in Unicode.

A parser stores a reference to a ${class:name=LeibnizSignature}$. It returns an object from the ${class:name=LeibnizTerm}$ hierarchy corresponding to the input string, or a ${class:name=PPFailure}$ object in case of failure.

!!Literal terms

Leibniz has a few built-in term types whose values are represented by literals, i.e. numbers and strings.

${method:name=LeibnizTermParser>>#literalTerm|expanded=}$


!!!Integers

Integer syntax is perfectly standard: an optional minus sign followed by a string of digits.

${method:name=LeibnizTermParser>>#integerTerm|expanded=}$


!!!Rational numbers

Fractions follow the same syntax as in Pharo: an integer followed by a slash following by a strictly positive integer.

${method:name=LeibnizTermParser>>#rationalNumberTerm|expanded=}$

!!!Floating-point numbers

Floating-point numbers require more care because their syntax differs from Pharo's. In Leibniz, a number is floating-point if it has a fractional part, an exponent, or both. In Pharo, it's the fractional part that matters, an integer with an exponent remains an integer. Moreover, in Leibniz, but not in Pharo, the fractional part can be reduced to just a dot.

${method:name=LeibnizTermParser>>#fpNumberTerm|expanded=}$

${method:name=LeibnizTermParser>>#fpIntegerPart|expanded=}$

${method:name=LeibnizTermParser>>#fpFractionalPart|expanded=}$

${method:name=LeibnizTermParser>>#fpExponentPart|expanded=}$

!!!Strings

Strings are delimited by double quotes. There is no mechanism for having a double quote inside a string yet.

${method:name=LeibnizTermParser>>#stringTerm|expanded=}$


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
		'parenthesizedTerm',
		'rationalNumberTerm',
		'fpNumberTerm',
		'integerTerm',
		'stringTerm',
		'literalTerm'
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
				(signature hasBuiltin: #fpNumbers)
					ifTrue: [ LeibnizFPNumberTerm value: (value copyReplaceAll: '.e' with: '.0e') asNumber asFloat
											 			  forSignature: signature ]
					ifFalse: [ PPFailure message: 'Floating-point literals not allowd by signature' ] ]

]

{ #category : #productions }
LeibnizTermParser >> identifier [
	^ identifierCharacter , (identifierCharacter / #digit asParser / $. asParser) plus

]

{ #category : #productions }
LeibnizTermParser >> identifierCharacter [
	| predicate |
	predicate := PPCharSetPredicate on:
		[ :char |
		char isLetter "Unicode categories Ll Lm Lo Lt Lu"
			or: [ char isLetterNumber "Unicode category Nl"
			or: [ ('-*/?' includes: char)
			or: [ (char isMathSymbol "Unicode category Sm"
						or: [ char isCurrencySymbol "Unicode category Sc"
						or: [ char isModifierSymbol "Unicode category Sk"
						or: [ char isOtherSymbol "Unicode category So" ] ] ])
					and: [ char ~= $^ ] ] ] ] ].
	^ PPPredicateObjectParser on: predicate message: 'Leibniz identifier character expected'

]

{ #category : #productions }
LeibnizTermParser >> integerTerm [
	^ ($- asParser optional , #digit asParser plus) flatten 
		==> [ :value |
				(signature hasBuiltin: #integers)
					ifTrue: [ LeibnizIntegerTerm value: value asNumber forSignature: signature ]
					ifFalse: [ PPFailure message: 'Integer literals not allowd by signature' ] ]
]

{ #category : #productions }
LeibnizTermParser >> literalTerm [
	^ rationalNumberTerm / fpNumberTerm / integerTerm / stringTerm
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
			signature nonZeroArgTermNamed: symbol
						 withArgs: args
						 onError: [ :opSymbol :arity |
										PPFailure message: symbol asString , '(' , arity asString ,
																	') not defined in signature' ] ]

]

{ #category : #productions }
LeibnizTermParser >> rationalNumberTerm [
	^ ($- asParser optional , #digit asParser plus ,
			$/ asParser ,
			$0 asParser not , #digit asParser star) flatten 
		==> [ :value |
				(signature hasBuiltin: #rationalNumbers)
					ifTrue: [ LeibnizRationalNumberTerm value: (Fraction readFromString: value)
																  forSignature: signature ]
					ifFalse: [ PPFailure message: 'Rational number literals not allowd by signature' ] ]
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
	^ literalTerm / parenthesizedTerm / prefixOpTerm / zeroArgTerm
]

{ #category : #accessing }
LeibnizTermParser >> start [
	^ term end
]

{ #category : #productions }
LeibnizTermParser >> stringTerm [
	^ ($" asParser , $" asParser negate star , $" asParser) flatten 
		==> [ :value |
				(signature hasBuiltin: #strings)
					ifTrue: [ LeibnizStringTerm value: (value copyFrom: 2 to: value size - 1)
														 forSignature: signature ]
					ifFalse: [ PPFailure message: 'String literals not allowd by signature' ] ]
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
		==> [ :name | signature zeroArgTermNamed: name asSymbol
										onError: [ :symbol | PPFailure message: symbol asString , ' undefined in signature' ] ]
]
