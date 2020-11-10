"
I represent a context term in context 'contexts'
"
Class {
	#name : #LbContextTerm,
	#superclass : #LbAtomicTerm,
	#category : #'Leibniz-3-Terms'
}

{ #category : #private }
LbContextTerm class >> requiredBuiltin [
	^ #contexts
]

{ #category : #accessing }
LbContextTerm >> sortSymbol [
	^ #context
]
