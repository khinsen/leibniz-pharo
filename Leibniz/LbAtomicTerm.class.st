"
I represent atomic terms, such as numbers and strings.
"
Class {
	#name : #LbAtomicTerm,
	#superclass : #LbTerm,
	#instVars : [
		'value'
	],
	#category : 'Leibniz-3-Terms'
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

{ #category : #testing }
LbAtomicTerm >> hasVariables [
	^ false
]

{ #category : #classifying }
LbAtomicTerm >> headOpName [
	^ LbPseudoOperatorName for: #Atomic
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

{ #category : #matching }
LbAtomicTerm >> unifyTagged: aSymbol with: otherTerm tagged: anotherSymbol variables: variables [
	otherTerm
		unifyTagged: anotherSymbol
		withAtomicTerm: self
		tagged: aSymbol
		variables: variables.
]

{ #category : #matching }
LbAtomicTerm >> unifyTagged: aSymbol withAtomicTerm: otherTerm tagged: anotherSymbol variables: variables [
	self = otherTerm
		ifFalse: [ variables failWith: self notUnifiableWith: otherTerm ]
]

{ #category : #accessing }
LbAtomicTerm >> value [
	^ value
]

{ #category : #accessing }
LbAtomicTerm >> variables [
	^ Dictionary new
]
