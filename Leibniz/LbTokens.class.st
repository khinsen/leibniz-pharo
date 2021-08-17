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
		'hat'
	],
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : 'productions - tokens' }
LbTokens >> closeBrace [
	^ $} asPParser
]

{ #category : 'productions - tokens' }
LbTokens >> closeBracket [
	^ $] asPParser
]

{ #category : 'productions - tokens' }
LbTokens >> closeParenthesis [
	^ $) asPParser
]

{ #category : 'productions - tokens' }
LbTokens >> colon [
	^ $: asPParser
]

{ #category : 'productions - tokens' }
LbTokens >> comma [
	^ $, asPParser
]

{ #category : 'productions - tokens' }
LbTokens >> forAll [
	^ $∀ asPParser
]

{ #category : 'grammar' }
LbTokens >> hat [
	^ $^ asPParser
]

{ #category : 'productions - tokens' }
LbTokens >> openBrace [
	^ ${ asPParser
]

{ #category : 'productions - tokens' }
LbTokens >> openBracket [
	^ $[ asPParser
]

{ #category : 'productions - tokens' }
LbTokens >> openParenthesis [
	^ $( asPParser
]

{ #category : 'productions - tokens' }
LbTokens >> underscore [
	^ $_ asPParser
]
