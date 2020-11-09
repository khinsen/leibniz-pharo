"
I represent an integer in context 'integers'.
"
Class {
	#name : #LbIntegerTerm,
	#superclass : #LbRationalNumberTerm,
	#category : #'Leibniz-3-Terms'
}

{ #category : #'instance creation' }
LbIntegerTerm class >> value: aNumber forSignature: aSignature [
	^self basicNew
			initializeWithValue: aNumber forSignature: aSignature;
			yourself
]

{ #category : #acccessing }
LbIntegerTerm >> sortSymbol [
	value = 0
		ifTrue: [ ^ #zero ].
	value positive
		ifTrue: [ ^ #'ℕ.nz' ]
		ifFalse: [ ^ #'ℤ.nz' ]
]
