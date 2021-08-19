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
		'infixArg',
		'pattern',
		'forAllClauseForTerms',
		'sort',
		'subsort'
	],
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : 'signature' }
LbGrammar2 >> arg [
	^ varArg / sortArg
]

{ #category : 'signature' }
LbGrammar2 >> bracketOp [
	^ arg, openBracket, (arg separatedBy: comma trim), closeBracket
]

{ #category : 'signature' }
LbGrammar2 >> forAllClause [
	^ forAll trim, identifier, colon, sort
]

{ #category : 'terms' }
LbGrammar2 >> forAllClauseForTerms [
	^ forAll trim, identifier, colon, identifier
]

{ #category : 'signature' }
LbGrammar2 >> infixArg [
	^ infixVarArg / infixSortArg
]

{ #category : 'signature' }
LbGrammar2 >> infixOp [
	^ infixArg trim, identifier trim, infixArg trim
]

{ #category : 'signature' }
LbGrammar2 >> infixSortArg [
	^ sort
]

{ #category : 'signature' }
LbGrammar2 >> infixVarArg [
	^ identifier, colon, sort
]

{ #category : 'terms' }
LbGrammar2 >> literalTerm [
	^ rationalNumberTerm / fpNumberTerm / integerTerm / stringTerm
]

{ #category : 'terms' }
LbGrammar2 >> nonInfixTerm [
	^ simpleTerm, suffix optional
]

{ #category : 'signature' }
LbGrammar2 >> op [
	^ forAllClause star, opAndArgs trim, colon, sort trim
]

{ #category : 'terms' }
LbGrammar2 >> opAndArgs [
	^ prefixOp / bracketOp / infixOp / subscriptOp / superscriptOp / zeroArgOp
]

{ #category : 'signature' }
LbGrammar2 >> opEnd [
	^ op end
]

{ #category : 'terms' }
LbGrammar2 >> parenthesizedTerm [
	^ openParenthesis , term, closeParenthesis
		==> [ :nodes | nodes second ]
]

{ #category : 'terms' }
LbGrammar2 >> pattern [
	^ forAllClauseForTerms star, term trim
]

{ #category : 'terms' }
LbGrammar2 >> patternEnd [
	^ pattern end
]

{ #category : 'signature' }
LbGrammar2 >> prefixOp [
	^ identifier trim,
		openParenthesis,
		(arg separatedBy: comma trim),
		closeParenthesis
]

{ #category : 'terms' }
LbGrammar2 >> prefixOpTerm [
	^ identifier , openParenthesis ,
		 (term separatedBy: comma trim) ,
		 closeParenthesis
]

{ #category : 'terms' }
LbGrammar2 >> simpleTerm [
	^ literalTerm / parenthesizedTerm / prefixOpTerm / zeroArgTerm
]

{ #category : 'signature' }
LbGrammar2 >> sort [
	^ identifier
]

{ #category : 'signature' }
LbGrammar2 >> sortArg [
	^ sort
]

{ #category : 'signature' }
LbGrammar2 >> sortOrSubsort [
	^ (subsort / sort) end 
]

{ #category : 'signature' }
LbGrammar2 >> subscriptOp [
	^ arg, underscore, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : 'signature' }
LbGrammar2 >> subsort [
	^ sort trim, subsortSymbol, sort trim
]

{ #category : 'terms' }
LbGrammar2 >> suffix [
	^ (self suffixBetween: openBracket and: closeBracket withSymbol: #'[]')
		 / (self suffixBetween: '^{' asPParser and: closeBrace withSymbol: #'^')
		 / (self suffixBetween: '_{' asPParser and: closeBrace withSymbol: #'_')
]

{ #category : 'terms' }
LbGrammar2 >> suffixBetween: leftDelimiter and: rightDelimiter withSymbol: opSymbol [
	^ leftDelimiter , (term separatedBy: comma asPParser trim) , rightDelimiter
		==> [ :nodes | { opSymbol . (nodes second reject: [ :element | element = $, ]) } ]
]

{ #category : 'signature' }
LbGrammar2 >> superscriptOp [
	^ arg, hat, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : 'terms' }
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

{ #category : 'terms' }
LbGrammar2 >> termEnd [
	^ term end
]

{ #category : 'signature' }
LbGrammar2 >> var [
	^ forAllClause star, identifier trim, colon, sort trim
]

{ #category : 'signature' }
LbGrammar2 >> varArg [
	^ identifier, colon, sort
]

{ #category : 'signature' }
LbGrammar2 >> varEnd [
	^ var end
]

{ #category : 'signature' }
LbGrammar2 >> zeroArgOp [
	^ identifier
]

{ #category : 'terms' }
LbGrammar2 >> zeroArgTerm [
	^ identifier
]
