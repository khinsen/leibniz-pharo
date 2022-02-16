Class {
	#name : #LzStringTerm,
	#superclass : #LzAtomicTerm,
	#category : #'Leibniz2-Terms'
}

{ #category : #accessing }
LzStringTerm >> sort [
	^ self signature sort: #string
]
