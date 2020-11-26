"
I represent a double-precision float in context 'IEEE-floating-point'.
"
Class {
	#name : #LbFPNumberTerm,
	#superclass : #LbAtomicTerm,
	#category : #'Leibniz-3-Terms'
}

{ #category : #private }
LbFPNumberTerm class >> requiredBuiltin [
	^ #fpNumbers
]

{ #category : #accessing }
LbFPNumberTerm >> sortSymbol [
	value isNaN ifTrue: [ ^ #'FP64.NaN' ].
	value isInfinite ifTrue: [ ^ #'FP64.inf' ].
	^ #'FP64.number'
]
