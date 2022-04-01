Class {
	#name : #LzBooleanTerm,
	#superclass : #LzAtomicTerm,
	#category : #'Leibniz2-Terms'
}

{ #category : #'instance creation' }
LzBooleanTerm class >> signature: aSignature value: aBoolean [
	| opName |
	opName := LzPrefixOpName for:
					(aBoolean
						ifTrue: [ '⊤' ]
						ifFalse: [ '⊥' ]).
	^ aSignature opTerm: opName args: #()
]
