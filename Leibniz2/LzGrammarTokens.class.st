Class {
	#name : #LzGrammarTokens,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'colon',
		'openParenthesis',
		'closeParenthesis',
		'comma',
		'openBracket',
		'closeBracket',
		'underscore',
		'openBrace',
		'closeBrace',
		'hat',
		'subsortSymbol',
		'conditionSymbol',
		'equalSign',
		'rewriteArrow',
		'fnArrow',
		'backslash'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #tokens }
LzGrammarTokens >> backslash [
	^ $\ asPParser
]

{ #category : #tokens }
LzGrammarTokens >> closeBrace [
	^ $} asPParser
]

{ #category : #tokens }
LzGrammarTokens >> closeBracket [
	^ $] asPParser
]

{ #category : #tokens }
LzGrammarTokens >> closeParenthesis [
	^ $) asPParser
]

{ #category : #tokens }
LzGrammarTokens >> colon [
	^ $: asPParser
]

{ #category : #tokens }
LzGrammarTokens >> comma [
	^ $, asPParser
]

{ #category : #tokens }
LzGrammarTokens >> conditionSymbol [
	^ $| asPParser
]

{ #category : #tokens }
LzGrammarTokens >> equalSign [
	^ $= asPParser
]

{ #category : #tokens }
LzGrammarTokens >> fnArrow [
	^ $→ asPParser
]

{ #category : #tokens }
LzGrammarTokens >> forAll [
	^ $∀ asPParser
]

{ #category : #tokens }
LzGrammarTokens >> hat [
	^ $^ asPParser
]

{ #category : #tokens }
LzGrammarTokens >> openBrace [
	^ ${ asPParser
]

{ #category : #tokens }
LzGrammarTokens >> openBracket [
	^ $[ asPParser
]

{ #category : #tokens }
LzGrammarTokens >> openParenthesis [
	^ $( asPParser
]

{ #category : #tokens }
LzGrammarTokens >> rewriteArrow [
	^ $⇒ asPParser
]

{ #category : #tokens }
LzGrammarTokens >> subsortSymbol [
	^ $⊆ asPParser

]

{ #category : #tokens }
LzGrammarTokens >> underscore [
	^ $_ asPParser
]
