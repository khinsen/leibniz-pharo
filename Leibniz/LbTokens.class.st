"
!The common grammar for all Leibniz syntax

!!Identifiers

The identifiers for sorts and operators live in separate namespaces but follow the same rules. The admissible characters are defined in ${method:name=LbGrammar>>#identifierCharacter|expanded=}$. All but the first character can also be digits or a dot. A small number of identifiers ('⇒' '→' '∀' '|' '⊆') are explicitly forbidden to avoid conflicts with other elements of Leibniz syntax.
"
Class {
	#name : 'LbTokens',
	#superclass : 'PP2CompositeNode',
	#instVars : [
		'identifier',
		'identifierCharacter',
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
		'subsortSymbol'
	],
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : 'tokens' }
LbTokens >> closeBrace [
	^ $} asPParser
]

{ #category : 'tokens' }
LbTokens >> closeBracket [
	^ $] asPParser
]

{ #category : 'tokens' }
LbTokens >> closeParenthesis [
	^ $) asPParser
]

{ #category : 'tokens' }
LbTokens >> colon [
	^ $: asPParser
]

{ #category : 'tokens' }
LbTokens >> comma [
	^ $, asPParser
]

{ #category : 'tokens' }
LbTokens >> forAll [
	^ $∀ asPParser
]

{ #category : 'tokens' }
LbTokens >> hat [
	^ $^ asPParser
]

{ #category : 'tokens' }
LbTokens >> openBrace [
	^ ${ asPParser
]

{ #category : 'tokens' }
LbTokens >> openBracket [
	^ $[ asPParser
]

{ #category : 'tokens' }
LbTokens >> openParenthesis [
	^ $( asPParser
]

{ #category : 'tokens' }
LbTokens >> subsortSymbol [
	^ $⊆ asPParser

]

{ #category : 'tokens' }
LbTokens >> underscore [
	^ $_ asPParser
]
