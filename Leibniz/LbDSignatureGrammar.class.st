Class {
	#name : 'LbDSignatureGrammar',
	#superclass : 'LbGrammarIdentifiersAndLiterals',
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
		'prefixOpTerm',
		'nonInfixTerm',
		'simpleTerm',
		'parenthesizedTerm',
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
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : 'productions - signature' }
LbDSignatureGrammar >> arg [
	^ varArg / sortArg
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> bracketOp [
	^ arg, openBracket, (arg separatedBy: comma trim), closeBracket
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> forAllClause [
	^ forAll trim, identifier, colon, identifier
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> infixArg [
	^ infixVarArg / infixSortArg
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> infixOp [
	^ infixArg trim, identifier trim, infixArg trim
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> infixSortArg [
	^ simpleTerm
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> infixVarArg [
	^ identifier, colon, simpleTerm
]

{ #category : 'productions - term' }
LbDSignatureGrammar >> literalTerm [
	^ rationalNumberTerm / fpNumberTerm / integerTerm / stringTerm
]

{ #category : 'productions - term' }
LbDSignatureGrammar >> nonInfixTerm [
	^ simpleTerm, suffix optional
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> op [
	^ forAllClause star, opAndArgs trim, colon, term trim
]

{ #category : 'productions - term' }
LbDSignatureGrammar >> opAndArgs [
	^ prefixOp / bracketOp / infixOp / subscriptOp / superscriptOp / zeroArgOp
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> opEnd [
	^ op end
]

{ #category : 'productions - term' }
LbDSignatureGrammar >> parenthesizedTerm [
	^ openParenthesis , term, closeParenthesis
		==> [ :nodes | nodes second ]
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> prefixOp [
	^ identifier trim,
		openParenthesis,
		(arg separatedBy: comma trim),
		closeParenthesis
]

{ #category : 'productions - term' }
LbDSignatureGrammar >> prefixOpTerm [
	^ identifier , openParenthesis ,
		 (term separatedBy: comma trim) ,
		 closeParenthesis
]

{ #category : 'productions - term' }
LbDSignatureGrammar >> simpleTerm [
	^ literalTerm / parenthesizedTerm / prefixOpTerm / zeroArgTerm
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> sortArg [
	^ simpleTerm
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> subscriptOp [
	^ arg, underscore, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : 'productions - term' }
LbDSignatureGrammar >> suffix [
	^ (self suffixBetween: openBracket and: closeBracket withSymbol: #'[]')
		 / (self suffixBetween: '^{' asPParser and: closeBrace withSymbol: #'^')
		 / (self suffixBetween: '_{' asPParser and: closeBrace withSymbol: #'_')
]

{ #category : 'productions - term' }
LbDSignatureGrammar >> suffixBetween: leftDelimiter and: rightDelimiter withSymbol: opSymbol [
	^ leftDelimiter , (term separatedBy: comma asPParser trim) , rightDelimiter
		==> [ :nodes | { opSymbol . (nodes second reject: [ :element | element = $, ]) } ]
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> superscriptOp [
	^ arg, hat, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : 'productions - term' }
LbDSignatureGrammar >> term [
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
LbDSignatureGrammar >> var [
	^ forAllClause star, identifier trim, colon, simpleTerm trim
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> varArg [
	^ identifier, colon, term
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> varEnd [
	^ var end
]

{ #category : 'productions - signature' }
LbDSignatureGrammar >> zeroArgOp [
	^ identifier
]

{ #category : 'productions - term' }
LbDSignatureGrammar >> zeroArgTerm [
	^ identifier
]
