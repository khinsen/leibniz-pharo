"
I represent a string in context 'strings'.
"
Class {
	#name : #LbStringTerm,
	#superclass : #LbAtomicTerm,
	#category : #'Leibniz-3-Terms'
}

{ #category : #private }
LbStringTerm class >> requiredBuiltin [
	^ #strings
]

{ #category : #accessing }
LbStringTerm >> headOpName [
	^ LbPseudoOperatorName for: #String
]

{ #category : #printing }
LbStringTerm >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPut: $".
	aStream nextPutAll: value.
	aStream nextPut: $".

]

{ #category : #accessing }
LbStringTerm >> sortSymbol [
	^ #string
]
