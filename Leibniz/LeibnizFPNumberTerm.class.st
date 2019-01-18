"
I represent a double-precision float in context 'IEEE-floating-point'.
"
Class {
	#name : #LeibnizFPNumberTerm,
	#superclass : #LeibnizAtomicTerm,
	#instVars : [
		'value'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #accessing }
LeibnizFPNumberTerm >> sort [
	value isNaN ifTrue: [ ^#'FP64-NaN' ].
	value isInfinite ifTrue: [ ^#'FP64-inf' ].
	^#'FP64-number'

]
