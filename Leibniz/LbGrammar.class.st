"
!The common grammar for all Leibniz syntax

!!Identifiers

The identifiers for sorts and operators live in separate namespaces but follow the same rules. The admissible characters are defined in ${method:name=LbGrammar>>#identifierCharacter|expanded=}$. All but the first character can also be digits or a dot. A small number of identifiers ('⇒' '→' '∀' '|' '⊆') are explicitly forbidden to avoid conflicts with other elements of Leibniz syntax.
"
Class {
	#name : #LbGrammar,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'identifier',
		'identifierCharacter'
	],
	#category : #'Leibniz-0-Infrastructure'
}

{ #category : #grammar }
LbGrammar class >> conditionSymbol [
	^ $|
]

{ #category : #grammar }
LbGrammar class >> equalSign [
	^ $=
]

{ #category : #grammar }
LbGrammar class >> forAllSymbol [
	^ $∀
]

{ #category : #grammar }
LbGrammar class >> functionArrow [
	^ $→
]

{ #category : #grammar }
LbGrammar class >> reservedIdentifiers [
	^ {
		self rewriteArrow asString.
		self functionArrow asString.
		self equalSign asString.
		self forAllSymbol asString.
		self conditionSymbol asString.
		self subsortSymbol asString
		}
]

{ #category : #grammar }
LbGrammar class >> rewriteArrow [
	^ $⇒
]

{ #category : #grammar }
LbGrammar class >> subsortSymbol [
	^ $⊆
]

{ #category : #productions }
LbGrammar >> identifier [
	^ (identifierCharacter , (#digit asPParser / $. asPParser / identifierCharacter) star) flatten
		==> [ :id |
				(LbGrammar reservedIdentifiers includes: id)
					ifFalse: [ id asSymbol ]
					ifTrue: [ PP2Failure message: 'reserved identifier: ', id ] ]
]

{ #category : #productions }
LbGrammar >> identifierCharacter [
	| predicate |
	predicate := PP2CharSetPredicate on:
		[ :char |
		char isLetter "Unicode categories Ll Lm Lo Lt Lu"
			or: [ char isLetterNumber "Unicode category Nl"
			or: [ ('-*/?☰' includes: char)
			or: [ (char isMathSymbol "Unicode category Sm"
						or: [ char isCurrencySymbol "Unicode category Sc"
						or: [ char isModifierSymbol "Unicode category Sk"
						or: [ char isOtherSymbol "Unicode category So" ] ] ])
					and: [ ('^' includes: char) not ] ] ] ] ].
	^ PP2PredicateObjectNode new
		predicate: predicate;
		predicateMessage: 'Leibniz identifier character expected';
		yourself.

]
