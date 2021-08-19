"
!The common grammar for all Leibniz syntax

!!Identifiers

The identifiers for sorts and operators live in separate namespaces but follow the same rules. The admissible characters are defined in ${method:name=LbGrammar>>#identifierCharacter|expanded=}$. All but the first character can also be digits or a dot. A small number of identifiers ('⇒' '→' '∀' '|' '⊆') are explicitly forbidden to avoid conflicts with other elements of Leibniz syntax.
"
Class {
	#name : 'LbGrammarTokens',
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
		'subsortSymbol',
		'conditionSymbol',
		'equalSign',
		'rewriteArrow',
		'fnArrow'
	],
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : 'tokens' }
LbGrammarTokens >> closeBrace [
	^ $} asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> closeBracket [
	^ $] asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> closeParenthesis [
	^ $) asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> colon [
	^ $: asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> comma [
	^ $, asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> conditionSymbol [
	^ $| asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> equalSign [
	^ $= asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> fnArrow [
	^ $→ asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> forAll [
	^ $∀ asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> hat [
	^ $^ asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> openBrace [
	^ ${ asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> openBracket [
	^ $[ asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> openParenthesis [
	^ $( asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> rewriteArrow [
	^ $⇒ asPParser
]

{ #category : 'tokens' }
LbGrammarTokens >> subsortSymbol [
	^ $⊆ asPParser

]

{ #category : 'tokens' }
LbGrammarTokens >> underscore [
	^ $_ asPParser
]
