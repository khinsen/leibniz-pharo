Class {
	#name : #LbSignatureGrammar,
	#superclass : #LbSortGrammar,
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
LbSignatureGrammar >> arg [
	^ var / sort
]

{ #category : #productions }
LbSignatureGrammar >> bracketOp [
	^ arg, openBracket, (arg separatedBy: comma trim), closeBracket
]

{ #category : #productions }
LbSignatureGrammar >> closeBrace [
	^ $} asPParser
]

{ #category : #productions }
LbSignatureGrammar >> closeBracket [
	^ $] asPParser
]

{ #category : #productions }
LbSignatureGrammar >> closeParenthesis [
	^ $) asPParser
]

{ #category : #productions }
LbSignatureGrammar >> colon [
	^ $: asPParser

]

{ #category : #productions }
LbSignatureGrammar >> comma [
	^ $, asPParser

]

{ #category : #productions }
LbSignatureGrammar >> hat [
	^ $^ asPParser

]

{ #category : #productions }
LbSignatureGrammar >> infixOp [
	^ arg trim, identifier trim, arg trim
]

{ #category : #productions }
LbSignatureGrammar >> op [
	^ opAndArgs trim, colon, sort trim

]

{ #category : #productions }
LbSignatureGrammar >> opAndArgs [
	^ prefixOp / bracketOp / infixOp / subscriptOp / superscriptOp / zeroArgOp
]

{ #category : #productions }
LbSignatureGrammar >> openBrace [
	^ ${ asPParser

]

{ #category : #productions }
LbSignatureGrammar >> openBracket [
	^ $[ asPParser

]

{ #category : #productions }
LbSignatureGrammar >> openParenthesis [
	^ $( asPParser

]

{ #category : #productions }
LbSignatureGrammar >> prefixOp [
	^ identifier trim, openParenthesis, (arg separatedBy: comma trim), closeParenthesis
]

{ #category : #accessing }
LbSignatureGrammar >> start [
	^ op end
]

{ #category : #productions }
LbSignatureGrammar >> subscriptOp [
	^ arg, underscore, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : #productions }
LbSignatureGrammar >> superscriptOp [
	^ arg, hat, openBrace, (arg separatedBy: comma trim), closeBrace
]

{ #category : #productions }
LbSignatureGrammar >> underscore [
	^ $_ asPParser

]

{ #category : #productions }
LbSignatureGrammar >> var [
	^ identifier, colon, identifier

]

{ #category : #productions }
LbSignatureGrammar >> zeroArgOp [
	^ identifier
]
