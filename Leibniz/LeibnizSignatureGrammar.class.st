Class {
	#name : #LeibnizSignatureGrammar,
	#superclass : #LeibnizSortGrammar,
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
		'superscriptOp'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #productions }
LeibnizSignatureGrammar >> arg [
	^ var / sort
]

{ #category : #productions }
LeibnizSignatureGrammar >> bracketOp [
	^ arg, openBracket, (arg separatedBy: comma trim), closeBracket
]

{ #category : #productions }
LeibnizSignatureGrammar >> closeBrace [
	^ $} asPParser
]

{ #category : #productions }
LeibnizSignatureGrammar >> closeBracket [
	^ $] asPParser
]

{ #category : #productions }
LeibnizSignatureGrammar >> closeParenthesis [
	^ $) asPParser
]

{ #category : #productions }
LeibnizSignatureGrammar >> colon [
	^ $: asPParser

]

{ #category : #productions }
LeibnizSignatureGrammar >> comma [
	^ $, asPParser

]

{ #category : #productions }
LeibnizSignatureGrammar >> hat [
	^ $^ asPParser

]

{ #category : #productions }
LeibnizSignatureGrammar >> infixOp [
	^ arg trim, identifier trim, arg trim
]

{ #category : #productions }
LeibnizSignatureGrammar >> op [
	^ opAndArgs trim, colon, sort trim

]

{ #category : #productions }
LeibnizSignatureGrammar >> opAndArgs [
	^ prefixOp / bracketOp / infixOp / subscriptOp / superscriptOp / zeroArgOp
]

{ #category : #productions }
LeibnizSignatureGrammar >> openBrace [
	^ ${ asPParser

]

{ #category : #productions }
LeibnizSignatureGrammar >> openBracket [
	^ $[ asPParser

]

{ #category : #productions }
LeibnizSignatureGrammar >> openParenthesis [
	^ $( asPParser

]

{ #category : #productions }
LeibnizSignatureGrammar >> prefixOp [
	^ identifier trim, openParenthesis, (arg separatedBy: comma trim), closeParenthesis
]

{ #category : #accessing }
LeibnizSignatureGrammar >> start [
	^ op end
]

{ #category : #productions }
LeibnizSignatureGrammar >> subscriptOp [
	^ arg, underscore, openBrace, arg, closeBrace
]

{ #category : #productions }
LeibnizSignatureGrammar >> superscriptOp [
	^ arg, hat, openBrace, arg, closeBrace
]

{ #category : #productions }
LeibnizSignatureGrammar >> underscore [
	^ $_ asPParser

]

{ #category : #productions }
LeibnizSignatureGrammar >> var [
	^ identifier, colon, identifier

]

{ #category : #productions }
LeibnizSignatureGrammar >> zeroArgOp [
	^ identifier
]
