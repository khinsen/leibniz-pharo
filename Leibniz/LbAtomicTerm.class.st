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

{ #category : #private }
LbAtomicTerm class >> requiredBuiltin [
	self subclassResponsibility
]

{ #category : #'instance creation' }
LbAtomicTerm class >> value: aString signature: aSignature [
	aSignature assertBuiltin: self requiredBuiltin.
	^ self basicNew
			initializeWithValue: aString signature: aSignature;
			yourself
]

{ #category : #converting }
LbAtomicTerm >> convertToSignature: aSignature extraVariables: aDictionary [
	^ self class value: value signature: aSignature
]

{ #category : #classifying }
LbAtomicTerm >> headOpName [
	^ LbPseudoOperatorName for: #'Built-in'
]

{ #category : #initialization }
LbAtomicTerm >> initializeWithValue: aString signature: aSignature [
	signature := aSignature.
	value := aString
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
	^ self signature sortNamed: self sortSymbol
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
