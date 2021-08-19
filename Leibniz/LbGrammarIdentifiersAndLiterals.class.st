Class {
	#name : 'LbGrammarIdentifiersAndLiterals',
	#superclass : 'LbGrammarTokens',
	#instVars : [
		'fpIntegerPart',
		'fpFractionalPart',
		'fpExponentPart',
		'rationalNumberTerm',
		'fpNumberTerm',
		'integerTerm',
		'stringTerm'
	],
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : 'identifiers' }
LbGrammarIdentifiersAndLiterals class >> reservedIdentifiers [
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

{ #category : 'literals' }
LbGrammarIdentifiersAndLiterals >> fpExponentPart [
	^ $e asPParser , fpIntegerPart
]

{ #category : 'literals' }
LbGrammarIdentifiersAndLiterals >> fpFractionalPart [
	^ $. asPParser , #digit asPParser plus optional
]

{ #category : 'literals' }
LbGrammarIdentifiersAndLiterals >> fpIntegerPart [
	^ $- asPParser optional , #digit asPParser plus
]

{ #category : 'literals' }
LbGrammarIdentifiersAndLiterals >> fpNumberTerm [
	^ ((fpIntegerPart , fpFractionalPart , fpExponentPart optional)
			/ (fpIntegerPart , fpExponentPart))
		flatten
]

{ #category : 'identifiers' }
LbGrammarIdentifiersAndLiterals >> identifier [
	^ (identifierCharacter , (#digit asPParser / $. asPParser / identifierCharacter) star) flatten
		==> [ :id |
				(LbGrammarIdentifiersAndLiterals reservedIdentifiers includes: id)
					ifFalse: [ id asSymbol ]
					ifTrue: [ PP2Failure message: 'reserved identifier: ', id ] ]
]

{ #category : 'identifiers' }
LbGrammarIdentifiersAndLiterals >> identifierCharacter [
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

{ #category : 'literals' }
LbGrammarIdentifiersAndLiterals >> integerTerm [
	^ ($- asPParser optional , #digit asPParser plus) flatten
]

{ #category : 'literals' }
LbGrammarIdentifiersAndLiterals >> rationalNumberTerm [
	^ ($- asPParser optional , #digit asPParser plus ,
			$/ asPParser ,
			$0 asPParser not , #digit asPParser star) flatten 

]

{ #category : 'literals' }
LbGrammarIdentifiersAndLiterals >> stringTerm [
	^ ($" asPParser , $" asPParser negate star , $" asPParser) flatten 

]
