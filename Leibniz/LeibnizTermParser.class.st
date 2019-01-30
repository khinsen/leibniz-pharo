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
]

{ #category : #productions }
LeibnizTermParser >> identifier [
	^ (identifierCharacter , (#digit asParser / $. asParser / identifierCharacter) star) flatten

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

]

{ #category : #productions }
LeibnizTermParser >> rationalNumberTerm [
	^ ($- asParser optional , #digit asParser plus ,
			$/ asParser ,
			$0 asParser not , #digit asParser star) flatten 

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

]

{ #category : #productions }
LeibnizTermParser >> suffixBetween: leftDelimiter and: rightDelimiter withSymbol: opSymbol [
	^ leftDelimiter , (term separatedBy: $, asParser trim) , rightDelimiter
		==> [ :nodes | { opSymbol . (nodes second reject: [ :element | element = $,]) } ]
]

{ #category : #grammar }
LeibnizTermParser >> term [
	^ (nonInfixTerm separatedBy: (identifier trim))
		==> [ :nodes |
				| result |
				result := OrderedCollection new.
				nodes size > 1
					ifTrue: [ result add: (nodes at: 2) ].
				1 to: nodes size by: 2 do: [ :index | result add: (nodes at: index) ].
				2 to: nodes size - 1 by: 2 do:
					[ :index |
						(nodes at: index) = (nodes at: 2)
							ifFalse: [ result := PPFailure message: 'expected ', (nodes at: 2) asString, ' but got ', (nodes at: index) asString ] ].
				result ]

]

{ #category : #productions }
LeibnizTermParser >> zeroArgTerm [
	^ identifier

]
