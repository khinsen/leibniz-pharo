"
I represent a Leibniz variable.
"
Class {
	#name : #LbVarTerm,
	#superclass : #LbTerm,
	#instVars : [
		'sort',
		'name'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LbVarTerm class >> name: anOpName sort: aSort signature: aSignature [
	^ self basicNew
		initializeWithName: anOpName
		sort: aSort
		signature: aSignature;
		yourself
]

{ #category : #matching }
LbVarTerm >> assertNotAVariable [
	Error signal: 'No variables allowed in matching terms'
]

{ #category : #converting }
LbVarTerm >> convertToSignature: aSignature extraVariables: aDictionary [
	| vars |
	vars := aDictionary collect: [ :eachSort | aSignature sortNamed: eachSort name ].
	^ aSignature zeroArgTermNamed: name extraVariables: vars
]

{ #category : #testing }
LbVarTerm >> hasVariables [
	^ true
]

{ #category : #accessing }
LbVarTerm >> headOpName [
	^ LbPseudoOperatorName for: #Variable
]

{ #category : #initialization }
LbVarTerm >> initializeWithName: aSymbol sort: aSort signature: aSignature [
	name := aSymbol.
	sort := aSort.
	signature := aSignature
]

{ #category : #testing }
LbVarTerm >> isVariable [
	^ true
]

{ #category : #matching }
LbVarTerm >> match: otherTerm [
	otherTerm assertNotAVariable.
	otherTerm sort <= sort
		ifTrue: [ ^ LbSubstitution variable: name value: otherTerm ]
		ifFalse: [ ^ LbSubstitution null ]
]

{ #category : #accessing }
LbVarTerm >> name [
	^ name
]

{ #category : #printing }
LbVarTerm >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: name internalSymbol asString
]

{ #category : #accessing }
LbVarTerm >> sort [
	^sort
]

{ #category : #substituting }
LbVarTerm >> substitute: aSubstitution [
	aSubstitution variables at: name ifPresent: [ :value | ^ value ].
	^ self
]

{ #category : #matching }
LbVarTerm >> unifyWith: otherTerm variables: variables [
	otherTerm unifyWithVar: name ofSort: sort variables: variables
]

{ #category : #matching }
LbVarTerm >> unifyWithOpTerm: otherTerm op: anOpName args: anArgList variables: variables [
	otherTerm unifyWithVar: name ofSort: sort variables: variables
]

{ #category : #matching }
LbVarTerm >> unifyWithVar: aSymbol ofSort: aSort variables: anLbVariables [
	anLbVariables makeVar: name ofSort: sort equalToVar: aSymbol ofSort: aSort
]

{ #category : #accessing }
LbVarTerm >> variables [
	^ Dictionary with: name -> sort

]
