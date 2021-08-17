Class {
	#name : 'LbGrammar2',
	#superclass : 'LbTokensIdentifiersLiterals',
	#instVars : [
		'op',
		'var',
		'arg',
		'opAndArgs',
		'prefixOp',
		'infixOp',
		'zeroArgOp',
		'bracketOp',
		'subscriptOp',
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
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : 'productions - signature' }
LbGrammar2 >> arg [
	^ varArg / sortArg
]

{ #category : 'productions - signature' }
LbGrammar2 >> bracketOp [
	^ arg, openBracket, (arg separatedBy: comma trim), closeBracket
]

{ #category : 'productions - signature' }
LbGrammar2 >> forAllClause [
	^ forAll trim, identifier, colon, identifier
]

{ #category : 'productions - term' }
LbGrammar2 >> fpExponentPart [
	^ $e asPParser , fpIntegerPart
]

{ #category : 'productions - term' }
LbGrammar2 >> fpFractionalPart [
	^ $. asPParser , #digit asPParser plus optional
]

{ #category : 'productions - term' }
LbGrammar2 >> fpIntegerPart [
	^ $- asPParser optional , #digit asPParser plus
]

{ #category : 'productions - term' }
LbGrammar2 >> fpNumberTerm [
	^ ((fpIntegerPart , fpFractionalPart , fpExponentPart optional)
			/ (fpIntegerPart , fpExponentPart))
		flatten
]

{ #category : 'productions - signature' }
LbGrammar2 >> infixArg [
	^ infixVarArg / infixSortArg
]

{ #category : 'productions - signature' }
LbGrammar2 >> infixOp [
	^ infixArg trim, identifier trim, infixArg trim
]

{ #category : 'productions - signature' }
LbGrammar2 >> infixSortArg [
	^ simpleTerm
]

{ #category : 'productions - signature' }
LbGrammar2 >> infixVarArg [
	^ identifier, colon, simpleTerm
]

{ #category : 'productions - term' }
LbGrammar2 >> integerTerm [
	^ ($- asPParser optional , #digit asPParser plus) flatten
]

{ #category : 'productions - term' }
LbGrammar2 >> literalTerm [
	^ rationalNumberTerm / fpNumberTerm / integerTerm / stringTerm
]

{ #category : 'productions - term' }
LbGrammar2 >> nonInfixTerm [
	^ simpleTerm, suffix optional
]

{ #category : 'productions - signature' }
LbGrammar2 >> op [
	^ forAllClause star, opAndArgs trim, colon, term trim
]

{ #category : 'productions - term' }
LbGrammar2 >> opAndArgs [
	^ prefixOp / bracketOp / infixOp / subscriptOp / superscriptOp / zeroArgOp
]

{ #category : 'productions - signature' }
LbGrammar2 >> opEnd [
	^ op end
]

{ #category : 'productions - term' }
LbGrammar2 >> parenthesizedTerm [
	^ openParenthesis , term, closeParenthesis
		==> [ :nodes | nodes second ]
]

{ #category : 'productions - signature' }
LbGrammar2 >> prefixOp [
	^ identifier trim,
		openParenthesis,
		(arg separatedBy: comma trim),
		closeParenthesis
]

{ #category : 'productions - term' }
LbGrammar2 >> prefixOpTerm [
	^ identifier , openParenthesis ,
		 (term separatedBy: comma trim) ,
		 closeParenthesis
]

{ #category : 'productions - term' }
LbGrammar2 >> rationalNumberTerm [
	^ ($- asPParser optional , #digit asPParser plus ,
			$/ asPParser ,
			$0 asPParser not , #digit asPParser star) flatten 

]

{ #category : 'productions - term' }
LbGrammar2 >> simpleTerm [
	^ literalTerm / parenthesizedTerm / prefixOpTerm / zeroArgTerm
]

{ #category : 'productions - signature' }
LbGrammar2 >> sortArg [
	^ term
]

{ #category : 'productions - term' }
LbGrammar2 >> stringTerm [
	^ ($" asPParser , $" asPParser negate star , $" asPParser) flatten 

]

{ #category : 'productions - signature' }
LbGrammar2 >> subscriptOp [
	^ arg, underscore, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : 'productions - term' }
LbGrammar2 >> suffix [
	^ (self suffixBetween: openBracket and: closeBracket withSymbol: #'[]')
		 / (self suffixBetween: '^{' asPParser and: closeBrace withSymbol: #'^')
		 / (self suffixBetween: '_{' asPParser and: closeBrace withSymbol: #'_')
]

{ #category : 'productions - term' }
LbGrammar2 >> suffixBetween: leftDelimiter and: rightDelimiter withSymbol: opSymbol [
	^ leftDelimiter , (term separatedBy: comma asPParser trim) , rightDelimiter
		==> [ :nodes | { opSymbol . (nodes second reject: [ :element | element = $, ]) } ]
]

{ #category : 'productions - signature' }
LbGrammar2 >> superscriptOp [
	^ arg, hat, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : 'productions - term' }
LbGrammar2 >> term [
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

{ #category : 'productions - signature' }
LbGrammar2 >> var [
	^ forAllClause star, identifier trim, colon, simpleTerm trim
]

{ #category : 'productions - signature' }
LbGrammar2 >> varArg [
	^ identifier, colon, term
]

{ #category : 'productions - signature' }
LbGrammar2 >> varEnd [
	^ var end
]

{ #category : 'productions - signature' }
LbGrammar2 >> zeroArgOp [
	^ identifier
]

{ #category : 'productions - term' }
LbGrammar2 >> zeroArgTerm [
	^ identifier
]
