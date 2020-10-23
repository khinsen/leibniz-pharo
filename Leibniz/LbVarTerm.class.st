"
I represent a Leibniz variable.
"
Class {
	#name : #LbVarTerm,
	#superclass : #LbTerm,
	#instVars : [
		'varSymbol',
		'sort'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LbVarTerm class >> symbol: aSymbol sort: aSort forSignature: aSignature [
	^self basicNew
			initializeWithSymbol: aSymbol sort: aSort forSignature: aSignature;
			yourself.

]

{ #category : #matching }
LbVarTerm >> assertNotAVariable [
	Error signal: 'No variables allowed in matching terms'
]

{ #category : #converting }
LbVarTerm >> convertToSignature: aSignature extraVariables: aDictionary [
	^ aSignature zeroArgTermNamed: varSymbol extraVariables: aDictionary
]

{ #category : #initialization }
LbVarTerm >> initializeWithSymbol: aSymbol sort: aSort forSignature: aSignature [
	varSymbol := aSymbol.
	sort := aSort.
	signature := aSignature.

]

{ #category : #matching }
LbVarTerm >> match: otherTerm [
	otherTerm assertNotAVariable.
	(signature sortGraph is: otherTerm sort subsortOf: sort)
		ifTrue: [ ^ LbSubstitution variable: varSymbol value: otherTerm ]
		ifFalse: [ ^ nil ]

]

{ #category : #printing }
LbVarTerm >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: varSymbol asString
]

{ #category : #accessing }
LbVarTerm >> sort [
	^sort
]

{ #category : #substituting }
LbVarTerm >> substitute: aSubstitution [
	aSubstitution variables at: varSymbol ifPresent: [ :value | ^ value ].
	^ self

]

{ #category : #accessing }
LbVarTerm >> variables [
	^ Dictionary with: varSymbol -> sort

]
