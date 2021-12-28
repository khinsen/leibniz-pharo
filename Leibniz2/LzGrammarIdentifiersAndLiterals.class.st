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
			/ (fpIntegerPart , fpExponentPart)) flatten
		==> [ :value |
			"Converting the string to a float requires some trickery:
		 	- Pharo doesn't allow a dot followed by an exponent without any fractional part.
				Workaround: replace '.e' by '.0e'
		 	- In Pharo, a number with an exponent but without a fractional part is an integer, not a float.
				Workaround: convert the converted string explicitly to a float."
				LzLiteral new
					value: (value copyReplaceAll: '.e' with: '.0e') asNumber asFloat;
					type: #fpNumber ]
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
		==> [ :value |
				LzLiteral new
					value: value asNumber;
					type: #integer ]
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
		==> [ :value |
				LzLiteral new
					value: (Fraction readFromString: value);
					type: #rational ]
]

{ #category : #literals }
LzGrammarIdentifiersAndLiterals >> stringTerm [
	^ ($" asPParser , $" asPParser negate star , $" asPParser) flatten 
		==> [ :value |
				LzLiteral new
					value: (value copyFrom: 2 to: value size - 1);
					type: #string ]
]

{ #category : #identifiers }
LzGrammarIdentifiersAndLiterals >> varIdentifier [
	^ ($? asPParser, (#digit asPParser / $. asPParser / identifierCharacter) star) flatten
		==> [ :id | id asSymbol ]
]
