"
I represent atomic terms, such as numbers and strings.
"
Class {
	#name : #LbAtomicTerm,
	#superclass : #LbTerm,
	#instVars : [
		'value'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LbAtomicTerm class >> value: aString forSignature: aSignature [
	^self basicNew
			initializeWithValue: aString forSignature: aSignature;
			yourself

]

{ #category : #converting }
LbAtomicTerm >> convertToSignature: aSignature extraVariables: aDictionary [
	^ self class value: value forSignature: aSignature
]

{ #category : #initialization }
LbAtomicTerm >> initializeWithValue: aString forSignature: aSignature [
	signature := aSignature.
	value := aString.

]

{ #category : #accessing }
LbAtomicTerm >> leibnizAtomicTermValue [
	^ value
]

{ #category : #printing }
LbAtomicTerm >> printAsLeibnizSyntaxOn: aStream [
	value printOn: aStream

]

{ #category : #accessing }
LbAtomicTerm >> sort [
	^ self signature sortGraph sortNamed: self sortSymbol
]

{ #category : #accessing }
LbAtomicTerm >> sortSymbol [
	self subclassResponsibility
]

{ #category : #substituting }
LbAtomicTerm >> substitute: aSubstitution [
	^self
]

{ #category : #accessing }
LbAtomicTerm >> value [
	^ value
]

{ #category : #accessing }
LbAtomicTerm >> variables [
	^ Dictionary new
]
