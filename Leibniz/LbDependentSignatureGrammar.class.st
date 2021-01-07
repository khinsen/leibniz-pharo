Class {
	#name : #LbDependentSignatureGrammar,
	#superclass : #LbGrammar,
	#instVars : [
		'colon',
		'openParenthesis',
		'closeParenthesis',
		'comma',
		'op',
		'var',
		'arg',
		'opAndArgs',
		'prefixOp',
		'infixOp',
		'zeroArgOp',
		'bracketOp',
		'openBracket',
		'closeBracket',
		'underscore',
		'openBrace',
		'closeBrace',
		'subscriptOp',
		'hat',
		'superscriptOp',
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
		'suffix',
		'sort',
		'forAll',
		'forAllClause'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #productions }
LbDependentSignatureGrammar >> arg [
	^ var / sort
]

{ #category : #productions }
LbDependentSignatureGrammar >> bracketOp [
	^ arg, openBracket, (arg separatedBy: comma trim), closeBracket
]

{ #category : #productions }
LbDependentSignatureGrammar >> closeBrace [
	^ $} asPParser
]

{ #category : #productions }
LbDependentSignatureGrammar >> closeBracket [
	^ $] asPParser
]

{ #category : #productions }
LbDependentSignatureGrammar >> closeParenthesis [
	^ $) asPParser
]

{ #category : #productions }
LbDependentSignatureGrammar >> colon [
	^ $: asPParser

]

{ #category : #productions }
LbDependentSignatureGrammar >> comma [
	^ $, asPParser

]

{ #category : #productions }
LbDependentSignatureGrammar >> forAll [
	^ $∀ asPParser
]

{ #category : #productions }
LbDependentSignatureGrammar >> forAllClause [
	^ forAll trim, identifier, colon, identifier
]

{ #category : #productions }
LbDependentSignatureGrammar >> fpExponentPart [
	^ $e asPParser , fpIntegerPart
]

{ #category : #productions }
LbDependentSignatureGrammar >> fpFractionalPart [
	^ $. asPParser , #digit asPParser plus optional

]

{ #category : #productions }
LbDependentSignatureGrammar >> fpIntegerPart [
	^ $- asPParser optional , #digit asPParser plus

]

{ #category : #productions }
LbDependentSignatureGrammar >> fpNumberTerm [
	^ ((fpIntegerPart , fpFractionalPart , fpExponentPart optional)
			/ (fpIntegerPart , fpExponentPart))
		flatten
]

{ #category : #productions }
LbDependentSignatureGrammar >> hat [
	^ $^ asPParser

]

{ #category : #productions }
LbDependentSignatureGrammar >> infixOp [
	^ arg trim, identifier trim, arg trim
]

{ #category : #productions }
LbDependentSignatureGrammar >> integerTerm [
	^ ($- asPParser optional , #digit asPParser plus) flatten
]

{ #category : #productions }
LbDependentSignatureGrammar >> literalTerm [
	^ rationalNumberTerm / fpNumberTerm / integerTerm / stringTerm
]

{ #category : #productions }
LbDependentSignatureGrammar >> nonInfixTerm [
	^ simpleTerm, suffix optional
]

{ #category : #productions }
LbDependentSignatureGrammar >> op [
	^ forAllClause star, opAndArgs trim, colon, sort trim
]

{ #category : #productions }
LbDependentSignatureGrammar >> opAndArgs [
	^ prefixOp / bracketOp / infixOp / subscriptOp / superscriptOp / zeroArgOp
]

{ #category : #productions }
LbDependentSignatureGrammar >> openBrace [
	^ ${ asPParser

]

{ #category : #productions }
LbDependentSignatureGrammar >> openBracket [
	^ $[ asPParser

]

{ #category : #productions }
LbDependentSignatureGrammar >> openParenthesis [
	^ $( asPParser

]

{ #category : #productions }
LbDependentSignatureGrammar >> parenthesizedTerm [
	^ openParenthesis , term, closeParenthesis
		==> [ :nodes | nodes second ]
]

{ #category : #productions }
LbDependentSignatureGrammar >> prefixOp [
	^ identifier trim,
		openParenthesis,
		(arg separatedBy: comma trim),
		closeParenthesis
]

{ #category : #productions }
LbDependentSignatureGrammar >> prefixOpTerm [
	^ identifier , openParenthesis ,
		 (term separatedBy: comma trim) ,
		 closeParenthesis
]

{ #category : #productions }
LbDependentSignatureGrammar >> rationalNumberTerm [
	^ ($- asPParser optional , #digit asPParser plus ,
			$/ asPParser ,
			$0 asPParser not , #digit asPParser star) flatten 

]

{ #category : #productions }
LbDependentSignatureGrammar >> simpleTerm [
	^ literalTerm / parenthesizedTerm / prefixOpTerm / zeroArgTerm
]

{ #category : #accessing }
LbDependentSignatureGrammar >> sort [
	^ term
]

{ #category : #productions }
LbDependentSignatureGrammar >> stringTerm [
	^ ($" asPParser , $" asPParser negate star , $" asPParser) flatten 

]

{ #category : #productions }
LbDependentSignatureGrammar >> subscriptOp [
	^ arg, underscore, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : #productions }
LbDependentSignatureGrammar >> suffix [
	^ (self suffixBetween: openBracket and: closeBracket withSymbol: #'[]')
		 / (self suffixBetween: '^{' asPParser and: $} asPParser withSymbol: #'^')
		 / (self suffixBetween: '_{' asPParser and: $} asPParser withSymbol: #'_')

]

{ #category : #productions }
LbDependentSignatureGrammar >> suffixBetween: leftDelimiter and: rightDelimiter withSymbol: opSymbol [
	^ leftDelimiter , (term separatedBy: $, asPParser trim) , rightDelimiter
		==> [ :nodes | { opSymbol . (nodes second reject: [ :element | element = $,]) } ]
]

{ #category : #productions }
LbDependentSignatureGrammar >> superscriptOp [
	^ arg, hat, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : #productions }
LbDependentSignatureGrammar >> term [
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

{ #category : #productions }
LbDependentSignatureGrammar >> underscore [
	^ $_ asPParser

]

{ #category : #productions }
LbDependentSignatureGrammar >> var [
	^ identifier, colon, simpleTerm
]

{ #category : #productions }
LbDependentSignatureGrammar >> zeroArgOp [
	^ identifier
]

{ #category : #productions }
LbDependentSignatureGrammar >> zeroArgTerm [
	^ identifier
]
