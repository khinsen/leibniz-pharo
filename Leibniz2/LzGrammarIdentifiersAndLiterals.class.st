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
		'stringTerm',
		'decimalRationalNumberTerm',
		'fpNumber'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #literals }
LzGrammarIdentifiersAndLiterals >> decimalRationalNumberTerm [
	^ $# asPParser, fpNumber ==> [ :nodes | nodes second ]
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
LzGrammarIdentifiersAndLiterals >> fpNumber [
	^ ((fpIntegerPart , fpFractionalPart , fpExponentPart optional)
			/ (fpIntegerPart , fpExponentPart)) flatten
	 	"Pharo doesn't allow a dot followed by an exponent without any fractional part.
		  Workaround: replace '.e' by '.0e'"
		==> [ :value | value copyReplaceAll: '.e' with: '.0e' ]
]

{ #category : #literals }
LzGrammarIdentifiersAndLiterals >> fpNumberTerm [
	^ fpNumber
]

{ #category : #identifiers }
LzGrammarIdentifiersAndLiterals >> identifierCharacter [
	| predicate |
	predicate := PP2CharSetPredicate on:
		[ :char | char isLzIdentifierCharacter ].
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
				(LzConstants reservedIdentifiers includes: id)
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
		==> [ :value | value copyFrom: 2 to: value size - 1 ]
]

{ #category : #identifiers }
LzGrammarIdentifiersAndLiterals >> varIdentifier [
	^ (opIdentifier, $_ asPParser plus) flatten
		==> [ :id | id asSymbol ]
]
