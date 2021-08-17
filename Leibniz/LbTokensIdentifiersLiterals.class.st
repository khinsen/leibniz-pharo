Class {
	#name : 'LbTokensIdentifiersLiterals',
	#superclass : 'LbTokens',
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : 'identifiers' }
LbTokensIdentifiersLiterals class >> reservedIdentifiers [
	| rewriteArrow functionArrow equalSign
	  forAllSymbol conditionSymbol subsortSymbol |
	rewriteArrow := '⇒'.
	functionArrow := '→'.
	equalSign := '='.
	forAllSymbol := '∀'.
	conditionSymbol := '|'.
	subsortSymbol := '⊆'.
	^ {
		rewriteArrow.
		functionArrow.
		equalSign.
		forAllSymbol.
		conditionSymbol.
		subsortSymbol
		}
]

{ #category : 'productions - identifiers' }
LbTokensIdentifiersLiterals >> identifier [
	^ (identifierCharacter , (#digit asPParser / $. asPParser / identifierCharacter) star) flatten
		==> [ :id |
				(LbTokensIdentifiersLiterals reservedIdentifiers includes: id)
					ifFalse: [ id asSymbol ]
					ifTrue: [ PP2Failure message: 'reserved identifier: ', id ] ]
]

{ #category : 'productions - identifiers' }
LbTokensIdentifiersLiterals >> identifierCharacter [
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
		yourself
]
