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
	^ aSignature zeroArgTermNamed: name extraVariables: aDictionary
]

{ #category : #initialization }
LbVarTerm >> initializeWithName: aSymbol sort: aSort signature: aSignature [
	name := aSymbol.
	sort := aSort.
	signature := aSignature
]

{ #category : #matching }
LbVarTerm >> match: otherTerm [
	otherTerm assertNotAVariable.
	(signature sortGraph is: otherTerm sort subsortOf: sort)
		ifTrue: [ ^ LbSubstitution variable: name value: otherTerm ]
		ifFalse: [ ^ nil ]

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

{ #category : #accessing }
LbVarTerm >> variables [
	^ Dictionary with: name -> sort

]
