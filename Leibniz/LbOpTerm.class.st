"
I represent a standard Leibniz term defined by a operator and its arguments.
"
Class {
	#name : #LbOpTerm,
	#superclass : #LbTerm,
	#instVars : [
		'sort',
		'opName',
		'arguments'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LbOpTerm class >> symbol: aSymbol args: anArgList sort: aSort forSignature: aSignature [
	^self basicNew
			initializeWithSymbol: aSymbol args: anArgList sort: aSort forSignature: aSignature;
			yourself.
]

{ #category : #accessing }
LbOpTerm >> arguments [
	^ arguments
]

{ #category : #converting }
LbOpTerm >> convertToSignature: aSignature extraVariables: aDictionary [
	^ arguments
		ifEmpty:
			[ aSignature zeroArgTermNamed: opName extraVariables: aDictionary ]
		ifNotEmpty:
			[ aSignature nonZeroArgTermNamed: opName
							 withArgs: (arguments collect:
								[ :each | each convertToSignature: aSignature  extraVariables: aDictionary]) ]

]

{ #category : #inspecting }
LbOpTerm >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Tree' translated;
		priority: 0;
		items: [ { self } ];
		column: 'Term' item: [ :each |
			each opName synopsis ];
		column: 'Sort' item: [ :each |
			each sort asLeibnizSyntaxString ];
		children: #arguments;
		expandAll;
		yourself
]

{ #category : #private }
LbOpTerm >> hasInfixOpOtherThan: aSymbol [
	"Not the same op."
	aSymbol = opName
		ifTrue: [ ^ false ].
	"Not an infix op."
	opName asString first = $_
		ifFalse: [ ^ false ].
	^ true
]

{ #category : #initialization }
LbOpTerm >> initializeWithSymbol: aSymbol args: anArgList sort: aSort forSignature: aSignature [
	opName := aSymbol.
	arguments := anArgList.
	sort := aSort.
	signature := aSignature.
]

{ #category : #testing }
LbOpTerm >> isEqualityTerm [
	opName = #'_==' ifFalse: [ ^ nil ].
	arguments size == 2 ifFalse: [ ^ nil ].
	sort = #boolean ifFalse: [ ^ nil ].
	^ arguments first = arguments second
]

{ #category : #testing }
LbOpTerm >> isInfix [
	"Answer true if the term is printed in infix notation."
	| opString |
	opString := opName asString.
	^ opString size > 1 and: [ opString first = $_ ]
]

{ #category : #testing }
LbOpTerm >> isTrue [
	^ (sort = #boolean)
		and: [ (opName = #true)
		and: [ arguments isEmpty ] ]
]

{ #category : #matching }
LbOpTerm >> match: otherTerm [
	^otherTerm matchOp: opName andArgs: arguments

]

{ #category : #matching }
LbOpTerm >> matchOp: aSymbol andArgs: anArgList [
	| match |
	opName = aSymbol
		ifFalse: [ ^ nil ].
	arguments size = anArgList size
		ifFalse: [ ^ nil ].
	match := LbSubstitution new.
	anArgList with: arguments do:
		[ :patternArg :valueArg |
		  | argMatch |
			argMatch := patternArg match: valueArg.
			argMatch ifNil: [ ^ nil ].
			match := match combineWith: argMatch.
			match ifNil: [ ^ nil ] ].
	^ match
]

{ #category : #accessing }
LbOpTerm >> opName [
	^ opName
]

{ #category : #printing }
LbOpTerm >> printAsLeibnizSyntaxOn: aStream [
	opName printForArity: arguments on: aStream
]

{ #category : #accessing }
LbOpTerm >> sort [
	^sort
]

{ #category : #substituting }
LbOpTerm >> substitute: aSubstitution [
	| substitutedArgList |
	substitutedArgList := arguments collect: [ :arg | arg substitute: aSubstitution ].
	^ signature nonZeroArgTermNamed: opName withArgs: substitutedArgList

]

{ #category : #accessing }
LbOpTerm >> variables [
	^ arguments inject: Dictionary new into: [ :total :each | total union: each variables ]
]

{ #category : #transforming }
LbOpTerm >> withTransformedArgs: transformer [
	^ signature nonZeroArgTermNamed: opName withArgs: (arguments collect: transformer)
]
