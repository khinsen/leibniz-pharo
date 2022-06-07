Class {
	#name : #LzStringTerm,
	#superclass : #LzAtomicTerm,
	#category : #'Leibniz2-Terms'
}

{ #category : #rewriting }
LzStringTerm >> , otherString [
	^ self class
		signature: self signature
		value: self value , otherString value
]

{ #category : #rewriting }
LzStringTerm >> ensureString [
]

{ #category : #accessing }
LzStringTerm >> sort [
	^ self signature sort: #string
]
