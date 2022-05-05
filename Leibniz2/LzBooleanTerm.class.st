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
						ifTrue: [ LzConstants opNameTrue ]
						ifFalse: [ LzConstants opNameFalse ]).
	^ aSignature opTerm: opName args: #()
]
