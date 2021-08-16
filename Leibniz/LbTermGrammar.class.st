"
!The grammar for the Leibniz term syntax

The overall goal of the Leibniz term syntax is to resemble both traditional mathematical notation and common programming languages while at the same time leaving a lot of freedom to context authors for designing suitable notation for their needs. The link to mathematical notation is mainly made by the liberal use of the mathematical symbols in Unicode.

!!Literal terms

Leibniz has a few built-in term types whose values are represented by literals, i.e. numbers and strings.

${method:name=LbTermGrammar>>#literalTerm|expanded=}$


!!!Integers

Integer syntax is perfectly standard: an optional minus sign followed by a string of digits.

${method:name=LbTermGrammar>>#integerTerm|expanded=}$


!!!Rational numbers

Fractions follow the same syntax as in Pharo: an integer followed by a slash following by a strictly positive integer.

${method:name=LbTermGrammar>>#rationalNumberTerm|expanded=}$

!!!Floating-point numbers

Floating-point numbers require more care because their syntax differs from Pharo's. In Leibniz, a number is floating-point if it has a fractional part, an exponent, or both. In Pharo, it's the fractional part that matters, an integer with an exponent remains an integer. Moreover, in Leibniz, but not in Pharo, the fractional part can be reduced to just a dot.

${method:name=LbTermGrammar>>#fpNumberTerm|expanded=}$

${method:name=LbTermGrammar>>#fpIntegerPart|expanded=}$

${method:name=LbTermGrammar>>#fpFractionalPart|expanded=}$

${method:name=LbTermGrammar>>#fpExponentPart|expanded=}$

!!!Strings

Strings are delimited by double quotes. There is no mechanism for having a double quote inside a string yet.

${method:name=LbTermGrammar>>#stringTerm|expanded=}$

!!Non-literal terms without arguments

These terms are plain identifiers, which can be resolved either to argument-free operators or to variables (this happens in ${class:name=LbTermParser}$).

${method:name=LbTermGrammar>>#zeroArgTerm|expanded=}$

${method:name=LbTermGrammar>>#identifier|expanded=}$

The rules for allowed characters in an identifiers are complex and may well change in the future. The overall idea is to be permissive but still avoid conflicts with other syntactical elements.

${method:name=LbTermGrammar>>#identifierCharacter|expanded=}$

!!Prefix operators

These operators implement the standard function syntax used both in mathematics and in programming languages.

${method:name=LbTermGrammar>>#prefixOpTerm|expanded=}$


!!Parenthesized expressions

Any valid expression in parenthesis is a valid term.

${method:name=LbTermGrammar>>#parenthesizedTerm|expanded=}$

!!Simple and non-infix terms

All terms listed up to here are so-called ""simple"" terms that can receive one of three suffixes to form the most general non-infix term.

${method:name=LbTermGrammar>>#simpleTerm|expanded=}$

${method:name=LbTermGrammar>>#nonInfixTerm|expanded=}$

The three suffixes are square brackets, superscript, and subscript.

${method:name=LbTermGrammar>>#suffixBetween:and:withSymbol:|expanded=}$

!!Infix operators

The most general term is a chain of infix operators combining non-infix terms. Leibniz has no precedence rules for infix operators, because there can be potentially many of them. A chain of infix operators is therefore allowed only if all the infix operators are the same. When mixing infix operators, parentheses must be used.

${method:name=LbTermGrammar>>#term|expanded=}$

"
Class {
	#name : 'LbTermGrammar',
	#superclass : 'LbGrammar',
	#instVars : [
		'zeroArgTerm',
		'term',
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
		'literalTerm',
		'suffix'
	],
	#category : 'Leibniz-3-Terms'
}

{ #category : 'productions' }
LbTermGrammar >> fpExponentPart [
	^ $e asPParser , fpIntegerPart
]

{ #category : 'productions' }
LbTermGrammar >> fpFractionalPart [
	^ $. asPParser , #digit asPParser plus optional

]

{ #category : 'productions' }
LbTermGrammar >> fpIntegerPart [
	^ $- asPParser optional , #digit asPParser plus

]

{ #category : 'productions' }
LbTermGrammar >> fpNumberTerm [
	^ ((fpIntegerPart , fpFractionalPart , fpExponentPart optional)
			/ (fpIntegerPart , fpExponentPart))
		flatten
]

{ #category : 'productions' }
LbTermGrammar >> integerTerm [
	^ ($- asPParser optional , #digit asPParser plus) flatten
]

{ #category : 'productions' }
LbTermGrammar >> literalTerm [
	^ rationalNumberTerm / fpNumberTerm / integerTerm / stringTerm
]

{ #category : 'productions' }
LbTermGrammar >> nonInfixTerm [
	^ simpleTerm, suffix optional

]

{ #category : 'productions' }
LbTermGrammar >> parenthesizedTerm [
	^ $( asPParser , term, $) asPParser
		==> [ :nodes | nodes at: 2 ]
]

{ #category : 'productions' }
LbTermGrammar >> prefixOpTerm [
	^ identifier , $( asPParser ,
		 (term separatedBy: $, asPParser trim) ,
		 $) asPParser

]

{ #category : 'productions' }
LbTermGrammar >> rationalNumberTerm [
	^ ($- asPParser optional , #digit asPParser plus ,
			$/ asPParser ,
			$0 asPParser not , #digit asPParser star) flatten 

]

{ #category : 'productions' }
LbTermGrammar >> simpleTerm [
	^ literalTerm / parenthesizedTerm / prefixOpTerm / zeroArgTerm
]

{ #category : 'accessing' }
LbTermGrammar >> start [
	^ term end
]

{ #category : 'productions' }
LbTermGrammar >> stringTerm [
	^ ($" asPParser , $" asPParser negate star , $" asPParser) flatten 

]

{ #category : 'productions' }
LbTermGrammar >> suffix [
	^ (self suffixBetween: $[ asPParser and: $] asPParser withSymbol: #'[]')
		 / (self suffixBetween: '^{' asPParser and: $} asPParser withSymbol: #'^')
		 / (self suffixBetween: '_{' asPParser and: $} asPParser withSymbol: #'_')

]

{ #category : 'productions' }
LbTermGrammar >> suffixBetween: leftDelimiter and: rightDelimiter withSymbol: opSymbol [
	^ leftDelimiter , (term separatedBy: $, asPParser trim) , rightDelimiter
		==> [ :nodes | { opSymbol . (nodes second reject: [ :element | element = $,]) } ]
]

{ #category : 'productions' }
LbTermGrammar >> term [
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
							ifFalse: [ result := PP2Failure message: 'expected ', (nodes at: 2) asString, ' but got ', (nodes at: index) asString ] ].
				result ]

]

{ #category : 'productions' }
LbTermGrammar >> zeroArgTerm [
	^ identifier

]
