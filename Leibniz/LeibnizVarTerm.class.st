"
I represent a Leibniz variable.
"
Class {
	#name : #LeibnizVarTerm,
	#superclass : #LeibnizTerm,
	#instVars : [
		'varSymbol',
		'sort'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LeibnizVarTerm class >> symbol: aSymbol sort: aSort forSignature: aSignature [
	^self basicNew
			initializeWithSymbol: aSymbol sort: aSort forSignature: aSignature;
			yourself.

]

{ #category : #matching }
LeibnizVarTerm >> assertNotAVariable [
	Error signal: 'No variables allowed in matching terms'
]

{ #category : #converting }
LeibnizVarTerm >> convertToSignature: aSignature extraVariables: aDictionary [
	^ aSignature zeroArgTermNamed: varSymbol extraVariables: aDictionary
]

{ #category : #initialization }
LeibnizVarTerm >> initializeWithSymbol: aSymbol sort: aSort forSignature: aSignature [
	varSymbol := aSymbol.
	sort := aSort.
	signature := aSignature.

]

{ #category : #matching }
LeibnizVarTerm >> match: otherTerm [
	otherTerm assertNotAVariable.
	(signature sortGraph is: otherTerm sort subsortOf: sort)
		ifTrue: [ ^ LeibnizSubstitution variable: varSymbol value: otherTerm ]
		ifFalse: [ ^ nil ]

]

{ #category : #printing }
LeibnizVarTerm >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPutAll: varSymbol asString
]

{ #category : #accessing }
LeibnizVarTerm >> sort [
	^sort
]

{ #category : #substituting }
LeibnizVarTerm >> substitute: aSubstitution [
	aSubstitution variables at: varSymbol ifPresent: [ :value | ^ value ].
	^ self

]

{ #category : #accessing }
LeibnizVarTerm >> variables [
	^ Dictionary with: varSymbol -> sort

]
