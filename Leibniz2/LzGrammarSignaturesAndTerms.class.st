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
		'pattern',
		'varTerm',
		'sort',
		'arrayElements',
		'arrayTerm'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #signature }
LzGrammarSignaturesAndTerms >> arg [
	^ varArg / sortArg
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> arrayElements [
	^ openBracket trimRight,
		 ((arrayElements separatedBy: comma trim) / (term separatedBy: comma trim)) optional,
		 closeBracket trimLeft
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> arrayTerm [
	^ openBrace, arrayElements, closeBrace
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> bracketOp [
	^ arg, openBracket, (arg separatedBy: comma trim), closeBracket
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> forAllClause [
	^ (forAll trim, varIdentifier, colon, sort) / (varIdentifier, colon, sort, comma trim)
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> infixOp [
	^ arg trim, opIdentifier trim, arg trim
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> literalTerm [
	^ rationalNumberTerm / decimalRationalNumberTerm / fpNumberTerm / integerTerm / stringTerm
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> literalTermEnd [
	^ literalTerm end
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> nonInfixTerm [
	^ simpleTerm, suffix optional
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> op [
	^ forAllClause star, opAndArgs trim, colon, simpleTerm trim
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
	^ (forAllClause plus, simpleTerm trim) / term
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> patternEnd [
	^ pattern end
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> prefixOp [
	^ opIdentifier trim,
		openParenthesis,
		(arg separatedBy: comma trim),
		closeParenthesis
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> prefixOpTerm [
	^ opIdentifier , openParenthesis ,
		 (term separatedBy: comma trim) ,
		 closeParenthesis
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> simpleTerm [
	^ literalTerm / parenthesizedTerm / arrayTerm / varTerm / prefixOpTerm / zeroArgTerm
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> simpleTermEnd [
	^ simpleTerm end
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> sort [
	^ simpleTerm / (openParenthesis, term, closeParenthesis)
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> sortArg [
	^ simpleTerm
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> subscriptOp [
	^ arg, backslash, openParenthesis, (arg separatedBy: comma trim), closeParenthesis
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> suffix [
	^ (self
		suffixBetween: openBracket and: closeBracket
		withOpName: LzBracketOpName new)
		 / (self
		 	suffixBetween: '^(' asPParser and: closeParenthesis
		 	withOpName: LzSuperscriptOpName new)
		 / (self
		 	suffixBetween: '\(' asPParser and: closeParenthesis
		 	withOpName: LzSubscriptOpName new)
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> suffixBetween: leftDelimiter and: rightDelimiter withOpName: opName [
	^ leftDelimiter , (term separatedBy: comma asPParser trim) , rightDelimiter
		==> [ :nodes | { opName . (nodes second reject: [ :element | element = $, ]) } ]
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> superscriptOp [
	^ arg, hat, openParenthesis, (arg separatedBy: comma trim), closeParenthesis
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> term [
	^ (nonInfixTerm separatedBy: (opIdentifier trim))
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
	^ varIdentifier trim, colon, pattern trim
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> varArg [
	^ varIdentifier, colon, simpleTerm
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> varEnd [
	^ var end
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> varTerm [
	^ varIdentifier
]

{ #category : #signature }
LzGrammarSignaturesAndTerms >> zeroArgOp [
	^ opIdentifier
]

{ #category : #terms }
LzGrammarSignaturesAndTerms >> zeroArgTerm [
	^ opIdentifier
]
