Class {
	#name : #LzGrammarIdentifiersAndLiterals,
	#superclass : #LzGrammarTokens,
	#instVars : [
		'identifierCharacter',
		'opIdentifier',
		'varIdentifier',
		'fpIntegerPart',
		'fpFractionalPart',
		'fpExponentPart',
		'rationalNumberTerm',
		'fpNumberTerm',
		'integerTerm',
		'stringTerm'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #identifiers }
LzGrammarIdentifiersAndLiterals class >> reservedIdentifiers [
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

{ #category : #literals }
LzGrammarIdentifiersAndLiterals >> fpExponentPart [
	^ $e asPParser , fpIntegerPart
]

{ #category : #literals }
LzGrammarIdentifiersAndLiterals >> fpFractionalPart [
	^ $. asPParser , #digit asPParser plus optional
]

{ #category : #literals }
LzGrammarIdentifiersAndLiterals >> fpIntegerPart [
	^ $- asPParser optional , #digit asPParser plus
]

{ #category : #literals }
LzGrammarIdentifiersAndLiterals >> fpNumberTerm [
	^ ((fpIntegerPart , fpFractionalPart , fpExponentPart optional)
			/ (fpIntegerPart , fpExponentPart))
		flatten
]

{ #category : #identifiers }
LzGrammarIdentifiersAndLiterals >> identifierCharacter [
	| predicate |
	predicate := PP2CharSetPredicate on:
		[ :char |
		char isLetter "Unicode categories Ll Lm Lo Lt Lu"
			or: [ char isLetterNumber "Unicode category Nl"
			or: [ ('-*/☰' includes: char)
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

{ #category : #literals }
LzGrammarIdentifiersAndLiterals >> integerTerm [
	^ ($- asPParser optional , #digit asPParser plus) flatten
]

{ #category : #identifiers }
LzGrammarIdentifiersAndLiterals >> opIdentifier [
	^ (identifierCharacter , (#digit asPParser / $. asPParser / identifierCharacter) star) flatten
		==> [ :id |
				(LbGrammarIdentifiersAndLiterals reservedIdentifiers includes: id)
					ifFalse: [ id asSymbol ]
					ifTrue: [ PP2Failure message: 'reserved identifier: ', id ] ]
]

{ #category : #literals }
LzGrammarIdentifiersAndLiterals >> rationalNumberTerm [
	^ ($- asPParser optional , #digit asPParser plus ,
			$/ asPParser ,
			$0 asPParser not , #digit asPParser star) flatten 

]

{ #category : #literals }
LzGrammarIdentifiersAndLiterals >> stringTerm [
	^ ($" asPParser , $" asPParser negate star , $" asPParser) flatten 

]

{ #category : #identifiers }
LzGrammarIdentifiersAndLiterals >> varIdentifier [
	^ ($? asPParser, (#digit asPParser / $. asPParser / identifierCharacter) star) flatten
		==> [ :id | id asSymbol ]
]
