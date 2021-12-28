Class {
	#name : #LbGrammarSignaturesAndTerms,
	#superclass : #LbGrammarIdentifiersAndLiterals,
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
	#category : #'Leibniz-0-Infrastructure'
}

{ #category : #signature }
LbGrammarSignaturesAndTerms >> arg [
	^ varArg / sortArg
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> bracketOp [
	^ arg, openBracket, (arg separatedBy: comma trim), closeBracket
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> forAllClause [
	^ forAll trim, identifier, colon, sort
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> infixArg [
	^ infixVarArg / infixSortArg
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> infixOp [
	^ infixArg trim, identifier trim, infixArg trim
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> infixSortArg [
	^ sort
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> infixVarArg [
	^ identifier, colon, sort
]

{ #category : #terms }
LbGrammarSignaturesAndTerms >> literalTerm [
	^ rationalNumberTerm / fpNumberTerm / integerTerm / stringTerm
]

{ #category : #terms }
LbGrammarSignaturesAndTerms >> nonInfixTerm [
	^ simpleTerm, suffix optional
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> op [
	^ forAllClause star, opAndArgs trim, colon, sort trim
]

{ #category : #terms }
LbGrammarSignaturesAndTerms >> opAndArgs [
	^ prefixOp / bracketOp / infixOp / subscriptOp / superscriptOp / zeroArgOp
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> opEnd [
	^ op end
]

{ #category : #terms }
LbGrammarSignaturesAndTerms >> parenthesizedTerm [
	^ openParenthesis , term, closeParenthesis
		==> [ :nodes | nodes second ]
]

{ #category : #terms }
LbGrammarSignaturesAndTerms >> pattern [
	^ forAllClause star, term trim
]

{ #category : #terms }
LbGrammarSignaturesAndTerms >> patternEnd [
	^ pattern end
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> prefixOp [
	^ identifier trim,
		openParenthesis,
		(arg separatedBy: comma trim),
		closeParenthesis
]

{ #category : #terms }
LbGrammarSignaturesAndTerms >> prefixOpTerm [
	^ identifier , openParenthesis ,
		 (term separatedBy: comma trim) ,
		 closeParenthesis
]

{ #category : #terms }
LbGrammarSignaturesAndTerms >> simpleTerm [
	^ literalTerm / parenthesizedTerm / prefixOpTerm / zeroArgTerm
]

{ #category : #terms }
LbGrammarSignaturesAndTerms >> simpleTermEnd [
	^ simpleTerm end
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> sort [
	^ simpleTerm
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> sortArg [
	^ sort
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> sortOrSubsort [
	^ (subsort / sort) end 
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> subscriptOp [
	^ arg, underscore, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> subsort [
	^ sort trim, subsortSymbol, sort trim
]

{ #category : #terms }
LbGrammarSignaturesAndTerms >> suffix [
	^ (self suffixBetween: openBracket and: closeBracket withSymbol: #'[]')
		 / (self suffixBetween: '^{' asPParser and: closeBrace withSymbol: #'^')
		 / (self suffixBetween: '_{' asPParser and: closeBrace withSymbol: #'_')
]

{ #category : #terms }
LbGrammarSignaturesAndTerms >> suffixBetween: leftDelimiter and: rightDelimiter withSymbol: opSymbol [
	^ leftDelimiter , (term separatedBy: comma asPParser trim) , rightDelimiter
		==> [ :nodes | { opSymbol . (nodes second reject: [ :element | element = $, ]) } ]
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> superscriptOp [
	^ arg, hat, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : #terms }
LbGrammarSignaturesAndTerms >> term [
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
LbGrammarSignaturesAndTerms >> termEnd [
	^ term end
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> var [
	^ forAllClause star, identifier trim, colon, sort trim
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> varArg [
	^ identifier, colon, sort
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> varEnd [
	^ var end
]

{ #category : #signature }
LbGrammarSignaturesAndTerms >> zeroArgOp [
	^ identifier
]

{ #category : #terms }
LbGrammarSignaturesAndTerms >> zeroArgTerm [
	^ identifier
]
