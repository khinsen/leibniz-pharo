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
LbOpTerm class >> name: anOpName args: anArgList sort: aSort signature: aSignature [
	^self basicNew
			initializeWithName: anOpName args: anArgList sort: aSort signature: aSignature;
			yourself
]

{ #category : #accessing }
LbOpTerm >> arguments [
	^ arguments
]

{ #category : #converting }
LbOpTerm >> convertToSignature: aSignature extraVariables: aDictionary [
	| vars |
	vars := aDictionary collect: [ :eachSort | aSignature sortNamed: eachSort name ].
	^ arguments
		ifEmpty: [
			aSignature zeroArgTermNamed: opName extraVariables: vars ]
		ifNotEmpty: [
			aSignature
				nonZeroArgTermNamed: opName
				withArgs: (arguments collect: [ :each |
					each convertToSignature: aSignature  extraVariables: aDictionary ] ) ]
]

{ #category : #testing }
LbOpTerm >> evaluateEqualityTerm [
	opName isEqualityOp ifFalse: [ ^ nil ].
	arguments size == 2 ifFalse: [ ^ nil ].
	sort name = #boolean ifFalse: [ ^ nil ].
	^ arguments first = arguments second
]

{ #category : #private }
LbOpTerm >> hasInfixOpOtherThan: anOpName [
	^ opName isInfixOpOtherThan: anOpName
]

{ #category : #testing }
LbOpTerm >> hasVariables [
	^ arguments
		detect: [ :each | each hasVariables ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #classifying }
LbOpTerm >> headOpName [
	^ opName
]

{ #category : #initialization }
LbOpTerm >> initializeWithName: anOpName args: anArgList sort: aSort signature: aSignature [
	opName := anOpName.
	arguments := anArgList.
	sort := aSort.
	signature := aSignature.
]

{ #category : #testing }
LbOpTerm >> isInfix [
	^ opName isInfix
]

{ #category : #testing }
LbOpTerm >> isTrue [
	^ (sort name = #boolean)
		and: [ (opName asSymbol = #true)
		and: [ arguments isEmpty ] ]
]

{ #category : #matching }
LbOpTerm >> match: otherTerm [
	^ otherTerm matchOp: opName andArgs: arguments
]

{ #category : #matching }
LbOpTerm >> matchOp: anOpName andArgs: anArgList [
	| match |
	opName = anOpName
		ifFalse: [ ^ LbSubstitution null ].
	arguments size = anArgList size
		ifFalse: [ ^ LbSubstitution null ].
	match := LbSubstitution new.
	anArgList with: arguments do: [ :patternArg :valueArg |
		match combineWith: (patternArg match: valueArg) ].
	^ match
]

{ #category : #accessing }
LbOpTerm >> opName [
	^ opName
]

{ #category : #printing }
LbOpTerm >> printAsLeibnizSyntaxOn: aStream [
	opName printForArgs: arguments on: aStream
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

{ #category : #inspecting }
LbOpTerm >> synopsis [
	^ self opName synopsis
]

{ #category : #matching }
LbOpTerm >> unifyWith: otherTerm variables: variables [
	otherTerm unifyWithOpTerm: self op: opName args: arguments variables: variables
]

{ #category : #matching }
LbOpTerm >> unifyWithOpTerm: otherTerm op: anOpName args: anArgList variables: variables [
	(opName = anOpName and: [ arguments size = anArgList size ])
		ifFalse: [ variables failWith: self notEqualTo: otherTerm ].
	anArgList with: arguments do: [ :arg1 :arg2 |
		arg1 unifyWith: arg2 variables: variables ]
]

{ #category : #accessing }
LbOpTerm >> variables [
	^ arguments inject: Dictionary new into: [ :total :each | total union: each variables ]
]

{ #category : #transforming }
LbOpTerm >> withTransformedArgs: anArgList [
	^ signature nonZeroArgTermNamed: opName withArgs: anArgList
]
