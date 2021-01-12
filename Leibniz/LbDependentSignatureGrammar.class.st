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
		'forAll',
		'forAllClause',
		'sortArg',
		'varArg',
		'infixVarArg',
		'infixSortArg',
		'infixArg'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> arg [
	^ varArg / sortArg
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> bracketOp [
	^ arg, openBracket, (arg separatedBy: comma trim), closeBracket
]

{ #category : #'productions - tokens' }
LbDependentSignatureGrammar >> closeBrace [
	^ $} asPParser
]

{ #category : #'productions - tokens' }
LbDependentSignatureGrammar >> closeBracket [
	^ $] asPParser
]

{ #category : #'productions - tokens' }
LbDependentSignatureGrammar >> closeParenthesis [
	^ $) asPParser
]

{ #category : #'productions - tokens' }
LbDependentSignatureGrammar >> colon [
	^ $: asPParser
]

{ #category : #'productions - tokens' }
LbDependentSignatureGrammar >> comma [
	^ $, asPParser
]

{ #category : #'productions - tokens' }
LbDependentSignatureGrammar >> forAll [
	^ $∀ asPParser
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> forAllClause [
	^ forAll trim, identifier, colon, identifier
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> fpExponentPart [
	^ $e asPParser , fpIntegerPart
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> fpFractionalPart [
	^ $. asPParser , #digit asPParser plus optional
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> fpIntegerPart [
	^ $- asPParser optional , #digit asPParser plus
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> fpNumberTerm [
	^ ((fpIntegerPart , fpFractionalPart , fpExponentPart optional)
			/ (fpIntegerPart , fpExponentPart))
		flatten
]

{ #category : #'productions - tokens' }
LbDependentSignatureGrammar >> hat [
	^ $^ asPParser
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> infixArg [
	^ infixVarArg / infixSortArg
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> infixOp [
	^ infixArg trim, identifier trim, infixArg trim
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> infixSortArg [
	^ simpleTerm
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> infixVarArg [
	^ identifier, colon, simpleTerm
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> integerTerm [
	^ ($- asPParser optional , #digit asPParser plus) flatten
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> literalTerm [
	^ rationalNumberTerm / fpNumberTerm / integerTerm / stringTerm
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> nonInfixTerm [
	^ simpleTerm, suffix optional
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> op [
	^ forAllClause star, opAndArgs trim, colon, term trim
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> opAndArgs [
	^ prefixOp / bracketOp / infixOp / subscriptOp / superscriptOp / zeroArgOp
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> opEnd [
	^ op end
]

{ #category : #'productions - tokens' }
LbDependentSignatureGrammar >> openBrace [
	^ ${ asPParser
]

{ #category : #'productions - tokens' }
LbDependentSignatureGrammar >> openBracket [
	^ $[ asPParser
]

{ #category : #'productions - tokens' }
LbDependentSignatureGrammar >> openParenthesis [
	^ $( asPParser
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> parenthesizedTerm [
	^ openParenthesis , term, closeParenthesis
		==> [ :nodes | nodes second ]
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> prefixOp [
	^ identifier trim,
		openParenthesis,
		(arg separatedBy: comma trim),
		closeParenthesis
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> prefixOpTerm [
	^ identifier , openParenthesis ,
		 (term separatedBy: comma trim) ,
		 closeParenthesis
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> rationalNumberTerm [
	^ ($- asPParser optional , #digit asPParser plus ,
			$/ asPParser ,
			$0 asPParser not , #digit asPParser star) flatten 

]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> simpleTerm [
	^ literalTerm / parenthesizedTerm / prefixOpTerm / zeroArgTerm
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> sortArg [
	^ term
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> stringTerm [
	^ ($" asPParser , $" asPParser negate star , $" asPParser) flatten 

]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> subscriptOp [
	^ arg, underscore, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> suffix [
	^ (self suffixBetween: openBracket and: closeBracket withSymbol: #'[]')
		 / (self suffixBetween: '^{' asPParser and: closeBrace withSymbol: #'^')
		 / (self suffixBetween: '_{' asPParser and: closeBrace withSymbol: #'_')
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> suffixBetween: leftDelimiter and: rightDelimiter withSymbol: opSymbol [
	^ leftDelimiter , (term separatedBy: comma asPParser trim) , rightDelimiter
		==> [ :nodes | { opSymbol . (nodes second reject: [ :element | element = $, ]) } ]
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> superscriptOp [
	^ arg, hat, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : #'productions - term' }
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

{ #category : #'productions - tokens' }
LbDependentSignatureGrammar >> underscore [
	^ $_ asPParser
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> var [
	^ forAllClause star, identifier trim, colon, simpleTerm trim
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> varArg [
	^ identifier, colon, term
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> varEnd [
	^ var end
]

{ #category : #'productions - signature' }
LbDependentSignatureGrammar >> zeroArgOp [
	^ identifier
]

{ #category : #'productions - term' }
LbDependentSignatureGrammar >> zeroArgTerm [
	^ identifier
]
