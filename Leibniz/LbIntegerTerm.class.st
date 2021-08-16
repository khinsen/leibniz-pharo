"
I represent an integer in context 'integers'.
"
Class {
	#name : 'LbIntegerTerm',
	#superclass : 'LbRationalNumberTerm',
	#category : 'Leibniz-3-Terms'
}

{ #category : 'private' }
LbIntegerTerm class >> requiredBuiltin [
	^ #integers
]

{ #category : 'instance creation' }
LbIntegerTerm class >> value: aNumber signature: aSignature [
	aSignature assertBuiltin: self requiredBuiltin.
	^ self basicNew
			initializeWithValue: aNumber signature: aSignature;
			yourself
]

{ #category : 'acccessing' }
LbIntegerTerm >> sortSymbol [
	value = 0
		ifTrue: [ ^ #zero ].
	value positive
		ifTrue: [ ^ #'ℕ.nz' ]
		ifFalse: [ ^ #'ℤ.nz' ]
]
