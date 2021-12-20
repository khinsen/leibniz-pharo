Class {
	#name : #LzGrammarSignaturesAndTerms,
	#superclass : #LzGrammarIdentifiersAndLiterals,
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
		'sort',
		'subsort'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #signature }
LzGrammarSignaturesAndTerms >> arg [
	^ varArg / sortArg
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> bracketOp [
	^ arg, openBracket, (arg separatedBy: comma trim), closeBracket
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> forAllClause [
	^ forAll trim, identifier, colon, sort
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> infixArg [
	^ infixVarArg / infixSortArg
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> infixOp [
	^ infixArg trim, identifier trim, infixArg trim
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> infixSortArg [
	^ sort
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> infixVarArg [
	^ identifier, colon, sort
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> literalTerm [
	^ rationalNumberTerm / fpNumberTerm / integerTerm / stringTerm
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> nonInfixTerm [
	^ simpleTerm, suffix optional
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> op [
	^ forAllClause star, opAndArgs trim, colon, sort trim
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> opAndArgs [
	^ prefixOp / bracketOp / infixOp / subscriptOp / superscriptOp / zeroArgOp
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> opEnd [
	^ op end
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> parenthesizedTerm [
	^ openParenthesis , term, closeParenthesis
		==> [ :nodes | nodes second ]
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> pattern [
	^ forAllClause star, term trim
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> patternEnd [
	^ pattern end
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> prefixOp [
	^ identifier trim,
		openParenthesis,
		(arg separatedBy: comma trim),
		closeParenthesis
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> prefixOpTerm [
	^ identifier , openParenthesis ,
		 (term separatedBy: comma trim) ,
		 closeParenthesis
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> simpleTerm [
	^ literalTerm / parenthesizedTerm / prefixOpTerm / zeroArgTerm
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> sort [
	^ simpleTerm
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> sortArg [
	^ sort
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> sortOrSubsort [
	^ (subsort / sort) end 
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> subscriptOp [
	^ arg, underscore, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> subsort [
	^ sort trim, subsortSymbol, sort trim
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> suffix [
	^ (self suffixBetween: openBracket and: closeBracket withSymbol: #'[]')
		 / (self suffixBetween: '^{' asPParser and: closeBrace withSymbol: #'^')
		 / (self suffixBetween: '_{' asPParser and: closeBrace withSymbol: #'_')
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> suffixBetween: leftDelimiter and: rightDelimiter withSymbol: opSymbol [
	^ leftDelimiter , (term separatedBy: comma asPParser trim) , rightDelimiter
		==> [ :nodes | { opSymbol . (nodes second reject: [ :element | element = $, ]) } ]
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> superscriptOp [
	^ arg, hat, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> term [
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

{ #category : #terms }
LzGrammarSignaturesAndTerms >> termEnd [
	^ term end
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> var [
	^ forAllClause star, identifier trim, colon, sort trim
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> varArg [
	^ identifier, colon, sort
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> varEnd [
	^ var end
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> zeroArgOp [
	^ identifier
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> zeroArgTerm [
	^ identifier
]
